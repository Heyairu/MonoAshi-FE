import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:monogatari_assistant/bin/statusbar.dart";

void main() {
  testWidgets("marquee stops across lifecycle and disposal", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(
          width: 320,
          child: MonogatariStatusBar(
            displayText: "這是一段刻意超出狀態列寬度、用來啟動 marquee 的非常長專案名稱",
            saveTimeText: "12:00",
            cursorLine: 1,
            cursorColumn: 1,
            currentWords: 1,
            totalWords: 1,
            iconSize: 16,
          ),
        ),
      ),
    );
    await tester.pump();

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(seconds: 2));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 3));

    expect(tester.takeException(), isNull);
  });

  testWidgets(
    "chapter loops only while overflowing and rechecks resized width",
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 600);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      const chapter = "文件 / 這是一個超出可用寬度的章節名稱，用來確認單向循環跑馬燈";
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: MonogatariStatusBar(
              compact: true,
              displayText: chapter,
              saveTimeText: "12:00",
              cursorLine: 1,
              cursorColumn: 1,
              currentWords: 1,
              totalWords: 1,
              iconSize: 16,
            ),
          ),
        ),
      );
      await tester.pump();
      final marquee = find.byKey(const Key("statusbar-chapter-marquee"));
      final cycle = find.byKey(const Key("statusbar-chapter-cycle"));
      expect(marquee, findsOneWidget);
      expect(find.text(chapter), findsNWidgets(2));
      final animation =
          tester
                  .widget<AnimatedBuilder>(
                    find.descendant(
                      of: marquee,
                      matching: find.byType(AnimatedBuilder),
                    ),
                  )
                  .animation
              as AnimationController;
      await tester.pump(const Duration(seconds: 1));
      final firstOffset = tester.widget<Transform>(cycle).transform.storage[12];
      expect(firstOffset, lessThan(0));
      await tester.pump(animation.duration! * 2);
      expect(
        tester.widget<Transform>(cycle).transform.storage[12],
        closeTo(firstOffset, .1),
      );
      expect(animation.isAnimating, isTrue);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      final pausedOffset = tester
          .widget<Transform>(cycle)
          .transform
          .storage[12];
      await tester.pump(const Duration(seconds: 2));
      expect(
        tester.widget<Transform>(cycle).transform.storage[12],
        pausedOffset,
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        tester.widget<Transform>(cycle).transform.storage[12],
        lessThan(pausedOffset),
      );

      tester.view.physicalSize = const Size(1800, 600);
      await tester.pump();
      await tester.pump();
      expect(marquee, findsNothing);
      expect(find.text(chapter), findsOneWidget);
      expect(animation.isAnimating, isFalse);

      tester.view.physicalSize = const Size(320, 600);
      await tester.pump();
      await tester.pump();
      expect(marquee, findsOneWidget);
      expect(animation.isAnimating, isTrue);
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
  );
}
