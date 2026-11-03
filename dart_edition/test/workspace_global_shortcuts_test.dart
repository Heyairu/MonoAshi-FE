import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/features/navigation/workspace_navigation_shortcuts.dart';

void main() {
  for (final platform in [
    TargetPlatform.windows,
    TargetPlatform.macOS,
    TargetPlatform.linux,
  ]) {
    testWidgets(
      '$platform: commands survive lost focus and override local bindings',
      (tester) async {
        final workspace = FocusNode();
        final outside = FocusNode();
        final input = FocusNode();
        final controller = TextEditingController(text: 'local text');
        addTearDown(workspace.dispose);
        addTearDown(outside.dispose);
        addTearDown(input.dispose);
        addTearDown(controller.dispose);
        final calls = <String>[];
        String? clipboard;
        var clipboardReads = 0;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async {
            if (call.method == 'Clipboard.getData') {
              clipboardReads++;
              return clipboard == null ? null : {'text': clipboard!};
            }
            if (call.method == 'Clipboard.setData') {
              clipboard = (call.arguments as Map)['text'] as String;
            }
            return null;
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            null,
          ),
        );
        var blocked = false;
        var localCalls = 0;
        var localCancellations = 0;
        final apple = platform == TargetPlatform.macOS;
        final primary = apple
            ? LogicalKeyboardKey.metaLeft
            : LogicalKeyboardKey.controlLeft;
        late BuildContext routeContext;

        Future<void> press(
          LogicalKeyboardKey key, {
          bool shift = false,
          bool alt = false,
          bool repeat = false,
          bool modified = true,
        }) async {
          if (modified) await tester.sendKeyDownEvent(primary);
          if (shift) {
            await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
          }
          if (alt) await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
          await tester.sendKeyDownEvent(key);
          if (repeat) await tester.sendKeyRepeatEvent(key);
          await tester.sendKeyUpEvent(key);
          if (alt) await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
          if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
          if (modified) await tester.sendKeyUpEvent(primary);
          await tester.pump();
        }

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: platform),
            home: Builder(
              builder: (context) {
                routeContext = context;
                return Material(
                  child: Column(
                    children: [
                      Focus(focusNode: outside, child: const Text('Outside')),
                      WorkspaceNavigationShortcuts(
                        focusNode: workspace,
                        isBlocked: () => blocked,
                        onRibbonStep: (_) => calls.add('ribbon'),
                        onModuleStep: (_) => calls.add('module'),
                        onOpenSwitcher: () => calls.add('switcher'),
                        onOpenModule: (_) => calls.add('openModule'),
                        onNew: () => calls.add('new'),
                        onOpen: () => calls.add('open'),
                        onSave: () => calls.add('save'),
                        onSaveAs: () => calls.add('saveAs'),
                        onUndo: () => calls.add('undo'),
                        onRedo: () => calls.add('redo'),
                        onFind: () => calls.add('find'),
                        onReplace: () => calls.add('replace'),
                        onSearchResult: (forward) =>
                            calls.add(forward ? 'next' : 'previous'),
                        onCloseSearch: () => calls.add('closeSearch'),
                        child: CallbackShortcuts(
                          bindings: {
                            const SingleActivator(
                              LogicalKeyboardKey.escape,
                            ): () =>
                                localCancellations++,
                            for (final key in [
                              LogicalKeyboardKey.keyN,
                              LogicalKeyboardKey.keyO,
                              LogicalKeyboardKey.keyS,
                              LogicalKeyboardKey.keyZ,
                              LogicalKeyboardKey.keyY,
                            ])
                              SingleActivator(
                                key,
                                control: !apple,
                                meta: apple,
                              ): () =>
                                  localCalls++,
                          },
                          child: TextField(
                            focusNode: input,
                            controller: controller,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        // No input or workspace focus: all application commands still work.
        outside.requestFocus();
        await tester.pump();
        expect(workspace.hasFocus, isFalse);
        await press(LogicalKeyboardKey.keyN);
        await press(LogicalKeyboardKey.keyO);
        await press(LogicalKeyboardKey.keyS, repeat: true);
        await press(LogicalKeyboardKey.keyS, shift: true, repeat: true);
        await press(LogicalKeyboardKey.keyZ, repeat: true);
        await press(LogicalKeyboardKey.keyZ, shift: true);
        if (!apple) await press(LogicalKeyboardKey.keyY);
        await press(LogicalKeyboardKey.keyF);
        await press(
          apple ? LogicalKeyboardKey.keyF : LogicalKeyboardKey.keyH,
          alt: apple,
        );
        await press(
          apple ? LogicalKeyboardKey.keyG : LogicalKeyboardKey.f3,
          modified: apple,
        );
        await press(
          apple ? LogicalKeyboardKey.keyG : LogicalKeyboardKey.f3,
          modified: apple,
          shift: true,
        );
        await press(LogicalKeyboardKey.keyM, shift: true);
        await press(LogicalKeyboardKey.digit1);
        await press(LogicalKeyboardKey.arrowRight, modified: false, alt: true);
        await press(LogicalKeyboardKey.arrowDown, modified: false, alt: true);
        await press(LogicalKeyboardKey.escape, modified: false);
        expect(calls, [
          'new',
          'open',
          'save',
          'saveAs',
          'undo',
          'undo',
          'redo',
          if (!apple) 'redo',
          'find',
          'replace',
          'next',
          'previous',
          'switcher',
          'openModule',
          'ribbon',
          'module',
          'closeSearch',
        ]);
        calls.clear();

        input.requestFocus();
        await tester.pump();
        await press(LogicalKeyboardKey.keyS);
        await press(LogicalKeyboardKey.keyZ);
        expect(calls, ['save', 'undo']);
        expect(localCalls, 0);
        calls.clear();
        await press(LogicalKeyboardKey.escape, modified: false);
        expect(localCancellations, 1);
        expect(calls, isEmpty);

        // Disabled commands are consumed before local handlers can see them.
        blocked = true;
        await press(LogicalKeyboardKey.keyZ);
        await press(LogicalKeyboardKey.keyS);
        expect(calls, isEmpty);
        expect(localCalls, 0);
        blocked = false;

        controller.value = const TextEditingValue(
          text: 'local text',
          selection: TextSelection.collapsed(offset: 1),
          composing: TextRange(start: 0, end: 1),
        );
        await press(LogicalKeyboardKey.keyF);
        expect(calls, isEmpty);
        controller.clearComposing();

        // Clipboard and selection keys continue through the focused input.
        await press(LogicalKeyboardKey.keyA);
        expect(
          controller.selection,
          const TextSelection(baseOffset: 0, extentOffset: 10),
        );
        await press(LogicalKeyboardKey.keyC);
        expect(clipboard, 'local text');
        clipboard = 'pasted';
        await press(LogicalKeyboardKey.keyV);
        expect(controller.text, 'pasted');
        await press(LogicalKeyboardKey.keyA);
        await press(LogicalKeyboardKey.keyX);
        expect(controller.text, isEmpty);
        expect(clipboard, 'pasted');
        await press(LogicalKeyboardKey.keyV);
        expect(controller.text, 'pasted');
        expect(calls, isEmpty);
        await press(LogicalKeyboardKey.keyS, alt: true);
        expect(calls, isEmpty);

        FocusManager.instance.primaryFocus!.unfocus();
        await tester.pump();
        expect(workspace.hasFocus, isFalse);
        final readsBefore = clipboardReads;
        clipboard = 'must not paste';
        await press(LogicalKeyboardKey.keyV);
        expect(controller.text, 'pasted');
        expect(clipboardReads, readsBefore);
        await press(LogicalKeyboardKey.keyS);
        expect(calls, ['save']);
        calls.clear();

        final dialog = showDialog<void>(
          context: routeContext,
          builder: (_) =>
              const AlertDialog(content: TextField(autofocus: true)),
        );
        await tester.pumpAndSettle();
        await press(LogicalKeyboardKey.keyZ);
        await press(LogicalKeyboardKey.keyS);
        expect(calls, isEmpty);
        Navigator.of(routeContext).pop();
        await tester.pumpAndSettle();
        await dialog;

        // Disposing the router must unregister its application-wide handler.
        await tester.pumpWidget(const MaterialApp(home: SizedBox()));
        await press(LogicalKeyboardKey.keyS);
        expect(calls, isEmpty);
      },
      variant: TargetPlatformVariant({platform}),
    );
  }
}
