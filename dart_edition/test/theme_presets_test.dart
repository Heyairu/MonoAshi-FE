import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/ui_library.dart';
import 'package:monogatari_assistant/data/repositories/theme_repository.dart';
import 'package:monogatari_assistant/features/oobe/oobe_state.dart';
import 'package:monogatari_assistant/presentation/providers/global_state_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

double contrast(Color a, Color b) {
  final first = a.computeLuminance();
  final second = b.computeLuminance();
  return (math.max(first, second) + .05) / (math.min(first, second) + .05);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final brightness in Brightness.values) {
    test('gray has neutral surfaces and readable roles in $brightness', () {
      final colors = AppThemePalette.scheme(
        Colors.grey,
        brightness,
        AppThemePreset.standard,
      );
      for (final color in [
        colors.primary,
        colors.secondary,
        colors.tertiary,
        colors.primaryContainer,
        colors.secondaryContainer,
        colors.tertiaryContainer,
        colors.surface,
        colors.onSurface,
        colors.onSurfaceVariant,
        colors.surfaceContainerLowest,
        colors.surfaceContainerLow,
        colors.surfaceContainer,
        colors.surfaceContainerHigh,
        colors.surfaceContainerHighest,
        colors.outline,
        colors.outlineVariant,
        colors.inverseSurface,
        colors.inversePrimary,
      ]) {
        expect(color.r, closeTo(color.g, .0001));
        expect(color.g, closeTo(color.b, .0001));
      }
      expect(
        contrast(colors.onSurfaceVariant, colors.surfaceContainerHighest),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrast(colors.onTertiaryContainer, colors.tertiaryContainer),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        {
          colors.surfaceContainerLowest,
          colors.surfaceContainerLow,
          colors.surfaceContainer,
          colors.surfaceContainerHigh,
          colors.surfaceContainerHighest,
        }.length,
        5,
      );
    });

    for (final preset in AppThemePreset.values.where(
      (preset) => preset != AppThemePreset.standard,
    )) {
      test('${preset.name} text contrast in $brightness', () {
        final colors = AppThemePalette.scheme(Colors.blue, brightness, preset);
        for (final (foreground, background) in [
          (colors.onSurface, colors.surface),
          (colors.onSurfaceVariant, colors.surfaceContainerHighest),
          (colors.onPrimary, colors.primary),
          (colors.onPrimaryContainer, colors.primaryContainer),
          (colors.onSecondary, colors.secondary),
          (colors.onSecondaryContainer, colors.secondaryContainer),
          (colors.onTertiary, colors.tertiary),
          (colors.onTertiaryContainer, colors.tertiaryContainer),
          (colors.onError, colors.error),
          (colors.onErrorContainer, colors.errorContainer),
        ]) {
          expect(
            contrast(foreground, background),
            greaterThanOrEqualTo(
              preset == AppThemePreset.highContrast ? 7 : 4.5,
            ),
          );
        }
        if (preset == AppThemePreset.highContrast) {
          expect(
            contrast(colors.outline, colors.surface),
            greaterThanOrEqualTo(7),
          );
          expect(
            contrast(colors.outlineVariant, colors.surfaceContainerHighest),
            greaterThanOrEqualTo(3),
          );
        }
      });
    }
  }

  test(
    'old and unknown preferences preserve accent and safely use standard',
    () async {
      for (final preset in [null, 'future-preset']) {
        SharedPreferences.setMockInitialValues({
          'app_theme_color': Colors.grey.toARGB32(),
          'app_theme_mode': AppThemeMode.dark.index,
          if (preset != null) 'app_theme_preset': preset,
        });
        final loaded = await SharedPreferencesThemeRepository().load();
        expect(loaded.themeColor.toARGB32(), Colors.grey.toARGB32());
        expect(loaded.themeMode, AppThemeMode.dark);
        expect(loaded.themePreset, AppThemePreset.standard);
      }
    },
  );

  test(
    'presets survive fresh providers and selecting a color clears the preset',
    () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(themeStateProvider.future);
      final notifier = container.read(themeStateProvider.notifier);
      await notifier.setThemeColor(Colors.green);
      for (final preset in AppThemePreset.values) {
        await notifier.setThemePreset(preset);
        final fresh = ProviderContainer();
        final loaded = await fresh.read(themeStateProvider.future);
        expect(loaded.themePreset, preset);
        expect(fresh.read(appThemeSettingsProvider).preset, preset);
        expect(loaded.themeColor.toARGB32(), Colors.green.toARGB32());
        final oobe = OobePreferences.fromSettings(
          const AppSettingsStateData(),
          loaded,
        );
        expect(oobe.copyWith(fontSize: 18).themePreset, preset);
        fresh.dispose();
      }
      await notifier.setThemeColor(Colors.grey);
      final saved = await SharedPreferencesThemeRepository().load();
      expect(saved.themePreset, AppThemePreset.standard);
      expect(saved.themeColor.toARGB32(), Colors.grey.toARGB32());
    },
  );
}
