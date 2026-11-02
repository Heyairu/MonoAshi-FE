import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/appbar.dart';
import 'package:monogatari_assistant/bin/findreplace.dart';
import 'package:monogatari_assistant/models/toolbar_mode.dart';

void main() {
  for (final mode in [ToolbarMode.moderate, ToolbarMode.concise]) {
    for (final reduceMotion in [false, true]) {
      testWidgets('${mode.name} selection spacing and motion=$reduceMotion', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(2400, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final options = FindReplaceOptions(matchCase: false, matchWidth: false);
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(disableAnimations: reduceMotion),
              child: child!,
            ),
            home: StatefulBuilder(
              builder: (context, update) => Scaffold(
                appBar: MonogatariTopAppBar(
                  iconSize: 22,
                  mode: mode,
                  modePreference: mode,
                  onModeChanged: (_) {},
                  showPunctuationPanel: false,
                  showFindReplaceWindow: true,
                  searchQuery: 'cat',
                  searchOptions: options.copy(),
                  onSearchOptionChanged: (option) => update(() {
                    options.setOption(option, !options.valueFor(option), 'cat');
                  }),
                  onFileAction: (_) async {},
                  onEditorAction: (_) async {},
                  onEditorActionPointerDown: () {},
                  onEditorActionInteractionEnd: () {},
                  onTogglePunctuationPanel: () {},
                  onToggleFindReplaceWindow: () {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        Finder button(String id) => find.byKey(ValueKey('toolbar-command-$id'));
        Finder surface(String id) =>
            find.descendant(of: button(id), matching: find.byType(Material));
        Color fill() =>
            tester.widget<Material>(surface('search.matchCase')).color!;
        Color? foreground() => IconTheme.of(
          tester.element(
            find.descendant(
              of: button('search.matchCase'),
              matching: find.byType(Icon),
            ),
          ),
        ).color;

        final target = button('search.matchCase');
        final bounds = tester.getRect(target);
        final colors = Theme.of(tester.element(target)).colorScheme;
        final first = tester.getRect(surface('find'));
        final second = tester.getRect(surface('search.matchCase'));
        final third = tester.getRect(surface('search.wholeWord'));
        expect(second.left - first.right, closeTo(12, .01));
        expect(third.left - second.right, closeTo(4, .01));
        expect(bounds.height, greaterThanOrEqualTo(48));
        expect(fill().a, 0);

        await tester.tap(target);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));
        expect(tester.widget<IconButton>(target).isSelected, isTrue);
        expect(tester.getRect(target), bounds);
        if (reduceMotion) {
          expect(fill(), colors.secondaryContainer);
          expect(foreground(), colors.onSecondaryContainer);
        } else {
          expect(fill().a, inExclusiveRange(0, 1));
          expect(foreground(), isNot(colors.onSurfaceVariant));
          expect(foreground(), isNot(colors.onSecondaryContainer));
        }

        // Reverse before the fade finishes; geometry and state stay stable.
        final previousAlpha = fill().a;
        await tester.tap(target);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 40));
        expect(fill().a, lessThan(previousAlpha));
        await tester.pumpAndSettle();
        expect(fill().a, 0);
        expect(foreground(), colors.onSurfaceVariant);
        expect(tester.getRect(target), bounds);

        // A new page must not inherit the selected Find button's fade.
        await tester.tap(find.text('檔案'));
        await tester.pump();
        expect(tester.widget<Material>(surface('new')).color!.a, 0);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
