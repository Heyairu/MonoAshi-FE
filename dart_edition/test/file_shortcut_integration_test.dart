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
