import "dart:convert";
import "dart:typed_data";

import "package:archive/archive.dart";
import "package:characters/characters.dart";
import "package:xml/xml.dart";

import "../../bin/file.dart";
import "../../features/inline_annotations/inline_annotation_projection.dart";
import "../../models/chapter_selection_data.dart";
import "../../models/character_snapshot_data.dart";
import "../../models/world_settings_data.dart";
import "export_models.dart";
import "export_scope_resolver.dart";

const exportModuleTypes = <SelectiveProjectModule, Set<String>>{
  SelectiveProjectModule.baseInfo: {"BaseInfo"},
  SelectiveProjectModule.chapters: {"ChapterSelection"},
  SelectiveProjectModule.outline: {"Outline", "Timeline"},
  SelectiveProjectModule.plans: {"PlanSettings"},
  SelectiveProjectModule.worldSettings: {
    "WorldSettings",
    "LocationStateChanges",
  },
  SelectiveProjectModule.characters: {
    "Characters",
    "CharacterStates",
    "CharacterStateBaselines",
    "CharacterStateChanges",
  },
  SelectiveProjectModule.items: {
    "ItemClasses",
    "ItemInstances",
    "ItemRelations",
    "ItemClassStateChanges",
    "ItemInstanceStateChanges",
  },
  SelectiveProjectModule.phrases: {"Phrases", "PhrasesRecovery"},
};

String safeExportName(String name) {
  var value = name
      .replaceAll(RegExp(r'[\x00-\x1f\x7f/\\:*?"<>|]'), "_")
      .replaceAll(RegExp(r"[. ]+$"), "")
      .trim();
  final buffer = StringBuffer();
  for (final rune in value.characters.take(60)) {
    if (utf8.encode("$buffer$rune").length > 120) break;
    buffer.write(rune);
  }
  value = buffer.toString();
  if (value.isEmpty || value == "." || value == "..") value = "未命名";
  if (RegExp(
    r"^(con|prn|aux|nul|com[1-9]|lpt[1-9])(?:\.|$)",
    caseSensitive: false,
  ).hasMatch(value)) {
    value = "_$value";
  }
  return value;
}

String readerExportText(String value) =>
    InlineAnnotationProjection.readerTextFromRaw(value);
String _unresolvedLabel(String value) =>
    RegExp(
      r"^(?:(?:class|instance):)?[0-9a-fA-F]{8}-[0-9a-fA-F-]{27,}$",
    ).hasMatch(value)
    ? "未解析參照"
    : value;
String _escape(String text) => text.replaceAllMapped(
  RegExp(r"[\\`*_{}\[\]()<>#+.!|~\-]"),
  (m) => "\\${m[0]}",
);

PreparedExport prepareProjectExport((ProjectData, ExportRequest) input) =>
    const ProjectExportService().prepare(input.$1, input.$2);

class ProjectExportService {
  const ProjectExportService();

  PreparedExport prepare(ProjectData source, ExportRequest request) {
    if (!request.format.available) throw const FormatException("此匯出格式尚未開放。");
    final valid = switch (request.purpose) {
      ExportPurpose.manuscript =>
        request.format == ExportFormat.txt ||
            request.format == ExportFormat.markdown,
      ExportPurpose.reference => request.format == ExportFormat.markdown,
      ExportPurpose.exchange => request.format == ExportFormat.xml,
    };
    if (!valid ||
        request.modules.isEmpty ||
        (request.purpose == ExportPurpose.manuscript &&
            (request.modules.length != 1 ||
                !request.modules.contains(SelectiveProjectModule.chapters)))) {
      throw const FormatException("匯出用途、格式或範圍不相容。");
    }
    final scope = resolveExportScope(source, request);
    final data = scope.data;
    final warnings = [...scope.warnings];
    final documents = <ExportDocument>[];
    ExportDocument document(
      String path,
      List<String> logical,
      String content,
    ) => ExportDocument(
      path: path,
      logicalPath: logical,
      bytes: Uint8List.fromList(utf8.encode(content)),
      preview: content.length > 12000
          ? "${content.characters.take(12000).toString()}\n…（預覽節錄）"
          : content,
    );
    if (request.purpose == ExportPurpose.manuscript) {
      final entries = _manuscripts(data.segmentsData, source.segmentsData);
      if (entries.isEmpty) throw const FormatException("所選範圍沒有文稿，請重新選取。");
      final markdown = request.format == ExportFormat.markdown;
      String text(String value) =>
          markdown ? _escape(readerExportText(value)) : readerExportText(value);
      String bookInfo() =>
          "${text(data.baseInfoData.bookName)}\n${text(data.baseInfoData.author)}\n\n";
      if (request.packaging == ExportPackaging.singleFile) {
        final buffer = StringBuffer();
        if (request.includeBookInfo) buffer.write(bookInfo());
        List<String> previous = [];
        for (final entry in entries) {
          if (request.includeHeadings) {
            for (var i = 0; i < entry.names.length; i++) {
              if (i < previous.length &&
                  previous.take(i + 1).join("/") ==
                      entry.ids.take(i + 1).join("/")) {
                continue;
              }
              if (markdown && i < 6) {
                buffer.writeln("${"#" * (i + 1)} ${text(entry.names[i])}\n");
              } else {
                buffer.writeln(
                  "${text(entry.names.take(i + 1).join(" / "))}\n${markdown ? "---" : "────"}\n",
                );
              }
            }
          }
          buffer.writeln("${text(entry.chapter.chapterContent)}\n");
          previous = entry.ids;
        }
        documents.add(
          document("正文.${request.format.extension}", ["正文"], buffer.toString()),
        );
      } else {
        final shortPaths = entries.any(
          (e) =>
              e.paths.length > 12 ||
              utf8
                      .encode(
                        "${e.paths.join("/")}.${request.format.extension}",
                      )
                      .length >
                  240,
        );
        if (shortPaths) warnings.add("章節路徑過深或過長，本次 ZIP 採短路徑；完整階層保留於 manifest。");
        if (request.includeBookInfo) {
          documents.add(
            document("00_作品資訊.${request.format.extension}", [
              "作品資訊",
            ], bookInfo()),
          );
        }
        for (var i = 0; i < entries.length; i++) {
          final entry = entries[i];
          final path = shortPaths
              ? "documents/${(i + 1).toString().padLeft(6, "0")}_${safeExportName(entry.chapter.chapterName)}.${request.format.extension}"
              : "${entry.paths.join("/")}.${request.format.extension}";
          final heading = request.includeHeadings
              ? "${markdown ? "# " : ""}${text(entry.chapter.chapterName)}\n\n"
              : "";
          documents.add(
            document(
              path,
              entry.names,
              "$heading${text(entry.chapter.chapterContent)}\n",
            ),
          );
        }
      }
    } else {
      final serialized = request.purpose == ExportPurpose.exchange
          ? XmlDocument.parse(
              FileService.generateProjectXMLWithoutLatestSaveUpdate(scope.data),
            )
          : null;
      if (request.purpose == ExportPurpose.exchange &&
          request.packaging == ExportPackaging.singleFile) {
        documents.add(
          document("匯出.xml", ["匯出"], _xml(scope, request.modules, serialized!)),
        );
      } else {
        var index = 0;
        for (final module in SelectiveProjectModule.values.where(
          request.modules.contains,
        )) {
          index++;
          final content = request.purpose == ExportPurpose.exchange
              ? _xml(scope, {module}, serialized!)
              : _reference(data, module);
          if (request.purpose == ExportPurpose.reference &&
              content.trim() == "# ${module.label}") {
            warnings.add("${module.label}沒有可閱讀內容，已略過。");
            continue;
          }
          documents.add(
            document(
              "${index.toString().padLeft(2, "0")}_${module.id}.${request.format.extension}",
              [module.label],
              content,
            ),
          );
        }
        if (documents.isEmpty) {
          throw const FormatException("所選模組沒有可閱讀內容，請重新選取。");
        }
        if (request.packaging == ExportPackaging.singleFile) {
          final content = request.purpose == ExportPurpose.exchange
              ? _xml(scope, request.modules, serialized!)
              : documents.map((d) => utf8.decode(d.bytes)).join("\n");
          documents.clear();
          documents.add(
            document("匯出.${request.format.extension}", ["匯出"], content),
          );
        }
      }
    }
    if (request.packaging == ExportPackaging.singleFile) {
      return PreparedExport(
        bytes: documents.single.bytes,
        extension: request.format.extension,
        mimeType: request.format.mimeType,
        documents: documents,
        warnings: warnings,
      );
    }
    final archive = Archive();
    for (final d in documents) {
      archive.addFile(ArchiveFile(d.path, d.bytes.length, d.bytes));
    }
    void add(String name, String content) {
      final bytes = utf8.encode(content);
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    }

    add(
      "README.txt",
      "Monogatari Assistant 匯出\n內容格式：${request.format.label}\n"
          "文件順序與原階層請見 export-manifest.json。\n"
          "${request.purpose == ExportPurpose.exchange ? "XML 保留原始註記；請解壓後逐一選擇 XML 匯入。細項 scope v1 需使用支援此規格的新版 App。匯入會替換模組，請先備份。\n" : "閱讀稿使用讀者文字，不包含內部註記語法；不是完整專案備份。\n"}"
          "${warnings.join("\n")}\n",
    );
    add(
      "export-manifest.json",
      const JsonEncoder.withIndent("  ").convert({
        "schemaVersion": 1,
        "format": request.format.extension,
        "purpose": request.purpose.name,
        "documents": [
          for (var i = 0; i < documents.length; i++)
            {
              "order": i + 1,
              "path": documents[i].path,
              "logicalPath": documents[i].logicalPath,
              "pathMode": documents[i].path.startsWith("documents/")
                  ? "short"
                  : "hierarchy",
            },
        ],
        if (request.purpose == ExportPurpose.exchange)
          "scope": {
            for (final entry in scope.partial.entries)
              entry.key.id: {
                "selected": entry.value.toList()..sort(),
                "structural": (scope.structural[entry.key] ?? {}).toList()
                  ..sort(),
                "dependencies": (scope.dependencies[entry.key] ?? {}).toList()
                  ..sort(),
              },
          },
      }),
    );
    return PreparedExport(
      bytes: ZipEncoder().encodeBytes(archive),
      extension: "zip",
      mimeType: "application/zip",
      documents: documents,
      warnings: warnings,
    );
  }

  String _xml(
    ResolvedExportScope scope,
    Set<SelectiveProjectModule> modules,
    XmlDocument full,
  ) {
    final supported = {for (final m in modules) ...exportModuleTypes[m]!};
    final builder = XmlBuilder();
    builder.processing("xml", "version=\"1.0\" encoding=\"UTF-8\"");
    builder.element(
      "Project",
      attributes: {"UUID": scope.data.projectUUID},
      nest: () {
        builder.element("ver", nest: FileService.projectVersion);
        builder.element(
          "SelectiveExport",
          nest: () {
            for (final module in SelectiveProjectModule.values.where(
              modules.contains,
            )) {
              builder.element("Module", nest: module.id);
            }
          },
        );
        if (modules.any(scope.partial.containsKey)) {
          builder.element(
            "ExportScope",
            attributes: {"Version": "1"},
            nest: () {
              for (final module in SelectiveProjectModule.values.where(
                (m) => modules.contains(m) && scope.partial.containsKey(m),
              )) {
                builder.element(
                  "Module",
                  attributes: {"Id": module.id, "Mode": "partial"},
                  nest: () {
                    for (final pair in [
                      ("Selected", scope.partial[module]!),
                      ("Structural", scope.structural[module] ?? <String>{}),
                      ("Dependency", scope.dependencies[module] ?? <String>{}),
                    ]) {
                      for (final key in pair.$2.toList()..sort()) {
                        builder.element(pair.$1, attributes: {"Key": key});
                      }
                    }
                  },
                );
              }
            },
          );
        }
        for (final type in full.rootElement.findElements("Type")) {
          if (supported.contains(type.getElement("Name")?.innerText)) {
            builder.xml(type.toXmlString());
          }
        }
      },
    );
    return builder.buildDocument().toXmlString(pretty: true);
  }

  String _reference(ProjectData data, SelectiveProjectModule module) {
    final out = StringBuffer("# ${module.label}\n\n");
    void heading(String name, [int depth = 2]) => out.writeln(
      "${"#" * depth.clamp(1, 6)} ${_escape(readerExportText(name))}\n",
    );
    void field(String label, Object? value) {
      if (value == null || value.toString().isEmpty) return;
      out.writeln(
        "- ${_escape(label)}：${_escape(readerExportText(value.toString()))}\n",
      );
    }

    String person(String id) =>
        data.characterData[id]?.displayName ?? _unresolvedLabel(id);
    String item(String id) =>
        data.itemInstances[id]?.name ??
        data.itemClasses[id]?.name ??
        _unresolvedLabel(id);
    final locationNames = <String, String>{};
    final pending = [...data.worldSettingsData];
    while (pending.isNotEmpty) {
      final location = pending.removeLast();
      locationNames[location.id] = location.localName;
      pending.addAll(location.child);
    }
    final sceneNames = {
      for (final l in data.outlineData)
        for (final e in l.scenes)
          for (final s in e.scenes) s.sceneUUID: s.sceneName,
    };
    String reference(String id, Map<String, String> names) =>
        names[id] ??
        (RegExp(r"^[0-9a-fA-F]{8}-[0-9a-fA-F-]{27,}$").hasMatch(id)
            ? "未解析參照"
            : id);
    void values(String label, Object? value) {
      if (value is Map) {
        for (final entry in value.entries) {
          final key = entry.key.toString();
          if (key == "person") {
            field("$label / 人物", person(entry.value.toString()));
            continue;
          }
          if ([
            "holderCharacterId",
            "controllerCharacterId",
            "ownerCharacterIds",
            "locationId",
          ].contains(key)) {
            final raw = entry.value is Map
                ? (entry.value as Map)["value"]
                : entry.value;
            if (raw != null) {
              String resolve(Object? id) => key == "locationId"
                  ? reference(id.toString(), locationNames)
                  : person(id.toString());
              field(
                "$label / ${key == "locationId" ? "地點" : "人物"}",
                raw is Iterable ? raw.map(resolve).join("、") : resolve(raw),
              );
            }
            continue;
          }
          if (RegExp(r"(id|ids|uuid)$", caseSensitive: false).hasMatch(key)) {
            continue;
          }
          values("$label / $key", entry.value);
        }
      } else if (value is Iterable) {
        var i = 0;
        for (final element in value) {
          values("$label ${(++i)}", element);
        }
      } else if (value != null) {
        field(label, value is bool ? (value ? "是" : "否") : value);
      }
    }

    void characterPatch(String label, CharacterStatePatch patch) {
      values(label, {
        if (patch.conflicts != null)
          "衝突": [
            for (final c in patch.conflicts!)
              {"阻礙": c.obstacle, "解決": c.resolution},
          ],
        if (patch.relationships != null)
          "關係": [
            for (final r in patch.relationships!)
              {
                "人物": person(r.person),
                "關係": r.relationship,
                "內在關係": r.internalRelationship,
              },
          ],
        if (patch.organizations != null)
          "組織": [
            for (final o in patch.organizations!)
              {"名稱": o.name, "說明": o.description},
          ],
        if (patch.statusEntries != null)
          "狀態": [
            for (final o in patch.statusEntries!)
              {"名稱": o.name, "說明": o.description},
          ],
        if (patch.possessions != null)
          "持有物": [
            for (final p in patch.possessions!)
              {"名稱": p.name, "數量": p.quantity, "說明": p.description},
          ],
        if (patch.customFields != null)
          "自訂欄位": {
            for (final e in patch.customFields!.entries)
              e.key: e.value.displayValue,
          },
      });
    }

    switch (module) {
      case SelectiveProjectModule.baseInfo:
        final b = data.baseInfoData;
        field("書名", b.bookName);
        field("作者", b.author);
        field("類型", b.storyType);
        field("主旨", b.purpose);
        field("一句話簡介", b.toRecap);
        field("簡介", b.intro);
        field("標籤", b.tags.join("、"));
      case SelectiveProjectModule.chapters:
        for (final entry in _manuscripts(
          data.segmentsData,
          data.segmentsData,
        )) {
          heading(entry.names.join(" / "));
          out.writeln(
            "${_escape(readerExportText(entry.chapter.chapterContent))}\n",
          );
        }
      case SelectiveProjectModule.outline:
        for (final line in data.outlineData) {
          heading(line.storylineName);
          field("類型", line.storylineType);
          field("備註", line.memo);
          field("衝突", line.conflictPoint);
          field("人物", line.people.map(person).join("、"));
          field("物品", line.item.map(item).join("、"));
          for (final event in line.scenes) {
            heading(event.storyEvent, 3);
            field("備註", event.memo);
            field("衝突", event.conflictPoint);
            field("人物", event.people.map(person).join("、"));
            field("物品", event.item.map(item).join("、"));
            for (final scene in event.scenes) {
              heading(scene.sceneName, 4);
              field("時間", scene.time);
              field("地點", reference(scene.location, locationNames));
              field("焦點", scene.focusPoint);
              field("衝突", scene.conflictPoint);
              field("備註", scene.memo);
              field("行動", scene.doingThings.join("、"));
              field("人物", scene.people.map(person).join("、"));
              field("物品", scene.item.map(item).join("、"));
              for (final placement in data.timelineDocument.placements.where(
                (p) => p.sceneUUID == scene.sceneUUID,
              )) {
                final tracks = data.timelineDocument.tracks.where(
                  (t) => t.trackUUID == placement.trackUUID,
                );
                field(
                  "時間軸",
                  "${tracks.isEmpty ? "未解析軌道" : tracks.first.name} · Tick ${placement.startTick}–${placement.endTick}",
                );
              }
            }
          }
        }
      case SelectiveProjectModule.plans:
        heading("伏筆");
        for (final p in data.foreshadowData) {
          heading(p.title, 3);
          field("狀態", p.isRevealed ? "已揭示" : "未揭示");
          field("備註", p.note);
        }
        heading("更新計畫");
        for (final p in data.updatePlanData) {
          heading(p.title, 3);
          field("狀態", p.isDone ? "已完成" : "未完成");
          field("備註", p.note);
        }
      case SelectiveProjectModule.characters:
        for (final c in data.characterData.values) {
          heading(c.displayName);
          for (final entry in <String, Object?>{
            "職業／角色": c.roleOrOccupation,
            "年齡": c.age,
            "性別": c.gender,
            "外貌": c.appearanceSummary,
            "個性": c.personalitySummary,
            "語氣": c.speechStyle,
            "動機": c.motivation,
            "目標": c.goal,
            "價值觀": c.valuesAndBeliefs,
            "恐懼": c.fear,
            "人際關係": c.relationshipSummary,
            "筆記": c.notes,
          }.entries) {
            field(entry.key, entry.value);
          }
          for (final alias in c.aliases) {
            field("別名", alias.values.join("、"));
          }
          for (final r in c.relationships) {
            field(
              "關係",
              "${person(r.person)}：${r.relationship} ${r.internalRelationship}",
            );
          }
          for (final entry in c.textFields.entries) {
            if (!RegExp("id|uuid", caseSensitive: false).hasMatch(entry.key)) {
              field(entry.key, entry.value);
            }
          }
          final legacy = c.toLegacyMap()
            ..remove("nanoId")
            ..remove("relationships");
          values("角色詳細資料", legacy);
          values("進階能力", {
            "生活能力": c.advanced.commonAbilities,
            "社交傾向": c.advanced.socialTraits,
            "處事傾向": c.advanced.approaches,
            "性格傾向": c.advanced.personalityTraits,
          });
          for (final custom in c.customFields.entries) {
            field(custom.key, custom.value.displayValue);
          }
          for (final state in data.characterStates.where(
            (s) => s.characterId == c.characterId,
          )) {
            field("狀態／健康", state.healthStatus);
            field("狀態／情緒", state.emotion);
            field("狀態／地點", reference(state.location, locationNames));
            field("狀態／陣營", state.alignment);
          }
          final baseline = data.characterStateBaselines[c.characterId];
          if (baseline != null) {
            field("基準快照／備註", baseline.note);
            characterPatch("基準快照", baseline.patch);
          }
          for (final change in data.characterStateChanges.where(
            (s) => s.characterId == c.characterId,
          )) {
            field("狀態變化／場景", reference(change.sceneUUID, sceneNames));
            field("狀態變化／備註", change.note);
            characterPatch("狀態變化", change.patch);
            for (final conflict in change.patch.conflicts ?? []) {
              field("狀態變化／衝突", "${conflict.obstacle} ${conflict.resolution}");
            }
            for (final r in change.patch.relationships ?? []) {
              field("狀態變化／關係", "${person(r.person)} ${r.relationship}");
            }
          }
        }
      case SelectiveProjectModule.worldSettings:
        void location(LocationData value, List<String> parents) {
          final path = [...parents, value.localName];
          heading(path.join(" / "));
          field("類型", value.localType);
          field("備註", value.note);
          for (final v in value.customVal) {
            field(v.key, v.val);
          }
          for (final change in data.locationStateChanges.where(
            (c) => c.locationId == value.id,
          )) {
            field("狀態變化／場景", reference(change.sceneUUID, sceneNames));
            values("狀態變化", change.patch.toJson());
            field("狀態變化／備註", change.note);
          }
          for (final child in value.child) {
            location(child, path);
          }
        }
        for (final root in data.worldSettingsData) {
          location(root, []);
        }
      case SelectiveProjectModule.items:
        for (final c in data.itemClasses.values) {
          heading(c.name);
          field("分類", c.category);
          field("說明", c.description);
          field("單位", c.unit);
          field("封存", c.archived ? "是" : "否");
          values("預設狀態", c.defaultState.toJson());
          for (final change in data.itemClassStateChanges.where(
            (s) => s.classId == c.classId,
          )) {
            field("狀態變化／場景", reference(change.sceneUUID, sceneNames));
            values("狀態變化", change.patch.toJson());
            field("狀態變化／備註", change.note);
          }
          for (final i in data.itemInstances.values.where(
            (i) => i.classId == c.classId,
          )) {
            heading(i.name, 3);
            field("封存", i.archived ? "是" : "否");
            values("預設狀態", i.defaultState.toJson());
            for (final change in data.itemInstanceStateChanges.where(
              (s) => s.instanceId == i.instanceId,
            )) {
              field("狀態變化／場景", reference(change.sceneUUID, sceneNames));
              values("狀態變化", change.patch.toJson());
              field("狀態變化／備註", change.note);
            }
          }
        }
      case SelectiveProjectModule.phrases:
        for (final p in data.phrases) {
          heading(p.name);
          field("捷徑", p.shortcut);
          field("分類", p.category);
          field("標籤", p.tags.join("、"));
          field("內容", readerExportText(p.body));
        }
        if (data.phrasesRecoveryPayload != null) {
          out.writeln("另有無法解讀的短語復原資料，請使用 XML 或完整專案保存。\n");
        }
    }
    return out.toString();
  }
}

class _Manuscript {
  final ChapterData chapter;
  final List<String> names;
  final List<String> paths;
  final List<String> ids;
  const _Manuscript(this.chapter, this.names, this.paths, this.ids);
}

List<_Manuscript> _manuscripts(
  List<SegmentData> selected,
  List<SegmentData> original,
) {
  final positions = <String, String>{};
  void index(List<SegmentData> folders) {
    for (var i = 0; i < folders.length; i++) {
      final f = folders[i];
      positions[f.segmentUUID] ??=
          "${(i + 1).toString().padLeft(folders.length.toString().length.clamp(2, 10), "0")}_${safeExportName(f.segmentName)}";
      final order = f.resolvedChildNodeOrder;
      final names = {
        for (final c in f.chapters) c.chapterUUID: c.chapterName,
        for (final c in f.childSegments) c.segmentUUID: c.segmentName,
      };
      for (var j = 0; j < order.length; j++) {
        positions[order[j]] =
            "${(j + 1).toString().padLeft(order.length.toString().length.clamp(2, 10), "0")}_${safeExportName(names[order[j]]!)}";
      }
      index(f.childSegments);
    }
  }

  index(original);
  final result = <_Manuscript>[];
  void visit(
    SegmentData folder,
    List<String> names,
    List<String> paths,
    List<String> ids,
  ) {
    final nextNames = [...names, folder.segmentName];
    final nextPaths = [...paths, positions[folder.segmentUUID]!];
    final nextIds = [...ids, folder.segmentUUID];
    final folders = {for (final f in folder.childSegments) f.segmentUUID: f};
    final chapters = {for (final c in folder.chapters) c.chapterUUID: c};
    for (final id in folder.resolvedChildNodeOrder) {
      if (folders[id] case final f?) {
        visit(f, nextNames, nextPaths, nextIds);
      }
      if (chapters[id] case final c?) {
        result.add(
          _Manuscript(
            c,
            [...nextNames, c.chapterName],
            [...nextPaths, positions[id]!],
            [...nextIds, c.chapterUUID],
          ),
        );
      }
    }
  }

  for (final f in selected) {
    visit(f, [], [], []);
  }
  return result;
}
