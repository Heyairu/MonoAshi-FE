#!/bin/bash
set -euo pipefail

# CocoaPods frameworks live inside <plugin>/<plugin>.framework. SwiftPM leaves
# top-level <plugin>.swiftmodule directories that can shadow those frameworks
# after the project switches dependency managers. Remove only those obsolete
# plugin modules, leaving framework contents and other build caches intact.
project_dir=$(CDPATH= cd -- "${1:?Expected the Flutter project directory}" && pwd)
if ! grep -Eq '^[[:space:]]*enable-swift-package-manager:[[:space:]]*false([[:space:]]|$)' \
    "$project_dir/pubspec.yaml"; then
  exit 0
fi

products_dir="$project_dir/build/macos/Build/Products/Release"
plugins_dir="$project_dir/macos/Flutter/ephemeral/.symlinks/plugins"
shopt -s nullglob
for module_dir in "$products_dir"/*.swiftmodule; do
  [ -d "$module_dir" ] || continue
  module_name=${module_dir##*/}
  module_name=${module_name%.swiftmodule}
  if [ -d "$plugins_dir/$module_name" ] || \
      [ -d "$products_dir/$module_name/$module_name.framework" ]; then
    printf 'Removing stale SwiftPM module: %s\n' "$module_dir"
    rm -rf -- "$module_dir"
  fi
done
