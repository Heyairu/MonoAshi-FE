#!/bin/bash
set -euo pipefail

usage() {
  cat <<'EOF'
Build a macOS Release app with the Rhodanthe Rust FFI library.

Usage: bash tool/build_macos_rhodanthe.sh [--arch universal|arm64|x86_64] [-- Flutter build options]

  --arch <architecture>  Default: universal (Intel and Apple Silicon).
  -h, --help             Show this help.

Examples:
  bash tool/build_macos_rhodanthe.sh
  bash tool/build_macos_rhodanthe.sh --arch arm64
  bash tool/build_macos_rhodanthe.sh --arch x86_64 -- --build-number=42

Output: build/macos-dist/<architecture>/<product-name>.app
Signing: ad-hoc for local testing. Developer ID signing and notarization are separate.
Environment: FLUTTER_BIN and CARGO_BIN can override executable paths.
EOF
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

arch=universal
while [ "$#" -gt 0 ]; do
  case "$1" in
    --arch)
      [ "$#" -ge 2 ] || fail '--arch requires a value'
      arch=$2
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    --) shift; break ;;
    *) fail "Unknown option: $1 (pass Flutter options after --)" ;;
  esac
done

case "$arch" in
  universal) architectures=(x86_64 arm64) ;;
  arm64|x86_64) architectures=("$arch") ;;
  *) fail "Unsupported architecture: $arch" ;;
esac

# These options would change the artifact location, build mode, or stop before
# producing an app. The packaging steps below require a standard Release build.
for option in "$@"; do
  case "$option" in
    --debug|--profile|--config-only|--flavor|--flavor=*|--help|-h)
      fail "Flutter option $option is incompatible with this Release packager"
      ;;
  esac
done

[ "$(uname -s)" = Darwin ] || fail 'This script requires macOS and Xcode'
project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
flutter_bin=${FLUTTER_BIN:-flutter}
cargo_bin=${CARGO_BIN:-cargo}
for tool in "$flutter_bin" "$cargo_bin" xcrun codesign ditto plutil; do
  command -v "$tool" >/dev/null || fail "Required tool not found: $tool"
done
xcrun --find clang >/dev/null
xcrun --find lipo >/dev/null
xcrun --show-sdk-path >/dev/null

# Keep the native library's deployment target aligned with the Runner project.
export MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET:-12.0}
target_dir="$project_dir/rust/target"
native_libraries=()
for architecture in "${architectures[@]}"; do
  case "$architecture" in
    arm64) rust_target=aarch64-apple-darwin ;;
    x86_64) rust_target=x86_64-apple-darwin ;;
  esac
  printf '\nBuilding Rhodanthe for %s...\n' "$architecture"
  (
    # Running inside the workspace selects its pinned rust-toolchain.toml.
    cd "$project_dir/rust"
    "$cargo_bin" build --locked --release -p rhodanthe-bridge \
      --target "$rust_target" --target-dir "$target_dir"
  )
  native_libraries+=("$target_dir/$rust_target/release/librhodanthe_bridge.dylib")
done

cd "$project_dir"
bash "$project_dir/tool/prepare_macos_cocoapods.sh" "$project_dir"
printf '\nBuilding Flutter for %s...\n' "$arch"
# Flutter forwards FLUTTER_XCODE_* values to xcodebuild without changing the
# user's persistent Flutter configuration or Xcode project.
FLUTTER_XCODE_ARCHS="${architectures[*]}" \
FLUTTER_XCODE_ONLY_ACTIVE_ARCH=NO \
FLUTTER_XCODE_EXCLUDED_ARCHS= \
  "$flutter_bin" build macos --release "$@"

release_dir="$project_dir/build/macos/Build/Products/Release"
shopt -s nullglob
app_bundles=("$release_dir"/*.app)
[ "${#app_bundles[@]}" -eq 1 ] || \
  fail "Expected exactly one .app in $release_dir; found ${#app_bundles[@]}"
built_app=${app_bundles[0]}
app_name=$(basename "$built_app")
executable=$(plutil -extract CFBundleExecutable raw -o - "$built_app/Contents/Info.plist")

verify_architectures() {
  local binary=$1
  if ! xcrun lipo "$binary" -verify_arch "${architectures[@]}"; then
    fail "Missing requested architecture in $binary. Check Flutter's enable-macos-arm64-only setting and plugin architecture support."
  fi
}

verify_architectures "$built_app/Contents/MacOS/$executable"
verify_architectures "$built_app/Contents/Frameworks/App.framework/App"

output_dir="$project_dir/build/macos-dist/$arch"
mkdir -p "$output_dir"
staging_dir=$(mktemp -d "$output_dir/.rhodanthe-build.XXXXXX")
trap 'rm -rf "$staging_dir"' EXIT
staging_app="$staging_dir/$app_name"
ditto "$built_app" "$staging_app"
native_lib="$staging_app/Contents/Frameworks/librhodanthe_bridge.dylib"
mkdir -p "$(dirname "$native_lib")"
if [ "${#native_libraries[@]}" -eq 2 ]; then
  xcrun lipo -create "${native_libraries[@]}" -output "$native_lib"
else
  cp "${native_libraries[0]}" "$native_lib"
fi
xcrun install_name_tool -id '@rpath/librhodanthe_bridge.dylib' "$native_lib"
verify_architectures "$native_lib"

printf '\nSigning and verifying the packaged app...\n'
codesign --force --sign - "$native_lib"
codesign --force --sign - \
  --entitlements "$project_dir/macos/Runner/Release.entitlements" "$staging_app"
codesign --verify --deep --strict "$staging_app"

# Replace only this architecture's generated artifact after verification passes.
output_app="$output_dir/$app_name"
rm -rf "$output_app"
mv "$staging_app" "$output_app"
printf '\nBuilt: %s\n' "$output_app"
xcrun lipo -info "$output_app/Contents/Frameworks/librhodanthe_bridge.dylib"
printf 'Ad-hoc signed for local testing; Developer ID signing and notarization are still required for public distribution.\n'
