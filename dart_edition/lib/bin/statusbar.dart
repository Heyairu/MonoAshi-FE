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

import "package:monogatari_assistant/l10n/app_localization.dart";
import "package:flutter/material.dart";
import "dart:math" as math;

import "../ui_library/spacing.dart";
import "../ui_library/theme_palette.dart";

class MonogatariStatusBar extends StatelessWidget {
  final AppThemePreset themePreset;
  final bool compact;
  final String displayText;
  final String saveTimeText;
  final int cursorLine;
  final int cursorColumn;
  final int currentWords;
  final int totalWords;
  final double iconSize;
  final int tabSpaceCount;
  final bool tabFullWidth;
  final bool autoIndentLineStart;
  final ValueChanged<bool>? onAutoIndentLineStartChanged;
  final ValueChanged<int>? onTabSpaceCountChanged;
  final ValueChanged<bool>? onTabFullWidthChanged;
  final bool overwriteMode;
  final VoidCallback? onToggleOverwrite;

  const MonogatariStatusBar({
    super.key,
    this.themePreset = AppThemePreset.standard,
    this.compact = false,
    required this.displayText,
    required this.saveTimeText,
    required this.cursorLine,
    required this.cursorColumn,
    required this.currentWords,
    required this.totalWords,
    required this.iconSize,
    this.tabSpaceCount = 2,
    this.tabFullWidth = true,
    this.autoIndentLineStart = false,
    this.onAutoIndentLineStartChanged,
    this.onTabSpaceCountChanged,
    this.onTabFullWidthChanged,
    this.overwriteMode = false,
    this.onToggleOverwrite,
  });

  @override
  Widget build(BuildContext context) {
    final statusTextStyle = Theme.of(
      context,
    ).textTheme.labelSmall!.copyWith(height: 1.2);
    // Latin-only and CJK labels must share the same line box and baseline.
    // Otherwise fallback glyph metrics shift text within centered controls.
    final statusStrutStyle = StrutStyle.fromTextStyle(
      statusTextStyle,
      forceStrutHeight: true,
    );
    final statusButtonStyle = TextButton.styleFrom(
      textStyle: statusTextStyle,
      minimumSize: const Size(0, 24),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
    );
    final wordsText = context.l10n.uiCharacters(
      context.formats.integer(currentWords),
      context.formats.integer(totalWords),
    );
    final cursorText =
        "${context.formats.integer(cursorLine)}:${context.formats.integer(cursorColumn)}";
    final summaryPainter = TextPainter(
      strutStyle: statusStrutStyle,
      text: TextSpan(
        style: statusTextStyle,
        children: [
          TextSpan(
            text: wordsText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: cursorText),
        ],
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    // Reserve a readable document slot, icons, gaps and badge insets.
    final minimumSummaryWidth = summaryPainter.width + iconSize * 2 + 104;
    // Match the desktop row: a 24dp control or the tallest status item,
    // plus the desktop's 8dp vertical inset on each side.
    final rowHeight =
        math.max(
          24.0,
          math.max(
            iconSize,
            summaryPainter.height + AppSpacing.badgePadding.vertical,
          ),
        ) +
        AppSpacing.sm * 2;
    summaryPainter.dispose();
    final document = Row(
      children: [
        Icon(
          Icons.description,
          size: iconSize,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: RepaintBoundary(
            child: ClipRect(
              child: _ScrollingText(
                text: displayText,
                style: statusTextStyle,
                strutStyle: statusStrutStyle,
              ),
            ),
          ),
        ),
      ],
    );
    final saveTime = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time,
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          saveTimeText,
          style: statusTextStyle,
          strutStyle: statusStrutStyle,
        ),
      ],
    );
    final cursor = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.pin_drop_outlined,
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(cursorText, style: statusTextStyle, strutStyle: statusStrutStyle),
      ],
    );
    final tabMenu = _TabSpacesMenu(
      buttonStyle: statusButtonStyle,
      labelStrutStyle: statusStrutStyle,
      count: tabSpaceCount,
      fullWidth: tabFullWidth,
      autoIndentLineStart: autoIndentLineStart,
      onAutoIndentLineStartChanged: onAutoIndentLineStartChanged,
      onCountChanged: onTabSpaceCountChanged,
      onFullWidthChanged: onTabFullWidthChanged,
    );
    final overwrite = Tooltip(
      message: overwriteMode
          ? context.l10n.uiOvertypeModeIns
          : context.l10n.uiInsertModeIns,
      child: Focus(
        canRequestFocus: false,
        descendantsAreFocusable: false,
        child: TextButton(
          style: statusButtonStyle,
          onPressed: onToggleOverwrite,
          // Reserve both labels so mode changes do not shift adjacent items.
          child: IndexedStack(
            index: overwriteMode ? 1 : 0,
            alignment: Alignment.center,
            children: [
              Text("[DEF]", strutStyle: statusStrutStyle),
              Text("[OVR]", strutStyle: statusStrutStyle),
            ],
          ),
        ),
      ),
    );
    final words = Container(
      padding: AppSpacing.badgePadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        wordsText,
        strutStyle: statusStrutStyle,
        style: statusTextStyle.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          if (themePreset.isPride)
            Positioned.fill(
              child: PrideEdgeGlow(
                preset: themePreset,
                fromBottom: true,
                saturation: .8,
                opacity: .4,
              ),
            ),
          if (compact)
            _ExpandableStatusRows(
              document: document,
              minimumWidth: minimumSummaryWidth,
              rowHeight: rowHeight,
              words: words,
              cursor: cursor,
              controls: [saveTime, tabMenu, overwrite],
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final minimumWidth = MediaQuery.textScalerOf(
                    context,
                  ).scale(480);
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: constraints.maxWidth < minimumWidth
                          ? minimumWidth
                          : constraints.maxWidth,
                      child: Row(
                        children: [
                          Expanded(child: document),
                          const SizedBox(width: 8),
                          saveTime,
                          const SizedBox(width: 12),
                          cursor,
                          const SizedBox(width: 12),
                          tabMenu,
                          overwrite,
                          const SizedBox(width: 4),
                          words,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Essential information stays visible while secondary controls expand below.
class _ExpandableStatusRows extends StatefulWidget {
  const _ExpandableStatusRows({
    required this.document,
    required this.minimumWidth,
    required this.rowHeight,
    required this.words,
    required this.cursor,
    required this.controls,
  });

  final Widget document;
  final double minimumWidth;
  final double rowHeight;
  final Widget words;
  final Widget cursor;
  final List<Widget> controls;

  @override
  State<_ExpandableStatusRows> createState() => _ExpandableStatusRowsState();
}

class _ExpandableStatusRowsState extends State<_ExpandableStatusRows> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        key: const Key("statusbar-summary-row"),
        height: widget.rowHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // At large text scales or with large counts, keep every
                    // value readable by scrolling the summary independently.
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: constraints.maxWidth < widget.minimumWidth
                            ? widget.minimumWidth
                            : constraints.maxWidth,
                        child: Row(
                          children: [
                            Expanded(child: widget.document),
                            const SizedBox(width: 8),
                            widget.cursor,
                            const SizedBox(width: 8),
                            widget.words,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Semantics(
                expanded: _expanded,
                child: IconButton(
                  key: const Key("statusbar-expand"),
                  constraints: BoxConstraints.tight(
                    Size.square(widget.rowHeight),
                  ),
                  tooltip: _expanded
                      ? context.l10n.uiCollapseDetails
                      : context.l10n.uiExpandDetails,
                  onPressed: () => setState(() => _expanded = !_expanded),
                  icon: Icon(_expanded ? Icons.expand_more : Icons.expand_less),
                ),
              ),
            ],
          ),
        ),
      ),
      if (_expanded) ...[
        const Divider(height: 1),
        SizedBox(
          key: const Key("statusbar-secondary-row"),
          height: widget.rowHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: SizedBox(
                    height: widget.rowHeight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        widget.controls[0],
                        const SizedBox(width: 12),
                        ...widget.controls.skip(1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ],
  );
}

/// Space width and count appear in columns, with auto-indent across the bottom.
class _TabSpacesMenu extends StatelessWidget {
  const _TabSpacesMenu({
    required this.buttonStyle,
    required this.labelStrutStyle,
    required this.count,
    required this.fullWidth,
    required this.autoIndentLineStart,
    this.onAutoIndentLineStartChanged,
    this.onCountChanged,
    this.onFullWidthChanged,
  });

  final ButtonStyle buttonStyle;
  final StrutStyle labelStrutStyle;
  final int count;
  final bool fullWidth;
  final bool autoIndentLineStart;
  final ValueChanged<bool>? onAutoIndentLineStartChanged;
  final ValueChanged<int>? onCountChanged;
  final ValueChanged<bool>? onFullWidthChanged;

  Widget _choice({
    required Key key,
    required String label,
    required bool selected,
    required VoidCallback? onPressed,
  }) => MenuItemButton(
    key: key,
    onPressed: onPressed,
    leadingIcon: selected
        ? const Icon(Icons.check, size: 16)
        : const SizedBox(width: 16),
    style: const ButtonStyle(fixedSize: WidgetStatePropertyAll(Size(100, 48))),
    child: Text(label),
  );

  @override
  Widget build(BuildContext context) => MenuAnchor(
    alignmentOffset: const Offset(0, -8),
    menuChildren: [
      // MenuItemButton labels contain flex children, so both columns must
      // receive finite horizontal constraints rather than shrink-wrap in a Row.
      SizedBox(
        width: 201,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 384,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _choice(
                          key: const Key("tab-full-width-choice"),
                          label: context.l10n.uiFullWidth,
                          selected: fullWidth,
                          onPressed: onFullWidthChanged == null
                              ? null
                              : () => onFullWidthChanged!(true),
                        ),
                        _choice(
                          key: const Key("tab-half-width-choice"),
                          label: context.l10n.uiHalfWidth,
                          selected: !fullWidth,
                          onPressed: onFullWidthChanged == null
                              ? null
                              : () => onFullWidthChanged!(false),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var value = 1; value <= 8; value++)
                          _choice(
                            key: ValueKey("tab-space-count-$value"),
                            label: "$value",
                            selected: count == value,
                            onPressed: onCountChanged == null
                                ? null
                                : () => onCountChanged!(value),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            SizedBox(
              width: 201,
              height: 48,
              child: MenuItemButton(
                key: const Key("auto-indent-line-start-choice"),
                onPressed: onAutoIndentLineStartChanged == null
                    ? null
                    : () => onAutoIndentLineStartChanged!(!autoIndentLineStart),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.l10n.uiIndentLineStart),
                    Text(autoIndentLineStart ? "ON" : "OFF"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
    builder: (context, controller, child) => Tooltip(
      message: context.l10n.uiInsertSpacesWithTab,
      child: TextButton(
        key: const Key("statusbar-tab-spaces"),
        style: buttonStyle,
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        child: Text(
          "[${fullWidth ? context.l10n.uiFullWidth : context.l10n.uiHalfWidth}:$count]",
          strutStyle: labelStrutStyle,
        ),
      ),
    ),
  );
}

class _ScrollingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final StrutStyle strutStyle;

  const _ScrollingText({
    required this.text,
    this.style,
    required this.strutStyle,
  });

  @override
  State<_ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<_ScrollingText>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const _gap = 32.0;
  static const _pixelsPerSecond = 32.0;

  late final AnimationController _animation;
  bool _isAppActive = true;
  bool _shouldAnimate = false;
  double _period = -1;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant _ScrollingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.style != widget.style ||
        oldWidget.strutStyle != widget.strutStyle) {
      _animation.reset();
      _period = -1;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isAppActive = state == AppLifecycleState.resumed;
    if (_isAppActive && _shouldAnimate) {
      _animation.repeat();
    } else {
      _animation.stop();
    }
  }

  void _configureAnimation(double period, bool enabled) {
    if (_period == period && _shouldAnimate == enabled) return;
    _period = period;
    _shouldAnimate = enabled;
    final generation = ++_generation;
    // Width, text scaling and animation preferences can change during layout.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _generation) return;
      _animation.stop();
      if (!_shouldAnimate) return;
      _animation.duration = Duration(
        milliseconds: (_period / _pixelsPerSecond * 1000).round(),
      );
      if (_isAppActive) _animation.repeat();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final direction = Directionality.of(context);
      final textScaler = MediaQuery.textScalerOf(context);
      final painter = TextPainter(
        text: TextSpan(text: widget.text, style: widget.style),
        strutStyle: widget.strutStyle,
        maxLines: 1,
        textDirection: direction,
        textScaler: textScaler,
      )..layout();
      final textWidth = painter.width;
      final textHeight = painter.height;
      painter.dispose();
      final overflows =
          constraints.maxWidth.isFinite && textWidth > constraints.maxWidth;
      final animated = overflows && !MediaQuery.disableAnimationsOf(context);
      final period = textWidth + _gap;
      _configureAnimation(period, animated);

      Widget text() => Text(
        widget.text,
        style: widget.style,
        strutStyle: widget.strutStyle,
        textDirection: direction,
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.clip,
      );
      if (!animated) return text();

      return Semantics(
        label: widget.text,
        child: ExcludeSemantics(
          child: SizedBox(
            height: textHeight,
            child: ClipRect(
              key: const Key("statusbar-chapter-marquee"),
              child: OverflowBox(
                alignment: Alignment.centerLeft,
                minWidth: period * 2,
                maxWidth: period * 2,
                minHeight: textHeight,
                maxHeight: textHeight,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) => Transform.translate(
                    key: const Key("statusbar-chapter-cycle"),
                    offset: Offset(-_animation.value * period, 0),
                    child: child,
                  ),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      text(),
                      const SizedBox(width: _gap),
                      text(),
                      const SizedBox(width: _gap),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
