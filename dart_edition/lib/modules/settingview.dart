/************************************************************
 * 
 * Copyright 2025-2026 Heyairu（部屋伊琉）
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 ************************************************************/

import "../features/help/help_scope.dart";
import "../features/help/help_topic.dart";
import "dart:async";

import "package:flutter/material.dart";
import "../features/inline_annotations/alias_mention_updates.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../bin/file.dart" show AutoBackupDirectoryInfo;
import "../bin/ui_library.dart";
import "../bin/settings_manager.dart";
import "../models/navigation_style.dart";
import "../models/toolbar_mode.dart";
import "../presentation/widgets/settings/settings_cards.dart";
import "../presentation/widgets/writing_goal_dialog.dart";
import "../presentation/widgets/settings/settings_color_picker.dart";
import "../presentation/widgets/settings/settings_mode_preview.dart";
import "../presentation/providers/core_providers.dart";
import "../presentation/providers/global_state_providers.dart";
import "../presentation/providers/mcp_providers.dart";
import "../presentation/providers/p2p_sync_providers.dart";
import "../features/mcp/application/mcp_bridge_server.dart";
import "../services/android_background_execution.dart";
import "../l10n/app_localization.dart";
import "../presentation/widgets/settings/app_language_selector.dart";

class SettingView extends ConsumerStatefulWidget {
  const SettingView({super.key});

  @override
  ConsumerState<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends ConsumerState<SettingView>
    with WidgetsBindingObserver {
  late Future<AutoBackupDirectoryInfo> _autoBackupDirectoryInfoFuture;
  bool _isBatteryOptimizationExempt = false;
  bool _isLoadingBackgroundPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _autoBackupDirectoryInfoFuture = _loadAutoBackupDirectoryInfo();
    _refreshBackgroundExecutionPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshBackgroundExecutionPermission();
      return;
    }
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      unawaited(ref.read(mcpBridgeProvider.notifier).stop());
    }
  }

  Future<void> _refreshBackgroundExecutionPermission() async {
    if (!AndroidBackgroundExecution.isSupported) return;
    try {
      final isExempt =
          await AndroidBackgroundExecution.isBatteryOptimizationExempt();
      if (mounted) {
        setState(() => _isBatteryOptimizationExempt = isExempt);
      }
    } on PlatformException {
      // The action button will provide a user-visible error if the platform
      // cannot service the request.
    }
  }

  Future<void> _requestBackgroundExecutionPermission() async {
    if (_isLoadingBackgroundPermission) return;
    setState(() => _isLoadingBackgroundPermission = true);
    try {
      await AndroidBackgroundExecution.requestBatteryOptimizationExemption();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.uiAllowUnrestrictedBatteryUsageInTheSystemPrompt,
          ),
        ),
      );
    } on PlatformException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message ??
                context.l10n.uiCouldNotOpenBackgroundExecutionPermissions,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingBackgroundPermission = false);
      }
    }
  }

  Future<void> _copyMcpHostConfiguration() async {
    try {
      final configuration = await ref
          .read(mcpBridgeProvider.notifier)
          .hostConfiguration();
      await Clipboard.setData(ClipboardData(text: configuration));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.uiMCPHostConfigurationCopiedPasteItIntoYour,
          ),
        ),
      );
    } on StateError catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message.toString())));
    }
  }

  Future<AutoBackupDirectoryInfo> _loadAutoBackupDirectoryInfo() {
    return ref.read(projectFileUseCaseProvider).getAutoBackupDirectoryInfo();
  }

  void _refreshAutoBackupDirectoryInfo() {
    setState(() {
      _autoBackupDirectoryInfoFuture = _loadAutoBackupDirectoryInfo();
    });
  }

  ({AppThemeMode themeMode, Color themeColor, AppThemePreset themePreset})
  get _themeViewState => ref.watch(
    themeStateProvider.select((state) {
      final theme = state.valueOrNull;
      return (
        themeMode: theme?.themeMode ?? AppThemeMode.system,
        themeColor: theme?.themeColor ?? Colors.lightBlue,
        themePreset: theme?.themePreset ?? AppThemePreset.standard,
      );
    }),
  );

  ({
    bool showExitWarning,
    double fontSize,
    WordCountMode wordCountMode,
    bool autoSaveEnabled,
    int autoSaveIntervalMinutes,
    bool autoBackupEnabled,
    int autoBackupIntervalMinutes,
    int autoBackupMaxSizeMb,
    bool allowSingleDevicePairingConfirmation,
    bool allowPersistentP2pVerification,
    bool poppinEnabled,
  })
  get _settingsViewState => ref.watch(
    settingsStateProvider.select((state) {
      final settings = state.valueOrNull;
      return (
        showExitWarning: settings?.showExitWarning ?? true,
        fontSize: settings?.fontSize ?? 14.0,
        wordCountMode:
            settings?.wordCountMode ?? WordCountMode.wordsAndCharacters,
        autoSaveEnabled: settings?.autoSaveEnabled ?? false,
        autoSaveIntervalMinutes: settings?.autoSaveIntervalMinutes ?? 5,
        autoBackupEnabled: settings?.autoBackupEnabled ?? false,
        autoBackupIntervalMinutes: settings?.autoBackupIntervalMinutes ?? 5,
        autoBackupMaxSizeMb: settings?.autoBackupMaxSizeMb ?? 512,
        allowSingleDevicePairingConfirmation:
            settings?.allowSingleDevicePairingConfirmation ?? true,
        allowPersistentP2pVerification:
            settings?.allowPersistentP2pVerification ?? false,
        poppinEnabled: settings?.poppinEnabled ?? true,
      );
    }),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPageScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: LargeTitle(
                icon: Icons.settings,
                text: context.l10n.settingsTitle,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.settingsDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SettingsSectionCard(
              id: "appearance",
              title: context.l10n.uiAppearanceAndInterface,
              subtitle: context.l10n.uiThemeNavigationToolbarAndFonts,
              icon: Icons.palette_outlined,
              initiallyExpanded: true,
              children: [
                _buildThemeModeSetting(),
                _buildNavigationStyleSetting(),
                HelpTarget(
                  topicId: HelpTopicId.toolbarMode,
                  child: _buildToolbarModeSetting(),
                ),
                _buildFontSizeSetting(),
                _buildColorSetting(),
                _buildThemePreview(),
                _buildPlaceholderSetting(
                  context.l10n.uiCustomizeToolbarItems,
                  Icons.bento_outlined,
                ),
              ],
            ),
            SettingsSectionCard(
              id: "editing",
              title: context.l10n.uiEditingAndInput,
              subtitle: context
                  .l10n
                  .uiSmartSuggestionsOverwriteIndentationAndWordCount,
              icon: Icons.edit_note_outlined,
              children: [_buildEditingSettings()],
            ),
            SettingsSectionCard(
              id: 'writing-goals',
              title: context.l10n.uiWritingGoals,
              subtitle:
                  context.l10n.uiDailyProgressAndDefaultChapterAndProjectGoals,
              icon: Icons.flag_outlined,
              children: [WritingGoalSettings()],
            ),
            SettingsSectionCard(
              id: "storage",
              title: context.l10n.uiSavingAndBackups,
              subtitle: context.l10n.uiAutosaveBackupScheduleAndStorageLimits,
              icon: Icons.save_outlined,
              children: [
                HelpTarget(
                  topicId: HelpTopicId.autoSave,
                  child: _buildAutoSaveSetting(),
                ),
                HelpTarget(
                  topicId: HelpTopicId.backup,
                  child: _buildAutoBackupSetting(),
                ),
              ],
            ),
            SettingsSectionCard(
              id: "sync",
              title: context.l10n.uiSyncAndConnections,
              subtitle: context
                  .l10n
                  .uiDevicePairingPersistentAuthenticationAndBackgroundExecution,
              icon: Icons.sync_outlined,
              children: [
                _buildP2pSyncSetting(),
                _buildAndroidBackgroundExecutionSetting(),
              ],
            ),
            SettingsSectionCard(
              id: "general",
              title: context.l10n.generalSettingsTitle,
              subtitle: context.l10n.generalSettingsDescription,
              icon: Icons.tune_outlined,
              children: [
                SwitchWithIconTitle(
                  title: context.l10n.exitWarningTitle,
                  icon: Icons.warning,
                  subtitle: context.l10n.exitWarningDescription,
                  value: _settingsViewState.showExitWarning,
                  onChanged: (value) async {
                    await ref
                        .read(settingsStateProvider.notifier)
                        .setShowExitWarning(value);
                  },
                ),

                const AppLanguageSelector(),
              ],
            ),
            SettingsSectionCard(
              id: "integrations",
              title: context.l10n.uiExternalIntegrations,
              subtitle: context.l10n.uiReadOnlyMCPProjectAccessAndAuthorization,
              icon: Icons.hub_outlined,
              children: [_buildMcpSetting()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditingSettings() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SwitchWithIconTitle(
        key: const Key("poppin-enabled-setting"),
        title: context.l10n.uiEnablePoppinIntelliSense,
        icon: Icons.auto_awesome_outlined,
        subtitle: context.l10n.uiShowSuggestionsNearTheCursorWhenEnteringA,
        value: _settingsViewState.poppinEnabled,
        onChanged: (value) async {
          await ref
              .read(settingsStateProvider.notifier)
              .setPoppinEnabled(value);
        },
      ),
      const SizedBox(height: 16),
      SwitchWithIconTitle(
        key: const Key("overwrite-mode-enabled-setting"),
        title: context.l10n.uiEnableOverwriteMode,
        icon: Icons.edit_outlined,
        subtitle: context.l10n.uiUseInsOrTheStatusBarToToggle,
        value:
            ref
                .watch(settingsStateProvider)
                .valueOrNull
                ?.overwriteModeEnabled ??
            true,
        onChanged: (value) => ref
            .read(settingsStateProvider.notifier)
            .setOverwriteModeEnabled(value),
      ),
      const SizedBox(height: 16),
      Text(
        context.l10n.uiSpacesAndIndentation,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      ListTile(
        title: Text(context.l10n.uiSpacesPerTab),
        subtitle: Text(context.l10n.uiNumberOfSpacesInsertedByTabOrAutomatic),
        trailing: DropdownButton<int>(
          key: const Key("tab-space-count-setting"),
          value:
              ref.watch(settingsStateProvider).valueOrNull?.tabSpaceCount ?? 2,
          items: [
            for (var count = 1; count <= 8; count++)
              DropdownMenuItem(value: count, child: Text("$count")),
          ],
          onChanged: (value) {
            if (value != null) {
              ref.read(settingsStateProvider.notifier).setTabSpaceCount(value);
            }
          },
        ),
      ),
      SwitchWithIconTitle(
        key: const Key("tab-full-width-setting"),
        title: context.l10n.uiUseFullWidthSpaces,
        icon: Icons.space_bar,
        subtitle: context.l10n.uiUseHalfWidthSpacesWhenDisabled,
        value:
            ref.watch(settingsStateProvider).valueOrNull?.tabFullWidth ?? true,
        onChanged: (value) =>
            ref.read(settingsStateProvider.notifier).setTabFullWidth(value),
      ),
      const SizedBox(height: 8),
      SwitchWithIconTitle(
        key: const Key("auto-indent-line-start-setting"),
        title: context.l10n.uiAutomaticallyIndentNewLines,
        icon: Icons.keyboard_return,
        subtitle:
            context.l10n.uiInsertConfiguredSpacesAfterEnterShiftEnterInserts,
        value:
            ref.watch(settingsStateProvider).valueOrNull?.autoIndentLineStart ??
            false,
        onChanged: (value) => ref
            .read(settingsStateProvider.notifier)
            .setAutoIndentLineStart(value),
      ),
      const SizedBox(height: 16),
      _buildWordCountSetting(),
      const SizedBox(height: 16),
      SwitchWithIconTitle(
        key: const Key("alias-mention-updates-setting"),
        title: context.l10n.uiUpdateManuscriptMentionsWhenAliasesChange,
        icon: Icons.sync,
        subtitle: context.l10n.uiUpdateMarkersForTheSameCharacterWhoseDisplay,
        value:
            ref.watch(aliasMentionUpdatesEnabledProvider).valueOrNull ?? true,
        onChanged: (value) => ref
            .read(aliasMentionUpdatesEnabledProvider.notifier)
            .setEnabled(value),
      ),
      const SizedBox(height: 16),
    ],
  );

  Widget _buildMcpSetting() {
    final bridge = ref.watch(mcpBridgeProvider);
    final notifier = ref.read(mcpBridgeProvider.notifier);
    final active = bridge.status == McpBridgeStatus.active;
    final busy = bridge.status == McpBridgeStatus.starting;
    final status = switch (bridge.status) {
      McpBridgeStatus.stopped => context.l10n.uiDisabled2,
      McpBridgeStatus.starting => context.l10n.uiCreatingLocalAuthorization,
      McpBridgeStatus.active => context.l10n.uiAuthorizedLocalReadOnly(
        (bridge.projectTitle ?? context.l10n.uiCurrentProject).toString(),
      ),
      McpBridgeStatus.expired => context.l10n.uiAuthorizationExpired,
      McpBridgeStatus.failed => bridge.failure ?? context.l10n.uiCouldNotEnable,
    };
    return Semantics(
      container: true,
      label: context.l10n.uiReadOnlyMCPIntegration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchWithIconTitle(
            key: const Key("mcp-readonly-setting"),
            title: context.l10n.uiReadOnlyMCPIntegration,
            icon: Icons.hub_outlined,
            subtitle: context.l10n
                .uiExposeOnlyTheAuthorizedProjectSSummaryChapters(
                  (status).toString(),
                ),
            value: active,
            onChanged: (value) async {
              if (busy || !notifier.isDesktopSupported) return;
              await (value ? notifier.enable() : notifier.stop());
            },
          ),
          if (!notifier.isDesktopSupported)
            Padding(
              padding: EdgeInsets.only(left: 56, top: AppSpacing.xs),
              child: Text(
                context.l10n.uiTheMCPSidecarSupportsWindowsMacOSAndLinux,
              ),
            ),
          if (active)
            Padding(
              padding: const EdgeInsets.only(left: 56, top: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (bridge.descriptorAvailable &&
                      bridge.descriptorPath != null) ...[
                    SelectableText(
                      context.l10n.uiConnectionConfiguration(
                        (bridge.descriptorPath).toString(),
                      ),
                      key: const Key("mcp-descriptor-path"),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                  ] else
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text(
                        context.l10n.uiAnMCPHostHasClaimedTheOneTime,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (bridge.descriptorAvailable)
                        FilledButton.tonalIcon(
                          key: const Key("mcp-copy-host-configuration"),
                          onPressed: _copyMcpHostConfiguration,
                          icon: const Icon(Icons.copy_outlined),
                          label: Text(context.l10n.uiCopyMCPHostConfiguration),
                        ),
                      FilledButton.tonalIcon(
                        key: const Key("mcp-stop-session"),
                        onPressed: notifier.stop,
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: Text(context.l10n.uiStopCurrentAuthorization),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildP2pSyncSetting() {
    return Column(
      children: [
        SwitchWithIconTitle(
          key: const Key("p2p-single-device-confirmation-setting"),
          title: context.l10n.uiAllowOneSidedPairingConfirmation,
          icon: Icons.phonelink_lock_outlined,
          subtitle: context.l10n.uiRequiresBothDevicesToEnableThisOptionAfter,
          value: _settingsViewState.allowSingleDevicePairingConfirmation,
          onChanged: (value) async {
            await ref
                .read(settingsStateProvider.notifier)
                .setAllowSingleDevicePairingConfirmation(value);
            ref.read(p2pSyncProvider.notifier).handlePairingPreferenceChanged();
          },
        ),
        SwitchWithIconTitle(
          key: const Key("p2p-persistent-verification-setting"),
          title: context.l10n.uiPersistentAuthenticationDays,
          icon: Icons.verified_user_outlined,
          subtitle:
              context.l10n.uiRequiresBothDevicesToEnableThisOptionAuthenticate,
          value: _settingsViewState.allowPersistentP2pVerification,
          onChanged: (value) async {
            await ref
                .read(settingsStateProvider.notifier)
                .setAllowPersistentP2pVerification(value);
            ref.read(p2pSyncProvider.notifier).handlePairingPreferenceChanged();
          },
        ),
      ],
    );
  }

  Widget _buildAndroidBackgroundExecutionSetting() {
    if (!AndroidBackgroundExecution.isSupported) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          _isBatteryOptimizationExempt
              ? Icons.battery_full_outlined
              : Icons.battery_saver_outlined,
        ),
        title: Text(context.l10n.uiAllowBackgroundExecution),
        subtitle: Text(
          _isBatteryOptimizationExempt
              ? context.l10n.uiUnrestrictedBatteryUsageIsAllowed
              : context.l10n.uiReduceTheChanceOfTheSystemSuspendingActive,
        ),
        trailing: FilledButton(
          onPressed:
              _isBatteryOptimizationExempt || _isLoadingBackgroundPermission
              ? null
              : _requestBackgroundExecutionPermission,
          child: _isLoadingBackgroundPermission
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  _isBatteryOptimizationExempt
                      ? context.l10n.uiAllowed
                      : context.l10n.uiAllow,
                ),
        ),
      ),
    );
  }

  // MARK: - 字體大小設定
  Widget _buildFontSizeSetting() {
    return LabeledSlider(
      title: context.l10n.uiFontSize,
      icon: Icons.text_fields,
      value: _settingsViewState.fontSize,
      min: 12,
      max: 20,
      divisions: 8,
      valueLabelBuilder: (value) => "${value.toInt()} sp",
      onChanged: (value) async {
        await ref.read(settingsStateProvider.notifier).setFontSize(value);
      },
    );
  }

  // MARK: - 主題顏色設定
  Widget _buildColorSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.uiThemeColor2,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SettingsColorPicker(
          selectedColor: _themeViewState.themeColor,
          preset: _themeViewState.themePreset,
          onPresetChanged: ref.read(themeStateProvider.notifier).setThemePreset,
          onChanged: (color) =>
              ref.read(themeStateProvider.notifier).setThemeColor(color),
        ),
      ],
    );
  }

  Widget _buildNavigationStyleSetting() {
    final style = ref.watch(
      settingsStateProvider.select(
        (state) =>
            state.valueOrNull?.navigationStyle ?? NavigationStyle.railLabel,
      ),
    );
    final labels = {
      NavigationStyle.railTooltip: context.l10n.uiIconsOnly,
      NavigationStyle.railLabel: context.l10n.uiIconsAndLabels,
      NavigationStyle.railButtonDrawer: context.l10n.uiExpandOnClick,
      NavigationStyle.railHoverDrawer: context.l10n.uiExpandOnHover,
    };
    return Column(
      key: const Key("navigation-style-setting"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.uiNavigationStyle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SettingsModePicker(
          compactRow: true,
          options: [
            for (final option in NavigationStyle.values)
              SettingsModeOption(
                id: "navigation-${option.name}",
                label: labels[option]!,
                description: context.l10n.legacyLabel(option.description),
                preview: SettingsModePreview(
                  accent: _themeViewState.themePreset.accent(
                    _themeViewState.themeColor,
                  ),
                  navigationStyle: option,
                ),
                selected: style == option,
                onSelected: () => ref
                    .read(settingsStateProvider.notifier)
                    .setNavigationStyle(option),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.legacyLabel(style.description),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.uiHomeStaysAtTheTopSettingsAndAbout,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildToolbarModeSetting() {
    final preference = ref.watch(
      toolbarModeProvider.select((state) => state.valueOrNull),
    );
    final resolved =
        preference ?? ToolbarMode.defaultFor(Theme.of(context).platform);
    return Column(
      key: const Key("toolbar-mode-setting"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.uiToolbarMode,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SettingsModePicker(
          compactRow: true,
          options: [
            for (final mode in [...ToolbarMode.values, null])
              SettingsModeOption(
                id: "toolbar-${mode?.name ?? 'automatic'}",
                label: mode?.label ?? context.l10n.uiAutomatic3,
                description:
                    (mode == null
                        ? null
                        : context.l10n.legacyLabel(mode.description)) ??
                    context.l10n.uiChooseByDeviceFullOnDesktopModerateOn,
                preview: SettingsModePreview(
                  accent: _themeViewState.themePreset.accent(
                    _themeViewState.themeColor,
                  ),
                  toolbarMode: mode,
                ),
                selected: preference == mode,
                onSelected: () =>
                    ref.read(toolbarModeProvider.notifier).setMode(mode),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          preference == null
              ? context.l10n.uiAutomaticallyUsing(
                  (resolved.label).toString(),
                  (context.l10n.legacyLabel(resolved.description)).toString(),
                )
              : context.l10n.legacyLabel(resolved.description),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildThemeModeSetting() {
    final labels = {
      AppThemeMode.light: context.l10n.uiLight,
      AppThemeMode.dark: context.l10n.uiDark,
      AppThemeMode.system: context.l10n.uiAutomatic3,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.uiThemeMode,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        SettingsModePicker(
          options: [
            for (final mode in AppThemeMode.values)
              SettingsModeOption(
                id: "theme-${mode.name}",
                label: labels[mode]!,
                description: mode == AppThemeMode.system
                    ? context.l10n.uiFollowTheSystemSLightOrDarkAppearance
                    : context.l10n.uiUseAppearance((labels[mode]).toString()),
                preview: SettingsModePreview(
                  accent: _themeViewState.themePreset.accent(
                    _themeViewState.themeColor,
                  ),
                  themeMode: mode,
                ),
                selected: _themeViewState.themeMode == mode,
                onSelected: () =>
                    ref.read(themeStateProvider.notifier).setThemeMode(mode),
              ),
          ],
        ),
      ],
    );
  }

  // MARK: - 主題預覽
  Widget _buildThemePreview() {
    final colorScheme = Theme.of(context).colorScheme;
    final isSystemDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final isDark =
        _themeViewState.themeMode == AppThemeMode.dark ||
        (_themeViewState.themeMode == AppThemeMode.system && isSystemDark);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 當前模式指示
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                size: _settingsViewState.fontSize + 6,
                color: colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.uiCurrentlyUsingMode(
                  (isDark ? context.l10n.uiDark : context.l10n.uiLight)
                      .toString(),
                ),
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // MARK: - 字數計算模式設定
  Widget _buildWordCountSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.formPadding,
          child: Row(
            children: [
              Icon(Icons.numbers, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.uiWordCountMode,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    _settingsViewState.wordCountMode == WordCountMode.characters
                        ? context.l10n.uiCharacterCountNotRecommended
                        : context.l10n.uiFullWidthCharactersHalfWidthWords,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AppDropdownField<WordCountMode>(
          value: _settingsViewState.wordCountMode,
          labelText: context.l10n.uiWordCountMode,
          options: [
            DropdownOption<WordCountMode>(
              value: WordCountMode.characters,
              label: context.l10n.uiCharactersNotRecommended,
            ),
            DropdownOption<WordCountMode>(
              value: WordCountMode.wordsAndCharacters,
              label: context.l10n.uiMixedMode,
            ),
          ],
          onChanged: (value) async {
            if (value == null) return;
            await ref
                .read(settingsStateProvider.notifier)
                .setWordCountMode(value);
          },
        ),
      ],
    );
  }

  // MARK: - 自動儲存設定
  Widget _buildAutoSaveSetting() {
    final enabled = _settingsViewState.autoSaveEnabled;
    final interval = _settingsViewState.autoSaveIntervalMinutes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchWithIconTitle(
          title: context.l10n.uiAutoSave,
          icon: Icons.save,
          subtitle: context.l10n.uiSaveOnAScheduleRequiresAnExistingFile,
          value: enabled,
          onChanged: (value) async {
            await ref
                .read(settingsStateProvider.notifier)
                .setAutoSaveEnabled(value);
          },
        ),
        Opacity(
          opacity: enabled ? 1 : 0.5,
          child: IgnorePointer(
            ignoring: !enabled,
            child: LabeledSlider(
              title: context.l10n.uiSaveInterval,
              icon: Icons.timer,
              value: interval.toDouble(),
              min: 0,
              max: 120,
              divisions: 24,
              layout: LabeledSliderLayout.stacked,
              valueLabelBuilder: (value) => context.l10n.uiMinutes(
                context.formats.integer(value.round()),
              ),
              onChanged: (value) async {
                await ref
                    .read(settingsStateProvider.notifier)
                    .setAutoSaveIntervalMinutes(value.round());
              },
            ),
          ),
        ),
      ],
    );
  }

  // MARK: - AutoBackup 設定
  Widget _buildAutoBackupSetting() {
    final enabled = _settingsViewState.autoBackupEnabled;
    final interval = _settingsViewState.autoBackupIntervalMinutes;
    final maxSizeMb = _settingsViewState.autoBackupMaxSizeMb;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchWithIconTitle(
          title: context.l10n.uiAutomaticBackup,
          icon: Icons.backup,
          subtitle: context
              .l10n
              .uiCreateScheduledProjectBackupsWithoutOverwritingTheOriginal,
          value: enabled,
          onChanged: (value) async {
            await ref
                .read(settingsStateProvider.notifier)
                .setAutoBackupEnabled(value);
          },
        ),
        Opacity(
          opacity: enabled ? 1 : 0.5,
          child: IgnorePointer(
            ignoring: !enabled,
            child: LabeledSlider(
              title: context.l10n.uiBackupInterval,
              icon: Icons.timer,
              value: interval.toDouble(),
              min: 0,
              max: 120,
              divisions: 24,
              layout: LabeledSliderLayout.stacked,
              valueLabelBuilder: (value) => context.l10n.uiMinutes(
                context.formats.integer(value.round()),
              ),
              onChanged: (value) async {
                await ref
                    .read(settingsStateProvider.notifier)
                    .setAutoBackupIntervalMinutes(value.round());
              },
            ),
          ),
        ),
        Opacity(
          opacity: enabled ? 1 : 0.5,
          child: IgnorePointer(
            ignoring: !enabled,
            child: HelpTarget(
              topicId: HelpTopicId.backupCapacity,
              child: LabeledSlider(
                title: context.l10n.uiMaximumBackupStorage,
                icon: Icons.storage_outlined,
                value: maxSizeMb.clamp(16, 4096).toDouble(),
                min: 16,
                max: 4096,
                divisions: 255,
                layout: LabeledSliderLayout.stacked,
                valueLabelBuilder: (value) => "${value.round()} MB",
                onChanged: (value) async {
                  await ref
                      .read(settingsStateProvider.notifier)
                      .setAutoBackupMaxSizeMb(value.round());
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        HelpTarget(
          topicId: HelpTopicId.backupDirectory,
          child: FutureBuilder<AutoBackupDirectoryInfo>(
            future: _autoBackupDirectoryInfoFuture,
            builder: (context, snapshot) {
              final info = snapshot.data;
              final isLoading =
                  snapshot.connectionState == ConnectionState.waiting &&
                  info == null;

              if (isLoading) {
                return const Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              if (info == null || (info.isAndroid && !info.isConfigured)) {
                return TextButton.icon(
                  onPressed: _selectAutoBackupDirectory,
                  icon: const Icon(Icons.folder_open),
                  label: Text(context.l10n.uiChooseAutomaticBackupFolder),
                );
              }

              return Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: _openAutoBackupDirectory,
                    icon: const Icon(Icons.folder_open),
                    label: Text(context.l10n.uiOpen),
                  ),
                  if (info.isAndroid)
                    TextButton.icon(
                      onPressed: _selectAutoBackupDirectory,
                      icon: const Icon(Icons.drive_folder_upload_outlined),
                      label: Text(context.l10n.uiChooseAgain),
                    )
                  else if (info.isDefault)
                    TextButton.icon(
                      onPressed: _selectAutoBackupDirectory,
                      icon: const Icon(Icons.drive_folder_upload_outlined),
                      label: Text(context.l10n.uiChoose),
                    )
                  else
                    PopupMenuButton<String>(
                      tooltip: context.l10n.uiAutoBackupFolderOptions,
                      icon: const Icon(Icons.more_horiz),
                      onSelected: (value) async {
                        if (value == "select") {
                          await _selectAutoBackupDirectory();
                        } else if (value == "reset") {
                          await _resetAutoBackupDirectory();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: "select",
                          child: Text(context.l10n.uiChoose),
                        ),
                        PopupMenuItem(
                          value: "reset",
                          child: Text(context.l10n.uiReset),
                        ),
                      ],
                    ),
                  if (info.path.trim().isNotEmpty)
                    Text(
                      info.path,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  Text(
                    context.l10n.uiMBBackups(
                      (_formatBytes(info.totalBytes)).toString(),
                      context.formats.integer(maxSizeMb),
                      context.formats.integer(info.fileCount),
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: info.fileCount == 0 ? null : _clearAutoBackups,
                    icon: const Icon(Icons.cleaning_services_outlined),
                    label: Text(context.l10n.uiDeleteAllBackups),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatBytes(int bytes) => context.formats.bytes(bytes);

  Future<void> _clearAutoBackups() async {
    try {
      final result = await ref
          .read(projectFileUseCaseProvider)
          .clearAutoBackups();
      if (!mounted) return;
      _refreshAutoBackupDirectoryInfo();
      AppFeedback.success(
        context,
        context.l10n.uiDeletedBackupsFreeing(
          context.formats.integer(result.deletedFiles),
          (_formatBytes(result.freedBytes)).toString(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      AppFeedback.error(context, e.toString());
    }
  }

  Future<void> _openAutoBackupDirectory() async {
    try {
      final directoryPath = await ref
          .read(projectFileUseCaseProvider)
          .openAutoBackupDirectory();
      if (!mounted) {
        return;
      }
      AppFeedback.success(
        context,
        context.l10n.uiOpenedAutoBackupFolder((directoryPath).toString()),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      AppFeedback.error(context, e.toString());
    }
  }

  Future<void> _selectAutoBackupDirectory() async {
    try {
      final directoryPath = await ref
          .read(projectFileUseCaseProvider)
          .selectAutoBackupDirectory();
      if (!mounted) {
        return;
      }
      _refreshAutoBackupDirectoryInfo();
      AppFeedback.success(
        context,
        context.l10n.uiAutoBackupFolderSet((directoryPath).toString()),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      AppFeedback.error(context, e.toString());
    }
  }

  Future<void> _resetAutoBackupDirectory() async {
    try {
      final directoryPath = await ref
          .read(projectFileUseCaseProvider)
          .resetAutoBackupDirectory();
      if (!mounted) {
        return;
      }
      _refreshAutoBackupDirectoryInfo();
      AppFeedback.success(
        context,
        context.l10n.uiAutoBackupFolderReset((directoryPath).toString()),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      AppFeedback.error(context, e.toString());
    }
  }

  // MARK: - 佔位元件
  Widget _buildPlaceholderSetting(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          const Spacer(),
          Text(
            context.l10n.uiComingSoon,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
