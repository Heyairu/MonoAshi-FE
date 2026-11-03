import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/content.dart';
import 'package:monogatari_assistant/bin/file.dart';
import 'package:monogatari_assistant/main.dart';
import 'package:monogatari_assistant/bin/findreplace.dart';
import 'package:monogatari_assistant/presentation/providers/project_io_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _ShortcutIo extends ProjectIoController {
  int calls = 0;
  final pending = Completer<ProjectFile>();
  @override
  Future<ProjectIoPayload> prepareProjectPayload(
    ProjectData data, {
    bool regenerateProjectUuid = false,
  }) async => ProjectIoPayload(snapshot: data, xmlContent: '<test/>');
  @override
  Future<ProjectFile> saveProject({
    required ProjectFile? currentProject,
    required ProjectData currentData,
    required bool forceSaveAs,
    ProjectIoPayload? preparedPayload,
  }) {
    calls++;
    return pending.future;
  }
}

void main() {
  testWidgets(
    'project Undo and Redo work from the editor, without focus and from search',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.binding.setSurfaceSize(const Size(1600, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
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

      Future<void> press(LogicalKeyboardKey key, {bool shift = false}) async {
        await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(key);
        if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
      }

      // New project must work even with focus outside the workspace subtree.
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      await press(LogicalKeyboardKey.keyN);
      expect(
        find.byKey(const ValueKey('project-1-page-4'), skipOffstage: false),
        findsOneWidget,
      );
      final editor = tester.widget<EditorTextBox>(find.byType(EditorTextBox));
      editor.focusNode.requestFocus();
      await tester.pump();
      editor.controller.text = '甲';
      await tester.pump(const Duration(seconds: 1));
      editor.controller.text = '甲乙';
      await tester.pump(const Duration(seconds: 1));

      // This must use project history even though Quill also binds Ctrl+Z.
      await press(LogicalKeyboardKey.keyZ);
      expect(editor.controller.text, '甲');
      editor.focusNode.unfocus();
      await tester.pump();
      expect(editor.focusNode.hasFocus, isFalse);
      await press(LogicalKeyboardKey.keyZ, shift: true);
      expect(editor.controller.text, '甲乙');

      await press(LogicalKeyboardKey.keyF);
      final search = tester.widget<FindReplaceBar>(find.byType(FindReplaceBar));
      final searchField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.controller == search.findController,
      );
      await tester.enterText(searchField, 'query');
      await tester.pump();
      await press(LogicalKeyboardKey.keyZ);
      expect(editor.controller.text, '甲');
      await press(LogicalKeyboardKey.keyY);
      expect(editor.controller.text, '甲乙');

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Save As overrides Quill strike-through and cannot reenter from repeated keys',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.binding.setSurfaceSize(const Size(1600, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final container = ProviderContainer(
        overrides: [projectIoControllerProvider.overrideWith(_ShortcutIo.new)],
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
      final editor = tester.widget<EditorTextBox>(find.byType(EditorTextBox));
      editor.focusNode.requestFocus();
      await tester.pump();
      final io =
          container.read(projectIoControllerProvider.notifier) as _ShortcutIo;
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyS);
      await tester.pump();
      await tester.sendKeyRepeatEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      expect(io.calls, 1);
      final quill = tester.widget<QuillEditor>(
        find.byKey(const ValueKey('plain-text-quill-editor')),
      );
      expect(
        quill.controller.getSelectionStyle().attributes.containsKey(
          Attribute.strikeThrough.key,
        ),
        isFalse,
      );
      io.pending.completeError(StateError('cancelled by test'));
      await tester.pump();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 200));
    },
  );
}
