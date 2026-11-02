import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/l10n/app_localization.dart';
import 'package:monogatari_assistant/models/character_data.dart';
import 'package:monogatari_assistant/modules/characterview.dart';
import 'package:monogatari_assistant/presentation/providers/project_state_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  for (final language in ['en', 'ja']) {
    testWidgets(
      '$language character questionnaire translates app labels and preserves values',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        tester.view.physicalSize = const Size(1200, 2000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final person = CharacterEntryData.withName('主角という原文');
        container
            .read(characterDataProvider.notifier)
            .setCharacterEntry(characterId: person.characterId, entry: person);
        final locale = Locale(language);
        final l10n = lookupAppLocalizations(locale);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              locale: locale,
              supportedLocales: supportedAppLocales,
              localizationsDelegates: AppLocalization.delegates,
              home: Scaffold(body: CharacterView()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final advanced = find.text(l10n.uiAdvancedSettings);
        await tester.ensureVisible(advanced);
        await tester.tap(advanced);
        await tester.pumpAndSettle();
        final social = find.text(l10n.uiSocialQuestionnaire);
        await tester.ensureVisible(social);
        await tester.tap(social);
        await tester.pumpAndSettle();
        final option = find.widgetWithText(
          CheckboxListTile,
          l10n.uiConfessDirectly,
        );
        await tester.ensureVisible(option);
        await tester.tap(option);
        await tester.pump(const Duration(milliseconds: 1200));
        expect(
          container
              .read(characterDataProvider)[person.characterId]!
              .howToShowLove['confess_directly'],
          isTrue,
        );
        expect(
          container
              .read(characterDataProvider)[person.characterId]!
              .displayName,
          '主角という原文',
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
