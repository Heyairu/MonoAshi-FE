import "../../models/project_operation_error.dart";
import "../../models/project_data.dart";
import "../../models/chapter_selection_data.dart";
import "../../models/world_settings_data.dart";
import "export_models.dart";

/// Guards serializer/codec resources, not the logical chapter schema.
const exportMaximumDepth = 256;

Map<SelectiveProjectModule, List<ExportSelectionNode>> buildExportSelections(
  ProjectData data,
) {
  final seen = <String>{};
  final chapterIds = <String>{};
  ExportSelectionNode node(
    String key,
    String name,
    String kind, [
    List<ExportSelectionNode> children = const [],
    bool selectable = true,
    String? summary,
  ]) {
    if (!seen.add(key))
      throw ProjectValidationException(
        ProjectErrorCode.duplicateIdentity,
        "重複的匯出項目 ID：$key",
      );
    return ExportSelectionNode(
      key: key,
      label: name.isEmpty ? "未命名" : name,
      kind: kind,
      children: children,
      selectable: selectable,
      summary: summary,
    );
  }

  ExportSelectionNode folder(SegmentData value, int depth) {
    if (depth > exportMaximumDepth) {
      throw const ProjectValidationException(
        ProjectErrorCode.treeTooDeep,
        "章節樹超出匯出資源限制（256 層），請減少巢狀深度。",
      );
    }
    for (final id in [
      value.segmentUUID,
      ...value.chapters.map((c) => c.chapterUUID),
    ]) {
      if (id.isEmpty || !chapterIds.add(id)) {
        throw const ProjectValidationException(
          ProjectErrorCode.duplicateIdentity,
          "章節樹含空白或重複 ID，請修復後再匯出。",
        );
      }
    }
    final folders = {
      for (final child in value.childSegments) child.segmentUUID: child,
    };
    final chapters = {
      for (final child in value.chapters) child.chapterUUID: child,
    };
    final children = <ExportSelectionNode>[];
    for (final id in value.resolvedChildNodeOrder) {
      if (folders[id] case final child?) {
        children.add(folder(child, depth + 1));
      } else if (chapters[id] case final chapter?) {
        children.add(node("chapter:$id", chapter.chapterName, "文稿"));
      }
    }
    return node(
      "folder:${value.segmentUUID}",
      value.segmentName,
      "資料夾",
      children,
    );
  }

  ExportSelectionNode location(LocationData value, int depth) {
    if (depth > exportMaximumDepth) {
      throw const ProjectValidationException(
        ProjectErrorCode.treeTooDeep,
        "地點樹超出匯出資源限制（256 層）。",
      );
    }
    return node(
      "location:${value.id}",
      value.localName,
      switch (value.nodeType) {
        WorldNodeType.location => "地點",
        WorldNodeType.organization => "組織",
        WorldNodeType.rule => "規則",
        WorldNodeType.item => "物品",
      },
      [for (final child in value.child) location(child, depth + 1)],
    );
  }

  final categories = <String, List<ExportSelectionNode>>{};
  for (final entry in data.itemClasses.values) {
    final category = entry.category.trim().isEmpty ? "未分類" : entry.category;
    categories
        .putIfAbsent(category, () => [])
        .add(
          node(
            "class:${entry.classId}",
            "${entry.name}${entry.archived ? "（封存）" : ""}",
            "物品定義",
            [
              for (final instance in data.itemInstances.values.where(
                (i) => i.classId == entry.classId,
              ))
                node(
                  "instance:${instance.instanceId}",
                  "${instance.name}${instance.archived ? "（封存）" : ""}",
                  "實例",
                ),
            ],
          ),
        );
  }
  final orphaned = data.itemInstances.values
      .where((i) => !data.itemClasses.containsKey(i.classId))
      .toList();
  if (orphaned.isNotEmpty) {
    categories["缺少物品定義"] = [
      for (final i in orphaned)
        node("instance:${i.instanceId}", i.name, "實例（缺少定義）"),
    ];
  }
  return {
    SelectiveProjectModule.chapters: [
      for (final root in data.segmentsData) folder(root, 1),
    ],
    SelectiveProjectModule.outline: [
      for (final storyline in data.outlineData)
        node(
          "storyline:${storyline.chapterUUID}",
          storyline.storylineName,
          "大箱",
          [
            for (final event in storyline.scenes)
              node("event:${event.storyEventUUID}", event.storyEvent, "中箱", [
                for (final scene in event.scenes)
                  node("scene:${scene.sceneUUID}", scene.sceneName, "小箱"),
              ]),
          ],
        ),
    ],
    SelectiveProjectModule.characters: [
      for (final entry in data.characterData.entries)
        node(
          "character:${entry.key}",
          entry.value.displayName,
          "角色",
          [],
          true,
          [
                entry.value.roleOrOccupation,
                entry.value.appearanceSummary,
                entry.value.personalitySummary,
              ].where((v) => v.isNotEmpty).join(" · ").isEmpty
              ? "未填寫角色摘要"
              : [
                  entry.value.roleOrOccupation,
                  entry.value.appearanceSummary,
                  entry.value.personalitySummary,
                ].where((v) => v.isNotEmpty).join(" · "),
        ),
    ],
    SelectiveProjectModule.worldSettings: [
      for (final root in data.worldSettingsData) location(root, 1),
    ],
    SelectiveProjectModule.items: [
      for (final category in categories.entries)
        node(
          "category:${category.key}",
          category.key,
          "分類",
          category.value,
          false,
        ),
    ],
  };
}
