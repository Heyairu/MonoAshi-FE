import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_locale.dart';
import 'generated/app_localizations.dart';
import 'locale_resolution.dart';
import 'quill_localizations_adapter.dart';

export 'app_locale.dart';
export 'generated/app_localizations.dart';

/// Shared by startup, failure and workspace MaterialApp configurations.
abstract final class AppLocalization {
  static const delegates = <LocalizationsDelegate<dynamic>>[
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    AppQuillLocalizationsDelegate(),
  ];

  static Locale resolve(
    List<Locale>? locales,
    Iterable<Locale> supportedLocales,
  ) => resolveAppLocale(locales);
}

extension LocalizedContext on BuildContext {
  /// Standalone component hosts keep the historical Traditional Chinese
  /// default. Production roots always install AppLocalization.delegates.
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ??
      lookupAppLocalizations(defaultAppLocale);
}
