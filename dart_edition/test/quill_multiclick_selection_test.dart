import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/content.dart';
import 'package:monogatari_assistant/bin/findreplace.dart';
import 'package:monogatari_assistant/main.dart';
import 'package:monogatari_assistant/features/editor/plain_text_quill_geometry.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _source = 'hello world again\nsecond line\nlast';
const _delegates = <LocalizationsDelegate<dynamic>>[
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  FlutterQuillLocalizations.delegate,
];

QuillController _quill(WidgetTester tester) => tester
    .widget<QuillEditor>(find.byKey(const ValueKey('plain-text-quill-editor')))
    .controller;

RenderParagraph _paragraph(WidgetTester tester, String text) =>
    tester.renderObject<RenderParagraph>(
      find
          .descendant(
            of: find.byType(QuillEditor),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is RichText &&
                  widget.text.toPlainText().contains(text),
            ),
          )
          .first,
    );

Offset _pointInWord(
  WidgetTester tester, {
  String text = 'hello world again',
  int offset = 7,
}) {
  final paragraph = _paragraph(tester, text);
  final box = paragraph
      .getBoxesForSelection(
        TextSelection(baseOffset: offset, extentOffset: offset + 1),
      )
      .single
      .toRect();
  return paragraph.localToGlobal(box.center);
}

Future<void> _click(
  WidgetTester tester,
  Offset point, {
  PointerDeviceKind kind = PointerDeviceKind.mouse,
}) async {
  await tester.tapAt(point, kind: kind);
  await tester.pump(const Duration(milliseconds: 80));
}

Widget _editor(
  HighlightTextEditingController controller,
  FocusNode focus, {
  ValueChanged<EditorTextInteraction>? onInteraction,
  double? width,
}) => ProviderScope(
  child: MaterialApp(
    localizationsDelegates: _delegates,
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          child: EditorTextBox(
            controller: controller,
            focusNode: focus,
            onInteractionOffset: onInteraction,
          ),
        ),
      ),
    ),
  ),
);

void main() {
  for (final platform in [
    TargetPlatform.windows,
    TargetPlatform.macOS,
    TargetPlatform.linux,
  ]) {
    testWidgets(
      '$platform: double click selects a word and triple click selects its line',
      (tester) async {
        final controller = HighlightTextEditingController(text: _source);
        final focus = FocusNode();
        addTearDown(controller.dispose);
        addTearDown(focus.dispose);
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              localizationsDelegates: _delegates,
              home: Scaffold(
                body: EditorTextBox(controller: controller, focusNode: focus),
              ),
            ),
          ),
        );
        await tester.pump();
        final point = _pointInWord(tester);
        await _click(tester, point);
        await _click(tester, point);
        expect(
          _quill(tester).selection,
          const TextSelection(baseOffset: 6, extentOffset: 11),
        );
        expect(
          controller.selection,
          const TextSelection(baseOffset: 6, extentOffset: 11),
        );
        await _click(tester, point);
        expect(
          _quill(tester).selection,
          const TextSelection(baseOffset: 0, extentOffset: 17),
        );
        expect(
          controller.selection,
          const TextSelection(baseOffset: 0, extentOffset: 17),
        );
        expect(controller.rawText, _source);
        expect(focus.hasFocus, isTrue);
        await tester.pump(kDoubleTapTimeout);
        final secondLine = _pointInWord(tester, text: 'second line', offset: 2);
        await _click(tester, secondLine);
        await _click(tester, secondLine);
        expect(
          _quill(tester).selection,
          const TextSelection(baseOffset: 18, extentOffset: 24),
        );
        await _click(tester, secondLine);
        expect(
          _quill(tester).selection,
          const TextSelection(baseOffset: 18, extentOffset: 29),
        );
        expect(controller.selection, _quill(tester).selection);
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      },
      variant: TargetPlatformVariant({platform}),
    );
  }

  testWidgets(
    'annotation multi-click selects visible text without opening details',
    (tester) async {
      const source =
          'Before //@<4e251fc2-1e2b-4f78-93da-91f8c76d9a92|Alice>{secret}// after\nnext';
      final controller = HighlightTextEditingController(text: source);
      final focus = FocusNode();
      final interactions = <EditorTextInteraction>[];
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _editor(controller, focus, onInteraction: interactions.add),
      );
      await tester.pump();
      final point = _pointInWord(tester, text: 'Alice', offset: 9);
      await _click(tester, point);
      await _click(tester, point);
      expect(
        _quill(tester).selection,
        const TextSelection(baseOffset: 8, extentOffset: 13),
      );
      expect(interactions, isEmpty);
      await _click(tester, point);
      expect(
        _quill(tester).selection,
        const TextSelection(baseOffset: 0, extentOffset: 19),
      );
      await tester.pump(kDoubleTapTimeout);
      expect(interactions, isEmpty);
      expect(controller.rawText, source);
      await _click(tester, point);
      await tester.pump(kDoubleTapTimeout);
      expect(interactions, hasLength(1));
      expect(controller.selection.isCollapsed, isTrue);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );

  testWidgets('triple click selects only the visible wrapped row', (
    tester,
  ) async {
    const source = 'one two three four five six seven eight nine ten';
    final controller = HighlightTextEditingController(text: source);
    final focus = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    await tester.pumpWidget(_editor(controller, focus, width: 180));
    await tester.pump();
    final offset = source.indexOf('five') + 1;
    final paragraph = _paragraph(tester, source);
    final painter = TextPainter(
      text: paragraph.text,
      textDirection: paragraph.textDirection,
      textScaler: paragraph.textScaler,
    )..layout(maxWidth: paragraph.size.width);
    final line = painter.getLineBoundary(TextPosition(offset: offset));
    painter.dispose();
    expect(line.start, greaterThan(0));
    expect(line.end, lessThan(source.length));
    final point = _pointInWord(tester, text: source, offset: offset);
    await _click(tester, point);
    await _click(tester, point);
    expect(_quill(tester).selection.textInside(source), 'five');
    await _click(tester, point);
    expect(
      _quill(tester).selection,
      TextSelection(baseOffset: line.start, extentOffset: line.end),
    );
    expect(controller.rawText, source);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets(
    'triple clicking an empty line remains a valid collapsed selection',
    (tester) async {
      const source = 'first\n\nlast';
      final controller = HighlightTextEditingController(text: source);
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      await tester.pumpWidget(_editor(controller, focus));
      await tester.pump();
      final widget = tester.widget<QuillEditor>(find.byType(QuillEditor));
      final renderer = widget.config.editorKey!.currentState!.renderEditor;
      final point =
          quillCaretGlobalRect(renderer, const TextPosition(offset: 6)).center +
          const Offset(1, 0);
      await _click(tester, point);
      await _click(tester, point);
      await _click(tester, point);
      expect(
        _quill(tester).selection,
        const TextSelection.collapsed(offset: 6),
      );
      expect(tester.takeException(), isNull);
      expect(controller.rawText, source);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );

  testWidgets(
    'touch multi-tap selects words and lines in mixed Unicode text',
    (tester) async {
      const source = '前文 🐈 hello 後文\n下一行';
      final controller = HighlightTextEditingController(text: source);
      final focus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focus.dispose);
      await tester.pumpWidget(_editor(controller, focus));
      await tester.pump();
      final start = source.indexOf('hello');
      final point = _pointInWord(tester, text: 'hello', offset: start + 1);
      await _click(tester, point, kind: PointerDeviceKind.touch);
      await _click(tester, point, kind: PointerDeviceKind.touch);
      expect(
        _quill(tester).selection,
        TextSelection(baseOffset: start, extentOffset: start + 5),
      );
      await _click(tester, point, kind: PointerDeviceKind.touch);
      expect(
        _quill(tester).selection,
        TextSelection(baseOffset: 0, extentOffset: source.indexOf('\n')),
      );
      expect(controller.rawText, source);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
    variant: TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );

  testWidgets('dragging and canceled pointers do not open annotation details', (
    tester,
  ) async {
    final controller = HighlightTextEditingController(text: _source);
    final focus = FocusNode();
    final interactions = <EditorTextInteraction>[];
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    await tester.pumpWidget(
      _editor(controller, focus, onInteraction: interactions.add),
    );
    await tester.pump();
    final point = _pointInWord(tester);
    await _click(tester, point);
    final canceled = await tester.startGesture(
      point,
      kind: PointerDeviceKind.mouse,
    );
    await canceled.cancel();
    await tester.pump(kDoubleTapTimeout);
    expect(interactions, isEmpty);
    final drag = await tester.startGesture(
      point,
      kind: PointerDeviceKind.mouse,
    );
    await drag.moveTo(point + const Offset(120, 0));
    await tester.pump(const Duration(milliseconds: 100));
    await drag.up();
    await tester.pump();
    await tester.pump(kDoubleTapTimeout);
    expect(interactions, isEmpty);
    expect(_quill(tester).selection.isCollapsed, isFalse);
    expect(controller.rawText, _source);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets(
    'workspace keeps mouse word and line selections after host rebuilds',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.binding.setSurfaceSize(const Size(1600, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: _delegates,
            home: ContentView(),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
      final editor = tester.widget<EditorTextBox>(find.byType(EditorTextBox));
      editor.controller.text = _source;
      await tester.pump(const Duration(seconds: 1));
      final point = _pointInWord(tester);
      await _click(tester, point);
      await _click(tester, point);
      expect(
        _quill(tester).selection,
        const TextSelection(baseOffset: 6, extentOffset: 11),
      );
      expect(
        editor.controller.selection,
        const TextSelection(baseOffset: 6, extentOffset: 11),
      );
      expect(editor.focusNode.hasFocus, isTrue);
      await _click(tester, point);
      expect(
        _quill(tester).selection,
        const TextSelection(baseOffset: 0, extentOffset: 17),
      );
      expect(
        editor.controller.selection,
        const TextSelection(baseOffset: 0, extentOffset: 17),
      );
      expect(editor.controller.text, _source);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );
}
