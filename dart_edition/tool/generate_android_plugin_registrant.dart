import "dart:convert";
import "dart:io";

import "package:path/path.dart" as path;
import "package:yaml/yaml.dart";

/// Generates a variant-owned registrant from Flutter's resolved plugin metadata.
/// Run directly with --disable-dart-dev; this tool needs no native build hooks.
void main(List<String> arguments) {
  try {
    final options = <String, String>{};
    for (var index = 0; index < arguments.length; index += 2) {
      final key = arguments[index];
      if (!const {"--metadata", "--mode", "--out"}.contains(key) ||
          options.containsKey(key) ||
          index + 1 >= arguments.length) {
        throw const FormatException(
          "Expected --metadata <file> --mode <debug|profile|release> --out <file>",
        );
      }
      options[key] = arguments[index + 1];
    }
    final mode = options["--mode"];
    if (!const {"debug", "profile", "release"}.contains(mode) ||
        options["--metadata"] == null ||
        options["--out"] == null) {
      throw const FormatException(
        "Expected --metadata <file> --mode <debug|profile|release> --out <file>",
      );
    }
    final output = File(options["--out"]!);
    final source = generateAndroidPluginRegistrant(
      metadata: File(options["--metadata"]!),
      release: mode == "release",
    );
    output.parent.createSync(recursive: true);
    // Leave timestamps stable when only unrelated metadata changed.
    if (!output.existsSync() || output.readAsStringSync() != source) {
      output.writeAsStringSync(source);
    }
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    exitCode = 64;
  } on FileSystemException catch (error) {
    stderr.writeln("Unable to generate Android plugin registration: $error");
    exitCode = 74;
  }
}

String generateAndroidPluginRegistrant({
  required File metadata,
  required bool release,
}) {
  final resolved =
      jsonDecode(metadata.readAsStringSync()) as Map<String, dynamic>;
  final android =
      (resolved["plugins"] as Map<String, dynamic>)["android"] as List<dynamic>;
  final registrations = StringBuffer();
  final identifier = RegExp(
    r"^[a-zA-Z_$][a-zA-Z0-9_$]*(\.[a-zA-Z_$][a-zA-Z0-9_$]*)*$",
  );
  for (final value in android) {
    final plugin = value as Map<String, dynamic>;
    if (plugin["dev_dependency"] is! bool) {
      throw FormatException(
        "Missing dev_dependency for ${plugin['name']}; run flutter pub get",
      );
    }
    if (release && plugin["dev_dependency"] == true) continue;
    final manifest =
        loadYaml(
              File(
                path.join(plugin["path"] as String, "pubspec.yaml"),
              ).readAsStringSync(),
            )
            as YamlMap;
    final declaration = (manifest["flutter"] as YamlMap)["plugin"] as YamlMap;
    final platforms = declaration["platforms"] as YamlMap?;
    final androidDeclaration = platforms?["android"] as YamlMap?;
    final pluginClass =
        androidDeclaration?["pluginClass"] ??
        (platforms == null ? declaration["pluginClass"] : null);
    // FFI-only and Dart-only plugins do not have a Java plugin to register.
    if (pluginClass == null) continue;
    final packageName =
        androidDeclaration?["package"] ?? declaration["androidPackage"];
    if (packageName is! String ||
        pluginClass is! String ||
        !identifier.hasMatch(packageName) ||
        !identifier.hasMatch(pluginClass)) {
      throw FormatException(
        "Invalid Android plugin class for ${plugin['name']}",
      );
    }
    final qualifiedClass = "$packageName.$pluginClass";
    final message = jsonEncode(
      "Error registering plugin ${plugin['name']}, $qualifiedClass",
    );
    registrations.writeln("""
    try {
      flutterEngine.getPlugins().add(new $qualifiedClass());
    } catch (Exception e) {
      Log.e(TAG, $message, e);
    }""");
  }
  return """package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;
import io.flutter.embedding.engine.FlutterEngine;

// Generated for this build variant. Do not edit.
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
$registrations  }
}
""";
}
