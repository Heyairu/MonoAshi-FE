import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:monogatari_assistant/bin/content.dart";
import "package:monogatari_assistant/bin/findreplace.dart";
import 'package:monogatari_assistant/features/inline_annotations/mosaic_clipboard.dart';
import 'package:monogatari_assistant/features/editor/plain_text_quill_editor_poc.dart';
import 'support/memory_mosaic_clipboard.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MemoryMosaicClipboard clipboard;
  late MosaicClipboardBackend previousBackend;
  setUp(() {
    previousBackend = MosaicClipboard.backend;
    clipboard = MemoryMosaicClipboard();
    MosaicClipboard.backend = clipboard;
  });
  tearDown(() => MosaicClipboard.backend = previousBackend);

  for (final quill in [false, true]) {
    testWidgets(
      'implicit clipboard excludes public hints and preserves internal source, Quill=$quill',
      (tester) async {
        String? publicText;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async {
            if (call.method == 'Clipboard.setData') {
              publicText = (call.arguments as Map)['text'] as String?;
            }
            if (call.method == 'Clipboard.getData') return {'text': publicText};
            return null;
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            null,
          ),
        );
        const mention = '//@+<4e251fc2-1e2b-4f78-93da-91f8c76d9a92|>{secret}//';
        const raw = 'A $mention B';
        final controller = HighlightTextEditingController(text: raw);
        final focus = FocusNode();
        addTearDown(controller.dispose);
        addTearDown(focus.dispose);
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EditorTextBox(
                  controller: controller,
                  focusNode: focus,
                  usePlainTextQuillEditor: quill,
                ),
              ),
            ),
          ),
        );
        focus.requestFocus();
        await tester.pump();
        controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: controller.text.length,
        );
        await tester.pump();
        final commands = quill
            ? tester
                  .widget<PlainTextQuillEditorPoc>(
                    find.byType(PlainTextQuillEditorPoc),
                  )
                  .commands!
            : null;
        Future<void> shortcut(LogicalKeyboardKey key) async {
          await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
          await tester.sendKeyEvent(key);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
          await tester.pump();
        }

        if (commands != null) {
          await commands.copy();
        } else {
          await shortcut(LogicalKeyboardKey.keyC);
        }
        expect(clipboard.data.text, 'A  B');
        expect(clipboard.data.rawText, raw);
        expect(publicText, 'A  B');
        controller.selection = TextSelection.collapsed(
          offset: controller.text.length,
        );
        await tester.pump();
        if (commands != null) {
          await commands.paste();
        } else {
          await shortcut(LogicalKeyboardKey.keyV);
        }
        await tester.pump();
        expect(controller.rawText, '$raw$raw');
        expect(controller.annotations, hasLength(2));
        expect(
          controller.annotations.every(
            (annotation) =>
                annotation.isImplicit && annotation.note == 'secret',
          ),
          isTrue,
        );

        final entry = controller.projection.projectedAnnotations.first;
        controller.selection = TextSelection(
          baseOffset: entry.labelRange.start,
          extentOffset: entry.labelRange.end,
        );
        await tester.pump();
        if (commands != null) {
          await commands.cut();
        } else {
          await shortcut(LogicalKeyboardKey.keyX);
        }
        await tester.pump();
        expect(clipboard.data.text, isEmpty);
        expect(clipboard.data.rawText, mention);
        expect(controller.annotations, hasLength(1));
        if (commands != null) {
          await commands.paste();
        } else {
          await shortcut(LogicalKeyboardKey.keyV);
        }
        await tester.pump();
        expect(controller.rawText, '$raw$raw');

        // External clipboard replacement has no private Mosaic representation.
        clipboard.data = const MosaicClipboardData(text: '外部');
        controller.selection = TextSelection.collapsed(
          offset: controller.text.length,
        );
        await tester.pump();
        if (commands != null) {
          await commands.paste();
        } else {
          await shortcut(LogicalKeyboardKey.keyV);
        }
        await tester.pump();
        expect(controller.rawText, '$raw$raw外部');
        expect(controller.annotations, hasLength(2));
        if (commands != null) {
          commands.undo();
          await tester.pump();
          expect(controller.rawText, '$raw$raw');
        }
      },
    );
  }

  testWidgets("copy and cut expose display text while preserving raw syntax", (
    tester,
  ) async {
    const uuid = "4e251fc2-1e2b-4f78-93da-91f8c76d9a92";
    const raw = "A //@<$uuid|艾莉絲>{secret}// B";
    final controller = HighlightTextEditingController(text: raw);
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    String? clipboardText;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == "Clipboard.setData") {
          clipboardText =
              (call.arguments as Map<Object?, Object?>)["text"] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: EditorTextBox(
              controller: controller,
              focusNode: focusNode,
              usePlainTextQuillEditor: false,
            ),
          ),
        ),
      ),
    );
    focusNode.requestFocus();
    controller.selection = const TextSelection(baseOffset: 3, extentOffset: 6);
    await tester.pump();

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    expect(clipboardText, "艾莉絲");
    expect(controller.rawText, raw);

    controller.selection = const TextSelection(baseOffset: 3, extentOffset: 6);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyX);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    expect(clipboardText, "艾莉絲");
    expect(controller.text, "A  B");
    expect(controller.rawText, "A  B");
  });
}
