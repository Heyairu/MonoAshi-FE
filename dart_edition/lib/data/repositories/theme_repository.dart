import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../bin/ui_library.dart";

class ThemeSettingsSnapshot {
  final AppThemeMode themeMode;
  final Color themeColor;
  final AppThemePreset themePreset;

  const ThemeSettingsSnapshot({
    required this.themeMode,
    required this.themeColor,
    this.themePreset = AppThemePreset.standard,
  });
}

abstract class ThemeRepository {
  Future<ThemeSettingsSnapshot> load();

  Future<void> saveThemeMode(AppThemeMode mode);

  Future<void> saveThemeColor(Color color);

  Future<void> saveThemePreset(AppThemePreset preset);
}

class SharedPreferencesThemeRepository implements ThemeRepository {
  static const String _themePreferenceKey = "app_theme_mode";
  static const String _presetPreferenceKey = "app_theme_preset";
  static const String _colorPreferenceKey = "app_theme_color";

  @override
  Future<ThemeSettingsSnapshot> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeIndex = prefs.getInt(_themePreferenceKey);
    final savedColorValue = prefs.getInt(_colorPreferenceKey);

    final mode =
        savedThemeIndex != null &&
            savedThemeIndex >= 0 &&
            savedThemeIndex < AppThemeMode.values.length
        ? AppThemeMode.values[savedThemeIndex]
        : AppThemeMode.system;

    final color = savedColorValue != null
        ? Color(savedColorValue)
        : Colors.lightBlue;

    final presetName = prefs.getString(_presetPreferenceKey);
    final preset =
        AppThemePreset.values
            .where((value) => value.name == presetName)
            .firstOrNull ??
        AppThemePreset.standard;
    return ThemeSettingsSnapshot(
      themeMode: mode,
      themeColor: color,
      themePreset: preset,
    );
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePreferenceKey, mode.index);
  }

  @override
  Future<void> saveThemePreset(AppThemePreset preset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_presetPreferenceKey, preset.name);
  }

  @override
  Future<void> saveThemeColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorPreferenceKey, color.toARGB32());
  }
}
