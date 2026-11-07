# Rhodanthe native packaging

## Linux AppImage with Rust FFI

From the repository root:

```sh
sh dart_edition/tool/build_linux_appimage.sh --check
sh dart_edition/tool/build_linux_appimage.sh
```

The AppImage packager requires Cargo and checks the workspace's pinned toolchain
before starting Flutter. It finds Cargo on PATH or under
`${CARGO_HOME:-$HOME/.cargo}/bin`; set `CARGO_BIN` to override its executable.
Set `FLUTTER_BIN` when Flutter is outside PATH. If rustup has just been installed,
`. "$HOME/.cargo/env"` also makes Cargo available to other shell commands.

The script requires the native bridge in the final Flutter bundle and refuses
to package a fallback-only app, including when a cached CMake configuration has
disabled `RHODANTHE_NATIVE`. Normal `flutter build linux` retains the optional
Dart fallback behavior. `ARCH` defaults to the host (`x86_64` or `aarch64`);
changing it to a different host architecture is rejected rather than producing
an incorrectly labelled AppImage.

Full verbose Flutter output is streamed to the terminal and saved in
`build/linux/<x64|arm64>/release/appimage-build.log`. Flutter's exit status is
preserved across logging, so a failed or interrupted build cannot package an
old bundle. Dependency update notices alone are not build failures; inspect the
saved log for the first compiler/linker error or interruption.

Run `sh dart_edition/tool/test_build_linux_appimage.sh` for isolated packaging
regressions without building Flutter or downloading AppImage tools.

## macOS app with Rust FFI

From `dart_edition`, run:

```sh
bash tool/build_macos_rhodanthe.sh
```

When the project disables SwiftPM, the script first removes obsolete top-level
SwiftPM plugin modules from the Release products directory. These modules can
shadow CocoaPods frameworks and cause errors such as `Unable to find module
dependency: 'video_player_avfoundation_objc'`. Cleanup preserves framework
contents, Rust build caches, and previously packaged apps.

The default is a Universal Release app containing both Intel and Apple Silicon
code, including the Rhodanthe library. For separate apps, run:

```sh
bash tool/build_macos_rhodanthe.sh --arch x86_64
bash tool/build_macos_rhodanthe.sh --arch arm64
```

Artifacts are saved separately under `build/macos-dist/universal`,
`build/macos-dist/x86_64`, and `build/macos-dist/arm64`. The script selects the
workspace's pinned Rust toolchain, builds with `Cargo.lock`, embeds the native
library, checks the requested architectures in Runner, Dart AOT, and Rhodanthe,
and verifies the app's ad-hoc signature. Both macOS Rust targets must already be
installed for a Universal build. Xcode and Flutter are also required.

Pass additional Flutter options after `--`, for example
`bash tool/build_macos_rhodanthe.sh -- --build-number=42`.
`FLUTTER_BIN` and `CARGO_BIN` can override executable paths. The script does not
change Flutter's persistent settings; if architecture verification reports an
ARM-only app, check whether `enable-macos-arm64-only` is enabled.

The output is signed for local testing. Public distribution still needs
Developer ID signing and notarization. Run this script again after rebuilding
Flutter so the distributed artifact includes the current Rhodanthe library.

## Android app with Rust FFI

Use JDK 17 with the current Android Gradle configuration.
On Windows, plugins located on another drive (such as a C: Pub cache with an
E: checkout) use non-incremental Kotlin compilation to avoid cross-drive cache
failures. The app and same-drive projects retain incremental compilation.

Normal `flutter run`, `flutter build apk`, and `flutter build appbundle` builds
compile and package Rhodanthe automatically. Gradle uses Flutter's configured
NDK and minimum SDK, and follows `--target-platform` for ARMv7 (`armeabi-v7a`),
ARM64 (`arm64-v8a`), and x64 (`x86_64`). Debug builds use Rust's debug profile;
Profile and Release use release. Libraries live under
`build/app/generated/jniLibs/buildRhodanthe<Variant>`, with separate variant outputs
so a previous build cannot supply the wrong ABI or profile.

Gradle also generates a separate Java plugin registrant per variant from
`.flutter-plugins-dependencies` and each plugin's `pubspec.yaml`, under
`build/app/generated/java/generate<Variant>PluginRegistrant`. Release excludes
development-only plugins such as `integration_test`; Debug and Profile retain
them. The shared `android/app/src/main/java/io/flutter/plugins/GeneratedPluginRegistrant.java`
is excluded from compilation, so a concurrent Flutter command or a later
`flutter pub get` cannot replace Release's registration with Debug's.

Install Rust and the Android targets for the pinned toolchain once, from
`dart_edition/rust`:

```text
rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android
```

Cargo is required by default; a native build failure fails the Android build.
Gradle finds Cargo under `CARGO_HOME/bin`, `~/.cargo/bin`, or PATH. Set
`CARGO_BIN` to override it. To explicitly test the Dart fallback, set
`rhodantheNative=false` in `android/gradle.properties`, or pass
`-PrhodantheNative=false` to Gradle directly. Remove it
before building a native-enabled release.

For manual staging or CI outside Gradle:

```text
dart --disable-dart-dev tool/build_rhodanthe_native.dart --platform android-arm64 --ndk <NDK-directory> --android-api 24
```

`--ndk` defaults to `ANDROID_NDK_HOME` or `ANDROID_NDK_ROOT`; `--android-api`
defaults to 21 and must not exceed the app's minimum SDK. No manual Cargo
linker configuration or cargo-ndk installation is needed. The tool invokes
NDK Clang directly with the ABI/API target, including on Windows, and sets
16 KB ELF alignment for compatibility with both 4 KB and 16 KB Android devices.
See the [NDK build guidance](https://developer.android.com/ndk/guides/other_build_systems)
and [page size requirements](https://developer.android.com/guide/practices/page-sizes).

The helper runs directly in the Dart VM with `--disable-dart-dev`. It must not
invoke package build hooks: those can regenerate Flutter's Release plugin
registrant with `integration_test`, while Gradle correctly excludes that
development-only plugin from the Release classpath.

Run `dart --disable-dart-dev tool/test_build_rhodanthe_native.dart` for isolated CLI regressions,
including preservation of the generated plugin registrant.
With an Android device or emulator connected, verify loading from the APK,
ABI handshake, worker isolate, UTF-16 search, and document cleanup with:

```text
flutter test integration_test/rhodanthe_android_ffi_test.dart -d <device-id>
```

This test requires the native bridge and fails if it cannot load it; it does
not silently accept the Dart fallback. CI builds an APK for all three ABIs
in both Debug and Release, repeats each build after regenerating the shared
Debug registrant, and checks the packaged libraries' exported symbols and ELF
alignment. Run `flutter test test/android_plugin_registrant_test.dart` for the
isolated registration regressions.

## Other platforms and library staging

Windows and Linux Flutter CMake builds automatically run Cargo when it is
available, then install the resulting bridge next to the executable (Windows)
or into `bundle/lib` (Linux). Configure with
`-DRHODANTHE_NATIVE=OFF` when intentionally testing the Dart fallback.

The portable staging command is:

```text
dart --disable-dart-dev tool/build_rhodanthe_native.dart --platform windows
```

Run the example on Windows. The default platform is the current desktop host;
desktop cross-builds require an explicit `--target` and a configured linker.
Add `--dry-run` to inspect the build and staging paths without invoking Cargo.
The tool runs inside the Rust workspace to select its pinned toolchain, uses
`--locked`, and explicitly places Cargo output in `rust/target`. See the
[implementation and toolchain plan](IMPLEMENTATION_PLAN.md) for setup and CI.

It supports Windows, Linux, macOS, Android arm64/arm/x64, and iOS device or
arm64 simulator Rust targets. Cross targets still require their normal Rust
target or Apple SDK configuration. Android requires the NDK options above;
manual outputs are staged in
`build/rhodanthe/<platform>/jniLibs/<abi>` to avoid duplicates with Gradle's
generated libraries. Remove any older manually staged Rhodanthe `.so` files
from `android/app/src/main/jniLibs` before using automatic builds. Apple outputs are
staged under `build/rhodanthe`; Xcode must link the static library into Runner
before `DynamicLibrary.process()` can resolve it.

Release CI should treat Cargo as required and verify ABI/contract capabilities
with the Dart preflight test. Contributor builds may omit Rust and continue on
the existing Dart path.
