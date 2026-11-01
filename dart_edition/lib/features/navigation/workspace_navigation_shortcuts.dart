// Copyright 2025-2026 Heyairu（部屋伊琉）
// Licensed under the Apache License, Version 2.0.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_module.dart';

/// Routes exact workspace gestures before editor-local search and movement.
/// The focus subtree and current route gate prevent background navigation.
class WorkspaceNavigationShortcuts extends StatefulWidget {
  const WorkspaceNavigationShortcuts({
    super.key,
    required this.child,
    required this.isBlocked,
    required this.onRibbonStep,
    required this.onModuleStep,
    required this.onOpenSwitcher,
    required this.onOpenModule,
    this.focusNode,
    this.onFind,
    this.onReplace,
    this.onSearchResult,
    this.onSaveAs,
  });

  final FocusNode? focusNode;
  final Widget child;
  final bool Function() isBlocked;
  final ValueChanged<int> onRibbonStep;
  final ValueChanged<int> onModuleStep;
  final VoidCallback onOpenSwitcher;
  final ValueChanged<AppModule> onOpenModule;
  final VoidCallback? onFind;
  final VoidCallback? onReplace;
  final ValueChanged<bool>? onSearchResult;
  final VoidCallback? onSaveAs;

  @override
  State<WorkspaceNavigationShortcuts> createState() =>
      _WorkspaceNavigationShortcutsState();
}

class _WorkspaceNavigationShortcutsState
    extends State<WorkspaceNavigationShortcuts> {
  late final _focus =
      widget.focusNode ?? FocusNode(debugLabel: 'Workspace navigation');

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addEarlyKeyEventHandler(_onKey);
  }

  KeyEventResult _onKey(KeyEvent event) {
    if (!_focus.hasFocus || ModalRoute.of(context)?.isCurrent == false) {
      return KeyEventResult.ignored;
    }
    final keyboard = HardwareKeyboard.instance;
    VoidCallback? invoke;
    if (keyboard.isAltPressed &&
        !keyboard.isControlPressed &&
        !keyboard.isMetaPressed &&
        !keyboard.isShiftPressed) {
      invoke = switch (event.logicalKey) {
        LogicalKeyboardKey.arrowLeft => () => widget.onRibbonStep(-1),
        LogicalKeyboardKey.arrowRight => () => widget.onRibbonStep(1),
        LogicalKeyboardKey.arrowUp => () => widget.onModuleStep(-1),
        LogicalKeyboardKey.arrowDown => () => widget.onModuleStep(1),
        _ => null,
      };
    } else {
      final platform = Theme.of(context).platform;
      final apple =
          platform == TargetPlatform.macOS || platform == TargetPlatform.iOS;
      final primary = apple
          ? keyboard.isMetaPressed && !keyboard.isControlPressed
          : keyboard.isControlPressed && !keyboard.isMetaPressed;
      if (primary) {
        if (!keyboard.isAltPressed &&
            keyboard.isShiftPressed &&
            event.logicalKey == LogicalKeyboardKey.keyS) {
          invoke = widget.onSaveAs;
        } else if (!keyboard.isShiftPressed &&
            ((apple &&
                    keyboard.isAltPressed &&
                    event.logicalKey == LogicalKeyboardKey.keyF) ||
                (!apple &&
                    !keyboard.isAltPressed &&
                    event.logicalKey == LogicalKeyboardKey.keyH))) {
          invoke = widget.onReplace;
        } else if (!keyboard.isAltPressed &&
            !keyboard.isShiftPressed &&
            event.logicalKey == LogicalKeyboardKey.keyF) {
          invoke = widget.onFind;
        } else if (apple &&
            !keyboard.isAltPressed &&
            event.logicalKey == LogicalKeyboardKey.keyG &&
            widget.onSearchResult != null) {
          invoke = () => widget.onSearchResult!(!keyboard.isShiftPressed);
        } else if (!keyboard.isAltPressed &&
            keyboard.isShiftPressed &&
            event.logicalKey == LogicalKeyboardKey.keyM) {
          invoke = widget.onOpenSwitcher;
        } else if (!keyboard.isAltPressed && !keyboard.isShiftPressed) {
          const digits = [
            LogicalKeyboardKey.digit0,
            LogicalKeyboardKey.digit1,
            LogicalKeyboardKey.digit2,
            LogicalKeyboardKey.digit3,
            LogicalKeyboardKey.digit4,
            LogicalKeyboardKey.digit5,
            LogicalKeyboardKey.digit6,
            LogicalKeyboardKey.digit7,
            LogicalKeyboardKey.digit8,
            LogicalKeyboardKey.digit9,
          ];
          final digit = digits.indexOf(event.logicalKey);
          if (digit >= 0) {
            final module = AppModule.all.firstWhere(
              (item) => item.digit == digit,
            );
            invoke = () => widget.onOpenModule(module);
          } else if (event.logicalKey == LogicalKeyboardKey.comma) {
            invoke = () => widget.onOpenModule(AppModule.forNavigation(14));
          }
        }
      }
      if (!apple &&
          !keyboard.isAltPressed &&
          !keyboard.isMetaPressed &&
          !keyboard.isControlPressed &&
          event.logicalKey == LogicalKeyboardKey.f3 &&
          widget.onSearchResult != null) {
        invoke = () => widget.onSearchResult!(!keyboard.isShiftPressed);
      }
    }
    if (invoke == null) return KeyEventResult.ignored;
    final node = FocusManager.instance.primaryFocus;
    final focusContext = node?.context;
    if (focusContext != null &&
        MenuController.maybeOf(focusContext)?.isOpen == true) {
      return KeyEventResult.ignored;
    }
    final editable = node?.context
        ?.findAncestorStateOfType<EditableTextState>();
    final composing = editable?.widget.controller.value.composing;
    if (composing != null && composing.isValid && !composing.isCollapsed) {
      return KeyEventResult.ignored;
    }
    // A disabled workspace command must not fall through to editor formatting.
    if (widget.isBlocked()) return KeyEventResult.handled;
    if (event is KeyDownEvent) invoke();
    // Consume repeats without repeating navigation or passing to the editor.
    return KeyEventResult.handled;
  }

  @override
  void dispose() {
    FocusManager.instance.removeEarlyKeyEventHandler(_onKey);
    if (widget.focusNode == null) _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Focus(focusNode: _focus, autofocus: true, child: widget.child);
}
