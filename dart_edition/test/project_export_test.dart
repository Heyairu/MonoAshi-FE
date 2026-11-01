import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/application/project_export/export_models.dart';
import 'package:monogatari_assistant/application/project_export/export_service.dart';
import 'package:monogatari_assistant/application/project_export/export_selection.dart';
import 'package:monogatari_assistant/application/project_export/export_scope_resolver.dart';
import 'package:monogatari_assistant/application/project_import/selective_project_import.dart';
import 'package:monogatari_assistant/bin/file.dart';
import 'package:monogatari_assistant/data/repositories/platform_export_writer.dart';
import 'package:monogatari_assistant/models/character_data.dart';
import 'package:monogatari_assistant/models/character_snapshot_data.dart';
import 'package:monogatari_assistant/models/item_data.dart';
import 'package:monogatari_assistant/models/item_snapshot_data.dart';
import 'package:monogatari_assistant/models/outline_data.dart';
import 'package:monogatari_assistant/models/world_settings_data.dart';
import 'package:monogatari_assistant/modules/chapterselectionview.dart';

const service = ProjectExportService();
const chapters = SelectiveProjectModule.chapters;
const items = SelectiveProjectModule.items;

ProjectData manuscriptFixture() => ProjectData.empty()
  ..segmentsData = [
    SegmentData(
      segmentUUID: 'root',
      segmentName: '卷',
      chapters: [
        ChapterData(chapterUUID: 'a', chapterName: '同名', chapterContent: 'A'),
        ChapterData(chapterUUID: 'c', chapterName: '同名', chapterContent: 'C'),
      ],
      childSegments: [
        SegmentData(
          segmentUUID: 'sub',
          segmentName: '子卷',
          chapters: [
            ChapterData(
              chapterUUID: 'b',
              chapterName: '文稿B',
              chapterContent: 'B',
            ),
          ],
        ),
      ],
      childNodeOrder: ['a', 'sub', 'c'],
    ),
  ];

ExportRequest reader({
  ExportFormat format = ExportFormat.txt,
  ExportPackaging packaging = ExportPackaging.singleFile,
  Map<SelectiveProjectModule, Set<String>> selections = const {},
}) => ExportRequest(
  purpose: ExportPurpose.manuscript,
  format: format,
  packaging: packaging,
  selections: selections,
);
ExportRequest exchange(
  Set<SelectiveProjectModule> modules, {
  Map<SelectiveProjectModule, Set<String>> selections = const {},
  ExportPackaging packaging = ExportPackaging.singleFile,
}) => ExportRequest(
  purpose: ExportPurpose.exchange,
  format: ExportFormat.xml,
  modules: modules,
  selections: selections,
  packaging: packaging,
);

void main() {
  test('empty reference modules cannot export header-only files or ZIPs', () {
    for (final packaging in ExportPackaging.values) {
      final request = ExportRequest(
        purpose: ExportPurpose.reference,
        format: ExportFormat.markdown,
        packaging: packaging,
        modules: {
          SelectiveProjectModule.characters,
          SelectiveProjectModule.items,
        },
      );
      expect(
        () => service.prepare(ProjectData.empty(), request),
        throwsFormatException,
      );
    }
  });

  test('mixed reference ZIP skips empty modules and reports the omission', () {
    final data = ProjectData.empty()
      ..baseInfoData = ProjectData.empty().baseInfoData.copyWith(
        bookName: '作品',
      );
    final output = service.prepare(
      data,
      ExportRequest(
        purpose: ExportPurpose.reference,
        format: ExportFormat.markdown,
        packaging: ExportPackaging.splitZip,
        modules: {
          SelectiveProjectModule.baseInfo,
          SelectiveProjectModule.characters,
        },
      ),
    );
    expect(output.documents.single.path, endsWith('BaseInfo.md'));
    expect(output.warnings, contains('角色設定與快照沒有可閱讀內容，已略過。'));
    final archive = ZipDecoder().decodeBytes(output.bytes);
    expect(archive.files.where((f) => f.name.endsWith('.md')), hasLength(1));
  });

  test(
    'isolate preparation accepts the same snapshot and request used by the UI',
    () async {
      final result = await compute(prepareProjectExport, (
        manuscriptFixture(),
        exchange({chapters}),
      ));
      expect(
        FileService.parseProjectXML(
          utf8.decode(result.bytes),
        ).segmentsData.single.segmentUUID,
        'root',
      );
    },
  );
  test('TXT follows mixed order and repeats distinct same-name headings', () {
    final text = utf8.decode(
      service.prepare(manuscriptFixture(), reader()).bytes,
    );
    expect(text.indexOf('\nA\n'), lessThan(text.indexOf('\nB\n')));
    expect(text.indexOf('\nB\n'), lessThan(text.indexOf('\nC\n')));
    expect('同名'.allMatches(text).length, 2);
    expect(text, isNot(contains('#')));
  });

  test(
    'reader projection hides annotation syntax and markdown escapes text',
    () {
      const id = '4e251fc2-1e2b-4f78-93da-91f8c76d9a92';
      final data = manuscriptFixture()
        ..segmentsData = [
          SegmentData(
            segmentUUID: 'r',
            segmentName: '# 卷',
            chapters: [
              ChapterData(
                chapterUUID: 'c',
                chapterName: '稿',
                chapterContent: '# 她看見 //@+^CE<$id|艾莉絲>{主角}//。\n😀',
              ),
            ],
          ),
        ];
      final text = utf8.decode(
        service.prepare(data, reader(format: ExportFormat.markdown)).bytes,
      );
      expect(text, contains(r'\# 她看見 艾莉絲。'));
      expect(text, contains('😀'));
      expect(text, isNot(contains(id)));
      expect(text, isNot(contains('主角')));
    },
  );

  test(
    'partial chapter XML keeps ancestor IDs, raw content and no siblings',
    () {
      final data = manuscriptFixture();
      final output = service.prepare(
        data,
        exchange(
          {chapters},
          selections: {
            chapters: {'chapter:b'},
          },
        ),
      );
      final text = utf8.decode(output.bytes);
      final parsed = FileService.parseProjectXML(text);
      expect(parsed.segmentsData.single.segmentUUID, 'root');
      expect(
        parsed.segmentsData.single.childSegments.single.segmentUUID,
        'sub',
      );
      expect(
        ChapterTree.chaptersDepthFirst(
          parsed.segmentsData,
        ).map((c) => c.chapter.chapterUUID),
        ['b'],
      );
      expect(parsed.segmentsData.single.resolvedChildNodeOrder, ['sub']);
      expect(SelectiveProjectImportManifest.fromXml(text).partialModules, {
        chapters,
      });
      expect(text, isNot(contains('UUID="a"')));
      expect(data.segmentsData.single.resolvedChildNodeOrder, [
        'a',
        'sub',
        'c',
      ]);
    },
  );

  test('empty selections and stale IDs never fall back to select all', () {
    for (final keys in [
      <String>{},
      {'chapter:gone'},
    ]) {
      expect(
        () => service.prepare(
          manuscriptFixture(),
          reader(selections: {chapters: keys}),
        ),
        throwsFormatException,
      );
    }
  });

  test(
    'module-only requests produce valid module declarations including empty modules',
    () {
      final output = service.prepare(
        ProjectData.empty(),
        exchange({SelectiveProjectModule.phrases}),
      );
      final manifest = SelectiveProjectImportManifest.fromXml(
        utf8.decode(output.bytes),
      );
      expect(manifest.declaredModules, {SelectiveProjectModule.phrases});
      expect(manifest.partialModules, isEmpty);
    },
  );

  test(
    'recursive empty folders and explicit empty trees survive the chapter codec',
    () {
      final folders = [
        SegmentData(
          segmentUUID: 'r',
          segmentName: '空卷',
          childSegments: [SegmentData(segmentUUID: 'e', segmentName: '空資料夾')],
        ),
      ];
      final parsed = ChapterSelectionCodec.loadXML(
        ChapterSelectionCodec.saveXML(folders)!,
      );
      expect(parsed!.single.childSegments.single.segmentUUID, 'e');
      expect(
        ChapterSelectionCodec.loadXML(ChapterSelectionCodec.saveXML([])!),
        isEmpty,
      );
    },
  );

  test(
    'ZIP preserves hierarchy, source indices, entry bytes and reader privacy',
    () {
      final output = service.prepare(
        manuscriptFixture(),
        reader(
          format: ExportFormat.markdown,
          packaging: ExportPackaging.splitZip,
          selections: {
            chapters: {'chapter:b'},
          },
        ),
      );
      final archive = ZipDecoder().decodeBytes(output.bytes);
      final file = archive.findFile('01_卷/02_子卷/01_文稿B.md')!;
      expect(file.content, output.documents.single.bytes);
      final manifest = jsonDecode(
        utf8.decode(archive.findFile('export-manifest.json')!.content),
      );
      expect(manifest['documents'][0]['logicalPath'], ['卷', '子卷', '文稿B']);
      expect(manifest.toString(), isNot(contains('chapter:b')));
      expect(manifest.toString(), isNot(contains('root')));
      expect(archive.findFile('README.txt'), isNotNull);
    },
  );

  test(
    'deep hierarchy uses short ZIP paths and valid Markdown heading levels',
    () {
      var folder = SegmentData(
        segmentUUID: 'leaf',
        segmentName: '底',
        chapters: [
          ChapterData(chapterUUID: 'c', chapterName: '稿', chapterContent: '內容'),
        ],
      );
      for (var i = 0; i < 40; i++) {
        folder = SegmentData(
          segmentUUID: 'f$i',
          segmentName: '資料夾$i',
          childSegments: [folder],
        );
      }
      final data = ProjectData.empty()..segmentsData = [folder];
      final zip = service.prepare(
        data,
        reader(packaging: ExportPackaging.splitZip),
      );
      expect(zip.documents.single.path, startsWith('documents/000001_'));
      expect(zip.documents.single.logicalPath.length, 42);
      expect(zip.warnings.single, contains('短路徑'));
      final text = utf8.decode(
        service.prepare(data, reader(format: ExportFormat.markdown)).bytes,
      );
      expect(text, isNot(contains('#######')));
      expect(text, contains('資料夾39 / 資料夾38'));
    },
  );

  test('ZIP same-name chapters have different stable filenames', () {
    final result = service.prepare(
      manuscriptFixture(),
      reader(packaging: ExportPackaging.splitZip),
    );
    expect(result.documents.map((d) => d.path).toSet().length, 3);
    expect(result.documents.last.path, '01_卷/03_同名.txt');
  });

  test('outline child-only selection strips ancestor notes and siblings', () {
    final data = ProjectData.empty()
      ..outlineData = [
        StorylineData(
          chapterUUID: 'l',
          storylineName: '線',
          memo: '秘密大箱',
          scenes: [
            StoryEventData(
              storyEventUUID: 'e',
              storyEvent: '事件',
              memo: '秘密中箱',
              scenes: [
                SceneData(sceneUUID: 's', sceneName: '場景'),
                SceneData(sceneUUID: 'other', sceneName: '不選'),
              ],
            ),
          ],
        ),
      ];
    final scope = resolveExportScope(
      data,
      exchange(
        {SelectiveProjectModule.outline},
        selections: {
          SelectiveProjectModule.outline: {'scene:s'},
        },
      ),
    );
    expect(scope.data.outlineData.single.memo, isEmpty);
    expect(scope.data.outlineData.single.scenes.single.memo, isEmpty);
    expect(
      scope.data.outlineData.single.scenes.single.scenes.single.sceneUUID,
      's',
    );
    expect(scope.structural[SelectiveProjectModule.outline], {
      'storyline:l',
      'event:e',
    });
  });

  test('character selection includes only matching snapshots', () {
    final data = ProjectData.empty()
      ..characterData = {
        'a': const CharacterEntryData(characterId: 'a', displayName: '甲'),
        'b': const CharacterEntryData(characterId: 'b', displayName: '乙'),
      }
      ..characterStateChanges = [
        CharacterStateChange(characterId: 'a', sceneUUID: 's', fallbackTick: 0),
        CharacterStateChange(characterId: 'b', sceneUUID: 's', fallbackTick: 0),
      ];
    final scope = resolveExportScope(
      data,
      exchange(
        {SelectiveProjectModule.characters},
        selections: {
          SelectiveProjectModule.characters: {'character:a'},
        },
      ),
    );
    expect(scope.data.characterData.keys, ['a']);
    expect(scope.data.characterStateChanges.single.characterId, 'a');
    expect(data.characterData.length, 2);
  });

  test('location child-only selection retains only structural ancestors', () {
    final data = ProjectData.empty()
      ..worldSettingsData = [
        LocationData(
          id: 'r',
          localName: '城',
          note: '秘密',
          child: [
            LocationData(id: 'c', localName: '街'),
            LocationData(id: 'x', localName: '未選'),
          ],
        ),
      ];
    final scope = resolveExportScope(
      data,
      exchange(
        {SelectiveProjectModule.worldSettings},
        selections: {
          SelectiveProjectModule.worldSettings: {'location:c'},
        },
      ),
    );
    expect(scope.data.worldSettingsData.single.note, isEmpty);
    expect(scope.data.worldSettingsData.single.child.single.id, 'c');
  });

  test(
    'item instance exports required definition without sibling instances or changes',
    () {
      final data = ProjectData.empty()
        ..itemClasses = {'k': ItemClassData(classId: 'k', name: '劍')}
        ..itemInstances = {
          'a': ItemInstanceData(instanceId: 'a', classId: 'k', name: '一號'),
          'b': ItemInstanceData(instanceId: 'b', classId: 'k', name: '二號'),
        }
        ..itemClassStateChanges = [
          ItemClassStateChange(
            classId: 'k',
            sceneUUID: 's',
            patch: ItemStatePatch(),
          ),
        ];
      final scope = resolveExportScope(
        data,
        exchange(
          {items},
          selections: {
            items: {'instance:a'},
          },
        ),
      );
      expect(scope.data.itemClasses.keys, ['k']);
      expect(scope.data.itemInstances.keys, ['a']);
      expect(scope.data.itemClassStateChanges, isEmpty);
      expect(scope.dependencies[items], {'class:k'});
    },
  );

  test('Phrases recovery payload survives XML serialization', () {
    final data = ProjectData.empty()
      ..phrasesRecoveryPayload = base64Encode(utf8.encode('{"future":true}'));
    final output = service.prepare(
      data,
      exchange({SelectiveProjectModule.phrases}),
    );
    final reopened = FileService.parseProjectXML(utf8.decode(output.bytes));
    expect(reopened.phrasesRecoveryPayload, data.phrasesRecoveryPayload);
  });

  test(
    'export leaves project identity, save timestamp, dirty and revision unchanged',
    () {
      final timestamp = DateTime(2026, 1, 1);
      final data = manuscriptFixture()
        ..isDirty = true
        ..revisionTrackingJson = 'revision';
      data.baseInfoData = data.baseInfoData.copyWith(
        bookName: '作品',
        latestSave: timestamp,
      );
      final id = data.projectUUID;
      service.prepare(
        data,
        exchange({chapters, SelectiveProjectModule.baseInfo}),
      );
      expect(data.projectUUID, id);
      expect(data.isDirty, isTrue);
      expect(data.baseInfoData.latestSave, timestamp);
      expect(data.revisionTrackingJson, 'revision');
    },
  );

  test('chapter identities cannot collide across folders and manuscripts', () {
    final data = ProjectData.empty()
      ..segmentsData = [
        SegmentData(
          segmentUUID: 'same',
          segmentName: '卷',
          chapters: [
            ChapterData(
              chapterUUID: 'same',
              chapterName: '稿',
              chapterContent: '內容',
            ),
          ],
        ),
      ];
    expect(() => buildExportSelections(data), throwsFormatException);
  });

  test(
    'Word, PDF and incompatible purpose/format are rejected by the service',
    () {
      for (final format in [
        ExportFormat.docx,
        ExportFormat.pdf,
        ExportFormat.xml,
      ]) {
        expect(
          () => service.prepare(manuscriptFixture(), reader(format: format)),
          throwsFormatException,
        );
      }
    },
  );

  test('filename cleaning handles reserved names and multi-byte length', () {
    for (final input in ['../CON', 'NUL', 'a/b\\c:*?. ', '😀' * 100]) {
      final value = safeExportName(input);
      expect(value, isNot(matches(r'[/\\:*?"<>|]')));
      expect(utf8.encode(value).length, lessThanOrEqualTo(120));
      expect(value.endsWith('.'), isFalse);
    }
    expect(safeExportName('CON'), '_CON');
  });

  test(
    'fine-grained XML requires explicit replacement and blocks structural overwrite',
    () {
      final text = utf8.decode(
        service
            .prepare(
              manuscriptFixture(),
              exchange(
                {chapters},
                selections: {
                  chapters: {'chapter:b'},
                },
              ),
            )
            .bytes,
      );
      final manifest = SelectiveProjectImportManifest.fromXml(text);
      final source = FileService.parseProjectXML(text);
      const importer = SelectiveProjectImporter();
      expect(
        () => importer.apply(
          current: ProjectData.empty(),
          source: source,
          manifest: manifest,
          selectedModules: {chapters},
        ),
        throwsFormatException,
      );
      final result = importer.apply(
        current: ProjectData.empty(),
        source: source,
        manifest: manifest,
        selectedModules: {chapters},
        allowPartialReplacement: true,
      );
      expect(ChapterTree.chapterCount(result.data.segmentsData), 1);
      expect(
        () => importer.apply(
          current: manuscriptFixture(),
          source: source,
          manifest: manifest,
          selectedModules: {chapters},
          allowPartialReplacement: true,
        ),
        throwsFormatException,
      );
      expect(
        () => SelectiveProjectImportManifest.fromXml(
          text.replaceFirst('Version="1"', 'Version="999"'),
        ),
        throwsFormatException,
      );
    },
  );

  test(
    'platform writer cancellation does not create output and successful bytes match',
    () async {
      final picker = _Picker();
      FilePicker.platform = picker;
      final output = service.prepare(
        manuscriptFixture(),
        reader(packaging: ExportPackaging.splitZip),
      );
      final dir = await Directory.systemTemp.createTemp('export-writer-test-');
      addTearDown(() => dir.delete(recursive: true));
      final writer = PlatformExportWriter();
      expect(
        (await writer.save(output, '稿')).status,
        ExportSaveStatus.cancelled,
      );
      expect(dir.listSync(), isEmpty);
      picker.destination = '${dir.path}/稿.zip';
      await File(picker.destination!).writeAsString('old');
      expect((await writer.save(output, '稿')).status, ExportSaveStatus.saved);
      expect(await File(picker.destination!).readAsBytes(), output.bytes);
      expect(dir.listSync().length, 1);
    },
  );

  test(
    'failed atomic replacement cleans temporary files and keeps target',
    () async {
      final dir = await Directory.systemTemp.createTemp('export-failure-');
      addTearDown(() => dir.delete(recursive: true));
      final target = await Directory('${dir.path}/existing').create();
      await File('${target.path}/keep').writeAsString('keep');
      await expectLater(
        writeExportBytesAtomically(target.path, [1, 2, 3]),
        throwsA(isA<FileSystemException>()),
      );
      expect(await File('${target.path}/keep').readAsString(), 'keep');
      expect(dir.listSync().length, 1);
    },
  );

  test(
    'project switch during desktop destination picking prevents writing',
    () async {
      var current = true;
      final dir = await Directory.systemTemp.createTemp('export-session-');
      addTearDown(() => dir.delete(recursive: true));
      final path = '${dir.path}/old.txt';
      await File(path).writeAsString('keep');
      FilePicker.platform = _Picker()
        ..destination = path
        ..onPick = () => current = false;
      final output = service.prepare(manuscriptFixture(), reader());
      await expectLater(
        PlatformExportWriter().save(output, '稿', canWrite: () => current),
        throwsStateError,
      );
      expect(await File(path).readAsString(), 'keep');
      expect(dir.listSync().length, 1);
    },
  );
}

class _Picker extends FilePicker {
  String? destination;
  void Function()? onPick;
  @override
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Uint8List? bytes,
    bool lockParentWindow = false,
  }) async {
    onPick?.call();
    return destination;
  }
}
