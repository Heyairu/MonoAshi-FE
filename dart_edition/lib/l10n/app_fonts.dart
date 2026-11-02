import 'package:flutter/widgets.dart';

/// Every named face is bundled in pubspec.yaml, so UI text works offline.
/// Manuscript-specific styles remain separate from the interface preference.
abstract final class AppFonts {
  static String primary(Locale locale) {
    final language = locale.languageCode.toLowerCase();
    final country = locale.countryCode?.toUpperCase();
    if (language == 'zh') {
      if (locale.scriptCode == 'Hant') return 'NotoSansTC';
      if (country == 'HK') return 'NotoSansHK';
      if (country == 'TW' || country == 'MO') return 'NotoSansTC';
      return 'NotoSansSC';
    }
    return switch (language) {
      'ja' => 'NotoSansJP',
      'ko' => 'NotoSansKR',
      'th' => 'NotoSansThai',
      _ => 'NotoSans',
    };
  }

  /// Keep the current CJK edition ahead of other CJK variants. Latin is the
  /// first fallback for CJK interfaces; English uses Traditional Chinese as
  /// its default CJK fallback when the content has no language metadata.
  static List<String> fallbacks(Locale locale) => List.unmodifiable(
    {
      'NotoSans',
      primary(locale),
      'NotoSansTC',
      'NotoSansJP',
      'NotoSansHK',
      'NotoSansSC',
      'NotoSansKR',
      'NotoSansThai',
    }..remove(primary(locale)),
  );
}
