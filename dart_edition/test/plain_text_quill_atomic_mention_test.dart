import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/features/editor/plain_text_quill_adapter.dart';
import 'package:monogatari_assistant/features/editor/plain_text_quill_editor_poc.dart';
import 'package:monogatari_assistant/features/editor/plain_text_quill_mention_overlay.dart';
import 'package:monogatari_assistant/features/inline_annotations/inline_annotation_parser.dart';

void main() {
  final annotation = const InlineAnnotationParser().parse('//^<重點>//').single;

  Future<QuillController> mount(
    WidgetTester tester, {
    String content = '前\u2003重點後',
    int offset = 1,
    PlainTextQuillEditorCommands? commands,
    ValueChanged<String>? onChanged,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlainTextQuillEditorPoc(
            content: content,
            onChanged: onChanged ?? (_) {},
            commands: commands,
            mentionMarkers: [
              PlainTextQuillMentionMarker(
                offset: offset,
                annotation: annotation,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    return tester.widget<QuillEditor>(find.byType(QuillEditor)).controller;
  }

  testWidgets(
    'caret snaps in either direction while partial selection remains',
    (tester) async {
      final controller = await mount(tester);
      controller.updateSelection(
        const TextSelection.collapsed(offset: 2),
        ChangeSource.local,
      );
      expect(controller.selection.extentOffset, 4);
      controller.updateSelection(
        const TextSelection.collapsed(offset: 3),
        ChangeSource.local,
      );
      expect(controller.selection.extentOffset, 1);
      controller.updateSelection(
        const TextSelection(baseOffset: 3, extentOffset: 2),
        ChangeSource.local,
      );
      expect(
        controller.selection,
        const TextSelection(baseOffset: 3, extentOffset: 2),
      );
    },
  );

  testWidgets(
    'partial replacement is one complete mention edit in undo history',
    (tester) async {
      final changes = <String>[];
      final controller = await mount(tester, onChanged: changes.add);
      controller.replaceText(
        2,
        1,
        '新',
        const TextSelection.collapsed(offset: 3),
      );
      expect(changes, ['前新後']);
      expect(controller.selection.extentOffset, 2);
      controller.undo();
      expect(changes, ['前新後', '前\u2003重點後']);
      controller.redo();
      expect(changes, ['前新後', '前\u2003重點後', '前新後']);
    },
  );

  testWidgets('newline replacement also removes the entire mention', (
    tester,
  ) async {
    final commands = PlainTextQuillEditorCommands();
    final controller = await mount(tester, commands: commands);
    controller.updateSelection(
      const TextSelection(baseOffset: 2, extentOffset: 3),
      ChangeSource.local,
    );
    commands.replaceSelectionWith('\n');
    expect(PlainTextQuillAdapter.toPlainText(controller.document), '前\n後');
    expect(controller.selection.extentOffset, 2);
  });

  testWidgets('deletion maps mention offsets before the host rebuilds', (
    tester,
  ) async {
    final controller = await mount(tester);
    controller.replaceText(0, 0, '新', const TextSelection.collapsed(offset: 1));
    // No pump between these edits: markers still refer to the original text.
    controller.replaceText(4, 1, '', const TextSelection.collapsed(offset: 4));
    expect(PlainTextQuillAdapter.toPlainText(controller.document), '新前後');
    expect(controller.selection.extentOffset, 2);
    // A second edit must not reuse the deleted mention's stale range.
    controller.replaceText(2, 1, '', const TextSelection.collapsed(offset: 2));
    expect(PlainTextQuillAdapter.toPlainText(controller.document), '新前');
  });

  testWidgets('CRLF host offsets map to canonical mention boundaries', (
    tester,
  ) async {
    final controller = await mount(
      tester,
      content: '前\r\n\u2003重點後',
      offset: 3,
    );
    controller.updateSelection(
      const TextSelection.collapsed(offset: 3),
      ChangeSource.local,
    );
    expect(controller.selection.extentOffset, 5);
    controller.replaceText(4, 1, '', const TextSelection.collapsed(offset: 4));
    expect(PlainTextQuillAdapter.toPlainText(controller.document), '前\n後');
    expect(controller.selection.extentOffset, 2);
  });

  testWidgets('deletion crossing two mentions expands both boundaries', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlainTextQuillEditorPoc(
            content: '前\u2003重點中\u2003重點後',
            onChanged: (_) {},
            mentionMarkers: [
              for (final offset in [1, 5])
                PlainTextQuillMentionMarker(
                  offset: offset,
                  annotation: annotation,
                ),
            ],
          ),
        ),
      ),
    );
    final controller = tester
        .widget<QuillEditor>(find.byType(QuillEditor))
        .controller;
    controller.replaceText(3, 4, '', const TextSelection.collapsed(offset: 3));
    expect(PlainTextQuillAdapter.toPlainText(controller.document), '前後');
    expect(controller.selection.extentOffset, 1);
  });
}
