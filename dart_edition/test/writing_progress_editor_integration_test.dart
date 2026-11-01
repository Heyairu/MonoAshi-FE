import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monogatari_assistant/bin/content.dart';
import 'package:monogatari_assistant/features/writing_goals/daily_progress_controller.dart';
import 'package:monogatari_assistant/main.dart';
import 'package:monogatari_assistant/presentation/providers/writing_progress_provider.dart';
import 'helpers/writing_progress_test_support.dart';

void main() {
  for (final createProject in [false, true]) {
    testWidgets(
      '${createProject ? "new project" : "startup draft"} counts editor and stored draft changes once',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        await tester.binding.setSurfaceSize(const Size(1600, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final repository = MemoryProgressRepository();
        final container = ProviderContainer(
          overrides: [
            dailyWritingProgressProvider.overrideWith(
              (ref) => DailyProgressController(
                repository: repository,
                calculate: lengthDelta,
                scheduleMidnight: false,
              ),
            ),
          ],
        );
        addTearDown(container.dispose);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const MaterialApp(
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                FlutterQuillLocalizations.delegate,
              ],
              home: ContentView(),
            ),
          ),
        );
        await tester.pump(const Duration(seconds: 1));
        if (createProject) {
          final result = Actions.invoke(
            tester.element(find.byKey(const Key('toolbar-ribbon'))),
            const NewFileIntent(),
          );
          await tester.pump();
          if (result is Future<void>) await result;
          await tester.pump(const Duration(seconds: 1));
        }
        final progress = container.read(dailyWritingProgressProvider);
        final editor = tester.widget<EditorTextBox>(find.byType(EditorTextBox));
        editor.controller.text = '甲乙丙';
        await tester.pump(const Duration(milliseconds: 600));
        await progress.flush();
        expect(progress.todayTotal, 3);
        // A second synchronization/history pass must not count the draft again.
        await tester.pump(const Duration(seconds: 1));
        await progress.flush();
        expect(progress.todayTotal, 3);
        if (createProject) {
          editor.onUndo!();
          await tester.pump(const Duration(milliseconds: 400));
          await progress.flush();
          expect(progress.todayTotal, 0);
          editor.onRedo!();
          await tester.pump(const Duration(milliseconds: 400));
          await progress.flush();
          expect(progress.todayTotal, 3);
        }
        await tester.pumpWidget(const SizedBox());
        await tester.pump();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
