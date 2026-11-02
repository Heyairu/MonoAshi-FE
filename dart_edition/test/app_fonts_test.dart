import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/ui_library.dart';
import 'package:monogatari_assistant/l10n/app_localization.dart';

// Read the real sfnt/cmap tables, so missing font files and missing sample
// glyphs are caught even though Flutter widget tests use the Ahem font.
class _Font {
  _Font(String path) : bytes = File(path).readAsBytesSync() {
    data = ByteData.sublistView(bytes);
    expect(data.getUint32(0), 0x00010000, reason: path);
    for (var i = 0; i < data.getUint16(4); i++) {
      final record = 12 + i * 16;
      tables[String.fromCharCodes(bytes.sublist(record, record + 4))] = data
          .getUint32(record + 8);
    }
    expect(tables.keys, containsAll(['cmap', 'fvar', 'glyf']));
  }
  final Uint8List bytes;
  late final ByteData data;
  final tables = <String, int>{};

  bool contains(int code) {
    final base = tables['cmap']!;
    for (var i = 0; i < data.getUint16(base + 2); i++) {
      final record = base + 4 + i * 8;
      final platform = data.getUint16(record);
      if (platform != 0 && platform != 3) continue;
      final subtable = base + data.getUint32(record + 4);
      if (data.getUint16(subtable) != 12) continue;
      final groups = data.getUint32(subtable + 12);
      for (var j = 0; j < groups; j++) {
        final group = subtable + 16 + j * 12;
        final start = data.getUint32(group);
        final end = data.getUint32(group + 4);
        if (code >= start && code <= end) {
          return data.getUint32(group + 8) + code - start != 0;
        }
      }
    }
    return false;
  }

  (double, double) get weightRange {
    final base = tables['fvar']!;
    final axes = base + data.getUint16(base + 4);
    for (var i = 0; i < data.getUint16(base + 8); i++) {
      final axis = axes + i * data.getUint16(base + 10);
      if (String.fromCharCodes(bytes.sublist(axis, axis + 4)) == 'wght') {
        return (
          data.getInt32(axis + 4) / 65536,
          data.getInt32(axis + 12) / 65536,
        );
      }
    }
    throw StateError('Missing variable weight axis');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'light and dark themes order bundled fallbacks by interface language',
    () {
      for (final (locale, family) in [
        (defaultAppLocale, 'NotoSansTC'),
        (const Locale('en'), 'NotoSans'),
        (const Locale('ja'), 'NotoSansJP'),
      ]) {
        expect(AppFonts.primary(locale), family);
        final fallback = AppFonts.fallbacks(locale);
        expect(fallback, isNot(contains(family)));
        expect(fallback.toSet(), hasLength(fallback.length));
        expect([
          family,
          ...fallback,
        ], containsAll(['NotoSans', 'NotoSansTC', 'NotoSansJP']));
        expect(
          fallback.first,
          family == 'NotoSans' ? 'NotoSansTC' : 'NotoSans',
        );
        for (final theme in [
          AppTheme.getLightTheme(14, Colors.blue, locale: locale),
          AppTheme.getDarkTheme(14, Colors.blue, locale: locale),
        ]) {
          for (final style in [
            theme.textTheme.bodyMedium!,
            theme.textTheme.titleLarge!,
            theme.textTheme.labelSmall!,
          ]) {
            expect(style.fontFamily, family);
            expect(style.fontFamilyFallback, fallback);
          }
        }
      }
      expect(AppFonts.primary(const Locale('zh', 'HK')), 'NotoSansHK');
      expect(AppFonts.primary(const Locale('zh', 'CN')), 'NotoSansSC');
      expect(AppFonts.primary(const Locale('ko')), 'NotoSansKR');
      expect(AppFonts.primary(const Locale('th')), 'NotoSansThai');
    },
  );

  test(
    'real bundled faces cover Latin, Traditional Chinese and Japanese glyphs and weights',
    () {
      for (final (family, sample) in [
        ('NotoSans', 'English café Ångström 0123456789'),
        ('NotoSansTC', '繁體中文臺灣骨直'),
        ('NotoSansJP', '日本語かなカナ骨直'),
        ('NotoSans-Italic', 'English café'),
      ]) {
        final font = _Font('assets/fonts/$family-Variable.ttf');
        for (final code in sample.runes) {
          expect(
            font.contains(code),
            isTrue,
            reason: '$family: ${String.fromCharCode(code)}',
          );
        }
        final (min, max) = font.weightRange;
        expect(min, lessThanOrEqualTo(100));
        expect(max, greaterThanOrEqualTo(900));
      }
    },
  );

  testWidgets(
    'the offline asset bundle registers every fallback and italic face',
    (tester) async {
      final source = await tester.runAsync(
        () => rootBundle.loadString('FontManifest.json'),
      );
      final manifest = (jsonDecode(source!) as List)
          .cast<Map<String, dynamic>>();
      for (final family in {
        for (final locale in supportedAppLocales) ...[
          AppFonts.primary(locale),
          ...AppFonts.fallbacks(locale),
        ],
      }) {
        final entry = manifest.singleWhere((e) => e['family'] == family);
        for (final font in entry['fonts'] as List) {
          expect(File(font['asset'] as String).existsSync(), isTrue);
        }
      }
      expect(
        (manifest.singleWhere((e) => e['family'] == 'NotoSans')['fonts']
                as List)
            .any((font) => font['style'] == 'italic'),
        isTrue,
      );
    },
  );
}
