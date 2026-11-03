import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:monogatari_assistant/bin/file.dart';
import 'package:monogatari_assistant/modules/chapterselectionview.dart'
    as chapter_module;
import 'package:monogatari_assistant/presentation/providers/project_history_provider.dart';
import 'package:monogatari_assistant/features/navigation/app_module.dart';

ProjectData _projectWithChapterContent(String content) {
  return ProjectData.empty()
    ..segmentsData = [
      chapter_module.SegmentData(
        segmentName: 'Segment',
        segmentUUID: 'segment-1',
        chapters: [
          chapter_module.ChapterData(
            chapterName: 'Chapter',
            chapterUUID: 'chapter-1',
            chapterContent: content,
          ),
        ],
      ),
    ]
    ..contentText = content;
}

ProjectHistoryEntry _entry(
  String content, {
  int pageIndex = 0,
  bool isPageTransition = false,
}) {
  return _entryFromData(
    _projectWithChapterContent(content),
    pageIndex: pageIndex,
    cursorOffset: content.length,
    isPageTransition: isPageTransition,
  );
}

ProjectHistoryEntry _entryFromData(
  ProjectData data, {
  int pageIndex = 0,
  int cursorOffset = 0,
  bool isPageTransition = false,
}) {
  return ProjectHistoryEntry(
    data: data,
    pageIndex: pageIndex,
    selectedSegID: 'segment-1',
    selectedChapID: 'chapter-1',
    cursorOffset: cursorOffset,
    isPageTransition: isPageTransition,
  );
}

void main() {
  test('record skips unchanged XML snapshots without page transition', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final history = container.read(projectHistoryProvider.notifier);
    final baseEntry = _entry('one');
    history.reset(baseEntry);

    expect(history.record(_entryFromData(baseEntry.data)), false);
    expect(container.read(projectHistoryProvider).undoStack, hasLength(1));

    expect(history.record(_entry('two')), true);
    expect(container.read(projectHistoryProvider).undoStack, hasLength(2));
  });

  test('browsing does not commit a page transition without a modification', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final history = container.read(projectHistoryProvider.notifier);
    final baseEntry = _entry('one', pageIndex: 1);
    history.reset(baseEntry);

    expect(
      history.record(
        _entryFromData(baseEntry.data, pageIndex: 2, isPageTransition: true),
      ),
      false,
    );
    expect(container.read(projectHistoryProvider).undoStack, hasLength(1));
  });

  test('undo and redo return full project snapshots with page metadata', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final history = container.read(projectHistoryProvider.notifier);
    history.reset(_entry('one', pageIndex: 1));
    history.record(_entry('two', pageIndex: 2));
    history.record(_entry('three', pageIndex: 3));

    final currentEntry = container.read(projectHistoryProvider).undoStack.last;
    final undoTarget = history.undo(currentEntry);
    expect(undoTarget, isNotNull);
    expect(undoTarget!.pageIndex, 3);
    expect(undoTarget.isPageTransition, isTrue);
    expect(
      undoTarget.data.segmentsData.first.chapters.first.chapterContent,
      'two',
    );
    expect(container.read(projectHistoryProvider).canRedo, true);

    final previousPage = history.undo(undoTarget)!;
    expect(previousPage.pageIndex, 2);
    final redoJump = history.redo(previousPage)!;
    expect(redoJump.isPageTransition, isTrue);
    expect(redoJump.pageIndex, 3);
    final redoTarget = history.redo(redoJump);
    expect(redoTarget, isNotNull);
    expect(redoTarget!.pageIndex, 3);
    expect(
      redoTarget.data.segmentsData.first.chapters.first.chapterContent,
      'three',
    );
  });

  test('undo stack keeps the newest 50 XML snapshots', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final history = container.read(projectHistoryProvider.notifier);
    history.reset(_entry('0'));
    for (var i = 1; i <= 60; i++) {
      history.record(_entry('$i'));
    }

    final state = container.read(projectHistoryProvider);
    expect(state.undoStack, hasLength(50));
    expect(
      state
          .undoStack
          .first
          .data
          .segmentsData
          .first
          .chapters
          .first
          .chapterContent,
      '11',
    );
    expect(
      state
          .undoStack
          .last
          .data
          .segmentsData
          .first
          .chapters
          .first
          .chapterContent,
      '60',
    );
  });

  test('modification commits its destination baseline before its content', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final history = container.read(projectHistoryProvider.notifier);
    final baseEntry = _entry('one', pageIndex: 1);
    history.reset(baseEntry);
    history.record(
      _entryFromData(baseEntry.data, pageIndex: 2, isPageTransition: true),
    );
    history.record(_entry('two', pageIndex: 2));

    final state = container.read(projectHistoryProvider);
    expect(state.undoStack, hasLength(3));
    expect(state.undoStack.first.pageIndex, 1);
    expect(state.undoStack[1].pageIndex, 2);
    expect(state.undoStack[1].isPageTransition, isTrue);
    expect(state.undoStack[1].contentDigest, baseEntry.contentDigest);
    expect(identical(state.undoStack[1].data, baseEntry.data), isTrue);
    expect(state.undoStack.last.pageIndex, 2);
    expect(
      state
          .undoStack
          .last
          .data
          .segmentsData
          .first
          .chapters
          .first
          .chapterContent,
      'two',
    );
  });

  test('unchanged navigation and records leave history untouched', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final history = container.read(projectHistoryProvider.notifier);
    final baseEntry = _entry('one', pageIndex: 1);
    history.reset(baseEntry);
    history.record(
      _entryFromData(baseEntry.data, pageIndex: 2, isPageTransition: true),
    );

    expect(history.record(_entryFromData(baseEntry.data, pageIndex: 2)), false);

    final state = container.read(projectHistoryProvider);
    expect(state.undoStack, hasLength(1));
    expect(state.undoStack.single.pageIndex, 1);
  });

  test(
    'only the edited destination is retained after browsing several pages',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final history = container.read(projectHistoryProvider.notifier);
      final initial = _entry('one', pageIndex: 1);
      history.reset(initial);
      for (final page in [2, 7, 0, 16]) {
        history.record(
          _entryFromData(initial.data, pageIndex: page, isPageTransition: true),
        );
        history.record(_entryFromData(initial.data, pageIndex: page));
      }
      history.record(_entry('two', pageIndex: 5));
      final entries = container.read(projectHistoryProvider).undoStack;
      expect(entries.map((entry) => entry.pageIndex), [1, 5, 5]);
      expect(entries.map((entry) => entry.isPageTransition), [
        false,
        true,
        false,
      ]);
    },
  );

  test('browsing after Undo preserves the complete Redo branch', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final history = container.read(projectHistoryProvider.notifier);
    final a = _entry('one', pageIndex: 1);
    final b = _entry('two', pageIndex: 5);
    history.reset(a);
    history.record(b);
    final baseline = history.undo(b)!;
    history.record(
      _entryFromData(baseline.data, pageIndex: 7, isPageTransition: true),
    );
    history.record(_entryFromData(baseline.data, pageIndex: 7));
    expect(
      history.redo(_entryFromData(baseline.data, pageIndex: 7))?.contentDigest,
      b.contentDigest,
    );
  });

  test(
    'Undo captures an immediate edit with its page baseline before debounce',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final history = container.read(projectHistoryProvider.notifier);
      final a = _entry('one', pageIndex: 1);
      final b = _entry('two', pageIndex: 5);
      history.reset(a);
      final baseline = history.undo(b)!;
      expect(baseline.pageIndex, 5);
      expect(baseline.isPageTransition, isTrue);
      expect(baseline.contentDigest, a.contentDigest);
      expect(history.undo(baseline)?.pageIndex, 1);
    },
  );

  test('a fresh edit invalidates Redo before its debounce timer runs', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final history = container.read(projectHistoryProvider.notifier);
    final a = _entry('one');
    final b = _entry('two');
    final c = _entry('fresh', pageIndex: 5);
    history.reset(a);
    history.record(b);
    history.undo(b);
    expect(history.redo(c), isNull);
    final state = container.read(projectHistoryProvider);
    expect(state.redoStack, isEmpty);
    expect(state.undoStack.last.contentDigest, c.contentDigest);
    expect(
      state.undoStack[state.undoStack.length - 2].isPageTransition,
      isTrue,
    );
  });

  for (final desktop in [false, true]) {
    test(
      '${desktop ? "desktop" : "mobile"} replays editor jumps with the proper number of steps',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final history = container.read(projectHistoryProvider.notifier);
        final a = _entry('one', pageIndex: 5);
        final b = _entry('body', pageIndex: AppModule.editorPageIndex);
        history.reset(a);
        history.record(b);
        expect(container.read(projectHistoryProvider).undoStack, hasLength(3));
        final undone = history.undo(b, skipEditorTransitions: desktop)!;
        expect(undone.contentDigest, a.contentDigest);
        if (desktop) {
          expect(undone.pageIndex, 5);
          expect(
            container.read(projectHistoryProvider).redoStack,
            hasLength(2),
          );
        } else {
          expect(undone.pageIndex, AppModule.editorPageIndex);
          expect(undone.isPageTransition, isTrue);
          final beforeJump = history.undo(undone)!;
          expect(beforeJump.pageIndex, 5);
          final jump = history.redo(beforeJump)!;
          expect(jump.pageIndex, AppModule.editorPageIndex);
          expect(jump.isPageTransition, isTrue);
        }
        final redone = history.redo(undone, skipEditorTransitions: desktop)!;
        expect(redone.contentDigest, b.contentDigest);
        expect(redone.isPageTransition, isFalse);
        expect(container.read(projectHistoryProvider).canRedo, isFalse);
      },
    );
  }

  test('desktop skipping editor jumps does not skip other modules', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final history = container.read(projectHistoryProvider.notifier);
    final a = _entry('one', pageIndex: 1);
    final body = _entry('body', pageIndex: AppModule.editorPageIndex);
    final character = _entry('character', pageIndex: 5);
    history.reset(a);
    history.record(body);
    history.record(character);
    final jump = history.undo(character, skipEditorTransitions: true)!;
    expect(jump.pageIndex, 5);
    expect(jump.isPageTransition, isTrue);
    expect(jump.contentDigest, body.contentDigest);
    final previous = history.undo(jump, skipEditorTransitions: true)!;
    expect(previous.contentDigest, body.contentDigest);
    expect(
      history.undo(previous, skipEditorTransitions: true)?.contentDigest,
      a.contentDigest,
    );
  });

  test(
    'switching to desktop while on an editor jump does not consume an empty Undo',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final history = container.read(projectHistoryProvider.notifier);
      final initial = _entry('initial', pageIndex: 5);
      final modified = _entry('modified', pageIndex: 5);
      final body = _entry('body', pageIndex: AppModule.editorPageIndex);
      history.reset(initial);
      history.record(modified);
      history.record(body);
      final jump = history.undo(body)!;
      expect(jump.isPageTransition, isTrue);
      final undone = history.undo(jump, skipEditorTransitions: true)!;
      expect(undone.contentDigest, initial.contentDigest);
      expect(
        history.redo(undone, skipEditorTransitions: true)?.contentDigest,
        modified.contentDigest,
      );
      expect(
        history.redo(modified, skipEditorTransitions: true)?.contentDigest,
        body.contentDigest,
      );
    },
  );

  test(
    'entry limits retain the editor content baseline when skipping its jump',
    () {
      final provider =
          NotifierProvider<ProjectHistoryNotifier, ProjectHistoryState>(
            () => ProjectHistoryNotifier(maxEntries: 2),
          );
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final history = container.read(provider.notifier);
      final initial = _entry('initial', pageIndex: 5);
      final body = _entry('body', pageIndex: AppModule.editorPageIndex);
      history.reset(initial);
      history.record(body);
      final undone = history.undo(body, skipEditorTransitions: true)!;
      expect(undone.contentDigest, initial.contentDigest);
      expect(
        history.redo(undone, skipEditorTransitions: true)?.contentDigest,
        body.contentDigest,
      );
    },
  );
}
