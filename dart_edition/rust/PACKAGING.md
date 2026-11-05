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

## Other platforms and library staging

Windows and Linux Flutter CMake builds automatically run Cargo when it is
available, then install the resulting bridge next to the executable (Windows)
or into `bundle/lib` (Linux). Configure with
`-DRHODANTHE_NATIVE=OFF` when intentionally testing the Dart fallback.

The portable staging command is:

```text
dart run tool/build_rhodanthe_native.dart --platform windows
```

Run the example on Windows. The default platform is the current desktop host;
desktop cross-builds require an explicit `--target` and a configured linker.
Add `--dry-run` to inspect the build and staging paths without invoking Cargo.
The tool runs inside the Rust workspace to select its pinned toolchain, uses
`--locked`, and explicitly places Cargo output in `rust/target`. See the
[implementation and toolchain plan](IMPLEMENTATION_PLAN.md) for setup and CI.

It supports Windows, Linux, macOS, Android arm64/arm/x64, and iOS device or
arm64 simulator Rust targets. Cross targets still require their normal Rust
target, NDK linker, or Apple SDK configuration. Android outputs are staged in
the matching `android/app/src/main/jniLibs/<abi>` directory. Apple outputs are
staged under `build/rhodanthe`; Xcode must link the static library into Runner
before `DynamicLibrary.process()` can resolve it.

Release CI should treat Cargo as required and verify ABI/contract capabilities
with the Dart preflight test. Contributor builds may omit Rust and continue on
the existing Dart path.
