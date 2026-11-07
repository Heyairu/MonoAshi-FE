import "dart:convert";
import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:path/path.dart" as path;

import "../tool/generate_android_plugin_registrant.dart";

void main() {
  late Directory fixture;
  late File metadata;
  late List<Map<String, Object?>> plugins;

  setUp(() {
    fixture = Directory.systemTemp.createTempSync("android registrant test ");
    metadata = File(path.join(fixture.path, ".flutter-plugins-dependencies"));
    plugins = [];
  });
  tearDown(() => fixture.deleteSync(recursive: true));

  void plugin(String name, String android, {bool dev = false}) {
    final directory = Directory(path.join(fixture.path, name))..createSync();
    File(path.join(directory.path, "pubspec.yaml")).writeAsStringSync("""
name: $name
flutter:
  plugin:
    platforms:
      android:
$android
""");
    plugins.add({"name": name, "path": directory.path, "dev_dependency": dev});
    metadata.writeAsStringSync(
      jsonEncode({
        "plugins": {"android": plugins},
      }),
    );
  }

  void standardPlugins() {
    plugin(
      "production_plugin",
      "        package: example.production\n        pluginClass: ProductionPlugin",
    );
    plugin(
      "integration_test",
      "        package: dev.flutter.plugins.integration_test\n        pluginClass: IntegrationTestPlugin",
      dev: true,
    );
    plugin("ffi_only", "        ffiPlugin: true");
    plugin("dart_only", "        dartPluginClass: DartOnlyPlugin");
  }

  test(
    "Release registers production method-channel plugins and excludes dev plugins",
    () {
      standardPlugins();
      final source = generateAndroidPluginRegistrant(
        metadata: metadata,
        release: true,
      );
      expect(source, contains("new example.production.ProductionPlugin()"));
      expect(source, isNot(contains("IntegrationTestPlugin")));
      expect(source, isNot(contains("dart_only")));
      expect(source, isNot(contains("ffi_only")));
      expect(source, contains("@Keep"));
      expect(source, contains("package io.flutter.plugins;"));
    },
  );

  test("Debug and Profile keep integration_test registration", () {
    standardPlugins();
    final source = generateAndroidPluginRegistrant(
      metadata: metadata,
      release: false,
    );
    expect(
      source,
      contains(
        "new dev.flutter.plugins.integration_test.IntegrationTestPlugin()",
      ),
    );
    expect(source, contains("new example.production.ProductionPlugin()"));
  });

  test(
    "Release remains identical after a shared registrant is regenerated for Debug",
    () {
      standardPlugins();
      final original = generateAndroidPluginRegistrant(
        metadata: metadata,
        release: true,
      );
      final shared = File(
        path.join(
          fixture.path,
          "android",
          "app",
          "src",
          "main",
          "java",
          "io",
          "flutter",
          "plugins",
          "GeneratedPluginRegistrant.java",
        ),
      );
      shared.parent.createSync(recursive: true);
      final debugSource = generateAndroidPluginRegistrant(
        metadata: metadata,
        release: false,
      );
      shared.writeAsStringSync(debugSource);
      expect(
        generateAndroidPluginRegistrant(metadata: metadata, release: true),
        original,
      );
      expect(
        generateAndroidPluginRegistrant(metadata: metadata, release: true),
        original,
      );
      expect(shared.readAsStringSync(), debugSource);
    },
  );

  test(
    "Missing dependency classification fails rather than leaking test plugins",
    () {
      standardPlugins();
      plugins.last.remove("dev_dependency");
      metadata.writeAsStringSync(
        jsonEncode({
          "plugins": {"android": plugins},
        }),
      );
      expect(
        () =>
            generateAndroidPluginRegistrant(metadata: metadata, release: true),
        throwsFormatException,
      );
    },
  );

  test("Invalid Java class names fail before writing generated source", () {
    plugin(
      "invalid_plugin",
      "        package: example.invalid\n        pluginClass: 'Injected();'",
    );
    expect(
      () => generateAndroidPluginRegistrant(metadata: metadata, release: true),
      throwsFormatException,
    );
  });
}
