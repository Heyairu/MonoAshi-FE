import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/features/help/help_assets.dart';
import 'package:monogatari_assistant/features/help/help_catalog.dart';
import 'package:monogatari_assistant/features/help/help_viewer.dart';
import 'package:monogatari_assistant/l10n/app_localization.dart';

class _MemoryBundle extends CachingAssetBundle {
  _MemoryBundle(this.files);
  final Map<String, String> files;
  @override
  Future<ByteData> load(String key) => throw UnimplementedError();
  @override
  Future<String> loadString(String key, {bool cache = true}) async =>
      files[key] ?? (throw FlutterError('Missing asset: $key'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final files = {
    for (final name in ['manifest', 'zh_TW', 'en', 'ja'])
      'assets/help/$name.json': File(
        'assets/help/$name.json',
      ).readAsStringSync(),
  };
  final catalogs = {
    for (final locale in ['zh_TW', 'en', 'ja'])
      locale: HelpCatalog.parse(files['assets/help/$locale.json']!),
  };

  test(
    'all languages retain every article, section, paragraph, step and link',
    () {
      final source = catalogs['zh_TW']!;
      expect(source.topics, hasLength(64));
      expect(
        HelpAssetManifest.parse(files[HelpAssets.manifestPath]!).topicIds,
        source.topics.keys.toSet(),
      );
      for (final entry in catalogs.entries) {
        final catalog = entry.value;
        expect(catalog.localeName, entry.key);
        expect(catalog.contentVersion, HelpAssets.contentVersion);
        expect(catalog.topics.keys, orderedEquals(source.topics.keys));
        var paragraphCount = 0;
        var stepCount = 0;
        var sectionCount = 0;
        for (final topic in catalog.topics.values) {
          final original = source.topic(topic.id);
          expect(topic.relatedIds, original.relatedIds, reason: topic.id);
          expect(
            topic.sections,
            hasLength(original.sections.length),
            reason: topic.id,
          );
          expect(
            topic.keywords,
            hasLength(original.keywords.length),
            reason: topic.id,
          );
          for (var i = 0; i < topic.sections.length; i++) {
            final section = topic.sections[i];
            expect(section.heading.trim(), isNotEmpty);
            expect(
              section.paragraphs,
              hasLength(original.sections[i].paragraphs.length),
            );
            expect(section.steps, hasLength(original.sections[i].steps.length));
            for (final text in [...section.paragraphs, ...section.steps]) {
              expect(text.trim(), isNotEmpty);
              if (entry.key != 'zh_TW') {
                expect(
                  [
                    ...original.sections[i].paragraphs,
                    ...original.sections[i].steps,
                  ],
                  isNot(contains(text)),
                  reason: '${entry.key}:${topic.id}',
                );
              }
            }
            paragraphCount += section.paragraphs.length;
            stepCount += section.steps.length;
            sectionCount++;
          }
        }
        expect(sectionCount, 167);
        expect(paragraphCount, 258);
        expect(stepCount, 230);
      }
    },
  );

  test('search finds localized bodies, CJK terms and full-width ASCII', () {
    expect(
      catalogs['en']!.search('backreferences').map((t) => t.id),
      contains('search.useRegexp'),
    );
    expect(
      catalogs['en']!.search('ｃｔｒｌ＋ｆ').map((t) => t.id),
      contains('search.overview'),
    );
    expect(
      catalogs['ja']!.search('バックアップ').map((t) => t.id),
      contains('settings.backup'),
    );
    expect(
      catalogs['ja']!.search('全角数字').map((t) => t.id),
      contains('search.useRegexp'),
    );
    expect(
      catalogs['ja']!.search('ＩＭＥ').map((t) => t.id),
      contains('search.overview'),
    );
    expect(
      catalogs['zh_TW']!.search('字型').map((t) => t.id),
      contains('pages.settings'),
    );
    expect(HelpAssets.cacheKey('ja_JP'), HelpAssets.cacheKey('JA-jp'));
    expect(HelpAssets.localeFor('fr'), 'zh_TW');
  });

  test(
    'loader rejects incomplete, stale, wrongly identified and missing resources',
    () async {
      Future<void> rejects(void Function(Map<String, dynamic>) change) async {
        final copy = Map.of(files);
        final data =
            jsonDecode(copy['assets/help/en.json']!) as Map<String, dynamic>;
        change(data);
        copy['assets/help/en.json'] = jsonEncode(data);
        await expectLater(
          HelpCatalog.load(bundle: _MemoryBundle(copy), localeName: 'en'),
          throwsFormatException,
        );
      }

      await rejects((d) => d['contentVersion'] = 1);
      await rejects((d) => d['locale'] = 'ja');
      await rejects((d) => (d['topics'] as List).removeLast());
      await rejects((d) => d['topics'][0]['sections'] = []);
      await rejects((d) => d['topics'][0]['sections'][0]['paragraphs'] = ['']);
      final missing = Map.of(files)..remove('assets/help/ja.json');
      await expectLater(
        HelpCatalog.load(bundle: _MemoryBundle(missing), localeName: 'ja'),
        throwsA(isA<FlutterError>()),
      );
      final manifest =
          jsonDecode(files[HelpAssets.manifestPath]!) as Map<String, dynamic>;
      (manifest['locales'] as Map).remove('ja');
      expect(
        () => HelpAssetManifest.parse(jsonEncode(manifest)),
        throwsFormatException,
      );
    },
  );

  testWidgets(
    'all three complete assets load from the bundled offline resources',
    (tester) async {
      for (final locale in ['zh-Hant', 'en_US', 'ja-JP']) {
        final catalog = await tester.runAsync(
          () => HelpCatalog.load(localeName: locale),
        );
        expect(catalog!.topics, hasLength(64));
        expect(catalog.localeName, HelpAssets.localeFor(locale));
      }
    },
  );

  testWidgets(
    'rapid language switches discard stale results and preserve query and history',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final locale = ValueNotifier(const Locale('en'));
      final topic = ValueNotifier('help.home');
      final focus = FocusNode();
      addTearDown(locale.dispose);
      addTearDown(topic.dispose);
      addTearDown(focus.dispose);
      final pendingJa = Completer<HelpCatalog>();
      final pendingZh = Completer<HelpCatalog>();
      var loads = 0;
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, value, child) => MaterialApp(
            locale: value,
            supportedLocales: supportedAppLocales,
            localizationsDelegates: AppLocalization.delegates,
            home: Scaffold(
              body: HelpViewer(
                embedded: true,
                topic: topic,
                focusNode: focus,
                loadCatalog: () {
                  loads++;
                  return switch (value.languageCode) {
                    'ja' => pendingJa.future,
                    'zh' => pendingZh.future,
                    _ => Future.value(catalogs['en']),
                  };
                },
                retryCatalog: () {},
                onTopic: (id) => topic.value = id,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      topic.value = 'pages.settings';
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'MCP');
      await tester.pumpAndSettle();
      final enBody = catalogs['en']!
          .topic('pages.settings')
          .sections
          .first
          .paragraphs
          .first;
      expect(find.text(enBody), findsOneWidget);
      locale.value = const Locale('ja');
      await tester.pump();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(enBody), findsNothing);
      locale.value = defaultAppLocale;
      await tester.pump();
      await tester.pump();
      pendingZh.complete(catalogs['zh_TW']);
      await tester.pumpAndSettle();
      pendingJa.complete(catalogs['ja']);
      await tester.pumpAndSettle();
      expect(loads, 3);
      expect(topic.value, 'pages.settings');
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'MCP',
      );
      expect(
        find.text(
          catalogs['zh_TW']!
              .topic('pages.settings')
              .sections
              .first
              .paragraphs
              .first,
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          catalogs['ja']!
              .topic('pages.settings')
              .sections
              .first
              .paragraphs
              .first,
        ),
        findsNothing,
      );
      await tester.tap(find.byTooltip('上一頁'));
      await tester.pumpAndSettle();
      expect(topic.value, 'help.home');
      await tester.tap(find.byTooltip('下一頁'));
      await tester.pumpAndSettle();
      expect(topic.value, 'pages.settings');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  for (final locale in ['en', 'ja']) {
    testWidgets(
      'complete $locale help fits narrow screens at 200% text scale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final topic = ValueNotifier('pages.settings');
        final focus = FocusNode();
        addTearDown(topic.dispose);
        addTearDown(focus.dispose);
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            supportedLocales: supportedAppLocales,
            localizationsDelegates: AppLocalization.delegates,
            home: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(2)),
                child: Scaffold(
                  body: HelpViewer(
                    embedded: true,
                    topic: topic,
                    focusNode: focus,
                    loadCatalog: () async => catalogs[locale]!,
                    retryCatalog: () {},
                    onTopic: (id) => topic.value = id,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(catalogs[locale]!.topic('pages.settings').title),
          findsWidgets,
        );
        expect(tester.takeException(), isNull);
        await tester.drag(
          find.byType(SingleChildScrollView).last,
          const Offset(0, -600),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }
}
