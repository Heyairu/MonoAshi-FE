import 'dart:async';
import 'dart:io';
import 'helpers/writing_progress_test_support.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/data/repositories/writing_progress_repository.dart';
import 'package:monogatari_assistant/features/writing_goals/daily_progress_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('signed deltas aggregate across projects without clamping', () async {
    final repository = MemoryProgressRepository();
    final controller = DailyProgressController(
      repository: repository,
      calculate: lengthDelta,
      clock: () => DateTime(2026, 11, 1),
      scheduleMidnight: false,
    );
    addTearDown(controller.dispose);
    controller.replaceBaseline('A', {'a': ''});
    controller.observeChapter('a', '文' * 800);
    controller.endSession();
    controller.replaceBaseline('B', {'b': '文' * 200});
    controller.observeChapter('b', '');
    await controller.flush();
    expect(controller.todayTotal, 600);
    controller.observeChapter('b', '文' * 150);
    await controller.flush();
    expect(controller.todayTotal, 750);
    final restarted = DailyProgressController(
      repository: repository,
      calculate: lengthDelta,
      clock: () => DateTime(2026, 11, 1),
      scheduleMidnight: false,
    );
    addTearDown(restarted.dispose);
    restarted.replaceBaseline('B', {'b': '文' * 150});
    await restarted.flush();
    expect(restarted.todayTotal, 750);
  });

  test(
    'excluded imports update baseline and their history checkpoint earns no credit',
    () async {
      final c = DailyProgressController(
        repository: MemoryProgressRepository(),
        calculate: lengthDelta,
        scheduleMidnight: false,
      );
      addTearDown(c.dispose);
      c.replaceBaseline('A', {'a': ''});
      c.observeChapter('a', 'abc');
      final beforeImport = c.checkpoint();
      c.observeChapter('a', 'imported', counted: false);
      final afterImport = c.checkpoint();
      c.observeChapter('a', 'imported!');
      await c.flush();
      expect(c.todayTotal, 4);
      c.restoreCheckpoint(afterImport);
      c.replaceBaseline('A', {'a': 'imported'});
      await c.flush();
      expect(c.todayTotal, 3);
      c.restoreCheckpoint(beforeImport);
      c.replaceBaseline('A', {'a': 'abc'});
      await c.flush();
      expect(c.todayTotal, 3);
      c.observeChapter('a', 'abcd');
      await c.flush();
      expect(c.todayTotal, 4);
    },
  );

  test(
    'saved position allows discarding local changes without subtracting imports',
    () async {
      final c = DailyProgressController(
        repository: MemoryProgressRepository(),
        calculate: lengthDelta,
        scheduleMidnight: false,
      );
      addTearDown(c.dispose);
      c.replaceBaseline('A', {'a': ''});
      c.observeChapter('a', 'abc');
      c.markSaved();
      c.observeChapter('a', 'imported', counted: false);
      c.observeChapter('a', 'imported!!');
      c.discardUnsaved();
      await c.flush();
      expect(c.todayTotal, 3);
    },
  );

  test(
    'save completion preserves its snapshot coordinate while typing continues',
    () async {
      final c = DailyProgressController(
        repository: MemoryProgressRepository(),
        calculate: lengthDelta,
        scheduleMidnight: false,
      );
      addTearDown(c.dispose);
      c.replaceBaseline('A', {'a': ''});
      c.observeChapter('a', 'abc');
      final savingPosition = c.checkpoint();
      c.observeChapter('a', 'abcde');
      c.markSaved(position: savingPosition);
      c.discardUnsaved();
      await c.flush();
      expect(c.todayTotal, 3);
      c.adoptProjectIdentity('B');
      c.replaceBaseline('B', {'a': 'abc'});
      c.observeChapter('a', 'abcd');
      await c.flush();
      expect(c.todayTotal, 4);
      expect(c.ledger.days[c.day]?['B'], 1);
    },
  );

  test(
    'delayed results retain their event date and project after midnight',
    () async {
      var now = DateTime(2026, 11, 1, 23, 59);
      final pending = Completer<int>();
      var calls = 0;
      final c = DailyProgressController(
        repository: MemoryProgressRepository(),
        clock: () => now,
        calculate: (changes) =>
            ++calls == 1 ? pending.future : lengthDelta(changes),
        scheduleMidnight: false,
      );
      addTearDown(c.dispose);
      c.replaceBaseline('A', {'a': ''});
      c.observeChapter('a', 'abc');
      c.checkpoint();
      now = DateTime(2026, 11, 2);
      c.endSession();
      c.replaceBaseline('B', {'b': ''});
      c.observeChapter('b', '12345');
      pending.complete(3);
      await c.flush();
      expect(c.ledger.totalFor('2026-11-01'), 3);
      expect(c.todayTotal, 5);
      expect(c.ledger.days['2026-11-01']?['A'], 3);
    },
  );

  test(
    'write failure retains ordered work for retry without double counting',
    () async {
      final repository = MemoryProgressRepository();
      final c = DailyProgressController(
        repository: repository,
        calculate: lengthDelta,
        scheduleMidnight: false,
      );
      addTearDown(c.dispose);
      c.replaceBaseline('A', {'a': ''});
      await c.flush();
      repository.fail = true;
      c.observeChapter('a', 'abc');
      await expectLater(c.flush(), throwsStateError);
      expect(c.todayTotal, 0);
      repository.fail = false;
      await c.retry();
      expect(c.todayTotal, 3);
      await c.flush();
      expect(c.todayTotal, 3);
    },
  );

  test('production count uses reader text and a stable word policy', () async {
    expect(
      await calculateWritingDelta({
        'a': ['', '中文 hello world 👋'],
      }),
      5,
    );
    expect(
      await calculateWritingDelta({
        'a': ['abc', ''],
      }),
      -1,
    );
  });

  test(
    'parallel disk writers merge instead of losing another window',
    () async {
      final folder = await Directory.systemTemp.createTemp('writing-parallel-');
      addTearDown(() => folder.delete(recursive: true));
      await Future.wait(
        List.generate(
          12,
          (i) => WritingProgressRepository(directory: () async => folder)
              .applyDelta(
                session: 'session-$i',
                sequence: 1,
                day: '2026-11-01',
                project: 'project-$i',
                delta: 1,
              ),
        ),
      );
      final ledger = await WritingProgressRepository(
        directory: () async => folder,
      ).load();
      expect(ledger.totalFor('2026-11-01'), 12);
      expect(ledger.sequences, hasLength(12));
    },
  );

  test(
    'disk ledger merges writers, deduplicates events and recovers backup',
    () async {
      final folder = await Directory.systemTemp.createTemp('writing-progress-');
      addTearDown(() => folder.delete(recursive: true));
      final r = WritingProgressRepository(directory: () async => folder);
      await r.applyDelta(
        session: 'one',
        sequence: 1,
        day: '2026-11-01',
        project: 'A',
        delta: 800,
      );
      await r.applyDelta(
        session: 'two',
        sequence: 1,
        day: '2026-11-01',
        project: 'B',
        delta: -200,
      );
      await r.applyDelta(
        session: 'one',
        sequence: 1,
        day: '2026-11-01',
        project: 'A',
        delta: 800,
      );
      expect((await r.load()).totalFor('2026-11-01'), 600);
      await File(
        '${folder.path}/Data/WritingProgress.json',
      ).writeAsString('corrupt');
      final recovered = await r.load();
      expect(recovered.totalFor('2026-11-01'), 800);
      expect(recovered.warning, isNotNull);
      expect(
        await Directory(
          '${folder.path}/Data',
        ).list().where((f) => f.path.contains('.corrupt.')).length,
        1,
      );
    },
  );
}
