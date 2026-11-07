allprojects {
    // Kotlin's incremental path converter cannot relativize plugin sources on
    // another Windows drive (for example C: Pub cache and an E: checkout).
    // Keep incremental compilation for the app and projects on the same drive.
    if (System.getProperty("os.name").startsWith("Windows") &&
        projectDir.toPath().root != rootProject.projectDir.toPath().root
    ) {
        extensions.extraProperties.set("kotlin.incremental", "false")
    }

    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
