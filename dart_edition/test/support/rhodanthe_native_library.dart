import "dart:io";

import "package:path/path.dart" as path;

/// An explicit CI library path must exist, so native tests cannot silently skip.
String? developmentRhodantheLibraryPath() {
  final explicit = Platform.environment["RHODANTHE_NATIVE_LIBRARY"];
  if (explicit != null) {
    if (explicit.isEmpty || !File(explicit).existsSync()) {
      throw StateError("RHODANTHE_NATIVE_LIBRARY does not exist: $explicit");
    }
    return path.absolute(explicit);
  }
  final fileName = switch (Platform.operatingSystem) {
    "windows" => "rhodanthe_bridge.dll",
    "linux" => "librhodanthe_bridge.so",
    "macos" => "librhodanthe_bridge.dylib",
    _ => null,
  };
  if (fileName == null) return null;
  final candidate = path.join(
    Directory.current.path,
    "rust",
    "target",
    "release",
    fileName,
  );
  return File(candidate).existsSync() ? candidate : null;
}
