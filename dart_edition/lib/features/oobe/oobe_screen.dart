import "dart:math" as math;

import "package:flutter/material.dart";

import "../../bin/ui_library.dart"
    show AppThemePreset, AppThemeMode, AppTheme, UILibrary, LabeledSlider;
import "../../models/navigation_style.dart";
import "../../models/toolbar_mode.dart";
import "../../presentation/widgets/settings/settings_cards.dart";
import "../../presentation/widgets/settings/settings_color_picker.dart";
import "../../presentation/widgets/settings/settings_mode_preview.dart";
import "oobe_state.dart";
import "../../l10n/app_localization.dart";
import "../../presentation/widgets/settings/app_language_selector.dart";

typedef OobeDirectorySelector =
    Future<String?> Function({required String title, String? initialDirectory});

const _colorNames = {
  "Auto": "預設",
  "Gray": "灰色",
  "Red": "紅色",
  "Orange": "橘色",
  "Yellow": "黃色",
  "Green": "綠色",
  "Cyan": "青色",
  "Blue": "藍色",
  "Purple": "紫色",
  "Pink": "粉紅色",
};

/// A spacious, Whistler-inspired setup canvas with a fixed step rail and
/// footer. On narrow windows the rail becomes a horizontal progress strip.
class OobeScreen extends StatefulWidget {
  const OobeScreen({
    super.key,
    required this.initialPreferences,
    required this.onComplete,
    this.selectDirectory,
  });

  final OobePreferences initialPreferences;
  final Future<void> Function(OobePreferences preferences) onComplete;
  final OobeDirectorySelector? selectDirectory;

  @override
  State<OobeScreen> createState() => _OobeScreenState();
}

class _OobeScreenState extends State<OobeScreen> {
  late OobePreferences _preferences = widget.initialPreferences;
  final _scrollController = ScrollController();
  late final _nameController = TextEditingController(
    text: _preferences.displayName,
  );
  int _step = 0;
  bool _saving = false;
  bool _saveFailed = false;
  String? _directoryError;
  bool _selectingDirectory = false;
  late ColorScheme _colors;
  Color get _ink => _colors.primary;
  Color get _accent => _colors.tertiary;

  List<String> get _steps => [
    context.l10n.oobeStepWelcome,
    context.l10n.oobeStepAppearance,
    context.l10n.oobeStepStorage,
    context.l10n.oobeStepName,
    context.l10n.oobeStepWorkspace,
    context.l10n.oobeStepComplete,
  ];

  List<String> get _titles => [
    context.l10n.oobeTitleWelcome,
    context.l10n.oobeTitleAppearance,
    context.l10n.oobeTitleStorage,
    context.l10n.oobeTitleName,
    context.l10n.oobeTitleWorkspace,
    context.l10n.oobeTitleComplete,
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _goTo(int step) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _step = step;
      _saveFailed = false;
    });
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  void _skipName() {
    _preferences = _preferences.copyWith(
      displayName: widget.initialPreferences.displayName,
      useAsDefaultPenName: widget.initialPreferences.useAsDefaultPenName,
    );
    _nameController.text = _preferences.displayName;
    _goTo(_step + 1);
  }

  Future<void> _next() async {
    if (_saving || _selectingDirectory) return;
    if (_step < _steps.length - 1) {
      _goTo(_step + 1);
      return;
    }
    setState(() {
      _saving = true;
      _saveFailed = false;
    });
    try {
      await widget.onComplete(_preferences);
    } catch (_) {
      if (mounted) {
        setState(() => _saveFailed = true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _selectBackupDirectory() async {
    final selector = widget.selectDirectory;
    if (selector == null || _selectingDirectory) return;
    setState(() {
      _selectingDirectory = true;
      _directoryError = null;
    });
    try {
      final selected = await selector(
        title: "選擇自動備份資料夾",
        initialDirectory: _preferences.backupDirectory,
      );
      if (!mounted || selected == null || selected.trim().isEmpty) return;
      setState(
        () => _preferences = _preferences.copyWith(backupDirectory: selected),
      );
    } catch (_) {
      if (mounted) setState(() => _directoryError = "無法選擇資料夾，請再試一次。");
    } finally {
      if (mounted) setState(() => _selectingDirectory = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final dark = switch (_preferences.themeMode) {
      AppThemeMode.light => false,
      AppThemeMode.dark => true,
      AppThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
    final base = dark
        ? AppTheme.getDarkTheme(
            _preferences.fontSize,
            _preferences.themeColor,
            preset: _preferences.themePreset,
            locale: Localizations.localeOf(context),
          )
        : AppTheme.getLightTheme(
            _preferences.fontSize,
            _preferences.themeColor,
            preset: _preferences.themePreset,
            locale: Localizations.localeOf(context),
          );
    _colors = base.colorScheme;
    final theme = base.copyWith(
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _ink,
          foregroundColor: _colors.onPrimary,
          minimumSize: const Size(116, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
    return Theme(
      data: theme,
      child: Scaffold(
        key: const Key("oobe-screen"),
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.alphaBlend(
                  _colors.primary.withValues(alpha: .10),
                  _colors.surface,
                ),
                Color.alphaBlend(
                  _colors.secondary.withValues(alpha: .05),
                  _colors.surface,
                ),
                Color.alphaBlend(
                  _colors.tertiary.withValues(alpha: .10),
                  _colors.surface,
                ),
              ],
            ),
          ),
          child: CustomPaint(
            painter: _SetupBackground(color: _colors.onSurface),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 720;
                  final shortWindow = constraints.maxHeight < 480;
                  final brandHeight = math.min(
                    compact ? 120.0 : 200.0,
                    constraints.maxHeight * .22,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!compact || !keyboardVisible)
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            compact ? 24 : 32,
                            shortWindow
                                ? 12
                                : compact
                                ? 20
                                : 28,
                            24,
                            shortWindow ? 12 : 20,
                          ),
                          child: _Brand(height: brandHeight),
                        ),
                      if (compact) _compactProgress(),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!compact)
                              SizedBox(
                                width: 238,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    34,
                                    24,
                                    0,
                                  ),
                                  child: SingleChildScrollView(
                                    primary: false,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        for (var i = 0; i < _steps.length; i++)
                                          _stepLabel(i),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Scrollbar(
                                controller: _scrollController,
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  padding: EdgeInsets.fromLTRB(
                                    compact ? 24 : 42,
                                    compact ? 24 : 28,
                                    compact ? 24 : 64,
                                    24,
                                  ),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 880,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Semantics(
                                          header: true,
                                          liveRegion: true,
                                          child: Text(
                                            _titles[_step],
                                            style: TextStyle(
                                              fontSize:
                                                  (compact ? 28 : 36) *
                                                  _preferences.fontSize /
                                                  14,
                                              fontWeight: FontWeight.w700,
                                              height: 1.35,
                                              color: _ink,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 22),
                                        ..._pageContent(),
                                        const SizedBox(height: 40),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _footer(compact),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepLabel(int index) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Semantics(
      selected: index == _step,
      label: context.l10n.oobeProgressSemantics(index + 1, _steps[index]),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (index == _step)
            Icon(Icons.arrow_right, color: _accent, size: 20)
          else if (index < _step)
            Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(Icons.check, color: _ink, size: 15),
            ),
          Flexible(
            child: Text(
              _steps[index],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: index == _step ? _accent : _ink,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _compactProgress() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${_step + 1} / ${_steps.length}  ·  ${_steps[_step]}",
          style: TextStyle(color: _ink, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (var i = 0; i < _steps.length; i++)
              Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.only(right: 6),
                  color: i == _step
                      ? _accent
                      : i < _step
                      ? _ink
                      : _ink.withValues(alpha: .12),
                ),
              ),
          ],
        ),
      ],
    ),
  );

  List<Widget> _pageContent() => switch (_step) {
    0 => [
      _paragraph(context.l10n.oobeWelcomeThanks),
      const SizedBox(height: 16),
      _paragraph(context.l10n.oobeWelcomeTime),
      const SizedBox(height: 16),
      _paragraph(context.l10n.oobeWelcomeDescription),
      const SizedBox(height: 32),
      _note(Icons.language_rounded, context.l10n.languageTitle, null),
      const SizedBox(height: 16),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: const AppLanguageSelector(fieldKey: Key('oobe-language')),
      ),
    ],
    1 => [
      _paragraph("選擇適合您的閱讀與操作方式。這些選項稍後都能在「設定」中調整。"),
      const SizedBox(height: 22),
      _label("介面主題"),
      SettingsModePicker(
        options: [
          for (final mode in AppThemeMode.values)
            SettingsModeOption(
              id: "oobe-theme-${mode.name}",
              label: _themeName(mode),
              description: "使用${_themeName(mode)}主題",
              preview: SettingsModePreview(
                accent: _preferences.themePreset.accent(
                  _preferences.themeColor,
                ),
                themeMode: mode,
              ),
              selected: _preferences.themeMode == mode,
              onSelected: () => setState(
                () => _preferences = _preferences.copyWith(themeMode: mode),
              ),
            ),
        ],
      ),
      const SizedBox(height: 24),
      _colorAndFontSettings(),
      const SizedBox(height: 24),
      _label("側邊導覽"),
      SettingsModePicker(
        options: [
          for (final (index, style) in NavigationStyle.values.indexed)
            SettingsModeOption(
              id: "oobe-navigation-${style.name}",
              label: ["僅圖示", "圖示與文字", "按鈕展開", "懸停展開"][index],
              description: style.description,
              preview: SettingsModePreview(
                accent: _preferences.themePreset.accent(
                  _preferences.themeColor,
                ),
                navigationStyle: style,
              ),
              selected: _preferences.navigationStyle == style,
              onSelected: () => setState(
                () => _preferences = _preferences.copyWith(
                  navigationStyle: style,
                ),
              ),
            ),
        ],
      ),
      const SizedBox(height: 24),
      _ribbonModeSetting(),
    ],
    2 => [
      _paragraph("作品會以 .mnproj 專案檔保存在您選擇的位置。依照寫作習慣，決定是否啟用以下功能。"),
      const SizedBox(height: 22),
      _surface(
        Column(
          children: [
            SwitchListTile(
              key: const Key("oobe-auto-save-switch"),
              title: const Text("自動儲存"),
              subtitle: Text(
                "每 ${_preferences.autoSaveIntervalMinutes} 分鐘寫回目前的專案檔。請先手動儲存一次，選定檔案位置。",
              ),
              value: _preferences.autoSaveEnabled,
              onChanged: (value) => setState(
                () => _preferences = _preferences.copyWith(
                  autoSaveEnabled: value,
                ),
              ),
            ),
            LabeledSlider(
              key: const Key("oobe-auto-save-interval"),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              title: "儲存間隔",
              value: _preferences.autoSaveIntervalMinutes.toDouble(),
              min: 1,
              max: 120,
              divisions: 119,
              valueLabelBuilder: (value) => "${value.round()} 分鐘",
              onChanged: !_preferences.autoSaveEnabled
                  ? null
                  : (value) => setState(
                      () => _preferences = _preferences.copyWith(
                        autoSaveIntervalMinutes: value.round(),
                      ),
                    ),
            ),
            const Divider(height: 1),
            SwitchListTile(
              key: const Key("oobe-auto-backup-switch"),
              title: const Text("自動備份"),
              subtitle: Text(
                "每 ${_preferences.autoBackupIntervalMinutes} 分鐘另存備份，保留目前專案的位置；可在設定中管理備份。",
              ),
              value: _preferences.autoBackupEnabled,
              onChanged: (value) => setState(
                () => _preferences = _preferences.copyWith(
                  autoBackupEnabled: value,
                ),
              ),
            ),
            LabeledSlider(
              key: const Key("oobe-auto-backup-interval"),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              title: "備份間隔",
              value: _preferences.autoBackupIntervalMinutes.toDouble(),
              min: 1,
              max: 120,
              divisions: 119,
              valueLabelBuilder: (value) => "${value.round()} 分鐘",
              onChanged: !_preferences.autoBackupEnabled
                  ? null
                  : (value) => setState(
                      () => _preferences = _preferences.copyWith(
                        autoBackupIntervalMinutes: value.round(),
                      ),
                    ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 22),
      _backupDirectorySetting(),
      if (widget.selectDirectory == null) ...[
        const SizedBox(height: 12),
        _paragraph("此平台的自動備份資料夾可於設定中管理。"),
      ],
      if (_directoryError != null)
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(_directoryError!, style: TextStyle(color: _colors.error)),
        ),
      const SizedBox(height: 22),
      _paragraph("本程式可離線使用。請記得用「儲存」保存新專案。"),
    ],
    3 => [
      _paragraph("開啟歡迎頁面時，您的名稱會出現在「歡迎訊息」欄位。請輸入您希望出現的名稱。您也可以略過這個步驟。"),
      const SizedBox(height: 16),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: TextField(
          key: const Key("oobe-display-name"),
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: "名稱（選填）",
            hintText: "輸入您的名稱或筆名",
          ),
          onChanged: (name) => setState(
            () => _preferences = _preferences.copyWith(displayName: name),
          ),
        ),
      ),
      const SizedBox(height: 8),
      _paragraph("範例：中野梓"),
      const SizedBox(height: 16),
      CheckboxListTile(
        key: const Key("oobe-default-pen-name"),
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text("作為預設筆名"),
        subtitle: const Text("新建專案時，自動填入作者欄位。"),
        value: _preferences.useAsDefaultPenName,
        onChanged: _preferences.displayName.trim().isEmpty
            ? null
            : (value) => setState(
                () => _preferences = _preferences.copyWith(
                  useAsDefaultPenName: value ?? false,
                ),
              ),
      ),
    ],
    4 => [
      _paragraph("進入工作區後，您可以從歡迎頁新建專案，或開啟已有的 .mnproj 檔案。"),
      const SizedBox(height: 24),
      _note(
        Icons.create_new_folder_outlined,
        "01  建立您的作品",
        "新建專案，填寫作品名稱與故事基本資料。",
      ),
      const SizedBox(height: 16),
      _note(
        Icons.edit_note_outlined,
        "02  寫下第一個章節",
        "在「章節」新增資料夾與章節，選取章節後開始撰寫正文。",
      ),
      const SizedBox(height: 16),
      _note(
        Icons.public_outlined,
        "03  構建您的設定",
        "用大綱、角色、世界觀與時間軸，整理您的故事。需要協助時可從「說明」選單開啟指南。",
      ),
    ],
    _ => [
      _paragraph("恭喜！您現在可以開始使用本程式。以下是您的完成報告："),
      const SizedBox(height: 24),
      _surface(
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _paragraph(
                "名稱：${_preferences.displayName.trim().isEmpty ? '未設定' : _preferences.displayName.trim()}",
              ),
              _paragraph(
                "作為預設筆名：${_preferences.useAsDefaultPenName && _preferences.displayName.trim().isNotEmpty ? '是' : '否'}",
              ),
              _paragraph("主題：${_themeName(_preferences.themeMode)}"),
              _paragraph(
                "主題顏色：${_preferences.themePreset == AppThemePreset.standard ? _colorName(_preferences.themeColor) : _preferences.themePreset.label}",
              ),
              _paragraph("文字大小：${_preferences.fontSize.toInt()}"),
              _paragraph(
                "導覽：${["僅圖示", "圖示與文字", "按鈕展開", "懸停展開"][_preferences.navigationStyle.index]}",
              ),
              _paragraph(
                "Ribbon 模式：${_preferences.toolbarMode?.label ?? '自動（${ToolbarMode.defaultFor(Theme.of(context).platform).label}）'}",
              ),
              _paragraph(
                "自動儲存：${_preferences.autoSaveEnabled ? "每 ${_preferences.autoSaveIntervalMinutes} 分鐘" : "關閉"}",
              ),
              _paragraph(
                "自動備份：${_preferences.autoBackupEnabled ? "每 ${_preferences.autoBackupIntervalMinutes} 分鐘" : "關閉"}",
              ),
              _paragraph(
                "自動備份資料夾：${_preferences.backupDirectory ?? "使用預設備份資料夾"}",
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 18),
      _paragraph("介面與儲存偏好可在「設定」中修改，名稱可重新開啟初次設定調整。"),
    ],
  };

  Widget _ribbonModeSetting() {
    final mode = _preferences.toolbarMode;
    final resolved = mode ?? ToolbarMode.defaultFor(Theme.of(context).platform);
    return Column(
      key: const Key("oobe-ribbon-mode-setting"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Ribbon 模式"),
        SettingsModePicker(
          options: [
            for (final option in [...ToolbarMode.values, null])
              SettingsModeOption(
                id: "oobe-toolbar-${option?.name ?? 'automatic'}",
                label: option?.label ?? "自動",
                description:
                    option?.description ?? "依裝置選擇：桌面 Full，手機 Moderate。",
                preview: SettingsModePreview(
                  accent: _preferences.themePreset.accent(
                    _preferences.themeColor,
                  ),
                  toolbarMode: option,
                ),
                selected: mode == option,
                onSelected: () => setState(
                  () => _preferences = _preferences.copyWith(
                    toolbarMode: option,
                    clearToolbarMode: option == null,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        _paragraph(
          mode == null
              ? "自動使用 ${resolved.label}：${resolved.description}"
              : resolved.description,
        ),
      ],
    );
  }

  Widget _colorAndFontSettings() => LayoutBuilder(
    builder: (context, constraints) {
      final colors = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label("主題顏色"),
          SettingsColorPicker(
            selectedColor: _preferences.themeColor,
            preset: _preferences.themePreset,
            onPresetChanged: (preset) => setState(
              () => _preferences = _preferences.copyWith(themePreset: preset),
            ),
            labels: _colorNames,
            keyPrefix: "oobe-color",
            onChanged: (color) => setState(
              () => _preferences = _preferences.copyWith(
                themeColor: color,
                themePreset: AppThemePreset.standard,
              ),
            ),
          ),
        ],
      );
      final fontSize = Column(
        key: const Key("oobe-font-size"),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label("文字大小  ${_preferences.fontSize.toInt()}sp"),
          Slider(
            value: _preferences.fontSize,
            max: 20,
            min: 12,
            onChanged: (value) => setState(
              () => _preferences = _preferences.copyWith(
                fontSize: value.round().toDouble(),
              ),
            ),
          ),
        ],
      );
      final textScale =
          MediaQuery.textScalerOf(context).scale(_preferences.fontSize) / 14;
      if (constraints.maxWidth >= 560 * textScale) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: colors),
            const SizedBox(width: 24),
            Expanded(child: fontSize),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [colors, const SizedBox(height: 24), fontSize],
      );
    },
  );

  Widget _backupDirectorySetting() {
    final directory = _preferences.backupDirectory;
    final title = "自動備份資料夾";
    return _surface(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label(title),
            Text(
              directory ?? "使用預設備份資料夾",
              key: const ValueKey("oobe-backup-directory"),
              style: TextStyle(color: _colors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  key: const ValueKey("oobe-select-backup-directory"),
                  onPressed:
                      widget.selectDirectory == null || _selectingDirectory
                      ? null
                      : _selectBackupDirectory,
                  icon: const Icon(Icons.folder_open),
                  label: const Text("選擇資料夾"),
                ),
                if (directory != null)
                  TextButton(
                    key: const ValueKey("oobe-reset-backup-directory"),
                    onPressed: _selectingDirectory
                        ? null
                        : () => setState(
                            () => _preferences = _preferences.copyWith(
                              clearBackupDirectory: true,
                            ),
                          ),
                    child: const Text("還原預設"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _footer(bool compact) => Padding(
    padding: EdgeInsets.fromLTRB(compact ? 24 : 40, 16, compact ? 24 : 64, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_saveFailed)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Semantics(
              liveRegion: true,
              child: Text(
                context.l10n.oobeSaveFailed,
                style: TextStyle(color: _colors.error),
              ),
            ),
          ),
        if (!compact)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              _step == _steps.length - 1
                  ? context.l10n.oobeCompleteHint
                  : context.l10n.oobeContinueHint,
            ),
          ),
        Row(
          children: [
            if (!compact)
              Expanded(
                child: Text(
                  "2025~2026 Heyairu(TM)",
                  style: TextStyle(
                    fontSize: 12,
                    color: _ink.withValues(alpha: .6),
                  ),
                ),
              ),
            Expanded(
              flex: 2,
              child: Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (_step == 3)
                    TextButton(
                      key: const Key("oobe-skip-name"),
                      onPressed: _saving || _selectingDirectory
                          ? null
                          : _skipName,
                      child: Text(context.l10n.oobeSkip),
                    ),
                  if (_step > 0)
                    TextButton(
                      key: const Key("oobe-back"),
                      onPressed: _saving || _selectingDirectory
                          ? null
                          : () => _goTo(_step - 1),
                      child: Text(context.l10n.oobeBack),
                    ),
                  FilledButton(
                    key: const Key("oobe-next"),
                    onPressed: _saving || _selectingDirectory ? null : _next,
                    child: _saving
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _colors.onPrimary,
                            ),
                          )
                        : Text(
                            _step == _steps.length - 1
                                ? context.l10n.oobeStart
                                : context.l10n.oobeNext,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

String _themeName(AppThemeMode mode) => switch (mode) {
  AppThemeMode.light => "淺色",
  AppThemeMode.dark => "深色",
  AppThemeMode.system => "跟隨系統",
};

String _colorName(Color color) {
  for (final entry in UILibrary.supportedColors.entries) {
    if (entry.value == color) return _colorNames[entry.key]!;
  }
  return "#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}";
}

Widget _paragraph(String text) => Builder(
  builder: (context) => Text(
    text,
    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8),
  ),
);

Widget _label(String text) => Builder(
  builder: (context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  ),
);

Widget _surface(Widget child) => Builder(
  builder: (context) => SizedBox(
    width: double.infinity,
    child: Material(
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerLow.withValues(alpha: .8),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    ),
  ),
);

Widget _note(IconData icon, String title, String? description) => Builder(
  builder: (context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Icon(
          icon,
          size: 26,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            if (description != null) ...[
              const SizedBox(height: 6),
              _paragraph(description),
            ],
          ],
        ),
      ),
    ],
  ),
);

class _Brand extends StatelessWidget {
  const _Brand({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Image.asset(
      "assets/icon/Title.png",
      key: const Key("oobe-title-image"),
      width: 240,
      height: height,
      fit: BoxFit.contain,
      semanticLabel: "物語 Assistant",
    ),
  );
}

class _SetupBackground extends CustomPainter {
  const _SetupBackground({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;
    canvas.save();
    canvas.translate(size.width * .53, size.height * .58);
    canvas.rotate(-math.pi / 6);
    for (var i = 0; i < 3; i++) {
      paint
        ..color = color.withValues(alpha: .04 - i * .01)
        ..strokeWidth = 2 + i * 8;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: size.width * (1.2 + i * .18),
          height: size.height * (.85 + i * .24),
        ),
        paint,
      );
    }
    canvas.restore();
    final wordmark = TextPainter(
      text: TextSpan(
        text: "MonoAshi",
        style: TextStyle(
          fontFamily: "NotoSansTC",
          color: color.withValues(alpha: .04),
          fontSize: size.width * .12,
          letterSpacing: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(size.width * .05, size.height * .62);
    canvas.rotate(math.pi / 10);
    wordmark.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SetupBackground oldDelegate) =>
      oldDelegate.color != color;
}
