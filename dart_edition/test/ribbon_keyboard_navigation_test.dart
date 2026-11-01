import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ribbon/material_ribbon.dart';

void main() {
  testWidgets(
    'bare Alt waits for release; Alt combinations do not open KeyTips',
    (tester) async {
      final focus = FocusNode();
      final keyTips = RibbonKeyTipController();
      addTearDown(focus.dispose);
      addTearDown(keyTips.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MaterialRibbon(
              context: const RibbonContext(),
              focusNode: focus,
              keyTipController: keyTips,
              tabs: const [
                RibbonTab(id: 'one', label: 'One', groups: []),
                RibbonTab(id: 'two', label: 'Two', groups: []),
              ],
            ),
          ),
        ),
      );
      focus.requestFocus();
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      expect(keyTips.value.level, RibbonKeyTipLevel.hidden);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      expect(keyTips.value.level, RibbonKeyTipLevel.hidden);
      await tester.sendKeyEvent(LogicalKeyboardKey.altLeft);
      expect(keyTips.value.level, RibbonKeyTipLevel.header);
    },
  );

  testWidgets('controller can select a tab without stealing editor focus', (
    tester,
  ) async {
    final controller = RibbonController();
    final focus = FocusNode();
    final text = TextEditingController(text: 'text');
    addTearDown(controller.dispose);
    addTearDown(focus.dispose);
    addTearDown(text.dispose);
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              MaterialRibbon(
                controller: controller,
                context: const RibbonContext(),
                onSelectedTabChanged: (id) => selected = id,
                tabs: const [
                  RibbonTab(id: 'one', label: 'One', groups: []),
                  RibbonTab(id: 'two', label: 'Two', groups: []),
                ],
              ),
              TextField(focusNode: focus, controller: text),
            ],
          ),
        ),
      ),
    );
    focus.requestFocus();
    text.selection = const TextSelection(baseOffset: 1, extentOffset: 3);
    await tester.pump();
    controller.selectTab('two', requestFocus: false);
    await tester.pump();
    expect(selected, 'two');
    expect(focus.hasFocus, isTrue);
    expect(text.selection, const TextSelection(baseOffset: 1, extentOffset: 3));
  });
}
