import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/slidebar.dart';
import 'package:monogatari_assistant/features/help/help_catalog.dart';
import 'package:monogatari_assistant/features/navigation/app_module.dart';
import 'package:monogatari_assistant/l10n/app_localization.dart';
import 'package:monogatari_assistant/l10n/ribbon_localizations_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'all navigation destinations and role labels resolve in three languages',
    () {
      const homes = ['首頁', 'Home', 'ホーム'];
      const roles = ['主角', 'Protagonist', '主人公'];
      for (var i = 0; i < supportedAppLocales.length; i++) {
        final l10n = lookupAppLocalizations(supportedAppLocales[i]);
        expect(l10n.legacyLabel(AppModule.all.first.label), homes[i]);
        expect(l10n.characterTypeLabel('protagonist'), roles[i]);
        expect(l10n.characterTypeLabel('自訂の角色'), '自訂の角色');
        final labels = AppModule.all
            .map((m) => l10n.legacyLabel(m.label))
            .toList();
        expect(labels.toSet(), hasLength(AppModule.all.length));
        if (i == 1) {
          for (final module in AppModule.all.where(
            (m) => m.label != 'Copilot',
          )) {
            expect(
              l10n.legacyLabel(module.label),
              isNot(module.label),
              reason: module.id.name,
            );
          }
        }
        final ribbon = localizedRibbon(l10n, TargetPlatform.macOS);
        expect(ribbon.moreOptions, isNotEmpty);
        expect(ribbon.font, isNotEmpty);
        expect(ribbon.tabSemantics('ABC'), contains('ABC'));
        expect(ribbon.tabSemantics('ABC'), isNot(contains('{label}')));
        expect(ribbon.expandRibbon, contains('Ctrl+F1'));
      }
    },
  );

  test('conflict labels preserve custom keys and stable path identities', () {
    final l10n = lookupAppLocalizations(const Locale('en'));
    const customPath = ['自訂欄位', '作者'];
    expect(l10n.conflictFieldPathLabel(customPath), 'Custom Field > 作者');
    expect(customPath, ['自訂欄位', '作者']);
    expect(
      l10n.conflictFieldPathLabel(['人物關係', 'row-id', '內在關係']),
      'Character Relationships > row-id > Internal Relationship',
    );
  });

  test('catalogs preserve declared placeholders in every translation', () {
    Map<String, dynamic> read(String locale) =>
        jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
            as Map<String, dynamic>;
    final source = read('zh');
    final keys = source.keys.where((key) => !key.startsWith('@')).toSet();
    for (final locale in ['en', 'ja']) {
      final translated = read(locale);
      expect(
        translated.keys.where((key) => !key.startsWith('@')).toSet(),
        keys,
      );
      for (final key in keys) {
        final metadata = source['@$key'] as Map<String, dynamic>? ?? {};
        final placeholders =
            (metadata['placeholders'] as Map<String, dynamic>? ?? {}).keys;
        for (final placeholder in placeholders) {
          expect(
            translated[key],
            contains('{$placeholder}'),
            reason: '$locale:$key:$placeholder',
          );
        }
      }
    }
  });

  test(
    'all help topics keep their stable IDs and links in English and Japanese',
    () {
      HelpCatalog read(String locale) => HelpCatalog.parse(
        File('assets/help/$locale.json').readAsStringSync(),
      );
      final source = read('zh_TW');
      for (final locale in ['en', 'ja']) {
        final translated = read(locale);
        expect(translated.topics.keys, source.topics.keys);
        for (final topic in translated.topics.values) {
          expect(topic.title, isNotEmpty);
          expect([
            ...topic.sections.first.paragraphs,
            ...topic.sections.first.steps,
          ], isNotEmpty);
          expect(topic.relatedIds, source.topic(topic.id).relatedIds);
        }
        expect(
          translated.search(locale == 'en' ? 'Timeline' : 'タイムライン'),
          isNotEmpty,
        );
      }
    },
  );

  testWidgets('localized help catalogs are included in the asset bundle', (
    tester,
  ) async {
    for (final locale in ['en', 'ja', 'zh-Hant']) {
      final catalog = await tester.runAsync(
        () => HelpCatalog.load(localeName: locale),
      );
      expect(catalog!.topics, hasLength(64));
      expect(catalog.topic('help.home').title, isNotEmpty);
    }
  });

  testWidgets(
    'navigation labels update without replacing the draft or selection',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final locale = ValueNotifier(defaultAppLocale);
      final draft = TextEditingController(text: '原文は翻訳しない');
      addTearDown(locale.dispose);
      addTearDown(draft.dispose);
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, language, __) => MaterialApp(
            locale: language,
            supportedLocales: supportedAppLocales,
            localizationsDelegates: AppLocalization.delegates,
            home: Scaffold(
              body: MonogatariNavigationLayout(
                selectedIndex: 5,
                onDestinationSelected: (_) {},
                child: TextField(controller: draft),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final state = tester.state(find.byType(MonogatariNavigationLayout));
      draft.selection = const TextSelection.collapsed(offset: 3);
      for (final language in [
        const Locale('en'),
        const Locale('ja'),
        defaultAppLocale,
      ]) {
        locale.value = language;
        await tester.pumpAndSettle();
        expect(
          tester.state(find.byType(MonogatariNavigationLayout)),
          same(state),
        );
        expect(
          tester
              .widget<MonogatariNavigationLayout>(
                find.byType(MonogatariNavigationLayout),
              )
              .selectedIndex,
          5,
        );
        expect(draft.text, '原文は翻訳しない');
        expect(draft.selection.baseOffset, 3);
        expect(tester.takeException(), isNull);
      }
    },
  );
}
