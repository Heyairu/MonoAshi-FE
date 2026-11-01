import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Quill 11.6 uses countryCode, rather than scriptCode, for Traditional Chinese.
/// Keep the app's canonical locale and adapt only the dependency's lookup.
class AppQuillLocalizationsDelegate
    extends LocalizationsDelegate<FlutterQuillLocalizations> {
  const AppQuillLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      const ['zh', 'en', 'ja'].contains(locale.languageCode);

  @override
  Future<FlutterQuillLocalizations> load(Locale locale) =>
      FlutterQuillLocalizations.delegate.load(
        locale.languageCode == 'zh' ? const Locale('zh', 'TW') : locale,
      );

  @override
  bool shouldReload(AppQuillLocalizationsDelegate old) => false;
}
