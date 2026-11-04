import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/features/inline_annotations/inline_annotation.dart';
import 'package:monogatari_assistant/features/inline_annotations/inline_annotation_parser.dart';
import 'package:monogatari_assistant/features/inline_annotations/inline_annotation_projection.dart';
import 'package:monogatari_assistant/features/inline_annotations/inline_annotation_syntax.dart';
import 'package:monogatari_assistant/features/inline_annotations/mosaic_editing_controller.dart';

void main() {
  const id = '4e251fc2-1e2b-4f78-93da-91f8c76d9a92';
  final raw = InlineAnnotationSyntax.format(
    kind: InlineAnnotationKind.character,
    targetId: id,
    isImplicit: true,
    displayText: '（艾莉絲）',
  );
  test('implicit mention round trips through parser and reader projection', () {
    final annotation = const InlineAnnotationParser().parse(raw).single;
    expect(annotation.isImplicit, isTrue);
    expect(annotation.targetId, id);
    expect(InlineAnnotationProjection.readerTextFromRaw(raw), '（艾莉絲）');
  });
  for (final highContrast in [false, true]) {
    testWidgets('implicit mention styling, highContrast=$highContrast', (
      tester,
    ) async {
      final controller = MosaicEditingController(rawText: raw);
      addTearDown(controller.dispose);
      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(highContrast: highContrast),
            child: Builder(
              builder: (value) {
                context = value;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      final style = controller.inlineStyleRanges(context).single.style;
      expect(style.fontStyle, FontStyle.italic);
      expect(style.color!.a, closeTo(highContrast ? 1 : .6, .01));
    });
  }
}
