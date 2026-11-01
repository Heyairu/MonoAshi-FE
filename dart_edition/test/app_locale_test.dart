import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/ui_library.dart';
import 'package:monogatari_assistant/l10n/app_localization.dart';
import 'package:monogatari_assistant/l10n/locale_resolution.dart';
import 'package:monogatari_assistant/l10n/quill_localizations_adapter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'English and Japanese contain every source message and no orphan keys',
    () {
      Map<String, dynamic> catalog(String locale) =>
          jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
              as Map<String, dynamic>;
      Set<String> keys(Map<String, dynamic> arb) =>
          arb.keys.where((key) => !key.startsWith('@')).toSet();
      final source = catalog('zh');
      for (final locale in ['en', 'ja']) {
        expect(keys(catalog(locale)), keys(source));
        for (final key in keys(source)) {
          expect(catalog(locale)[key], isNotEmpty, reason: '$locale:$key');
        }
      }
    },
  );

  test('legacy preferences normalize and invalid values follow the system', () {
    for (final value in ['zh_TW', 'zh-TW', 'zh-Hant', 'zh_Hant_TW', 'zh-CN']) {
      expect(
        AppLocalePreference.fromPreference(value),
        AppLocalePreference.traditionalChinese,
      );
    }
    expect(
      AppLocalePreference.fromPreference('en_US'),
      AppLocalePreference.english,
    );
    expect(
      AppLocalePreference.fromPreference('ja-JP'),
      AppLocalePreference.japanese,
    );
    for (final value in [null, 42, '', 'future-locale', 'system']) {
      expect(
        AppLocalePreference.fromPreference(value),
        AppLocalePreference.system,
      );
    }
    expect(AppLocalePreference.traditionalChinese.preferenceValue, 'zh-Hant');
    expect(AppLocalePreference.system.locale, isNull);
  });

  test('resolution checks every preferred locale before falling back', () {
    expect(
      resolveAppLocale([const Locale('fr', 'FR'), const Locale('ja', 'JP')]),
      const Locale('ja'),
    );
    expect(
      resolveAppLocale([const Locale('de'), const Locale('en', 'GB')]),
      const Locale('en'),
    );
    for (final chinese in [
      const Locale('zh'),
      const Locale('zh', 'TW'),
      const Locale('zh', 'HK'),
      const Locale('zh', 'MO'),
      const Locale('zh', 'CN'),
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    ]) {
      expect(resolveAppLocale([chinese]), defaultAppLocale);
    }
    for (final locales in [
      null,
      <Locale>[],
      [const Locale('fr')],
    ]) {
      expect(resolveAppLocale(locales), defaultAppLocale);
    }
    expect(
      resolveAppLocale([
        const Locale('ja'),
      ], preference: AppLocalePreference.english),
      const Locale('en'),
    );
  });

  test(
    'every product locale has a generated catalog with complete sample copy',
    () {
      expect(supportedAppLocales, hasLength(3));
      for (final locale in supportedAppLocales) {
        expect(AppLocalizations.supportedLocales, contains(locale));
        expect(lookupAppLocalizations(locale).languageTitle, isNotEmpty);
      }
      expect(lookupAppLocalizations(defaultAppLocale).languageTitle, '顯示語言');
      expect(
        lookupAppLocalizations(const Locale('en')).languageTitle,
        'Display language',
      );
      expect(lookupAppLocalizations(const Locale('ja')).languageTitle, '表示言語');
    },
  );

  test(
    'Quill maps the canonical Traditional locale to its TW catalog',
    () async {
      const delegate = AppQuillLocalizationsDelegate();
      expect((await delegate.load(defaultAppLocale)).copy, '複製');
      expect((await delegate.load(const Locale('en'))).copy, 'Copy');
      expect((await delegate.load(const Locale('ja'))).copy, 'コピー');
    },
  );

  test(
    'both theme modes follow the selected UI locale for their primary font',
    () {
      for (final (locale, family) in [
        (defaultAppLocale, 'NotoSansTC'),
        (const Locale('en'), 'NotoSans'),
        (const Locale('ja'), 'NotoSansJP'),
      ]) {
        expect(
          AppTheme.getLightTheme(
            14,
            Colors.blue,
            locale: locale,
          ).textTheme.bodyMedium!.fontFamily,
          family,
        );
        expect(
          AppTheme.getDarkTheme(
            14,
            Colors.blue,
            locale: locale,
          ).textTheme.bodyMedium!.fontFamily,
          family,
        );
      }
    },
  );
}
