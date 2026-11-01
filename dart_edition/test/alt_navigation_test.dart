import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/features/navigation/app_module.dart';
import 'package:monogatari_assistant/features/navigation/workspace_navigation_shortcuts.dart';
import 'package:monogatari_assistant/presentation/widgets/module_switcher.dart';

Future<void> alt(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
  await tester.sendKeyEvent(key);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
  await tester.pump();
}

void main() {
  test(
    'all modules retain legacy indexes and cycle through help and settings',
    () {
      expect(AppModule.all.length, 18);
      expect(AppModule.all.map((module) => module.id).toSet().length, 18);
      expect(
        AppModule.all.map((module) => module.navigationIndex).toSet().length,
        18,
      );
      expect(AppModule.forNavigation(14).id, AppModuleId.settings);
      expect(AppModule.forNavigation(15).id, AppModuleId.about);
      expect(AppModule.forNavigation(16).id, AppModuleId.help);
      expect(
        AppModule.forPage(AppModule.editorPageIndex).id,
        AppModuleId.editor,
      );
      expect(AppModule.step(AppModule.all.last, 1), AppModule.all.first);
      expect(AppModule.step(AppModule.all.first, -1), AppModule.all.last);
      expect(
        AppModule.step(AppModule.forNavigation(14), 1).id,
        AppModuleId.help,
      );
    },
  );

  for (final platform in [
    TargetPlatform.windows,
    TargetPlatform.macOS,
    TargetPlatform.linux,
  ]) {
    testWidgets(
      '$platform: Alt axes preserve text and ignore repeats/modifiers/modal/IME',
      (tester) async {
        final controller = TextEditingController(text: '甲乙丙丁');
        final focus = FocusNode();
        addTearDown(controller.dispose);
        addTearDown(focus.dispose);
        final ribbon = <int>[];
        final modules = <int>[];
        final opened = <AppModule>[];
        var blocked = false;
        late BuildContext routeContext;
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: platform),
            home: Builder(
              builder: (context) {
                routeContext = context;
                return WorkspaceNavigationShortcuts(
                  isBlocked: () => blocked,
                  onRibbonStep: ribbon.add,
                  onModuleStep: modules.add,
                  onOpenSwitcher: () {},
                  onOpenModule: opened.add,
                  child: Scaffold(
                    body: TextField(controller: controller, focusNode: focus),
                  ),
                );
              },
            ),
          ),
        );
        focus.requestFocus();
        controller.selection = const TextSelection(
          baseOffset: 1,
          extentOffset: 3,
        );
        await tester.pump();
        await alt(tester, LogicalKeyboardKey.arrowLeft);
        await alt(tester, LogicalKeyboardKey.arrowRight);
        await alt(tester, LogicalKeyboardKey.arrowUp);
        await alt(tester, LogicalKeyboardKey.arrowDown);
        expect(ribbon, [-1, 1]);
        expect(modules, [-1, 1]);
        expect(controller.text, '甲乙丙丁');
        expect(
          controller.selection,
          const TextSelection(baseOffset: 1, extentOffset: 3),
        );
        expect(focus.hasFocus, isTrue);

        await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
        await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyRepeatEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowDown);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
        expect(modules, [-1, 1, 1]);
        await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        await alt(tester, LogicalKeyboardKey.arrowDown);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        expect(modules.length, 3);

        blocked = true;
        await alt(tester, LogicalKeyboardKey.arrowDown);
        expect(modules.length, 3);
        blocked = false;
        controller.value = const TextEditingValue(
          text: '甲乙丙丁',
          selection: TextSelection.collapsed(offset: 2),
          composing: TextRange(start: 1, end: 2),
        );
        await alt(tester, LogicalKeyboardKey.arrowDown);
        expect(modules.length, 3);
        controller.clearComposing();

        final primary = platform == TargetPlatform.macOS
            ? LogicalKeyboardKey.metaLeft
            : LogicalKeyboardKey.controlLeft;
        await tester.sendKeyDownEvent(primary);
        await tester.sendKeyEvent(LogicalKeyboardKey.digit9);
        await tester.sendKeyUpEvent(primary);
        expect(opened.single.id, AppModuleId.help);

        final dialog = showDialog<void>(
          context: routeContext,
          builder: (_) =>
              const AlertDialog(content: TextField(autofocus: true)),
        );
        await tester.pumpAndSettle();
        await alt(tester, LogicalKeyboardKey.arrowDown);
        expect(modules.length, 3);
        Navigator.of(routeContext).pop();
        await tester.pumpAndSettle();
        await dialog;
      },
    );
  }

  testWidgets('module picker filters, accepts keyboard selection and cancels', (
    tester,
  ) async {
    AppModule? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                selected = await ModuleSwitcher.show(
                  context,
                  AppModule.all.first,
                );
              },
              child: const Text('切換'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('切換'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('module-switcher-query')),
      '說明',
    );
    await tester.pump();
    expect(find.widgetWithText(ListTile, '說明'), findsOneWidget);
    expect(find.widgetWithText(ListTile, '設定'), findsNothing);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(selected?.id, AppModuleId.help);
    selected = null;
    await tester.tap(find.text('切換'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(selected, isNull);
    expect(find.byType(ModuleSwitcher), findsNothing);
  });
}
