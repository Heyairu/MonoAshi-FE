import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/file.dart';
import 'package:monogatari_assistant/models/chapter_selection_data.dart';
import 'package:monogatari_assistant/application/project_export/export_selection.dart';
import 'package:monogatari_assistant/presentation/providers/project_state_providers.dart';

List<SegmentData> damagedTree() => [
  SegmentData.raw(
    segmentUUID: 'same',
    segmentName: 'Root',
    chapters: [
      ChapterData.raw(chapterUUID: 'same', chapterContent: 'first'),
      ChapterData.raw(chapterUUID: '', chapterContent: 'second'),
      ChapterData.raw(chapterUUID: 'valid', chapterContent: 'third'),
    ],
    childSegments: [
      SegmentData.raw(
        segmentUUID: 'same',
        segmentName: 'Child',
        chapters: [
          ChapterData.raw(chapterUUID: 'valid', chapterContent: 'fourth'),
          ChapterData.raw(chapterUUID: '  ', chapterContent: 'fifth'),
        ],
      ),
    ],
    childNodeOrder: ['missing', 'valid', 'same', 'same', ''],
  ),
];

void checkRecovered(List<SegmentData> roots) {
  final folders = ChapterTree.foldersDepthFirst(roots).toList();
  final chapters = ChapterTree.chaptersDepthFirst(roots).toList();
  final ids = [
    for (final folder in folders) folder.segmentUUID,
    for (final location in chapters) location.chapter.chapterUUID,
  ];
  expect(ids, hasLength(7));
  expect(ids.toSet(), hasLength(7));
  expect(ids.every((id) => id.trim().isNotEmpty), isTrue);
  expect(roots.single.segmentUUID, 'same');
  expect(roots.single.chapters.last.chapterUUID, 'valid');
  expect(
    chapters.map((c) => c.chapter.chapterContent),
    unorderedEquals(['first', 'second', 'third', 'fourth', 'fifth']),
  );
  expect(chapters.first.chapter.chapterContent, 'third');
  expect(ChapterTree.repair(roots), roots);
  final project = ProjectData.empty()..segmentsData = roots;
  expect(() => buildExportSelections(project), returnsNormally);
}

void main() {
  test(
    'repairs blank and colliding IDs without losing text or mixed order',
    () {
      final source = damagedTree();
      final recovered = ChapterTree.repair(source);
      checkRecovered(recovered);
      expect(ChapterTree.repair(source), recovered);
      expect(source.single.chapters.first.chapterUUID, 'same');
    },
  );

  test(
    'provider repairs incoming trees before editor traversal and export',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(segmentsDataProvider.notifier)
          .setSegmentsData(damagedTree());
      checkRecovered(container.read(segmentsDataProvider));
    },
  );

  test(
    'legacy XML with duplicate IDs reopens with every manuscript intact',
    () {
      const xml = '''<Project><ver>1.22</ver>
<Type ChapterTreeVersion="3"><Name>ChapterSelection</Name>
<Segment Name="Root" UUID="same">
  <Chapter Name="1" UUID="same"><Content>first</Content></Chapter>
  <Chapter Name="2" UUID=""><Content>second</Content></Chapter>
  <Chapter Name="3" UUID="valid"><Content>third</Content></Chapter>
  <Segment Name="Child" UUID="same">
    <Chapter Name="4" UUID="valid"><Content>fourth</Content></Chapter>
    <Chapter Name="5" UUID=" "><Content>fifth</Content></Chapter>
  </Segment>
</Segment></Type></Project>''';
      final reopened = FileService.parseProjectXML(xml);
      final folders = ChapterTree.foldersDepthFirst(
        reopened.segmentsData,
      ).toList();
      final chapters = folders.expand((f) => f.chapters).toList();
      expect(
        chapters.map((c) => c.chapterContent),
        unorderedEquals(['first', 'second', 'third', 'fourth', 'fifth']),
      );
      final ids = [
        ...folders.map((f) => f.segmentUUID),
        ...chapters.map((c) => c.chapterUUID),
      ];
      expect(ids.toSet().length, ids.length);
      expect(() => buildExportSelections(reopened), returnsNormally);
      final saved = FileService.generateProjectXML(reopened);
      final secondLoad = FileService.parseProjectXML(saved);
      expect(secondLoad.segmentsData, reopened.segmentsData);
    },
  );

  test('new chapter and folder IDs remain unique under rapid creation', () {
    final ids = <String>{};
    for (var i = 0; i < 10000; i++) {
      expect(ids.add(ChapterData().chapterUUID), isTrue);
      expect(ids.add(SegmentData().segmentUUID), isTrue);
    }
  });
}
