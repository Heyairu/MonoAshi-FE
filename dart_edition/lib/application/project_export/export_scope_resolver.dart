import "../../models/project_data.dart";
import "../../models/chapter_selection_data.dart";
import "../../models/outline_data.dart";
import "../../models/world_settings_data.dart";
import "../../models/item_data.dart";
import "../../presentation/providers/project_snapshot_utils.dart";
import "export_models.dart";
import "export_selection.dart";

class ResolvedExportScope {
  final ProjectData data;
  final Map<SelectiveProjectModule, Set<String>> partial;
  final Map<SelectiveProjectModule, Set<String>> structural;
  final Map<SelectiveProjectModule, Set<String>> dependencies;
  final List<String> warnings;
  const ResolvedExportScope(
    this.data,
    this.partial,
    this.structural,
    this.dependencies,
    this.warnings,
  );
}

ResolvedExportScope resolveExportScope(
  ProjectData source,
  ExportRequest request,
) {
  // Validate identity/depth before the snapshot's recursive codecs are reached.
  final trees = buildExportSelections(source);
  final data = snapshotProjectData(source);
  final partial = <SelectiveProjectModule, Set<String>>{};
  final structural = <SelectiveProjectModule, Set<String>>{};
  final dependencies = <SelectiveProjectModule, Set<String>>{};
  final warnings = <String>[];
  for (final module in request.modules) {
    final selected = request.selections[module];
    if (selected == null) continue;
    final all = {
      for (final root in trees[module] ?? <ExportSelectionNode>[])
        ...root.selectableKeys,
    };
    if (!all.containsAll(selected)) {
      throw FormatException("${module.label}含已移除或無效的選取項目。");
    }
    if (selected.isEmpty) throw FormatException("請至少選取一個${module.label}項目。");
    if (selected.length != all.length) partial[module] = selected;
  }
  bool keep(SelectiveProjectModule module, String key) =>
      !partial.containsKey(module) || partial[module]!.contains(key);
  void ancestor(SelectiveProjectModule module, String key) =>
      structural.putIfAbsent(module, () => {}).add(key);

  const chapters = SelectiveProjectModule.chapters;
  if (partial.containsKey(chapters)) {
    SegmentData? prune(SegmentData folder) {
      final children = folder.childSegments
          .map(prune)
          .whereType<SegmentData>()
          .toList();
      final manuscripts = folder.chapters
          .where((c) => keep(chapters, "chapter:${c.chapterUUID}"))
          .toList();
      final own = keep(chapters, "folder:${folder.segmentUUID}");
      if (!own && children.isEmpty && manuscripts.isEmpty) return null;
      if (!own) ancestor(chapters, "folder:${folder.segmentUUID}");
      final ids = {
        ...children.map((c) => c.segmentUUID),
        ...manuscripts.map((c) => c.chapterUUID),
      };
      return folder.copyWith(
        chapters: manuscripts,
        childSegments: children,
        childNodeOrder: folder.resolvedChildNodeOrder
            .where(ids.contains)
            .toList(),
      );
    }

    data.segmentsData = data.segmentsData
        .map(prune)
        .whereType<SegmentData>()
        .toList();
  }

  const outline = SelectiveProjectModule.outline;
  if (partial.containsKey(outline)) {
    final lines = <StorylineData>[];
    for (final line in data.outlineData) {
      final events = <StoryEventData>[];
      for (final event in line.scenes) {
        final scenes = event.scenes
            .where((s) => keep(outline, "scene:${s.sceneUUID}"))
            .toList();
        final own = keep(outline, "event:${event.storyEventUUID}");
        if (!own && scenes.isEmpty) continue;
        if (!own) ancestor(outline, "event:${event.storyEventUUID}");
        events.add(
          own
              ? event.copyWith(scenes: scenes)
              : StoryEventData(
                  storyEventUUID: event.storyEventUUID,
                  storyEvent: event.storyEvent,
                  scenes: scenes,
                ),
        );
      }
      final own = keep(outline, "storyline:${line.chapterUUID}");
      if (!own && events.isEmpty) continue;
      if (!own) ancestor(outline, "storyline:${line.chapterUUID}");
      lines.add(
        own
            ? line.copyWith(scenes: events)
            : StorylineData(
                chapterUUID: line.chapterUUID,
                storylineName: line.storylineName,
                storylineType: line.storylineType,
                scenes: events,
              ),
      );
    }
    data.outlineData = lines;
    final sceneIds = {
      for (final l in lines)
        for (final e in l.scenes)
          for (final s in e.scenes) s.sceneUUID,
    };
    final placements = data.timelineDocument.placements
        .where(
          (p) => p.sceneUUID != null
              ? sceneIds.contains(p.sceneUUID)
              : p.eventUUID != null
              ? keep(outline, "event:${p.eventUUID}")
              : p.storylineUUID != null &&
                    keep(outline, "storyline:${p.storylineUUID}"),
        )
        .toList();
    final placementIds = placements.map((p) => p.placementUUID).toSet();
    final trackIds = placements.map((p) => p.trackUUID).toSet();
    data.timelineDocument = data.timelineDocument.copyWith(
      placements: placements
          .map(
            (p) => placementIds.contains(p.parentPlacementUUID)
                ? p
                : p.copyWith(parentPlacementUUID: null),
          )
          .toList(),
      tracks: data.timelineDocument.tracks
          .where((t) => trackIds.contains(t.trackUUID))
          .toList(),
    );
    data.outlineChapterLinks = data.outlineChapterLinks
        .where((l) => sceneIds.contains(l.sceneUUID))
        .toList();
  }

  const locations = SelectiveProjectModule.worldSettings;
  if (partial.containsKey(locations)) {
    LocationData? prune(LocationData value) {
      final children = value.child
          .map(prune)
          .whereType<LocationData>()
          .toList();
      if (keep(locations, "location:${value.id}")) {
        return value.copyWith(child: children);
      }
      if (children.isEmpty) return null;
      ancestor(locations, "location:${value.id}");
      return LocationData.raw(
        id: value.id,
        localName: value.localName,
        localType: value.localType,
        nodeType: value.nodeType,
        child: children,
      );
    }

    data.worldSettingsData = data.worldSettingsData
        .map(prune)
        .whereType<LocationData>()
        .toList();
    data.locationStateChanges = data.locationStateChanges
        .where((c) => keep(locations, "location:${c.locationId}"))
        .toList();
  }

  const characters = SelectiveProjectModule.characters;
  if (partial.containsKey(characters)) {
    data.characterData = Map.fromEntries(
      data.characterData.entries.where(
        (e) => keep(characters, "character:${e.key}"),
      ),
    );
    data.characterStates = data.characterStates
        .where((s) => keep(characters, "character:${s.characterId}"))
        .toList();
    data.characterStateBaselines = Map.fromEntries(
      data.characterStateBaselines.entries.where(
        (e) => keep(characters, "character:${e.key}"),
      ),
    );
    data.characterStateChanges = data.characterStateChanges
        .where((s) => keep(characters, "character:${s.characterId}"))
        .toList();
  }

  const items = SelectiveProjectModule.items;
  if (partial.containsKey(items)) {
    final instances = Map.fromEntries(
      data.itemInstances.entries.where((e) => keep(items, "instance:${e.key}")),
    );
    final classIds = {
      for (final c in data.itemClasses.values)
        if (keep(items, "class:${c.classId}")) c.classId,
    };
    for (final instance in instances.values) {
      if (!data.itemClasses.containsKey(instance.classId)) {
        throw FormatException("物品「${instance.name}」缺少定義，無法匯出。");
      }
      if (classIds.add(instance.classId)) {
        dependencies
            .putIfAbsent(items, () => {})
            .add("class:${instance.classId}");
        warnings.add(
          "實例「${instance.name}」附帶必要物品定義「${data.itemClasses[instance.classId]!.name}」。",
        );
      }
    }
    data.itemClasses = Map.fromEntries(
      data.itemClasses.entries.where((e) => classIds.contains(e.key)),
    );
    data.itemInstances = instances;
    data.itemClassStateChanges = data.itemClassStateChanges
        .where((c) => keep(items, "class:${c.classId}"))
        .toList();
    data.itemInstanceStateChanges = data.itemInstanceStateChanges
        .where((c) => instances.containsKey(c.instanceId))
        .toList();
    data.itemRelations = data.itemRelations
        .where(
          (r) => r.itemKind == ItemReferenceKind.instance
              ? instances.containsKey(r.itemId)
              : keep(items, "class:${r.itemId}"),
        )
        .toList();
  }

  if (request.purpose == ExportPurpose.exchange) {
    final scenes = request.modules.contains(outline)
        ? {
            for (final l in data.outlineData)
              for (final e in l.scenes)
                for (final s in e.scenes) s.sceneUUID,
          }
        : <String>{};
    final missingScenes = <String>{
      if (request.modules.contains(characters))
        ...data.characterStateChanges.map((c) => c.sceneUUID),
      if (request.modules.contains(locations))
        ...data.locationStateChanges.map((c) => c.sceneUUID),
      if (request.modules.contains(items))
        ...data.itemClassStateChanges.map((c) => c.sceneUUID),
      if (request.modules.contains(items))
        ...data.itemInstanceStateChanges.map((c) => c.sceneUUID),
    }..removeAll(scenes);
    if (missingScenes.isNotEmpty) {
      warnings.add("${missingScenes.length} 個快照場景參照未包含於所選大綱，匯入後可能需要修復。");
    }
    if (request.modules.contains(outline)) {
      final exportedChapters = request.modules.contains(chapters)
          ? ChapterTree.chaptersDepthFirst(
              data.segmentsData,
            ).map((c) => c.chapter.chapterUUID).toSet()
          : <String>{};
      final missingLinks = data.outlineChapterLinks
          .where((l) => !exportedChapters.contains(l.chapterUUID))
          .length;
      if (missingLinks > 0) {
        warnings.add("$missingLinks 筆大綱章節連結的文稿不在匯出範圍，匯入後可能需要重新連結。");
      }
    }
    if (partial.isNotEmpty) {
      warnings.add(
        "這是細項 XML；匯入目前版本會替換所選模組，不會依 ID 合併。舊版 App 可能忽略細項範圍，請先備份；含結構祖先或必要依賴時，請匯入空白專案。",
      );
    }
    if (request.modules.contains(SelectiveProjectModule.phrases)) {
      warnings.add("短語的 Mention 可能需要在目標專案重新連結。");
    }
  }
  return ResolvedExportScope(data, partial, structural, dependencies, warnings);
}
