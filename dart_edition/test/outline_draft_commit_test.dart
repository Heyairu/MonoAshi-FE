import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:monogatari_assistant/modules/outlineview.dart";
import "package:monogatari_assistant/presentation/providers/project_state_providers.dart";
import "package:monogatari_assistant/presentation/widgets/remote_text_cursor_overlay.dart";

Finder field(String label) => find.byWidgetPredicate(
  (widget) => widget is TextField && widget.decoration?.labelText == label,
);

void main() {
  Future<ProviderContainer> openOutline(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1500, 3500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(outlineDataProvider.notifier).setOutlineData([
      StorylineData(
        chapterUUID: "first",
        storylineName: "第一大箱",
        scenes: [
          StoryEventData(
            storyEventUUID: "event",
            storyEvent: "第一中箱",
            scenes: [SceneData(sceneUUID: "scene", sceneName: "第一小箱")],
          ),
        ],
      ),
      StorylineData(chapterUUID: "second", storylineName: "第二大箱"),
    ]);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: OutlineAdjustView()),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets("draft commits edited fields at all three outline levels", (
    tester,
  ) async {
    final container = await openOutline(tester);
    await tester.enterText(field("故事線名稱"), "修正大箱");
    await tester.enterText(field("類型 (如：開頭、中段、高潮、結尾)"), "承");
    await tester.enterText(field("主要衝突"), "大箱衝突");
    await tester.enterText(field("事件名稱"), "修正中箱");
    await tester.enterText(field("場景名稱"), "修正小箱");
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    final box = container.read(outlineDataProvider).first;
    expect(box.storylineName, "修正大箱");
    expect(box.storylineType, "承");
    expect(box.conflictPoint, "大箱衝突");
    expect(box.scenes.single.storyEvent, "修正中箱");
    expect(box.scenes.single.scenes.single.sceneName, "修正小箱");
    expect(find.text("承"), findsWidgets);
  });

  testWidgets("outline rebuilds preserve Zhuyin composition until commit", (
    tester,
  ) async {
    final container = await openOutline(tester);
    final regions = tester
        .widgetList<CollaborativeProjectTextFieldRegion>(
          find.byType(CollaborativeProjectTextFieldRegion),
        )
        .toList();
    expect(regions, hasLength(13));
    for (final region in regions) {
      final label = region.crdtDocumentId!;
      final before = container.read(outlineDataProvider);
      final target = find.descendant(
        of: find.byKey(region.key!),
        matching: find.byType(TextField),
      );
      await tester.showKeyboard(target);
      final controller = tester.widget<TextField>(target).controller!;
      for (final text in ["ㄅ", "ㄅㄢ", "班ㄐ", "班ㄐㄧ", "班級"]) {
        final value = TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
          composing: TextRange(start: 0, end: text.length),
        );
        tester.testTextInput.updateEditingValue(value);
        // Unrelated provider/UI updates can rebuild the outline while the
        // Windows IME still owns the preedit range, even after the debounce.
        tester.element(find.byType(OutlineAdjustView)).markNeedsBuild();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
        expect(controller.value, value, reason: "$label: $text");
        expect(
          container.read(outlineDataProvider),
          same(before),
          reason: "Preedit must stay out of drafts: $label",
        );
      }
      // Windows may commit by clearing only the composing range.
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: "班級",
          selection: TextSelection.collapsed(offset: 2),
        ),
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(controller.text, "班級");
    }
    final storyline = container.read(outlineDataProvider).first;
    expect(storyline.storylineName, "班級");
    expect(storyline.scenes.single.storyEvent, "班級");
    expect(storyline.scenes.single.scenes.single.sceneName, "班級");
  });

  testWidgets("switching large boxes flushes a draft before the debounce", (
    tester,
  ) async {
    final container = await openOutline(tester);
    await tester.enterText(field("類型 (如：開頭、中段、高潮、結尾)"), "轉");
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey("second")),
        matching: find.byIcon(Icons.library_books),
      ),
    );
    await tester.pumpAndSettle();
    expect(container.read(outlineDataProvider).first.storylineType, "轉");
    expect(container.read(outlineDataProvider).last.storylineType, isEmpty);
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey("first")),
        matching: find.byIcon(Icons.library_books),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(field("類型 (如：開頭、中段、高潮、結尾)")).controller!.text,
      "轉",
    );
  });

  testWidgets("rebuilds keep a pending draft and idle fields accept updates", (
    tester,
  ) async {
    final container = await openOutline(tester);
    await tester.enterText(field("事件名稱"), "班級");
    tester.element(find.byType(OutlineAdjustView)).markNeedsBuild();
    await tester.pump();
    expect(tester.widget<TextField>(field("事件名稱")).controller!.text, "班級");
    await tester.pump(const Duration(milliseconds: 350));
    expect(
      container.read(outlineDataProvider).first.scenes.single.storyEvent,
      "班級",
    );

    container.read(outlineDataProvider.notifier).updateOutlineData((current) {
      final first = current.first;
      final event = first.scenes.single;
      return [
        first.copyWith(scenes: [event.copyWith(storyEvent: "外部更新")]),
        ...current.skip(1),
      ];
    });
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(field("事件名稱")).controller!.text, "外部更新");
  });
}
