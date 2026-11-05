#!/bin/bash
set -euo pipefail

tool_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
fixture_dir=$(mktemp -d "${TMPDIR:-/tmp}/monoashi-macos-cache.XXXXXX")
trap 'rm -rf "$fixture_dir"' EXIT
project_dir="$fixture_dir/project with spaces"
products_dir="$project_dir/build/macos/Build/Products/Release"
plugins_dir="$project_dir/macos/Flutter/ephemeral/.symlinks/plugins"
mkdir -p "$project_dir"

check() {
  if ! "$@"; then
    printf 'Failed: %s\n' "$*" >&2
    exit 1
  fi
}

# A fresh checkout has no generated directories to clean.
printf 'flutter:\n  config:\n    enable-swift-package-manager: false\n' > "$project_dir/pubspec.yaml"
bash "$tool_dir/prepare_macos_cocoapods.sh" "$project_dir"
check test ! -e "$products_dir"

# Simulate both a migrated plugin framework and a plugin not built by Pods yet.
mkdir -p "$products_dir/video_player_avfoundation.swiftmodule"
mkdir -p "$products_dir/video_player_avfoundation/video_player_avfoundation.framework/Modules/video_player_avfoundation.swiftmodule"
mkdir -p "$products_dir/shared_preferences_foundation.swiftmodule"
mkdir -p "$fixture_dir/shared_preferences_foundation"
mkdir -p "$plugins_dir"
ln -s "$fixture_dir/shared_preferences_foundation" "$plugins_dir/shared_preferences_foundation"
mkdir -p "$products_dir/Runner.swiftmodule" "$products_dir/FlutterFramework.swiftmodule"
mkdir -p "$project_dir/build/macos/Build/Products/Debug/video_player_avfoundation.swiftmodule"
mkdir -p "$project_dir/rust/target" "$project_dir/build/macos-dist/universal/MonoAshi.app"
printf 'cached rust output' > "$project_dir/rust/target/library"
printf 'previous package' > "$project_dir/build/macos-dist/universal/MonoAshi.app/marker"

bash "$tool_dir/prepare_macos_cocoapods.sh" "$project_dir"
check test ! -e "$products_dir/video_player_avfoundation.swiftmodule"
check test ! -e "$products_dir/shared_preferences_foundation.swiftmodule"
check test -d "$products_dir/video_player_avfoundation/video_player_avfoundation.framework/Modules/video_player_avfoundation.swiftmodule"
check test -d "$products_dir/Runner.swiftmodule"
check test -d "$products_dir/FlutterFramework.swiftmodule"
check test -d "$project_dir/build/macos/Build/Products/Debug/video_player_avfoundation.swiftmodule"
check test -f "$project_dir/rust/target/library"
check test -f "$project_dir/build/macos-dist/universal/MonoAshi.app/marker"

# Repeated packaging is harmless; SwiftPM projects retain their own modules.
bash "$tool_dir/prepare_macos_cocoapods.sh" "$project_dir"
mkdir -p "$products_dir/video_player_avfoundation.swiftmodule"
for config in true unset; do
  if [ "$config" = true ]; then
    printf 'flutter:\n  config:\n    enable-swift-package-manager: true\n' > "$project_dir/pubspec.yaml"
  else
    printf 'flutter:\n  uses-material-design: true\n' > "$project_dir/pubspec.yaml"
  fi
  bash "$tool_dir/prepare_macos_cocoapods.sh" "$project_dir"
  check test -d "$products_dir/video_player_avfoundation.swiftmodule"
done
printf 'macOS dependency cache checks passed.\n'
