#!/bin/sh
set -eu

usage() {
  cat <<'EOF'
Build a Linux AppImage containing the Rhodanthe Rust library.

Usage: sh dart_edition/tool/build_linux_appimage.sh [--check]

  --check   Check required tools without building or downloading appimagetool.
  --help    Show this help.

Environment: FLUTTER_BIN, CARGO_BIN, and ARCH (x86_64 or aarch64).
ARCH must match the host; this script does not configure cross-compilation.
Full Flutter output is saved in build/linux/<architecture>/release/appimage-build.log.
EOF
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

check_only=0
case "${1:-}" in
  --help|-h) usage; exit 0 ;;
  --check) check_only=1; shift ;;
esac
[ "$#" -eq 0 ] || fail "Unknown argument: $1"
[ "$(uname -s)" = Linux ] || fail 'This script requires Linux'

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
flutter_bin=${FLUTTER_BIN:-flutter}
host_arch=$(uname -m)
arch=${ARCH:-$host_arch}
[ "$arch" = "$host_arch" ] || fail "ARCH=$arch does not match host $host_arch; cross-compilation is not configured"
case "$arch" in
  x86_64) flutter_arch=x64 ;;
  aarch64) flutter_arch=arm64 ;;
  *) fail "Unsupported architecture: $arch" ;;
esac
build_dir="$project_dir/build/linux/$flutter_arch/release"
bundle_dir="$build_dir/bundle"
app_dir="$build_dir/MonogatariAssistant.AppDir"
output_file="$build_dir/Monogatari-Assistant-$arch.AppImage"
tool_dir="$project_dir/.dart_tool/appimage-tools"
appimagetool="$tool_dir/appimagetool-$arch.AppImage"
desktop_file="$project_dir/linux/packaging/com.heyairu.monogatari_assistant.desktop"
icon_file="$project_dir/linux/packaging/com.heyairu.monogatari_assistant.png"

for tool in "$flutter_bin" cmake ninja clang++ pkg-config curl tee mktemp; do
  command -v "$tool" >/dev/null || fail "Required tool not found: $tool"
done

if [ -n "${CARGO_BIN:-}" ]; then
  cargo_bin=$CARGO_BIN
elif command -v cargo >/dev/null 2>&1; then
  cargo_bin=$(command -v cargo)
else
  cargo_bin="${CARGO_HOME:-$HOME/.cargo}/bin/cargo"
fi
cargo_bin=$(command -v "$cargo_bin") || \
  fail 'Cargo was not found. Install rustup, then source "$HOME/.cargo/env", or set CARGO_BIN to its executable path. See dart_edition/rust/IMPLEMENTATION_PLAN.md.'
# Use an absolute path so Flutter/CMake can change working directories safely.
cargo_dir=$(CDPATH= cd -- "$(dirname -- "$cargo_bin")" && pwd)
export CARGO_BIN="$cargo_dir/$(basename -- "$cargo_bin")"
export PATH="$cargo_dir:$PATH"
export RHODANTHE_REQUIRE_NATIVE=1
(
  cd "$project_dir/rust"
  "$CARGO_BIN" --version
) || fail 'The pinned Rust toolchain could not start; check rustup show from dart_edition/rust'
pkg-config --exists gtk+-3.0 || fail 'GTK 3 development files were not found by pkg-config'
[ "$check_only" -eq 0 ] || { printf 'Linux AppImage prerequisites passed.\n'; exit 0; }

cd "$project_dir"
mkdir -p "$build_dir"
build_log="$build_dir/appimage-build.log"
status_file=$(mktemp "$build_dir/.appimage-build-status.XXXXXX")
trap 'rm -f "$status_file"' 0
trap 'exit 130' INT
trap 'exit 143' TERM
printf 'Building Linux AppImage; full Flutter log: %s\n' "$build_log"
# POSIX sh has no pipefail. Record Flutter's status separately from tee's status
# so a failed or interrupted build can never proceed to package an old bundle.
if (
  if "$flutter_bin" build linux --release --verbose; then
    flutter_status=0
  else
    flutter_status=$?
  fi
  printf '%s\n' "$flutter_status" > "$status_file"
) 2>&1 | tee "$build_log"; then
  :
else
  fail "Could not write build log: $build_log"
fi
flutter_status=$(cat "$status_file")
case "$flutter_status" in
  0) ;;
  '') fail "Build was interrupted. See $build_log" ;;
  *) printf 'Flutter build failed (exit %s). Full log: %s\n' "$flutter_status" "$build_log" >&2
     exit "$flutter_status" ;;
esac
[ -f "$bundle_dir/lib/librhodanthe_bridge.so" ] || \
  fail "Rhodanthe was not packaged in $bundle_dir/lib; check RHODANTHE_NATIVE in CMakeCache.txt and $build_log"

cmake -E remove_directory "$app_dir"
cmake -E make_directory "$app_dir/usr/bin"
cmake -E make_directory "$app_dir/usr/share/applications"
cmake -E make_directory "$app_dir/usr/share/icons/hicolor/512x512/apps"
cmake -E copy_directory "$bundle_dir" "$app_dir/usr/bin"
cmake -E copy "$desktop_file" \
  "$app_dir/usr/share/applications/com.heyairu.monogatari_assistant.desktop"
cmake -E copy "$icon_file" \
  "$app_dir/usr/share/icons/hicolor/512x512/apps/com.heyairu.monogatari_assistant.png"
cmake -E copy "$project_dir/linux/packaging/AppRun" "$app_dir/AppRun"
chmod +x "$app_dir/AppRun"

ln -s "usr/share/applications/com.heyairu.monogatari_assistant.desktop" \
  "$app_dir/com.heyairu.monogatari_assistant.desktop"
ln -s "usr/share/icons/hicolor/512x512/apps/com.heyairu.monogatari_assistant.png" \
  "$app_dir/com.heyairu.monogatari_assistant.png"
ln -s "com.heyairu.monogatari_assistant.png" "$app_dir/.DirIcon"

cmake -E make_directory "$tool_dir"
if [ ! -x "$appimagetool" ]; then
  curl --fail --location --output "$appimagetool" \
    "https://github.com/AppImage/appimagetool/releases/download/1.9.1/appimagetool-$arch.AppImage"
  chmod +x "$appimagetool"
fi

cmake -E rm -f "$output_file"
ARCH="$arch" "$appimagetool" --appimage-extract-and-run \
  "$app_dir" "$output_file"
chmod +x "$output_file"

printf '%s\n' "$output_file"
