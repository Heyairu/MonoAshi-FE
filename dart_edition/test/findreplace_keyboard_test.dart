import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/findreplace.dart';

void main() {
  testWidgets(
    'search Enter navigates, Shift reverses, composition wins and Esc closes',
    (tester) async {
      final key = GlobalKey<FindReplaceBarState>();
      final find = TextEditingController(text: 'cat');
      final replace = TextEditingController();
      addTearDown(find.dispose);
      addTearDown(replace.dispose);
      var next = 0;
      var previous = 0;
      var closed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FindReplaceBar(
              key: key,
              findController: find,
              replaceController: replace,
              options: FindReplaceOptions(),
              onFindNext: (_, _, _) async {
                next++;
              },
              onFindPrevious: (_, _, _) async {
                previous++;
              },
              onClose: () => closed++,
            ),
          ),
        ),
      );
      key.currentState!.focusFind();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(next, 1);
      expect(find.text, 'cat');
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump();
      expect(previous, 1);
      find.value = const TextEditingValue(
        text: 'cat',
        selection: TextSelection.collapsed(offset: 3),
        composing: TextRange(start: 0, end: 3),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(next, 1);
      find.clearComposing();
      key.currentState!.focusReplace();
      await tester.pump();
      await tester.pump();
      expect(find.text, 'cat');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      expect(closed, 1);
    },
  );
}
