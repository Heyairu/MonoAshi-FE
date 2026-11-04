import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

/// Loads the name table for the current display locale and selected culture.
class NameGeneratorData {
  NameGeneratorData({AssetBundle? bundle, Random? random})
    : _bundle = bundle ?? rootBundle,
      _random = random ?? Random();

  final AssetBundle _bundle;
  final Random _random;
  final Map<String, Map<String, dynamic>> _cache = {};
  static const _anglosphere = {'UK', 'US', 'CA', 'AU'};

  Future<List<String>> generate({
    required String culture,
    required String gender,
    required String locale,
    required int count,
  }) async {
    final isAnglo = _anglosphere.contains(culture);
    if (!isAnglo && !{'ZH', 'JP', 'KR'}.contains(culture)) {
      throw const FormatException('Unknown name culture');
    }
    final displayLocale = locale == 'ja' || locale == 'en' ? locale : 'zh';
    final suffix = isAnglo
        ? (displayLocale == 'zh' ? 'zh_TW' : displayLocale)
        : (displayLocale == 'zh' ? 'en' : displayLocale);
    final family = isAnglo ? 'Anglosphere' : 'eastAsia';
    final asset = 'assets/jsons/name_${family}_$suffix.json';
    final data = await _load(asset);
    final country = data[culture];
    if (country is! Map<String, dynamic>) {
      throw const FormatException('Missing name culture');
    }
    final surnames = isAnglo
        ? _angloSurnames(country)
        : _eastAsiaSurnames(country, culture, displayLocale);
    final names = isAnglo
        ? _angloNames(country, gender)
        : _eastAsiaNames(country, gender, culture, displayLocale);
    if (surnames.isEmpty || names.isEmpty) {
      throw const FormatException('Empty name pool');
    }
    return List.generate(count, (_) {
      final surname = surnames[_random.nextInt(surnames.length)];
      final given = names[_random.nextInt(names.length)];
      final useWesternOrder = isAnglo;
      final separator = isAnglo || displayLocale == 'en' ? ' ' : '';
      final value = useWesternOrder
          ? '${given.value}$separator${surname.value}'
          : '${surname.value}$separator${given.value}';
      if (!surname.annotate && !given.annotate) return value;
      final original = useWesternOrder
          ? '${given.original} ${surname.original}'
          : '${surname.original}${given.original}';
      return '$value（$original）';
    });
  }

  Future<Map<String, dynamic>> _load(String path) async {
    final cached = _cache[path];
    if (cached != null) return cached;
    final decoded = jsonDecode(await _bundle.loadString(path));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid name data');
    }
    return _cache[path] = decoded;
  }

  List<String> _genderKeys(String gender) => switch (gender) {
    'male' => ['Name_Man'],
    'female' => ['Name_Lady'],
    'neutral' => ['Name_Neutral'],
    'all' => ['Name_Man', 'Name_Lady', 'Name_Neutral'],
    _ => throw const FormatException('Unknown gender'),
  };

  _NamePart _angloPart(String value) {
    final match = RegExp(r'^(.*?)（([^（）]+)）$').firstMatch(value);
    return match == null
        ? _NamePart(value, value, false)
        : _NamePart(match[1]!, match[2]!, true);
  }

  List<_NamePart> _angloSurnames(Map<String, dynamic> country) {
    final raw = country['Surname'];
    if (raw is! List) return [];
    return raw.whereType<String>().map(_angloPart).toList();
  }

  List<_NamePart> _angloNames(Map<String, dynamic> country, String gender) {
    final result = <String>{};
    for (final key in _genderKeys(gender)) {
      final groups = country[key];
      if (groups is! List || groups.isEmpty || groups.first is! Map) continue;
      for (final group in (groups.first as Map).values) {
        if (group is List && group.isNotEmpty && group.first is Map) {
          result.addAll((group.first as Map).keys.whereType<String>());
        }
      }
    }
    return result.map(_angloPart).toList();
  }

  _NamePart? _eastAsiaPart(dynamic raw, String culture, String locale) {
    if (raw is! Map ||
        raw['original'] is! String ||
        raw['source'] is! String ||
        raw['value'] is! String) {
      return null;
    }
    final original = raw['original'] as String;
    final value = locale == 'zh'
        ? raw['source'] as String
        : raw['value'] as String;
    return _NamePart(
      value,
      original,
      locale == 'en' || (locale == 'ja' ? culture != 'JP' : culture != 'ZH'),
    );
  }

  List<_NamePart> _eastAsiaSurnames(
    Map<String, dynamic> country,
    String culture,
    String locale,
  ) {
    final raw = country['Surname'];
    if (raw is! List) return [];
    return raw
        .map((item) => _eastAsiaPart(item, culture, locale))
        .whereType<_NamePart>()
        .toList();
  }

  List<_NamePart> _eastAsiaNames(
    Map<String, dynamic> country,
    String gender,
    String culture,
    String locale,
  ) {
    final result = <String, _NamePart>{};
    for (final key in _genderKeys(gender)) {
      final groups = country[key];
      if (groups is! Map) continue;
      for (final group in groups.values) {
        if (group is! List) continue;
        for (final item in group) {
          final part = _eastAsiaPart(item, culture, locale);
          if (part != null) {
            result['${part.value}\u0000${part.original}'] = part;
          }
        }
      }
    }
    return result.values.toList();
  }
}

class _NamePart {
  const _NamePart(this.value, this.original, this.annotate);
  final String value;
  final String original;
  final bool annotate;
}
