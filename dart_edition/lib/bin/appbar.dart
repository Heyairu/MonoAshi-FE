// Copyright 2025-2026 Heyairu（部屋伊琉）
// Licensed under the Apache License, Version 2.0.
// https://www.apache.org/licenses/LICENSE-2.0

import 'package:monogatari_assistant/l10n/app_localization.dart';
import '../l10n/ribbon_localizations_adapter.dart';
import "../features/help/help_controller.dart";
import "../features/help/help_scope.dart";
import "../features/help/help_topic.dart";
import "dart:developer" as developer;

import "package:flutter/material.dart";
import "package:material_ribbon/material_ribbon.dart";

import "../models/toolbar_mode.dart";
import "findreplace.dart";

/// Three presentations sharing commands, editor targets, and project history.
class MonogatariTopAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final ValueChanged<String>? onHelpAction;
  final Widget? moduleSwitcher;
  final double iconSize;
  final ToolbarMode mode;
  final ToolbarMode? modePreference;
  final ValueChanged<ToolbarMode?> onModeChanged;
  final Widget? statusIndicator;
  final bool isProjectIoBusy;
  final bool showPunctuationPanel;
  final bool showFindReplaceWindow;
  final Future<void> Function(String) onFileAction;
  final Future<void> Function(String) onEditorAction;
  final VoidCallback onEditorActionPointerDown;
  final VoidCallback onEditorActionInteractionEnd;
  final VoidCallback onTogglePunctuationPanel;
  final VoidCallback onToggleFindReplaceWindow;
  final RibbonController? controller;
  final FindReplaceOptions? searchOptions;
  final String searchQuery;
  final ValueChanged<FindReplaceOption>? onSearchOptionChanged;
  final bool showNavigation;
  final bool showSidebar;
  final bool showDashboard;
  final VoidCallback? onToggleNavigation;
  final VoidCallback? onToggleSidebar;
  final VoidCallback? onToggleDashboard;
  final Future<void> Function()? onOpenPhraseLibrary;
  final Future<void> Function()? onInsertPhrase;
  final VoidCallback? onSaveSelectionAsPhrase;

  const MonogatariTopAppBar({
    super.key,
    this.onHelpAction,
    this.moduleSwitcher,
    required this.iconSize,
    required this.mode,
    required this.modePreference,
    required this.onModeChanged,
    this.statusIndicator,
    this.isProjectIoBusy = false,
    required this.showPunctuationPanel,
    required this.showFindReplaceWindow,
    required this.onFileAction,
    required this.onEditorAction,
    required this.onEditorActionPointerDown,
    required this.onEditorActionInteractionEnd,
    required this.onTogglePunctuationPanel,
    required this.onToggleFindReplaceWindow,
    this.controller,
    this.searchOptions,
    this.searchQuery = "",
    this.onSearchOptionChanged,
    this.showNavigation = true,
    this.showSidebar = true,
    this.showDashboard = true,
    this.onToggleNavigation,
    this.onToggleSidebar,
    this.onToggleDashboard,
    this.onOpenPhraseLibrary,
    this.onInsertPhrase,
    this.onSaveSelectionAsPhrase,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(mode == ToolbarMode.full ? 210 : 108);

  @override
  State<MonogatariTopAppBar> createState() => MonogatariTopAppBarState();
}

class MonogatariTopAppBarState extends State<MonogatariTopAppBar> {
  static const _ribbonContext = RibbonContext();
  static const _fileIds = [
    "save",
    "new",
    "open",
    "saveAs",
    "import_selective",
    "export_selective",
  ];
  static const _editIds = ["selectAll", "cut", "copy", "paste"];
  final _running = <String>{};
  final _keyTips = RibbonKeyTipController();
  bool get ownsMenuFocus => _menuOpen;

  void dismissKeyTips() => _keyTips.hide();

  void selectRelativeTab(int delta) {
    final ids = _tabs(_commands).map((tab) => tab.id).toList();
    final id = ids[(ids.indexOf(_selectedTabId) + delta) % ids.length];
    selectTabForNavigation(id);
  }

  void selectTabForNavigation(String id) {
    _keyTips.hide();
    _selectTab(id, openSearch: false);
    widget.controller?.selectTab(id, requestFocus: false);
  }

  final _scrollController = ScrollController();
  bool _menuOpen = false;
  String _selectedTabId = "home";
  final _defaultSearchOptions = FindReplaceOptions();

  @override
  void initState() {
    super.initState();
    if (widget.showFindReplaceWindow) _selectedTabId = "search";
  }

  @override
  void didUpdateWidget(covariant MonogatariTopAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.showFindReplaceWindow && widget.showFindReplaceWindow) {
      _selectTab("search");
    }
  }

  @override
  void dispose() {
    _keyTips.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _openMenu() {
    _menuOpen = true;
    widget.onEditorActionPointerDown();
  }

  void _endInteraction() {
    // Pointer-up reaches this listener before PopupMenuButton.onOpened.
    // Wait until the menu has claimed focus before releasing the editor target.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_menuOpen) widget.onEditorActionInteractionEnd();
    });
  }

  void _closeMenu() {
    _menuOpen = false;
    _endInteraction();
  }

  Map<String, RibbonCommand> get _commands {
    RibbonCommand command(
      String id,
      String label,
      IconData icon, {
      bool? selected,
      bool enabled = true,
      String? disabledReason,
      RibbonCommandSize size = RibbonCommandSize.medium,
    }) => RibbonCommand(
      id: id,
      label: label,
      icon: icon,
      size: size,
      type: selected == null
          ? RibbonCommandType.action
          : RibbonCommandType.toggle,
      checkState: (_) => selected == true
          ? RibbonCheckState.checked
          : RibbonCheckState.unchecked,
      isEnabled: (_) =>
          enabled &&
          (!_fileIds.contains(id) ||
              (!widget.isProjectIoBusy && !_running.any(_fileIds.contains))),
      disabledReason: (_) => disabledReason,
      isBusy: (_) => _running.contains(id),
      onInvoked: (event) => _invoke(event.commandId),
    );
    final commands = [
      command(
        "save",
        context.l10n.uiSaveFile,
        Icons.save_outlined,
        size: RibbonCommandSize.large,
      ),
      command("new", context.l10n.uiNewFile, Icons.note_add_outlined),
      command("open", context.l10n.uiOpenFile, Icons.folder_open_outlined),
      command("saveAs", context.l10n.uiSaveAs, Icons.save_as_outlined),
      command("import_selective", context.l10n.uiImport, Icons.input),
      command("export_selective", context.l10n.uiExport, Icons.output),
      command("selectAll", context.l10n.editorSelectAll, Icons.select_all),
      command("cut", context.l10n.editorCut, Icons.content_cut),
      command("copy", context.l10n.commonCopy, Icons.content_copy),
      command(
        "paste",
        context.l10n.editorPaste,
        Icons.content_paste,
        size: RibbonCommandSize.large,
      ),
      command("undo", context.l10n.editorUndo, Icons.undo),
      command("redo", context.l10n.editorRedo, Icons.redo),
      command(
        "phrases.library",
        context.l10n.uiPhraseLibrary,
        Icons.library_books_outlined,
        enabled: widget.onOpenPhraseLibrary != null,
        size: RibbonCommandSize.large,
      ),
      command(
        "phrases.insert",
        context.l10n.uiInsertPhrase,
        Icons.add_comment_outlined,
        enabled: widget.onInsertPhrase != null,
        disabledReason: widget.onInsertPhrase == null
            ? context.l10n.uiOpenTheManuscriptEditorFirst
            : null,
      ),
      command(
        "phrases.saveSelection",
        context.l10n.uiSaveSelectionAsPhrase,
        Icons.bookmark_add_outlined,
        enabled: widget.onSaveSelectionAsPhrase != null,
        disabledReason: widget.onSaveSelectionAsPhrase == null
            ? context.l10n.uiOpenTheManuscriptEditorFirst
            : null,
      ),
      command(
        "punctuation",
        context.l10n.uiPunctuation,
        Icons.keyboard_alt_outlined,
        selected: widget.showPunctuationPanel,
      ),
      command(
        "find",
        context.l10n.uiSearch,
        Icons.search,
        selected: widget.showFindReplaceWindow,
      ),
      command(
        "view.navigation",
        context.l10n.uiNavigation,
        Icons.navigation_outlined,
        selected: widget.showNavigation,
        enabled: widget.onToggleNavigation != null,
      ),
      command(
        "view.sidebar",
        context.l10n.uiSidebar,
        Icons.view_sidebar_outlined,
        selected: widget.showSidebar,
        enabled: widget.onToggleSidebar != null,
      ),
      command(
        "view.dashboard",
        context.l10n.uiDashboard,
        Icons.speed_rounded,
        selected: widget.showDashboard,
        enabled: widget.onToggleDashboard != null,
      ),
    ];
    final options = widget.searchOptions ?? _defaultSearchOptions;
    for (final (option, label, icon) in [
      (
        FindReplaceOption.matchCase,
        context.l10n.uiMatchCase,
        Icons.text_fields,
      ),
      (
        FindReplaceOption.wholeWord,
        context.l10n.uiWholeWords,
        Icons.text_format,
      ),
      (
        FindReplaceOption.useRegexp,
        context.l10n.uiRegularExpression,
        Icons.data_object,
      ),
      (
        FindReplaceOption.matchWidth,
        context.l10n.uiMatchCharacterWidth,
        Icons.width_normal,
      ),
      (
        FindReplaceOption.ignorePunctuation,
        context.l10n.uiIgnorePunctuation,
        Icons.format_quote,
      ),
      (
        FindReplaceOption.ignoreWhitespace,
        context.l10n.uiIgnoreWhitespace,
        Icons.space_bar,
      ),
    ]) {
      final enabled = options.enabledFor(option, widget.searchQuery);
      commands.add(
        command(
          "search.${option.name}",
          label,
          icon,
          selected: options.valueFor(option),
          enabled: enabled && widget.onSearchOptionChanged != null,
          disabledReason: enabled
              ? null
              : options.useRegexp
              ? context
                    .l10n
                    .uiRegularExpressionsAlwaysMatchCaseAndCharacterWidth
              : context.l10n.uiWholeWordMatchingIsUnavailableWhenTheQuery,
        ),
      );
    }
    return {for (final command in commands) command.id: command};
  }

  /// Validate again when executing, regardless of the presentation or KeyTip.
  Future<void> _invoke(String id) async {
    final command = _commands[id];
    if (command == null ||
        !command.enabledFor(_ribbonContext) ||
        command.busyFor(_ribbonContext)) {
      return;
    }
    setState(() => _running.add(id));
    try {
      if (_fileIds.contains(id)) {
        await widget.onFileAction(id);
      } else if (_editIds.contains(id) || id == "undo" || id == "redo") {
        await widget.onEditorAction(id);
      } else if (id == "punctuation") {
        widget.onTogglePunctuationPanel();
      } else if (id == "find") {
        widget.onToggleFindReplaceWindow();
      } else if (id == "view.navigation") {
        widget.onToggleNavigation?.call();
      } else if (id == "view.sidebar") {
        widget.onToggleSidebar?.call();
      } else if (id == "view.dashboard") {
        widget.onToggleDashboard?.call();
      } else if (id == "phrases.library") {
        await widget.onOpenPhraseLibrary?.call();
      } else if (id == "phrases.insert") {
        await widget.onInsertPhrase?.call();
      } else if (id == "phrases.saveSelection") {
        widget.onSaveSelectionAsPhrase?.call();
      } else if (id.startsWith("search.")) {
        final option = FindReplaceOption.values.firstWhere(
          (option) => id == "search.${option.name}",
        );
        widget.onSearchOptionChanged?.call(option);
      }
    } catch (error, stackTrace) {
      developer.log(
        "Toolbar command failed: $id",
        name: "MonoAshi.Toolbar",
        error: error,
        stackTrace: stackTrace,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.uiCouldNotCompletePleaseTryAgain(
                (command.label).toString(),
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _running.remove(id));
      _endInteraction();
    }
  }

  List<RibbonTab> _tabs(Map<String, RibbonCommand> commands) => [
    RibbonTab(
      id: "file",
      label: context.l10n.uiFile,
      keyTip: "F",
      groups: [
        RibbonGroup(
          id: "project",
          label: context.l10n.uiProject,
          rows: 3,
          commands: [
            for (final id
                in widget.mode == ToolbarMode.full
                    ? ["save", "new", "open", "saveAs"]
                    : ["new", "open", "save", "saveAs"])
              commands[id]!,
          ],
        ),
        RibbonGroup(
          id: "transfer",
          label: context.l10n.uiDataExchange,
          commands: [
            commands["import_selective"]!,
            commands["export_selective"]!,
          ],
        ),
      ],
    ),
    RibbonTab(
      id: "home",
      label: context.l10n.uiHome,
      keyTip: "H",
      groups: [
        RibbonGroup(
          id: "clipboard",
          label: context.l10n.uiClipboard,
          rows: 3,
          commands: [
            for (final id in ["paste", "cut", "copy", "selectAll"])
              commands[id]!,
          ],
        ),
        RibbonGroup(
          id: "history",
          label: context.l10n.uiHistory,
          commands: [commands["undo"]!, commands["redo"]!],
        ),
        RibbonGroup(
          id: "tools",
          label: context.l10n.uiWritingTools,
          commands: [commands["punctuation"]!, commands["find"]!],
        ),
        RibbonGroup(
          id: "phrases",
          label: context.l10n.uiPhrases,
          commands: [
            commands["phrases.library"]!,
            commands["phrases.insert"]!,
            commands["phrases.saveSelection"]!,
          ],
        ),
        RibbonGroup(
          id: "display-blocks",
          label: context.l10n.uiWorkspacePanels,
          rows: 3,
          commands: [
            commands["view.navigation"]!,
            commands["view.sidebar"]!,
            commands["view.dashboard"]!,
          ],
        ),
      ],
    ),
    RibbonTab(
      id: "search",
      label: context.l10n.uiSearch,
      keyTip: "S",
      groups: [
        RibbonGroup(
          id: "search-panel",
          label: context.l10n.uiFindAndReplace,
          commands: [commands["find"]!],
        ),
        RibbonGroup(
          id: "search-match",
          label: context.l10n.uiMatchOptions,
          rows: 3,
          commands: [
            for (final option in [
              FindReplaceOption.matchCase,
              FindReplaceOption.wholeWord,
              FindReplaceOption.matchWidth,
            ])
              commands["search.${option.name}"]!,
          ],
        ),
        RibbonGroup(
          id: "search-mode",
          label: context.l10n.uiSearchMethod,
          rows: 3,
          commands: [
            for (final option in [
              FindReplaceOption.useRegexp,
              FindReplaceOption.ignorePunctuation,
              FindReplaceOption.ignoreWhitespace,
            ])
              commands["search.${option.name}"]!,
          ],
        ),
      ],
    ),
  ];

  void _selectTab(String id, {bool openSearch = true}) {
    if (_selectedTabId == id) return;
    setState(() => _selectedTabId = id);
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
    if (openSearch && id == "search" && !widget.showFindReplaceWindow) {
      widget.onToggleFindReplaceWindow();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.controller?.scrollToTab(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final commands = _commands;
    final tabs = _tabs(commands);
    final selectedTab = tabs.firstWhere((tab) => tab.id == _selectedTabId);
    final full = widget.mode == ToolbarMode.full;
    return HelpScope(
      topicId: HelpTopicId.toolbar,
      child: Listener(
        onPointerDown: (_) => widget.onEditorActionPointerDown(),
        onPointerUp: (_) => _endInteraction(),
        onPointerCancel: (_) => _endInteraction(),
        child: SafeArea(
          bottom: false,
          child: Material(
            key: Key("toolbar-${widget.mode.name}"),
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MaterialRibbon(
                  key: const Key("toolbar-ribbon"),
                  controller: widget.controller,
                  keyTipController: _keyTips,
                  enableAltKeyTips: false,
                  commandWrapperBuilder: (context, command, child) =>
                      HelpTarget(
                        topicId: HelpTopicId.forCommand(command.id),
                        child: child,
                      ),
                  compact: false,
                  collapsed: !full,
                  context: _ribbonContext,
                  localizations: localizedRibbon(
                    context.l10n,
                    Theme.of(context).platform,
                  ),
                  selectedTabId: _selectedTabId,
                  onSelectedTabChanged: _selectTab,
                  bodyScrollController: _scrollController,
                  onCollapsedChanged: (_) => widget.onModeChanged(
                    full ? ToolbarMode.concise : ToolbarMode.full,
                  ),
                  fixedHeaderActions: [
                    if (widget.moduleSwitcher != null) widget.moduleSwitcher!,
                  ],
                  headerActions: [
                    _HelpMenu(
                      onAction: widget.onHelpAction,
                      onOpened: _openMenu,
                      onClosed: _closeMenu,
                    ),
                    if (widget.statusIndicator != null) widget.statusIndicator!,
                    HelpTarget(
                      topicId: HelpTopicId.toolbarMode,
                      child: _ToolbarModeMenu(
                        preference: widget.modePreference,
                        onChanged: widget.onModeChanged,
                        onOpened: _openMenu,
                        onClosed: _closeMenu,
                      ),
                    ),
                  ],
                  quickAccessCommands: [
                    commands["save"]!,
                    commands["undo"]!,
                    commands["redo"]!,
                  ],
                  tabs: tabs,
                ),
                if (!full)
                  SizedBox(
                    height: 56,
                    child: Scrollbar(
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        key: const Key("toolbar-command-scroll"),
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            for (final group in selectedTab.groups)
                              for (final command in group.commands)
                                _ToolbarCommandButton(
                                  command: command,
                                  showLabel:
                                      widget.mode == ToolbarMode.moderate,
                                  iconSize: widget.iconSize,
                                  onInvoke: () => _invoke(command.id),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolbarCommandButton extends StatelessWidget {
  const _ToolbarCommandButton({
    required this.command,
    required this.showLabel,
    required this.iconSize,
    required this.onInvoke,
  });
  final RibbonCommand command;
  final bool showLabel;
  final double iconSize;
  final VoidCallback onInvoke;

  @override
  Widget build(BuildContext context) {
    final busy = command.busyFor(const RibbonContext());
    final selected = command.type == RibbonCommandType.toggle
        ? command.stateFor(const RibbonContext()) == RibbonCheckState.checked
        : null;
    final searchState = command.id.startsWith("search.") ? selected : null;
    return HelpTarget(
      topicId: HelpTopicId.forCommand(command.id),
      child: Semantics(
        toggled: selected,
        child: IconButton(
          key: ValueKey("toolbar-command-${command.id}"),
          tooltip: [
            command.label,
            if (!command.enabledFor(const RibbonContext()) &&
                command.disabledReasonFor(const RibbonContext()) != null)
              command.disabledReasonFor(const RibbonContext())!,
          ].join("\n"),
          isSelected: selected,
          style: IconButton.styleFrom(
            minimumSize: const Size(48, 48),
            backgroundColor: searchState == true
                ? Theme.of(context).colorScheme.secondaryContainer
                : null,
          ),
          onPressed: command.enabledFor(const RibbonContext()) && !busy
              ? onInvoke
              : null,
          icon: _ToolbarButtonContent(
            icon: command.icon,
            iconSize: iconSize,
            label: showLabel ? command.label : null,
            busy: busy,
            searchState: searchState,
          ),
        ),
      ),
    );
  }
}

class _ToolbarButtonContent extends StatelessWidget {
  const _ToolbarButtonContent({
    required this.icon,
    required this.iconSize,
    this.label,
    this.busy = false,
    this.searchState,
  });
  final IconData icon;
  final double iconSize;
  final String? label;
  final bool busy;
  final bool? searchState;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (busy)
        const SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      else
        Icon(icon, size: iconSize),
      if (label != null) ...[
        const SizedBox(width: 6),
        Text(label!, style: Theme.of(context).textTheme.labelLarge),
      ],
      if (searchState != null) ...[
        const SizedBox(width: 4),
        ExcludeSemantics(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
            decoration: BoxDecoration(
              color: searchState!
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  searchState! ? Icons.check : Icons.close,
                  size: 12,
                  color: searchState!
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                if (label != null)
                  Text(
                    searchState! ? context.l10n.uiOn : context.l10n.uiOff,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: searchState!
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    ],
  );
}

class _ToolbarModeMenu extends StatelessWidget {
  const _ToolbarModeMenu({
    required this.preference,
    required this.onChanged,
    required this.onOpened,
    required this.onClosed,
  });
  final ToolbarMode? preference;
  final ValueChanged<ToolbarMode?> onChanged;
  final VoidCallback onOpened;
  final VoidCallback onClosed;

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    key: const Key("toolbar-mode-menu"),
    tooltip: context.l10n.uiToolbarMode,
    icon: const Icon(Icons.view_compact_outlined),
    onOpened: onOpened,
    onCanceled: onClosed,
    onSelected: (value) {
      onChanged(ToolbarMode.fromPreference(value));
      onClosed();
    },
    itemBuilder: (_) => [
      CheckedPopupMenuItem(
        value: "automatic",
        checked: preference == null,
        child: Text(context.l10n.uiAutomaticFullOnDesktopModerateOnMobile),
      ),
      for (final mode in ToolbarMode.values)
        CheckedPopupMenuItem(
          value: mode.name,
          checked: preference == mode,
          child: Text(mode.label),
        ),
    ],
  );
}

class _HelpMenu extends StatefulWidget {
  const _HelpMenu({
    this.onAction,
    required this.onOpened,
    required this.onClosed,
  });
  final ValueChanged<String>? onAction;
  final VoidCallback onOpened;
  final VoidCallback onClosed;
  @override
  State<_HelpMenu> createState() => _HelpMenuState();
}

class _HelpMenuState extends State<_HelpMenu> {
  bool _pointerCaptured = false;

  @override
  Widget build(BuildContext context) {
    final help = HelpController.maybeOf(context);
    return HelpTarget(
      topicId: HelpTopicId.usingHelp,
      child: Listener(
        onPointerDown: (_) {
          help?.beginMenu();
          _pointerCaptured = true;
        },
        child: PopupMenuButton<String>(
          tooltip: context.l10n.uiHelp,
          onOpened: () {
            if (!_pointerCaptured) help?.beginMenu();
            _pointerCaptured = false;
            widget.onOpened();
          },
          onCanceled: () {
            help?.endMenu();
            widget.onClosed();
          },
          icon: const Icon(Icons.help_outline),
          onSelected: (action) {
            widget.onClosed();
            if (widget.onAction != null) {
              widget.onAction!(action);
              help?.endMenu();
              return;
            }
            switch (action) {
              case 'home':
                help?.showTopic(HelpTopicId.home);
              case 'context':
                help?.showCapturedContext();
              case 'pick':
                help?.togglePicking(useCapturedContext: true);
            }
            help?.endMenu();
          },
          itemBuilder: (_) => [
            for (final (id, label) in [
              ('home', context.l10n.uiHelpHome),
              ('context', context.l10n.uiHelpForThisFeatureF1),
              ('pick', context.l10n.uiWhatSThisShiftF1),
            ])
              HelpPopupMenuItem(
                topicId: HelpTopicId.usingHelp,
                value: id,
                child: HelpTarget(
                  topicId: HelpTopicId.usingHelp,
                  child: Text(label),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
