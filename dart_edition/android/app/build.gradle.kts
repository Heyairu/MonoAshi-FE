import org.gradle.api.file.ConfigurableFileCollection
import org.gradle.api.file.DirectoryProperty
import org.gradle.api.provider.ListProperty
import org.gradle.api.provider.Property
import org.gradle.process.ExecOperations
import javax.inject.Inject
import java.util.Properties
import groovy.json.JsonSlurper
import org.gradle.api.file.RegularFileProperty

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.heyairu.monogatari_assistant_fe"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // Flutter commands share this mutable file across build modes. Compile a
    // metadata-derived, variant-owned registrant instead (see onVariants below).
    sourceSets.getByName("main").java.exclude("io/flutter/plugins/GeneratedPluginRegistrant.java")

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.heyairu.monogatari_assistant_fe"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Register generated JNI sources so AGP builds Rust before merging native
// libraries, for APKs, app bundles, split ABIs, and flutter run alike.
val rhodantheRoot = layout.projectDirectory.dir("../..")
val localProperties = Properties().apply {
    rootProject.file("local.properties").inputStream().use { load(it) }
}
val isWindowsHost = System.getProperty("os.name").startsWith("Windows")
val dartExecutable = file(
    "${localProperties.getProperty("flutter.sdk")}/bin/cache/dart-sdk/bin/" +
        if (isWindowsHost) "dart.exe" else "dart"
)
val cargoExecutable = providers.environmentVariable("CARGO_BIN").orElse(
    providers.environmentVariable("CARGO_HOME").map {
        "$it/bin/" + if (isWindowsHost) "cargo.exe" else "cargo"
    }
).getOrElse(
    File(System.getProperty("user.home"), ".cargo/bin/" +
        if (isWindowsHost) "cargo.exe" else "cargo").let {
        if (it.isFile) it.absolutePath else "cargo"
    }
)
val nativeEnabled = providers.gradleProperty("rhodantheNative").orElse("true")
val pluginMetadata = rhodantheRoot.file(".flutter-plugins-dependencies")

androidComponents {
    onVariants { variant ->
        val registrantTask = tasks.register<AndroidPluginRegistrantBuild>(
            "generate${variant.name.replaceFirstChar { it.uppercase() }}PluginRegistrant"
        ) {
            projectDirectory.set(rhodantheRoot)
            dartPath.set(dartExecutable.absolutePath)
            mode.set(variant.buildType ?: "debug")
            metadata.set(pluginMetadata)
            generator.set(rhodantheRoot.file("tool/generate_android_plugin_registrant.dart"))
            pluginManifests.from(providers.provider {
                val resolved = JsonSlurper().parse(pluginMetadata.asFile) as Map<*, *>
                val plugins = resolved["plugins"] as Map<*, *>
                (plugins["android"] as List<*>).map {
                    val plugin = it as Map<*, *>
                    File(plugin["path"] as String, "pubspec.yaml")
                }
            })
        }
        variant.sources.java?.addGeneratedSourceDirectory(registrantTask) { it.outputDirectory }

        if (nativeEnabled.get().toBoolean()) {
            val nativeTask = tasks.register<RhodantheAndroidBuild>(
                "buildRhodanthe${variant.name.replaceFirstChar { it.uppercase() }}"
            ) {
                projectDirectory.set(rhodantheRoot)
                dartPath.set(dartExecutable.absolutePath)
                cargoPath.set(cargoExecutable)
                ndkPath.set(sdkComponents.ndkDirectory.map { it.asFile.absolutePath })
                platforms.set(providers.gradleProperty("target-platform").orElse(
                    "android-arm,android-arm64,android-x64"
                ).map { it.split(",") })
                apiLevel.set(variant.minSdk.apiLevel)
                release.set(variant.buildType != "debug")
                sourceFiles.from(fileTree(rhodantheRoot.dir("rust")) {
                    include("**/*.rs", "**/Cargo.toml", "Cargo.lock", "rust-toolchain.toml")
                    exclude("target/**")
                })
                sourceFiles.from(rhodantheRoot.file("tool/build_rhodanthe_native.dart"))
            }
            // AGP assigns this task a variant-specific generated JNI directory.
            variant.sources.jniLibs?.addGeneratedSourceDirectory(nativeTask) { it.outputDirectory }
        }
    }
}

abstract class AndroidPluginRegistrantBuild @Inject constructor(
    private val execOperations: ExecOperations
) : DefaultTask() {
    @get:Internal abstract val projectDirectory: DirectoryProperty
    @get:Input abstract val dartPath: Property<String>
    @get:Input abstract val mode: Property<String>
    @get:InputFile abstract val metadata: RegularFileProperty
    @get:InputFile abstract val generator: RegularFileProperty
    @get:InputFiles @get:PathSensitive(PathSensitivity.RELATIVE)
    abstract val pluginManifests: ConfigurableFileCollection
    @get:OutputDirectory abstract val outputDirectory: DirectoryProperty

    @TaskAction
    fun generate() {
        execOperations.exec {
            workingDir(projectDirectory.get().asFile)
            executable(dartPath.get())
            args(
                "--disable-dart-dev", generator.get().asFile.absolutePath,
                "--metadata", metadata.get().asFile.absolutePath,
                "--mode", mode.get(),
                "--out", outputDirectory.file("io/flutter/plugins/GeneratedPluginRegistrant.java").get().asFile.absolutePath
            )
        }
    }
}

abstract class RhodantheAndroidBuild @Inject constructor(
    private val execOperations: ExecOperations
) : DefaultTask() {
    @get:Internal abstract val projectDirectory: DirectoryProperty
    @get:Input abstract val dartPath: Property<String>
    @get:Input abstract val cargoPath: Property<String>
    @get:Input abstract val ndkPath: Property<String>
    @get:Input abstract val platforms: ListProperty<String>
    @get:Input abstract val apiLevel: Property<Int>
    @get:Input abstract val release: Property<Boolean>
    @get:InputFiles @get:PathSensitive(PathSensitivity.RELATIVE)
    abstract val sourceFiles: ConfigurableFileCollection
    @get:OutputDirectory abstract val outputDirectory: DirectoryProperty

    @TaskAction
    fun buildNative() {
        val abis = mapOf(
            "android-arm" to "armeabi-v7a",
            "android-arm64" to "arm64-v8a",
            "android-x64" to "x86_64"
        )
        val requested = platforms.get().distinct()
        require(requested.isNotEmpty() && requested.all { it in abis }) {
            "Unsupported Rhodanthe Android target-platform: $requested"
        }
        // Remove only our stale library when the requested ABI selection changes.
        val output = outputDirectory.get().asFile
        abis.filterKeys { it !in requested }.values.forEach { abi ->
            output.resolve("$abi/librhodanthe_bridge.so").delete()
        }
        requested.forEach { platform ->
            execOperations.exec {
                workingDir(projectDirectory.get().asFile)
                executable(dartPath.get())
                args(
                    // This pure Dart tool must not run package build hooks:
                    // they regenerate Flutter's registrant with dev plugins,
                    // which are absent from the Release Java classpath.
                    "--disable-dart-dev", "tool/build_rhodanthe_native.dart",
                    "--platform", platform,
                    "--cargo", cargoPath.get(),
                    "--ndk", ndkPath.get(),
                    "--android-api", apiLevel.get().toString(),
                    "--out", output.resolve(abis.getValue(platform)).absolutePath
                )
                if (!release.get()) args("--debug")
            }
        }
    }
}
