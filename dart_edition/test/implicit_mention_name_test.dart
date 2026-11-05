import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/content.dart';
import 'package:monogatari_assistant/bin/findreplace.dart';
import 'package:monogatari_assistant/features/editor/plain_text_quill_adapter.dart';
import 'package:monogatari_assistant/l10n/app_localization.dart';
import 'package:monogatari_assistant/models/character_data.dart';
import 'package:monogatari_assistant/presentation/providers/project_state_providers.dart';

void main() {
  const id = '4e251fc2-1e2b-4f78-93da-91f8c76d9a92';
  for (final state in {'': '', '+': '：開始', '-': '：結束'}.entries) {
    for (final quill in [false, true]) {
      testWidgets(
        'implicit label follows original name and renames, Quill=$quill, state=${state.key}',
        (tester) async {
          final container = ProviderContainer();
          addTearDown(container.dispose);
          void rename(String name) =>
              container.read(characterDataProvider.notifier).setCharacterData({
                id: CharacterEntryData(
                  characterId: id,
                  displayName: name,
                  aliases: const [
                    CharacterAlias(values: ['別名']),
                  ],
                ),
              });
          rename('Chino');
          final raw = '前//@${state.key}<$id|>{note}//後';
          final controller = HighlightTextEditingController(text: raw);
          final focus = FocusNode();
          addTearDown(controller.dispose);
          addTearDown(focus.dispose);
          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp(
                localizationsDelegates: AppLocalization.delegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale.fromSubtags(
                  languageCode: 'zh',
                  scriptCode: 'Hant',
                ),
                home: Scaffold(
                  body: EditorTextBox(
                    controller: controller,
                    focusNode: focus,
                    usePlainTextQuillEditor: quill,
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(controller.displayText, '前\uFFFC（Chino${state.value}）後');
          if (quill) {
            expect(
              PlainTextQuillAdapter.toPlainText(
                tester
                    .widget<QuillEditor>(find.byType(QuillEditor))
                    .controller
                    .document,
              ),
              '前\u2003（Chino${state.value}）後',
            );
          }
          controller.selection = TextSelection.collapsed(
            offset: controller
                .projection
                .projectedAnnotations
                .single
                .displayRange
                .end,
          );
          await tester.pump();
          rename('千乃');
          await tester.pumpAndSettle();
          expect(controller.displayText, '前\uFFFC（千乃${state.value}）後');
          expect(
            controller.selection.extentOffset,
            controller.projection.projectedAnnotations.single.displayRange.end,
          );
          expect(controller.rawText, raw);
          expect(controller.rawRevision, 0);
          expect(controller.annotations.single.displayText, isEmpty);
          expect(controller.projection.readerText, '前後');
          if (quill) {
            expect(
              PlainTextQuillAdapter.toPlainText(
                tester
                    .widget<QuillEditor>(find.byType(QuillEditor))
                    .controller
                    .document,
              ),
              '前\u2003（千乃${state.value}）後',
            );
          }
          // Display-name mapping never changes an explicit label.
          controller.setRawText('//@<$id|別名>//');
          await tester.pumpAndSettle();
          expect(controller.displayText, '\uFFFC別名');
        },
      );
    }
  }
}
