import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart' as bundled_dates;
import 'package:intl/intl.dart';

/// Offline presentation formatting. Never use these strings for persistence,
/// protocol fields, IDs, editable numeric input, or filename timestamps.
final class AppFormatters {
  AppFormatters(Locale locale) : localeName = _localeName(locale);

  factory AppFormatters.forLanguageTag(String tag) {
    final language = tag
        .trim()
        .replaceAll('_', '-')
        .split('-')
        .first
        .toLowerCase();
    return AppFormatters(Locale(language));
  }

  static String _localeName(Locale locale) =>
      switch (locale.languageCode.toLowerCase()) {
        'en' => 'en',
        'ja' => 'ja',
        _ => 'zh_TW',
      };

  final String localeName;
  static bool _dateSymbolsInitialized = false;

  /// Intl's bundled data registers synchronously and returns a completed
  /// Future. Startup awaits it; standalone component hosts can also format
  /// safely before app bootstrap, without a network request.
  static Future<void> initialize() {
    // Cache registration, not a Future bound to the first caller's Zone.
    // A fresh Future also works after a widget host/test session is disposed.
    if (_dateSymbolsInitialized) return Future<void>.value();
    final initialized = bundled_dates.initializeDateFormatting();
    _dateSymbolsInitialized = true;
    return initialized;
  }

  String integer(int value, {bool grouping = true}) =>
      decimal(value, maximumFractionDigits: 0, grouping: grouping);

  String decimal(
    num value, {
    int minimumFractionDigits = 0,
    int maximumFractionDigits = 1,
    bool grouping = true,
  }) {
    assert(minimumFractionDigits >= 0);
    assert(maximumFractionDigits >= minimumFractionDigits);
    final format = NumberFormat.decimalPattern(localeName)
      ..minimumFractionDigits = minimumFractionDigits
      ..maximumFractionDigits = maximumFractionDigits;
    if (!grouping) format.turnOffGrouping();
    return format.format(value);
  }

  /// [fraction] is a ratio (0.125 means 12.5%), not an already scaled percent.
  String percent(num fraction, {int fractionDigits = 1}) {
    assert(fractionDigits >= 0);
    final format = NumberFormat.decimalPercentPattern(
      locale: localeName,
      decimalDigits: fractionDigits,
    );
    return format.format(fraction);
  }

  /// Preserve the app's existing binary conversion and KB/MB display labels.
  /// The raw byte count stays an integer in project and transport data.
  String bytes(int count, {int fractionDigits = 1}) {
    assert(count >= 0);
    const units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    var size = count.toDouble();
    var unit = 0;
    while (size >= 1024 && unit < units.length - 1) {
      size /= 1024;
      unit++;
    }
    final number = unit == 0
        ? integer(count)
        : decimal(
            size,
            minimumFractionDigits: fractionDigits,
            maximumFractionDigits: fractionDigits,
          );
    return '$number ${units[unit]}';
  }

  DateFormat _dateFormat({bool withTime = false, bool seconds = false}) {
    unawaited(initialize());
    final format = DateFormat.yMd(localeName);
    if (withTime) seconds ? format.add_Hms() : format.add_Hm();
    return format;
  }

  /// Display in the device's local timezone; language never changes timezone.
  String date(DateTime value) => _dateFormat().format(value.toLocal());

  String dateTime(DateTime value, {bool seconds = true}) =>
      _dateFormat(withTime: true, seconds: seconds).format(value.toLocal());

  /// Use the existing explicit 24-hour policy for status timestamps.
  String time(DateTime value, {bool seconds = false}) {
    unawaited(initialize());
    return (seconds ? DateFormat.Hms(localeName) : DateFormat.Hm(localeName))
        .format(value.toLocal());
  }
}
