import 'package:monogatari_assistant/l10n/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/providers/global_state_providers.dart';
import '../../data/repositories/storage_preferences_repository.dart';
import '../../data/repositories/user_profile_repository.dart';
import 'oobe_screen.dart';
import 'oobe_state.dart';
import 'oobe_intro.dart';

/// Keeps the editor (and queued external project opens) unmounted until setup
/// finishes. No completion flag is written merely by viewing or bypassing it.
class OobeGate extends ConsumerStatefulWidget {
  const OobeGate({
    super.key,
    required this.builder,
    this.options = const OobeLaunchOptions(),
  });

  final WidgetBuilder builder;
  final OobeLaunchOptions options;

  @override
  ConsumerState<OobeGate> createState() => _OobeGateState();
}

class _OobeGateState extends ConsumerState<OobeGate> {
  bool _finished = false;

  Future<void> _complete(OobePreferences preferences) async {
    final settings = ref.read(settingsStateProvider.notifier);
    final theme = ref.read(themeStateProvider.notifier);
    await theme.setThemeMode(preferences.themeMode);
    await theme.setThemeColor(preferences.themeColor);
    await theme.setThemePreset(preferences.themePreset);
    await settings.setFontSize(preferences.fontSize);
    await settings.setNavigationStyle(preferences.navigationStyle);
    await ref
        .read(toolbarModeProvider.notifier)
        .setMode(preferences.toolbarMode);
    await settings.setAutoSaveEnabled(preferences.autoSaveEnabled);
    await settings.setAutoSaveIntervalMinutes(
      preferences.autoSaveIntervalMinutes,
    );
    await settings.setAutoBackupEnabled(preferences.autoBackupEnabled);
    await settings.setAutoBackupIntervalMinutes(
      preferences.autoBackupIntervalMinutes,
    );
    await ref
        .read(storagePreferencesRepositoryProvider)
        .save(StorageDirectories(backupDirectory: preferences.backupDirectory));
    ref.invalidate(storageDirectoriesProvider);
    await ref
        .read(userProfileProvider.notifier)
        .save(
          UserProfile(
            displayName: preferences.displayName,
            useAsDefaultPenName: preferences.useAsDefaultPenName,
          ),
        );
    // Write last: a failed settings write must leave setup available to retry.
    await ref.read(oobeRepositoryProvider).complete();
    ref.invalidate(oobeCompletedProvider);
    if (mounted) setState(() => _finished = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_finished || widget.options.bypass) return widget.builder(context);

    final completed = ref.watch(oobeCompletedProvider);
    if (completed.hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.uiCouldNotReadInitialSetupPleaseTryAgain),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(oobeCompletedProvider),
                child: Text(context.l10n.commonRetry),
              ),
            ],
          ),
        ),
      );
    }
    if (!completed.hasValue) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!widget.options.shouldShow(completed: completed.requireValue)) {
      return widget.builder(context);
    }

    final directories = ref.watch(storageDirectoriesProvider);
    if (directories.hasError) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => ref.invalidate(storageDirectoriesProvider),
            child: Text(context.l10n.uiCouldNotReadTheBackupLocationSelectTo),
          ),
        ),
      );
    }
    if (!directories.hasValue) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final storage = ref.read(storagePreferencesRepositoryProvider);

    return OobeIntro(
      createController: ref.read(oobeIntroControllerFactoryProvider),
      child: OobeScreen(
        initialPreferences: OobePreferences.fromSettings(
          ref.read(settingsStateProvider).requireValue,
          ref.read(themeStateProvider).requireValue,
          directories: directories.requireValue,
          toolbarMode: ref.read(toolbarModeProvider).requireValue,
          profile: ref.read(userProfileProvider).requireValue,
        ),
        selectDirectory: storage.supportsDirectorySelection
            ? ({required title, initialDirectory}) => storage.pickDirectory(
                title: title,
                initialDirectory: initialDirectory,
              )
            : null,
        onComplete: _complete,
      ),
    );
  }
}
