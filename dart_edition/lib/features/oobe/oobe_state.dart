import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../bin/ui_library.dart" show AppThemePreset, AppThemeMode;
import "../../models/app_state_data.dart";
import "../../models/navigation_style.dart";
import "../../models/toolbar_mode.dart";
import "../../data/repositories/storage_preferences_repository.dart";
import "../../data/repositories/user_profile_repository.dart";

/// Explicit bypass wins when both switches are supplied. Bypass is per launch;
/// only finishing the wizard records completion on this device.
class OobeLaunchOptions {
  const OobeLaunchOptions({this.force = false, this.bypass = false});

  factory OobeLaunchOptions.parse(Iterable<String> arguments) =>
      OobeLaunchOptions(
        force: arguments.contains("--oobe/force"),
        bypass: arguments.contains("--oobe/bypass"),
      );

  final bool force;
  final bool bypass;

  bool shouldShow({required bool completed}) =>
      !bypass && (force || !completed);
}

class OobeRepository {
  static const completionKey = "oobe_completed";

  Future<bool> isCompleted() async =>
      (await SharedPreferences.getInstance()).getBool(completionKey) ?? false;

  Future<void> complete() async {
    final preferences = await SharedPreferences.getInstance();
    if (!await preferences.setBool(completionKey, true)) {
      throw StateError("無法儲存初次設定的完成狀態，請重試。");
    }
  }
}

final oobeRepositoryProvider = Provider<OobeRepository>(
  (ref) => OobeRepository(),
);

final oobeCompletedProvider = FutureProvider<bool>(
  (ref) => ref.watch(oobeRepositoryProvider).isCompleted(),
);

class OobePreferences {
  const OobePreferences({
    this.themeMode = AppThemeMode.system,
    this.themeColor = Colors.lightBlue,
    this.themePreset = AppThemePreset.standard,
    this.fontSize = 14,
    this.navigationStyle = NavigationStyle.railLabel,
    this.toolbarMode,
    this.autoSaveEnabled = false,
    this.autoBackupEnabled = false,
    this.autoSaveIntervalMinutes = 5,
    this.autoBackupIntervalMinutes = 5,
    this.backupDirectory,
    this.displayName = "",
    this.useAsDefaultPenName = false,
  });

  factory OobePreferences.fromSettings(
    AppSettingsStateData settings,
    AppThemeStateData theme, {
    StorageDirectories directories = const StorageDirectories(),
    ToolbarMode? toolbarMode,
    UserProfile profile = const UserProfile(),
  }) => OobePreferences(
    themeMode: theme.themeMode,
    themeColor: theme.themeColor,
    themePreset: theme.themePreset,
    fontSize: settings.fontSize,
    navigationStyle: settings.navigationStyle,
    toolbarMode: toolbarMode,
    autoSaveEnabled: settings.autoSaveEnabled,
    autoBackupEnabled: settings.autoBackupEnabled,
    autoSaveIntervalMinutes: settings.autoSaveIntervalMinutes,
    autoBackupIntervalMinutes: settings.autoBackupIntervalMinutes,
    backupDirectory: directories.backupDirectory,
    displayName: profile.displayName,
    useAsDefaultPenName: profile.useAsDefaultPenName,
  );

  final AppThemeMode themeMode;
  final Color themeColor;
  final AppThemePreset themePreset;
  final double fontSize;
  final NavigationStyle navigationStyle;
  final ToolbarMode? toolbarMode;
  final bool autoSaveEnabled;
  final bool autoBackupEnabled;
  final int autoSaveIntervalMinutes;
  final int autoBackupIntervalMinutes;
  final String? backupDirectory;
  final String displayName;
  final bool useAsDefaultPenName;

  OobePreferences copyWith({
    AppThemeMode? themeMode,
    Color? themeColor,
    AppThemePreset? themePreset,
    double? fontSize,
    NavigationStyle? navigationStyle,
    ToolbarMode? toolbarMode,
    bool clearToolbarMode = false,
    bool? autoSaveEnabled,
    bool? autoBackupEnabled,
    int? autoSaveIntervalMinutes,
    int? autoBackupIntervalMinutes,
    String? backupDirectory,
    bool clearBackupDirectory = false,
    String? displayName,
    bool? useAsDefaultPenName,
  }) => OobePreferences(
    themeMode: themeMode ?? this.themeMode,
    themeColor: themeColor ?? this.themeColor,
    themePreset: themePreset ?? this.themePreset,
    fontSize: fontSize ?? this.fontSize,
    navigationStyle: navigationStyle ?? this.navigationStyle,
    toolbarMode: clearToolbarMode ? null : toolbarMode ?? this.toolbarMode,
    autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
    autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
    autoSaveIntervalMinutes:
        autoSaveIntervalMinutes ?? this.autoSaveIntervalMinutes,
    autoBackupIntervalMinutes:
        autoBackupIntervalMinutes ?? this.autoBackupIntervalMinutes,
    backupDirectory: clearBackupDirectory
        ? null
        : backupDirectory ?? this.backupDirectory,
    displayName: displayName ?? this.displayName,
    useAsDefaultPenName: useAsDefaultPenName ?? this.useAsDefaultPenName,
  );
}
