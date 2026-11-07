import "dart:io";

import "package:path/path.dart" as path;

Future<void> main(List<String> arguments) async {
  try {
    await _build(arguments);
  } on FormatException catch (error) {
    stderr.writeln("${error.message}\n\n$_usage");
    exitCode = 64;
  } on ProcessException catch (error) {
    stderr.writeln("Unable to run Cargo: $error");
    stderr.writeln("Install rustup and add its bin directory to PATH.");
    exitCode = 69;
  } on FileSystemException catch (error) {
    stderr.writeln("Unable to stage the native library: $error");
    exitCode = 74;
  }
}

Future<void> _build(List<String> arguments) async {
  if (arguments.contains("--help") || arguments.contains("-h")) {
    stdout.writeln(_usage);
    return;
  }

  final options = _BuildOptions.parse(arguments);
  final projectRoot = File.fromUri(Platform.script).parent.parent.path;
  final manifest = path.join(projectRoot, "rust", "Cargo.toml");
  if (!File(manifest).existsSync()) {
    stderr.writeln("Rust workspace not found beside this tool: $manifest");
    exitCode = 64;
    return;
  }

  final cargo = options.cargo ?? "cargo";
  final android = options.platform.startsWith("android-");
  final ndk = android ? _androidNdk(options.ndk) : null;
  final hostTag = Platform.isWindows
      ? "windows-x86_64"
      : Platform.isMacOS
      ? "darwin-x86_64"
      : "linux-x86_64";
  final clang = ndk == null
      ? null
      : path.join(
          ndk,
          "toolchains",
          "llvm",
          "prebuilt",
          hostTag,
          "bin",
          Platform.isWindows ? "clang.exe" : "clang",
        );
  if (clang != null && !File(clang).existsSync()) {
    throw FormatException("Android NDK Clang not found: $clang");
  }
  // Use one known artifact location even when CARGO_TARGET_DIR is set.
  final targetDirectory = path.join(projectRoot, "rust", "target");
  final command = <String>[
    android ? "rustc" : "build",
    "--locked",
    "--manifest-path",
    manifest,
    "--target-dir",
    targetDirectory,
    "-p",
    "rhodanthe-bridge",
    if (android) "--lib",
    if (options.release) "--release",
    if (options.target != null) ...<String>["--target", options.target!],
    if (android) ...<String>[
      // Apply these to the final bridge without overriding the caller's
      // RUSTFLAGS or trying to execute Windows NDK .cmd linker wrappers.
      "--",
      "-C",
      "linker=$clang",
      "-C",
      "link-arg=--target=${options.androidClangTarget}${options.androidApi}",
      "-C",
      "link-arg=-Wl,-z,max-page-size=16384",
      "-C",
      "link-arg=-Wl,-z,common-page-size=16384",
    ],
  ];
  stdout.writeln("$cargo ${command.join(' ')}");
  if (options.dryRun) {
    stdout.writeln("Stage in: ${options.outputDirectory(projectRoot)}");
    return;
  }
  final result = await Process.run(
    cargo,
    command,
    workingDirectory: path.join(projectRoot, "rust"),
    runInShell: Platform.isWindows,
  );
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    exitCode = result.exitCode;
    return;
  }

  final profile = options.release ? "release" : "debug";
  final artifact = path.joinAll(<String>[
    projectRoot,
    "rust",
    "target",
    if (options.target != null) options.target!,
    profile,
    options.artifactName,
  ]);
  final source = File(artifact);
  if (!source.existsSync()) {
    stderr.writeln("Cargo succeeded but $artifact was not produced.");
    exitCode = 66;
    return;
  }

  final outputDirectory = Directory(options.outputDirectory(projectRoot))
    ..createSync(recursive: true);
  final destination = path.join(outputDirectory.path, options.artifactName);
  await source.copy(destination);
  stdout.writeln("Staged Rhodanthe native library: $destination");
}

final class _BuildOptions {
  final String platform;
  final String? target;
  final String? cargo;
  final String? output;
  final String? ndk;
  final int androidApi;
  final bool release;
  final bool dryRun;

  const _BuildOptions({
    required this.platform,
    required this.target,
    required this.cargo,
    required this.output,
    required this.ndk,
    required this.androidApi,
    required this.release,
    required this.dryRun,
  });

  factory _BuildOptions.parse(List<String> arguments) {
    final values = <String, String>{};
    final flags = <String>{};
    for (var index = 0; index < arguments.length; index++) {
      final option = arguments[index];
      if (option == "--debug" || option == "--dry-run") {
        flags.add(option);
        continue;
      }
      if (!const <String>{
        "--platform",
        "--target",
        "--cargo",
        "--out",
        "--ndk",
        "--android-api",
      }.contains(option)) {
        throw FormatException("Unknown option: $option");
      }
      if (values.containsKey(option)) {
        throw FormatException("Duplicate option: $option");
      }
      if (index + 1 >= arguments.length ||
          arguments[index + 1].startsWith("--") ||
          arguments[index + 1].trim().isEmpty) {
        throw FormatException("$option requires a value");
      }
      values[option] = arguments[++index];
    }

    final platform = values["--platform"] ?? _hostPlatform;
    final known = _platforms[platform];
    if (known == null) {
      throw FormatException("Unsupported platform $platform");
    }
    final android = platform.startsWith("android-");
    final androidApi = int.tryParse(values["--android-api"] ?? "21");
    if (androidApi == null || androidApi < 21) {
      throw const FormatException("--android-api must be an integer >= 21");
    }
    if (!android &&
        (values.containsKey("--ndk") || values.containsKey("--android-api"))) {
      throw const FormatException("--ndk and --android-api require Android");
    }
    if (android &&
        values["--target"] != null &&
        values["--target"] != known.target) {
      throw FormatException("$platform requires Rust target ${known.target}");
    }
    if (known.target == null &&
        platform != _hostPlatform &&
        values["--target"] == null) {
      throw FormatException(
        "Building $platform on $_hostPlatform requires an explicit --target "
        "and a configured cross-linker",
      );
    }
    return _BuildOptions(
      platform: platform,
      target: values["--target"] ?? known.target,
      cargo: values["--cargo"],
      output: values["--out"],
      ndk: values["--ndk"],
      androidApi: androidApi,
      release: !flags.contains("--debug"),
      dryRun: flags.contains("--dry-run"),
    );
  }

  _PlatformBuild get _build => _platforms[platform]!;

  String get artifactName => _build.artifactName;

  String get androidClangTarget => switch (platform) {
    "android-arm" => "armv7a-linux-androideabi",
    _ => target!,
  };

  String outputDirectory(String root) {
    if (output != null) return path.absolute(output!);
    return switch (platform) {
      "android-arm64" => path.join(
        root,
        "build",
        "rhodanthe",
        platform,
        "jniLibs",
        "arm64-v8a",
      ),
      "android-arm" => path.join(
        root,
        "build",
        "rhodanthe",
        platform,
        "jniLibs",
        "armeabi-v7a",
      ),
      "android-x64" => path.join(
        root,
        "build",
        "rhodanthe",
        platform,
        "jniLibs",
        "x86_64",
      ),
      "ios-arm64" ||
      "ios-simulator" => path.join(root, "build", "rhodanthe", platform),
      _ => path.join(root, "build", "rhodanthe", platform),
    };
  }
}

String _androidNdk(String? explicit) {
  final directory =
      explicit ??
      Platform.environment["ANDROID_NDK_HOME"] ??
      Platform.environment["ANDROID_NDK_ROOT"];
  if (directory == null || directory.trim().isEmpty) {
    throw const FormatException(
      "Android builds require --ndk <directory> or ANDROID_NDK_HOME. "
      "Flutter/Gradle builds select the configured NDK automatically.",
    );
  }
  return path.absolute(directory);
}

final class _PlatformBuild {
  final String? target;
  final String artifactName;

  const _PlatformBuild(this.target, this.artifactName);
}

String get _hostPlatform {
  if (Platform.isWindows) return "windows";
  if (Platform.isLinux) return "linux";
  if (Platform.isMacOS) return "macos";
  throw UnsupportedError("This host platform cannot build Rhodanthe");
}

const Map<String, _PlatformBuild> _platforms = <String, _PlatformBuild>{
  "windows": _PlatformBuild(null, "rhodanthe_bridge.dll"),
  "linux": _PlatformBuild(null, "librhodanthe_bridge.so"),
  "macos": _PlatformBuild(null, "librhodanthe_bridge.dylib"),
  "android-arm64": _PlatformBuild(
    "aarch64-linux-android",
    "librhodanthe_bridge.so",
  ),
  "android-arm": _PlatformBuild(
    "armv7-linux-androideabi",
    "librhodanthe_bridge.so",
  ),
  "android-x64": _PlatformBuild(
    "x86_64-linux-android",
    "librhodanthe_bridge.so",
  ),
  "ios-arm64": _PlatformBuild("aarch64-apple-ios", "librhodanthe_bridge.a"),
  "ios-simulator": _PlatformBuild(
    "aarch64-apple-ios-sim",
    "librhodanthe_bridge.a",
  ),
};

const String _usage = """
Build and stage the MonoAshi Rhodanthe native bridge.

dart --disable-dart-dev tool/build_rhodanthe_native.dart [options]

  --platform <windows|linux|macos|android-arm64|android-arm|android-x64|ios-arm64|ios-simulator>
  --target <rust-target>   Override the platform's Rust target.
  --cargo <path>          Override the Cargo executable.
  --out <directory>       Override the staging directory.
  --ndk <directory>       Android NDK root (or set ANDROID_NDK_HOME).
  --android-api <level>   Android minimum API level, >= 21 (default: 21).
  --debug                 Build the debug profile instead of release.
  --dry-run               Print the build and staging plan without running Cargo.

Uses the workspace's rust-toolchain.toml and Cargo.lock. Output is built under
rust/target regardless of CARGO_TARGET_DIR. Relative --out paths use the caller's
working directory. Desktop cross-builds require --target and a cross-linker.

Android cross-builds select NDK Clang and enable 16 KB ELF page alignment.
Run this pure Dart tool directly with --disable-dart-dev to avoid package build
hooks rewriting Flutter's Release plugin registrant with test-only plugins.
Install the platform's Rust target with rustup target add before building.
Apple static libraries must be linked by the Xcode target so DynamicLibrary.process() can
resolve the exported C ABI.
""";
