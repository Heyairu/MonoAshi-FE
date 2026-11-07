import "dart:io";

import "package:path/path.dart" as path;

/// Exercises the real CLI without downloading Rust or invoking a native linker.
Future<void> main() async {
  final root = File.fromUri(Platform.script).parent.parent;
  final registrant = File(
    path.join(
      root.path,
      "android",
      "app",
      "src",
      "main",
      "java",
      "io",
      "flutter",
      "plugins",
      "GeneratedPluginRegistrant.java",
    ),
  );
  final originalRegistrant = registrant.existsSync()
      ? registrant.readAsStringSync()
      : null;
  final temporary = Directory.systemTemp.createTempSync("rhodanthe-ndk-test-");
  try {
    final host = Platform.isWindows
        ? "windows-x86_64"
        : Platform.isMacOS
        ? "darwin-x86_64"
        : "linux-x86_64";
    final clang = File(
      path.join(
        temporary.path,
        "NDK with spaces",
        "toolchains",
        "llvm",
        "prebuilt",
        host,
        "bin",
        Platform.isWindows ? "clang.exe" : "clang",
      ),
    );
    clang.parent.createSync(recursive: true);
    clang.writeAsStringSync("");
    final ndk = path.join(temporary.path, "NDK with spaces");

    Future<ProcessResult> run(List<String> arguments) async {
      final result = await Process.run(
        Platform.resolvedExecutable,
        [
          "--disable-dart-dev",
          "tool/build_rhodanthe_native.dart",
          ...arguments,
          "--dry-run",
        ],
        workingDirectory: root.path,
        environment: {"ANDROID_NDK_HOME": "", "ANDROID_NDK_ROOT": ""},
      );
      _check(
        !result.stdout.toString().contains("Running build hooks"),
        "Native staging must not invoke package build hooks",
      );
      if (originalRegistrant != null) {
        _check(
          registrant.readAsStringSync() == originalRegistrant,
          "Native staging changed Flutter's plugin registrant",
        );
      }
      return result;
    }

    for (final target in const [
      (
        "android-arm64",
        "aarch64-linux-android",
        "aarch64-linux-android",
        "arm64-v8a",
      ),
      (
        "android-arm",
        "armv7-linux-androideabi",
        "armv7a-linux-androideabi",
        "armeabi-v7a",
      ),
      ("android-x64", "x86_64-linux-android", "x86_64-linux-android", "x86_64"),
    ]) {
      final result = await run([
        "--platform",
        target.$1,
        "--ndk",
        ndk,
        "--android-api",
        "24",
      ]);
      _check(result.exitCode == 0, "${target.$1}: ${result.stderr}");
      final output = result.stdout.toString();
      for (final expected in [
        "cargo rustc --locked",
        "--target ${target.$2}",
        "linker=${clang.path}",
        "--target=${target.$3}24",
        "max-page-size=16384",
        "common-page-size=16384",
        path.join("jniLibs", target.$4),
      ]) {
        _check(output.contains(expected), "Missing $expected in $output");
      }
    }
    for (final arguments in [
      ["--platform", "android-arm64"],
      ["--platform", "android-arm64", "--ndk", temporary.path],
      ["--platform", "android-arm64", "--ndk", ndk, "--android-api", "20"],
      ["--platform", "android-arm64", "--ndk", ndk, "--android-api", "invalid"],
      [
        "--platform",
        "android-arm64",
        "--ndk",
        ndk,
        "--target",
        "x86_64-linux-android",
      ],
      ["--ndk", ndk],
    ]) {
      final result = await run(arguments);
      _check(
        result.exitCode == 64,
        "Expected argument error for $arguments: $result",
      );
    }
    final desktop = await run([]);
    _check(
      desktop.exitCode == 0,
      "Desktop staging regressed: ${desktop.stderr}",
    );
    _check(
      desktop.stdout.toString().contains("cargo build --locked"),
      "Desktop must retain cargo build",
    );
    stdout.writeln(
      "Passed Android ABI, NDK, API, alignment, and desktop CLI checks.",
    );
  } finally {
    // This is the absolute, unique directory returned by createTempSync above.
    temporary.deleteSync(recursive: true);
  }
}

void _check(bool condition, String message) {
  if (!condition) throw StateError(message);
}
