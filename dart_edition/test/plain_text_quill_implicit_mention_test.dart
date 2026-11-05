import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/features/editor/plain_text_quill_adapter.dart';
import 'package:monogatari_assistant/features/editor/plain_text_quill_editor_poc.dart';
import 'package:monogatari_assistant/features/editor/plain_text_quill_mention_overlay.dart';
import 'package:monogatari_assistant/features/inline_annotations/inline_annotation_parser.dart';

void main() {
  const raw = '//@<4e251fc2-1e2b-4f78-93da-91f8c76d9a92|>//';
  final annotation = const InlineAnnotationParser().parse(raw).single;
  const content = '前\u2003（艾莉絲）後';
  Widget editor({
    bool contrast = false,
    List<PlainTextQuillMentionMarker>? markers,
    ValueChanged<String>? onChanged,
  }) => MaterialApp(
    home: Scaffold(
      body: PlainTextQuillEditorPoc(
        content: content,
        onChanged: onChanged ?? (_) {},
        highContrast: contrast,
        mentionMarkers:
            markers ??
            [
              PlainTextQuillMentionMarker(
                offset: 1,
                annotation: annotation,
                displayText: '（艾莉絲）',
              ),
            ],
      ),
    ),
  );
  QuillEditor quill(WidgetTester tester) =>
      tester.widget(find.byKey(const ValueKey('plain-text-quill-editor')));

  testWidgets(
    'styles only the implicit label and keeps plain text and undo intact',
    (tester) async {
      final changes = <String>[];
      await tester.pumpWidget(editor(onChanged: changes.add));
      await tester.pump();
      final widget = quill(tester);
      final controller = widget.controller;
      final ops = controller.document.toDelta().toJson();
      final styled = ops.singleWhere(
        (op) =>
            (op['attributes']
                as Map?)?[PlainTextQuillAdapter.implicitMentionAttribute] ==
            true,
      );
      expect(styled['insert'], '（艾莉絲）');
      final style = widget.config.customStyleBuilder!(
        const Attribute(
          PlainTextQuillAdapter.implicitMentionAttribute,
          AttributeScope.ignore,
          true,
        ),
      );
      expect(style.fontStyle, FontStyle.italic);
      expect(style.color!.a, closeTo(.6, .01));
      expect(PlainTextQuillAdapter.toPlainText(controller.document), content);
      expect(controller.document.hasUndo, isFalse);
      expect(changes, isEmpty);
      controller.replaceText(
        0,
        0,
        '新',
        const TextSelection.collapsed(offset: 1),
      );
      await tester.pump();
      expect(changes, ['新$content']);
      controller.undo();
      await tester.pump();
      expect(PlainTextQuillAdapter.toPlainText(controller.document), content);
      expect(controller.document.hasRedo, isTrue);
      controller.redo();
      await tester.pump();
      expect(
        PlainTextQuillAdapter.toPlainText(controller.document),
        '新$content',
      );
    },
  );

  testWidgets(
    'high contrast keeps the label opaque and removing marker clears styling',
    (tester) async {
      await tester.pumpWidget(editor(contrast: true));
      await tester.pump();
      final widget = quill(tester);
      final style = widget.config.customStyleBuilder!(
        const Attribute(
          PlainTextQuillAdapter.implicitMentionAttribute,
          AttributeScope.ignore,
          true,
        ),
      );
      expect(style.fontStyle, FontStyle.italic);
      expect(style.color!.a, 1);
      await tester.pumpWidget(editor(contrast: true, markers: []));
      await tester.pump();
      expect(
        quill(tester).controller.document.toDelta().toJson().every(
          (op) =>
              (op['attributes']
                  as Map?)?[PlainTextQuillAdapter.implicitMentionAttribute] !=
              true,
        ),
        isTrue,
      );
      expect(
        PlainTextQuillAdapter.toPlainText(quill(tester).controller.document),
        content,
      );
    },
  );
}
