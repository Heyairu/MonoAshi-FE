import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../bin/settings_manager.dart";
import "../../bin/ui_library.dart";
import "../../models/app_state_data.dart";
import "../../models/navigation_style.dart";
import "../../models/toolbar_mode.dart";
import "../../data/repositories/user_profile_repository.dart";
import "repository_providers.dart";
import "../../l10n/app_locale.dart";
import "../../l10n/app_formatters.dart";

export "../../models/app_state_data.dart";

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() => ref.read(userProfileRepositoryProvider).load();

  Future<void> save(UserProfile profile) async {
    await future;
    final normalized = profile.normalized;
    await ref.read(userProfileRepositoryProvider).save(normalized);
    state = AsyncData(normalized);
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
      UserProfileNotifier.new,
    );

/// A device-local presentation preference, independent of project state.
class ToolbarModeNotifier extends AsyncNotifier<ToolbarMode?> {
  @override
  Future<ToolbarMode?> build() async =>
      (await ref.read(settingsRepositoryProvider).load()).toolbarMode;

  Future<void> setMode(ToolbarMode? value) async {
    await future;
    state = AsyncData(value);
    await ref.read(settingsRepositoryProvider).saveToolbarMode(value);
  }
}

final toolbarModeProvider =
    AsyncNotifierProvider<ToolbarModeNotifier, ToolbarMode?>(
      ToolbarModeNotifier.new,
    );

class ThemeStateNotifier extends AsyncNotifier<AppThemeStateData> {
  @override
  Future<AppThemeStateData> build() async {
    final repository = ref.read(themeRepositoryProvider);
    final snapshot = await repository.load();
    return AppThemeStateData(
      themeMode: snapshot.themeMode,
      themeColor: snapshot.themeColor,
      themePreset: snapshot.themePreset,
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final current = state.valueOrNull ?? const AppThemeStateData();
    state = AsyncData(current.copyWith(themeMode: mode));
    await ref.read(themeRepositoryProvider).saveThemeMode(mode);
  }

  Future<void> setThemeColor(Color color) async {
    final current = state.valueOrNull ?? const AppThemeStateData();
    state = AsyncData(
      current.copyWith(themeColor: color, themePreset: AppThemePreset.standard),
    );
    await ref.read(themeRepositoryProvider).saveThemeColor(color);
    await ref
        .read(themeRepositoryProvider)
        .saveThemePreset(AppThemePreset.standard);
  }

  Future<void> setThemePreset(AppThemePreset preset) async {
    await future;
    final current = state.requireValue;
    state = AsyncData(current.copyWith(themePreset: preset));
    await ref.read(themeRepositoryProvider).saveThemePreset(preset);
  }

  Future<void> toggleTheme() async {
    final current = state.valueOrNull ?? const AppThemeStateData();
    switch (current.themeMode) {
      case AppThemeMode.light:
        await setThemeMode(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        await setThemeMode(AppThemeMode.system);
        break;
      case AppThemeMode.system:
        await setThemeMode(AppThemeMode.light);
        break;
    }
  }
}

class SettingsStateNotifier extends AsyncNotifier<AppSettingsStateData> {
  static const int _maxRecentProjects = 10;
  Future<void> _localeSaveTail = Future<void>.value();
  AppLocalePreference? _persistedLocale;
  int _localeRequestId = 0;

  @override
  Future<AppSettingsStateData> build() async {
    final repository = ref.read(settingsRepositoryProvider);
    final snapshot = await repository.load();

    _persistedLocale = snapshot.appLocale;

    return AppSettingsStateData(
      appLocale: snapshot.appLocale,
      navigationStyle: snapshot.navigationStyle,
      showExitWarning: snapshot.showExitWarning,
      fontSize: snapshot.fontSize,
      wordCountMode: snapshot.wordCountMode,
      autoSaveEnabled: snapshot.autoSaveEnabled,
      autoSaveIntervalMinutes: snapshot.autoSaveIntervalMinutes,
      autoBackupEnabled: snapshot.autoBackupEnabled,
      autoBackupIntervalMinutes: snapshot.autoBackupIntervalMinutes,
      autoBackupMaxSizeMb: snapshot.autoBackupMaxSizeMb,
      allowSingleDevicePairingConfirmation:
          snapshot.allowSingleDevicePairingConfirmation,
      allowPersistentP2pVerification: snapshot.allowPersistentP2pVerification,
      poppinEnabled: snapshot.poppinEnabled,
      overwriteModeEnabled: snapshot.overwriteModeEnabled,
      tabSpaceCount: snapshot.tabSpaceCount,
      tabFullWidth: snapshot.tabFullWidth,
      autoIndentLineStart: snapshot.autoIndentLineStart,
      recentProjects: snapshot.recentProjects,
    );
  }

  /// Apply immediately, serialize writes, and roll back only the latest
  /// selection to the last successfully persisted preference on failure.
  Future<void> setAppLocale(AppLocalePreference value) async {
    await future;
    final requestId = ++_localeRequestId;
    state = AsyncData(state.requireValue.copyWith(appLocale: value));
    final result = _localeSaveTail.then((_) async {
      try {
        await ref.read(settingsRepositoryProvider).saveAppLocale(value);
        _persistedLocale = value;
      } catch (_) {
        if (requestId == _localeRequestId) {
          state = AsyncData(
            state.requireValue.copyWith(
              appLocale: _persistedLocale ?? AppLocalePreference.system,
            ),
          );
        }
        rethrow;
      }
    });
    // A failed write must not poison the queue for the next selection.
    _localeSaveTail = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    await result;
  }

  Future<void> setShowExitWarning(bool value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(showExitWarning: value));
    await ref.read(settingsRepositoryProvider).saveShowExitWarning(value);
  }

  Future<void> setNavigationStyle(NavigationStyle value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(navigationStyle: value));
    await ref.read(settingsRepositoryProvider).saveNavigationStyle(value);
  }

  Future<void> setFontSize(double value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(fontSize: value));
    await ref.read(settingsRepositoryProvider).saveFontSize(value);
  }

  Future<void> setWordCountMode(WordCountMode value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(wordCountMode: value));
    await ref.read(settingsRepositoryProvider).saveWordCountMode(value);
  }

  Future<void> setAutoSaveEnabled(bool value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(autoSaveEnabled: value));
    await ref.read(settingsRepositoryProvider).saveAutoSaveEnabled(value);
  }

  Future<void> setAutoSaveIntervalMinutes(int value) async {
    final normalized = value.clamp(1, 120);
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(autoSaveIntervalMinutes: normalized));
    await ref
        .read(settingsRepositoryProvider)
        .saveAutoSaveIntervalMinutes(normalized);
  }

  Future<void> setAutoBackupEnabled(bool value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(autoBackupEnabled: value));
    await ref.read(settingsRepositoryProvider).saveAutoBackupEnabled(value);
  }

  Future<void> setAutoBackupIntervalMinutes(int value) async {
    final normalized = value.clamp(1, 120);
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(autoBackupIntervalMinutes: normalized));
    await ref
        .read(settingsRepositoryProvider)
        .saveAutoBackupIntervalMinutes(normalized);
  }

  Future<void> setAutoBackupMaxSizeMb(int value) async {
    final normalized = value.clamp(16, 10240);
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(autoBackupMaxSizeMb: normalized));
    await ref
        .read(settingsRepositoryProvider)
        .saveAutoBackupMaxSizeMb(normalized);
  }

  Future<void> setAllowSingleDevicePairingConfirmation(bool value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(
      current.copyWith(allowSingleDevicePairingConfirmation: value),
    );
    await ref
        .read(settingsRepositoryProvider)
        .saveAllowSingleDevicePairingConfirmation(value);
  }

  Future<void> setAllowPersistentP2pVerification(bool value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(allowPersistentP2pVerification: value));
    await ref
        .read(settingsRepositoryProvider)
        .saveAllowPersistentP2pVerification(value);
  }

  Future<void> setPoppinEnabled(bool value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(poppinEnabled: value));
    await ref.read(settingsRepositoryProvider).savePoppinEnabled(value);
  }

  Future<void> setOverwriteModeEnabled(bool value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(overwriteModeEnabled: value));
    if (!value) ref.read(editorOverwriteProvider.notifier).state = false;
    await ref.read(settingsRepositoryProvider).saveOverwriteModeEnabled(value);
  }

  Future<void> setTabSpaceCount(int value) async {
    final count = value.clamp(1, 8);
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(tabSpaceCount: count));
    await ref.read(settingsRepositoryProvider).saveTabSpaceCount(count);
  }

  Future<void> setTabFullWidth(bool value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(tabFullWidth: value));
    await ref.read(settingsRepositoryProvider).saveTabFullWidth(value);
  }

  Future<void> setAutoIndentLineStart(bool value) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    state = AsyncData(current.copyWith(autoIndentLineStart: value));
    await ref.read(settingsRepositoryProvider).saveAutoIndentLineStart(value);
  }

  Future<void> addRecentProject({
    required String fileName,
    String? filePath,
    String? uri,
  }) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    if (fileName.trim().isEmpty) {
      return;
    }

    final entry = RecentProjectEntry(
      fileName: fileName.trim(),
      filePath: filePath?.trim().isNotEmpty == true ? filePath!.trim() : null,
      uri: uri?.trim().isNotEmpty == true ? uri!.trim() : null,
      lastOpenedAtMillis: DateTime.now().millisecondsSinceEpoch,
    );

    final merged = [
      entry,
      ...current.recentProjects.where(
        (item) => item.identityKey != entry.identityKey,
      ),
    ];
    final nextRecentProjects = merged.take(_maxRecentProjects).toList();

    state = AsyncData(current.copyWith(recentProjects: nextRecentProjects));
    await ref
        .read(settingsRepositoryProvider)
        .saveRecentProjects(nextRecentProjects);
  }

  Future<void> removeRecentProject(RecentProjectEntry entry) async {
    final current = state.valueOrNull ?? const AppSettingsStateData();
    final nextRecentProjects = current.recentProjects
        .where((item) => item.identityKey != entry.identityKey)
        .toList();

    state = AsyncData(current.copyWith(recentProjects: nextRecentProjects));
    await ref
        .read(settingsRepositoryProvider)
        .saveRecentProjects(nextRecentProjects);
  }
}

final themeStateProvider =
    AsyncNotifierProvider<ThemeStateNotifier, AppThemeStateData>(
      ThemeStateNotifier.new,
    );

// Session state: retained across chapters, reset when the app restarts.
final editorOverwriteProvider = StateProvider<bool>((ref) => false);
final editorEffectiveOverwriteProvider = Provider<bool>((ref) {
  final enabled =
      ref.watch(settingsStateProvider).valueOrNull?.overwriteModeEnabled ??
      true;
  return enabled && ref.watch(editorOverwriteProvider);
});

final settingsStateProvider =
    AsyncNotifierProvider<SettingsStateNotifier, AppSettingsStateData>(
      SettingsStateNotifier.new,
    );

@immutable
class AppThemeSettings {
  final Color color;
  final AppThemeMode mode;
  final AppThemePreset preset;
  final double fontSize;

  const AppThemeSettings({
    required this.color,
    required this.mode,
    this.preset = AppThemePreset.standard,
    required this.fontSize,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppThemeSettings &&
            other.color == color &&
            other.mode == mode &&
            other.preset == preset &&
            other.fontSize == fontSize;
  }

  @override
  int get hashCode => Object.hash(color, mode, preset, fontSize);
}

final appThemeSettingsProvider = Provider<AppThemeSettings>((ref) {
  final theme = ref.watch(
    themeStateProvider.select(
      (state) => state.valueOrNull ?? const AppThemeStateData(),
    ),
  );
  final fontSize = ref.watch(
    settingsStateProvider.select(
      (state) => state.valueOrNull?.fontSize ?? 14.0,
    ),
  );

  return AppThemeSettings(
    color: theme.themeColor,
    mode: theme.themeMode,
    preset: theme.themePreset,
    fontSize: fontSize,
  );
});

final appInitializationProvider = FutureProvider<void>((ref) async {
  await Future.wait([
    AppFormatters.initialize(),
    // Bootstrap should only await initial load; later updates should not
    // re-enter app-level loading and replace the whole UI tree.
    ref.read(themeStateProvider.future),
    ref.read(settingsStateProvider.future),
    ref.read(toolbarModeProvider.future),
    ref.read(userProfileProvider.future),
  ]);
});
