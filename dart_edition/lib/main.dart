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

import "features/help/help_controller.dart";
import "features/help/help_scope.dart";
import "features/help/help_topic.dart";
import "features/phrases/phrase_library_dialog.dart";
import "features/oobe/oobe_gate.dart";
import "features/oobe/oobe_state.dart";
import "dart:math";
import "dart:async"; // Added for Timer
import "dart:convert";

import "package:flutter/material.dart";
import "l10n/app_localization.dart";
import "presentation/providers/locale_providers.dart";
import "package:flutter/services.dart";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:window_manager/window_manager.dart";
import "bin/appbar.dart";
import "package:material_ribbon/material_ribbon.dart";
import "bin/statusbar.dart";
import "bin/slidebar.dart";
import "models/navigation_style.dart";
import "models/toolbar_mode.dart";
import "bin/content.dart";
import "bin/mobile_function_page.dart";
import "bin/file.dart";
import "bin/findreplace.dart";
import "bin/punctuation_panel.dart";
import "bin/ui_library.dart";
import "bin/settings_manager.dart";
import "application/project_import/selective_project_import.dart";
import "application/project_export/export_models.dart";
import "application/project_export/export_selection.dart";
import "application/project_export/export_service.dart";
import "presentation/providers/project_export_providers.dart";
import "presentation/widgets/project_export/export_dialog.dart";
import "data/p2p/p2p_snapshot_quarantine.dart";
import "domain/collaboration/collaborative_text.dart";
import "domain/collaboration/collaboration_operation.dart"
    show ProjectRecordKind;
import "domain/models/p2p_sync_models.dart";
import "domain/models/p2p_revision_models.dart";
import "domain/models/p2p_snapshot_models.dart";
import "infrastructure/rhodanthe/rhodanthe_editor_session.dart";
import "infrastructure/rhodanthe/rhodanthe_annotations.dart";
import "infrastructure/rhodanthe/rhodanthe_protocol.dart";
import "infrastructure/rhodanthe/rhodanthe_rollout_cohort.dart";
import "infrastructure/rhodanthe/rhodanthe_rollout_guard.dart";
import "infrastructure/rhodanthe/rhodanthe_rollout_store.dart";
import "infrastructure/rhodanthe/rhodanthe_theme.dart";
import "features/inline_annotations/inline_annotation_rhodanthe_adapter.dart";
import "features/inline_annotations/inline_annotation_details_dialog.dart";
import "features/inline_annotations/inline_annotation_edit_dialog.dart";
import "features/inline_annotations/inline_annotation.dart";
import "features/inline_annotations/inline_annotation_relink_dialog.dart";
import "features/inline_annotations/inline_annotation_target_resolver.dart";
import "features/inline_annotations/inline_annotation_projection.dart";
import "features/inline_annotations/mosaic_editing_controller.dart";
import "features/inline_annotations/alias_mention_updates.dart";
import "features/editor/plain_text_quill_editor_poc.dart";
import "features/navigation/app_module.dart";
import "features/navigation/workspace_navigation_shortcuts.dart";
import "features/help/help_module.dart";
import "presentation/widgets/module_switcher.dart";
import "features/editor/plain_text_quill_render_range.dart";
import "features/revision_tracking/presentation/revision_tracking_panel.dart";
import "features/revision_tracking/application/revision_review_service.dart";
import "features/revision_tracking/application/revision_session_codec.dart";
import "features/revision_tracking/application/revision_snapshot_builder.dart";
import "features/revision_tracking/domain/revision_models.dart";
import "presentation/providers/collaboration_providers.dart";
import "presentation/providers/editor_coordinator_provider.dart";
import "presentation/providers/global_state_providers.dart";
import "presentation/providers/project_io_providers.dart";
import "presentation/providers/project_history_provider.dart";
import "presentation/providers/writing_progress_provider.dart";
import "presentation/providers/p2p_sync_providers.dart";
import "presentation/widgets/p2p_conflict_resolution_dialog.dart";
import "presentation/widgets/splash_screen.dart";
import "presentation/widgets/radial_gauge_dashboard.dart";
import "presentation/providers/project_snapshot_utils.dart";
import "presentation/providers/project_state_providers.dart";
import "presentation/providers/revision_tracking_provider.dart";
import "presentation/providers/timeline_providers.dart";
import "presentation/providers/word_count_providers.dart";
import "presentation/providers/gauge_dashboard_provider.dart";
import "utils/text_change_debouncer.dart";
import "utils/text_position_index.dart";
import "services/word_count_service.dart";
import "services/project_io_session_coordinator.dart";
import "services/desktop_project_launch.dart";

import "modules/baseinfoview.dart" as BaseInfoModule;
import "modules/chapterselectionview.dart" as ChapterModule;
import "modules/AboutView.dart" as AboutModule;
import "modules/glossaryview.dart" as GlossaryModule;
import "modules/palettesview.dart" as palettes_module;
import "modules/outlineview.dart" as OutlineModule;
import "modules/planview.dart" as PlanModule;
import "modules/proofreadingview.dart" as ProofReadingModule;
import "modules/copliot.dart" as copilot_module;
import "modules/WelcomeView.dart" as WelcomeModule;
import "modules/worldsettingsview.dart";
import "modules/characterview.dart";
import "modules/character_relationship_graph_view.dart";
import "modules/settingview.dart";
import "modules/timelineview.dart";
import "modules/itemview.dart";

typedef _CoordinatorUiEventState = ({
  int messageEventId,
  String? messageText,
  int wordCountModeEventId,
  int errorEventId,
  String? errorMessage,
});

enum _P2pSnapshotApplyChoice { cancel, overwriteCurrent, saveAs }

class _ProjectIoBusyIndicator extends ConsumerWidget {
  const _ProjectIoBusyIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBusy = ref.watch(
      projectIoControllerProvider.select((value) => value.isProjectIoBusy),
    );

    if (!isBusy) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

void main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopProjectLaunch.initialize(startupArguments: arguments);
  if (_isDesktopPlatform) {
    await _DesktopSplashWindowController.prepare();
  }

  runApp(ProviderScope(child: MainApp(startupArguments: arguments)));
}

bool get _isDesktopPlatform =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS);

bool get _isAndroidPlatform =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

class _DesktopSplashWindowController {
  static const Size splashSize = Size(540, 360);
  static Size? _mainWindowSize;

  static Future<void> prepare() async {
    await windowManager.ensureInitialized();
    _mainWindowSize = await windowManager.getSize();

    unawaited(
      windowManager.waitUntilReadyToShow(
        const WindowOptions(
          size: splashSize,
          center: true,
          backgroundColor: Colors.transparent,
          titleBarStyle: TitleBarStyle.hidden,
          windowButtonVisibility: false,
        ),
        () async {
          await windowManager.setAsFrameless();
          await windowManager.show();
          await windowManager.focus();
        },
      ),
    );
  }

  static Future<void> restoreMainWindow() async {
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    final mainWindowSize = _mainWindowSize;
    if (mainWindowSize != null) {
      await windowManager.setSize(mainWindowSize);
      await windowManager.center();
    }
  }
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key, this.startupArguments = const []});

  final List<String> startupArguments;

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  final _helpNavigatorKey = GlobalKey<NavigatorState>();
  static const _desktopSplashMinimumDuration = Duration(seconds: 5);

  Timer? _splashTimer;
  bool _minimumSplashElapsed = !_isDesktopPlatform;
  bool _mainWindowRestored = false;

  @override
  void initState() {
    super.initState();
    if (_isDesktopPlatform) {
      _splashTimer = Timer(_desktopSplashMinimumDuration, () {
        if (mounted) {
          setState(() => _minimumSplashElapsed = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  ThemeMode _convertThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bootstrap = ref.watch(appInitializationProvider);
    final localePreference = ref.watch(appLocalePreferenceProvider);
    final resolvedLocale = ref.watch(resolvedAppLocaleProvider);

    final keepDesktopSplashVisible =
        _isDesktopPlatform && !_minimumSplashElapsed;
    if (bootstrap.isLoading || keepDesktopSplashVisible) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: localePreference.locale,
        supportedLocales: supportedAppLocales,
        localeListResolutionCallback: AppLocalization.resolve,
        localizationsDelegates: AppLocalization.delegates,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: AppFonts.primary(resolvedLocale),
          fontFamilyFallback: AppFonts.fallbacks(resolvedLocale),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        ),
        home: const AppSplash(),
      );
    }

    if (_isDesktopPlatform && !_mainWindowRestored) {
      _mainWindowRestored = true;
      unawaited(_DesktopSplashWindowController.restoreMainWindow());
    }

    if (bootstrap.hasError) {
      return MaterialApp(
        theme: ThemeData(
          fontFamily: AppFonts.primary(resolvedLocale),
          fontFamilyFallback: AppFonts.fallbacks(resolvedLocale),
        ),
        locale: localePreference.locale,
        supportedLocales: supportedAppLocales,
        localeListResolutionCallback: AppLocalization.resolve,
        localizationsDelegates: AppLocalization.delegates,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  context.l10n.initializationFailed("${bootstrap.error}"),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final theme = ref.watch(appThemeSettingsProvider);

    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      navigatorKey: _helpNavigatorKey,
      builder: (context, child) => AppHelpHost(
        navigatorKey: _helpNavigatorKey,
        child: Stack(
          fit: StackFit.expand,
          children: [
            child!,
            if (theme.preset.isPride)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 6,
                child: PrideEdgeGlow(preset: theme.preset),
              ),
          ],
        ),
      ),
      theme: AppTheme.getLightTheme(
        theme.fontSize,
        theme.color,
        preset: theme.preset,
        locale: resolvedLocale,
      ),
      darkTheme: AppTheme.getDarkTheme(
        theme.fontSize,
        theme.color,
        preset: theme.preset,
        locale: resolvedLocale,
      ),
      themeMode: _convertThemeMode(theme.mode),
      locale: localePreference.locale,
      localizationsDelegates: AppLocalization.delegates,
      supportedLocales: supportedAppLocales,
      localeListResolutionCallback: AppLocalization.resolve,
      home: OobeGate(
        options: OobeLaunchOptions.parse(widget.startupArguments),
        builder: (_) => const ContentView(),
      ),
    );
  }
}

// 數據模型類別（BaseInfoData, ChapterData, SegmentData 現在從模組導入）

class SimpleLocation {
  String localName;
  String description;
  String locationUUID;

  SimpleLocation({
    required this.localName,
    this.description = "",
    String? locationUUID,
  }) : locationUUID =
           locationUUID ?? DateTime.now().millisecondsSinceEpoch.toString();
}

// Intent classes for keyboard shortcuts
class NewFileIntent extends Intent {
  const NewFileIntent();
}

class OpenFileIntent extends Intent {
  const OpenFileIntent();
}

class SaveFileIntent extends Intent {
  const SaveFileIntent();
}

class SaveAsFileIntent extends Intent {
  const SaveAsFileIntent();
}

class ReplaceIntent extends Intent {
  const ReplaceIntent();
}

class SearchResultIntent extends Intent {
  const SearchResultIntent(this.forward);
  final bool forward;
}

class CloseSearchIntent extends Intent {
  const CloseSearchIntent();
}

class FindIntent extends Intent {
  const FindIntent();
}

class UndoProjectIntent extends Intent {
  const UndoProjectIntent();
}

class RedoProjectIntent extends Intent {
  const RedoProjectIntent();
}

typedef _EditorStatusLocation = ({String chapterLabel, int cursorOffset});

final _editorStatusLocationProvider = Provider<_EditorStatusLocation>((ref) {
  final selection = ref.watch(
    editorSelectionProvider.select(
      (state) => (
        selectedSegID: state.selectedSegID,
        selectedChapID: state.selectedChapID,
        cursorOffset: state.cursorOffset,
      ),
    ),
  );
  final segments = ref.watch(segmentsDataProvider);

  String chapterLabel = "";
  final location = selection.selectedChapID == null
      ? null
      : ChapterModule.ChapterTree.findChapter(
          segments,
          folderId: selection.selectedSegID,
          chapterId: selection.selectedChapID!,
        );
  if (location != null) {
    chapterLabel =
        "${location.folder.segmentName} / ${location.chapter.chapterName}";
  }

  return (chapterLabel: chapterLabel, cursorOffset: selection.cursorOffset);
});

class _EditorStatusBar extends ConsumerStatefulWidget {
  const _EditorStatusBar({
    required this.textController,
    required this.projectName,
    required this.hasUnsavedChanges,
    required this.lastSavedTime,
    required this.iconSize,
  });

  final TextEditingController textController;
  final String projectName;
  final bool hasUnsavedChanges;
  final DateTime? lastSavedTime;
  final double iconSize;

  @override
  ConsumerState<_EditorStatusBar> createState() => _EditorStatusBarState();
}

class _EditorStatusBarState extends ConsumerState<_EditorStatusBar> {
  static const int _largeDocumentThreshold = 128 * 1024;
  static const Duration _largeDocumentDebounce = Duration(milliseconds: 160);

  late TextPositionIndex _positionIndex;
  Timer? _positionIndexTimer;

  @override
  void initState() {
    super.initState();
    _positionIndex = TextPositionIndex(widget.textController.text);
    widget.textController.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant _EditorStatusBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.textController, widget.textController)) return;
    oldWidget.textController.removeListener(_handleControllerChanged);
    widget.textController.addListener(_handleControllerChanged);
    _rebuildPositionIndex(widget.textController.text);
  }

  void _handleControllerChanged() {
    final nextText = widget.textController.text;
    if (nextText == _positionIndex.text) return;

    final isSmall = nextText.length < _largeDocumentThreshold;
    final looksLikeSingleEdit =
        (nextText.length - _positionIndex.text.length).abs() <= 8;
    if (isSmall || !looksLikeSingleEdit) {
      _positionIndexTimer?.cancel();
      _rebuildPositionIndex(nextText);
      return;
    }

    _positionIndexTimer?.cancel();
    _positionIndexTimer = Timer(_largeDocumentDebounce, () {
      if (!mounted) return;
      _rebuildPositionIndex(widget.textController.text);
    });
  }

  void _rebuildPositionIndex(String text) {
    if (!mounted) {
      _positionIndex = TextPositionIndex(text);
      return;
    }
    setState(() => _positionIndex = TextPositionIndex(text));
  }

  @override
  void dispose() {
    _positionIndexTimer?.cancel();
    widget.textController.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(_editorStatusLocationProvider);
    final totalWords = ref.watch(totalWordsProvider);
    final currentWords = ref.watch(
      activeChapterWordCountProvider.select((state) => state.count),
    );

    final projectName = widget.hasUnsavedChanges
        ? "${widget.projectName}*"
        : widget.projectName;
    final displayText = status.chapterLabel.isNotEmpty
        ? "$projectName | ${status.chapterLabel}"
        : projectName;
    final saveTimeText = widget.lastSavedTime == null
        ? "--:--"
        : context.formats.time(widget.lastSavedTime!);
    final cursor = _positionIndex.lineColumnFromOffset(status.cursorOffset);

    return MonogatariStatusBar(
      compact: MediaQuery.sizeOf(context).width < 800,
      themePreset: ref.watch(
        appThemeSettingsProvider.select((theme) => theme.preset),
      ),
      displayText: displayText,
      saveTimeText: saveTimeText,
      cursorLine: cursor.line,
      cursorColumn: cursor.column,
      tabSpaceCount:
          ref.watch(settingsStateProvider).valueOrNull?.tabSpaceCount ?? 2,
      tabFullWidth:
          ref.watch(settingsStateProvider).valueOrNull?.tabFullWidth ?? true,
      onTabSpaceCountChanged: (count) =>
          ref.read(settingsStateProvider.notifier).setTabSpaceCount(count),
      onTabFullWidthChanged: (fullWidth) =>
          ref.read(settingsStateProvider.notifier).setTabFullWidth(fullWidth),
      autoIndentLineStart:
          ref.watch(settingsStateProvider).valueOrNull?.autoIndentLineStart ??
          false,
      onAutoIndentLineStartChanged: (enabled) => ref
          .read(settingsStateProvider.notifier)
          .setAutoIndentLineStart(enabled),
      overwriteMode: ref.watch(editorEffectiveOverwriteProvider),
      onToggleOverwrite:
          (ref.watch(settingsStateProvider).valueOrNull?.overwriteModeEnabled ??
              true)
          ? () {
              final mode = ref.read(editorOverwriteProvider.notifier);
              mode.state = !mode.state;
            }
          : null,
      currentWords: currentWords,
      totalWords: totalWords,
      iconSize: widget.iconSize,
    );
  }
}

// 主要 ContentView
class ContentView extends ConsumerStatefulWidget {
  const ContentView({super.key});

  @override
  ConsumerState<ContentView> createState() => _ContentViewState();
}

/// Keeps the last fully laid-out body at fixed logical constraints while the
/// native window is being resized. [FittedBox] scales only the composited
/// result, preventing large editable paragraphs and all inactive project pages
/// from being laid out again for every intermediate window size.
class _WindowResizeViewport extends StatelessWidget {
  const _WindowResizeViewport({
    super.key,
    required this.contentSize,
    required this.child,
  });

  final Size contentSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topLeft,
          child: SizedBox.fromSize(
            key: const Key("window-resize-stable-content"),
            size: contentSize,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _ContentViewState extends ConsumerState<ContentView>
    with WindowListener, WidgetsBindingObserver {
  // 狀態變數
  final int slidePageCounts = AppModule.pageCount;
  int slidePageIndexCurrent = 0;
  int slidePageIndexNow = 0;
  int _projectSessionVersion = 0;
  String? _requestedCharacterId;
  int _characterSelectionRequestId = 0;
  String? _requestedLocationId;
  int _locationSelectionRequestId = 0;
  String? _requestedItemClassId;
  int _itemSelectionRequestId = 0;
  String? _requestedPlanTargetId;
  PlanModule.PlanSelectionTarget? _requestedPlanTargetKind;
  int _planSelectionRequestId = 0;
  bool _isExitConfirmationInProgress = false;
  bool _isDesktopWindowClosing = false;
  bool _isWindowResizeInProgress = false;
  Timer? _windowResizeEndTimer;
  Widget? _stableResizeBody;
  Size? _stableResizeBodySize;
  double _sidebarWidthRatio = 0.25; // Default sidebar width ratio (25%)
  bool _showNavigation = true;
  bool _showSidebar = true;
  bool _revisionDialogOpen = false;
  bool _showRevisionDetails = false;
  double _revisionSidebarWidth = 320;
  bool _showGaugeDashboard = true;

  static const Duration _windowResizeSettleDelay = Duration(milliseconds: 40);

  final WordCountService _wordCountService = WordCountService.instance;
  late final VoidCallback _stopWritingProgressClock;

  // 主編輯器文字
  String get contentText => ref.read(editorContentProvider);
  set contentText(String value) {
    _cancelPendingContentCommit();
    ref.read(editorContentProvider.notifier).setContent(value);
  }

  final HighlightTextEditingController textController =
      HighlightTextEditingController();
  final PlainTextQuillSearchController _quillSearchController =
      PlainTextQuillSearchController();
  String _lastObservedEditorText = "";
  RhodantheEditorSession? _rhodantheSession;
  final RhodantheRolloutEvidenceController _rhodantheRolloutEvidence =
      RhodantheRolloutEvidenceController();
  final RhodantheRolloutNoticeTracker _rhodantheRolloutNotices =
      RhodantheRolloutNoticeTracker();
  int _rhodantheQueryRevision = 0;
  RhodantheFillerRequest? _rhodantheFillerRequest;
  List<RhodantheExternalAnnotation> _rhodantheDiagnostics =
      const <RhodantheExternalAnnotation>[];
  static const InlineAnnotationRhodantheAdapter _inlineRhodantheAdapter =
      InlineAnnotationRhodantheAdapter();

  List<RhodantheExternalAnnotation> get _rhodantheInlineAnnotations =>
      _inlineRhodantheAdapter.build(
        projection: textController.projection,
        documentRevision: textController.textRevision,
      );

  // 浮動視窗狀態
  bool showFindReplaceWindow = false;
  bool showPunctuationPanel = false;
  final TextEditingController findController = TextEditingController();
  final TextEditingController replaceController = TextEditingController();
  final FindReplaceOptions findReplaceOptions = FindReplaceOptions();
  final RibbonController _ribbonController = RibbonController();
  final _bodyEditorKey = GlobalKey<EditorTextBoxState>();
  final _findBarKey = GlobalKey<FindReplaceBarState>();
  bool _fileCommandRunning = false;
  final _topAppBarKey = GlobalKey<MonogatariTopAppBarState>();
  final _workspaceFocus = FocusNode(debugLabel: "Workspace");
  final _moduleFocus = <AppModuleId, FocusNode>{};
  AppModule _lastFunctionModule = AppModule.all.first;
  bool _moduleSwitcherOpen = false;
  bool _moduleNavigationInProgress = false;

  AppModule get _currentModule => AppModule.forPage(slidePageIndexNow);

  bool get _navigationBlocked {
    final help = HelpController.maybeOf(context);
    final focus = FocusManager.instance.primaryFocus;
    final composing = focus?.context
        ?.findAncestorStateOfType<EditableTextState>()
        ?.widget
        .controller
        .value
        .composing;
    return !mounted ||
        (composing != null && composing.isValid && !composing.isCollapsed) ||
        _moduleSwitcherOpen ||
        _fileCommandRunning ||
        _isProjectSwitching ||
        _isExitConfirmationInProgress ||
        _isApplyingProjectHistory ||
        ModalRoute.of(context)?.isCurrent == false ||
        help?.ownsFocus == true ||
        _topAppBarKey.currentState?.ownsMenuFocus == true ||
        ref.read(projectIoControllerProvider).blocksProjectEditor ||
        (editorFocusNode.hasFocus &&
            (_bodyEditorKey.currentState?.hasActiveCompletion == true ||
                (textController.value.composing.isValid &&
                    !textController.value.composing.isCollapsed)));
  }

  void _selectModule(AppModule module) {
    if (_navigationBlocked) return;
    _topAppBarKey.currentState?.dismissKeyTips();
    if (module.id == _currentModule.id) return;
    final origin = FocusManager.instance.primaryFocus;
    if (origin != null &&
        origin != _workspaceFocus &&
        origin.context?.findAncestorWidgetOfExactType<MonogatariTopAppBar>() ==
            null) {
      _moduleFocus[_currentModule.id] = origin;
    }
    if (_currentModule.id != AppModuleId.editor) {
      _lastFunctionModule = _currentModule;
    }
    _moduleNavigationInProgress = true;
    _syncEditorToSelectedChapter();
    _recordPageTransitionIfNeeded(module.pageIndex);
    setState(() => slidePageIndexNow = module.pageIndex);
    final session = _projectSessionVersion;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (session == _projectSessionVersion && _currentModule.id == module.id) {
        final target = module.id == AppModuleId.editor
            ? editorFocusNode
            : _moduleFocus[module.id];
        if (target?.context?.mounted == true && target!.canRequestFocus) {
          target.requestFocus();
        } else {
          _workspaceFocus.requestFocus();
        }
      }
      _moduleNavigationInProgress = false;
    });
  }

  Future<void> _openModuleSwitcher() async {
    if (_navigationBlocked) return;
    _topAppBarKey.currentState?.dismissKeyTips();
    final origin = FocusManager.instance.primaryFocus;
    if (origin != null &&
        origin != _workspaceFocus &&
        origin.context?.findAncestorWidgetOfExactType<MonogatariTopAppBar>() ==
            null) {
      _moduleFocus[_currentModule.id] = origin;
    }
    final session = _projectSessionVersion;
    _moduleSwitcherOpen = true;
    try {
      final selected = await ModuleSwitcher.show(context, _currentModule);
      if (!mounted || session != _projectSessionVersion) return;
      _moduleSwitcherOpen = false;
      if (selected != null) _selectModule(selected);
    } finally {
      _moduleSwitcherOpen = false;
    }
  }

  int _findOptionsRevision = 0;
  String _ribbonSearchQuery = "";
  final FocusNode editorFocusNode = FocusNode();

  // 搜尋狀態
  int _currentMatchIndex = -1;
  List<TextSelection> _searchMatches = [];

  AppSettingsStateData get _settingsState =>
      ref.read(settingsStateProvider).valueOrNull ??
      const AppSettingsStateData();

  EditorCoordinatorState get _editorCoordinatorState =>
      ref.read(editorCoordinatorProvider);

  EditorCoordinatorNotifier get _editorCoordinatorNotifier =>
      ref.read(editorCoordinatorProvider.notifier);

  bool get isLoading => _editorCoordinatorState.isLoading;
  bool get _isSyncing => _editorCoordinatorState.isSyncing;
  bool get hasUnsavedChanges => _editorCoordinatorState.hasUnsavedChanges;

  final List<ProviderSubscription<Object?>> _subscriptions = [];

  late final TextChangeDebouncer _textChangeDebouncer;
  Timer? _projectHistoryRecordTimer;
  int _projectDataRevision = 0;
  bool _suppressRevisionDirty = false;
  int? _lastRecordedProjectDataRevision;
  int? _pendingProjectHistoryRevision;
  Timer? _autoSaveTimer;
  Timer? _autoBackupTimer;
  bool _isWritingAutoSave = false;
  bool _isWritingAutoBackup = false;
  int? _lastAutoBackupRevision;
  final ProjectIoSessionCoordinator _projectIoCoordinator =
      ProjectIoSessionCoordinator();
  late ProjectIoSessionToken _projectIoSession;
  bool _isProjectSwitching = false;
  bool _isApplyingProjectHistory = false;
  bool _isP2pProjectStatusPublishScheduled = false;
  bool _hasUnpersistedRemoteDraft = false;
  String? _p2pAutoApplyApprovedSessionKey;
  static const Duration _projectHistoryRecordDelay = Duration(
    milliseconds: 500,
  );
  static const Set<int> _ignoredPageTransitionIndexes = {
    0, // Welcome
    16, // Help
    9, // Glossary
    10, // Palettes
    11, // Proofreading
    14, // About
  };
  static const Set<int> _projectBackedPageIndexes = {
    1, // Base info
    2, // Chapters
    3, // Outline
    4, // World settings
    5, // Characters
    6, // Timeline
    7, // Character relationships
    8, // Plans
    15, // Items
  };

  List<ChapterModule.SegmentData> get segmentsData =>
      ref.read(segmentsDataProvider);

  // 選取狀態
  String? get selectedSegID => ref.read(editorSelectionProvider).selectedSegID;

  String? get selectedChapID =>
      ref.read(editorSelectionProvider).selectedChapID;

  int _proofreadingChapterSwitchVersion = 0;
  int get totalWords => ref.read(totalWordsProvider);
  set totalWords(int value) {
    ref.read(totalWordsProvider.notifier).setTotalWords(value);
  }

  int get _cursorOffset => ref.read(editorSelectionProvider).cursorOffset;

  ProjectFile? get currentProject => ref.read(currentProjectFileProvider);
  set currentProject(ProjectFile? value) {
    ref.read(currentProjectFileProvider.notifier).setCurrentProjectFile(value);
  }

  // 檔案狀態

  // 追蹤最後一個焦點輸入框
  FocusNode? _lastFocusedEditableNode;
  bool _preserveEditableFocusForEditorAction = false;
  int _editorToolbarInteractionVersion = 0;

  void _onFocusChange() {
    // Help temporarily owns focus without changing editor selection/history.
    final help = HelpController.maybeOf(context);
    if (help?.ownsFocus == true ||
        _moduleSwitcherOpen ||
        _moduleNavigationInProgress) {
      return;
    }
    final node = WidgetsBinding.instance.focusManager.primaryFocus;
    // Moving between modules can temporarily focus the workspace itself.
    // Preserve the old module's selection instead of clearing every controller.
    if (node == _workspaceFocus) {
      _lastFocusedEditableNode = null;
      return;
    }
    final previousEditableNode = _lastFocusedEditableNode;
    final focusChangedFromEditable =
        previousEditableNode != null && previousEditableNode != node;

    if (focusChangedFromEditable) {
      _recordProjectHistorySnapshot();
    }

    if (node != null &&
        (_findEditableForFocusNode(node) != null ||
            PlainTextQuillEditorCommands.forFocusNode(node) != null)) {
      // 焦點進入編輯框
      _lastFocusedEditableNode = node;
      debugPrint("[DEBUG] Focus on editable: $node");
    } else if (node != null && node.canRequestFocus) {
      // 焦點轉移到其他可請求焦點的 widget（非編輯框、非功能按鈕）
      debugPrint("[DEBUG] Focus moved away from editable to: $node");
      if (_preserveEditableFocusForEditorAction ||
          node.context?.findAncestorWidgetOfExactType<MonogatariTopAppBar>() !=
              null) {
        debugPrint("[DEBUG] Preserving editable focus for editor action");
        return;
      }
      _clearEditableFocus();
    }
  }

  void _prepareEditorToolbarAction() {
    _editorToolbarInteractionVersion += 1;
    _preserveEditableFocusForEditorAction = true;
  }

  void _finishEditorToolbarAction() {
    final version = _editorToolbarInteractionVersion;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (version == _editorToolbarInteractionVersion) {
        _preserveEditableFocusForEditorAction = false;
      }
    });
  }

  void _clearEditableFocus() {
    debugPrint("[DEBUG] Clearing editable focus");

    final lastFocusedEditableNode = _lastFocusedEditableNode;
    _lastFocusedEditableNode = null;

    if (lastFocusedEditableNode != null && lastFocusedEditableNode.hasFocus) {
      lastFocusedEditableNode.unfocus();
    }

    _clearAllSelections();
  }

  void _clearAllSelections() {
    debugPrint("[DEBUG] Clearing all selections");

    // 清除主編輯器的選取
    if (textController.selection.isValid &&
        !textController.selection.isCollapsed) {
      textController.selection = TextSelection.collapsed(
        offset: textController.selection.baseOffset,
      );
    }

    // 清除搜尋欄的選取
    if (findController.selection.isValid &&
        !findController.selection.isCollapsed) {
      findController.selection = TextSelection.collapsed(
        offset: findController.selection.baseOffset,
      );
    }

    if (replaceController.selection.isValid &&
        !replaceController.selection.isCollapsed) {
      replaceController.selection = TextSelection.collapsed(
        offset: replaceController.selection.baseOffset,
      );
    }
  }

  int _clampOffset(int offset, int textLength) {
    if (offset < 0) {
      return 0;
    }
    return offset.clamp(0, textLength);
  }

  TextSelection _clampSelection(TextSelection selection, String text) {
    final int textLength = text.length;
    if (!selection.isValid) {
      return const TextSelection.collapsed(offset: 0);
    }

    final int base = _clampOffset(selection.baseOffset, textLength);
    final int extent = _clampOffset(selection.extentOffset, textLength);

    return TextSelection(
      baseOffset: base,
      extentOffset: extent,
      affinity: selection.affinity,
      isDirectional: selection.isDirectional,
    );
  }

  void _bootstrapEditorSelectionFromProviderState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final selectionState = ref.read(editorSelectionProvider);
      final segments = ref.read(segmentsDataProvider);

      String? selectedSegID = selectionState.selectedSegID;
      String? selectedChapID = selectionState.selectedChapID;
      String initialContent = ref.read(editorContentProvider);

      final firstChapter = ChapterModule.ChapterTree.firstChapter(segments);
      if ((selectedSegID == null || selectedChapID == null) &&
          firstChapter != null) {
        selectedSegID = firstChapter.folder.segmentUUID;
        selectedChapID = firstChapter.chapter.chapterUUID;
        initialContent = firstChapter.chapter.chapterContent;
      }

      final int cursorOffset = _clampOffset(
        selectionState.cursorOffset,
        initialContent.length,
      );

      final editorSelectionNotifier = ref.read(
        editorSelectionProvider.notifier,
      );
      editorSelectionNotifier.setSelectionAndCursor(
        selectedSegID: selectedSegID,
        selectedChapID: selectedChapID,
        cursorOffset: cursorOffset,
      );

      final editorContentNotifier = ref.read(editorContentProvider.notifier);
      if (ref.read(editorContentProvider) != initialContent) {
        editorContentNotifier.setContent(initialContent);
      }

      // The initial unsaved workspace can be edited before choosing New File.
      // Seed its personal counter without treating existing text as new writing.
      ref
          .read(dailyWritingProgressProvider)
          .replaceBaseline(ref.read(projectUuidProvider), {
            for (final location in ChapterModule.ChapterTree.chaptersDepthFirst(
              segments,
            ))
              location.chapter.chapterUUID:
                  location.chapter.chapterUUID == selectedChapID
                  ? initialContent
                  : location.chapter.chapterContent,
          });

      // Seed the raw snapshot first so projection publication is not mistaken
      // for a local collaborative edit during startup.
      _lastObservedEditorText = initialContent;
      textController.setRawText(
        initialContent,
        rawSelection: TextSelection.collapsed(offset: cursorOffset),
      );

      _refreshActiveChapterWordCount();
    });
  }

  void _refreshActiveChapterWordCount({String? contentOverride}) {
    final String? activeChapterId = selectedChapID;
    final activeWordCountNotifier = ref.read(
      activeChapterWordCountProvider.notifier,
    );
    if (activeChapterId == null) {
      activeWordCountNotifier.reset();
      return;
    }

    final WordCountMode mode = _settingsState.wordCountMode;
    final String activeText = contentOverride == null
        ? textController.readerText
        : InlineAnnotationProjection.build(
            contentOverride,
          ).readerTextFor(TextRange(start: 0, end: contentOverride.length));
    final lookup = _wordCountService.observeChapter(
      chapterId: activeChapterId,
      content: activeText,
      mode: mode,
    );
    if (lookup.isPending) {
      activeWordCountNotifier.markComputing(chapterId: activeChapterId);
    } else {
      activeWordCountNotifier.refreshFromCount(
        chapterId: activeChapterId,
        count: lookup.count,
      );
    }
  }

  void _handleWordCountServiceChanged() {
    if (!mounted) {
      return;
    }
    totalWords = _wordCountService.total;
    final chapterId = selectedChapID;
    if (chapterId == null) {
      return;
    }
    final lookup = _wordCountService.lookup(
      chapterId,
      _settingsState.wordCountMode,
    );
    final notifier = ref.read(activeChapterWordCountProvider.notifier);
    if (lookup.isPending) {
      notifier.markComputing(chapterId: chapterId);
    } else {
      notifier.refreshFromCount(chapterId: chapterId, count: lookup.count);
    }
  }

  Future<void> _initializeRhodanthe() async {
    try {
      final restored = await _rhodantheRolloutEvidence.load();
      if (restored) {
        debugPrint(
          "Rhodanthe rollout evidence restored: "
          "${_rhodantheRolloutEvidence.auditSummary()}",
        );
      }
    } catch (error) {
      debugPrint("Rhodanthe evidence restore failed: $error");
    }
    RhodantheRolloutMode effectiveMode = configuredRhodantheRolloutMode;
    if (!hasConfiguredRhodantheModeOverride) {
      try {
        final cohort = await RhodantheRolloutCohortController().resolve(
          stage: configuredRhodantheReleaseStage,
        );
        effectiveMode = cohort.effectiveMode;
        debugPrint("Rhodanthe rollout cohort: ${jsonEncode(cohort.toJson())}");
      } catch (error) {
        effectiveMode = RhodantheRolloutMode.disabled;
        debugPrint("Rhodanthe cohort resolution failed; disabled: $error");
      }
    }
    final session = await RhodantheEditorSession.start(
      mode: effectiveMode,
      onPlan: (renderPlan) {
        if (!mounted) return;
        textController.publishRhodantheRenderPlan(renderPlan);
        _syncRhodantheRangesToQuill(renderPlan);
      },
      onShadowReport: (report) {
        if (!report.isExactMatch) {
          debugPrint(
            "Rhodanthe shadow mismatch at revision ${report.revision}: "
            "Dart=${report.dartRanges.length}, "
            "Rust=${report.nativeRanges.length}",
          );
        }
      },
      onFailure: (failure) {
        debugPrint("Rhodanthe fallback: ${failure.code}: ${failure.message}");
      },
      onHealthChanged: (health) {
        if (!mounted) return;
        if (health.status == RhodantheSessionStatus.circuitOpen ||
            health.status == RhodantheSessionStatus.degraded) {
          textController.clearRhodantheRenderPlan();
          _quillSearchController.clearProofreadingRanges();
        }
      },
      onObservation: (observation) {
        _rhodantheRolloutEvidence.record(observation);
        final decision = _rhodantheRolloutEvidence.evaluate(observation.mode);
        final notice = _rhodantheRolloutNotices.observe(decision);
        if (notice == null) return;
        if (notice.kind == RhodantheRolloutNoticeKind.progress) {
          debugPrint(
            "Rhodanthe rollout progress: "
            "mode=${decision.currentMode.name}, "
            "progress=${notice.progressPercent}%, "
            "samples=${decision.completedSamples}/${decision.requiredSamples}",
          );
          return;
        }
        final action = switch (notice.kind) {
          RhodantheRolloutNoticeKind.rollback => "rollback",
          RhodantheRolloutNoticeKind.defaultOnReady => "default-on readiness",
          RhodantheRolloutNoticeKind.promotion => "promotion",
          RhodantheRolloutNoticeKind.progress => "progress",
        };
        debugPrint(
          "Rhodanthe $action recommendation: "
          "${decision.recommendedMode.name}, reason=${decision.reason.name}, "
          "samples=${decision.completedSamples}/${decision.requiredSamples}, "
          "p95=${decision.p95Micros}us",
        );
        debugPrint(
          "Rhodanthe rollout audit: "
          "${_rhodantheRolloutEvidence.auditSummary()}",
        );
      },
    );
    if (!mounted) {
      await session?.dispose();
      return;
    }
    _rhodantheSession = session;
    await _synchronizeRhodantheDocument();
  }

  Future<void> _synchronizeRhodantheDocument() async {
    final session = _rhodantheSession;
    final chapterId = selectedChapID;
    if (session == null || chapterId == null) return;
    try {
      await session.synchronizeDocument(
        documentId: chapterId,
        revision: textController.textRevision,
        text: textController.text,
      );
    } catch (_) {
      // The session reports the structured failure and remains off the input path.
    }
  }

  void _syncRhodantheRangesToQuill(RhodantheVersionedRenderPlan renderPlan) {
    if (renderPlan.documentId != selectedChapID ||
        renderPlan.revision != textController.textRevision ||
        renderPlan.plan.textLenUtf16 != textController.text.length) {
      return;
    }
    final rhodantheTheme = RhodantheTheme.resolve(context);
    _quillSearchController.setRenderRanges(<PlainTextQuillRenderRange>[
      for (final run in renderPlan.plan.runs)
        if (run.styleTokenSetId >= 0 &&
            run.styleTokenSetId < renderPlan.plan.tokenSets.length)
          if (renderPlan.plan.tokenSets[run.styleTokenSetId]
              case final tokenSet)
            if (tokenSet.background != null || tokenSet.decoration != null)
              PlainTextQuillRenderRange(
                range: TextRange(start: run.range.start, end: run.range.end),
                // Find/Replace already paints these ranges. Applying the
                // analyzer's background again darkens the same glyph boxes.
                backgroundColor:
                    tokenSet.background == null ||
                        tokenSet.background!.startsWith("search.")
                    ? null
                    : rhodantheTheme.resolveColor(tokenSet.background!),
                decorationColor: tokenSet.decoration == null
                    ? null
                    : rhodantheTheme.resolveColor(tokenSet.decoration!.color),
                decorationThickness:
                    tokenSet.decoration?.thickness.clamp(1.0, 3.0) ?? 1,
                doubleUnderline:
                    tokenSet.foreground == "filler.foreground" ||
                    tokenSet.decoration?.color == "filler.decoration",
              ),
    ]);
  }

  void _syncFindRangesToQuill(String query, {bool selectCurrent = true}) {
    if (query.isEmpty) {
      _quillSearchController.clearSearchResults();
      return;
    }
    _quillSearchController.showHostResults(
      query: query,
      matches: _searchMatches.map(
        (match) => TextRange(start: match.start, end: match.end),
      ),
      currentMatchIndex: _currentMatchIndex,
      selectCurrent: selectCurrent,
    );
  }

  Future<void> _analyzeRhodantheSearch(
    String query,
    FindReplaceOptions options,
    List<TextSelection> dartMatches,
    int currentIndex,
  ) async {
    final session = _rhodantheSession;
    if (session == null || query.isEmpty) return;
    await _synchronizeRhodantheDocument();
    await session.analyze(
      search: RhodantheSearchRequest(
        query: query,
        queryRevision: ++_rhodantheQueryRevision,
        activeMatchIndex: currentIndex >= 0 ? currentIndex : null,
        maxResults: HighlightTextEditingController.maxSearchResults,
        options: RhodantheSearchOptions(
          matchCase: options.matchCase,
          wholeWord: options.wholeWord,
          useRegexp: options.useRegexp,
          matchWidth: options.matchWidth,
          ignorePunctuation: options.ignorePunctuation,
          ignoreWhitespace: options.ignoreWhitespace,
        ),
      ),
      filler: session.mode == RhodantheRolloutMode.full
          ? _rhodantheFillerRequest
          : null,
      externalAnnotations: session.mode == RhodantheRolloutMode.full
          ? <RhodantheExternalAnnotation>[
              ..._rhodantheDiagnostics,
              ..._rhodantheInlineAnnotations,
            ]
          : const <RhodantheExternalAnnotation>[],
      dartSearchRanges: <RhodantheRange>[
        for (final match in dartMatches) RhodantheRange(match.start, match.end),
      ],
    );
  }

  void _handleRhodantheProofreading({
    required List<TextSelection> fillerMatches,
    required List<TextSelection> diagnosticMatches,
    required List<String> fillerWords,
    required int dictionaryRevision,
  }) {
    final session = _rhodantheSession;
    if (session == null || session.mode != RhodantheRolloutMode.full) return;
    _rhodantheFillerRequest = fillerWords.isEmpty
        ? null
        : RhodantheFillerRequest(
            dictionaryRevision: dictionaryRevision,
            words: fillerWords,
          );
    _rhodantheDiagnostics = <RhodantheExternalAnnotation>[
      for (var index = 0; index < diagnosticMatches.length; index++)
        RhodantheDiagnostic(
          diagnosticId: "proofreading:$dictionaryRevision:$index",
          range: RhodantheRange(
            diagnosticMatches[index].start,
            diagnosticMatches[index].end,
          ),
        ).toAnnotation(sourceOrder: index),
    ];

    final query = findController.text;
    if (showFindReplaceWindow && query.isNotEmpty) {
      unawaited(
        _analyzeRhodantheSearch(
          query,
          findReplaceOptions,
          _searchMatches,
          _currentMatchIndex,
        ),
      );
      return;
    }
    unawaited(_analyzeRhodantheProofreadingLayers());
  }

  Future<void> _analyzeRhodantheProofreadingLayers() async {
    final session = _rhodantheSession;
    if (session == null) return;
    await _synchronizeRhodantheDocument();
    if (session.mode != RhodantheRolloutMode.full) return;
    await session.analyze(
      filler: _rhodantheFillerRequest,
      externalAnnotations: <RhodantheExternalAnnotation>[
        ..._rhodantheDiagnostics,
        ..._rhodantheInlineAnnotations,
      ],
    );
  }

  Future<void> _handleInlineAnnotationInteraction(
    EditorTextInteraction interaction,
  ) async {
    final entry = textController.projection.annotationAtDisplayOffset(
      interaction.displayOffset,
    );
    if (entry == null) return;

    final annotation = entry.annotation;
    final sourceStart = annotation.sourceRange.start;
    final rawSyntax = textController.rawSyntaxAtSourceStart(sourceStart);
    if (rawSyntax == null) return;
    final target = const InlineAnnotationTargetResolver().resolve(
      annotation: annotation,
      characters: ref.read(characterDataProvider),
      locations: ref.read(worldSettingsDataProvider),
      outline: ref.read(outlineDataProvider),
      foreshadows: ref.read(foreshadowDataProvider),
      plans: ref.read(updatePlanDataProvider),
      itemClasses: ref.read(itemWorkspaceProvider).itemClasses,
    );

    final anchor = Rect.fromCircle(
      center: interaction.globalPosition,
      radius: 1,
    );
    final result = await InlineAnnotationDetailsDialog.show(
      context: context,
      annotation: annotation,
      rawSyntax: rawSyntax,
      target: target,
      anchor: anchor,
    );
    if (!mounted) return;

    switch (result?.action) {
      case InlineAnnotationDetailsAction.applyDisplayText:
        if (!textController.updateAnnotationDisplayText(
          sourceStart,
          result?.displayText ?? annotation.displayText,
        )) {
          AppFeedback.warning(context, "標記已變更，無法更新顯示文字。");
        }
        break;
      case InlineAnnotationDetailsAction.applySyntax:
        if (!textController.replaceAnnotationSyntax(
          sourceStart,
          result?.rawSyntax ?? rawSyntax,
        )) {
          AppFeedback.warning(context, "標記已變更，無法套用完整語法。");
        }
        break;
      case InlineAnnotationDetailsAction.editAnnotation:
        final replacement = await InlineAnnotationEditDialog.show(
          context: context,
          annotation: annotation,
          rawSyntax: rawSyntax,
          anchor: anchor,
        );
        if (!mounted) return;
        if (replacement == null) {
          textController.collapseAnnotations();
          break;
        }
        if (!textController.replaceAnnotationSyntax(sourceStart, replacement)) {
          AppFeedback.warning(context, "標記已變更，無法套用編輯。");
        }
        break;
      case InlineAnnotationDetailsAction.navigateToTarget:
        if (target == null) break;
        _navigateToInlineAnnotationTarget(annotation.kind, target.id);
        break;
      case InlineAnnotationDetailsAction.relinkTarget:
        final candidates = const InlineAnnotationTargetResolver().candidates(
          kind: annotation.kind,
          characters: ref.read(characterDataProvider),
          locations: ref.read(worldSettingsDataProvider),
          outline: ref.read(outlineDataProvider),
          foreshadows: ref.read(foreshadowDataProvider),
          plans: ref.read(updatePlanDataProvider),
          itemClasses: ref.read(itemWorkspaceProvider).itemClasses,
        );
        if (candidates.isEmpty) {
          await AppDialog.message(
            context: context,
            title: context.l10n.uiNoTargetsAvailable,
            message: context.l10n.uiCreateATargetOfTheSameTypeBefore,
          );
          if (mounted) textController.collapseAnnotations();
          break;
        }
        final replacement = await InlineAnnotationRelinkDialog.show(
          context: context,
          candidates: candidates,
        );
        if (!mounted) return;
        if (replacement == null) {
          textController.collapseAnnotations();
          break;
        }
        if (!textController.relinkAnnotationTarget(
          sourceStart: sourceStart,
          targetId: replacement.id,
          displayText: replacement.primaryName,
        )) {
          AppFeedback.warning(context, "標記已變更，無法重新連結。");
        }
        break;
      case InlineAnnotationDetailsAction.copySyntax:
        await Clipboard.setData(
          ClipboardData(text: result?.rawSyntax ?? rawSyntax),
        );
        if (mounted)
          AppFeedback.success(
            context,
            context.l10n.uiFullAnnotationSyntaxCopied,
          );
        textController.collapseAnnotations();
        break;
      case InlineAnnotationDetailsAction.updateToPrimaryName:
        final updated =
            target != null &&
            textController.updateAnnotationDisplayText(
              sourceStart,
              target.primaryName,
            );
        if (!updated) {
          AppFeedback.warning(context, "標記已變更，無法更新名稱。");
        }
        break;
      case InlineAnnotationDetailsAction.removeKeepText:
        if (!textController.removeAnnotationKeepText(sourceStart)) {
          AppFeedback.warning(context, "標記已變更，無法移除。");
        }
        break;
      case null:
        textController.collapseAnnotations();
        break;
    }
  }

  void _navigateToInlineAnnotationTarget(
    InlineAnnotationKind kind,
    String targetId,
  ) {
    _syncEditorToSelectedChapter();
    final pageIndex = switch (kind) {
      InlineAnnotationKind.character => 5,
      InlineAnnotationKind.event => 3,
      InlineAnnotationKind.location => 7,
      InlineAnnotationKind.foreshadowing || InlineAnnotationKind.plan => 9,
      InlineAnnotationKind.item => 8,
      InlineAnnotationKind.emphasis => null,
    };
    if (pageIndex == null) return;
    _recordPageTransitionIfNeeded(pageIndex);
    setState(() {
      if (kind == InlineAnnotationKind.character) {
        _requestedCharacterId = targetId;
        _characterSelectionRequestId++;
      } else if (kind == InlineAnnotationKind.event) {
        ref
            .read(outlineSelectionRequestProvider.notifier)
            .requestTarget(targetId);
      } else if (kind == InlineAnnotationKind.location) {
        _requestedLocationId = targetId;
        _locationSelectionRequestId++;
      } else if (kind == InlineAnnotationKind.foreshadowing ||
          kind == InlineAnnotationKind.plan) {
        _requestedPlanTargetId = targetId;
        _requestedPlanTargetKind = kind == InlineAnnotationKind.foreshadowing
            ? PlanModule.PlanSelectionTarget.foreshadow
            : PlanModule.PlanSelectionTarget.updatePlan;
        _planSelectionRequestId++;
      } else if (kind == InlineAnnotationKind.item) {
        _requestedItemClassId = targetId;
        _itemSelectionRequestId++;
      }
      slidePageIndexNow = pageIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    findController.addListener(_onRibbonSearchQueryChanged);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(ref.read(p2pSyncProvider.notifier).initialize());
      _publishLocalP2pProjectStatusNow();
    });
    final writingProgress = ref.read(dailyWritingProgressProvider);
    writingProgress.startClock();
    _stopWritingProgressClock = writingProgress.stopClock;
    _projectIoSession = _projectIoCoordinator.beginSession("");
    _wordCountService.addListener(_handleWordCountServiceChanged);

    _textChangeDebouncer = TextChangeDebouncer(
      onWordCountTrigger: (nextContent) {
        _flushPendingEditorContent();
        _refreshActiveChapterWordCount();
        _recordProjectHistorySnapshot();
      },
      onContentCommitTrigger: (nextContent) {
        if (!mounted) return;
        if (ref.read(editorContentProvider) == nextContent) return;
        ref.read(editorContentProvider.notifier).setContent(nextContent);
      },
    );

    // 註冊視窗監聽器並設置視窗選項
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      windowManager.addListener(this);
      _initWindowManager();
    }

    _bootstrapEditorSelectionFromProviderState();
    unawaited(_initializeRhodanthe());
    _configureAutoSaveTimer(_settingsState);
    _configureAutoBackupTimer(_settingsState);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        DesktopProjectLaunch.bind(_openProjectFromDesktop);
      }
    });

    // 監聽文字變化
    textController.addListener(() {
      final rawSelection = textController.projection.displaySelectionToRaw(
        textController.selection,
      );
      final int selectionOffset = rawSelection.baseOffset;
      final int normalizedOffset = _clampOffset(
        selectionOffset,
        textController.rawText.length,
      );
      final String currentText = textController.rawText;
      final bool textChanged =
          !_isSyncing && _lastObservedEditorText != currentText;
      final chapterId = selectedChapID;
      final composing = textController.value.composing;
      if (!_isSyncing &&
          chapterId != null &&
          !ref.read(editorCoordinatorProvider).isApplyingProjectData &&
          (!composing.isValid || composing.isCollapsed)) {
        ref
            .read(dailyWritingProgressProvider)
            .observeChapter(chapterId, currentText);
      }
      if (chapterId != null &&
          (!composing.isValid || composing.isCollapsed) &&
          ref.read(revisionTrackingProvider).baseline != null) {
        ref
            .read(revisionEditorDraftProvider.notifier)
            .update(ref.read(projectUuidProvider), chapterId, currentText);
      }
      final focusOffset = _clampOffset(
        rawSelection.extentOffset,
        currentText.length,
      );

      // 將輸入事件轉交 coordinator，UI listener 僅保留畫面刷新職責。
      if (textChanged) {
        _rhodantheDiagnostics = const <RhodantheExternalAnnotation>[];
        final delta = CollaborativeTextDelta.between(
          _lastObservedEditorText,
          currentText,
        );
        cancelFindAllMatches(textController);
        if (chapterId != null) {
          ref
              .read(collaborationProvider.notifier)
              .recordLocalTextEdit(
                chapterId: chapterId,
                delta: delta,
                anchorOffset: normalizedOffset,
                focusOffset: focusOffset,
              );
        }
        _lastObservedEditorText = currentText;
        unawaited(_analyzeRhodantheProofreadingLayers());
        _editorCoordinatorNotifier.updateCursorOffset(normalizedOffset);
        _editorCoordinatorNotifier.markAsModified();

        _textChangeDebouncer.onTextChanged(currentText);

        // 當文字內容變化時，清除所有高亮和搜尋狀態
        if (_searchMatches.isNotEmpty || _currentMatchIndex != -1) {
          setState(() {
            _searchMatches = [];
            _currentMatchIndex = -1;
            textController.clearAllHighlights();
          });
          _quillSearchController.clearSearchResults();
        }
      } else if (_cursorOffset != normalizedOffset) {
        _editorCoordinatorNotifier.updateCursorOffset(normalizedOffset);
      }
      if (!textChanged && chapterId != null) {
        ref
            .read(collaborationProvider.notifier)
            .updateLocalCursor(
              chapterId: chapterId,
              anchorOffset: normalizedOffset,
              focusOffset: focusOffset,
            );
      }
    });

    // 啟動時不自動建立新專案，避免與使用者手動開檔流程競態。

    _subscriptions.add(
      ref.listenManual<AppSettingsStateData>(
        settingsStateProvider.select(
          (state) => state.valueOrNull ?? const AppSettingsStateData(),
        ),
        (previous, next) {
          if (!mounted) {
            return;
          }
          if (previous?.autoSaveEnabled != next.autoSaveEnabled ||
              previous?.autoSaveIntervalMinutes !=
                  next.autoSaveIntervalMinutes) {
            _configureAutoSaveTimer(next);
          }
          if (previous?.autoBackupEnabled != next.autoBackupEnabled ||
              previous?.autoBackupIntervalMinutes !=
                  next.autoBackupIntervalMinutes) {
            _configureAutoBackupTimer(next);
          }
        },
      ),
    );

    _subscriptions.add(
      ref.listenManual<ProjectFile?>(currentProjectFileProvider, (
        previous,
        next,
      ) {
        _publishLocalP2pProjectStatus();
      }),
    );
    _subscriptions.add(
      ref.listenManual<String>(projectUuidProvider, (previous, next) {
        _publishLocalP2pProjectStatus();
      }),
    );
    _subscriptions.add(
      ref.listenManual<String?>(revisionTrackingJsonProvider, (previous, next) {
        if (!mounted || _suppressRevisionDirty || previous == next) return;
        _projectDataRevision++;
        ref.read(editorCoordinatorProvider.notifier).markAsModified();
        if (RevisionSessionCodec.decisionDigest(previous) !=
            RevisionSessionCodec.decisionDigest(next)) {
          _scheduleProjectHistoryRecord(_projectDataRevision);
        }
      }),
    );
    _subscriptions.add(
      ref.listenManual<bool>(
        editorCoordinatorProvider.select((state) => state.hasUnsavedChanges),
        (previous, next) {
          _publishLocalP2pProjectStatus();
        },
      ),
    );

    _subscriptions.add(
      ref.listenManual<AliasRename?>(aliasRenameProvider, (previous, rename) {
        if (rename == null) return;
        unawaited(_applyAliasMentionRename(rename));
      }),
    );
    _subscriptions.add(
      ref.listenManual<String>(editorContentProvider, (previous, next) {
        if (!mounted || _isSyncing || textController.rawText == next) {
          return;
        }

        final selectionRebase = ref
            .read(collaborationProvider)
            .localSelectionRebase;
        final currentSelection =
            selectionRebase != null &&
                selectionRebase.documentId == selectedChapID &&
                selectionRebase.expectedText == next
            ? TextSelection(
                baseOffset: _clampOffset(
                  selectionRebase.anchorOffset,
                  next.length,
                ),
                extentOffset: _clampOffset(
                  selectionRebase.focusOffset,
                  next.length,
                ),
              )
            : _clampSelection(
                textController.projection.displaySelectionToRaw(
                  textController.selection,
                ),
                next,
              );

        final coordinatorNotifier = ref.read(
          editorCoordinatorProvider.notifier,
        );
        final beganSync = coordinatorNotifier.beginSync();
        try {
          textController.setRawText(next, rawSelection: currentSelection);
          _lastObservedEditorText = next;
          unawaited(_synchronizeRhodantheDocument());
          if (selectionRebase != null &&
              selectionRebase.documentId == selectedChapID &&
              selectionRebase.expectedText == next) {
            ref
                .read(collaborationProvider.notifier)
                .consumeLocalSelectionRebase(selectionRebase.revision);
          }
        } finally {
          if (beganSync) {
            coordinatorNotifier.endSync();
          }
        }

        _refreshActiveChapterWordCount();
      }),
    );

    _subscriptions.add(
      ref.listenManual<EditorSelectionState>(editorSelectionProvider, (
        previous,
        next,
      ) {
        if (!mounted) {
          return;
        }
        if (previous?.selectedChapID == next.selectedChapID &&
            previous?.selectedSegID == next.selectedSegID) {
          return;
        }
        // Selection and editor content are separate provider updates. Resolve
        // the newly selected chapter directly from the project model so the
        // word-count cache never sees the new id paired with the old editor
        // text during that brief transition.
        _refreshActiveChapterWordCount(
          contentOverride: ref.read(selectedChapterStoredContentProvider) ?? "",
        );
      }),
    );

    _subscriptions.add(
      ref.listenManual<List<ChapterModule.SegmentData>>(segmentsDataProvider, (
        previous,
        next,
      ) {
        if (!mounted || previous == null || previous == next) {
          return;
        }

        final progress = ref.read(dailyWritingProgressProvider);
        final before = {
          for (final location in ChapterModule.ChapterTree.chaptersDepthFirst(
            previous,
          ))
            location.chapter.chapterUUID: location.chapter.chapterContent,
        };
        final after = {
          for (final location in ChapterModule.ChapterTree.chaptersDepthFirst(
            next,
          ))
            location.chapter.chapterUUID: location.chapter.chapterContent,
        };
        final applying = ref
            .read(editorCoordinatorProvider)
            .isApplyingProjectData;
        for (final id in {...before.keys, ...after.keys}) {
          if (before[id] == after[id]) continue;
          final composing = textController.value.composing;
          if (!applying &&
              id == selectedChapID &&
              composing.isValid &&
              !composing.isCollapsed)
            continue;
          progress.observeChapter(
            id,
            after[id] ?? "",
            counted: !applying && !_isApplyingProjectHistory,
          );
        }
        if (applying) return;
        _updateAllWordCounts();
      }),
    );

    _subscriptions.add(
      ref.listenManual<int>(projectDataAggregateProvider, (previous, next) {
        if (!mounted ||
            previous == null ||
            previous == next ||
            _isApplyingProjectHistory ||
            ref.read(editorCoordinatorProvider).isApplyingProjectData) {
          return;
        }

        _projectDataRevision++;
        _hasUnpersistedRemoteDraft = false;
        ref
            .read(collaborationProvider.notifier)
            .captureProjectData(_collectProjectData());
        _scheduleProjectHistoryRecord(_projectDataRevision);
      }),
    );

    _subscriptions.add(
      ref.listenManual<_CoordinatorUiEventState>(
        editorCoordinatorProvider.select(
          (state) => (
            messageEventId: state.messageEventId,
            messageText: state.messageText,
            wordCountModeEventId: state.wordCountModeEventId,
            errorEventId: state.errorEventId,
            errorMessage: state.errorMessage,
          ),
        ),
        (previous, next) {
          if (!mounted) {
            return;
          }

          if (previous?.messageEventId != next.messageEventId &&
              next.messageText != null &&
              next.messageText!.isNotEmpty) {
            final int messageEventId = next.messageEventId;
            final snackMessage = next.messageText!;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              AppFeedback.info(
                context,
                snackMessage,
                duration: const Duration(seconds: 3),
              );
              if (mounted &&
                  ref.read(editorCoordinatorProvider).messageEventId ==
                      messageEventId) {
                _editorCoordinatorNotifier.clearMessage();
              }
            });
          }

          if (previous?.wordCountModeEventId != next.wordCountModeEventId) {
            _onSettingsChanged();
          }

          if (previous?.errorEventId != next.errorEventId &&
              next.errorMessage != null &&
              next.errorMessage!.isNotEmpty) {
            final int errorEventId = next.errorEventId;
            final dialogMessage = next.errorMessage!;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (!mounted) {
                return;
              }
              await AppDialog.message(
                context: context,
                title: context.l10n.uiError,
                message: dialogMessage,
                closeLabel: context.l10n.commonConfirm,
                tone: AppFeedbackTone.error,
              );

              if (mounted &&
                  ref.read(editorCoordinatorProvider).errorEventId ==
                      errorEventId) {
                _editorCoordinatorNotifier.clearError();
              }
            });
          }
        },
      ),
    );

    // 監聽焦點變化
    WidgetsBinding.instance.focusManager.addListener(_onFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateAllWordCounts();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final progress = ref.read(dailyWritingProgressProvider);
    if (state != AppLifecycleState.resumed) {
      unawaited(progress.flush().catchError((Object _) {}));
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      progress.refreshDate();
      unawaited(ref.read(p2pSyncProvider.notifier).handleAppResumed());
    });
  }

  @override
  void didChangeMetrics() {
    if (_isDesktopPlatform) {
      _markWindowResizeInProgress();
    }
  }

  @override
  void dispose() {
    _stopWritingProgressClock();
    DesktopProjectLaunch.unbind();
    WidgetsBinding.instance.removeObserver(this);
    CharacterDraftSessionCoordinator.instance.flushAndClose(
      _projectSessionVersion,
    );
    _cancelPendingContentCommit();
    _projectHistoryRecordTimer?.cancel();
    _projectHistoryRecordTimer = null;
    _pendingProjectHistoryRevision = null;
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
    _autoBackupTimer?.cancel();
    _autoBackupTimer = null;
    _windowResizeEndTimer?.cancel();
    _windowResizeEndTimer = null;
    _stableResizeBody = null;
    _stableResizeBodySize = null;
    _wordCountService.removeListener(_handleWordCountServiceChanged);
    _closeProviderSubscriptions();
    WidgetsBinding.instance.focusManager.removeListener(_onFocusChange);
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      windowManager.removeListener(this);
    }
    _textChangeDebouncer.cancelAll();
    final rhodantheSession = _rhodantheSession;
    _rhodantheSession = null;
    unawaited(rhodantheSession?.dispose() ?? Future<void>.value());
    unawaited(_rhodantheRolloutEvidence.dispose());
    textController.dispose();
    _quillSearchController.dispose();
    findController.removeListener(_onRibbonSearchQueryChanged);
    _ribbonController.dispose();
    findController.dispose();
    replaceController.dispose();
    editorFocusNode.dispose();
    _workspaceFocus.dispose();
    super.dispose();
  }

  void _closeProviderSubscriptions() {
    for (final subscription in List<ProviderSubscription<Object?>>.of(
      _subscriptions,
    )) {
      try {
        subscription.close();
      } catch (error, stackTrace) {
        debugPrint(
          "Failed to close provider subscription: $error\n$stackTrace",
        );
      }
    }
    _subscriptions.clear();
  }

  Future<void> _applyAliasMentionRename(AliasRename rename) async {
    final projectId = ref.read(projectDataProvider).projectUUID;
    final enabled =
        rename.isPrimaryName ||
        await ref.read(aliasMentionUpdatesEnabledProvider.future);
    if (!mounted ||
        !enabled ||
        ref.read(projectDataProvider).projectUUID != projectId) {
      return;
    }
    _flushPendingEditorContent();
    _syncEditorToSelectedChapter();
    final selection = ref.read(editorSelectionProvider);
    final locations = ChapterModule.ChapterTree.chaptersDepthFirst(
      ref.read(segmentsDataProvider),
    ).toList();
    for (final location in locations) {
      final chapter = location.chapter;
      final isActive = chapter.chapterUUID == selection.selectedChapID;
      final raw = isActive ? textController.rawText : chapter.chapterContent;
      final updated = rewriteAliasMentions(raw, rename);
      if (updated == raw) continue;
      ref
          .read(segmentsDataProvider.notifier)
          .updateChapterContent(
            segmentID: location.folder.segmentUUID,
            chapterID: chapter.chapterUUID,
            content: updated,
          );
      if (isActive) {
        ref.read(editorContentProvider.notifier).setContent(updated);
      }
    }
  }

  void _flushPendingEditorContent() {
    _textChangeDebouncer.flushPendingContentCommit();
  }

  bool _canAutoSaveToKnownLocation(ProjectFile? projectFile) {
    if (projectFile == null) {
      return false;
    }
    final hasPath = projectFile.filePath?.trim().isNotEmpty == true;
    final hasUri = projectFile.uri?.trim().isNotEmpty == true;
    return hasPath || hasUri;
  }

  String _projectIdentity(ProjectFile? project) {
    if (project == null) return "unsaved";
    return project.uri?.trim().isNotEmpty == true
        ? "uri:${project.uri!.trim()}"
        : project.filePath?.trim().isNotEmpty == true
        ? "path:${project.filePath!.trim()}"
        : "name:${project.fileName}";
  }

  ProjectIoSessionToken _beginProjectIoSession(ProjectFile? project) {
    final token = _projectIoCoordinator.beginSession(_projectIdentity(project));
    _projectIoSession = token;
    return token;
  }

  Future<ProjectIoPayload> _sharedProjectIoPayload({
    required ProjectIoSessionToken session,
    required int revision,
    required ProjectData data,
  }) {
    return _projectIoCoordinator.sharedPayload<ProjectIoPayload>(
      token: session,
      revision: revision,
      create: () => ref
          .read(projectIoControllerProvider.notifier)
          .prepareProjectPayload(data),
    );
  }

  void _configureAutoSaveTimer(AppSettingsStateData settings) {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;

    if (!settings.autoSaveEnabled) {
      return;
    }

    final intervalMinutes = settings.autoSaveIntervalMinutes.clamp(1, 120);
    _autoSaveTimer = Timer.periodic(
      Duration(minutes: intervalMinutes),
      (_) => unawaited(_performAutoSave()),
    );
  }

  Future<void> _performAutoSave() async {
    final project = currentProject;
    if (!mounted ||
        _isWritingAutoSave ||
        _isProjectSwitching ||
        !_settingsState.autoSaveEnabled ||
        !_canAutoSaveToKnownLocation(project)) {
      return;
    }

    _syncEditorToSelectedChapter();
    if (!hasUnsavedChanges) {
      return;
    }

    _isWritingAutoSave = true;
    try {
      final session = _projectIoSession;
      final revision = _projectDataRevision;
      final currentData = _collectProjectData();
      final savedProgressPosition = ref
          .read(dailyWritingProgressProvider)
          .checkpoint();
      ProjectIoPayload? persistedPayload;
      final runResult = await _projectIoCoordinator.run(session, () async {
        final payload = await _sharedProjectIoPayload(
          session: session,
          revision: revision,
          data: currentData,
        );
        persistedPayload = payload;
        return ref
            .read(projectIoControllerProvider.notifier)
            .saveProjectAutoSave(
              currentProject: project!,
              currentData: currentData,
              preparedPayload: payload,
            );
      });
      final savedProject = runResult.value;
      if (!mounted ||
          savedProject == null ||
          !_projectIoCoordinator.isCurrent(session)) {
        return;
      }
      setState(() => currentProject = savedProject);
      _hasUnpersistedRemoteDraft = false;
      if (_projectDataRevision == revision) {
        _markAsSaved();
      }
      ref
          .read(dailyWritingProgressProvider)
          .markSaved(position: savedProgressPosition);
      await _recordP2pPersistedRevision(persistedPayload);
      await _editorCoordinatorNotifier.recordRecentProject(savedProject);
    } catch (error, stackTrace) {
      debugPrint("AutoSave failed: $error\n$stackTrace");
    } finally {
      _isWritingAutoSave = false;
    }
  }

  void _configureAutoBackupTimer(AppSettingsStateData settings) {
    _autoBackupTimer?.cancel();
    _autoBackupTimer = null;

    if (!settings.autoBackupEnabled) {
      _resetAutoBackupBaseline();
      return;
    }

    final intervalMinutes = settings.autoBackupIntervalMinutes.clamp(1, 120);
    _autoBackupTimer = Timer.periodic(
      Duration(minutes: intervalMinutes),
      (_) => unawaited(_performAutoBackup()),
    );
  }

  Future<void> _performAutoBackup() async {
    if (!mounted ||
        _isWritingAutoBackup ||
        _isProjectSwitching ||
        !_settingsState.autoBackupEnabled) {
      return;
    }

    _syncEditorToSelectedChapter();
    final revision = _projectDataRevision;
    if (_lastAutoBackupRevision == revision) return;

    _isWritingAutoBackup = true;
    try {
      final session = _projectIoSession;
      final currentData = _collectProjectData();
      final runResult = await _projectIoCoordinator.run(session, () async {
        final payload = await _sharedProjectIoPayload(
          session: session,
          revision: revision,
          data: currentData,
        );
        return ref
            .read(projectIoControllerProvider.notifier)
            .saveProjectAutoBackup(
              currentProject: currentProject,
              currentData: currentData,
              maxTotalBytes: _settingsState.autoBackupMaxSizeMb * 1024 * 1024,
              preparedPayload: payload,
            );
      });
      final result = runResult.value;
      if (result == null || !_projectIoCoordinator.isCurrent(session)) return;
      _lastAutoBackupRevision = revision;
    } catch (error, stackTrace) {
      debugPrint("AutoBackup failed: $error\n$stackTrace");
    } finally {
      _isWritingAutoBackup = false;
    }
  }

  void _resetAutoBackupBaseline() {
    _lastAutoBackupRevision = null;
  }

  void _cancelPendingContentCommit() {
    _textChangeDebouncer.cancelAll();
  }

  void _scheduleProjectHistoryRecord(int revision) {
    if (_isApplyingProjectHistory ||
        revision == _lastRecordedProjectDataRevision) {
      return;
    }

    _pendingProjectHistoryRevision = revision;
    _projectHistoryRecordTimer?.cancel();
    _projectHistoryRecordTimer = Timer(_projectHistoryRecordDelay, () {
      _projectHistoryRecordTimer = null;
      final int? pendingRevision = _pendingProjectHistoryRevision;
      _pendingProjectHistoryRevision = null;
      if (pendingRevision == null ||
          pendingRevision == _lastRecordedProjectDataRevision) {
        return;
      }
      _recordProjectHistorySnapshot();
    });
  }

  ProjectHistoryEntry _createProjectHistoryEntry(
    ProjectData data, {
    bool isPageTransition = false,
  }) {
    final selection = ref.read(editorSelectionProvider);
    final rawSelection = textController.selection.isValid
        ? textController.projection.displaySelectionToRaw(
            textController.selection,
          )
        : null;
    final int cursorOffset = rawSelection != null
        ? _clampOffset(rawSelection.baseOffset, textController.rawText.length)
        : selection.cursorOffset;

    return ProjectHistoryEntry(
      data: data,
      pageIndex: slidePageIndexNow,
      selectedSegID: selection.selectedSegID,
      selectedChapID: selection.selectedChapID,
      cursorOffset: cursorOffset,
      isPageTransition: isPageTransition,
      writingProgressPosition: ref
          .read(dailyWritingProgressProvider)
          .checkpoint(),
    );
  }

  void _recordProjectHistorySnapshot({
    bool reset = false,
    bool isPageTransition = false,
  }) {
    if (!mounted || _isApplyingProjectHistory) {
      return;
    }

    _projectHistoryRecordTimer?.cancel();
    _projectHistoryRecordTimer = null;
    _pendingProjectHistoryRevision = null;
    _syncEditorToSelectedChapter();

    // Syncing editor text may publish a new aggregate provider state and
    // schedule another timer synchronously. Consume that revision here so the
    // duplicate callback cannot perform a second full snapshot/serialization.
    _projectHistoryRecordTimer?.cancel();
    _projectHistoryRecordTimer = null;
    _pendingProjectHistoryRevision = null;
    final int currentRevision = _projectDataRevision;
    if (!reset &&
        !isPageTransition &&
        currentRevision == _lastRecordedProjectDataRevision) {
      return;
    }

    final entry = _createProjectHistoryEntry(
      _collectProjectData(),
      isPageTransition: isPageTransition,
    );
    final historyNotifier = ref.read(projectHistoryProvider.notifier);
    if (reset) {
      historyNotifier.reset(entry);
    } else {
      historyNotifier.record(entry);
    }
    _lastRecordedProjectDataRevision = currentRevision;
  }

  void _resetProjectHistory() {
    _recordProjectHistorySnapshot(reset: true);
  }

  bool _shouldRecordPageTransition(int fromIndex, int toIndex) {
    return !_ignoredPageTransitionIndexes.contains(fromIndex) &&
        !_ignoredPageTransitionIndexes.contains(toIndex);
  }

  void _recordPageTransitionIfNeeded(int nextPageIndex) {
    if (!_shouldRecordPageTransition(slidePageIndexNow, nextPageIndex)) {
      return;
    }

    _recordProjectHistorySnapshot(isPageTransition: true);
  }

  EditorProjectInitialState _initialStateForHistoryEntry(
    ProjectHistoryEntry entry,
  ) {
    final fallback = ref
        .read(editorCoordinatorProvider.notifier)
        .calculateInitialState(entry.data, _settingsState.wordCountMode);

    final String? targetSegID = entry.selectedSegID ?? fallback.selectedSegID;
    final String? targetChapID =
        entry.selectedChapID ?? fallback.selectedChapID;
    String content = fallback.contentText;
    bool hasSelection = fallback.hasSelection;

    if (targetChapID != null) {
      final location = ChapterModule.ChapterTree.findChapter(
        entry.data.segmentsData,
        folderId: targetSegID,
        chapterId: targetChapID,
      );
      if (location != null) {
        content = location.chapter.chapterContent;
        hasSelection = true;
      }
    }

    return EditorProjectInitialState(
      selectedSegID: targetSegID,
      selectedChapID: targetChapID,
      contentText: content,
      totalWords: entry.data.totalWords,
      hasSelection: hasSelection,
      cursorOffset: _clampOffset(entry.cursorOffset, content.length),
    );
  }

  void _applyProjectHistoryEntry(ProjectHistoryEntry entry) {
    if (!mounted) {
      return;
    }

    _projectHistoryRecordTimer?.cancel();
    _projectHistoryRecordTimer = null;
    _isApplyingProjectHistory = true;
    if (entry.writingProgressPosition case final position?) {
      ref.read(dailyWritingProgressProvider).restoreCheckpoint(position);
    }
    final initialState = _initialStateForHistoryEntry(entry);
    final historyData = snapshotProjectData(entry.data)
      ..projectUUID = ref.read(projectUuidProvider)
      ..revisionTrackingJson = ref.read(revisionTrackingJsonProvider);

    setState(() {
      slidePageIndexNow = entry.pageIndex < 0 ? 0 : entry.pageIndex;
      _applyProjectData(historyData, initialState);
    });
    ref
        .read(revisionTrackingProvider.notifier)
        .restoreReviewDecisions(entry.data.revisionTrackingJson);
    _projectDataRevision++;
    _lastRecordedProjectDataRevision = _projectDataRevision;

    _updateAllWordCounts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _isApplyingProjectHistory = false;
      _editorCoordinatorNotifier.markAsModified();
    });
  }

  void _undoProjectHistory() {
    if (_isApplyingProjectHistory) {
      return;
    }

    _syncEditorToSelectedChapter();
    final currentEntry = _createProjectHistoryEntry(_collectProjectData());
    final target = ref.read(projectHistoryProvider.notifier).undo(currentEntry);
    if (target == null) {
      return;
    }

    _applyProjectHistoryEntry(target);
  }

  void _redoProjectHistory() {
    if (_isApplyingProjectHistory) {
      return;
    }

    _syncEditorToSelectedChapter();
    final currentEntry = _createProjectHistoryEntry(_collectProjectData());
    final target = ref.read(projectHistoryProvider.notifier).redo(currentEntry);
    if (target == null) {
      return;
    }

    _applyProjectHistoryEntry(target);
  }

  void _updateAllWordCounts() {
    _wordCountService.synchronizeChapters(
      ChapterModule.ChapterTree.chaptersDepthFirst(segmentsData).map(
        (location) => WordCountChapterInput(
          chapterId: location.chapter.chapterUUID,
          content: InlineAnnotationProjection.readerTextFromRaw(
            location.chapter.chapterContent,
          ),
        ),
      ),
      _settingsState.wordCountMode,
    );
    totalWords = _wordCountService.total;
  }

  void _onSettingsChanged() {
    // When settings change (e.g. counting mode), recalculate all
    _updateAllWordCounts();
    _refreshActiveChapterWordCount();
  }

  // WindowListener 實作

  /// 初始化視窗管理器
  Future<void> _initWindowManager() async {
    // 設置視窗為可以被攔截關閉
    await windowManager.setPreventClose(true);
  }

  @override
  void onWindowClose() async {
    // Ignore duplicate close messages while a confirmation dialog is open or
    // after the user has already approved the close. This is especially
    // important during startup, where Windows can deliver close messages
    // before the first dialog animation finishes.
    if (_isExitConfirmationInProgress || _isDesktopWindowClosing) return;

    final shouldClose = await _requestExit();
    if (!shouldClose) return;

    _isDesktopWindowClosing = true;
    // Let the native window close normally instead of force-destroying the
    // Flutter view while it may still be handling a platform message.
    await windowManager.setPreventClose(false);
    await windowManager.close();
  }

  @override
  void onWindowFocus() {
    // 視窗獲得焦點時可以做一些事情（暫時不需要）
  }

  @override
  void onWindowBlur() {
    // 視窗失去焦點時可以做一些事情（暫時不需要）
  }

  @override
  void onWindowMaximize() {}

  @override
  void onWindowUnmaximize() {}

  @override
  void onWindowMinimize() {}

  @override
  void onWindowRestore() {}

  @override
  void onWindowResize() => _markWindowResizeInProgress();

  @override
  void onWindowMove() {}

  @override
  void onWindowEnterFullScreen() {}

  @override
  void onWindowLeaveFullScreen() {}

  @override
  void onWindowEvent(String eventName) {}

  @override
  void onWindowDocked() {}

  @override
  void onWindowUndocked() {}

  void _markWindowResizeInProgress() {
    if (!mounted || !_isDesktopPlatform) return;

    _isWindowResizeInProgress = true;
    _windowResizeEndTimer?.cancel();
    _windowResizeEndTimer = Timer(_windowResizeSettleDelay, () {
      if (!mounted) return;
      setState(() {
        _isWindowResizeInProgress = false;
        // The next build performs one real layout at the final window size.
        _stableResizeBody = null;
        _stableResizeBodySize = null;
      });
    });
  }

  Widget _buildResizeStabilizedBody({
    required BoxConstraints constraints,
    required double fontSize,
    required WordCountMode wordCountMode,
    required bool hasUnsavedChanges,
    required DateTime? lastSavedTime,
  }) {
    final currentSize = constraints.biggest;
    final canReuseStableBody =
        _isWindowResizeInProgress &&
        _stableResizeBody != null &&
        _stableResizeBodySize != null;

    if (!canReuseStableBody) {
      _stableResizeBody = constraints.maxWidth < 800
          ? _buildMobileLayout(
              fontSize: fontSize,
              wordCountMode: wordCountMode,
              hasUnsavedChanges: hasUnsavedChanges,
              lastSavedTime: lastSavedTime,
            )
          : _buildDesktopLayout(
              fontSize: fontSize,
              wordCountMode: wordCountMode,
              hasUnsavedChanges: hasUnsavedChanges,
              lastSavedTime: lastSavedTime,
            );
      _stableResizeBodySize = currentSize;
    }

    return _WindowResizeViewport(
      key: const Key("window-resize-stable-viewport"),
      contentSize: _stableResizeBodySize!,
      child: _stableResizeBody!,
    );
  }

  // MARK: 主體建構方法
  @override
  Widget build(BuildContext context) {
    // Keep personal tracking alive even while the dashboard is hidden.
    ref.watch(dailyWritingProgressProvider.notifier);
    final fontSize = ref.watch(
      settingsStateProvider.select(
        (state) => state.valueOrNull?.fontSize ?? 14.0,
      ),
    );
    final wordCountMode = ref.watch(
      settingsStateProvider.select(
        (state) =>
            state.valueOrNull?.wordCountMode ??
            WordCountMode.wordsAndCharacters,
      ),
    );
    final hasUnsavedChanges = ref.watch(
      editorCoordinatorProvider.select((state) => state.hasUnsavedChanges),
    );
    final lastSavedTime = ref.watch(
      editorCoordinatorProvider.select((state) => state.lastSavedTime),
    );
    final toolbarPreference = ref.watch(
      toolbarModeProvider.select((state) => state.valueOrNull),
    );
    final toolbarMode =
        toolbarPreference ?? ToolbarMode.defaultFor(Theme.of(context).platform);
    final projectIoBusy = ref.watch(
      projectIoControllerProvider.select((state) => state.isProjectIoBusy),
    );

    // 根據平台判斷快捷鍵修飾符 (Apple 設備使用 Command，其他使用 Control)
    final bool isApple =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.iOS);

    HelpController.maybeOf(context)?.pageTopic = HelpTopicId.forPage(
      slidePageIndexNow,
    );

    return WorkspaceNavigationShortcuts(
      focusNode: _workspaceFocus,
      isBlocked: () => _navigationBlocked,
      onRibbonStep: (delta) =>
          _topAppBarKey.currentState?.selectRelativeTab(delta),
      onModuleStep: (delta) =>
          _selectModule(AppModule.step(_currentModule, delta)),
      onOpenSwitcher: _openModuleSwitcher,
      onOpenModule: _selectModule,
      onSaveAs: () => _handleFileAction("saveAs"),
      onFind: _openFindReplace,
      onReplace: () => _openFindReplace(replace: true),
      onSearchResult: (forward) {
        if (showFindReplaceWindow) {
          unawaited(
            _findBarKey.currentState?.navigate(forward) ?? Future<void>.value(),
          );
        }
      },
      child: Shortcuts(
        shortcuts: <ShortcutActivator, Intent>{
          SingleActivator(
            LogicalKeyboardKey.keyS,
            control: !isApple,
            meta: isApple,
            shift: true,
            includeRepeats: false,
          ): const SaveAsFileIntent(),
          SingleActivator(
            isApple ? LogicalKeyboardKey.keyF : LogicalKeyboardKey.keyH,
            control: !isApple,
            meta: isApple,
            alt: isApple,
            includeRepeats: false,
          ): const ReplaceIntent(),
          SingleActivator(
            isApple ? LogicalKeyboardKey.keyG : LogicalKeyboardKey.f3,
            meta: isApple,
            includeRepeats: false,
          ): const SearchResultIntent(
            true,
          ),
          SingleActivator(
            isApple ? LogicalKeyboardKey.keyG : LogicalKeyboardKey.f3,
            meta: isApple,
            shift: true,
            includeRepeats: false,
          ): const SearchResultIntent(
            false,
          ),
          if (!isApple)
            const SingleActivator(LogicalKeyboardKey.keyY, control: true):
                const RedoProjectIntent(),
          if (showFindReplaceWindow)
            const SingleActivator(
              LogicalKeyboardKey.escape,
              includeRepeats: false,
            ): const CloseSearchIntent(),

          SingleActivator(
            LogicalKeyboardKey.keyN,
            control: !isApple,
            meta: isApple,
            includeRepeats: false,
          ): const NewFileIntent(),
          SingleActivator(
            LogicalKeyboardKey.keyO,
            control: !isApple,
            meta: isApple,
            includeRepeats: false,
          ): const OpenFileIntent(),
          SingleActivator(
            LogicalKeyboardKey.keyS,
            control: !isApple,
            meta: isApple,
            includeRepeats: false,
          ): const SaveFileIntent(),
          SingleActivator(
            LogicalKeyboardKey.keyF,
            control: !isApple,
            meta: isApple,
            includeRepeats: false,
          ): const FindIntent(),
          SingleActivator(
            LogicalKeyboardKey.keyZ,
            control: !isApple,
            meta: isApple,
          ): const UndoProjectIntent(),
          SingleActivator(
            LogicalKeyboardKey.keyZ,
            control: !isApple,
            meta: isApple,
            shift: true,
          ): const RedoProjectIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            SaveAsFileIntent: CallbackAction<SaveAsFileIntent>(
              onInvoke: (_) => _handleFileAction("saveAs"),
            ),
            ReplaceIntent: CallbackAction<ReplaceIntent>(
              onInvoke: (_) {
                _openFindReplace(replace: true);
                return null;
              },
            ),
            SearchResultIntent: CallbackAction<SearchResultIntent>(
              onInvoke: (intent) {
                if (!_navigationBlocked && showFindReplaceWindow) {
                  unawaited(
                    _findBarKey.currentState?.navigate(intent.forward) ??
                        Future<void>.value(),
                  );
                }
                return null;
              },
            ),
            CloseSearchIntent: CallbackAction<CloseSearchIntent>(
              onInvoke: (_) {
                if (!_navigationBlocked) _closeFindReplace();
                return null;
              },
            ),
            NewFileIntent: CallbackAction<NewFileIntent>(
              onInvoke: (intent) => _handleFileAction("new"),
            ),
            OpenFileIntent: CallbackAction<OpenFileIntent>(
              onInvoke: (intent) => _handleFileAction("open"),
            ),
            SaveFileIntent: CallbackAction<SaveFileIntent>(
              onInvoke: (intent) => _handleFileAction("save"),
            ),
            FindIntent: CallbackAction<FindIntent>(
              onInvoke: (intent) {
                _openFindReplace();
                return null;
              },
            ),
            UndoProjectIntent: CallbackAction<UndoProjectIntent>(
              onInvoke: (intent) {
                _undoProjectHistory();
                return null;
              },
            ),
            RedoProjectIntent: CallbackAction<RedoProjectIntent>(
              onInvoke: (intent) {
                _redoProjectHistory();
                return null;
              },
            ),
          },
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, dynamic result) async {
              if (didPop) return;

              final shouldPop = await _requestExit();
              if (!shouldPop || !context.mounted) return;

              if (_isAndroidPlatform) {
                // Popping the Flutter route leaves the Android Activity in its
                // task. Ask the platform to finish it so Back exits directly.
                await SystemNavigator.pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },
            child: Scaffold(
              appBar: MonogatariTopAppBar(
                key: _topAppBarKey,
                iconSize: fontSize + 8,
                mode: toolbarMode,
                controller: _ribbonController,
                searchOptions: findReplaceOptions.copy(),
                searchQuery: _ribbonSearchQuery,
                onSearchOptionChanged: _changeFindOption,
                modePreference: toolbarPreference,
                onModeChanged: (value) =>
                    ref.read(toolbarModeProvider.notifier).setMode(value),
                isProjectIoBusy: projectIoBusy || _fileCommandRunning,
                statusIndicator: const _ProjectIoBusyIndicator(),
                showPunctuationPanel: showPunctuationPanel,
                showFindReplaceWindow: showFindReplaceWindow,
                showNavigation: _showNavigation,
                showSidebar: _showSidebar,
                showDashboard: _showGaugeDashboard,
                onToggleNavigation: MediaQuery.sizeOf(context).width < 800
                    ? null
                    : () => setState(() => _showNavigation = !_showNavigation),
                onToggleSidebar: MediaQuery.sizeOf(context).width < 800
                    ? null
                    : () => setState(() => _showSidebar = !_showSidebar),
                onToggleDashboard: MediaQuery.sizeOf(context).width < 800
                    ? null
                    : () => setState(
                        () => _showGaugeDashboard = !_showGaugeDashboard,
                      ),
                onFileAction: _handleFileAction,
                onEditorAction: _performEditorAction,
                onOpenPhraseLibrary: () async {
                  final editor = _bodyEditorKey.currentState;
                  if (editor != null) {
                    await editor.openPhraseLibrary();
                  } else {
                    await PhraseLibraryDialog.show(context: context);
                  }
                },
                onInsertPhrase: () async {
                  if (MediaQuery.sizeOf(context).width < 800) {
                    setState(() => slidePageIndexNow = 114514);
                  }
                  await _bodyEditorKey.currentState?.insertPhrase();
                },
                onSaveSelectionAsPhrase: () =>
                    _bodyEditorKey.currentState?.saveSelectionAsPhrase(),
                onEditorActionPointerDown: _prepareEditorToolbarAction,
                onEditorActionInteractionEnd: _finishEditorToolbarAction,
                onTogglePunctuationPanel: _togglePunctuationPanel,
                onToggleFindReplaceWindow: _toggleFindReplaceWindow,
              ),
              body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _clearEditableFocus,
                child: LayoutBuilder(
                  builder: (context, constraints) => _buildResizeStabilizedBody(
                    constraints: constraints,
                    fontSize: fontSize,
                    wordCountMode: wordCountMode,
                    hasUnsavedChanges: hasUnsavedChanges,
                    lastSavedTime: lastSavedTime,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onRibbonSearchQueryChanged() {
    final value = findController.value;
    if (value.composing.isValid && !value.composing.isCollapsed) return;
    if (_ribbonSearchQuery == value.text) return;
    setState(() {
      _ribbonSearchQuery = value.text;
      findReplaceOptions.normalizeForQuery(value.text);
    });
  }

  void _changeFindOption(FindReplaceOption option) {
    final query = findController.text;
    if (!findReplaceOptions.enabledFor(option, query)) return;
    setState(() {
      findReplaceOptions.setOption(
        option,
        !findReplaceOptions.valueFor(option),
        query,
      );
      _findOptionsRevision += 1;
    });
    unawaited(_refreshSearchResults(query, findReplaceOptions.copy()));
  }

  Future<void> _refreshSearchResults(
    String findText,
    FindReplaceOptions options,
  ) async {
    // Reject debounced callbacks from before a Ribbon option change or IME commit.
    final composing = findController.value.composing;
    if (!showFindReplaceWindow ||
        findText != findController.text ||
        !options.sameAs(findReplaceOptions) ||
        (composing.isValid && !composing.isCollapsed)) {
      return;
    }
    // 當搜尋內容或選項變化時，重新搜尋所有匹配項（但不移動光標）
    if (findText.isNotEmpty) {
      if (textController.text.isNotEmpty) {
        // Async search (background isolate + precomputed index)
        final searchResult = await findAllMatchesLatest(
          textController,
          findText,
          options,
          maxResults: HighlightTextEditingController.maxSearchResults,
        );
        if (!mounted ||
            searchResult == null ||
            !searchResult.isCurrent(
              textController,
              findController.text,
              findReplaceOptions,
              maxResults: HighlightTextEditingController.maxSearchResults,
            )) {
          return;
        }

        setState(() {
          // 更新高亮顯示（使用預編譯的索引）
          searchResult.applyHighlights(
            textController,
            currentIndex: _currentMatchIndex,
          );
          _searchMatches = textController.searchMatches;
          // 如果當前選中的匹配項仍然有效，保持它
          if (_currentMatchIndex >= _searchMatches.length) {
            _currentMatchIndex = _searchMatches.isEmpty ? -1 : 0;
            textController.updateCurrentSearchMatchIndex(_currentMatchIndex);
          }
        });
        _syncFindRangesToQuill(findText, selectCurrent: false);
        unawaited(
          _analyzeRhodantheSearch(
            findText,
            options,
            _searchMatches,
            _currentMatchIndex,
          ),
        );
      }
    } else {
      cancelFindAllMatches(textController);
      setState(() {
        _searchMatches = [];
        _currentMatchIndex = -1;
        textController.clearAllHighlights();
        textController.clearRhodantheRenderPlan(notify: false);
      });
      _quillSearchController.clearSearchResults();
      _quillSearchController.clearProofreadingRanges();
    }
  }

  void _togglePunctuationPanel() {
    setState(() {
      showPunctuationPanel = !showPunctuationPanel;
    });
  }

  void _openFindReplace({bool replace = false}) {
    if (_navigationBlocked) return;
    if (MediaQuery.sizeOf(context).width < 800 &&
        _currentModule.id != AppModuleId.editor) {
      _selectModule(AppModule.forNavigation(17));
    }
    setState(() {
      showFindReplaceWindow = true;
    });
    _topAppBarKey.currentState?.selectTabForNavigation("search");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !showFindReplaceWindow) return;
      if (replace) {
        _findBarKey.currentState?.focusReplace();
      } else {
        _findBarKey.currentState?.focusFind();
      }
    });
  }

  void _closeFindReplace() {
    if (!showFindReplaceWindow) return;
    cancelFindAllMatches(textController);
    cancelReplaceAll(textController);
    setState(() {
      showFindReplaceWindow = false;
      _searchMatches = [];
      _currentMatchIndex = -1;
      textController.clearAllHighlights();
      textController.clearRhodantheRenderPlan(notify: false);
    });
    _quillSearchController.clearSearchResults();
    _quillSearchController.clearProofreadingRanges();
    editorFocusNode.requestFocus();
  }

  void _toggleFindReplaceWindow() {
    if (_navigationBlocked) return;
    if (showFindReplaceWindow) {
      _closeFindReplace();
    } else {
      if (MediaQuery.sizeOf(context).width < 800 &&
          _currentModule.id != AppModuleId.editor) {
        _selectModule(AppModule.forNavigation(17));
      }
      setState(() => showFindReplaceWindow = true);
      _topAppBarKey.currentState?.selectTabForNavigation("search");
    }
  }

  // 手機佈局（左右浮動導覽與儀表板）
  Widget _buildMobileLayout({
    required double fontSize,
    required WordCountMode wordCountMode,
    required bool hasUnsavedChanges,
    required DateTime? lastSavedTime,
  }) {
    // 檢查是否在編輯器頁面（slidePageIndexNow > (slidePageCounts - 1) 表示編輯器）
    bool isEditorMode = slidePageIndexNow > (slidePageCounts - 1);

    return MonogatariMobileLayout(
      isEditorMode: isEditorMode,
      selectedIndex: _getNavigationIndex(),
      functionPage: _buildMobileFunctionPage(fontSize: fontSize),
      editorPage: _buildEditor(),
      statusBar: _buildMobileStatusBar(
        fontSize: fontSize,
        wordCountMode: wordCountMode,
        hasUnsavedChanges: hasUnsavedChanges,
        lastSavedTime: lastSavedTime,
      ),
      dashboardBuilder: (onClose) => RadialGaugeDashboard(
        capsule: true,
        reverseOrder: true,
        onClose: onClose,
        onStartRevision: _startRevisionTracking,
        onOpenRevision: () {
          onClose();
          _openRevisionDetails();
        },
      ),
      onDestinationSelected: (index) =>
          _selectModule(AppModule.forNavigation(index)),
    );
  }

  // 手機狀態列 - 顯示專案資訊
  Widget _buildMobileStatusBar({
    required double fontSize,
    required WordCountMode wordCountMode,
    required bool hasUnsavedChanges,
    required DateTime? lastSavedTime,
  }) {
    return _EditorStatusBar(
      textController: textController,
      projectName: currentProject?.nameWithoutExtension ?? "Untitled",
      hasUnsavedChanges: hasUnsavedChanges,
      lastSavedTime: lastSavedTime,
      iconSize: fontSize,
    );
  }

  // 手機功能頁面（包含功能切換和內容）
  Widget _buildMobileFunctionPage({required double fontSize}) {
    return MonogatariMobileFunctionPage(
      showPunctuationPanel: showPunctuationPanel,
      onInsertPunctuation: _insertText,
      onClosePunctuationPanel: () {
        setState(() {
          showPunctuationPanel = false;
        });
      },
      pageCount: slidePageCounts,
      selectedIndex: _currentModule.id == AppModuleId.editor
          ? _lastFunctionModule.navigationIndex
          : slidePageIndexNow,
      fontSize: fontSize,
      pageBuilder: _buildSpecificPageContent,
    );
  }

  // 特定頁面內容建構（用於 IndexedStack）
  Widget _buildSpecificPageContent(int pageIndex) {
    late Widget page;
    switch (pageIndex) {
      case 0:
        page = _buildWelcomeView();
        break;
      case 1:
        page = _buildBaseInfoView();
        break;
      case 2:
        page = _buildChapterSelectionView();
        break;
      case 3:
        page = _buildOutlineView();
        break;
      case 4:
        page = _buildTimelineView();
        break;
      case 5:
        page = _buildCharacterSettingsView();
        break;
      case 6:
        page = _buildRelationView();
        break;
      case 7:
        page = _buildWorldSettingsView();
        break;
      case 8:
        page = ItemView(
          initialClassId: _requestedItemClassId,
          selectionRequestId: _itemSelectionRequestId,
        );
        break;
      case 9:
        page = _buildPlanView();
        break;
      case 10:
        page = _buildGlossaryView();
        break;
      case 11:
        page = _buildPalettesView();
        break;
      case 12:
        page = _buildProofreadingView();
        break;
      case 13:
        page = _buildCopilotView();
        break;
      case 14:
        page = _buildSettingView();
        break;
      case 15:
        page = _buildAboutView();
        break;
      case 16:
        page = const HelpModule();
        break;
      default:
        page = Center(child: Text("Page ${pageIndex + 1}"));
    }

    page = HelpScope(topicId: HelpTopicId.forPage(pageIndex), child: page);

    if (!_projectBackedPageIndexes.contains(pageIndex)) {
      return page;
    }

    // IndexedStack normally preserves every project page's State. Use a new
    // session key after switching projects so controllers and selections cannot
    // keep values that belong to the previous project.
    return KeyedSubtree(
      key: ValueKey("project-$_projectSessionVersion-page-$pageIndex"),
      child: page,
    );
  }

  // 桌面佈局（使用 NavigationRail）
  Widget _buildDesktopLayout({
    required double fontSize,
    required WordCountMode wordCountMode,
    required bool hasUnsavedChanges,
    required DateTime? lastSavedTime,
  }) {
    return Column(
      children: [
        Expanded(
          child: MonogatariNavigationLayout(
            visible: _showNavigation,
            style: ref.watch(
              settingsStateProvider.select(
                (state) =>
                    state.valueOrNull?.navigationStyle ??
                    NavigationStyle.railLabel,
              ),
            ),
            selectedIndex: _getNavigationIndex(),
            onDestinationSelected: (index) {
              _selectModule(AppModule.forNavigation(index));
            },
            selectedLabelTextStyle: Theme.of(context).textTheme.labelTiny,
            unselectedLabelTextStyle: Theme.of(context).textTheme.labelTiny,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Reserve the dashboard before sizing the sidebar and editor.
                final canShowDashboardInline =
                    constraints.maxWidth >=
                    RadialGaugeDashboard.panelWidth +
                        1 +
                        360 +
                        (_showSidebar ? 408 : 0);
                final showDashboardInline =
                    _showGaugeDashboard && canShowDashboardInline;
                final dashboardWidth = !_showGaugeDashboard
                    ? 0.0
                    : showDashboardInline
                    ? RadialGaugeDashboard.panelWidth
                    : RadialGaugeDashboard.collapsedWidth;
                final double maxWidth =
                    constraints.maxWidth -
                    dashboardWidth -
                    (_showGaugeDashboard ? 1 : 0);
                // 計算側邊欄寬度，並限制在 400px - 40% 之間
                final double minSidebarWidth = max(maxWidth * 0.2, 400);
                final double maxSidebarWidth = max(maxWidth * 0.4, 400);
                // 確保最大寬度至少能容納最小寬度
                final double effectiveMaxWidth =
                    maxSidebarWidth < minSidebarWidth
                    ? minSidebarWidth
                    : maxSidebarWidth;

                final double sidebarWidth = min(
                  (maxWidth * _sidebarWidthRatio).clamp(
                    minSidebarWidth,
                    effectiveMaxWidth,
                  ),
                  max(240, maxWidth - 360),
                );
                final editorAreaWidth =
                    maxWidth - (_showSidebar ? sidebarWidth + 8 : 0);
                final showRevisionDetails =
                    _showGaugeDashboard && _showRevisionDetails;
                final inlineRevision =
                    showRevisionDetails &&
                    editorAreaWidth >= _revisionSidebarWidth + 8 + 360;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 左側內容區域
                    ExcludeFocus(
                      excluding: !_showSidebar,
                      child: Offstage(
                        offstage: !_showSidebar,
                        child: SizedBox(
                          width: sidebarWidth,
                          child: Container(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLowest,
                            child: _buildPageContent(),
                          ),
                        ),
                      ),
                    ),

                    Offstage(
                      offstage: !_showSidebar,
                      child: MonogatariResizeDivider(
                        onPanUpdate: (details) {
                          setState(() {
                            double currentWidth = sidebarWidth;
                            double newWidth = currentWidth + details.delta.dx;

                            double newRatio = newWidth / maxWidth;
                            double minRatio = minSidebarWidth / maxWidth;
                            double maxRatio = effectiveMaxWidth / maxWidth;

                            _sidebarWidthRatio = newRatio.clamp(
                              minRatio,
                              maxRatio,
                            );
                          });
                        },
                      ),
                    ),
                    // 右側編輯器
                    Expanded(
                      key: const ValueKey("editor-pane"),
                      child: Stack(
                        children: [
                          Positioned.fill(child: _buildEditor()),
                          if (showRevisionDetails && !inlineRevision)
                            Positioned(
                              key: const ValueKey("revision-sidebar-overlay"),
                              top: 0,
                              bottom: 0,
                              right: 0,
                              width: min(
                                _revisionSidebarWidth,
                                editorAreaWidth,
                              ),
                              child: Material(
                                elevation: 8,
                                child: _buildRevisionPanel(
                                  onClose: () => setState(
                                    () => _showRevisionDetails = false,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (inlineRevision) ...[
                      MonogatariResizeDivider(
                        onPanUpdate: (details) => setState(() {
                          _revisionSidebarWidth =
                              (_revisionSidebarWidth - details.delta.dx).clamp(
                                280.0,
                                min(480.0, editorAreaWidth - 368),
                              );
                        }),
                      ),
                      SizedBox(
                        key: const ValueKey("revision-sidebar-inline"),
                        width: _revisionSidebarWidth,
                        child: _buildRevisionPanel(
                          onClose: () =>
                              setState(() => _showRevisionDetails = false),
                        ),
                      ),
                    ],
                    if (_showGaugeDashboard) ...[
                      const VerticalDivider(width: 1, thickness: 1),
                      SizedBox(
                        key: const ValueKey("dashboard-column"),
                        width: dashboardWidth,
                        child: showDashboardInline
                            ? RadialGaugeDashboard(
                                onStartRevision: _startRevisionTracking,
                                onOpenRevision: _openRevisionDetails,
                                onClose: () =>
                                    setState(() => _showGaugeDashboard = false),
                              )
                            : Material(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerLow,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: IconButton(
                                    key: const ValueKey(
                                      "gauge-dashboard-toggle",
                                    ),
                                    tooltip: context.l10n.uiOpenDashboard,
                                    icon: const Icon(Icons.speed_rounded),
                                    onPressed: () {
                                      if (canShowDashboardInline) {
                                        setState(
                                          () => _showGaugeDashboard = true,
                                        );
                                      } else {
                                        RadialGaugeDashboard.show(
                                          context,
                                          onStartRevision:
                                              _startRevisionTracking,
                                          onOpenRevision: _openRevisionDetails,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),

        // 桌面狀態列
        _buildDesktopStatusBar(
          fontSize: fontSize,
          wordCountMode: wordCountMode,
          hasUnsavedChanges: hasUnsavedChanges,
          lastSavedTime: lastSavedTime,
        ),
      ],
    );
  }

  // 桌面狀態列
  Widget _buildDesktopStatusBar({
    required double fontSize,
    required WordCountMode wordCountMode,
    required bool hasUnsavedChanges,
    required DateTime? lastSavedTime,
  }) {
    // 復用手機版的狀態列邏輯，但為了程式碼清晰，獨立出一個方法
    // 在未來可以在這裡添加桌面版特有的資訊（如編碼格式、游標位置等）
    return _buildMobileStatusBar(
      fontSize: fontSize,
      wordCountMode: wordCountMode,
      hasUnsavedChanges: hasUnsavedChanges,
      lastSavedTime: lastSavedTime,
    );
  }

  void _startRevisionTracking() {
    _syncEditorToSelectedChapter();
    ref
        .read(revisionEditorDraftProvider.notifier)
        .update(
          ref.read(projectUuidProvider),
          selectedChapID,
          textController.rawText,
        );
    ref.read(revisionTrackingProvider.notifier).start();
  }

  Future<void> _openRevisionDetails() async {
    if (!mounted) return;
    if (MediaQuery.sizeOf(context).width >= 800) {
      setState(() {
        _showRevisionDetails = true;
        _showGaugeDashboard = true;
      });
      return;
    }
    if (_revisionDialogOpen) return;
    _revisionDialogOpen = true;
    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => Dialog(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 880,
            height: min(760, MediaQuery.sizeOf(dialogContext).height - 80),
            child: _buildRevisionPanel(
              onClose: () => Navigator.of(dialogContext).pop(),
              onNavigate: () => Navigator.of(dialogContext).pop(),
            ),
          ),
        ),
      );
    } finally {
      _revisionDialogOpen = false;
    }
  }

  Widget _buildRevisionPanel({
    required VoidCallback onClose,
    VoidCallback? onNavigate,
  }) => RevisionTrackingPanel(
    onStart: _startRevisionTracking,
    onClose: onClose,
    onRejectTextScope: (selection) {
      _syncEditorToSelectedChapter();
      final tracking = ref.read(revisionTrackingProvider);
      if (tracking.baseline?.readOnly != false ||
          tracking.status != RevisionComparisonStatus.complete ||
          !ref.read(revisionTrackingProvider.notifier).comparisonIsFresh()) {
        _showMessage(context.l10n.uiTheManuscriptChangedWaitForChangesToBe);
        return;
      }
      final updates = <String, ({String folderId, String content})>{};
      try {
        for (final entry in selection.entries) {
          final text = entry.key;
          if (tracking.comparison?.texts.contains(text) != true ||
              !text.hunks.toSet().containsAll(entry.value)) {
            throw StateError("Stale text selection");
          }
          final location = ChapterModule.ChapterTree.findChapter(
            ref.read(segmentsDataProvider),
            chapterId: text.chapterId,
          );
          final expected =
              tracking.targetSnapshot?.chapterTexts[text.chapterId];
          if (location == null ||
              expected == null ||
              location.chapter.chapterContent != expected) {
            throw StateError("Changed chapter");
          }
          updates[text.chapterId] = (
            folderId: location.folder.segmentUUID,
            content: RevisionReviewService.rejectTextHunks(
              before:
                  tracking.baseline!.snapshot.chapterTexts[text.chapterId] ??
                  "",
              after: expected,
              diff: text,
              hunks: entry.value,
            ),
          );
        }
      } catch (_) {
        _showMessage(
          context.l10n.uiTheBatchRejectionSourceHasChangedRecalculateThe,
        );
        return;
      }
      _recordProjectHistorySnapshot();
      for (final entry in updates.entries) {
        if (selectedChapID == entry.key) {
          textController.setRawText(entry.value.content);
        }
        ref
            .read(segmentsDataProvider.notifier)
            .updateChapterContent(
              segmentID: entry.value.folderId,
              chapterID: entry.key,
              content: entry.value.content,
            );
      }
      _recordProjectHistorySnapshot();
    },
    onRejectText: (text, hunk) {
      _syncEditorToSelectedChapter();
      final tracking = ref.read(revisionTrackingProvider);
      final snapshot = tracking.targetSnapshot;
      final current = ChapterModule.ChapterTree.findChapter(
        ref.read(segmentsDataProvider),
        chapterId: text.chapterId,
      );
      final expected = snapshot?.chapterTexts[text.chapterId];
      if (tracking.status != RevisionComparisonStatus.complete ||
          tracking.comparison?.texts.contains(text) != true ||
          !ref.read(revisionTrackingProvider.notifier).comparisonIsFresh() ||
          current == null ||
          expected == null ||
          current.chapter.chapterContent != expected) {
        _showMessage(context.l10n.uiTheManuscriptChangedWaitForChangesToBe2);
        return;
      }
      final original =
          tracking.baseline!.snapshot.chapterTexts[text.chapterId] ?? "";
      try {
        final restored = RevisionReviewService.rejectTextHunk(
          before: original,
          after: expected,
          diff: text,
          hunk: hunk,
        );
        _recordProjectHistorySnapshot();
        if (selectedChapID == text.chapterId) {
          textController.setRawText(restored);
        }
        ref
            .read(segmentsDataProvider.notifier)
            .updateChapterContent(
              segmentID: current.folder.segmentUUID,
              chapterID: text.chapterId,
              content: restored,
            );
        _recordProjectHistorySnapshot();
      } catch (_) {
        _showMessage(context.l10n.uiThisBlockSPositionIsNoLongerValid);
      }
    },
    onRejectRecord: (record, field) {
      if (field == null ||
          !RevisionReviewService.canRejectField(record, field)) {
        return;
      }
      final tracking = ref.read(revisionTrackingProvider);
      if (tracking.status != RevisionComparisonStatus.complete ||
          tracking.comparison?.records.contains(record) != true ||
          !ref.read(revisionTrackingProvider.notifier).comparisonIsFresh()) {
        _showMessage(context.l10n.uiTheFieldChangedWaitForChangesToBe);
        return;
      }
      final name = field.target.fieldPath.single;
      final currentRecord = RevisionSnapshotBuilder.capture(
        ref.read(projectDataProvider),
        version: "review-check",
      ).records[record.key];
      final currentValue = currentRecord?.fields[name];
      if (currentValue != field.newValue) {
        _showMessage(context.l10n.uiTheFieldChangedWaitForChangesToBe);
        return;
      }
      _recordProjectHistorySnapshot();
      final oldValue = field.oldValue as String;
      switch (record.key.kind) {
        case ProjectRecordKind.baseInfo:
          final notifier = ref.read(baseInfoDataProvider.notifier);
          switch (name) {
            case "bookName":
              notifier.setBookName(oldValue);
            case "author":
              notifier.setAuthor(oldValue);
            case "purpose":
              notifier.setPurpose(oldValue);
            case "toRecap":
              notifier.setToRecap(oldValue);
            case "storyType":
              notifier.setStoryType(oldValue);
            case "intro":
              notifier.setIntro(oldValue);
          }
        case ProjectRecordKind.chapterFolder:
          ref
              .read(segmentsDataProvider.notifier)
              .renameSegment(segmentID: record.key.recordId, name: oldValue);
        case ProjectRecordKind.chapterMetadata:
          final location = ChapterModule.ChapterTree.findChapter(
            ref.read(segmentsDataProvider),
            chapterId: record.key.recordId,
          );
          if (location == null) return;
          ref
              .read(segmentsDataProvider.notifier)
              .renameChapter(
                segmentID: location.folder.segmentUUID,
                chapterID: record.key.recordId,
                name: oldValue,
              );
        case ProjectRecordKind.worldNode:
          ref
              .read(worldSettingsDataProvider.notifier)
              .updateLocationById(
                record.key.recordId,
                (current) => switch (name) {
                  "name" => current.copyWith(localName: oldValue),
                  "localType" => current.copyWith(localType: oldValue),
                  "note" => current.copyWith(note: oldValue),
                  _ => current,
                },
              );
        case ProjectRecordKind.character:
          final current = ref.read(characterDataProvider)[record.key.recordId];
          if (current == null) return;
          final updated = switch (name) {
            "displayName" => current.withDisplayName(oldValue),
            "roleOrOccupation" => current.copyWith(roleOrOccupation: oldValue),
            "age" => current.copyWith(age: oldValue),
            "gender" => current.copyWith(gender: oldValue),
            "appearanceSummary" => current.copyWith(
              appearanceSummary: oldValue,
            ),
            "personalitySummary" => current.copyWith(
              personalitySummary: oldValue,
            ),
            "speechStyle" => current.copyWith(speechStyle: oldValue),
            "motivation" => current.copyWith(motivation: oldValue),
            "goal" => current.copyWith(goal: oldValue),
            "valuesAndBeliefs" => current.copyWith(valuesAndBeliefs: oldValue),
            "fear" => current.copyWith(fear: oldValue),
            "relationshipSummary" => current.copyWith(
              relationshipSummary: oldValue,
            ),
            "notes" => current.copyWith(notes: oldValue),
            _ => current,
          };
          ref
              .read(characterDataProvider.notifier)
              .setCharacterEntry(
                characterId: record.key.recordId,
                entry: name == "displayName"
                    ? updated
                    : updated.withTextField(name, oldValue),
              );
        case ProjectRecordKind.outlineStoryline:
          ref
              .read(outlineDataProvider.notifier)
              .updateOutlineData(
                (source) => [
                  for (final storyline in source)
                    if (storyline.chapterUUID == record.key.recordId)
                      switch (name) {
                        "name" => storyline.copyWith(storylineName: oldValue),
                        "type" => storyline.copyWith(storylineType: oldValue),
                        "memo" => storyline.copyWith(memo: oldValue),
                        "conflictPoint" => storyline.copyWith(
                          conflictPoint: oldValue,
                        ),
                        _ => storyline,
                      }
                    else
                      storyline,
                ],
              );
        case ProjectRecordKind.outlineEvent:
          ref
              .read(outlineDataProvider.notifier)
              .updateOutlineData(
                (source) => [
                  for (final storyline in source)
                    storyline.copyWith(
                      scenes: [
                        for (final event in storyline.scenes)
                          if (event.storyEventUUID == record.key.recordId)
                            switch (name) {
                              "event" => event.copyWith(storyEvent: oldValue),
                              "memo" => event.copyWith(memo: oldValue),
                              "conflictPoint" => event.copyWith(
                                conflictPoint: oldValue,
                              ),
                              _ => event,
                            }
                          else
                            event,
                      ],
                    ),
                ],
              );
        case ProjectRecordKind.outlineScene:
          ref
              .read(outlineDataProvider.notifier)
              .updateOutlineData(
                (source) => [
                  for (final storyline in source)
                    storyline.copyWith(
                      scenes: [
                        for (final event in storyline.scenes)
                          event.copyWith(
                            scenes: [
                              for (final scene in event.scenes)
                                if (scene.sceneUUID == record.key.recordId)
                                  switch (name) {
                                    "name" => scene.copyWith(
                                      sceneName: oldValue,
                                    ),
                                    "time" => scene.copyWith(time: oldValue),
                                    "location" => scene.copyWith(
                                      location: oldValue,
                                    ),
                                    "focusPoint" => scene.copyWith(
                                      focusPoint: oldValue,
                                    ),
                                    "conflictPoint" => scene.copyWith(
                                      conflictPoint: oldValue,
                                    ),
                                    "memo" => scene.copyWith(memo: oldValue),
                                    _ => scene,
                                  }
                                else
                                  scene,
                            ],
                          ),
                      ],
                    ),
                ],
              );
        case ProjectRecordKind.itemClass:
          final current = ref
              .read(itemWorkspaceProvider)
              .itemClasses[record.key.recordId];
          if (current == null) return;
          final updated = switch (name) {
            "name" => current.copyWith(
              name: oldValue,
              defaultState: current.defaultState.copyWith(name: oldValue),
            ),
            "description" => current.copyWith(
              description: oldValue,
              defaultState: current.defaultState.copyWith(
                description: oldValue,
              ),
            ),
            "category" => current.copyWith(category: oldValue),
            "unit" => current.copyWith(unit: oldValue),
            _ => current,
          };
          ref.read(itemWorkspaceProvider.notifier).putClass(updated);
        case ProjectRecordKind.itemInstance:
          final current = ref
              .read(itemWorkspaceProvider)
              .itemInstances[record.key.recordId];
          if (current == null) return;
          ref
              .read(itemWorkspaceProvider.notifier)
              .putInstance(current.copyWith(name: oldValue));
        default:
          return;
      }
      _recordProjectHistorySnapshot();
    },
    onNavigateText: (text, hunk, index) {
      _syncEditorToSelectedChapter();
      final opened = ref
          .read(editorCoordinatorProvider.notifier)
          .navigateToChapter(text.chapterId);
      if (!opened) {
        _showMessage(
          context.l10n.uiThisChapterWasDeletedViewItsPreviousContent,
        );
        return;
      }
      onNavigate?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || selectedChapID != text.chapterId) return;
        final position = hunk.newOffset.clamp(0, textController.rawText.length);
        textController.setRawText(
          textController.rawText,
          rawSelection: TextSelection.collapsed(offset: position),
        );
        editorFocusNode.requestFocus();
      });
    },
    onNavigateRecord: (record, field) {
      _syncEditorToSelectedChapter();
      setState(() => _showSidebar = true);
      onNavigate?.call();
      switch (record.key.kind) {
        case ProjectRecordKind.baseInfo:
          setState(() => slidePageIndexNow = 1);
        case ProjectRecordKind.chapterFolder:
          setState(() => slidePageIndexNow = 2);
        case ProjectRecordKind.chapterMetadata:
          setState(() => slidePageIndexNow = 2);
          if (record.after != null) {
            ref
                .read(editorCoordinatorProvider.notifier)
                .navigateToChapter(record.key.recordId);
          }
        case ProjectRecordKind.character:
          if (record.after != null) {
            _openCharacter(record.key.recordId);
          } else {
            setState(() => slidePageIndexNow = 5);
          }
        case ProjectRecordKind.worldNode:
          setState(() {
            _requestedLocationId = record.after == null
                ? null
                : record.key.recordId;
            _locationSelectionRequestId++;
            slidePageIndexNow = 7;
          });
        case ProjectRecordKind.outlineStoryline:
        case ProjectRecordKind.outlineEvent:
        case ProjectRecordKind.outlineScene:
        case ProjectRecordKind.outlineChapterLink:
          if (record.after != null) {
            ref
                .read(outlineSelectionRequestProvider.notifier)
                .requestTarget(
                  record.key.kind == ProjectRecordKind.outlineChapterLink
                      ? (record.after?.fields["sceneUUID"] as String? ??
                            record.key.recordId)
                      : record.key.recordId,
                );
          }
          setState(() => slidePageIndexNow = 3);
        case ProjectRecordKind.itemClass:
        case ProjectRecordKind.itemInstance:
        case ProjectRecordKind.itemRelation:
        case ProjectRecordKind.itemClassStateChange:
        case ProjectRecordKind.itemInstanceStateChange:
          final fields = (record.after ?? record.before)?.fields;
          final workspace = ref.read(itemWorkspaceProvider);
          final itemId = fields == null ? null : fields["itemId"] as String?;
          final itemKind = fields == null ? null : fields["itemKind"];
          final classId = switch (record.key.kind) {
            ProjectRecordKind.itemClass => record.key.recordId,
            ProjectRecordKind.itemInstance =>
              fields == null ? null : fields["classId"] as String?,
            ProjectRecordKind.itemClassStateChange =>
              fields == null ? null : fields["classId"] as String?,
            ProjectRecordKind.itemInstanceStateChange =>
              workspace
                  .itemInstances[fields == null ? null : fields["instanceId"]]
                  ?.classId,
            ProjectRecordKind.itemRelation =>
              itemKind == "itemClass"
                  ? itemId
                  : workspace.itemInstances[itemId]?.classId,
            _ => null,
          };
          setState(() {
            _requestedItemClassId = classId;
            _itemSelectionRequestId++;
            slidePageIndexNow = 8;
          });
        default:
          break;
      }
    },
    sidebarPageIndex: slidePageIndexNow,
  );

  // 獲取 NavigationRail 的選中索引
  int _getNavigationIndex() {
    return _currentModule.navigationIndex;
  }

  // 頁面內容
  Widget _buildPageContent() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: _buildPageView(),
    );
  }

  // 頁面視圖
  Widget _buildPageView() {
    final int pageIndex = slidePageIndexNow > (slidePageCounts - 1)
        ? _lastFunctionModule.navigationIndex
        : slidePageIndexNow; // 編輯器模式保留上次功能模組

    return IndexedStack(
      index: pageIndex.clamp(0, slidePageCounts - 1),
      children: [
        for (int i = 0; i < slidePageCounts; i++) _buildSpecificPageContent(i),
      ],
    );
  }

  // 編輯器
  Widget _buildEditor() {
    return HelpScope(
      topicId: HelpTopicId.editor,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            // 標點符號列（當開啟時）- 放在最上方
            if (showPunctuationPanel)
              HelpTarget(
                topicId: HelpTopicId.punctuation,
                child: PunctuationPanel(
                  onInsert: _insertText,
                  onClose: () {
                    setState(() {
                      showPunctuationPanel = false;
                    });
                  },
                ),
              ),

            // 搜尋列（當開啟時）- 放在標點符號列下方
            if (showFindReplaceWindow)
              HelpTarget(
                topicId: HelpTopicId.search,
                child: FindReplaceBar(
                  key: _findBarKey,
                  findController: findController,
                  replaceController: replaceController,
                  options: findReplaceOptions,
                  currentMatchIndex: _searchMatches.isNotEmpty
                      ? _currentMatchIndex
                      : null,
                  totalMatches: _searchMatches.length,
                  onFindNext: (findText, replaceText, options) async {
                    await performFind(
                      textController,
                      findText,
                      options,
                      editorFocusNode,
                      _searchMatches,
                      _currentMatchIndex,
                      (matches, index) {
                        setState(() {
                          _searchMatches = matches;
                          _currentMatchIndex = index;
                        });
                      },
                      forward: true,
                    );
                    _syncFindRangesToQuill(findText);
                    await _analyzeRhodantheSearch(
                      findText,
                      options,
                      _searchMatches,
                      _currentMatchIndex,
                    );
                  },
                  onFindPrevious: (findText, replaceText, options) async {
                    await performFind(
                      textController,
                      findText,
                      options,
                      editorFocusNode,
                      _searchMatches,
                      _currentMatchIndex,
                      (matches, index) {
                        setState(() {
                          _searchMatches = matches;
                          _currentMatchIndex = index;
                        });
                      },
                      forward: false,
                    );
                    _syncFindRangesToQuill(findText);
                    await _analyzeRhodantheSearch(
                      findText,
                      options,
                      _searchMatches,
                      _currentMatchIndex,
                    );
                  },
                  onReplace: (findText, replaceText, options) async {
                    await performReplace(
                      context,
                      textController,
                      findText,
                      replaceText,
                      options,
                      editorFocusNode,
                      _searchMatches,
                      _currentMatchIndex,
                      (matches, index) {
                        setState(() {
                          _searchMatches = matches;
                          _currentMatchIndex = index;
                        });
                      },
                      (_) {
                        setState(() {
                          contentText = textController.rawText;
                          _textChangeDebouncer.onTextChanged(
                            textController.rawText,
                          );
                        });
                      },
                    );
                    _syncFindRangesToQuill(findText);
                    await _analyzeRhodantheSearch(
                      findText,
                      options,
                      _searchMatches,
                      _currentMatchIndex,
                    );
                  },
                  onReplaceAll: (findText, replaceText, options) async {
                    await performReplaceAll(
                      context,
                      textController,
                      findText,
                      replaceText,
                      options,
                      (matches, index) {
                        setState(() {
                          _searchMatches = matches;
                          _currentMatchIndex = index;
                        });
                      },
                      (_) {
                        setState(() {
                          contentText = textController.rawText;
                          _textChangeDebouncer.onTextChanged(
                            textController.rawText,
                          );
                        });
                      },
                    );
                    _syncFindRangesToQuill(findText);
                    await _analyzeRhodantheSearch(
                      findText,
                      options,
                      _searchMatches,
                      _currentMatchIndex,
                    );
                  },
                  onOptionsRequested: () =>
                      _ribbonController.selectTab("search"),
                  optionsRevision: _findOptionsRevision,
                  onSearchChanged: _refreshSearchResults,
                  onClose: _closeFindReplace,
                ),
              ),

            // 文本編輯器 - 使用 Expanded 填充剩餘空間
            Expanded(
              child: EditorTextBox(
                key: _bodyEditorKey,
                controller: textController,
                showPhraseActions: false,
                focusNode: editorFocusNode,
                onUndo: _undoProjectHistory,
                onRedo: _redoProjectHistory,
                onInteractionOffset: _handleInlineAnnotationInteraction,
                quillSearchController: _quillSearchController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeView() {
    final project = currentProject;
    final projectUuid = ref.watch(projectUuidProvider);
    final hasPersistentLocation =
        project != null &&
        ((project.filePath?.trim().isNotEmpty ?? false) ||
            (project.uri?.trim().isNotEmpty ?? false));
    return WelcomeModule.WelcomeView(
      onNewProject: _newProject,
      onOpenProject: _openProject,
      onOpenRecentProject: _openRecentProject,
      onDeleteRecentProject: _deleteRecentProject,
      localP2pProject: project == null
          ? null
          : P2pProjectStatus(
              fileName: project.fullFileName,
              hasPersistentLocation: hasPersistentLocation,
              hasUnsavedChanges:
                  hasUnsavedChanges && !_hasUnpersistedRemoteDraft,
              projectUuid: projectUuid,
              isPersistedSnapshotValidated: hasPersistentLocation,
            ),
      onSaveProject: _saveProject,
      onSaveProjectAs: _saveProjectAs,
      onChooseSyncProject: _openProject,
      onApplyVerifiedP2pSnapshot: _applyVerifiedP2pSnapshot,
      onCompareVerifiedP2pSnapshot: _compareVerifiedP2pSnapshot,
      onResolveConcurrentP2pSnapshot: _resolveConcurrentP2pSnapshot,
    );
  }

  Future<bool> _resolveConcurrentP2pSnapshot(
    P2pVerifiedSnapshot snapshot,
  ) async {
    if (_isProjectSwitching || !mounted || currentProject == null) return false;
    final notifier = ref.read(p2pSyncProvider.notifier);
    final plan = await notifier.prepareConcurrentMerge(snapshot);
    if (!mounted || plan == null) {
      _showError(
        ref.read(p2pSyncProvider).revisionMetadataErrorFor(context.l10n) ??
            context.l10n.uiCouldNotPrepareTheThreeWayMerge,
      );
      return false;
    }
    final resolution = plan.conflicts.isEmpty
        ? P2pConflictResolutionResult(const <String, P2pConflictSide>{})
        : await P2pConflictResolutionDialog.show(
            context,
            conflicts: plan.conflicts,
          );
    if (!mounted || resolution == null) return false;
    final syncState = ref.read(p2pSyncProvider);
    final graph = syncState.localRevisionGraph;
    final activeMergeSession = syncState.trustedPeer == null
        ? ""
        : "${syncState.trustedPeer!.deviceId}:${plan.localRevision.revisionId}:${plan.remoteRevision.revisionId}";
    if (graph == null ||
        !syncState.hasAuthenticatedTransport ||
        !plan.matchesHeads(
          activeSessionId: activeMergeSession,
          headRevisionIds: graph.headIds,
        )) {
      _showError(
        context.l10n.uiRevisionHeadsChangedDuringMergingOutdatedConflictChoices,
      );
      return false;
    }

    late final ProjectData resolvedData;
    try {
      resolvedData = plan.apply(resolution);
    } catch (error) {
      _showError(
        context.l10n.uiCouldNotApplyConflictChoices((error).toString()),
      );
      return false;
    }
    _isProjectSwitching = true;
    final session = _projectIoSession;
    try {
      final runResult = await _projectIoCoordinator.run(session, () async {
        final controller = ref.read(projectIoControllerProvider.notifier);
        final payload = await controller.prepareProjectPayload(
          resolvedData,
          regenerateProjectUuid: false,
        );
        final saved = await controller.saveProject(
          currentProject: currentProject,
          currentData: resolvedData,
          forceSaveAs: false,
          preparedPayload: payload,
        );
        return (saved: saved, payload: payload);
      });
      final result = runResult.value;
      if (!mounted ||
          result == null ||
          !_projectIoCoordinator.isCurrent(session)) {
        return false;
      }
      final resolvedGraph = await notifier.recordResolvedSnapshot(
        parentRevisionIds: <String>[
          plan.localRevision.revisionId,
          plan.remoteRevision.revisionId,
        ],
        xmlContent: result.payload.xmlContent,
        formatVersion: FileService.projectVersion,
      );
      if (!mounted || resolvedGraph == null) {
        _showError(context.l10n.uiTheMergedFileWasSavedButCreatingThe);
        return false;
      }
      final initialState = ref
          .read(editorCoordinatorProvider.notifier)
          .calculateInitialState(resolvedData, _settingsState.wordCountMode);
      setState(() {
        currentProject = result.saved;
        _applyProjectData(resolvedData, initialState);
      });
      _markAsSaved();
      _updateAllWordCounts();
      _editorCoordinatorNotifier.resetAfterProjectLoaded();
      _showMessage(context.l10n.uiFieldConflictsResolvedAndARevisionWithTwo);
      return true;
    } catch (error) {
      if (mounted)
        _showError(
          context.l10n.uiCouldNotSaveTheResolutionRevision((error).toString()),
        );
      return false;
    } finally {
      _isProjectSwitching = false;
    }
  }

  Future<bool> _compareVerifiedP2pSnapshot(P2pVerifiedSnapshot snapshot) async {
    if (!mounted || !_isCurrentP2pComparisonSnapshot(snapshot)) {
      _showError(context.l10n.uiTheRemoteRevisionIsNoLongerValidDownload);
      return false;
    }
    if (FileService.isProjectVersionNewerThanSupported(
      snapshot.manifest.formatVersion,
    )) {
      _showError(context.l10n.uiTheRemoteProjectFormatIsNewerAndCannot);
      return false;
    }
    _syncEditorToSelectedChapter();
    try {
      final parsed = await compute(
        FileService.parseProjectXMLWithMetadata,
        snapshot.xmlContent,
      );
      if (!mounted || !_isCurrentP2pComparisonSnapshot(snapshot)) return false;
      final currentId = ref.read(projectUuidProvider).trim().toLowerCase();
      if (parsed.sourceProjectUuid?.trim().toLowerCase() !=
              snapshot.manifest.projectUuid ||
          parsed.data.projectUUID.trim().toLowerCase() != currentId) {
        _showError(context.l10n.uiTheRemoteRevisionBelongsToAnotherProjectAnd);
        return false;
      }
      ref
          .read(revisionTrackingProvider.notifier)
          .addHistoricalSource(
            parsed.data,
            revisionId: snapshot.manifest.revisionId,
            label:
                "P2P ${snapshot.manifest.revisionId.length > 8 ? snapshot.manifest.revisionId.substring(0, 8) : snapshot.manifest.revisionId}",
          );
      ref
          .read(gaugeDashboardProvider.notifier)
          .setVisible(DashboardMetric.revisionTracking, true);
      setState(() => _showGaugeDashboard = true);
      unawaited(_openRevisionDetails());
      _showMessage(context.l10n.uiTheCompleteRemoteRevisionIsAvailableForRead);
      return true;
    } catch (error) {
      if (mounted)
        _showError(
          context.l10n.uiCouldNotCompareTheRemoteRevision((error).toString()),
        );
      return false;
    }
  }

  Future<bool> _applyVerifiedP2pSnapshot(P2pVerifiedSnapshot snapshot) async {
    if (_isProjectSwitching || !mounted) return false;
    if (!_isCurrentP2pSnapshot(snapshot)) {
      _showError(context.l10n.uiTheSyncSessionOrRemoteRevisionChangedDownload);
      return false;
    }

    final syncState = ref.read(p2pSyncProvider);
    final currentFile = currentProject;
    final currentName = currentFile?.fullFileName;
    final canOverwriteCurrent =
        currentFile != null &&
        !currentFile.isNewFile &&
        ref.read(projectUuidProvider).trim().toLowerCase() ==
            snapshot.manifest.projectUuid;
    final hasLocalUnsavedChanges =
        hasUnsavedChanges && !_hasUnpersistedRemoteDraft;
    if (hasLocalUnsavedChanges) {
      _showError(context.l10n.uiTheWorkingCopyHasLiveOperationsSnapshotsAre);
      return false;
    }

    final remoteIsDraft =
        syncState.remoteHeadIsDraft &&
        syncState.remoteRevisionSummary?.heads.single.revisionId ==
            snapshot.manifest.revisionId;
    late final _P2pSnapshotApplyChoice? choice;
    if (canOverwriteCurrent) {
      final allowed = await _confirmP2pSessionAutoApply(
        snapshot,
        appliesInMemory: remoteIsDraft,
      );
      choice = allowed ? _P2pSnapshotApplyChoice.overwriteCurrent : null;
    } else {
      choice = await showDialog<_P2pSnapshotApplyChoice>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: Text(dialogContext.l10n.uiSaveAndOpenRemoteRevision),
          content: Text(
            currentName == null
                ? dialogContext
                      .l10n
                      .uiTheRemoteSnapshotIsFullyVerifiedChooseWhere
                : dialogContext.l10n.uiTheRemoteSnapshotIsVerifiedButItCannot,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(_P2pSnapshotApplyChoice.cancel),
              child: Text(dialogContext.l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(
                dialogContext,
              ).pop(_P2pSnapshotApplyChoice.saveAs),
              child: Text(dialogContext.l10n.uiChooseSaveLocation),
            ),
          ],
        ),
      );
    }
    if (choice == null ||
        choice == _P2pSnapshotApplyChoice.cancel ||
        !mounted) {
      return false;
    }
    if (!_isCurrentP2pSnapshot(snapshot)) {
      _showError(
        context.l10n.uiTheSyncSessionChangedDuringConfirmationNoProject,
      );
      return false;
    }

    if (FileService.isProjectVersionNewerThanSupported(
      snapshot.manifest.formatVersion,
    )) {
      final shouldContinue =
          await ProjectManager.showVersionCompatibilityDialog(
            context,
            fileVersion: snapshot.manifest.formatVersion,
            supportedVersion: FileService.projectVersion,
          );
      if (!mounted || !shouldContinue || !_isCurrentP2pSnapshot(snapshot)) {
        return false;
      }
    }

    if (remoteIsDraft &&
        choice == _P2pSnapshotApplyChoice.overwriteCurrent &&
        currentFile != null) {
      return _applyVerifiedP2pDraftInMemory(snapshot, currentFile);
    }

    _isProjectSwitching = true;
    final switchSession = _projectIoCoordinator.beginSession(
      "switch:p2p:${snapshot.manifest.revisionId}",
    );
    _projectIoSession = switchSession;
    try {
      final remoteName = ref
          .read(p2pSyncProvider)
          .remoteProjectOffer
          ?.fileName
          ?.trim();
      final suggestedName = remoteName == null || remoteName.isEmpty
          ? "P2P_${snapshot.manifest.projectUuid.substring(0, 8)}.mnproj"
          : remoteName;
      final runResult = await _projectIoCoordinator.run(switchSession, () {
        final controller = ref.read(projectIoControllerProvider.notifier);
        if (choice == _P2pSnapshotApplyChoice.overwriteCurrent &&
            currentFile != null) {
          return controller.overwriteAndLoadExternalProjectSnapshot(
            currentProject: currentFile,
            xmlContent: snapshot.xmlContent,
          );
        }
        return controller.saveAndLoadExternalProjectSnapshotAs(
          suggestedFileName: suggestedName,
          xmlContent: snapshot.xmlContent,
        );
      });
      final loadResult = runResult.value;
      if (!mounted ||
          loadResult == null ||
          !_projectIoCoordinator.isCurrent(switchSession) ||
          !_isCurrentP2pSnapshot(snapshot)) {
        if (mounted && _projectIoCoordinator.isCurrent(switchSession)) {
          _showError(context.l10n.uiTheSnapshotWasSavedButTheSyncSession);
        }
        return false;
      }

      final initialState = ref
          .read(editorCoordinatorProvider.notifier)
          .calculateInitialState(loadResult.data, _settingsState.wordCountMode);
      setState(() {
        _resetProjectSessionUiState();
        currentProject = loadResult.projectFile;
        _resetAutoBackupBaseline();
        _applyProjectData(loadResult.data, initialState);
      });
      final activeProjectSession = _beginProjectIoSession(
        loadResult.projectFile,
      );
      _updateAllWordCounts();
      for (final warning in loadResult.migrationWarnings) {
        debugPrint(
          "P2P project migration warning [${warning.code}]: ${warning.message}",
        );
      }
      _showMessage(
        choice == _P2pSnapshotApplyChoice.overwriteCurrent
            ? context.l10n.uiRemoteSnapshotOverwrittenAndOpened(
                (loadResult.projectFile.nameWithoutExtension).toString(),
              )
            : context.l10n.uiRemoteSnapshotSavedAsACopyAndOpened(
                (loadResult.projectFile.nameWithoutExtension).toString(),
              ),
      );
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || !_projectIoCoordinator.isCurrent(activeProjectSession)) {
        return false;
      }
      _resetProjectHistory();
      _editorCoordinatorNotifier.resetAfterProjectLoaded();
      await _editorCoordinatorNotifier.recordRecentProject(
        loadResult.projectFile,
      );
      return mounted &&
          _projectIoCoordinator.isCurrent(activeProjectSession) &&
          _isCurrentP2pSnapshot(snapshot);
    } catch (error) {
      if (mounted && _projectIoCoordinator.isCurrent(switchSession)) {
        final message = error.toString();
        if (!message.contains("另存檔案已取消")) {
          _showError(
            context.l10n.uiCouldNotSaveOrOpenTheRemoteSnapshot(
              (message).toString(),
            ),
          );
        }
        _beginProjectIoSession(currentProject);
      }
      return false;
    } finally {
      if (_projectIoCoordinator.isCurrent(switchSession)) {
        _beginProjectIoSession(currentProject);
      }
      _isProjectSwitching = false;
    }
  }

  String? _currentP2pSecureSessionKey() {
    final state = ref.read(p2pSyncProvider);
    final projectUuid = state.sessionProjectUuid;
    final peerId = state.trustedPeer?.deviceId;
    final localNonce = state.localPairingChallenge?.nonceBase64;
    final remoteNonce = state.remotePairingChallenge?.nonceBase64;
    if (!state.hasAuthenticatedTransport ||
        projectUuid == null ||
        peerId == null ||
        localNonce == null ||
        remoteNonce == null) {
      return null;
    }
    return "$projectUuid|$peerId|$localNonce|$remoteNonce";
  }

  Future<bool> _confirmP2pSessionAutoApply(
    P2pVerifiedSnapshot snapshot, {
    required bool appliesInMemory,
  }) async {
    final sessionKey = _currentP2pSecureSessionKey();
    if (sessionKey == null) return false;
    if (_p2pAutoApplyApprovedSessionKey == sessionKey) return true;
    final approved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.uiAllowAutomaticSyncForThisSession),
        content: Text(
          appliesInMemory
              ? dialogContext.l10n.uiTheRemoteDraftIsFullyVerifiedIfAllowed
              : dialogContext.l10n.uiTheRemoteRevisionIsFullyVerifiedIfAllowed(
                  (snapshot.manifest.projectUuid.substring(0, 8)).toString(),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.uiNotNow),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogContext.l10n.uiAllowThisSession),
          ),
        ],
      ),
    );
    if (approved == true &&
        mounted &&
        _currentP2pSecureSessionKey() == sessionKey) {
      _p2pAutoApplyApprovedSessionKey = sessionKey;
      return true;
    }
    return false;
  }

  Future<bool> _applyVerifiedP2pDraftInMemory(
    P2pVerifiedSnapshot snapshot,
    ProjectFile currentFile,
  ) async {
    _isProjectSwitching = true;
    final session = _projectIoSession;
    try {
      final runResult = await _projectIoCoordinator.run(session, () {
        return ref
            .read(projectIoControllerProvider.notifier)
            .parseExternalProjectSnapshot(
              currentProject: currentFile,
              xmlContent: snapshot.xmlContent,
            );
      });
      final loadResult = runResult.value;
      if (!mounted ||
          loadResult == null ||
          !_projectIoCoordinator.isCurrent(session) ||
          !_isCurrentP2pSnapshot(snapshot)) {
        return false;
      }
      final initialState = ref
          .read(editorCoordinatorProvider.notifier)
          .calculateInitialState(loadResult.data, _settingsState.wordCountMode);
      _hasUnpersistedRemoteDraft = true;
      setState(() {
        _applyProjectData(loadResult.data, initialState);
      });
      _updateAllWordCounts();
      _editorCoordinatorNotifier.resetAfterProjectLoaded();
      _editorCoordinatorNotifier.markAsModified();
      _resetProjectHistory();
      _publishLocalP2pProjectStatusNow();
      _showMessage(context.l10n.uiRemoteDraftAppliedInNearRealTimeThe);
      return true;
    } catch (error) {
      if (mounted)
        _showError(
          context.l10n.uiCouldNotApplyTheRemoteDraftInMemory(
            (error).toString(),
          ),
        );
      return false;
    } finally {
      _isProjectSwitching = false;
    }
  }

  bool _isCurrentP2pSnapshot(P2pVerifiedSnapshot snapshot) {
    return _isCurrentP2pComparisonSnapshot(snapshot) &&
        ref.read(p2pSyncProvider).revisionSummaryRelation ==
            P2pRevisionSummaryRelation.remoteAhead;
  }

  bool _isCurrentP2pComparisonSnapshot(P2pVerifiedSnapshot snapshot) {
    final syncState = ref.read(p2pSyncProvider);
    return syncState.hasAuthenticatedTransport &&
        syncState.sessionProjectUuid == snapshot.manifest.projectUuid &&
        syncState.remoteSnapshotManifest == snapshot.manifest &&
        syncState.snapshotManifestStatus == P2pSnapshotManifestStatus.available;
  }

  Future<void> _recordP2pPersistedRevision(ProjectIoPayload? payload) async {
    if (payload == null) return;
    final recorded = await ref
        .read(p2pSyncProvider.notifier)
        .recordPersistedSnapshot(
          projectUuid: payload.snapshot.projectUUID,
          xmlContent: payload.xmlContent,
          formatVersion: FileService.projectVersion,
        );
    if (!recorded) {
      debugPrint(
        "Project saved, but P2P revision metadata could not be recorded.",
      );
    }
  }

  Future<void> _ensureP2pBaselineForLoadedProject(
    ProjectLoadResult loadResult,
    ProjectIoSessionToken session,
  ) async {
    if (!mounted || !_projectIoCoordinator.isCurrent(session)) return;
    final xmlContent = loadResult.persistedXmlContent;
    final sourceProjectUuid = loadResult.persistedProjectUuid
        ?.trim()
        .toLowerCase();
    final loadedProjectUuid = loadResult.data.projectUUID.trim().toLowerCase();
    final formatVersion = loadResult.projectVersion?.trim();
    final hasExactPersistedIdentity =
        xmlContent != null &&
        xmlContent.isNotEmpty &&
        sourceProjectUuid != null &&
        sourceProjectUuid == loadedProjectUuid &&
        P2pProjectStatus.isValidProjectUuid(sourceProjectUuid) &&
        formatVersion != null &&
        formatVersion.isNotEmpty;
    if (!hasExactPersistedIdentity) {
      debugPrint(
        "Skipped automatic P2P baseline: persisted XML needs a normal save to establish an exact UUID/version identity.",
      );
      return;
    }

    // Publish the newly loaded file before recording. This makes the notifier
    // reject a late result if the user switches projects during the write.
    _publishLocalP2pProjectStatusNow();
    final recorded = await ref
        .read(p2pSyncProvider.notifier)
        .recordPersistedSnapshot(
          projectUuid: sourceProjectUuid,
          xmlContent: xmlContent,
          formatVersion: formatVersion,
        );
    if (!mounted || !_projectIoCoordinator.isCurrent(session)) return;
    if (!recorded) {
      debugPrint("Automatic P2P baseline could not be recorded.");
    }
  }

  void _publishLocalP2pProjectStatus() {
    if (!mounted || _isP2pProjectStatusPublishScheduled) return;
    _isP2pProjectStatusPublishScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isP2pProjectStatusPublishScheduled = false;
      if (!mounted) return;
      _publishLocalP2pProjectStatusNow();
    });
  }

  void _publishLocalP2pProjectStatusNow() {
    final project = ref.read(currentProjectFileProvider);
    final hasPersistentLocation =
        project != null &&
        ((project.filePath?.trim().isNotEmpty ?? false) ||
            (project.uri?.trim().isNotEmpty ?? false));
    ref
        .read(p2pSyncProvider.notifier)
        .updateLocalProjectStatus(
          project == null
              ? null
              : P2pProjectStatus(
                  fileName: project.fullFileName,
                  hasPersistentLocation: hasPersistentLocation,
                  hasUnsavedChanges:
                      ref.read(editorCoordinatorProvider).hasUnsavedChanges &&
                      !_hasUnpersistedRemoteDraft,
                  projectUuid: ref.read(projectUuidProvider),
                  isPersistedSnapshotValidated: hasPersistentLocation,
                ),
        );
  }

  // 各個頁面的建構方法（符合 Material Design）
  Widget _buildBaseInfoView() {
    return const BaseInfoModule.BaseInfoView();
  }

  Widget _buildChapterSelectionView() {
    return const ChapterModule.ChapterSelectionView();
  }

  Widget _buildOutlineView() {
    return OutlineModule.OutlineAdjustView(onOpenItem: _openItemClass);
  }

  Widget _buildWorldSettingsView() {
    return WorldSettingsView(
      initialLocationId: _requestedLocationId,
      selectionRequestId: _locationSelectionRequestId,
      onOpenItem: _openItemClass,
    );
  }

  Widget _buildCharacterSettingsView() {
    return CharacterView(
      projectSessionId: _projectSessionVersion,
      initialCharacterId: _requestedCharacterId,
      selectionRequestId: _characterSelectionRequestId,
      onOpenItem: _openItemClass,
    );
  }

  void _openItemClass(String classId) {
    _syncEditorToSelectedChapter();
    _recordPageTransitionIfNeeded(8);
    setState(() {
      _requestedItemClassId = classId;
      _itemSelectionRequestId++;
      slidePageIndexNow = 8;
    });
  }

  void _openCharacter(String characterId) {
    _syncEditorToSelectedChapter();
    _recordPageTransitionIfNeeded(5);
    setState(() {
      _requestedCharacterId = characterId;
      _characterSelectionRequestId++;
      slidePageIndexNow = 5;
    });
  }

  void _openLocation(String locationId) {
    _syncEditorToSelectedChapter();
    _recordPageTransitionIfNeeded(7);
    setState(() {
      _requestedLocationId = locationId;
      _locationSelectionRequestId++;
      slidePageIndexNow = 7;
    });
  }

  Widget _buildTimelineView() {
    return TimelineView(
      onOpenChapter: (chapterUUID) {
        _flushPendingEditorContent();
        _syncEditorToSelectedChapter();
        final opened = ref
            .read(editorCoordinatorProvider.notifier)
            .navigateToChapter(chapterUUID);
        if (!opened) {
          AppFeedback.warning(context, "找不到關聯章節，請重新建立連結。");
        }
      },
      onOpenOutlineScene: (sceneUUID) {
        _flushPendingEditorContent();
        _syncEditorToSelectedChapter();
        ref
            .read(outlineSelectionRequestProvider.notifier)
            .requestScene(sceneUUID);
        _recordPageTransitionIfNeeded(3);
        setState(() => slidePageIndexNow = 3);
      },
      onOpenCharacter: _openCharacter,
      onOpenItem: _openItemClass,
      onOpenLocation: _openLocation,
    );
  }

  Widget _buildRelationView() {
    return CharacterRelationshipGraphView(
      projectSessionId: _projectSessionVersion,
      onOpenCharacter: (characterId) {
        _syncEditorToSelectedChapter();
        _recordPageTransitionIfNeeded(5);
        setState(() {
          _requestedCharacterId = characterId;
          _characterSelectionRequestId++;
          slidePageIndexNow = 5;
        });
      },
    );
  }

  Widget _buildPlanView() {
    return PlanModule.PlanView(
      initialTargetId: _requestedPlanTargetId,
      initialTargetKind: _requestedPlanTargetKind,
      selectionRequestId: _planSelectionRequestId,
    );
  }

  Widget _buildGlossaryView() {
    return const GlossaryModule.GlossaryView();
  }

  Widget _buildPalettesView() {
    return const palettes_module.PalettesView();
  }

  Widget _buildProofreadingView() {
    return ProofReadingModule.ProofReadingView(
      textController: textController,
      chapterSwitchVersion: _proofreadingChapterSwitchVersion,
      onRequestFocusEditor: _focusEditorForProofreading,
      onRhodantheAnnotationsChanged: _handleRhodantheProofreading,
    );
  }

  void _focusEditorForProofreading() {
    final bool isMobileLayout = MediaQuery.of(context).size.width < 800;
    if (isMobileLayout && slidePageIndexNow < slidePageCounts) {
      setState(() {
        slidePageIndexNow = 114514;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      editorFocusNode.requestFocus();
    });
  }

  Widget _buildCopilotView() {
    return copilot_module.CopilotView(
      onOpenChapter: (chapterUUID) {
        _flushPendingEditorContent();
        _syncEditorToSelectedChapter();
        final opened = ref
            .read(editorCoordinatorProvider.notifier)
            .navigateToChapter(chapterUUID);
        if (!opened) {
          AppFeedback.warning(context, "找不到來源章節，可能已被移除。");
          return;
        }
        if (MediaQuery.of(context).size.width < 800) {
          setState(() => slidePageIndexNow = 114514);
        }
      },
      onOpenResource: (resourceType, resourceId) {
        switch (resourceType) {
          case "character":
            _openCharacter(resourceId);
            break;
          case "worldSetting":
            _openLocation(resourceId);
            break;
          case "outlineEvent":
            _syncEditorToSelectedChapter();
            ref
                .read(outlineSelectionRequestProvider.notifier)
                .requestTarget(resourceId);
            _recordPageTransitionIfNeeded(3);
            setState(() => slidePageIndexNow = 3);
            break;
          case "glossaryTerm":
            _syncEditorToSelectedChapter();
            _recordPageTransitionIfNeeded(9);
            setState(() => slidePageIndexNow = 9);
            break;
          default:
            AppFeedback.warning(context, "此來源目前無法定位。");
        }
      },
    );
  }

  Widget _buildSettingView() {
    return const SettingView();
  }

  Widget _buildAboutView() {
    return const AboutModule.AboutView();
  }

  // 檔案操作處理
  Future<void> _handleFileAction(String action) async {
    if (_fileCommandRunning ||
        !mounted ||
        ModalRoute.of(context)?.isCurrent == false ||
        HelpController.maybeOf(context)?.ownsFocus == true ||
        ref.read(projectIoControllerProvider).isProjectIoBusy) {
      return;
    }
    final node = FocusManager.instance.primaryFocus;
    final value = node == null
        ? null
        : _findEditableForFocusNode(node)?.widget.controller.value;
    if (value != null &&
        value.composing.isValid &&
        !value.composing.isCollapsed) {
      return;
    }
    setState(() => _fileCommandRunning = true);
    try {
      switch (action) {
        case "new":
          await _newProject();
          break;
        case "open":
          await _openProject();
          break;
        case "save":
          await _saveProject();
          break;
        case "saveAs":
          await _saveProjectAs();
          break;
        case "export_selective":
          await _showExportDialog();
          break;
        case "import_selective":
          await _importSelective();
          break;
        case "export_txt":
          await _exportAs("txt");
          break;
        case "export_md":
          await _exportAs("md");
          break;
      }
    } finally {
      if (mounted) setState(() => _fileCommandRunning = false);
    }
  }

  Future<void> _importSelective() async {
    try {
      _syncEditorToSelectedChapter();
      final controller = ref.read(projectIoControllerProvider.notifier);
      final sourceFile = await controller.pickProjectFile();
      if (sourceFile == null || !mounted) return;
      final sourceXml = sourceFile.content;
      if (sourceXml.trim().isEmpty) {
        throw const FormatException("匯入檔案沒有內容。");
      }
      final manifest = SelectiveProjectImportManifest.fromXml(sourceXml);
      if (manifest.availableModules.isEmpty) {
        throw const FormatException("匯入檔案沒有可辨識的模組。");
      }
      final loaded = await controller.loadProject(sourceFile);
      if (!mounted) return;
      if (FileService.isProjectVersionNewerThanSupported(
        loaded.projectVersion,
      )) {
        final proceed = await ProjectManager.showVersionCompatibilityDialog(
          context,
          fileVersion: loaded.projectVersion ?? "unknown",
          supportedVersion: FileService.projectVersion,
        );
        if (!mounted || !proceed) return;
      }

      final currentBeforeImport = _collectProjectData();
      final currentTrees = buildExportSelections(currentBeforeImport);
      final sourceTrees = buildExportSelections(loaded.data);
      int itemCount(
        Map<SelectiveProjectModule, List<ExportSelectionNode>> trees,
        SelectiveProjectModule module,
      ) =>
          trees[module]?.fold<int>(
            0,
            (count, root) => count + root.selectableKeys.length,
          ) ??
          0;
      final blocked = manifest.blockedReplacements(currentBeforeImport);
      final selected = <SelectiveProjectModule>{...manifest.availableModules}
        ..removeAll(manifest.partialModules);
      final importSession = _projectIoSession;
      final importRevision = _projectDataRevision;
      final chosen = await AppDialog.showCustom<Set<SelectiveProjectModule>>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, setDialogState) {
            SelectiveProjectImportResult? preview;
            if (selected.isNotEmpty) {
              preview = const SelectiveProjectImporter().apply(
                current: currentBeforeImport,
                source: loaded.data,
                manifest: manifest,
                selectedModules: selected,
                allowPartialReplacement: true,
              );
            }
            return HelpTarget(
              topicId: HelpTopicId.importFiles,
              child: AppDialog(
                title: context.l10n.uiImportModules,
                icon: Icons.input,
                content: SizedBox(
                  width: 560,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.uiSource(
                            (sourceFile.fullFileName).toString(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context
                              .l10n
                              .uiSelectedModulesReplaceTheCorrespondingDataInThis,
                        ),
                        if (manifest.partialModules.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            context
                                .l10n
                                .uiThisIsASelectiveExportImportingReplacesWhole,
                          ),
                          if (blocked.isNotEmpty)
                            Text(
                              context.l10n
                                  .uiIncludesRequiredAncestorsOrDependenciesImportIntoAn(
                                    (blocked
                                            .map(
                                              (m) => context.l10n.legacyLabel(
                                                m.label,
                                              ),
                                            )
                                            .join("、"))
                                        .toString(),
                                  ),
                            ),
                        ],
                        const SizedBox(height: 12),
                        for (final module in SelectiveProjectModule.values)
                          if (manifest.availableModules.contains(module))
                            CheckboxListTile(
                              key: Key("selective-import-${module.id}"),
                              title: Text(
                                "${context.l10n.legacyLabel(module.label)}${manifest.partialModules.contains(module) ? context.l10n.uiSelectiveContentReplacesTheEntireModule : ""}",
                              ),
                              subtitle: manifest.partialModules.contains(module)
                                  ? Text(
                                      context.l10n
                                          .uiCurrentAfterImportIncludingStructuralNodes(
                                            (itemCount(
                                              currentTrees,
                                              module,
                                            )).toString(),
                                            (itemCount(
                                              sourceTrees,
                                              module,
                                            )).toString(),
                                          ),
                                    )
                                  : null,
                              value: selected.contains(module),
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              onChanged: blocked.contains(module)
                                  ? null
                                  : (value) => setDialogState(() {
                                      if (value == true) {
                                        selected.add(module);
                                      } else {
                                        selected.remove(module);
                                      }
                                    }),
                            ),
                        if (preview != null && preview.warnings.isNotEmpty) ...[
                          const Divider(),
                          Text(
                            context.l10n.uiReferencesRequiringRepair(
                              context.formats.integer(preview.warnings.length),
                            ),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                          const SizedBox(height: 6),
                          for (final warning in preview.warnings)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.xs,
                              ),
                              child: Text("• ${warning.message}"),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(context.l10n.commonCancel),
                  ),
                  FilledButton(
                    key: const Key("selective-import-apply"),
                    onPressed: selected.isEmpty
                        ? null
                        : () => Navigator.of(
                            dialogContext,
                          ).pop(Set<SelectiveProjectModule>.from(selected)),
                    child: Text(context.l10n.uiApplyImport),
                  ),
                ],
              ),
            );
          },
        ),
      );
      if (!mounted || chosen == null) return;
      if (!_projectIoCoordinator.isCurrent(importSession) ||
          _projectDataRevision != importRevision) {
        _showError(
          context.l10n.uiTheWorkChangedDuringConfirmationStartTheImport,
        );
        return;
      }

      _recordProjectHistorySnapshot();
      final imported = const SelectiveProjectImporter().apply(
        current: currentBeforeImport,
        source: loaded.data,
        manifest: manifest,
        selectedModules: chosen,
        allowPartialReplacement: true,
      );
      final initialState = ref
          .read(editorCoordinatorProvider.notifier)
          .calculateInitialState(imported.data, _settingsState.wordCountMode);
      setState(() {
        _applyProjectData(
          imported.data,
          initialState,
          reopenCollaboration: false,
        );
      });
      _editorCoordinatorNotifier.markAsModified();
      _recordProjectHistorySnapshot();
      final warningSuffix = imported.warnings.isEmpty
          ? ""
          : context.l10n.uiReferencesRequiringRepair2(
              context.formats.integer(imported.warnings.length),
            );
      _showMessage(
        context.l10n.uiModulesImported(
          context.formats.integer(chosen.length),
          (warningSuffix).toString(),
        ),
      );
    } catch (error) {
      if (mounted) {
        _showError(
          context.l10n.uiImportFailed(context.l10n.projectError(error)),
        );
      }
    }
  }

  bool _exportDialogOpen = false;

  Future<void> _showExportDialog({
    ExportFormat initialFormat = ExportFormat.markdown,
  }) async {
    if (_exportDialogOpen) return;
    _exportDialogOpen = true;
    final session = _projectIoSession;
    try {
      _syncEditorToSelectedChapter();
      final data = _collectProjectData();
      buildExportSelections(data);
      final snapshot = snapshotProjectData(data);
      final fileName =
          currentProject?.nameWithoutExtension ?? "MonogatariExport";
      final result = await AppDialog.showCustom<ExportSaveResult>(
        context: context,
        barrierDismissible: false,
        builder: (_) => ProjectExportDialog(
          snapshot: snapshot,
          prepare: (request) =>
              compute(prepareProjectExport, (snapshot, request)),
          initialFormat: initialFormat,
          currentChapterId: selectedChapID,
          isCurrent: () => mounted && _projectIoCoordinator.isCurrent(session),
          save: (output) => ref
              .read(exportWriterProvider)
              .save(
                output,
                fileName,
                canWrite: () =>
                    mounted && _projectIoCoordinator.isCurrent(session),
              ),
        ),
      );
      if (!mounted || result?.status != ExportSaveStatus.saved) return;
      if (_projectIoCoordinator.isCurrent(session)) {
        _showMessage(
          context.l10n.uiExportComplete(
            (result!.destination ?? fileName).toString(),
          ),
        );
      }
    } catch (error) {
      if (mounted && _projectIoCoordinator.isCurrent(session)) {
        _showError(
          context.l10n.uiExportFailed(context.l10n.projectError(error)),
        );
      }
    } finally {
      _exportDialogOpen = false;
    }
  }

  // 插入文字到編輯器當前位置 (支援所有輸入框)
  void _insertText(String textToInsert) {
    var targetNode = WidgetsBinding.instance.focusManager.primaryFocus;
    EditableTextState? editable;

    // 1. 嘗試獲取當前焦點的 EditableTextState
    if (targetNode != null && targetNode.context != null) {
      editable = targetNode.context!
          .findAncestorStateOfType<EditableTextState>();
    }

    // 2. 如果當前焦點無效，嘗試使用最後一次的焦點
    if (editable == null) {
      if (_lastFocusedEditableNode != null &&
          _lastFocusedEditableNode!.context != null &&
          _lastFocusedEditableNode!.context!.mounted) {
        targetNode = _lastFocusedEditableNode;
        targetNode!.requestFocus();
        editable = targetNode.context!
            .findAncestorStateOfType<EditableTextState>();
      }
    }

    // 3. 執行插入
    if (editable != null) {
      final oldValue = editable.textEditingValue;
      final text = oldValue.text;
      final selection = oldValue.selection;

      String newText;
      int newSelectionIndex;

      if (selection.isValid && selection.start >= 0) {
        newText = text.replaceRange(
          selection.start,
          selection.end,
          textToInsert,
        );
        newSelectionIndex = selection.start + textToInsert.length;
      } else {
        newText = text + textToInsert;
        newSelectionIndex = newText.length;
      }

      editable.updateEditingValue(
        TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newSelectionIndex),
          composing: TextRange.empty,
        ),
      );

      // 確保焦點回到該輸入框
      if (targetNode != WidgetsBinding.instance.focusManager.primaryFocus) {
        targetNode!.requestFocus();
      }
    }
  }

  EditableTextState? _findEditableForFocusNode(FocusNode node) {
    final context = node.context;
    if (context == null || !context.mounted) {
      return null;
    }

    final ancestor = context.findAncestorStateOfType<EditableTextState>();
    if (ancestor != null && ancestor.widget.focusNode == node) {
      return ancestor;
    }

    EditableTextState? result;
    void visit(Element element) {
      if (result != null) {
        return;
      }

      if (element is StatefulElement) {
        final state = element.state;
        if (state is EditableTextState && state.widget.focusNode == node) {
          result = state;
          return;
        }
      }

      element.visitChildElements(visit);
    }

    (context as Element).visitChildElements(visit);
    return result;
  }

  EditableTextState? _getPrimaryFocusedEditable() {
    // 使用追蹤的最後一個有焦點的編輯框
    // 當按鈕被點擊時，焦點會移到按鈕，但我們需要操作在它之前有焦點的編輯框

    if (_lastFocusedEditableNode != null &&
        _lastFocusedEditableNode!.context != null &&
        _lastFocusedEditableNode!.context!.mounted) {
      debugPrint(
        "[DEBUG] Using last focused editable node: $_lastFocusedEditableNode",
      );
      final editable = _findEditableForFocusNode(_lastFocusedEditableNode!);
      if (editable != null) {
        return editable;
      }
    }

    debugPrint("[DEBUG] No last focused editable found");
    return null;
  }

  // 編輯器操作
  Future<void> _performEditorAction(String action) async {
    try {
      if (action == "undo") {
        _undoProjectHistory();
        return;
      }
      if (action == "redo") {
        _redoProjectHistory();
        return;
      }

      final quillCommands = PlainTextQuillEditorCommands.forFocusNode(
        _lastFocusedEditableNode,
      );
      if (quillCommands != null) {
        switch (action) {
          case "selectAll":
            quillCommands.selectAll();
            break;
          case "cut":
            await quillCommands.cut();
            break;
          case "copy":
            await quillCommands.copy();
            break;
          case "paste":
            await quillCommands.paste();
            break;
        }
        return;
      }

      final editable = _getPrimaryFocusedEditable();

      // Copy/Cut/Paste/Select All 只作用在目前取得焦點的輸入框。
      if (editable == null) {
        debugPrint("[DEBUG] No focused editable found");
        return;
      }

      final controller = editable.widget.controller;

      debugPrint("[DEBUG]: Performing action $action on controller");

      switch (action) {
        case "selectAll":
          _handleSelectAll(controller);
          break;
        case "cut":
          await _handleCut(controller, editable);
          break;
        case "copy":
          _handleCopy(controller);
          break;
        case "paste":
          await _handlePaste(controller, editable);
          break;
        case "find":
          // 實作搜尋功能
          break;
      }

      // 操作完後恢復焦點到編輯框
      final focusNode = editable.widget.focusNode;
      if (!focusNode.hasFocus) {
        debugPrint("[DEBUG] Restoring focus to editable after action");
        focusNode.requestFocus();
      }
    } finally {
      _finishEditorToolbarAction();
    }
  }

  /// 選擇所有文本
  void _handleSelectAll(TextEditingController controller) {
    final editable = _getPrimaryFocusedEditable();
    if (editable != null && editable.widget.controller == controller) {
      // 使用 updateEditingValue 確保 UI 正確更新
      editable.updateEditingValue(
        TextEditingValue(
          text: controller.text,
          selection: TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          ),
          composing: TextRange.empty,
        ),
      );
    } else {
      // 備用方案
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
    }
  }

  /// 複製選定的文本到剪貼簿
  void _handleCopy(TextEditingController controller) {
    final selection = controller.selection;
    debugPrint(
      "[DEBUG] Copy selection=$selection, isValid=${selection.isValid}, isCollapsed=${selection.isCollapsed}",
    );

    if (!selection.isValid || selection.isCollapsed) {
      debugPrint("[DEBUG] Copy No selection to copy");
      return; // 沒有選定任何文本
    }

    final selectedText = controller is MosaicEditingController
        ? controller.plainTextForSelection(selection)
        : controller.text.substring(selection.start, selection.end);
    debugPrint("[DEBUG] Copy: copying ${selectedText.length} UTF-16 units");
    Clipboard.setData(ClipboardData(text: selectedText));
  }

  /// 剪切選定的文本到剪貼簿
  Future<void> _handleCut(
    TextEditingController controller,
    EditableTextState editable,
  ) async {
    final selection = controller.selection;
    debugPrint(
      "[DEBUG] Cut selection=$selection, isValid=${selection.isValid}, isCollapsed=${selection.isCollapsed}",
    );

    if (!selection.isValid || selection.isCollapsed) {
      debugPrint("[DEBUG] Cut No selection to cut");
      return; // 沒有選定任何文本
    }

    final selectedText = controller is MosaicEditingController
        ? controller.plainTextForSelection(selection)
        : controller.text.substring(selection.start, selection.end);
    debugPrint("[DEBUG] Cut: cutting ${selectedText.length} UTF-16 units");
    await Clipboard.setData(ClipboardData(text: selectedText));

    // 刪除選定的文本
    final newText = controller.text.replaceRange(
      selection.start,
      selection.end,
      "",
    );

    // 使用 updateEditingValue 更新，確保 UI 正確更新
    editable.updateEditingValue(
      TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start),
        composing: TextRange.empty,
      ),
    );
    debugPrint("[DEBUG] Cut: resulting length=${newText.length}");
  }

  /// 從剪貼簿貼上文本
  Future<void> _handlePaste(
    TextEditingController controller,
    EditableTextState editable,
  ) async {
    debugPrint("[DEBUG] Paste Starting paste operation");
    try {
      final clipboardData = await Clipboard.getData("text/plain");
      final pastedText = clipboardData?.text ?? "";

      debugPrint(
        "[DEBUG] Paste: clipboard length=${pastedText.length} UTF-16 units",
      );

      if (pastedText.isEmpty) {
        debugPrint("[DEBUG] Paste Clipboard is empty");
        return; // 剪貼簿為空
      }

      final selection = controller.selection;
      debugPrint("[DEBUG] Paste: Current selection $selection");

      String newText;
      int newCursorPos;

      if (selection.isValid && !selection.isCollapsed) {
        // 如果有選定的文本，先替換它
        debugPrint("[DEBUG] Paste Replacing selected text");
        newText = controller.text.replaceRange(
          selection.start,
          selection.end,
          pastedText,
        );
        newCursorPos = selection.start + pastedText.length;
      } else {
        // 在游標位置插入文本
        debugPrint("[DEBUG] Paste Inserting at cursor position");
        final offset = selection.isValid
            ? _clampOffset(selection.baseOffset, controller.text.length)
            : controller.text.length;
        newText = controller.text.replaceRange(offset, offset, pastedText);
        newCursorPos = offset + pastedText.length;
      }

      // 使用 updateEditingValue 更新，確保 UI 正確更新
      editable.updateEditingValue(
        TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newCursorPos),
          composing: TextRange.empty,
        ),
      );
      debugPrint("[DEBUG] Paste: resulting length=${newText.length}");
    } catch (e) {
      debugPrint("[DEBUG] Paste failed: ${e.runtimeType}");
    }
  }

  // MARK: - 檔案操作

  // 變更追蹤和退出處理

  /// 標記內容已儲存
  void _markAsSaved() {
    _editorCoordinatorNotifier.markAsSaved();
  }

  /// 檢查是否有未儲存的變更
  bool _hasUnsavedChanges() {
    CharacterDraftSessionCoordinator.instance.flush(_projectSessionVersion);
    _syncEditorToSelectedChapter();
    return _editorCoordinatorNotifier.hasUnsavedChanges();
  }

  /// 處理退出請求
  Future<bool> _handleExit() async {
    final shouldExit = await ProjectManager.handleExit(
      context,
      showExitWarning: _settingsState.showExitWarning,
      hasUnsavedChanges: _hasUnsavedChanges(),
      onDontShowAgainChanged: (val) async => await ref
          .read(settingsStateProvider.notifier)
          .setShowExitWarning(!val),
      onSave: () async {
        await _saveProject();
        // Check if save successful (dirty flag cleared)
        if (_hasUnsavedChanges()) throw Exception("Save cancelled or failed");
      },
    );
    if (shouldExit) {
      final progress = ref.read(dailyWritingProgressProvider);
      final beforeDiscard = progress.checkpoint();
      final discarded = _hasUnsavedChanges();
      if (discarded) progress.discardUnsaved();
      try {
        await progress.flush();
      } catch (error) {
        if (discarded) progress.restoreCheckpoint(beforeDiscard);
        if (mounted) _showMessage("$error");
        return false;
      }
    }
    return shouldExit;
  }

  Future<bool> _requestExit() async {
    if (_isExitConfirmationInProgress) return false;

    _isExitConfirmationInProgress = true;
    try {
      return await _handleExit();
    } finally {
      _isExitConfirmationInProgress = false;
    }
  }

  // 檔案操作方法
  void _resetProjectSessionUiState() {
    final writingProgress = ref.read(dailyWritingProgressProvider);
    if (ref.read(editorCoordinatorProvider).hasUnsavedChanges) {
      writingProgress.discardUnsaved();
    }
    writingProgress.endSession();
    _hasUnpersistedRemoteDraft = false;
    CharacterDraftSessionCoordinator.instance.flushAndClose(
      _projectSessionVersion,
    );
    _projectSessionVersion++;
    _requestedCharacterId = null;
    _characterSelectionRequestId = 0;
    _requestedLocationId = null;
    _locationSelectionRequestId = 0;
    _requestedItemClassId = null;
    _itemSelectionRequestId = 0;
    _requestedPlanTargetId = null;
    _requestedPlanTargetKind = null;
    _planSelectionRequestId = 0;
    _lastFocusedEditableNode = null;
    _preserveEditableFocusForEditorAction = false;

    cancelFindAllMatches(textController);
    cancelReplaceAll(textController);
    findController.clear();
    replaceController.clear();
    _searchMatches = const <TextSelection>[];
    _currentMatchIndex = -1;
    textController.clearAllHighlights(notify: false);
    _quillSearchController.clear();
    showFindReplaceWindow = false;
  }

  Future<void> _newProject() async {
    if (_hasUnsavedChanges()) {
      final shouldProceed = await ProjectManager.showSaveConfirmDialog(
        context,
        title: context.l10n.uiCreateProject,
        message: context.l10n.uiYouHaveUnsavedChangesSaveBeforeCreatingA,
        onDontShowAgainChanged: (_) async {},
        onSave: _saveProject,
      );

      if (shouldProceed == null) {
        return;
      }
    }

    if (!mounted) {
      return;
    }

    _isProjectSwitching = true;
    final switchSession = _projectIoCoordinator.beginSession("switch:new");
    _projectIoSession = switchSession;
    try {
      final runResult = await _projectIoCoordinator.run(
        switchSession,
        () => ref.read(projectIoControllerProvider.notifier).createNewProject(),
      );
      final result = runResult.value;
      if (!mounted ||
          result == null ||
          !_projectIoCoordinator.isCurrent(switchSession)) {
        return;
      }

      final initialState = ref
          .read(editorCoordinatorProvider.notifier)
          .calculateInitialState(result.data, _settingsState.wordCountMode);

      setState(() {
        _resetProjectSessionUiState();
        currentProject = result.projectFile;
        _resetAutoBackupBaseline();
        _applyProjectData(result.data, initialState);
      });
      final activeProjectSession = _beginProjectIoSession(result.projectFile);
      _updateAllWordCounts();
      _showMessage(context.l10n.uiProjectCreated);
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || !_projectIoCoordinator.isCurrent(activeProjectSession)) {
        return;
      }
      _resetProjectHistory();
      _editorCoordinatorNotifier.resetAfterProjectLoaded();
    } catch (e) {
      if (mounted && _projectIoCoordinator.isCurrent(switchSession)) {
        _showError(
          context.l10n.uiCouldNotCreateTheProject(context.l10n.projectError(e)),
        );
        _beginProjectIoSession(currentProject);
      }
    } finally {
      if (_projectIoCoordinator.isCurrent(switchSession)) {
        _beginProjectIoSession(currentProject);
      }
      _isProjectSwitching = false;
    }
  }

  Future<void> _openProject() async {
    if (_hasUnsavedChanges()) {
      final shouldProceed = await ProjectManager.showSaveConfirmDialog(
        context,
        title: context.l10n.uiOpenProject,
        message: context.l10n.uiYouHaveUnsavedChangesSaveBeforeOpeningAnother,
        onDontShowAgainChanged: (_) async {},
        onSave: _saveProject,
      );
      if (shouldProceed == null) {
        return;
      }
    }

    if (!mounted) {
      return;
    }

    _isProjectSwitching = true;
    final switchSession = _projectIoCoordinator.beginSession("switch:open");
    _projectIoSession = switchSession;
    try {
      final runResult = await _projectIoCoordinator.run(
        switchSession,
        () async {
          final controller = ref.read(projectIoControllerProvider.notifier);
          final projectFile = await controller.pickProjectFile();
          return projectFile == null
              ? null
              : controller.loadProject(projectFile);
        },
      );
      final loadResult = runResult.value;
      if (!mounted || !_projectIoCoordinator.isCurrent(switchSession)) {
        return;
      }
      if (loadResult == null) {
        _beginProjectIoSession(currentProject);
        return;
      }
      final projectFile = loadResult.projectFile;
      final openedVersion = loadResult.projectVersion;
      final hasNewerVersion = FileService.isProjectVersionNewerThanSupported(
        openedVersion,
      );

      if (hasNewerVersion) {
        if (!mounted || !_projectIoCoordinator.isCurrent(switchSession)) {
          return;
        }
        final shouldContinue =
            await ProjectManager.showVersionCompatibilityDialog(
              context,
              fileVersion: openedVersion ?? "unknown",
              supportedVersion: FileService.projectVersion,
            );
        if (!mounted || !_projectIoCoordinator.isCurrent(switchSession)) {
          return;
        }
        if (!shouldContinue) {
          _showError(context.l10n.uiOpeningTheNewerFileWasCancelled);
          return;
        }
      }

      final data = loadResult.data;

      final initialState = ref
          .read(editorCoordinatorProvider.notifier)
          .calculateInitialState(data, _settingsState.wordCountMode);

      setState(() {
        _resetProjectSessionUiState();
        currentProject = projectFile;
        _resetAutoBackupBaseline();
        _applyProjectData(data, initialState);
      });
      final activeProjectSession = _beginProjectIoSession(projectFile);

      // Start the background count immediately after applying the project.
      // Persisting the recent-project entry can involve platform storage and
      // must not delay the visible total word count.
      _updateAllWordCounts();
      final migrationSuffix = loadResult.wasMigrated
          ? context.l10n.uiUpgradedToInMemoryWarnings(
              (FileService.projectVersion).toString(),
              context.formats.integer(loadResult.migrationWarnings.length),
            )
          : "";
      for (final warning in loadResult.migrationWarnings) {
        debugPrint(
          "Project migration warning [${warning.code}]: ${warning.message}",
        );
      }
      _showMessage(
        context.l10n.uiProjectOpened2(
          (projectFile.nameWithoutExtension).toString(),
          (migrationSuffix).toString(),
        ),
      );
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || !_projectIoCoordinator.isCurrent(activeProjectSession)) {
        return;
      }
      _resetProjectHistory();
      _editorCoordinatorNotifier.resetAfterProjectLoaded();

      await _ensureP2pBaselineForLoadedProject(
        loadResult,
        activeProjectSession,
      );
      if (!mounted || !_projectIoCoordinator.isCurrent(activeProjectSession)) {
        return;
      }

      await _editorCoordinatorNotifier.recordRecentProject(projectFile);
      if (!mounted || !_projectIoCoordinator.isCurrent(activeProjectSession)) {
        return;
      }
    } catch (e) {
      if (mounted && _projectIoCoordinator.isCurrent(switchSession)) {
        _showError(
          context.l10n.uiCouldNotOpenTheProject(context.l10n.projectError(e)),
        );
        _beginProjectIoSession(currentProject);
      }
    } finally {
      if (_projectIoCoordinator.isCurrent(switchSession)) {
        _beginProjectIoSession(currentProject);
      }
      _isProjectSwitching = false;
    }
  }

  Future<void> _openProjectFromDesktop(String filePath) async {
    final normalizedPath = filePath.trim();
    if (normalizedPath.isEmpty) {
      return;
    }

    const projectPayloadPrefix = "MNPROJ_PAYLOAD::";
    if (normalizedPath.startsWith(projectPayloadPrefix)) {
      try {
        final decoded = jsonDecode(
          normalizedPath.substring(projectPayloadPrefix.length),
        );
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException("Invalid project payload");
        }
        final rawContent = decoded["content"];
        if (rawContent is! String || rawContent.isEmpty) {
          throw const FormatException("Project payload has no content");
        }
        final rawPath = decoded["path"];
        final rawName = decoded["name"];
        final rawBookmark = decoded["bookmark"];
        final path = rawPath is String && rawPath.trim().isNotEmpty
            ? rawPath.trim()
            : null;
        final bookmark = rawBookmark is String && rawBookmark.trim().isNotEmpty
            ? rawBookmark.trim()
            : null;
        final fileName = rawName is String && rawName.trim().isNotEmpty
            ? rawName.trim()
            : (path == null
                  ? context.l10n.uiUntitledMnproj
                  : path.split(RegExp(r"[/\\]")).last);

        await _openRecentProject(
          RecentProjectEntry(
            fileName: fileName,
            filePath: path,
            uri: bookmark,
            lastOpenedAtMillis: DateTime.now().millisecondsSinceEpoch,
          ),
          launchedExternally: true,
          projectFileLoader: (_) async => ProjectFile(
            fileName: fileName,
            filePath: path,
            uri: bookmark,
            content: rawContent,
          ),
        );
      } catch (e) {
        _showError(
          context.l10n.uiCouldNotOpenTheProject(context.l10n.projectError(e)),
        );
      }
      return;
    }

    // Bookmark payload from native: BKMK::<base64Bookmark>::PATH::<originalPath>
    if (normalizedPath.startsWith("BKMK::")) {
      try {
        final marker = "BKMK::";
        final sep = "::PATH::";
        final rest = normalizedPath.substring(marker.length);
        final idx = rest.indexOf(sep);
        final bookmark = idx >= 0 ? rest.substring(0, idx) : rest;
        final origPath = idx >= 0 ? rest.substring(idx + sep.length) : "";
        final parts = origPath.split(RegExp(r"[/\\]"));
        final fileName = parts.isEmpty || parts.last.isEmpty
            ? context.l10n.uiUntitledMnproj
            : parts.last;

        await _openRecentProject(
          RecentProjectEntry(
            fileName: fileName,
            filePath: origPath.isNotEmpty ? origPath : null,
            uri: bookmark,
            lastOpenedAtMillis: DateTime.now().millisecondsSinceEpoch,
          ),
          launchedExternally: true,
          projectFileLoader: (_) =>
              FileService.openProjectFromSecurityScopedBookmark(bookmark),
        );
      } catch (e) {
        _showError(
          context.l10n.uiCouldNotOpenTheProject(context.l10n.projectError(e)),
        );
      }
      return;
    }
    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        (normalizedPath.startsWith("content://") ||
            normalizedPath.startsWith("file://"))) {
      await _openProjectFromAndroidUri(normalizedPath);
      return;
    }
    final parts = normalizedPath.split(RegExp(r"[/\\]"));
    final fileName = parts.isEmpty || parts.last.isEmpty
        ? context.l10n.uiUntitledMnproj
        : parts.last;
    final accessToken = await FileService.createPersistentAccessToken(
      normalizedPath,
    );
    await _openRecentProject(
      RecentProjectEntry(
        fileName: fileName,
        filePath: normalizedPath,
        uri: accessToken,
        lastOpenedAtMillis: DateTime.now().millisecondsSinceEpoch,
      ),
      launchedExternally: true,
    );
  }

  Future<void> _openProjectFromAndroidUri(String uri) async {
    await _openRecentProject(
      RecentProjectEntry(
        fileName: context.l10n.uiExternalProjectMnproj,
        uri: uri,
        lastOpenedAtMillis: DateTime.now().millisecondsSinceEpoch,
      ),
      launchedExternally: true,
      projectFileLoader: (controller) =>
          controller.openProjectFromExternalUri(uri),
    );
  }

  Future<void> _openRecentProject(
    RecentProjectEntry entry, {
    bool launchedExternally = false,
    Future<ProjectFile> Function(ProjectIoController controller)?
    projectFileLoader,
  }) async {
    if (projectFileLoader == null &&
        (!entry.canReopen || entry.filePath == null)) {
      _showError(context.l10n.uiThisRecentFileHasNoUsableLocalPath);
      return;
    }

    if (_hasUnsavedChanges()) {
      final shouldProceed = await ProjectManager.showSaveConfirmDialog(
        context,
        title: launchedExternally
            ? context.l10n.uiOpenProject
            : context.l10n.uiOpenRecentProject,
        message: launchedExternally
            ? context.l10n.uiYouHaveUnsavedChangesSaveBeforeOpeningAnother
            : context.l10n.uiYouHaveUnsavedChangesSaveBeforeOpeningA,
        onDontShowAgainChanged: (_) async {},
        onSave: _saveProject,
      );
      if (shouldProceed == null) {
        return;
      }
    }

    if (!mounted) {
      return;
    }

    _isProjectSwitching = true;
    final switchSession = _projectIoCoordinator.beginSession(
      launchedExternally ? "switch:external" : "switch:recent",
    );
    _projectIoSession = switchSession;
    try {
      final runResult = await _projectIoCoordinator.run(
        switchSession,
        () async {
          final controller = ref.read(projectIoControllerProvider.notifier);
          final projectFile = projectFileLoader != null
              ? await projectFileLoader(controller)
              : await controller.openProjectFromPath(
                  entry.filePath!,
                  accessToken: entry.uri,
                );
          return controller.loadProject(projectFile);
        },
      );
      final loadResult = runResult.value;
      if (!mounted ||
          loadResult == null ||
          !_projectIoCoordinator.isCurrent(switchSession)) {
        return;
      }
      final projectFile = loadResult.projectFile;
      final openedVersion = loadResult.projectVersion;
      final hasNewerVersion = FileService.isProjectVersionNewerThanSupported(
        openedVersion,
      );

      if (hasNewerVersion) {
        if (!mounted || !_projectIoCoordinator.isCurrent(switchSession)) {
          return;
        }
        final shouldContinue =
            await ProjectManager.showVersionCompatibilityDialog(
              context,
              fileVersion: openedVersion ?? "unknown",
              supportedVersion: FileService.projectVersion,
            );
        if (!mounted || !_projectIoCoordinator.isCurrent(switchSession)) {
          return;
        }
        if (!shouldContinue) {
          _showError(context.l10n.uiOpeningTheNewerFileWasCancelled);
          return;
        }
      }

      final data = loadResult.data;

      final initialState = ref
          .read(editorCoordinatorProvider.notifier)
          .calculateInitialState(data, _settingsState.wordCountMode);

      setState(() {
        _resetProjectSessionUiState();
        currentProject = projectFile;
        _resetAutoBackupBaseline();
        _applyProjectData(data, initialState);
      });
      final activeProjectSession = _beginProjectIoSession(projectFile);

      // Keep word-count refresh independent from recent-project persistence.
      _updateAllWordCounts();
      final migrationSuffix = loadResult.wasMigrated
          ? context.l10n.uiUpgradedToInMemoryWarnings(
              (FileService.projectVersion).toString(),
              context.formats.integer(loadResult.migrationWarnings.length),
            )
          : "";
      for (final warning in loadResult.migrationWarnings) {
        debugPrint(
          "Project migration warning [${warning.code}]: ${warning.message}",
        );
      }
      _showMessage(
        context.l10n.uiProjectOpened2(
          (projectFile.nameWithoutExtension).toString(),
          (migrationSuffix).toString(),
        ),
      );
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || !_projectIoCoordinator.isCurrent(activeProjectSession)) {
        return;
      }
      _resetProjectHistory();
      _editorCoordinatorNotifier.resetAfterProjectLoaded();

      await _ensureP2pBaselineForLoadedProject(
        loadResult,
        activeProjectSession,
      );
      if (!mounted || !_projectIoCoordinator.isCurrent(activeProjectSession)) {
        return;
      }

      await _editorCoordinatorNotifier.recordRecentProject(projectFile);
      if (!mounted || !_projectIoCoordinator.isCurrent(activeProjectSession)) {
        return;
      }
    } catch (e) {
      if (mounted && _projectIoCoordinator.isCurrent(switchSession)) {
        final message = e.toString();
        _showError(
          context.l10n.uiFailed(
            (launchedExternally
                    ? context.l10n.uiOpenProject
                    : context.l10n.uiOpenRecentProject)
                .toString(),
            context.l10n.projectError(e),
          ),
        );
        if (projectFileLoader == null &&
            !launchedExternally &&
            message.contains("檔案不存在")) {
          unawaited(
            ref.read(settingsStateProvider.notifier).removeRecentProject(entry),
          );
        }
        _beginProjectIoSession(currentProject);
      }
    } finally {
      if (_projectIoCoordinator.isCurrent(switchSession)) {
        _beginProjectIoSession(currentProject);
      }
      _isProjectSwitching = false;
    }
  }

  Future<void> _deleteRecentProject(RecentProjectEntry entry) async {
    await ref.read(settingsStateProvider.notifier).removeRecentProject(entry);
    if (!mounted) return;
    _showMessage(
      context.l10n.uiRemovedFromRecentProjects((entry.fileName).toString()),
    );
  }

  Future<void> _saveProject() async {
    if (_isProjectSwitching) return;
    _syncEditorToSelectedChapter();
    final session = _projectIoSession;
    final revision = _projectDataRevision;
    final currentData = _collectProjectData();
    final savedProgressPosition = ref
        .read(dailyWritingProgressProvider)
        .checkpoint();
    ProjectIoPayload? persistedPayload;

    try {
      final runResult = await _projectIoCoordinator.run(session, () async {
        final payload = await _sharedProjectIoPayload(
          session: session,
          revision: revision,
          data: currentData,
        );
        persistedPayload = payload;
        return ref
            .read(projectIoControllerProvider.notifier)
            .saveProject(
              currentProject: currentProject,
              currentData: currentData,
              forceSaveAs: false,
              preparedPayload: payload,
            );
      });
      final savedProject = runResult.value;
      if (!mounted ||
          savedProject == null ||
          !_projectIoCoordinator.isCurrent(session)) {
        return;
      }
      setState(() => currentProject = savedProject);
      _hasUnpersistedRemoteDraft = false;
      if (_projectDataRevision == revision) {
        _markAsSaved();
      }
      if (_projectIdentity(savedProject) != session.projectIdentity) {
        _beginProjectIoSession(savedProject);
      }
      ref
          .read(dailyWritingProgressProvider)
          .markSaved(position: savedProgressPosition);
      await _recordP2pPersistedRevision(persistedPayload);
      await _editorCoordinatorNotifier.recordRecentProject(savedProject);
      if (!mounted) {
        return;
      }
      _showMessage(context.l10n.uiProjectSaved);
    } catch (e) {
      _showError(
        context.l10n.uiCouldNotSaveTheProject(context.l10n.projectError(e)),
      );
    }
  }

  Future<void> _saveProjectAs() async {
    if (_isProjectSwitching) return;
    _syncEditorToSelectedChapter();
    final session = _projectIoSession;
    final revision = _projectDataRevision;
    final currentData = _collectProjectData();
    final savedProgressPosition = ref
        .read(dailyWritingProgressProvider)
        .checkpoint();
    ProjectIoPayload? saveAsPayload;

    try {
      final runResult = await _projectIoCoordinator.run(session, () async {
        final payload = await ref
            .read(projectIoControllerProvider.notifier)
            .prepareProjectPayload(
              currentData,
              regenerateProjectUuid: shouldRegenerateProjectUuidForSaveAs(
                currentProject,
              ),
            );
        saveAsPayload = payload;
        return ref
            .read(projectIoControllerProvider.notifier)
            .saveProject(
              currentProject: currentProject,
              currentData: currentData,
              forceSaveAs: true,
              preparedPayload: payload,
            );
      });
      final savedProject = runResult.value;
      if (!mounted ||
          savedProject == null ||
          !_projectIoCoordinator.isCurrent(session)) {
        return;
      }
      setState(() => currentProject = savedProject);
      _hasUnpersistedRemoteDraft = false;
      final adoptedProjectUuid = saveAsPayload?.snapshot.projectUUID;
      if (adoptedProjectUuid != null) {
        final beganApplying = _editorCoordinatorNotifier
            .beginApplyingProjectData();
        ref
            .read(projectUuidProvider.notifier)
            .setProjectUuid(adoptedProjectUuid);
        ref
            .read(dailyWritingProgressProvider)
            .adoptProjectIdentity(adoptedProjectUuid);
        if (beganApplying) {
          _editorCoordinatorNotifier.endApplyingProjectData();
        }
      }
      if (_projectDataRevision == revision) {
        _markAsSaved();
      } else {
        _editorCoordinatorNotifier.markAsModified();
      }
      _beginProjectIoSession(savedProject);
      ref
          .read(dailyWritingProgressProvider)
          .markSaved(position: savedProgressPosition);
      await _recordP2pPersistedRevision(saveAsPayload);
      await _editorCoordinatorNotifier.recordRecentProject(savedProject);
      if (!mounted) {
        return;
      }
      _showMessage(
        context.l10n.uiProjectSavedAs(
          (savedProject.nameWithoutExtension).toString(),
        ),
      );
    } catch (e) {
      _showError(
        context.l10n.uiCouldNotSaveTheProjectAsANew(
          context.l10n.projectError(e),
        ),
      );
    }
  }

  Future<void> _exportAs(String extension) => _showExportDialog(
    initialFormat: extension == "txt"
        ? ExportFormat.txt
        : ExportFormat.markdown,
  );

  // 同步編輯器內容到選中的章節（先存的部分）
  void _syncEditorToSelectedChapter() {
    _flushPendingEditorContent();
    ref
        .read(editorCoordinatorProvider.notifier)
        .syncEditorToSelectedChapter(
          textController: textController,
          authoritativeText: textController.rawText,
        );
  }

  // 輔助方法：收集當前專案數據
  ProjectData _collectProjectData() {
    CharacterDraftSessionCoordinator.instance.flush(_projectSessionVersion);
    _flushPendingEditorContent();
    return ref.read(editorCoordinatorProvider.notifier).collectProjectData();
  }

  // 輔助方法：應用專案數據到狀態 (改為接收預先計算的狀態)
  void _applyProjectData(
    ProjectData data,
    EditorProjectInitialState initialState, {
    bool reopenCollaboration = true,
  }) {
    _cancelPendingContentCommit();
    _suppressRevisionDirty = true;
    if (!_isApplyingProjectHistory) {
      ref.read(revisionTrackingProvider.notifier).stop();
    }
    final coordinatorNotifier = ref.read(editorCoordinatorProvider.notifier);
    final beganApplying = coordinatorNotifier.beginApplyingProjectData();
    final String? previousSelectedChapID = selectedChapID;

    coordinatorNotifier.applyProjectData(
      data: data,
      initialState: initialState,
    );
    if (!_isApplyingProjectHistory) {
      ref
          .read(revisionTrackingProvider.notifier)
          .restore(data.revisionTrackingJson, projectId: data.projectUUID);
    }
    if (reopenCollaboration) {
      ref.read(collaborationProvider.notifier).openProject(data);
    }

    if (previousSelectedChapID != selectedChapID) {
      _proofreadingChapterSwitchVersion++;
    }

    final bool beganSync = coordinatorNotifier.beginSync();
    try {
      if (initialState.hasSelection) {
        textController.setRawText(
          contentText,
          rawSelection: TextSelection.collapsed(
            offset: _clampOffset(initialState.cursorOffset, contentText.length),
          ),
        );
      } else {
        textController.setRawText("");
      }
      _lastObservedEditorText = textController.rawText;
    } finally {
      if (beganSync) {
        coordinatorNotifier.endSync();
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (beganApplying) {
        coordinatorNotifier.endApplyingProjectData();
      }
      _suppressRevisionDirty = false;
    });

    _refreshActiveChapterWordCount();

    // Force rebuild of all modules by using keys or ensuring state update
    // Note: Since we are replacing the data objects, didUpdateWidget in children should trigger
  }

  // 訊息處理
  void _showError(String message) {
    _editorCoordinatorNotifier.pushError(message);
  }

  void _showMessage(String message) {
    _editorCoordinatorNotifier.pushMessage(message);
  }
}

/************************************************
誰偷了我的芳文人生==

為什麼我已經17歲了，
還沒有加入輕音部，
沒有轉學到天宮女學院，也沒有加入漫畫咖啡廳「刺蝟」，
沒有加入情報處理部，
沒有從英國來的金髮蘿莉來我們學校交換，
沒有在轉學後在路邊睡著遇到同校的露營專家，
沒有來到RPG不動產，
沒有考上天之御船學園幸福班，
沒有遇到對夜來舞有興趣的如妖精般的外國人，
沒有去Rabbit House打工，
沒有人跟我約定一起找小行星，也沒有加入地學部，
沒有遇見自稱外星人的神秘新生，
沒有在因緣際會下去角色扮演咖啡廳當抖S，
沒有考上美術班，
沒有在文芳社當4コマ家，
進了板中資訊社發現這裡沒有做同人遊戲的SNS部==
************************************************/
