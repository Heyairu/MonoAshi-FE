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

import 'package:monogatari_assistant/l10n/app_localization.dart';
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter/services.dart";
import "package:file_picker/file_picker.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:path_provider/path_provider.dart";
import "package:uuid/uuid.dart";
import "dart:async";
import "dart:collection";
import "dart:convert";
import "dart:io";
import "../bin/ui_library.dart";
import "../models/glossary_data.dart";
import "../presentation/providers/project_state_providers.dart";

export "../models/glossary_data.dart";

const String _glossaryAssetPath = "assets/jsons/glossary.json";
const String _legacyGlossaryPrefsKey = "glossary_json_v1";

class _GlossaryCategoryDragData {
  final String categoryId;
  final String categoryName;

  const _GlossaryCategoryDragData({
    required this.categoryId,
    required this.categoryName,
  });
}

class _GlossaryEntryDragData {
  final String entryId;
  final String entryTerm;
  final String sourceCategoryId;

  const _GlossaryEntryDragData({
    required this.entryId,
    required this.entryTerm,
    required this.sourceCategoryId,
  });
}

class _CategoryEntryRef {
  final String entryId;
  final String sourceCategoryId;
  final bool isLocal;

  const _CategoryEntryRef({
    required this.entryId,
    required this.sourceCategoryId,
    required this.isLocal,
  });
}

class _VisibleCategoryRow {
  final GlossaryCategory category;
  final int depth;

  const _VisibleCategoryRow({required this.category, required this.depth});
}

class _GlossaryDecoded {
  final List<GlossaryCategory> categoryTree;
  final HashMap<String, GlossaryEntry> entryIndex;
  final bool shouldPersistToDisk;

  const _GlossaryDecoded({
    required this.categoryTree,
    required this.entryIndex,
    this.shouldPersistToDisk = false,
  });
}

class _GlossaryImportPreviewSummary {
  final int newCategoryCount;
  final int mergedCategoryCount;
  final int newEntryCount;
  final int reusedEntryCount;
  final int newLinkCount;
  final List<String> newCategorySamples;
  final List<String> newEntrySamples;

  const _GlossaryImportPreviewSummary({
    required this.newCategoryCount,
    required this.mergedCategoryCount,
    required this.newEntryCount,
    required this.reusedEntryCount,
    required this.newLinkCount,
    required this.newCategorySamples,
    required this.newEntrySamples,
  });
}

class GlossaryView extends ConsumerStatefulWidget {
  const GlossaryView({super.key});
  @override
  ConsumerState<GlossaryView> createState() => _GlossaryViewState();
}

class _GlossaryViewState extends ConsumerState<GlossaryView> {
  final ScrollController _categoryTreeScrollController = ScrollController();
  final ScrollController _entryListScrollController = ScrollController();

  bool _isLoading = true;
  String? _loadError;

  List<GlossaryCategory> _readCategoryTree() =>
      ref.read(glossaryStateProvider.select((state) => state.categoryTree));
  Map<String, GlossaryEntry> _readEntryIndex() =>
      ref.read(glossaryStateProvider.select((state) => state.entryIndex));
  GlossaryStateNotifier get _glossaryNotifier =>
      ref.read(glossaryStateProvider.notifier);

  String? _selectedCategoryId;
  String? _selectedEntryId;

  bool _isDragging = false;
  String? _draggingCategoryId;
  String? _draggingEntryId;
  String? _draggingEntrySourceCategoryId;

  String? _editingCategoryId;
  TextEditingController? _categoryRenameController;
  final Set<String> _expandedCategoryIds = <String>{};
  final Map<String, Timer> _draftTimers = <String, Timer>{};
  final Map<String, VoidCallback> _draftCommits = <String, VoidCallback>{};
  List<GlossaryCategory>? _indexedCategoryTree;
  Map<String, GlossaryCategory> _categoryIndex =
      const <String, GlossaryCategory>{};
  Map<String, int> _categoryDfsEntry = const <String, int>{};
  Map<String, int> _categoryDfsExit = const <String, int>{};
  Map<String, int> _subtreeEntryCountByCategoryId = const <String, int>{};

  void _bootstrapFromProviderState() {
    final initialState = ref.read(glossaryStateProvider);
    if (initialState.categoryTree.isNotEmpty ||
        initialState.entryIndex.isNotEmpty) {
      _restoreSelectionForState(initialState);
      _expandedCategoryIds
        ..clear()
        ..addAll(initialState.categoryTree.map((category) => category.id));
      setState(() {
        _isLoading = false;
        _loadError = null;
      });
    } else {
      unawaited(_loadGlossary());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _bootstrapFromProviderState();
    });
  }

  @override
  void dispose() {
    for (final timer in _draftTimers.values) {
      timer.cancel();
    }
    for (final commit in _draftCommits.values.toList(growable: false)) {
      commit();
    }
    _draftTimers.clear();
    _draftCommits.clear();
    _categoryRenameController?.dispose();
    _categoryTreeScrollController.dispose();
    _entryListScrollController.dispose();
    super.dispose();
  }

  void _scheduleDraftCommit(String key, VoidCallback commit) {
    _draftTimers.remove(key)?.cancel();
    _draftCommits[key] = commit;
    _draftTimers[key] = Timer(const Duration(milliseconds: 300), () {
      _draftTimers.remove(key);
      _draftCommits.remove(key)?.call();
    });
  }

  Future<String> _getDataDirectoryPath() async {
    final Directory appDir = await getApplicationSupportDirectory();
    final Directory dataDir = Directory("${appDir.path}/Data");
    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }
    return dataDir.path;
  }

  Future<String> get _glossaryFilePath async {
    final String dataPath = await _getDataDirectoryPath();
    return "$dataPath/Glossary.json";
  }

  Future<void> _loadGlossary() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final _GlossaryDecoded decoded = await _loadFromDiskOrAsset();

      String? initialCategoryId;
      if (decoded.categoryTree.isNotEmpty) {
        initialCategoryId = decoded.categoryTree.first.id;
      }

      String? initialEntryId;
      if (initialCategoryId != null) {
        final List<_CategoryEntryRef> refs = _collectEntryRefs(
          initialCategoryId,
          decoded.categoryTree,
        );
        for (final _CategoryEntryRef ref in refs) {
          if (decoded.entryIndex.containsKey(ref.entryId)) {
            initialEntryId = ref.entryId;
            break;
          }
        }
      }

      if (!mounted) return;

      _glossaryNotifier.hydrateFromStorage(
        GlossaryStateData(
          categoryTree: decoded.categoryTree,
          entryIndex: decoded.entryIndex,
        ),
      );
      if (decoded.shouldPersistToDisk) {
        unawaited(_glossaryNotifier.flushGlossaryPersistence());
      }
      _restoreSelectionForState(ref.read(glossaryStateProvider));

      setState(() {
        _selectedCategoryId = initialCategoryId;
        _selectedEntryId = initialEntryId;
        _expandedCategoryIds
          ..clear()
          ..addAll(decoded.categoryTree.map((category) => category.id));
        _isLoading = false;
        _loadError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = e.toString();
      });
    }
  }

  Future<_GlossaryDecoded> _loadFromDiskOrAsset() async {
    final String filePath = await _glossaryFilePath;
    final File file = File(filePath);

    if (await file.exists()) {
      try {
        final String raw = await file.readAsString();
        return _decodeGlossary(raw);
      } catch (_) {
        // 檔案壞掉時會回退到資源檔，避免畫面卡住。
      }
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? legacyRaw = prefs.getString(_legacyGlossaryPrefsKey);
    if (legacyRaw != null && legacyRaw.trim().isNotEmpty) {
      final _GlossaryDecoded decoded = _decodeGlossary(legacyRaw);
      return _GlossaryDecoded(
        categoryTree: decoded.categoryTree,
        entryIndex: decoded.entryIndex,
        shouldPersistToDisk: true,
      );
    }

    final String assetRaw = await rootBundle.loadString(_glossaryAssetPath);
    final _GlossaryDecoded decoded = _decodeGlossary(assetRaw);
    return _GlossaryDecoded(
      categoryTree: decoded.categoryTree,
      entryIndex: decoded.entryIndex,
      shouldPersistToDisk: true,
    );
  }

  _GlossaryDecoded _decodeGlossary(String rawJson) {
    final dynamic decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException("glossary.json 不是合法物件格式");
    }

    final List<GlossaryCategory> categoryTree =
        (decoded["categoryTree"] as List<dynamic>? ?? <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(GlossaryCategory.fromJson)
            .toList();

    final HashMap<String, GlossaryEntry> entryIndex = HashMap();
    final dynamic entriesRaw = decoded["entries"];
    if (entriesRaw is Map<String, dynamic>) {
      for (final MapEntry<String, dynamic> entry in entriesRaw.entries) {
        final dynamic value = entry.value;
        if (value is Map<String, dynamic>) {
          final GlossaryEntry parsed = GlossaryEntry.fromJson(value);
          final String resolvedId = parsed.id.isNotEmpty
              ? parsed.id
              : entry.key;
          final GlossaryEntry resolved = parsed.copyWith(id: resolvedId);
          entryIndex[entry.key] = resolved;
          if (resolvedId != entry.key) {
            entryIndex[resolvedId] = resolved;
          }
        }
      }
    }

    _deduplicateEntriesByTerm(categoryTree, entryIndex);

    return _GlossaryDecoded(categoryTree: categoryTree, entryIndex: entryIndex);
  }

  List<GlossaryCategory> _copyCategoryTree(List<GlossaryCategory> nodes) {
    return copyGlossaryCategoryTree(nodes);
  }

  HashMap<String, GlossaryEntry> _copyEntryIndex(
    Map<String, GlossaryEntry> source,
  ) {
    return copyGlossaryEntryIndex(source);
  }

  void _restoreSelectionForState(GlossaryStateData state) {
    final List<GlossaryCategory> categoryTree = state.categoryTree;
    final Map<String, GlossaryEntry> entryIndex = state.entryIndex;

    if (_selectedCategoryId == null ||
        _findCategoryById(_selectedCategoryId!, categoryTree) == null) {
      _selectedCategoryId = categoryTree.isNotEmpty
          ? categoryTree.first.id
          : null;
    }

    if (_selectedCategoryId == null) {
      _selectedEntryId = null;
      return;
    }

    final List<_CategoryEntryRef> refs = _collectEntryRefs(
      _selectedCategoryId!,
      categoryTree,
    );

    if (_selectedEntryId != null) {
      final bool stillVisible = refs.any(
        (ref) => ref.entryId == _selectedEntryId,
      );
      final bool exists = entryIndex.containsKey(_selectedEntryId);
      if (stillVisible && exists) {
        return;
      }
    }

    _selectedEntryId = null;
    for (final _CategoryEntryRef ref in refs) {
      if (entryIndex.containsKey(ref.entryId)) {
        _selectedEntryId = ref.entryId;
        break;
      }
    }
  }

  void _rebuildCategoryIndex(List<GlossaryCategory> categoryTree) {
    final categoryIndex = <String, GlossaryCategory>{};
    final dfsEntry = <String, int>{};
    final dfsExit = <String, int>{};
    final subtreeEntryCountByCategoryId = <String, int>{};
    int dfsClock = 0;

    void walk(GlossaryCategory category) {
      dfsEntry[category.id] = dfsClock++;
      categoryIndex[category.id] = category;
      int subtreeEntryCount = category.entryIds.length;

      for (final GlossaryCategory child in category.children) {
        walk(child);
        subtreeEntryCount += subtreeEntryCountByCategoryId[child.id] ?? 0;
      }

      subtreeEntryCountByCategoryId[category.id] = subtreeEntryCount;
      dfsExit[category.id] = dfsClock++;
    }

    for (final GlossaryCategory category in categoryTree) {
      walk(category);
    }

    _indexedCategoryTree = categoryTree;
    _categoryIndex = categoryIndex;
    _categoryDfsEntry = dfsEntry;
    _categoryDfsExit = dfsExit;
    _subtreeEntryCountByCategoryId = subtreeEntryCountByCategoryId;
  }

  GlossaryCategory? _findCategoryById(String id, List<GlossaryCategory> nodes) {
    if (identical(nodes, _indexedCategoryTree)) {
      final GlossaryCategory? indexed = _categoryIndex[id];
      if (indexed != null) {
        return indexed;
      }
    }

    for (final GlossaryCategory node in nodes) {
      if (node.id == id) return node;
      final GlossaryCategory? found = _findCategoryById(id, node.children);
      if (found != null) return found;
    }
    return null;
  }

  bool _isDescendantCategory(
    String sourceId,
    String targetId,
    List<GlossaryCategory> categoryTree,
  ) {
    if (identical(categoryTree, _indexedCategoryTree)) {
      final sourceEntry = _categoryDfsEntry[sourceId];
      final sourceExit = _categoryDfsExit[sourceId];
      final targetEntry = _categoryDfsEntry[targetId];
      final targetExit = _categoryDfsExit[targetId];
      if (sourceEntry != null &&
          sourceExit != null &&
          targetEntry != null &&
          targetExit != null) {
        return sourceEntry < targetEntry && targetExit < sourceExit;
      }
    }

    final GlossaryCategory? source = _findCategoryById(sourceId, categoryTree);
    if (source == null) return false;

    bool walk(GlossaryCategory node) {
      if (node.id == targetId) return true;
      for (final GlossaryCategory child in node.children) {
        if (walk(child)) return true;
      }
      return false;
    }

    return walk(source);
  }

  void _moveCategoryTo(
    String sourceId,
    String targetId,
    DropPosition position,
  ) {
    final GlossaryCategoryDropPosition mappedPosition = switch (position) {
      DropPosition.before => GlossaryCategoryDropPosition.before,
      DropPosition.child => GlossaryCategoryDropPosition.child,
      DropPosition.after => GlossaryCategoryDropPosition.after,
    };

    final bool moved = _glossaryNotifier.moveCategoryTo(
      sourceId: sourceId,
      targetId: targetId,
      position: mappedPosition,
    );

    if (!moved) {
      AppFeedback.warning(context, "無法移動到自己或自己的子目錄");
      return;
    }

    if (position == DropPosition.child) {
      setState(() {
        _expandedCategoryIds.add(targetId);
      });
    }
  }

  List<_VisibleCategoryRow> _collectVisibleCategories(
    List<GlossaryCategory> categoryTree,
  ) {
    final List<_VisibleCategoryRow> rows = [];

    void walk(List<GlossaryCategory> nodes, int depth) {
      for (final GlossaryCategory category in nodes) {
        rows.add(_VisibleCategoryRow(category: category, depth: depth));
        final bool expanded = _expandedCategoryIds.contains(category.id);
        if (expanded && category.children.isNotEmpty) {
          walk(category.children, depth + 1);
        }
      }
    }

    walk(categoryTree, 0);
    return rows;
  }

  List<_CategoryEntryRef> _collectEntryRefs(
    String categoryId,
    List<GlossaryCategory> nodes,
  ) {
    final GlossaryCategory? root = _findCategoryById(categoryId, nodes);
    if (root == null) return [];

    final List<_CategoryEntryRef> refs = [];
    final Set<String> seen = <String>{};

    void walk(GlossaryCategory category, {required bool isLocal}) {
      for (final String entryId in category.entryIds) {
        if (seen.add(entryId)) {
          refs.add(
            _CategoryEntryRef(
              entryId: entryId,
              sourceCategoryId: category.id,
              isLocal: isLocal,
            ),
          );
        }
      }

      for (final GlossaryCategory child in category.children) {
        walk(child, isLocal: false);
      }
    }

    walk(root, isLocal: true);
    return refs;
  }

  int _countSubtreeEntries(GlossaryCategory category) {
    final int? indexedCount = _subtreeEntryCountByCategoryId[category.id];
    if (indexedCount != null) {
      return indexedCount;
    }

    int total = category.entryIds.length;
    for (final GlossaryCategory child in category.children) {
      total += _countSubtreeEntries(child);
    }
    return total;
  }

  String _categoryName(String categoryId, List<GlossaryCategory> categoryTree) {
    final GlossaryCategory? category = _findCategoryById(
      categoryId,
      categoryTree,
    );
    return category?.name ?? context.l10n.uiUnknownCategory;
  }

  String _normalizeTerm(String value) {
    return value.trim().toLowerCase();
  }

  String _resolvePartOfSpeechLabel(GlossaryEntry entry) {
    if (entry.partOfSpeech == GlossaryPartOfSpeech.custom) {
      final String custom = entry.customPartOfSpeech.trim();
      if (custom.isNotEmpty) {
        return custom;
      }
    }
    return context.l10n.legacyLabel(entry.partOfSpeech.label);
  }

  void _deduplicateEntriesByTerm(
    List<GlossaryCategory> categoryTree,
    HashMap<String, GlossaryEntry> entryIndex,
  ) {
    final List<String> primaryEntryIds =
        entryIndex.entries
            .where((item) => item.key == item.value.id)
            .map((item) => item.value.id)
            .toSet()
            .toList()
          ..sort();

    final Map<String, String> canonicalByTerm = {};
    final Map<String, String> replacements = {};

    for (final String entryId in primaryEntryIds) {
      final GlossaryEntry? entry = entryIndex[entryId];
      if (entry == null) continue;

      final String normalizedTerm = _normalizeTerm(entry.term);
      if (normalizedTerm.isEmpty) continue;

      final String? canonicalId = canonicalByTerm[normalizedTerm];
      if (canonicalId == null) {
        canonicalByTerm[normalizedTerm] = entryId;
        continue;
      }

      if (canonicalId != entryId) {
        replacements[entryId] = canonicalId;
      }
    }

    if (replacements.isEmpty) return;

    void walk(List<GlossaryCategory> nodes) {
      for (final GlossaryCategory node in nodes) {
        final List<String> rewrittenIds = [];
        final Set<String> seen = <String>{};

        for (final String entryId in node.entryIds) {
          final String resolvedId = replacements[entryId] ?? entryId;
          if (seen.add(resolvedId)) {
            rewrittenIds.add(resolvedId);
          }
        }

        node.entryIds = rewrittenIds;
        walk(node.children);
      }
    }

    walk(categoryTree);
    entryIndex.removeWhere(
      (key, value) =>
          replacements.containsKey(key) || replacements.containsKey(value.id),
    );
  }

  String _createId() => const Uuid().v4();

  Future<String?> _showTextInputDialog({
    required String title,
    required String hint,
    String initialValue = "",
  }) async {
    return AppDialog.prompt(
      context: context,
      title: title,
      hintText: hint,
      initialValue: initialValue,
      allowEmpty: true,
    );
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
  }) async {
    return AppDialog.confirm(
      context: context,
      title: title,
      message: message,
      confirmLabel: context.l10n.commonDelete,
      destructive: true,
    );
  }

  List<GlossaryCategory>? _findCategoryPathById(
    String categoryId,
    List<GlossaryCategory> nodes,
  ) {
    for (final GlossaryCategory node in nodes) {
      if (node.id == categoryId) {
        return [node];
      }

      final List<GlossaryCategory>? childPath = _findCategoryPathById(
        categoryId,
        node.children,
      );
      if (childPath != null) {
        return [node, ...childPath];
      }
    }

    return null;
  }

  GlossaryCategory _copyCategoryNode(
    GlossaryCategory source, {
    List<GlossaryCategory>? childrenOverride,
  }) {
    return source.copyWith(
      entryIds: List<String>.from(source.entryIds),
      children:
          childrenOverride ?? source.children.map(_copyCategoryNode).toList(),
    );
  }

  List<GlossaryCategory> _buildExportTreeForSelectedCategory(
    String categoryId,
    List<GlossaryCategory> categoryTree,
  ) {
    final List<GlossaryCategory>? path = _findCategoryPathById(
      categoryId,
      categoryTree,
    );
    if (path == null || path.isEmpty) {
      return [];
    }

    GlossaryCategory chain = _copyCategoryNode(path.last);
    for (int i = path.length - 2; i >= 0; i--) {
      chain = _copyCategoryNode(path[i], childrenOverride: [chain]);
    }

    return [chain];
  }

  Set<String> _collectEntryIdsFromTree(List<GlossaryCategory> nodes) {
    final Set<String> refs = <String>{};

    void walk(List<GlossaryCategory> categories) {
      for (final GlossaryCategory category in categories) {
        refs.addAll(category.entryIds);
        walk(category.children);
      }
    }

    walk(nodes);
    return refs;
  }

  Map<String, GlossaryEntry> _collectPrimaryEntries(
    Map<String, GlossaryEntry> entryIndex,
  ) {
    final Map<String, GlossaryEntry> result = {};
    for (final MapEntry<String, GlossaryEntry> entry in entryIndex.entries) {
      if (entry.key == entry.value.id) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  String _sanitizeFileNamePart(String raw) {
    final String sanitized = raw.replaceAll(RegExp(r'[\\/:*?"<>|]'), "_");
    final String trimmed = sanitized.trim();
    return trimmed.isEmpty ? "glossary" : trimmed;
  }

  Future<void> _exportGlossaryData({
    required String defaultName,
    required List<GlossaryCategory> exportTree,
  }) async {
    final Set<String> refs = _collectEntryIdsFromTree(exportTree);
    final Map<String, GlossaryEntry> primaryEntries = _collectPrimaryEntries(
      _readEntryIndex(),
    );

    final Map<String, dynamic> payload = {
      "version": 1,
      "categoryTree": exportTree.map((e) => e.toJson()).toList(),
      "entries": {
        for (final String entryId in refs)
          if (primaryEntries.containsKey(entryId))
            entryId: primaryEntries[entryId]!.toJson(),
      },
    };

    final String jsonContent = jsonEncode(payload);

    final String? savedPath = await FilePicker.platform.saveFile(
      dialogTitle: context.l10n.uiExportWordReference,
      fileName: defaultName,
      type: FileType.custom,
      allowedExtensions: ["json"],
    );

    if (!mounted || savedPath == null) return;

    final String resolvedPath = savedPath.toLowerCase().endsWith(".json")
        ? savedPath
        : "$savedPath.json";

    try {
      await File(resolvedPath).writeAsString(jsonContent);
    } catch (_) {
      if (!mounted) return;
      AppFeedback.error(
        context,
        context.l10n.uiExportFailedCouldNotWriteTheFile,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (!mounted) return;
    final String name = resolvedPath.replaceAll("\\", "/").split("/").last;
    AppFeedback.success(
      context,
      context.l10n.uiExportComplete2(
        (name).toString(),
        (resolvedPath).toString(),
      ),
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _exportAllGlossary() async {
    final List<GlossaryCategory> categoryTree = _readCategoryTree();
    await _exportGlossaryData(
      defaultName: "glossary_all.json",
      exportTree: categoryTree.map(_copyCategoryNode).toList(),
    );
  }

  Future<void> _exportSelectedGlossary() async {
    if (_selectedCategoryId == null) {
      if (!mounted) return;
      AppFeedback.info(context, "請先選擇類別", duration: const Duration(seconds: 1));
      return;
    }

    final List<GlossaryCategory> categoryTree = _readCategoryTree();

    final List<GlossaryCategory> exportTree =
        _buildExportTreeForSelectedCategory(_selectedCategoryId!, categoryTree);
    if (exportTree.isEmpty) {
      if (!mounted) return;
      AppFeedback.warning(
        context,
        "找不到選取類別",
        duration: const Duration(seconds: 1),
      );
      return;
    }

    final String categoryName = _sanitizeFileNamePart(
      _categoryName(_selectedCategoryId!, categoryTree),
    );
    await _exportGlossaryData(
      defaultName: "glossary_$categoryName.json",
      exportTree: exportTree,
    );
  }

  _GlossaryImportPreviewSummary _buildImportPreviewSummary(
    _GlossaryDecoded imported,
  ) {
    final List<GlossaryCategory> categoryTree = _readCategoryTree();
    final Map<String, GlossaryEntry> entryIndex = _readEntryIndex();
    final List<GlossaryCategory> previewTree = categoryTree
        .map(_copyCategoryNode)
        .toList();
    final Map<String, String> termToResolvedId = {
      for (final MapEntry<String, GlossaryEntry> entry
          in _collectPrimaryEntries(entryIndex).entries)
        _normalizeTerm(entry.value.term): entry.key,
    };

    int newCategoryCount = 0;
    int mergedCategoryCount = 0;
    int newEntryCount = 0;
    int reusedEntryCount = 0;
    int newLinkCount = 0;

    final List<String> newCategorySamples = [];
    final List<String> newEntrySamples = [];

    String resolveEntryId(GlossaryEntry importedEntry) {
      final String normalizedTerm = _normalizeTerm(importedEntry.term);
      final String? existing = termToResolvedId[normalizedTerm];
      if (existing != null) {
        reusedEntryCount++;
        return existing;
      }

      newEntryCount++;
      final String pseudoId = "__import_new_$newEntryCount";
      termToResolvedId[normalizedTerm] = pseudoId;

      if (newEntrySamples.length < 6) {
        final String term = importedEntry.term.trim();
        newEntrySamples.add(term.isEmpty ? context.l10n.uiEmptyEntry : term);
      }
      return pseudoId;
    }

    void walkAndPlan(
      List<GlossaryCategory> incomingNodes,
      List<GlossaryCategory> targetNodes,
    ) {
      for (final GlossaryCategory incoming in incomingNodes) {
        GlossaryCategory? existing;
        for (final GlossaryCategory candidate in targetNodes) {
          if (candidate.name.trim() == incoming.name.trim()) {
            existing = candidate;
            break;
          }
        }

        if (existing == null) {
          existing = GlossaryCategory(
            id: "__preview_${incoming.id}",
            name: incoming.name,
            entryIds: [],
            children: [],
          );
          targetNodes.add(existing);
          newCategoryCount++;
          if (newCategorySamples.length < 6) {
            newCategorySamples.add(
              incoming.name.trim().isEmpty
                  ? context.l10n.uiUnnamedCategory
                  : incoming.name,
            );
          }
        } else {
          mergedCategoryCount++;
        }

        for (final String entryId in incoming.entryIds) {
          final GlossaryEntry? importedEntry = imported.entryIndex[entryId];
          if (importedEntry == null) continue;

          final String resolvedId = resolveEntryId(importedEntry);
          if (!existing.entryIds.contains(resolvedId)) {
            existing.entryIds.add(resolvedId);
            newLinkCount++;
          }
        }

        walkAndPlan(incoming.children, existing.children);
      }
    }

    walkAndPlan(imported.categoryTree, previewTree);

    return _GlossaryImportPreviewSummary(
      newCategoryCount: newCategoryCount,
      mergedCategoryCount: mergedCategoryCount,
      newEntryCount: newEntryCount,
      reusedEntryCount: reusedEntryCount,
      newLinkCount: newLinkCount,
      newCategorySamples: newCategorySamples,
      newEntrySamples: newEntrySamples,
    );
  }

  Future<bool> _showImportPreviewDialog(
    _GlossaryImportPreviewSummary summary,
  ) async {
    final bool? confirmed = await AppDialog.showCustom<bool>(
      context: context,
      builder: (context) {
        return AppDialog(
          title: context.l10n.uiImportPreview,
          icon: Icons.preview_outlined,
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.uiCategoriesToAdd(
                      (summary.newCategoryCount).toString(),
                    ),
                  ),
                  Text(
                    context.l10n.uiCategoriesToMerge(
                      (summary.mergedCategoryCount).toString(),
                    ),
                  ),
                  Text(
                    context.l10n.uiNewEntriesToImport(
                      (summary.newEntryCount).toString(),
                    ),
                  ),
                  Text(
                    context.l10n.uiExistingEntriesToReuse(
                      (summary.reusedEntryCount).toString(),
                    ),
                  ),
                  Text(
                    context.l10n.uiCategoryEntryLinksToAdd(
                      (summary.newLinkCount).toString(),
                    ),
                  ),
                  if (summary.newCategorySamples.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(context.l10n.uiNewCategoriesUpToShown),
                    const SizedBox(height: 4),
                    for (final String item in summary.newCategorySamples)
                      Text("- $item"),
                  ],
                  if (summary.newEntrySamples.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(context.l10n.uiNewEntriesUpToShown),
                    const SizedBox(height: 4),
                    for (final String item in summary.newEntrySamples)
                      Text("- $item"),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.uiConfirmImport),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  Future<void> _importGlossary() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    String? raw;
    final PlatformFile picked = result.files.first;
    if (picked.bytes != null) {
      raw = utf8.decode(picked.bytes!);
    } else if (picked.path != null) {
      raw = await File(picked.path!).readAsString();
    }
    if (!mounted || raw == null || raw.trim().isEmpty) return;

    _GlossaryDecoded imported;
    try {
      imported = _decodeGlossary(raw);
    } catch (_) {
      if (!mounted) return;
      AppFeedback.error(
        context,
        context.l10n.uiInvalidImportFileFormat,
        duration: const Duration(seconds: 1),
      );
      return;
    }

    final _GlossaryImportPreviewSummary preview = _buildImportPreviewSummary(
      imported,
    );
    final bool confirmed = await _showImportPreviewDialog(preview);
    if (!mounted || !confirmed) return;

    int createdCategoryCount = 0;
    int createdEntryCount = 0;
    int reusedEntryCount = 0;
    int linkedEntryCount = 0;

    final List<GlossaryCategory> nextTree = _copyCategoryTree(
      _readCategoryTree(),
    );
    final HashMap<String, GlossaryEntry> nextEntryIndex = _copyEntryIndex(
      _readEntryIndex(),
    );

    GlossaryEntry cloneEntry(GlossaryEntry source, String newId) {
      return source.deepCopy().copyWith(id: newId);
    }

    String? findEntryIdByTermInIndex(String term) {
      final String normalizedTerm = _normalizeTerm(term);
      if (normalizedTerm.isEmpty) {
        return null;
      }
      for (final MapEntry<String, GlossaryEntry> item
          in nextEntryIndex.entries) {
        if (item.key != item.value.id) {
          continue;
        }
        if (_normalizeTerm(item.value.term) == normalizedTerm) {
          return item.value.id;
        }
      }
      return null;
    }

    void mergeNodes(
      List<GlossaryCategory> incomingNodes,
      List<GlossaryCategory> targetNodes,
    ) {
      for (final GlossaryCategory incoming in incomingNodes) {
        GlossaryCategory? existing;
        for (final GlossaryCategory candidate in targetNodes) {
          if (candidate.name.trim() == incoming.name.trim()) {
            existing = candidate;
            break;
          }
        }

        if (existing == null) {
          existing = GlossaryCategory(
            id: _createId(),
            name: incoming.name,
            entryIds: [],
            children: [],
          );
          targetNodes.add(existing);
          createdCategoryCount++;
        }

        for (final String importedEntryId in incoming.entryIds) {
          final GlossaryEntry? importedEntry =
              imported.entryIndex[importedEntryId];
          if (importedEntry == null) {
            continue;
          }

          String resolvedEntryId;
          final String? existingEntryId = findEntryIdByTermInIndex(
            importedEntry.term,
          );
          if (existingEntryId != null) {
            resolvedEntryId = existingEntryId;
            reusedEntryCount++;
          } else {
            resolvedEntryId = _createId();
            nextEntryIndex[resolvedEntryId] = cloneEntry(
              importedEntry,
              resolvedEntryId,
            );
            createdEntryCount++;
          }

          if (!existing.entryIds.contains(resolvedEntryId)) {
            existing.entryIds.add(resolvedEntryId);
            linkedEntryCount++;
          }
        }

        mergeNodes(incoming.children, existing.children);
      }
    }

    mergeNodes(imported.categoryTree, nextTree);

    _glossaryNotifier.setGlossaryState(
      GlossaryStateData(categoryTree: nextTree, entryIndex: nextEntryIndex),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      if (_selectedCategoryId == null && nextTree.isNotEmpty) {
        _selectedCategoryId = nextTree.first.id;
      }
      _restoreSelectionForState(ref.read(glossaryStateProvider));
    });

    if (!mounted) return;
    AppFeedback.success(
      context,
      context.l10n.uiImportCompleteNewCategoriesNewEntriesReusedEntries(
        (createdCategoryCount).toString(),
        (createdEntryCount).toString(),
        (reusedEntryCount).toString(),
        (linkedEntryCount).toString(),
      ),
      duration: const Duration(seconds: 2),
    );
  }

  void _selectCategory(String categoryId) {
    if (_editingCategoryId != null && _editingCategoryId != categoryId) {
      _submitEditingCategory();
    }

    final List<GlossaryCategory> categoryTree = _readCategoryTree();
    final Map<String, GlossaryEntry> entryIndex = _readEntryIndex();

    final List<_CategoryEntryRef> refs = _collectEntryRefs(
      categoryId,
      categoryTree,
    );

    String? nextEntryId;
    for (final _CategoryEntryRef ref in refs) {
      if (entryIndex.containsKey(ref.entryId)) {
        nextEntryId = ref.entryId;
        break;
      }
    }

    setState(() {
      _selectedCategoryId = categoryId;
      _selectedEntryId = nextEntryId;
      _expandedCategoryIds.add(categoryId);
    });
  }

  Future<void> _addCategory({String? parentId}) async {
    final String? name = await _showTextInputDialog(
      title: parentId == null
          ? context.l10n.uiAddCategory
          : context.l10n.uiAddSubcategory,
      hint: context.l10n.uiEnterACategoryName,
    );
    if (!mounted) return;
    if (name == null || name.isEmpty) return;

    final GlossaryCategory newNode = GlossaryCategory(
      id: _createId(),
      name: name,
      entryIds: [],
      children: [],
    );

    bool added = _glossaryNotifier.addCategory(
      category: newNode,
      parentCategoryId: parentId,
    );
    if (!added && parentId != null) {
      added = _glossaryNotifier.addCategory(category: newNode);
    }
    if (!added) {
      return;
    }

    setState(() {
      if (parentId != null) {
        _expandedCategoryIds.add(parentId);
      }
      _selectedCategoryId = newNode.id;
      _selectedEntryId = null;
    });
  }

  void _startEditingCategory(String categoryId) {
    final GlossaryCategory? category = _findCategoryById(
      categoryId,
      _readCategoryTree(),
    );
    if (category == null) return;

    setState(() {
      _editingCategoryId = categoryId;
      _categoryRenameController?.dispose();
      _categoryRenameController = TextEditingController(text: category.name);
    });
  }

  void _submitEditingCategory() {
    final String? editingId = _editingCategoryId;
    final TextEditingController? controller = _categoryRenameController;

    bool changed = false;
    if (editingId != null && controller != null) {
      final String nextName = controller.text.trim();
      if (nextName.isNotEmpty) {
        changed = _glossaryNotifier.renameCategory(
          categoryId: editingId,
          name: nextName,
        );
      }
    }

    setState(() {
      _editingCategoryId = null;
      _categoryRenameController?.dispose();
      _categoryRenameController = null;
    });

    if (!changed) {
      return;
    }
  }

  Future<void> _deleteCategory(String categoryId) async {
    final GlossaryCategory? category = _findCategoryById(
      categoryId,
      _readCategoryTree(),
    );
    if (category == null) return;

    final bool confirmed = await _showConfirmDialog(
      title: context.l10n.uiDeleteCategory,
      message: context.l10n.uiDeleteAndItsSubcategories(
        (category.name).toString(),
      ),
    );
    if (!mounted) return;
    if (!confirmed) return;

    final bool deleted = _glossaryNotifier.deleteCategory(categoryId);
    if (!deleted) {
      return;
    }

    setState(() {
      _expandedCategoryIds.remove(categoryId);
      _restoreSelectionForState(ref.read(glossaryStateProvider));
    });
  }

  void _addEntryByTermToSelectedCategory(String rawTerm) {
    if (_selectedCategoryId == null) return;
    final GlossaryAddEntryResult? result = _glossaryNotifier
        .addEntryByTermToCategory(
          categoryId: _selectedCategoryId!,
          term: rawTerm,
          newEntryId: _createId(),
        );
    if (result == null) {
      return;
    }

    setState(() {
      _selectedEntryId = result.entryId;
    });

    if (!result.createdNewEntry) {
      AppFeedback.info(
        context,
        result.linkedToCategory ? "已連結到同名詞條，共用意義/例句" : "此分類已有同名詞條，已定位到該詞條",
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> _removeEntryFromCategory(_CategoryEntryRef entryRef) async {
    final GlossaryEntry? entry = _readEntryIndex()[entryRef.entryId];
    if (entry == null) return;

    final List<GlossaryCategory> categoryTree = _readCategoryTree();

    final bool confirmed = await _showConfirmDialog(
      title: context.l10n.uiRemoveEntry,
      message: context.l10n.uiRemoveFrom(
        (_categoryName(entryRef.sourceCategoryId, categoryTree)).toString(),
        (entry.term).toString(),
      ),
    );
    if (!mounted) return;
    if (!confirmed) return;

    final bool removed = _glossaryNotifier.removeEntryFromCategory(
      sourceCategoryId: entryRef.sourceCategoryId,
      entryId: entryRef.entryId,
    );
    if (!removed) {
      return;
    }

    setState(() {
      if (_selectedEntryId == entryRef.entryId) {
        _restoreSelectionForState(ref.read(glossaryStateProvider));
      }
    });
  }

  bool _moveEntryToCategory({
    required String entryId,
    required String sourceCategoryId,
    required String targetCategoryId,
    int? targetInsertIndex,
  }) {
    return _glossaryNotifier.moveEntryToCategory(
      entryId: entryId,
      sourceCategoryId: sourceCategoryId,
      targetCategoryId: targetCategoryId,
      targetInsertIndex: targetInsertIndex,
    );
  }

  GlossaryEntry? get _selectedEntry {
    if (_selectedEntryId == null) return null;
    return _readEntryIndex()[_selectedEntryId!];
  }

  void _updateTerm(String entryId, String value) {
    final GlossaryEntry? entry = ref
        .read(glossaryStateProvider)
        .entryIndex[entryId];
    if (entry == null || entry.term == value) return;

    final GlossaryUpdateTermResult result = _glossaryNotifier.updateEntryTerm(
      entryId: entry.id,
      term: value,
    );
    if (!result.changed) {
      return;
    }

    if (result.mergedIntoEntryId != null) {
      setState(() {
        _selectedEntryId = result.mergedIntoEntryId;
      });
      AppFeedback.info(
        context,
        "同名詞條已合併，現在共用同一組意義/例句",
        duration: const Duration(seconds: 1),
      );
    }
  }

  Widget _buildPairEditorList(GlossaryEntry selectedEntry) {
    return Column(
      children: List.generate(selectedEntry.pairs.length, (index) {
        final GlossaryPair pair = selectedEntry.pairs[index];

        return AppSectionCard(
          padding: EdgeInsets.zero,
          useSectionLayout: false,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      context.l10n.uiGroup((index + 1).toString()),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    ItemActionBar(
                      actions: [
                        ItemAction.delete(
                          tooltip: context.l10n.uiDeleteThisGroup,
                          onPressed: selectedEntry.pairs.length <= 1
                              ? null
                              : () => _removePair(index),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AppTextField(
                  key: ValueKey("meaning_${selectedEntry.id}_$index"),
                  initialValue: pair.meaning,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: context.l10n.uiMeaning,
                  ),
                  onChanged: (value) => _scheduleDraftCommit(
                    "meaning:${selectedEntry.id}:$index",
                    () => _updatePairMeaning(selectedEntry.id, index, value),
                  ),
                ),
                const SizedBox(height: 10),
                AppTextField(
                  key: ValueKey("example_${selectedEntry.id}_$index"),
                  initialValue: pair.example,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: context.l10n.uiExample,
                  ),
                  onChanged: (value) => _scheduleDraftCommit(
                    "example:${selectedEntry.id}:$index",
                    () => _updatePairExample(selectedEntry.id, index, value),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _setPolarity(GlossaryPolarity value) {
    final GlossaryEntry? entry = _selectedEntry;
    if (entry == null || entry.polarity == value) return;

    _glossaryNotifier.setEntryPolarity(entryId: entry.id, polarity: value);
  }

  void _setPartOfSpeech(GlossaryPartOfSpeech value) {
    final GlossaryEntry? entry = _selectedEntry;
    if (entry == null || entry.partOfSpeech == value) return;

    _glossaryNotifier.setEntryPartOfSpeech(
      entryId: entry.id,
      partOfSpeech: value,
    );
  }

  void _updateCustomPartOfSpeech(String entryId, String value) {
    final GlossaryEntry? entry = ref
        .read(glossaryStateProvider)
        .entryIndex[entryId];
    if (entry == null) return;

    if (entry.customPartOfSpeech == value) return;

    _glossaryNotifier.setEntryCustomPartOfSpeech(
      entryId: entry.id,
      customPartOfSpeech: value,
    );
  }

  void _updatePairMeaning(String entryId, int index, String value) {
    final GlossaryEntry? entry = ref
        .read(glossaryStateProvider)
        .entryIndex[entryId];
    if (entry == null || index < 0 || index >= entry.pairs.length) return;

    if (entry.pairs[index].meaning == value) return;

    _glossaryNotifier.updateEntryPairMeaning(
      entryId: entry.id,
      pairIndex: index,
      meaning: value,
    );
  }

  void _updatePairExample(String entryId, int index, String value) {
    final GlossaryEntry? entry = ref
        .read(glossaryStateProvider)
        .entryIndex[entryId];
    if (entry == null || index < 0 || index >= entry.pairs.length) return;

    if (entry.pairs[index].example == value) return;

    _glossaryNotifier.updateEntryPairExample(
      entryId: entry.id,
      pairIndex: index,
      example: value,
    );
  }

  void _addPair() {
    final GlossaryEntry? entry = _selectedEntry;
    if (entry == null) return;

    _glossaryNotifier.addEntryPair(entry.id);
  }

  void _removePair(int index) {
    final GlossaryEntry? entry = _selectedEntry;
    if (entry == null || index < 0 || index >= entry.pairs.length) return;
    if (entry.pairs.length <= 1) return;

    _glossaryNotifier.removeEntryPair(entryId: entry.id, pairIndex: index);
  }

  Widget _buildWarningCard() {
    return AppNoticeBanner(
      message: context.l10n.uiThisFeatureIsInDevelopmentAndMayContain,
      tone: AppFeedbackTone.warning,
    );
  }

  Widget _buildCategoryTreeCard(List<GlossaryCategory> categoryTree) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final List<_VisibleCategoryRow> rows = _collectVisibleCategories(
      categoryTree,
    );
    final TextStyle menuTextStyle = Theme.of(context).textTheme.bodySmall!;

    return AppSectionCard(
      padding: EdgeInsets.zero,
      useSectionLayout: false,
      elevation: 0,
      color: scheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: MediumTitle(
                    icon: Icons.folder,
                    text: context.l10n.uiWordCategories,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.uiAddRootCategory,
                  onPressed: () => _addCategory(),
                  icon: const Icon(Icons.create_new_folder_outlined),
                ),
                IconButton(
                  tooltip: context.l10n.uiAddSubcategory,
                  onPressed: _selectedCategoryId == null
                      ? null
                      : () => _addCategory(parentId: _selectedCategoryId),
                  icon: const Icon(Icons.create_new_folder),
                ),
                PopupMenuButton<String>(
                  tooltip: context.l10n.uiImportExport,
                  iconColor: scheme.onSurface,
                  onSelected: (value) {
                    switch (value) {
                      case "import":
                        unawaited(_importGlossary());
                        break;
                      case "export_selected":
                        unawaited(_exportSelectedGlossary());
                        break;
                      case "export_all":
                        unawaited(_exportAllGlossary());
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<String>(
                        value: "import",
                        child: Text(
                          context.l10n.uiImport2,
                          style: menuTextStyle,
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        enabled: false,
                        child: Text(
                          context.l10n.uiExportDisabled,
                          style: menuTextStyle,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: "export_selected",
                        enabled: _selectedCategoryId != null,
                        child: Text(
                          context.l10n.uiExportSelectedCategory,
                          style: menuTextStyle,
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: "export_all",
                        child: Text(
                          context.l10n.uiExportAll,
                          style: menuTextStyle,
                        ),
                      ),
                    ];
                  },
                  icon: Icon(
                    Icons.import_export_outlined,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.uiLongPressCardsToDragReorderOrMove,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            CollectionPanel.builder(
              title: context.l10n.uiWordCategories,
              showSectionCard: false,
              minHeight: 180,
              maxHeight: 420,
              controller: _categoryTreeScrollController,
              showScrollbar: true,
              itemCount: rows.length,
              emptyTitle: context.l10n.uiNoWordCategories,
              emptyDescription: context.l10n.uiAddYourFirstCategory,
              emptyIcon: Icons.create_new_folder_outlined,
              itemBuilder: (BuildContext context, int index) {
                return _buildCategoryRow(rows[index], categoryTree);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(
    _VisibleCategoryRow row,
    List<GlossaryCategory> categoryTree,
  ) {
    final GlossaryCategory category = row.category;
    final bool isSelected = _selectedCategoryId == category.id;
    final bool hasChildren = category.children.isNotEmpty;
    final bool isExpanded = _expandedCategoryIds.contains(category.id);
    final bool isEditing = _editingCategoryId == category.id;
    final int totalEntries = _countSubtreeEntries(category);
    final TextStyle menuTextStyle = Theme.of(context).textTheme.bodySmall!;

    return DraggableCardNode<Object>(
      key: ValueKey(category.id),
      dragData: _GlossaryCategoryDragData(
        categoryId: category.id,
        categoryName: category.name,
      ),
      nodeId: category.id,
      nodeType: hasChildren ? NodeType.folder : NodeType.item,
      leading: Icon(
        hasChildren ? Icons.folder_copy_outlined : Icons.folder_open_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: InlineEditableText(
        value: category.name,
        controller: _categoryRenameController,
        isEditing: isEditing,
        onEdit: () => _startEditingCategory(category.id),
        onSubmitted: (_) => _submitEditingCategory(),
        onTapOutside: (_) => _submitEditingCategory(),
        emptyText: context.l10n.uiUnnamedCategory2,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        context.l10n.uiEntries((totalEntries).toString()),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: PopupMenuButton<String>(
        tooltip: context.l10n.uiCategoryActions,
        onSelected: (value) {
          if (value == "rename") {
            _startEditingCategory(category.id);
            return;
          }
          if (value == "delete") {
            _deleteCategory(category.id);
            return;
          }
          if (value == "toggle") {
            setState(() {
              if (isExpanded) {
                _expandedCategoryIds.remove(category.id);
              } else {
                _expandedCategoryIds.add(category.id);
              }
            });
          }
        },
        itemBuilder: (context) {
          return [
            if (hasChildren)
              PopupMenuItem<String>(
                value: "toggle",
                child: Text(
                  isExpanded
                      ? context.l10n.uiCollapseSubcategories
                      : context.l10n.uiExpandSubcategories,
                  style: menuTextStyle,
                ),
              ),
            PopupMenuItem<String>(
              value: "rename",
              child: Text(context.l10n.uiRename, style: menuTextStyle),
            ),
            PopupMenuItem<String>(
              value: "delete",
              child: Text(context.l10n.uiDeleteCategory, style: menuTextStyle),
            ),
          ];
        },
        icon: const Icon(Icons.more_horiz),
      ),
      isSelected: isSelected,
      isDragging: _isDragging,
      isThisDragging: _draggingCategoryId == category.id,
      isDragForbidden:
          _draggingCategoryId != null &&
          _isDescendantCategory(
            _draggingCategoryId!,
            category.id,
            categoryTree,
          ),
      onClicked: () => _selectCategory(category.id),
      onDragStarted: () {
        if (_editingCategoryId != null) {
          _submitEditingCategory();
        }
        setState(() {
          _isDragging = true;
          _draggingCategoryId = category.id;
          _draggingEntryId = null;
          _draggingEntrySourceCategoryId = null;
        });
      },
      onDragEnd: () {
        setState(() {
          _isDragging = false;
          _draggingCategoryId = null;
          _draggingEntryId = null;
          _draggingEntrySourceCategoryId = null;
        });
      },
      onWillAccept: (data, position) {
        if (data is _GlossaryCategoryDragData) {
          if (data.categoryId == category.id) return false;
          if (_isDescendantCategory(
            data.categoryId,
            category.id,
            categoryTree,
          )) {
            return false;
          }
          return true;
        }
        if (data is _GlossaryEntryDragData) {
          return position == DropPosition.child;
        }
        return false;
      },
      onAccept: (data, position) {
        if (data is _GlossaryCategoryDragData) {
          _moveCategoryTo(data.categoryId, category.id, position);
          final String actionText = switch (position) {
            DropPosition.before => context.l10n.uiMoveBefore,
            DropPosition.child => context.l10n.uiMoveToSubcategory,
            DropPosition.after => context.l10n.uiMoveAfter,
          };
          AppFeedback.success(
            context,
            context.l10n.uiLiteral2(
              (data.categoryName).toString(),
              (actionText).toString(),
            ),
            duration: const Duration(seconds: 1),
          );
          return;
        }

        if (data is _GlossaryEntryDragData && position == DropPosition.child) {
          final bool moved = _moveEntryToCategory(
            entryId: data.entryId,
            sourceCategoryId: data.sourceCategoryId,
            targetCategoryId: category.id,
          );
          if (moved) {
            AppFeedback.success(
              context,
              context.l10n.uiMovedInto(
                (data.entryTerm).toString(),
                (category.name).toString(),
              ),
              duration: const Duration(seconds: 1),
            );
          }
        }
      },
      getDropZoneSize: (position) {
        if (_draggingEntryId != null) {
          return position == DropPosition.child ? 1.0 : 0.0;
        }
        switch (position) {
          case DropPosition.before:
            return 0.3;
          case DropPosition.child:
            return 0.4;
          case DropPosition.after:
            return 0.3;
        }
      },
      indent: row.depth * 16.0,
    );
  }

  Widget _buildEntryListCard(
    List<GlossaryCategory> categoryTree,
    Map<String, GlossaryEntry> entryIndex,
  ) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    if (_selectedCategoryId == null) {
      return AppSectionCard(
        title: context.l10n.uiWordEntries,
        icon: Icons.format_list_bulleted,
        child: AppEmptyState(
          title: context.l10n.uiSelectAWordCategoryFirst,
          icon: Icons.touch_app_outlined,
          compact: true,
        ),
      );
    }

    final List<_CategoryEntryRef> refs = _collectEntryRefs(
      _selectedCategoryId!,
      categoryTree,
    );
    final List<_CategoryEntryRef> visibleRefs = refs
        .where((ref) => entryIndex.containsKey(ref.entryId))
        .toList();

    return AppSectionCard(
      padding: EdgeInsets.zero,
      useSectionLayout: false,
      elevation: 0,
      color: scheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediumTitle(
              icon: Icons.format_list_bulleted,
              text: context.l10n.uiWordEntries,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.uiLongPressEntriesToDragReorderOrMove,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            CollectionPanel.builder(
              title: context.l10n.uiWordEntries,
              showSectionCard: false,
              minHeight: 180,
              maxHeight: 320,
              controller: _entryListScrollController,
              showScrollbar: true,
              itemCount: visibleRefs.length,
              emptyTitle: context.l10n.uiThisCategoryHasNoEntries,
              emptyDescription: context.l10n.uiAddYourFirstEntry,
              emptyIcon: Icons.menu_book_outlined,
              footer: AddItemInput(
                title: context.l10n.uiEntryName,
                onAdd: _addEntryByTermToSelectedCategory,
              ),
              itemBuilder: (BuildContext context, int index) {
                return _buildEntryRow(
                  visibleRefs[index],
                  categoryTree,
                  entryIndex,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryRow(
    _CategoryEntryRef ref,
    List<GlossaryCategory> categoryTree,
    Map<String, GlossaryEntry> entryIndex,
  ) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final GlossaryEntry? entry = entryIndex[ref.entryId];
    if (entry == null) {
      return const SizedBox.shrink();
    }

    final bool isSelected = _selectedEntryId == entry.id;
    final String summary = entry.pairs.isEmpty
        ? context.l10n.uiNoMeaningEnteredYet
        : (entry.pairs.first.meaning.trim().isEmpty
              ? context.l10n.uiNoMeaningEnteredYet
              : entry.pairs.first.meaning);

    return DraggableCardNode<Object>(
      key: ValueKey("${ref.sourceCategoryId}_${entry.id}"),
      dragData: _GlossaryEntryDragData(
        entryId: entry.id,
        entryTerm: entry.term,
        sourceCategoryId: ref.sourceCategoryId,
      ),
      nodeId: "${ref.sourceCategoryId}_${entry.id}",
      nodeType: NodeType.item,
      leading: Icon(entry.polarity.icon, color: entry.polarity.color(scheme)),
      title: Text(
        entry.term,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(summary, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(
            context.l10n.uiPartOfSpeech(
              (_resolvePartOfSpeechLabel(entry)).toString(),
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Text(
            ref.isLocal
                ? context.l10n.uiSourceThisCategory
                : context.l10n.uiSourceSubcategory(
                    (_categoryName(
                      ref.sourceCategoryId,
                      categoryTree,
                    )).toString(),
                  ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: IconButton(
        tooltip: context.l10n.uiRemoveFromThisCategory,
        icon: const Icon(Icons.remove_circle_outline),
        onPressed: () => _removeEntryFromCategory(ref),
      ),
      isSelected: isSelected,
      isDragging: _isDragging,
      isThisDragging:
          _draggingEntryId == entry.id &&
          _draggingEntrySourceCategoryId == ref.sourceCategoryId,
      onClicked: () {
        setState(() {
          _selectedEntryId = entry.id;
        });
      },
      onDragStarted: () {
        if (_editingCategoryId != null) {
          _submitEditingCategory();
        }
        setState(() {
          _isDragging = true;
          _draggingCategoryId = null;
          _draggingEntryId = entry.id;
          _draggingEntrySourceCategoryId = ref.sourceCategoryId;
        });
      },
      onDragEnd: () {
        setState(() {
          _isDragging = false;
          _draggingCategoryId = null;
          _draggingEntryId = null;
          _draggingEntrySourceCategoryId = null;
        });
      },
      onWillAccept: (data, position) {
        if (data is! _GlossaryEntryDragData) return false;
        if (position == DropPosition.child) return false;
        if (data.entryId == ref.entryId &&
            data.sourceCategoryId == ref.sourceCategoryId) {
          return false;
        }
        return true;
      },
      onAccept: (data, position) {
        if (data is! _GlossaryEntryDragData) return;
        if (position == DropPosition.child) return;

        final GlossaryCategory? targetCategory = _findCategoryById(
          ref.sourceCategoryId,
          categoryTree,
        );
        if (targetCategory == null) return;

        final int anchorIndex = targetCategory.entryIds.indexOf(ref.entryId);
        if (anchorIndex < 0) return;

        final int targetIndex = position == DropPosition.before
            ? anchorIndex
            : anchorIndex + 1;

        final bool moved = _moveEntryToCategory(
          entryId: data.entryId,
          sourceCategoryId: data.sourceCategoryId,
          targetCategoryId: ref.sourceCategoryId,
          targetInsertIndex: targetIndex,
        );

        if (moved) {
          final String destination = _categoryName(
            ref.sourceCategoryId,
            categoryTree,
          );
          AppFeedback.success(
            context,
            context.l10n.uiMovedTo(
              (data.entryTerm).toString(),
              (destination).toString(),
            ),
            duration: const Duration(seconds: 1),
          );
        }
      },
      getDropZoneSize: (position) {
        if (_draggingEntryId == null) return 0.0;
        return position == DropPosition.child ? 0.0 : 0.5;
      },
    );
  }

  Widget _buildEntryEditorCard(Map<String, GlossaryEntry> entryIndex) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final GlossaryEntry? selectedEntry = _selectedEntryId == null
        ? null
        : entryIndex[_selectedEntryId!];

    return AppSectionCard(
      padding: EdgeInsets.zero,
      useSectionLayout: false,
      elevation: 0,
      color: scheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediumTitle(
              icon: Icons.library_books,
              text: context.l10n.uiMeaningsAndExamples,
            ),
            const SizedBox(height: 12),
            if (selectedEntry == null)
              Text(
                context.l10n.uiSelectAnEntryAbove,
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else ...[
              AppTextField(
                key: ValueKey("term_${selectedEntry.id}"),
                initialValue: selectedEntry.term,
                decoration: InputDecoration(
                  labelText: context.l10n.uiEntryName,
                ),
                onChanged: (value) => _scheduleDraftCommit(
                  "term:${selectedEntry.id}",
                  () => _updateTerm(selectedEntry.id, value),
                ),
              ),
              const SizedBox(height: 12),
              AppDropdownField<GlossaryPartOfSpeech>(
                key: ValueKey("part_of_speech_${selectedEntry.id}"),
                value: selectedEntry.partOfSpeech,
                labelText: context.l10n.uiPartOfSpeech2,
                textStyle: Theme.of(context).textTheme.bodySmall,
                options: GlossaryPartOfSpeech.values.map((partOfSpeech) {
                  return DropdownOption<GlossaryPartOfSpeech>(
                    value: partOfSpeech,
                    label: context.l10n.legacyLabel(partOfSpeech.label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _setPartOfSpeech(value);
                  }
                },
              ),
              if (selectedEntry.partOfSpeech ==
                  GlossaryPartOfSpeech.custom) ...[
                const SizedBox(height: 12),
                AppTextField(
                  key: ValueKey("custom_pos_${selectedEntry.id}"),
                  initialValue: selectedEntry.customPartOfSpeech,
                  decoration: InputDecoration(
                    labelText: context.l10n.uiCustomPartOfSpeech,
                  ),
                  onChanged: (value) => _scheduleDraftCommit(
                    "partOfSpeech:${selectedEntry.id}",
                    () => _updateCustomPartOfSpeech(selectedEntry.id, value),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              AppDropdownField<GlossaryPolarity>(
                key: ValueKey("polarity_${selectedEntry.id}"),
                value: selectedEntry.polarity,
                labelText: context.l10n.uiSentiment,
                textStyle: Theme.of(context).textTheme.bodySmall,
                options: GlossaryPolarity.values.map((polarity) {
                  return DropdownOption<GlossaryPolarity>(
                    value: polarity,
                    label: context.l10n.legacyLabel(polarity.label),
                    child: Row(
                      children: [
                        Icon(
                          polarity.icon,
                          size: 18,
                          color: polarity.color(scheme),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          context.l10n.legacyLabel(polarity.label),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _setPolarity(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    context.l10n.uiMeaningAndExampleGroups,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _addPair,
                    icon: const Icon(Icons.add),
                    label: Text(context.l10n.uiAddGroup),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildPairEditorList(selectedEntry),
            ],
          ],
        ),
      ),
    );
  }

  // MARK: - UI 介面建構
  @override
  Widget build(BuildContext context) {
    final List<GlossaryCategory> categoryTree = ref.watch(
      glossaryStateProvider.select(
        (glossaryState) => glossaryState.categoryTree,
      ),
    );
    final Map<String, GlossaryEntry> entryIndex = ref.watch(
      glossaryStateProvider.select((glossaryState) => glossaryState.entryIndex),
    );
    if (!identical(categoryTree, _indexedCategoryTree)) {
      _rebuildCategoryIndex(categoryTree);
    }

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_loadError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 36),
                const SizedBox(height: 12),
                Text(context.l10n.uiCouldNotLoadWordData),
                const SizedBox(height: 8),
                Text(
                  _loadError!,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadGlossary,
                  child: Text(context.l10n.commonRetry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: AppPageScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: LargeTitle(
                icon: Icons.library_books_outlined,
                text: context.l10n.uiWordReference,
              ),
            ),
            const SizedBox(height: 32),
            _buildWarningCard(),
            const SizedBox(height: 20),
            ResponsiveSplitView(
              breakpoint: 980,
              spacing: 12,
              primaryFlex: 1,
              secondaryFlex: 2,
              primary: _buildCategoryTreeCard(categoryTree),
              secondary: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildEntryListCard(categoryTree, entryIndex),
                  const SizedBox(height: 12),
                  _buildEntryEditorCard(entryIndex),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
