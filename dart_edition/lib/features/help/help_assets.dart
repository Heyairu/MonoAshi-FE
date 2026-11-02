import 'dart:convert';

/// Bump with structural/content changes to invalidate open viewers' caches.
abstract final class HelpAssets {
  static const contentVersion = 2;
  static const manifestPath = 'assets/help/manifest.json';

  static String localeFor(String tag) =>
      switch (tag.trim().replaceAll('_', '-').toLowerCase().split('-').first) {
        'en' => 'en',
        'ja' => 'ja',
        _ => 'zh_TW',
      };

  static String cacheKey(String tag) => '$contentVersion:${localeFor(tag)}';
}

final class HelpAssetManifest {
  HelpAssetManifest._(this.version, this.locales, this.topicIds);

  final int version;
  final Map<String, String> locales;
  final Set<String> topicIds;

  factory HelpAssetManifest.parse(String source) {
    final data = jsonDecode(source);
    if (data is! Map<String, dynamic> ||
        data['contentVersion'] != HelpAssets.contentVersion ||
        data['defaultLocale'] != 'zh_TW') {
      throw const FormatException('Unsupported offline help manifest');
    }
    final rawLocales = data['locales'];
    final rawTopics = data['topicIds'];
    if (rawLocales is! Map<String, dynamic> ||
        rawTopics is! List ||
        !rawTopics.every((id) => id is String && id.isNotEmpty) ||
        rawTopics.isEmpty ||
        rawTopics.toSet().length != rawTopics.length) {
      throw const FormatException('Invalid offline help manifest');
    }
    final locales = <String, String>{};
    for (final locale in ['zh_TW', 'en', 'ja']) {
      final path = rawLocales[locale];
      if (path != 'assets/help/$locale.json') {
        throw FormatException('Missing or invalid help asset: $locale');
      }
      locales[locale] = path as String;
    }
    return HelpAssetManifest._(
      HelpAssets.contentVersion,
      Map.unmodifiable(locales),
      Set.unmodifiable(rawTopics.cast<String>()),
    );
  }
}

/// IME full-width ASCII should find the same shortcuts and technical terms.
/// Japanese words remain intact; queries do not require whitespace tokenizing.
String normalizeHelpSearch(String text) => String.fromCharCodes(
  text.runes.map(
    (code) => switch (code) {
      0x3000 => 0x20,
      >= 0xff01 && <= 0xff5e => code - 0xfee0,
      _ => code,
    },
  ),
).toLowerCase();
