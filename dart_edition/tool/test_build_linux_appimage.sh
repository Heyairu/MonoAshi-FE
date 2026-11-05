#!/bin/sh
set -eu

tool_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
fixture_dir=$(mktemp -d "${TMPDIR:-/tmp}/monoashi-appimage.XXXXXX")
trap 'rm -rf "$fixture_dir"' 0
project_dir="$fixture_dir/project with spaces"
mkdir -p "$project_dir/tool" "$project_dir/rust" "$project_dir/linux/packaging" "$fixture_dir/bin"
cp "$tool_dir/build_linux_appimage.sh" "$project_dir/tool/"
cp "$tool_dir/../rust/rust-toolchain.toml" "$project_dir/rust/"
cp "$tool_dir/../linux/packaging/"* "$project_dir/linux/packaging/"

cat > "$fixture_dir/bin/cargo fixture" <<'EOF'
#!/bin/sh
set -eu
[ "$1" = --version ]
[ -f rust-toolchain.toml ]
printf 'cargo fixture\n'
EOF
cat > "$fixture_dir/bin/pkg-config" <<'EOF'
#!/bin/sh
exit 0
EOF
cat > "$fixture_dir/bin/flutter fixture" <<'EOF'
#!/bin/sh
set -eu
printf 'Flutter fixture diagnostic\n'
printf '%s\n' "$@" > flutter-arguments
[ "$RHODANTHE_REQUIRE_NATIVE" = 1 ]
[ -x "$CARGO_BIN" ]
if [ "${FIXTURE_FLUTTER_STATUS:-0}" -ne 0 ]; then
  exit "$FIXTURE_FLUTTER_STATUS"
fi
case "$(uname -m)" in
  x86_64) build_arch=x64 ;;
  aarch64) build_arch=arm64 ;;
esac
bundle="build/linux/$build_arch/release/bundle"
rm -rf "$bundle"
mkdir -p "$bundle/lib"
printf 'app fixture\n' > "$bundle/monogatari_assistant"
if [ "${FIXTURE_OMIT_NATIVE:-0}" -eq 0 ]; then
  printf 'native fixture\n' > "$bundle/lib/librhodanthe_bridge.so"
fi
EOF
chmod +x "$fixture_dir/bin/"*
export PATH="$fixture_dir/bin:$PATH"
export FLUTTER_BIN="$fixture_dir/bin/flutter fixture"
export CARGO_BIN="$fixture_dir/bin/cargo fixture"
# Ignore caller overrides; fixture packaging always matches the test host.
export ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) build_arch=x64 ;;
  aarch64) build_arch=arm64 ;;
  *) printf 'Unsupported test host: %s\n' "$ARCH" >&2; exit 1 ;;
esac
build_dir="$project_dir/build/linux/$build_arch/release"
mkdir -p "$project_dir/.dart_tool/appimage-tools" "$build_dir"
appimagetool="$project_dir/.dart_tool/appimage-tools/appimagetool-$ARCH.AppImage"
cat > "$appimagetool" <<'EOF'
#!/bin/sh
set -eu
[ "$1" = --appimage-extract-and-run ]
[ -f "$2/usr/bin/lib/librhodanthe_bridge.so" ]
printf 'AppImage fixture\n' > "$3"
EOF
chmod +x "$appimagetool"
script="$project_dir/tool/build_linux_appimage.sh"
output_file="$build_dir/Monogatari-Assistant-$ARCH.AppImage"
app_dir="$build_dir/MonogatariAssistant.AppDir"

expect_status() {
  expected=$1
  shift
  if "$@" > "$fixture_dir/output" 2>&1; then actual=0; else actual=$?; fi
  if [ "$actual" -ne "$expected" ]; then
    cat "$fixture_dir/output" >&2
    printf 'Expected exit %s, got %s\n' "$expected" "$actual" >&2
    exit 1
  fi
}

expect_status 0 sh "$script" --check
[ ! -e "$project_dir/flutter-arguments" ]
expect_status 1 env CARGO_BIN="$fixture_dir/missing-cargo" sh "$script"
[ ! -e "$project_dir/flutter-arguments" ]
expect_status 1 sh "$script" --unknown
expect_status 1 env ARCH=unsupported sh "$script"

# Flutter's failure must survive tee, and must not package a stale bundle.
printf 'previous image\n' > "$output_file"
expect_status 17 env FIXTURE_FLUTTER_STATUS=17 sh "$script"
[ "$(cat "$output_file")" = 'previous image' ]
[ ! -e "$app_dir" ]
[ "$(cat "$build_dir/appimage-build.log")" = 'Flutter fixture diagnostic' ]
expect_status 130 env FIXTURE_FLUTTER_STATUS=130 sh "$script"
[ "$(cat "$output_file")" = 'previous image' ]

# A successful Flutter build without the native library is also a failed package.
expect_status 1 env FIXTURE_OMIT_NATIVE=1 sh "$script"
[ "$(cat "$output_file")" = 'previous image' ]
[ ! -e "$app_dir" ]

expect_status 0 sh "$script"
[ "$(cat "$output_file")" = 'AppImage fixture' ]
[ -x "$output_file" ]
[ -f "$app_dir/usr/bin/lib/librhodanthe_bridge.so" ]
[ -L "$app_dir/.DirIcon" ]
case "$(cat "$project_dir/flutter-arguments")" in
  *--release*--verbose*) ;;
  *) printf 'Missing Release/verbose Flutter arguments\n' >&2; exit 1 ;;
esac
printf 'Linux AppImage preflight, failure propagation, logging, and packaging checks passed.\n'
