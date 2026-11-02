// Copyright 2025-2026 Heyairu（部屋伊琉）
// Licensed under the Apache License, Version 2.0.

import "dart:convert";
import "package:flutter/services.dart";
import "help_topic.dart";
import "help_assets.dart";

export "help_assets.dart" show HelpAssets;

class HelpSection {
  const HelpSection({
    required this.heading,
    required this.paragraphs,
    required this.steps,
  });
  final String heading;
  final List<String> paragraphs;
  final List<String> steps;
}

class HelpTopic {
  const HelpTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.keywords,
    required this.sections,
    required this.relatedIds,
  });
  final String id;
  final String title;
  final String category;
  final List<String> keywords;
  final List<HelpSection> sections;
  final List<String> relatedIds;
  String get searchableText => normalizeHelpSearch(
    [
      category,
      title,
      ...keywords,
      for (final section in sections) ...[
        section.heading,
        ...section.paragraphs,
        ...section.steps,
      ],
    ].join("\n"),
  );
}

class HelpCatalog {
  HelpCatalog._(
    this.topics, {
    required this.localeName,
    required this.contentVersion,
  });
  final Map<String, HelpTopic> topics;
  final String localeName;
  final int contentVersion;

  static Future<HelpCatalog> load({
    AssetBundle? bundle,
    String localeName = "zh",
  }) async {
    final assets = bundle ?? rootBundle;
    final manifest = HelpAssetManifest.parse(
      await assets.loadString(HelpAssets.manifestPath, cache: false),
    );
    final locale = HelpAssets.localeFor(localeName);
    final catalog = HelpCatalog.parse(
      await assets.loadString(manifest.locales[locale]!, cache: false),
    );
    if (catalog.contentVersion != manifest.version ||
        catalog.localeName != locale ||
        catalog.topics.length != manifest.topicIds.length ||
        !catalog.topics.keys.toSet().containsAll(manifest.topicIds)) {
      throw FormatException("Incomplete or outdated offline help: $locale");
    }
    return catalog;
  }

  factory HelpCatalog.parse(String source) {
    final rawData = jsonDecode(source);
    if (rawData is! Map<String, dynamic> || rawData["topics"] is! List) {
      throw const FormatException("Invalid offline help catalog");
    }
    final data = rawData;
    final topics = <String, HelpTopic>{};
    List<String> strings(dynamic value) {
      if (value is! List ||
          !value.every((text) => text is String && text.trim().isNotEmpty)) {
        throw const FormatException("Invalid offline help text");
      }
      return List<String>.unmodifiable(value.cast<String>());
    }

    for (final raw in data["topics"] as List) {
      if (raw is! Map<String, dynamic> ||
          raw["id"] is! String ||
          raw["title"] is! String ||
          raw["category"] is! String ||
          raw["sections"] is! List) {
        throw const FormatException("Invalid offline help topic");
      }
      final item = raw;
      final id = item["id"] as String;
      if (id.isEmpty ||
          (item["title"] as String).trim().isEmpty ||
          (item["category"] as String).trim().isEmpty ||
          (item["sections"] as List).isEmpty) {
        throw FormatException("Incomplete help topic: $id");
      }
      if (topics.containsKey(id)) {
        throw FormatException("Duplicate help topic: $id");
      }
      topics[id] = HelpTopic(
        id: id,
        title: item["title"] as String,
        category: item["category"] as String,
        keywords: strings(item["keywords"]),
        sections: List.unmodifiable([
          for (final s in item["sections"] as List)
            if (s is Map<String, dynamic> &&
                s["heading"] is String &&
                (s["heading"] as String).trim().isNotEmpty &&
                s["paragraphs"] is List &&
                s["steps"] is List &&
                ((s["paragraphs"] as List).isNotEmpty ||
                    (s["steps"] as List).isNotEmpty))
              HelpSection(
                heading: s["heading"] as String,
                paragraphs: strings(s["paragraphs"]),
                steps: strings(s["steps"]),
              )
            else
              throw FormatException("Incomplete help section: $id"),
        ]),
        relatedIds: strings(item["relatedIds"]),
      );
    }
    for (final topic in topics.values) {
      for (final id in topic.relatedIds) {
        if (!topics.containsKey(id)) {
          throw FormatException("Unknown help link: $id");
        }
      }
    }
    if (!topics.containsKey(HelpTopicId.home)) {
      throw const FormatException("Missing help home");
    }
    return HelpCatalog._(
      Map.unmodifiable(topics),
      localeName: data["locale"] as String? ?? "zh_TW",
      contentVersion: data["contentVersion"] as int? ?? 1,
    );
  }

  HelpTopic topic(String id) => topics[id] ?? topics[HelpTopicId.home]!;

  /// All query terms must match; title matches rank before keyword/body matches.
  List<HelpTopic> search(String query) {
    final terms = normalizeHelpSearch(
      query,
    ).trim().split(RegExp(r"\s+")).where((s) => s.isNotEmpty).toList();
    if (terms.isEmpty) return topics.values.toList();
    final matches = topics.values
        .where((t) => terms.every(t.searchableText.contains))
        .toList();
    int rank(HelpTopic t) => terms.fold(
      0,
      (score, term) =>
          score +
          (normalizeHelpSearch(t.title).contains(term)
              ? 100
              : t.keywords.any((k) => normalizeHelpSearch(k).contains(term))
              ? 10
              : 1),
    );
    matches.sort((a, b) {
      final score = rank(b).compareTo(rank(a));
      return score != 0 ? score : a.title.compareTo(b.title);
    });
    return matches;
  }
}
