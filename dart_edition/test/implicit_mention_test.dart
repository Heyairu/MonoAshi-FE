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
    displayText: '',
  );
  test('implicit mention round trips through parser and reader projection', () {
    final annotation = const InlineAnnotationParser().parse(raw).single;
    expect(annotation.isImplicit, isTrue);
    expect(annotation.targetId, id);
    expect(InlineAnnotationProjection.readerTextFromRaw(raw), '');
    expect(raw, '//@<$id|>//');
  });

  test('empty fields alone define implicitness, not the former flag', () {
    const parser = InlineAnnotationParser();
    expect(parser.parse('//@<$id|>//').single.isImplicit, isTrue);
    expect(parser.parse('//@<$id|文字>//').single.isImplicit, isFalse);
    expect(parser.parse('//@<$id| >//').single.isImplicit, isFalse);
    expect(parser.parse('//@~<$id|文字>//').single.isImplicit, isFalse);
    expect(parser.parse('//^<>//').single.isImplicit, isFalse);
  });

  test(
    'implicit original names are mapped by kind and UUID without changing source',
    () {
      final controller = MosaicEditingController(
        rawText: '//@<$id|>// //!<$id|>//',
      );
      addTearDown(controller.dispose);
      controller.configureImplicitLabels(
        targetNames: const {
          (InlineAnnotationKind.character, id): 'Chino',
          (InlineAnnotationKind.location, id): '木造小鎮',
        },
        start: '開始',
        end: '結束',
      );
      expect(controller.displayText, '\uFFFC（Chino） \uFFFC（木造小鎮）');
      expect(controller.rawText, '//@<$id|>// //!<$id|>//');
      expect(
        controller.annotations.every(
          (annotation) => annotation.displayText.isEmpty,
        ),
        isTrue,
      );
      expect(controller.rawRevision, 0);
    },
  );

  for (final state in {'+': '（艾莉絲：開始）', '-': '（艾莉絲：結束）'}.entries) {
    test('implicit ${state.key} hint has no persisted or public text', () {
      final source = '前//@${state.key}<$id|>{note}//後';
      final controller = MosaicEditingController(rawText: source);
      addTearDown(controller.dispose);
      controller.configureImplicitLabels(
        targetNames: const {(InlineAnnotationKind.character, id): '艾莉絲'},
        start: '開始',
        end: '結束',
      );
      final entry = controller.projection.projectedAnnotations.single;
      expect(
        controller.displayText,
        '前$inlineAnnotationPlaceholder${state.value}後',
      );
      expect(entry.label, state.value);
      expect(entry.annotation.displayText, isEmpty);
      expect(controller.projection.readerText, '前後');
      final selected = TextSelection(
        baseOffset: entry.labelRange.start + 1,
        extentOffset: entry.labelRange.end - 1,
      );
      expect(controller.plainTextForSelection(selected), isEmpty);
      expect(
        controller.rawTextForSelection(selected),
        '//@${state.key}<$id|>{note}//',
      );
      controller.configureImplicitLabels(
        targetNames: const {(InlineAnnotationKind.character, id): 'Alice'},
        start: 'Start',
        end: 'End',
      );
      expect(controller.rawText, source);
      expect(
        controller.projection.projectedAnnotations.single.label,
        state.key == '+' ? '（Alice：Start）' : '（Alice：End）',
      );
      expect(controller.rawRevision, 0);
    });
  }
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
