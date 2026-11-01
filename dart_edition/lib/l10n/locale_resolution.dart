import 'package:flutter/widgets.dart';

import 'app_locale.dart';

/// Use the whole ordered preference list. All Chinese variants currently use
/// the Traditional Chinese edition; this does not claim Simplified support.
Locale resolveAppLocale(
  Iterable<Locale>? preferredLocales, {
  AppLocalePreference preference = AppLocalePreference.system,
}) {
  if (preference.locale case final locale?) return locale;
  for (final locale in preferredLocales ?? const <Locale>[]) {
    switch (locale.languageCode.toLowerCase()) {
      case 'zh':
        return defaultAppLocale;
      case 'en':
        return const Locale('en');
      case 'ja':
        return const Locale('ja');
    }
  }
  return defaultAppLocale;
}
