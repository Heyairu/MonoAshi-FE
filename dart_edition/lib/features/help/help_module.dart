// Copyright 2025-2026 Heyairu（部屋伊琉）
// Licensed under the Apache License, Version 2.0.

import 'package:flutter/material.dart';
import '../../l10n/app_localization.dart';
import 'help_catalog.dart';
import 'help_topic.dart';
import 'help_viewer.dart';

/// Independent focus and reading state; F1 can still open contextual help.
class HelpModule extends StatefulWidget {
  const HelpModule({super.key});

  @override
  State<HelpModule> createState() => _HelpModuleState();
}

class _HelpModuleState extends State<HelpModule> {
  final _topic = ValueNotifier(HelpTopicId.home);
  final _focus = FocusNode(debugLabel: 'Help module');
  Future<HelpCatalog>? _catalog;
  String? _catalogKey;

  Future<HelpCatalog> _loadCatalog() {
    final locale = context.l10n.localeName;
    final key = HelpAssets.cacheKey(locale);
    if (_catalogKey != key) {
      _catalogKey = key;
      _catalog = null;
    }
    return _catalog ??= HelpCatalog.load(localeName: locale);
  }

  @override
  void dispose() {
    _topic.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HelpViewer(
    embedded: true,
    catalogKey: HelpAssets.cacheKey(context.l10n.localeName),
    topic: _topic,
    focusNode: _focus,
    loadCatalog: _loadCatalog,
    retryCatalog: () => _catalog = null,
    onTopic: (id) => _topic.value = id,
  );
}
