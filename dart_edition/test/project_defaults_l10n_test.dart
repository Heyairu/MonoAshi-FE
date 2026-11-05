import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/application/project_import/selective_project_import.dart';
import 'package:monogatari_assistant/bin/file.dart';
import 'package:monogatari_assistant/data/repositories/file_repository.dart';
import 'package:monogatari_assistant/l10n/app_localization.dart';
import 'package:monogatari_assistant/models/codecs/timeline_codec.dart';
import 'package:monogatari_assistant/presentation/providers/project_state_providers.dart';
import 'package:xml/xml.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final locales = {
    const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'): [
      '資料夾 1',
      '序章',
      '開場',
      '主要場景',
      '時間軸 1',
      '故事開始',
      '未命名軌道',
    ],
    const Locale('en'): [
      'Folder 1',
      'Prologue',
      'Opening',
      'Main setting',
      'Timeline 1',
      'Story begins',
      'Untitled track',
    ],
    const Locale('ja'): [
      'フォルダー 1',
      '序章',
      '導入',
      '主な舞台',
      'タイムライン 1',
      '物語の始まり',
      '無題のトラック',
    ],
  };
  void expectSeed(ProjectData data, List<String> expected) {
    expect(data.segmentsData.single.segmentName, expected[0]);
    expect(data.segmentsData.single.chapters.single.chapterName, 'Chapter1');
    expect(data.outlineData.single.storylineName, expected[1]);
    expect(data.outlineData.single.storylineType, expected[2]);
    expect(data.worldSettingsData.single.localName, expected[3]);
    expect(data.timelineDocument.tracks.single.name, expected[4]);
    expect(data.timelineDocument.grid.originLabel, expected[5]);
  }

  for (final entry in locales.entries) {
    final l10n = lookupAppLocalizations(entry.key);
    final defaults = l10n.projectDefaults;
    test('new and missing project data use ${entry.key}', () async {
      expectSeed(ProjectData.empty(defaults: defaults), entry.value);
      final repository = DefaultFileRepository(localizations: () => l10n);
      expect((await repository.createNewProject()).fileName, l10n.uiUntitled2);
      final loaded = await repository.loadProjectFromXml(
        ProjectFile(
          fileName: 'old.mnproj',
          filePath: null,
          content: '<Project><ver>1.22</ver></Project>',
        ),
      );
      expectSeed(loaded, entry.value);
      final timeline = TimelineCodec.loadElement(
        XmlDocument.parse(
          '<Type><Name>Timeline</Name><Timeline><Track UUID="track" /></Timeline></Type>',
        ).rootElement,
        defaults: defaults,
      )!;
      expect(timeline.document.grid.originLabel, entry.value[5]);
      expect(timeline.document.tracks.single.name, entry.value[6]);
    });

    test('startup provider seeds use ${entry.key}', () {
      final container = ProviderContainer(
        overrides: [initialProjectDefaultsProvider.overrideWithValue(defaults)],
      );
      addTearDown(container.dispose);
      expect(
        container.read(segmentsDataProvider).single.segmentName,
        entry.value[0],
      );
      expect(
        container.read(segmentsDataProvider).single.chapters.single.chapterName,
        'Chapter1',
      );
      expect(
        container.read(outlineDataProvider).single.storylineName,
        entry.value[1],
      );
      expect(
        container.read(worldSettingsDataProvider).single.localName,
        entry.value[3],
      );
      expect(
        container.read(timelineDocumentProvider).tracks.single.name,
        entry.value[4],
      );
    });

    test(
      'localized seeds remain replaceable by structural imports, ${entry.key}',
      () {
        final manifest = SelectiveProjectImportManifest.fromXml('''
<Project><SelectiveExport>
  <Module>Chapters</Module><Module>Outline</Module><Module>WorldSettings</Module>
</SelectiveExport><ExportScope Version="1">
  <Module Id="Chapters" Mode="partial"><Selected Id="x"/><Structural Id="y"/></Module>
  <Module Id="Outline" Mode="partial"><Selected Id="x"/><Structural Id="y"/></Module>
  <Module Id="WorldSettings" Mode="partial"><Selected Id="x"/><Structural Id="y"/></Module>
</ExportScope></Project>''');
        final data = ProjectData.empty(defaults: defaults);
        expect(manifest.structuralModules, hasLength(3));
        expect(manifest.blockedReplacements(data), isEmpty);
        data.segmentsData = [
          data.segmentsData.single.copyWith(segmentName: 'My folder'),
        ];
        expect(
          manifest.blockedReplacements(data),
          contains(SelectiveProjectModule.chapters),
        );
      },
    );
  }

  test(
    'loading a different locale preserves saved names including defaults',
    () {
      final original = ProjectData.empty(
        defaults: lookupAppLocalizations(const Locale('ja')).projectDefaults,
      );
      final source = FileService.generateProjectXMLWithoutLatestSaveUpdate(
        original,
      );
      final loaded = FileService.parseProjectXML(
        source,
        defaults: lookupAppLocalizations(const Locale('en')).projectDefaults,
      );
      expectSeed(loaded, locales[const Locale('ja')]!);
    },
  );
}
