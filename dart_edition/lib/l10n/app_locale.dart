import 'package:flutter/widgets.dart';

/// Device-local UI preference. These stable values never enter project data.
enum AppLocalePreference {
  system('system'),
  traditionalChinese('zh-Hant'),
  english('en'),
  japanese('ja');

  const AppLocalePreference(this.preferenceValue);
  final String preferenceValue;

  Locale? get locale => switch (this) {
    system => null,
    traditionalChinese => defaultAppLocale,
    english => const Locale('en'),
    japanese => const Locale('ja'),
  };

  /// Accept legacy region/underscore spellings, but store canonical values.
  static AppLocalePreference fromPreference(Object? value) {
    if (value is! String) return system;
    final language = value.trim().replaceAll('_', '-').toLowerCase();
    return switch (language.split('-').first) {
      'zh' => traditionalChinese,
      'en' => english,
      'ja' => japanese,
      _ => system,
    };
  }
}

const defaultAppLocale = Locale.fromSubtags(
  languageCode: 'zh',
  scriptCode: 'Hant',
);

/// Product locales, excluding the generator's internal language-only zh alias.
const supportedAppLocales = <Locale>[
  defaultAppLocale,
  Locale('en'),
  Locale('ja'),
];
