import "dart:io";
import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:monogatari_assistant/bin/ui_library.dart";
import "package:monogatari_assistant/models/toolbar_mode.dart";
import "package:monogatari_assistant/modules/settingview.dart";
import "package:monogatari_assistant/presentation/providers/global_state_providers.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<ProviderContainer> mountSettings(
  WidgetTester tester, {
  Size size = const Size(800, 1400),
  bool dark = false,
  double textScale = 1,
  AppThemePreset preset = AppThemePreset.standard,
  Color seed = Colors.lightBlue,
}) async {
  SharedPreferences.setMockInitialValues({
    "app_theme_preset": preset.name,
    "app_theme_color": seed.toARGB32(),
    "app_theme_mode": (dark ? AppThemeMode.dark : AppThemeMode.light).index,
  });
  const backgroundChannel = MethodChannel(
    "com.heyairu.monogatari_assistant/background_execution",
  );
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    backgroundChannel,
    (_) async => true,
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      backgroundChannel,
      null,
    ),
  );
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final container = ProviderContainer();
  addTearDown(container.dispose);
  await container.read(settingsStateProvider.future);
  await container.read(themeStateProvider.future);
  await container.read(toolbarModeProvider.future);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: dark
            ? AppTheme.getDarkTheme(14, seed, preset: preset)
            : AppTheme.getLightTheme(14, seed, preset: preset),
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            platformBrightness: dark ? Brightness.dark : Brightness.light,
            textScaler: TextScaler.linear(textScale),
          ),
          child: RepaintBoundary(
            key: const Key("settings-preview"),
            child: const SettingView(),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  return container;
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 300));
  await tester.tap(finder);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final (family, path) in [
      ("NotoSans", "assets/fonts/NotoSans-Variable.ttf"),
      ("NotoSansTC", "assets/fonts/NotoSansTC-Variable.ttf"),
      ("MaterialIcons", "fonts/MaterialIcons-Regular.otf"),
    ]) {
      final loader = FontLoader(family)..addFont(rootBundle.load(path));
      await loader.load();
    }
  });
  testWidgets("theme and toolbar preview cards persist every choice", (
    tester,
  ) async {
    final container = await mountSettings(tester);
    for (final mode in AppThemeMode.values) {
      await tapVisible(
        tester,
        find.byKey(ValueKey("settings-mode-theme-${mode.name}")),
      );
      expect(container.read(themeStateProvider).value!.themeMode, mode);
      expect(
        (await SharedPreferences.getInstance()).getInt("app_theme_mode"),
        mode.index,
      );
    }
    for (final mode in [...ToolbarMode.values, null]) {
      await tapVisible(
        tester,
        find.byKey(
          ValueKey("settings-mode-toolbar-${mode?.name ?? "automatic"}"),
        ),
      );
      expect(container.read(toolbarModeProvider).value, mode);
      expect(
        (await SharedPreferences.getInstance()).getString("toolbar_mode"),
        mode?.name,
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    "special themes persist and pride support text follows selection",
    (tester) async {
      final container = await mountSettings(
        tester,
        size: const Size(360, 1000),
        textScale: 1.6,
      );
      final caption = find.text("除了使用這個主題外，你還可以做什麼……");
      expect(caption, findsNothing);
      for (final preset in AppThemePreset.values.where(
        (value) => value != AppThemePreset.standard,
      )) {
        await tapVisible(
          tester,
          find.byKey(ValueKey("settings-color-preset-${preset.name}")),
        );
        expect(
          container.read(themeStateProvider).requireValue.themePreset,
          preset,
        );
        expect(
          (await SharedPreferences.getInstance()).getString("app_theme_preset"),
          preset.name,
        );
        expect(caption, preset.isPride ? findsOneWidget : findsNothing);
        expect(tester.takeException(), isNull);
      }
      await tapVisible(
        tester,
        find.byKey(const ValueKey("settings-color-Gray")),
      );
      expect(
        container.read(themeStateProvider).requireValue.themePreset,
        AppThemePreset.standard,
      );
      expect(caption, findsNothing);
    },
  );

  testWidgets("sections fold independently and keep edited settings", (
    tester,
  ) async {
    final container = await mountSettings(tester);
    // Includes the writing-goals section already present in SettingView.
    expect(find.byType(ExpansionTile), findsNWidgets(7));
    expect(find.byKey(const Key("poppin-enabled-setting")), findsNothing);
    await tapVisible(tester, find.text("編輯與輸入"));
    final setting = find.byKey(const Key("poppin-enabled-setting"));
    await tapVisible(
      tester,
      find.descendant(of: setting, matching: find.byType(Switch)),
    );
    expect(container.read(settingsStateProvider).value!.poppinEnabled, isFalse);
    await tapVisible(tester, find.text("編輯與輸入"));
    expect(find.byKey(const Key("poppin-enabled-setting")), findsNothing);
    await tapVisible(tester, find.text("編輯與輸入"));
    expect(
      tester
          .widget<Switch>(
            find.descendant(of: setting, matching: find.byType(Switch)),
          )
          .value,
      isFalse,
    );
    await tapVisible(tester, find.text("儲存與備份"));
    expect(find.text("自動備份"), findsOneWidget);
    expect(find.byKey(const Key("poppin-enabled-setting")), findsOneWidget);
    await tapVisible(tester, find.text("外觀與介面"));
    expect(find.byKey(const Key("toolbar-mode-setting")), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final dark in [false, true]) {
    testWidgets(
      "${dark ? "dark" : "light"} preview cards fit a narrow screen with large text",
      (tester) async {
        await mountSettings(
          tester,
          size: const Size(360, 1000),
          dark: dark,
          textScale: 1.6,
        );
        for (final group in [
          [
            "navigation-railTooltip",
            "navigation-railLabel",
            "navigation-railButtonDrawer",
            "navigation-railHoverDrawer",
          ],
          [
            "toolbar-full",
            "toolbar-moderate",
            "toolbar-concise",
            "toolbar-automatic",
          ],
        ]) {
          final tops = group
              .map(
                (id) => tester
                    .getTopLeft(find.byKey(ValueKey("settings-mode-$id")))
                    .dy,
              )
              .toList();
          expect(tops, everyElement(tops.first));
        }
        for (final id in [
          "theme-system",
          "navigation-railHoverDrawer",
          "toolbar-automatic",
        ]) {
          await tapVisible(tester, find.byKey(ValueKey("settings-mode-$id")));
          expect(tester.takeException(), isNull);
        }
        await tapVisible(tester, find.text("外觀與介面"));
        for (final title in ["編輯與輸入", "儲存與備份", '同步與連線', "一般設定", "外部整合"]) {
          await tapVisible(tester, find.text(title));
          expect(tester.takeException(), isNull);
          await tapVisible(tester, find.text(title));
        }
      },
    );

    for (final preset in AppThemePreset.values) {
      testWidgets(
        "${preset.name} ${dark ? "dark" : "light"} theme visual preview",
        (tester) async {
          await mountSettings(
            tester,
            size: const Size(760, 1700),
            dark: dark,
            preset: preset,
            seed: Colors.grey,
          );
          expect(tester.takeException(), isNull);
          const directory = String.fromEnvironment("SETTINGS_PREVIEW_DIR");
          if (directory.isNotEmpty) {
            final boundary = tester.renderObject<RenderRepaintBoundary>(
              find.byKey(const Key("settings-preview")),
            );
            await tester.runAsync(() async {
              final screenshot = await boundary.toImage(pixelRatio: 1);
              final bytes = await screenshot.toByteData(
                format: ui.ImageByteFormat.png,
              );
              await File(
                "$directory/${preset.name}-${dark ? "dark" : "light"}.png",
              ).writeAsBytes(bytes!.buffer.asUint8List());
              screenshot.dispose();
            });
          }
        },
      );
    }

    testWidgets("${dark ? "dark" : "light"} settings visual preview", (
      tester,
    ) async {
      await mountSettings(tester, size: const Size(760, 1500), dark: dark);
      expect(tester.takeException(), isNull);
      const directory = String.fromEnvironment("SETTINGS_PREVIEW_DIR");
      if (directory.isNotEmpty) {
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const Key("settings-preview")),
        );
        await tester.runAsync(() async {
          final screenshot = await boundary.toImage(pixelRatio: 1.5);
          final bytes = await screenshot.toByteData(
            format: ui.ImageByteFormat.png,
          );
          await File(
            "$directory/settings-${dark ? "dark" : "light"}.png",
          ).writeAsBytes(bytes!.buffer.asUint8List());
          screenshot.dispose();
        });
      }
    });
  }
}
