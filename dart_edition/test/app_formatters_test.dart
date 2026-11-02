import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:monogatari_assistant/l10n/app_localization.dart';

void main() {
  setUpAll(AppFormatters.initialize);

  for (final tag in ['zh-Hant', 'zh_TW', 'en-US', 'ja_JP']) {
    final format = AppFormatters.forLanguageTag(tag);
    test('$tag formats numbers, ratios and binary sizes explicitly', () {
      expect(format.integer(1234567), '1,234,567');
      expect(format.integer(-1234), '-1,234');
      expect(format.integer(1234, grouping: false), '1234');
      expect(format.decimal(1234.567), '1,234.6');
      expect(
        format.decimal(12, minimumFractionDigits: 2, maximumFractionDigits: 2),
        '12.00',
      );
      expect(format.decimal(1234.5, grouping: false), '1234.5');
      expect(format.percent(0.125), '12.5%');
      expect(format.percent(0, fractionDigits: 0), '0%');
      expect(format.percent(1, fractionDigits: 0), '100%');
      expect(format.bytes(0), '0 B');
      expect(format.bytes(1023), '1,023 B');
      expect(format.bytes(1024), '1.0 KB');
      expect(format.bytes(1024 * 1024), '1.0 MB');
      expect(format.bytes(1536, fractionDigits: 2), '1.50 KB');
    });

    test('$tag dates follow language and local timezone with 24-hour time', () {
      final value = DateTime(2026, 11, 2, 13, 4, 5);
      final date = tag.startsWith('en') ? '11/2/2026' : '2026/11/2';
      expect(format.date(value), date);
      expect(format.dateTime(value), '$date 13:04:05');
      expect(format.dateTime(value, seconds: false), '$date 13:04');
      expect(format.time(value), '13:04');
      expect(format.time(value, seconds: true), '13:04:05');
      expect(format.dateTime(value.toUtc()), format.dateTime(value));
    });
  }

  test('formatters remain independent when the global locale changes', () {
    final before = Intl.defaultLocale;
    addTearDown(() => Intl.defaultLocale = before);
    Intl.defaultLocale = 'fr';
    final format = AppFormatters.forLanguageTag('en');
    final timestamp = DateTime.utc(2026, 11, 2, 13, 4, 5);
    expect(format.integer(1234), '1,234');
    expect(format.percent(.125), '12.5%');
    format.dateTime(timestamp);
    expect(Intl.defaultLocale, 'fr');
    expect(AppFormatters.forLanguageTag('unsupported').localeName, 'zh_TW');
  });

  testWidgets(
    'live locale changes update dates and retain editable raw input',
    (tester) async {
      final locale = ValueNotifier(const Locale('en'));
      final controller = TextEditingController(text: '1234');
      addTearDown(locale.dispose);
      addTearDown(controller.dispose);
      controller.selection = const TextSelection.collapsed(offset: 2);
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, value, child) => MaterialApp(
            locale: value,
            supportedLocales: supportedAppLocales,
            localizationsDelegates: AppLocalization.delegates,
            home: Builder(
              builder: (context) => Scaffold(
                body: Column(
                  children: [
                    Text(
                      context.formats.dateTime(DateTime(2026, 11, 2, 13, 4)),
                    ),
                    TextField(controller: controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('11/2/2026 13:04:00'), findsOneWidget);
      locale.value = const Locale('ja');
      await tester.pumpAndSettle();
      expect(find.text('2026/11/2 13:04:00'), findsOneWidget);
      expect(controller.text, '1234');
      expect(controller.selection.baseOffset, 2);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
