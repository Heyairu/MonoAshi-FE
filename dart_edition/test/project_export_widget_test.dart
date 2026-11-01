import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/application/project_export/export_models.dart';
import 'package:monogatari_assistant/application/project_export/export_service.dart';
import 'package:monogatari_assistant/models/chapter_selection_data.dart';
import 'package:monogatari_assistant/models/project_data.dart';
import 'package:monogatari_assistant/models/character_data.dart';
import 'package:monogatari_assistant/presentation/widgets/project_export/export_dialog.dart';
import 'package:monogatari_assistant/presentation/widgets/project_export/export_selection_tree.dart';

void main() {
  const root = ExportSelectionNode(
    key: 'folder:r',
    label: '卷',
    kind: '資料夾',
    children: [
      ExportSelectionNode(key: 'chapter:a', label: '甲稿', kind: '文稿'),
      ExportSelectionNode(key: 'chapter:b', label: '乙稿', kind: '文稿'),
    ],
  );

  testWidgets('parent tri-state selects all, then clears the subtree', (
    tester,
  ) async {
    var selected = <String>{'chapter:a'};
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => ExportSelectionTree(
              roots: const [root],
              selected: selected,
              onChanged: (value) => setState(() => selected = value),
            ),
          ),
        ),
      ),
    );
    final parent = find.byKey(const ValueKey('export-check-folder:r'));
    expect(tester.widget<Checkbox>(parent).value, isNull);
    await tester.tap(parent);
    await tester.pump();
    expect(selected, {'folder:r', 'chapter:a', 'chapter:b'});
    expect(tester.widget<Checkbox>(parent).value, isTrue);
    await tester.tap(parent);
    await tester.pump();
    expect(selected, isEmpty);
    expect(tester.widget<Checkbox>(parent).value, isFalse);
  });

  testWidgets('collapse and name filtering preserve hidden selections', (
    tester,
  ) async {
    var selected = <String>{'chapter:a'};
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => ExportSelectionTree(
              roots: const [root],
              selected: selected,
              onChanged: (value) => setState(() => selected = value),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('展開 卷'));
    await tester.pump();
    expect(find.text('甲稿'), findsOneWidget);
    await tester.tap(find.byTooltip('收合 卷'));
    await tester.pump();
    expect(find.text('甲稿'), findsNothing);
    expect(selected, {'chapter:a'});
    await tester.enterText(find.byKey(const Key('export-tree-search')), '乙');
    await tester.pump();
    expect(find.text('乙稿'), findsOneWidget);
    expect(find.text('甲稿'), findsNothing);
    expect(selected, {'chapter:a'});
    await tester.tap(find.text('全選清單'));
    await tester.pump();
    expect(selected, {'folder:r', 'chapter:a', 'chapter:b'});
  });

  testWidgets(
    'only-this-item excludes children and summary disclosure does not select fields',
    (tester) async {
      var selected = <String>{'event:e', 'scene:s'};
      const roots = [
        ExportSelectionNode(
          key: 'event:e',
          label: '事件',
          kind: '中箱',
          children: [
            ExportSelectionNode(key: 'scene:s', label: '場景', kind: '小箱'),
          ],
        ),
        ExportSelectionNode(
          key: 'character:c',
          label: '主角',
          kind: '角色',
          summary: '偵探，沉著',
        ),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => ExportSelectionTree(
                roots: roots,
                selected: selected,
                onChanged: (value) => setState(() => selected = value),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('僅此項：事件'));
      await tester.pump();
      expect(selected, {'event:e'});
      await tester.tap(find.byTooltip('展開 主角'));
      await tester.pump();
      expect(find.text('偵探，沉著'), findsOneWidget);
      expect(selected, {'event:e'});
    },
  );

  ProjectData fixture() => ProjectData.empty()
    ..segmentsData = [
      SegmentData(
        segmentUUID: 'r',
        segmentName: '卷',
        chapters: [
          ChapterData(
            chapterUUID: 'c',
            chapterName: '稿',
            chapterContent: '正文內容',
          ),
        ],
      ),
    ];

  testWidgets('module checkbox and its descendants always agree', (
    tester,
  ) async {
    ExportRequest? preparedRequest;
    final data = fixture()
      ..characterData = {
        'a': const CharacterEntryData(characterId: 'a', displayName: '甲角色'),
        'b': const CharacterEntryData(characterId: 'b', displayName: '乙角色'),
      };
    await tester.pumpWidget(
      MaterialApp(
        home: ProjectExportDialog(
          snapshot: data,
          isCurrent: () => true,
          prepare: (request) async {
            preparedRequest = request;
            return const ProjectExportService().prepare(data, request);
          },
          save: (_) async => const ExportSaveResult.cancelled(),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('export-purpose')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('局部專案交換').last);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<DropdownButtonFormField<ExportPurpose>>(
            find.byKey(const Key('export-purpose')),
          )
          .initialValue,
      ExportPurpose.exchange,
    );
    await tester.tap(find.text('章節內容'));
    await tester.pumpAndSettle();
    final parent = find.byKey(const ValueKey('export-module-check-Characters'));
    await tester.scrollUntilVisible(
      parent,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('角色設定與快照'));
    await tester.pumpAndSettle();
    final first = find.byKey(const ValueKey('export-check-character:a'));
    await tester.ensureVisible(first);
    expect(tester.widget<Checkbox>(parent).value, isFalse);
    expect(tester.widget<Checkbox>(first).value, isFalse);
    await tester.ensureVisible(parent);
    await tester.tap(parent);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(first).value, isTrue);
    await tester.tap(parent);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(first).value, isFalse);
    await tester.ensureVisible(first);
    await tester.tap(first);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(parent).value, isNull);
    await tester.tap(first);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(parent).value, isFalse);
    await tester.tap(find.byKey(const Key('export-prepare')));
    await tester.pumpAndSettle();
    expect(
      preparedRequest!.modules,
      isNot(contains(SelectiveProjectModule.characters)),
    );
    expect(find.byKey(const Key('export-preview-summary')), findsOneWidget);
  });

  testWidgets(
    'preview is required and cancellation/error can retry before actual success',
    (tester) async {
      final data = fixture();
      var calls = 0;
      ExportSaveResult? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                child: const Text('open'),
                onPressed: () async {
                  result = await showDialog<ExportSaveResult>(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => ProjectExportDialog(
                      snapshot: data,
                      isCurrent: () => true,
                      prepare: (request) async =>
                          const ProjectExportService().prepare(data, request),
                      save: (output) async {
                        calls++;
                        expect(
                          output.documents.single.preview,
                          contains('正文內容'),
                        );
                        if (calls == 1) {
                          return const ExportSaveResult.cancelled();
                        }
                        if (calls == 2) throw StateError('無法寫入');
                        return const ExportSaveResult.saved('/tmp/export.md');
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('export-save')))
            .onPressed,
        isNull,
      );
      await tester.tap(find.byKey(const Key('export-prepare')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('export-preview-summary')), findsOneWidget);
      await tester.tap(find.byKey(const Key('export-save')));
      await tester.pumpAndSettle();
      expect(find.text('已取消儲存，可重新選擇位置。'), findsOneWidget);
      expect(result, isNull);
      await tester.tap(find.byKey(const Key('export-save')));
      await tester.pumpAndSettle();
      expect(find.textContaining('無法寫入'), findsOneWidget);
      await tester.tap(find.byKey(const Key('export-save')));
      await tester.pumpAndSettle();
      expect(result!.status, ExportSaveStatus.saved);
      expect(calls, 3);
    },
  );

  testWidgets('stale source refuses preparation and saving', (tester) async {
    final data = fixture();
    var current = true;
    var saved = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ProjectExportDialog(
          snapshot: data,
          isCurrent: () => current,
          prepare: (request) async =>
              const ProjectExportService().prepare(data, request),
          save: (_) async {
            saved = true;
            return const ExportSaveResult.saved('saved');
          },
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('export-prepare')));
    await tester.pumpAndSettle();
    current = false;
    await tester.tap(find.byKey(const Key('export-save')));
    await tester.pumpAndSettle();
    expect(saved, isFalse);
    expect(find.textContaining('來源專案已切換'), findsOneWidget);
  });

  testWidgets('narrow dialog fits and Word/PDF remain disabled', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final data = fixture();
    await tester.pumpWidget(
      MaterialApp(
        home: ProjectExportDialog(
          snapshot: data,
          isCurrent: () => true,
          prepare: (request) async =>
              const ProjectExportService().prepare(data, request),
          save: (_) async => const ExportSaveResult.cancelled(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final dropdown = tester.widget<DropdownButtonFormField<ExportFormat>>(
      find.byKey(const ValueKey('export-format-manuscript')),
    );
    expect(dropdown, isNotNull);
    await tester.tap(find.byKey(const ValueKey('export-format-manuscript')));
    await tester.pumpAndSettle();
    expect(find.text('Word（尚未開放）'), findsWidgets);
    final word = tester.widget<DropdownMenuItem<ExportFormat>>(
      find
          .ancestor(
            of: find.text('Word（尚未開放）').last,
            matching: find.byType(DropdownMenuItem<ExportFormat>),
          )
          .last,
    );
    expect(word.enabled, isFalse);
    expect(tester.takeException(), isNull);
  });
}
