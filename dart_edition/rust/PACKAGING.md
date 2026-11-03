# Rhodanthe native packaging

## macOS app with Rust FFI

From `dart_edition`, run:

```sh
bash tool/build_macos_rhodanthe.sh
```

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

It supports Windows, Linux, macOS, Android arm64/arm/x64, and iOS device or
arm64 simulator Rust targets. Cross targets still require their normal Rust
target, NDK linker, or Apple SDK configuration. Android outputs are staged in
the matching `android/app/src/main/jniLibs/<abi>` directory. Apple outputs are
staged under `build/rhodanthe`; Xcode must link the static library into Runner
before `DynamicLibrary.process()` can resolve it.

Release CI should treat Cargo as required and verify ABI/contract capabilities
with the Dart preflight test. Contributor builds may omit Rust and continue on
the existing Dart path.
