import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ribbon/material_ribbon.dart';
import 'package:monogatari_assistant/bin/content.dart';
import 'package:monogatari_assistant/features/help/help_module.dart';
import 'package:monogatari_assistant/features/help/help_controller.dart';
import 'package:monogatari_assistant/features/help/help_viewer.dart';
import 'package:monogatari_assistant/main.dart';
import 'package:monogatari_assistant/models/toolbar_mode.dart';
import 'package:monogatari_assistant/presentation/providers/editor_coordinator_provider.dart';
import 'package:monogatari_assistant/presentation/providers/project_state_providers.dart';
import 'package:monogatari_assistant/presentation/widgets/module_switcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> chord(
  WidgetTester tester,
  LogicalKeyboardKey modifier,
  LogicalKeyboardKey key,
) async {
  await tester.sendKeyDownEvent(modifier);
  await tester.sendKeyEvent(key);
  await tester.sendKeyUpEvent(modifier);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  for (final mode in ToolbarMode.values) {
    for (final width in [390.0, 1600.0]) {
      testWidgets(
        '${mode.name} $width: real workspace navigates ribbon, modules and embedded help',
        (tester) async {
          SharedPreferences.setMockInitialValues({'toolbar_mode': mode.name});
          await tester.binding.setSurfaceSize(Size(width, 1000));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final navigator = GlobalKey<NavigatorState>();
          final container = ProviderContainer();
          addTearDown(container.dispose);
          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp(
                navigatorKey: navigator,
                builder: (_, child) =>
                    AppHelpHost(navigatorKey: navigator, child: child!),
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  FlutterQuillLocalizations.delegate,
                ],
                home: const ContentView(),
              ),
            ),
          );
          await tester.pump(const Duration(seconds: 1));
          expect(find.byKey(const Key('module-switcher-button')), findsNothing);

          // Body focus is the same editor mounted before and after module changes.
          await chord(
            tester,
            LogicalKeyboardKey.controlLeft,
            LogicalKeyboardKey.digit1,
          );
          container.read(editorContentProvider.notifier).setContent('甲乙丙丁');
          await tester.pump(const Duration(seconds: 1));
          final quill = tester.widget<QuillEditor>(
            find.byKey(const ValueKey('plain-text-quill-editor')),
          );
          quill.controller.updateSelection(
            const TextSelection(baseOffset: 1, extentOffset: 3),
            ChangeSource.local,
          );
          await tester.pump();
          final editor = tester.widget<EditorTextBox>(
            find.byType(EditorTextBox),
          );
          final raw = editor.controller.text;
          final selection = editor.controller.selection;
          final dirty = container
              .read(editorCoordinatorProvider)
              .hasUnsavedChanges;
          editor.focusNode.requestFocus();
          await tester.pump();
          await chord(
            tester,
            LogicalKeyboardKey.altLeft,
            LogicalKeyboardKey.arrowRight,
          );
          expect(
            tester
                .widget<MaterialRibbon>(find.byType(MaterialRibbon))
                .selectedTabId,
            'search',
          );
          expect(
            find.text('搜尋……'),
            findsNothing,
            reason: 'Alt navigation does not open search',
          );
          expect(editor.focusNode.hasFocus, isTrue);
          expect(editor.controller.text, raw);
          expect(editor.controller.selection, selection);
          expect(
            container.read(editorCoordinatorProvider).hasUnsavedChanges,
            dirty,
          );
          await chord(
            tester,
            LogicalKeyboardKey.altLeft,
            LogicalKeyboardKey.arrowRight,
          );
          expect(
            tester
                .widget<MaterialRibbon>(find.byType(MaterialRibbon))
                .selectedTabId,
            'file',
          );
          await chord(
            tester,
            LogicalKeyboardKey.altLeft,
            LogicalKeyboardKey.arrowLeft,
          );
          expect(
            tester
                .widget<MaterialRibbon>(find.byType(MaterialRibbon))
                .selectedTabId,
            'search',
          );

          await chord(
            tester,
            LogicalKeyboardKey.controlLeft,
            LogicalKeyboardKey.digit8,
          );
          await chord(
            tester,
            LogicalKeyboardKey.altLeft,
            LogicalKeyboardKey.arrowDown,
          );
          expect(find.byType(HelpModule), findsOneWidget);
          final help = tester.widget<HelpViewer>(find.byType(HelpViewer));
          expect(help.embedded, isTrue);
          expect(find.byTooltip('關閉說明（Esc）'), findsNothing);
          expect(find.text('說明中心'), findsOneWidget);
          await tester.sendKeyEvent(LogicalKeyboardKey.f1);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 400));
          expect(
            find.byWidgetPredicate(
              (widget) => widget is HelpViewer && !widget.embedded,
            ),
            findsOneWidget,
          );
          await chord(
            tester,
            LogicalKeyboardKey.altLeft,
            LogicalKeyboardKey.arrowUp,
          );
          expect(
            find.byType(HelpModule),
            findsOneWidget,
            reason: 'F1 dialog blocks background module navigation',
          );
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 400));
          expect(
            find.byWidgetPredicate(
              (widget) => widget is HelpViewer && !widget.embedded,
            ),
            findsNothing,
          );
          await chord(
            tester,
            LogicalKeyboardKey.altLeft,
            LogicalKeyboardKey.arrowUp,
          );
          expect(find.byType(HelpModule), findsNothing);
          await chord(
            tester,
            LogicalKeyboardKey.controlLeft,
            LogicalKeyboardKey.digit9,
          );
          expect(find.byType(HelpModule), findsOneWidget);

          await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
          await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
          await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
          await tester.pump(const Duration(milliseconds: 400));
          expect(find.byType(ModuleSwitcher), findsOneWidget);
          await tester.enterText(
            find.byKey(const Key('module-switcher-query')),
            '首頁',
          );
          await tester.pump();
          await tester.tap(find.widgetWithText(ListTile, '首頁'));
          await tester.pump(const Duration(milliseconds: 400));
          expect(find.byType(ModuleSwitcher), findsNothing);
          expect(find.byType(HelpModule), findsNothing);
          expect(container.read(editorContentProvider), raw);
          await chord(
            tester,
            LogicalKeyboardKey.controlLeft,
            LogicalKeyboardKey.digit1,
          );
          expect(
            editor.controller.selection,
            selection,
            reason: 'module switching preserves body selection',
          );
          await chord(
            tester,
            LogicalKeyboardKey.controlLeft,
            LogicalKeyboardKey.keyF,
          );
          expect(find.text('搜尋……'), findsOneWidget);
          await chord(
            tester,
            LogicalKeyboardKey.controlLeft,
            LogicalKeyboardKey.keyF,
          );
          expect(find.text('搜尋……'), findsOneWidget);
          await chord(
            tester,
            LogicalKeyboardKey.controlLeft,
            LogicalKeyboardKey.keyH,
          );
          await tester.pump();
          expect(find.text('取代為……'), findsOneWidget);
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          await tester.pump();
          expect(find.text('搜尋……'), findsNothing);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump();
        },
      );
    }
  }
}
