import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:monogatari_assistant/bin/statusbar.dart";
import "package:monogatari_assistant/bin/ui_library.dart";

void main() {
  setUpAll(() async {
    // Real Latin and fallback CJK metrics expose both width and baseline drift.
    for (final family in ["NotoSans", "NotoSansTC"]) {
      final loader = FontLoader(family)
        ..addFont(rootBundle.load("assets/fonts/$family-Variable.ttf"));
      await loader.load();
    }
  });

  for (final dark in [false, true]) {
    for (final scale in [1.0, 1.5]) {
      testWidgets(
        "mode toggle keeps its bounds and editor focus (dark=$dark, scale=$scale)",
        (tester) async {
          final focusNode = FocusNode();
          addTearDown(focusNode.dispose);
          var overwrite = false;
          await tester.pumpWidget(
            MaterialApp(
              theme: dark
                  ? AppTheme.getDarkTheme(14, Colors.lightBlue)
                  : AppTheme.getLightTheme(14, Colors.lightBlue),
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: StatefulBuilder(
                builder: (context, setState) => Scaffold(
                  body: TextField(focusNode: focusNode),
                  bottomNavigationBar: MonogatariStatusBar(
                    displayText: "Untitled | Folder 1 / Chapter 1",
                    saveTimeText: "--:--",
                    cursorLine: 12,
                    cursorColumn: 23,
                    currentWords: 446,
                    totalWords: 446,
                    iconSize: 14,
                    overwriteMode: overwrite,
                    onToggleOverwrite: () =>
                        setState(() => overwrite = !overwrite),
                  ),
                ),
              ),
            ),
          );
          focusNode.requestFocus();
          await tester.pump();

          final modeButton = find.widgetWithText(TextButton, "[DEF]");
          final initialBounds = tester.getRect(modeButton);
          final tabBounds = tester.getRect(
            find.byKey(const Key("statusbar-tab-spaces")),
          );
          final barBounds = tester.getRect(find.byType(MonogatariStatusBar));

          for (final label in ["[OVR]", "[DEF]"]) {
            await tester.tap(
              find.widgetWithText(TextButton, overwrite ? "[OVR]" : "[DEF]"),
            );
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));
            final currentButton = find.widgetWithText(TextButton, label);
            expect(tester.getRect(currentButton), initialBounds);
            expect(
              tester.getRect(find.byKey(const Key("statusbar-tab-spaces"))),
              tabBounds,
            );
            expect(tester.getRect(find.byType(MonogatariStatusBar)), barBounds);
            expect(tester.getCenter(currentButton).dy, tabBounds.center.dy);
            final modeText = tester.renderObject<RenderParagraph>(
              find.text(label),
            );
            final modeBaseline = modeText
                .localToGlobal(
                  Offset(
                    0,
                    modeText.getDryBaseline(
                      modeText.constraints,
                      TextBaseline.alphabetic,
                    )!,
                  ),
                )
                .dy;
            for (final text in ["--:--", "12:23", "[全形:2]", "446 / 446 字"]) {
              final paragraph = tester.renderObject<RenderParagraph>(
                find.text(text),
              );
              final baseline = paragraph
                  .localToGlobal(
                    Offset(
                      0,
                      paragraph.getDryBaseline(
                        paragraph.constraints,
                        TextBaseline.alphabetic,
                      )!,
                    ),
                  )
                  .dy;
              expect(baseline, closeTo(modeBaseline, 0.001), reason: text);
              expect(
                tester.getRect(find.text(text)).height,
                modeText.size.height,
                reason: text,
              );
            }
            expect(focusNode.hasFocus, isTrue);
            expect(tester.takeException(), isNull);
          }
        },
      );
    }
  }

  for (final scale in [1.0, 1.5, 2.0]) {
    testWidgets("mobile row matches desktop height at scale $scale", (
      tester,
    ) async {
      Widget bar({required bool compact}) => MonogatariStatusBar(
        key: ValueKey(compact ? "mobile-statusbar" : "desktop-statusbar"),
        compact: compact,
        displayText: "文件",
        saveTimeText: "12:00",
        cursorLine: 12,
        cursorColumn: 23,
        currentWords: 446,
        totalWords: 446,
        iconSize: 14,
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.getLightTheme(14, Colors.lightBlue),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [bar(compact: false), bar(compact: true)],
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final desktop = find.byKey(const ValueKey("desktop-statusbar"));
      final mobile = find.byKey(const ValueKey("mobile-statusbar"));
      final desktopHeight = tester.getSize(desktop).height;
      expect(tester.getSize(mobile).height, closeTo(desktopHeight, .001));
      await tester.tap(find.byKey(const Key("statusbar-expand")));
      await tester.pump();
      expect(tester.getSize(mobile).height, closeTo(desktopHeight * 2, .001));
      expect(
        tester.getSize(find.byKey(const Key("statusbar-summary-row"))).height,
        tester.getSize(find.byKey(const Key("statusbar-secondary-row"))).height,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
