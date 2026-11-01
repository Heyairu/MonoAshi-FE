import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/application/project_export/export_models.dart';
import 'package:monogatari_assistant/application/project_export/export_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monogatari_assistant/bin/file.dart';
import 'package:monogatari_assistant/models/writing_goal_data.dart';
import 'package:monogatari_assistant/models/project_migrator.dart';
import 'package:monogatari_assistant/presentation/providers/writing_goal_providers.dart';
import 'package:monogatari_assistant/presentation/providers/project_state_providers.dart';
import 'package:monogatari_assistant/presentation/providers/project_snapshot_utils.dart';
import 'package:monogatari_assistant/presentation/providers/project_history_provider.dart';
import 'package:monogatari_assistant/application/collaboration/project_record_codec.dart';
import 'package:monogatari_assistant/application/project_import/selective_project_import.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'defaults persist while equal-valued overrides retain their scope',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(writingGoalDefaultsProvider.future);
      container
          .read(projectWritingGoalsProvider.notifier)
          .setGoal(WritingGoalKind.chapter, 2000);
      await container
          .read(writingGoalDefaultsProvider.notifier)
          .setGoal(WritingGoalKind.chapter, 2500);
      expect(container.read(effectiveChapterWordGoalProvider), 2000);
      container
          .read(projectWritingGoalsProvider.notifier)
          .setGoal(WritingGoalKind.chapter, null);
      expect(container.read(effectiveChapterWordGoalProvider), 2500);
      expect(container.read(effectiveTotalWordGoalProvider), 100000);
      final restarted = ProviderContainer();
      addTearDown(restarted.dispose);
      expect(
        (await restarted.read(
          writingGoalDefaultsProvider.future,
        )).chapterWordGoal,
        2500,
      );
    },
  );

  test('concurrent default saves do not overwrite another metric', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(writingGoalDefaultsProvider.notifier);
    await Future.wait([
      notifier.setGoal(WritingGoalKind.chapter, 3000),
      notifier.setGoal(WritingGoalKind.daily, 1500),
    ]);
    final defaults = await container.read(writingGoalDefaultsProvider.future);
    expect(defaults.dailyWordGoal, 1500);
    expect(defaults.chapterWordGoal, 3000);
  });

  test('1.18 upgrades to 1.20 without materializing defaults', () {
    final parsed = FileService.parseProjectXMLWithMetadata(
      '<Project><ver>1.18</ver></Project>',
    );
    expect(parsed.wasMigrated, isTrue);
    expect(parsed.data.writingGoals, const ProjectWritingGoals());
    final xml = FileService.generateProjectXML(parsed.data);
    expect(xml, contains('<ver>1.20</ver>'));
    expect(xml, isNot(contains('<Name>WritingGoals</Name>')));
  });

  test('single override survives migration, snapshot, history and XML', () {
    final data = ProjectData.empty()
      ..writingGoals = const ProjectWritingGoals(totalWordGoal: 120000);
    final migrated = ProjectMigrator.migrate(
      sourceVersion: '1.10',
      parsedData: data,
    ).data;
    final snapshot = snapshotProjectData(migrated);
    final entry = ProjectHistoryEntry(
      data: snapshot,
      pageIndex: 1,
      selectedSegID: null,
      selectedChapID: null,
      cursorOffset: 0,
    );
    final xml = FileService.generateProjectXML(entry.data);
    expect(xml, contains('<TotalWordGoal>120000</TotalWordGoal>'));
    expect(xml, isNot(contains('ChapterWordGoal')));
    expect(FileService.parseProjectXML(xml).writingGoals, data.writingGoals);
    final inherited = snapshotProjectData(data)
      ..writingGoals = const ProjectWritingGoals();
    final inheritedEntry = ProjectHistoryEntry(
      data: inherited,
      pageIndex: 1,
      selectedSegID: null,
      selectedChapID: null,
      cursorOffset: 0,
    );
    expect(inheritedEntry.contentDigest, isNot(entry.contentDigest));
  });

  test('unknown, invalid and duplicate goal payloads survive a repaired save', () {
    for (final raw in [
      '<Type Version="9"><Name>WritingGoals</Name><Future>yes</Future></Type>',
      '<Type Version="1"><Name>WritingGoals</Name><ChapterWordGoal>0</ChapterWordGoal></Type>',
      '<Type Version="1"><Name>WritingGoals</Name></Type><Type Version="1"><Name>WritingGoals</Name></Type>',
    ]) {
      final parsed = FileService.parseProjectXMLWithMetadata(
        '<Project><ver>1.20</ver>$raw</Project>',
      );
      expect(
        parsed.migrationWarnings.map((w) => w.code),
        contains('writing-goals-recovery'),
      );
      final recovery = parsed.data.writingGoals.recoveryXml;
      expect(recovery, isNotEmpty);
      parsed.data.writingGoals = parsed.data.writingGoals.withGoal(
        WritingGoalKind.chapter,
        4000,
      );
      final reloaded = FileService.parseProjectXML(
        FileService.generateProjectXML(parsed.data),
      );
      expect(reloaded.writingGoals.chapterWordGoal, 4000);
      expect(reloaded.writingGoals.recoveryXml, recovery);
    }
  });

  test('deduplicated history retains the latest progress coordinate', () async {
    final data = ProjectData.empty();
    ProjectHistoryEntry entry(int value) => ProjectHistoryEntry(
      data: data,
      pageIndex: 1,
      selectedSegID: null,
      selectedChapID: null,
      cursorOffset: 0,
      writingProgressPosition: Future.value(value),
    );
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final history = container.read(projectHistoryProvider.notifier);
    history.reset(entry(0));
    expect(history.record(entry(5)), isFalse);
    expect(container.read(projectHistoryProvider).undoStack, hasLength(1));
    expect(
      await container
          .read(projectHistoryProvider)
          .undoStack
          .last
          .writingProgressPosition,
      5,
    );
  });

  test(
    'collaboration records round trip explicit inheritance and overrides',
    () {
      final data = ProjectData.empty()
        ..writingGoals = const ProjectWritingGoals(chapterWordGoal: 3333);
      expect(
        ProjectRecordCodec.decodeWritingGoals(
          ProjectRecordCodec.snapshot(data),
        ),
        data.writingGoals,
      );
      data.writingGoals = const ProjectWritingGoals();
      expect(
        ProjectRecordCodec.decodeWritingGoals(
          ProjectRecordCodec.snapshot(data),
        ),
        data.writingGoals,
      );
    },
  );

  test('partial XML exchange omits file-owned goals', () {
    final data = ProjectData.empty()
      ..writingGoals = const ProjectWritingGoals(chapterWordGoal: 3210);
    final prepared = const ProjectExportService().prepare(
      data,
      ExportRequest(
        purpose: ExportPurpose.exchange,
        format: ExportFormat.xml,
        modules: {SelectiveProjectModule.chapters},
      ),
    );
    final xml = utf8.decode(prepared.bytes);
    expect(xml, contains('ChapterSelection'));
    expect(xml, isNot(contains('WritingGoals')));
  });

  test('partial import preserves the receiving file goals', () {
    final current = ProjectData.empty()
      ..writingGoals = const ProjectWritingGoals(chapterWordGoal: 3210);
    final source = ProjectData.empty()
      ..writingGoals = const ProjectWritingGoals(totalWordGoal: 99999);
    final xml = FileService.generateProjectXML(source);
    final manifest = SelectiveProjectImportManifest.fromXml(xml);
    final result = const SelectiveProjectImporter().apply(
      current: current,
      source: source,
      manifest: manifest,
      selectedModules: {SelectiveProjectModule.chapters},
    );
    expect(result.data.writingGoals, current.writingGoals);
  });
}
