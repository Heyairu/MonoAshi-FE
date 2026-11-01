import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monogatari_assistant/models/project_file.dart';
import 'package:monogatari_assistant/models/writing_goal_data.dart';
import 'package:monogatari_assistant/presentation/providers/project_state_providers.dart';
import 'package:monogatari_assistant/presentation/providers/writing_goal_providers.dart';
import 'package:monogatari_assistant/presentation/widgets/writing_goal_dialog.dart';

Future<void> mount(WidgetTester tester, ProviderContainer container) async {
  await container.read(writingGoalDefaultsProvider.future);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          body: Consumer(
            builder: (context, ref, _) => TextButton(
              onPressed: () =>
                  showWritingGoalDialog(context, ref, WritingGoalKind.chapter),
              child: const Text('開啟目標'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('開啟目標'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
    'file override and restore inheritance leave defaults unchanged',
    (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(currentProjectFileProvider.notifier)
          .setCurrentProjectFile(
            ProjectFile(fileName: 'test.mnproj', filePath: null, content: ''),
          );
      await mount(tester, container);
      await tester.tap(find.text('僅限本檔案'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '3000');
      await tester.tap(find.text('套用'));
      await tester.pumpAndSettle();
      expect(container.read(projectWritingGoalsProvider).chapterWordGoal, 3000);
      expect(
        (await container.read(
          writingGoalDefaultsProvider.future,
        )).chapterWordGoal,
        2000,
      );
      await tester.tap(find.text('開啟目標'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('恢復使用預設'));
      await tester.pumpAndSettle();
      expect(
        container.read(projectWritingGoalsProvider).chapterWordGoal,
        isNull,
      );
      expect(container.read(effectiveChapterWordGoalProvider), 2000);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('changing project invalidates an open file goal dialog', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(currentProjectFileProvider.notifier)
        .setCurrentProjectFile(
          ProjectFile(fileName: 'a.mnproj', filePath: null, content: ''),
        );
    await mount(tester, container);
    await tester.tap(find.text('僅限本檔案'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '9999');
    container.read(projectWritingSessionProvider.notifier).state++;
    await tester.tap(find.text('套用'));
    await tester.pumpAndSettle();
    expect(find.textContaining('目前作品已變更'), findsOneWidget);
    expect(container.read(projectWritingGoalsProvider).chapterWordGoal, isNull);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('default edits preserve an existing file override', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(currentProjectFileProvider.notifier)
        .setCurrentProjectFile(
          ProjectFile(fileName: 'a.mnproj', filePath: null, content: ''),
        );
    container
        .read(projectWritingGoalsProvider.notifier)
        .setGoal(WritingGoalKind.chapter, 3000);
    await mount(tester, container);
    await tester.tap(find.text('預設'));
    await tester.pumpAndSettle();
    expect(find.textContaining('本檔案仍使用專屬目標 3000 字'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '2500');
    await tester.tap(find.text('套用'));
    await tester.pumpAndSettle();
    expect(container.read(effectiveChapterWordGoalProvider), 3000);
    expect(
      (await container.read(
        writingGoalDefaultsProvider.future,
      )).chapterWordGoal,
      2500,
    );
    await tester.pumpWidget(const SizedBox());
  });
}
