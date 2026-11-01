// Copyright 2025-2026 Heyairu（部屋伊琉）
// Licensed under the Apache License, Version 2.0.

import 'package:flutter/material.dart';

enum AppModuleId {
  home,
  story,
  chapters,
  outline,
  timeline,
  characters,
  relationships,
  world,
  items,
  plans,
  glossary,
  palettes,
  proofreading,
  copilot,
  editor,
  settings,
  help,
  about,
}

/// Navigation indexes retain their historic values. The editor is not mounted
/// a second time inside the page stack.
class AppModule {
  const AppModule(
    this.id,
    this.navigationIndex,
    this.label,
    this.icon, {
    this.digit,
    this.footer = false,
  });

  final AppModuleId id;
  final int navigationIndex;
  final String label;
  final IconData icon;
  final int? digit;
  final bool footer;

  int get pageIndex =>
      id == AppModuleId.editor ? editorPageIndex : navigationIndex;
  static const editorPageIndex = 114514;

  static AppModule forPage(int index) => all.firstWhere(
    (module) => module.pageIndex == index,
    orElse: () => all.firstWhere((module) => module.id == AppModuleId.editor),
  );

  static AppModule forNavigation(int index) =>
      all.firstWhere((module) => module.navigationIndex == index);

  static AppModule step(AppModule current, int delta) =>
      all[(all.indexOf(current) + delta) % all.length];

  static const pageCount = 17;
  static const all = <AppModule>[
    AppModule(AppModuleId.home, 0, '首頁', Icons.home, digit: 0),
    AppModule(AppModuleId.story, 1, '故事設定', Icons.book),
    AppModule(AppModuleId.chapters, 2, '章節選擇', Icons.menu_book, digit: 2),
    AppModule(AppModuleId.outline, 3, '大綱調整', Icons.list, digit: 3),
    AppModule(
      AppModuleId.timeline,
      4,
      '時間軸',
      Icons.view_timeline_outlined,
      digit: 6,
    ),
    AppModule(AppModuleId.characters, 5, '角色設定', Icons.person, digit: 4),
    AppModule(AppModuleId.relationships, 6, '關係設定', Icons.group),
    AppModule(AppModuleId.world, 7, '世界設定', Icons.public, digit: 5),
    AppModule(
      AppModuleId.items,
      8,
      '物品設定',
      Icons.inventory_2_outlined,
      digit: 7,
    ),
    AppModule(AppModuleId.plans, 9, '計畫規劃', Icons.assessment_outlined),
    AppModule(AppModuleId.glossary, 10, '詞語參考', Icons.library_books_outlined),
    AppModule(AppModuleId.palettes, 11, '文字色票', Icons.palette_outlined),
    AppModule(AppModuleId.proofreading, 12, '文本校正', Icons.spellcheck),
    AppModule(AppModuleId.copilot, 13, 'Copilot', Icons.auto_awesome),
    AppModule(AppModuleId.editor, 17, '正文編輯', Icons.edit_note, digit: 1),
    AppModule(
      AppModuleId.settings,
      14,
      '設定',
      Icons.settings,
      digit: 8,
      footer: true,
    ),
    AppModule(
      AppModuleId.help,
      16,
      '說明',
      Icons.help_outline,
      digit: 9,
      footer: true,
    ),
    AppModule(AppModuleId.about, 15, '關於', Icons.info, footer: true),
  ];
}
