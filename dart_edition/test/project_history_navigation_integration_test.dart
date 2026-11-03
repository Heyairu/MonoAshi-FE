import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/content.dart';
import 'package:monogatari_assistant/bin/slidebar.dart';
import 'package:monogatari_assistant/features/navigation/app_module.dart';
import 'package:monogatari_assistant/main.dart';
import 'package:monogatari_assistant/modules/baseinfoview.dart';
import 'package:monogatari_assistant/presentation/providers/project_history_provider.dart';
import 'package:monogatari_assistant/presentation/providers/project_state_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final width in [390.0, 1600.0]) {
    testWidgets(
      '$width: only edited modules enter history and body jumps follow the layout',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        await tester.binding.setSurfaceSize(Size(width, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final container = ProviderContainer();
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

        MonogatariNavigationLayout navigation() =>
            tester.widget<MonogatariNavigationLayout>(
              find.byType(MonogatariNavigationLayout),
            );
        ProjectHistoryState history() => container.read(projectHistoryProvider);
        Future<void> navigate(int index) async {
          navigation().onDestinationSelected(index);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 400));
          expect(navigation().selectedIndex, index);
        }

        Future<void> press(LogicalKeyboardKey key, {bool shift = false}) async {
          await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
          if (shift) {
            await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
          }
          await tester.sendKeyEvent(key);
          if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 400));
        }

        // The unsaved startup workspace has a baseline too. Unmodified visits
        // neither consume Undo steps nor become future navigation destinations.
        expect(history().undoStack, hasLength(1));
        for (final index in [2, 3, 5, 14, 1]) {
          await navigate(index);
          expect(history().undoStack, hasLength(1));
        }
        final originalName = container.read(baseInfoDataProvider).bookName;
        final nameField = find
            .descendant(
              of: find.byType(BaseInfoView),
              matching: find.byType(TextField),
            )
            .first;
        await tester.enterText(nameField, 'History work');
        await tester.pump();
        // Leave before the 500 ms history debounce finishes.
        await navigate(5);
        expect(history().undoStack.map((entry) => entry.pageIndex), [0, 1, 1]);
        expect(history().undoStack[1].isPageTransition, isTrue);
        final beforeReturn = history();
        await press(LogicalKeyboardKey.keyZ);
        expect(navigation().selectedIndex, 1);
        expect(container.read(baseInfoDataProvider).bookName, 'History work');
        expect(history().undoStack, same(beforeReturn.undoStack));
        expect(history().redoStack, same(beforeReturn.redoStack));
        await press(LogicalKeyboardKey.keyZ);
        expect(navigation().selectedIndex, 1);
        expect(container.read(baseInfoDataProvider).bookName, originalName);
        // Returning to a page must also preserve an existing Redo branch.
        await navigate(5);
        final beforeReturnWithRedo = history();
        await press(LogicalKeyboardKey.keyZ);
        expect(navigation().selectedIndex, 1);
        expect(container.read(baseInfoDataProvider).bookName, originalName);
        expect(history().undoStack, same(beforeReturnWithRedo.undoStack));
        expect(history().redoStack, same(beforeReturnWithRedo.redoStack));
        await press(LogicalKeyboardKey.keyZ);
        expect(navigation().selectedIndex, 0);
        await press(LogicalKeyboardKey.keyZ, shift: true);
        expect(navigation().selectedIndex, 1);
        expect(container.read(baseInfoDataProvider).bookName, originalName);
        await navigate(5);
        expect(history().canRedo, isTrue);
        await press(LogicalKeyboardKey.keyZ, shift: true);
        expect(navigation().selectedIndex, 1);
        expect(container.read(baseInfoDataProvider).bookName, 'History work');

        await navigate(5);
        final desktop = width >= 800;
        if (!desktop) await navigate(17);
        final editor = tester.widget<EditorTextBox>(find.byType(EditorTextBox));
        final originalText = editor.controller.text;
        editor.focusNode.requestFocus();
        await tester.pump();
        editor.controller.text = '正文修改';
        // Immediate Undo must flush the body edit and label it as editor work,
        // even when a different module is visible in the desktop sidebar.
        await press(LogicalKeyboardKey.keyZ);
        expect(editor.controller.text, originalText);
        expect(navigation().selectedIndex, desktop ? 5 : 17);
        expect(history().redoStack.last.pageIndex, AppModule.editorPageIndex);
        expect(history().redoStack.last.desktopPageIndex, 5);
        if (desktop) {
          expect(history().redoStack.first.isPageTransition, isTrue);
          await press(LogicalKeyboardKey.keyZ, shift: true);
          expect(navigation().selectedIndex, 5);
        } else {
          expect(
            history().undoStack.last.isPageTransition,
            isTrue,
            reason: history().undoStack
                .map(
                  (entry) =>
                      '${entry.pageIndex}/${entry.isPageTransition}/${entry.data.contentText}/${entry.data.baseInfoData.bookName}/${entry.data.totalWords}',
                )
                .join('; '),
          );
          await press(LogicalKeyboardKey.keyZ);
          expect(navigation().selectedIndex, 1);
          await press(LogicalKeyboardKey.keyZ, shift: true);
          expect(navigation().selectedIndex, 17);
          expect(editor.controller.text, originalText);
          await press(LogicalKeyboardKey.keyZ, shift: true);
        }
        expect(editor.controller.text, '正文修改');
        expect(history().canRedo, isFalse);
        if (desktop) {
          // The editor is already visible: switching the sidebar must not add
          // a page-only Undo before reverting its text.
          await navigate(7);
          await press(LogicalKeyboardKey.keyZ);
          expect(navigation().selectedIndex, 7);
          expect(editor.controller.text, originalText);
          await press(LogicalKeyboardKey.keyZ, shift: true);
          expect(navigation().selectedIndex, 7);
          expect(editor.controller.text, '正文修改');
          await navigate(5);
          // Interleave body work and another module edit. Undoing the module's
          // jump must return to the sidebar that was visible during body work.
          await navigate(1);
          await tester.enterText(nameField, 'Next work');
          await tester.pump();
          await navigate(7);
          final beforeReturnToStory = history();
          await press(LogicalKeyboardKey.keyZ);
          expect(navigation().selectedIndex, 1);
          expect(container.read(baseInfoDataProvider).bookName, 'Next work');
          expect(editor.controller.text, '正文修改');
          expect(history().undoStack, same(beforeReturnToStory.undoStack));
          expect(history().redoStack, same(beforeReturnToStory.redoStack));
          await press(LogicalKeyboardKey.keyZ);
          expect(navigation().selectedIndex, 1);
          expect(container.read(baseInfoDataProvider).bookName, 'History work');
          await press(LogicalKeyboardKey.keyZ);
          expect(navigation().selectedIndex, 5);
          expect(editor.controller.text, '正文修改');
          await press(LogicalKeyboardKey.keyZ);
          expect(navigation().selectedIndex, 5);
          expect(editor.controller.text, originalText);
          await press(LogicalKeyboardKey.keyZ, shift: true);
          expect(navigation().selectedIndex, 5);
          expect(editor.controller.text, '正文修改');
          await press(LogicalKeyboardKey.keyZ, shift: true);
          expect(navigation().selectedIndex, 1);
          expect(container.read(baseInfoDataProvider).bookName, 'History work');
          await press(LogicalKeyboardKey.keyZ, shift: true);
          expect(container.read(baseInfoDataProvider).bookName, 'Next work');
        } else {
          await navigate(5);
          final beforeReturnToEditor = history();
          await press(LogicalKeyboardKey.keyZ);
          expect(navigation().selectedIndex, 17);
          expect(editor.controller.text, '正文修改');
          expect(history().undoStack, same(beforeReturnToEditor.undoStack));
          expect(history().redoStack, same(beforeReturnToEditor.redoStack));
          await press(LogicalKeyboardKey.keyZ);
          expect(editor.controller.text, originalText);
        }
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
