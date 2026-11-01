// Copyright 2025-2026 Heyairu（部屋伊琉）
// Licensed under the Apache License, Version 2.0.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../features/navigation/app_module.dart';

class ModuleSwitcher extends StatefulWidget {
  const ModuleSwitcher({super.key, required this.current});
  final AppModule current;

  static Future<AppModule?> show(BuildContext context, AppModule current) =>
      showDialog<AppModule>(
        context: context,
        builder: (_) => ModuleSwitcher(current: current),
      );

  @override
  State<ModuleSwitcher> createState() => _ModuleSwitcherState();
}

class _ModuleSwitcherState extends State<ModuleSwitcher> {
  final _query = TextEditingController();
  late final _focus = FocusNode(onKeyEvent: _onKey);
  final _scroll = ScrollController();

  late AppModule _selected = widget.current;
  List<AppModule> get _matches => AppModule.all
      .where(
        (module) => module.label.toLowerCase().contains(
          _query.text.trim().toLowerCase(),
        ),
      )
      .toList();

  double get _rowHeight =>
      MediaQuery.textScalerOf(context).scale(72).clamp(72, double.infinity);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelection());
  }

  void _revealSelection() {
    if (!mounted || !_scroll.hasClients) return;
    final index = _matches.indexOf(_selected);
    if (index < 0) return;
    final top = index * _rowHeight;
    final bottom = top + _rowHeight;
    final position = _scroll.position;
    final target = top < position.pixels
        ? top
        : bottom > position.pixels + position.viewportDimension
        ? bottom - position.viewportDimension
        : position.pixels;
    _scroll.jumpTo(target.clamp(0, position.maxScrollExtent));
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (_query.value.composing.isValid && !_query.value.composing.isCollapsed) {
      return KeyEventResult.ignored;
    }
    final matches = _matches;
    if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if ((event is KeyDownEvent || event is KeyRepeatEvent) &&
          matches.isNotEmpty) {
        final delta = event.logicalKey == LogicalKeyboardKey.arrowUp ? -1 : 1;
        setState(
          () => _selected =
              matches[(matches.indexOf(_selected) + delta) % matches.length],
        );
        WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelection());
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _query.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matches = _matches;
    final apple =
        Theme.of(context).platform == TargetPlatform.macOS ||
        Theme.of(context).platform == TargetPlatform.iOS;
    return AlertDialog(
      title: const Text('切換模組'),
      content: SizedBox(
        width: 440,
        height: 480,
        child: Column(
          children: [
            TextField(
              key: const Key('module-switcher-query'),
              controller: _query,
              focusNode: _focus,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '搜尋模組',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {
                if (_matches.isNotEmpty && !_matches.contains(_selected)) {
                  _selected = _matches.first;
                }
              }),
              onSubmitted: (_) {
                if (matches.contains(_selected)) {
                  Navigator.of(context).pop(_selected);
                }
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: matches.isEmpty
                  ? const Center(child: Text('找不到符合的模組'))
                  : ListView(
                      controller: _scroll,
                      itemExtent: _rowHeight,
                      children: [
                        for (final module in matches)
                          ListTile(
                            key: ValueKey('module-choice-${module.id.name}'),
                            selected: module == _selected,
                            leading: Icon(module.icon),
                            title: Text(module.label),
                            subtitle: module == widget.current
                                ? const Text('目前模組')
                                : null,
                            trailing: module.digit == null
                                ? null
                                : Text(
                                    '${apple ? '⌘' : 'Ctrl+'}${module.digit}',
                                  ),
                            onTap: () => Navigator.of(context).pop(module),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ],
    );
  }
}
