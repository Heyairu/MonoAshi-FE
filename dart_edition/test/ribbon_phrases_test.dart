import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/content.dart';
import 'package:monogatari_assistant/features/inline_annotations/mosaic_editing_controller.dart';
import 'package:monogatari_assistant/features/phrases/global_phrases_provider.dart';
import 'package:monogatari_assistant/features/phrases/phrase_entry.dart';
import 'package:monogatari_assistant/features/phrases/phrase_library_dialog.dart';
import 'package:monogatari_assistant/main.dart';
import 'package:monogatari_assistant/models/toolbar_mode.dart';
import 'package:monogatari_assistant/presentation/providers/project_state_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final mode in ToolbarMode.values) {
    testWidgets('${mode.name} Ribbon manages, inserts and saves body phrases', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'toolbar_mode': mode.name});
      const channel = MethodChannel(
        'com.heyairu.monogatari_assistant/background_execution',
      );
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (_) async => true,
      );
      addTearDown(() {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        );
      });
      await tester.binding.setSurfaceSize(const Size(2400, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(globalPhrasesProvider.future);
      final now = DateTime.utc(2026, 10, 25);
      container.read(phrasesProvider.notifier).setPhrases([
        PhraseEntry(
          id: '8f680e3c-90c1-4f37-ae35-f70c4dc7fe8f',
          name: '抵達',
          shortcut: 'arrive',
          body: '她抵達了。',
          createdAt: now,
          updatedAt: now,
        ),
      ]);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
            home: ContentView(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      final editor = tester.widget<EditorTextBox>(find.byType(EditorTextBox));
      final body = editor.controller as MosaicEditingController;
      expect(editor.showPhraseActions, isFalse);
      expect(find.byKey(const ValueKey('phrase-library-button')), findsNothing);

      Future<void> invoke(String tooltip) async {
        final button = find.byTooltip(tooltip);
        await tester.ensureVisible(button);
        await tester.tap(button);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
      }

      await invoke('短語庫');
      expect(find.byType(PhraseLibraryDialog), findsOneWidget);
      expect(find.text('arrive'), findsWidgets);
      await tester.tap(find.byTooltip('關閉'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      body.setRawText('前文 舊內容 後文');
      editor.focusNode.requestFocus();
      await tester.pump();
      body.selection = const TextSelection(baseOffset: 3, extentOffset: 6);
      await tester.pump();
      await invoke('插入短語');
      expect(find.text('插入短語'), findsWidgets);
      // Dialog focus may clear the body's selection. The Ribbon must still
      // replace the range captured when the command was invoked.
      body.selection = const TextSelection.collapsed(offset: 0);
      await tester.tap(find.text('arrive · 抵達'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(body.rawText, '前文 她抵達了。 後文');

      const mention = '//@<4e251fc2-1e2b-4f78-93da-91f8c76d9a92|艾莉絲>//';
      body.setRawText('前$mention後');
      editor.focusNode.requestFocus();
      await tester.pump();
      body.selection = const TextSelection(baseOffset: 1, extentOffset: 2);
      await tester.pump();
      await invoke('選取內容存為短語');
      expect(find.byType(PhraseLibraryDialog), findsOneWidget);
      final phraseBody =
          tester
                  .widget<CodeField>(
                    find.descendant(
                      of: find.byKey(const ValueKey('phrase-body')),
                      matching: find.byType(CodeField),
                    ),
                  )
                  .controller
              as MosaicEditingController;
      expect(phraseBody.rawText, mention);
      expect(find.text('含 Mention，只能用於目前專案'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
