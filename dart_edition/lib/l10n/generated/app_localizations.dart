import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    Locale('en'),
    Locale('ja'),
    Locale('zh'),
  ];

  /// Application title; keep product branding.
  ///
  /// In zh, this message translates to:
  /// **'物語 Assistant'**
  String get appTitle;

  /// Settings page heading.
  ///
  /// In zh, this message translates to:
  /// **'設定'**
  String get settingsTitle;

  /// Settings introduction.
  ///
  /// In zh, this message translates to:
  /// **'調整適合自己的寫作環境'**
  String get settingsDescription;

  /// General settings section heading.
  ///
  /// In zh, this message translates to:
  /// **'一般設定'**
  String get generalSettingsTitle;

  /// General settings section summary.
  ///
  /// In zh, this message translates to:
  /// **'退出提示與語言'**
  String get generalSettingsDescription;

  /// Exit confirmation setting.
  ///
  /// In zh, this message translates to:
  /// **'退出時提示'**
  String get exitWarningTitle;

  /// Exit warning explanation.
  ///
  /// In zh, this message translates to:
  /// **'關閉應用前提示儲存未儲存的變更'**
  String get exitWarningDescription;

  /// UI language selector title.
  ///
  /// In zh, this message translates to:
  /// **'顯示語言'**
  String get languageTitle;

  /// UI language preference that follows the ordered system language list.
  ///
  /// In zh, this message translates to:
  /// **'跟隨系統'**
  String get languageSystem;

  /// Explain immediate persistence and current translation coverage; this foundation does not imply all modules are translated.
  ///
  /// In zh, this message translates to:
  /// **'立即套用並自動儲存。部分功能仍顯示繁體中文。'**
  String get languageHelp;

  /// Preference write failed and rolled back; never expose a raw exception here.
  ///
  /// In zh, this message translates to:
  /// **'無法儲存語言設定，已恢復原選擇。請再試一次。'**
  String get languageSaveFailed;

  /// Startup failure; error is a technical diagnostic kept verbatim.
  ///
  /// In zh, this message translates to:
  /// **'初始化失敗：{error}'**
  String initializationFailed(String error);

  /// First setup step label.
  ///
  /// In zh, this message translates to:
  /// **'歡迎'**
  String get oobeStepWelcome;

  /// Setup step label.
  ///
  /// In zh, this message translates to:
  /// **'介面偏好'**
  String get oobeStepAppearance;

  /// Setup step label.
  ///
  /// In zh, this message translates to:
  /// **'儲存與備份'**
  String get oobeStepStorage;

  /// Setup step label.
  ///
  /// In zh, this message translates to:
  /// **'名稱設定'**
  String get oobeStepName;

  /// Setup step label.
  ///
  /// In zh, this message translates to:
  /// **'開始使用'**
  String get oobeStepWorkspace;

  /// Final setup step label.
  ///
  /// In zh, this message translates to:
  /// **'完成！'**
  String get oobeStepComplete;

  /// Welcome setup heading; MonoAshi is a product name.
  ///
  /// In zh, this message translates to:
  /// **'ヤッホー！歡迎使用 MonoAshi'**
  String get oobeTitleWelcome;

  /// Setup page heading.
  ///
  /// In zh, this message translates to:
  /// **'主題與操作偏好'**
  String get oobeTitleAppearance;

  /// Setup page heading.
  ///
  /// In zh, this message translates to:
  /// **'檔案與自動備份'**
  String get oobeTitleStorage;

  /// Setup page heading.
  ///
  /// In zh, this message translates to:
  /// **'名稱設定'**
  String get oobeTitleName;

  /// Setup page heading.
  ///
  /// In zh, this message translates to:
  /// **'從第一個故事開始'**
  String get oobeTitleWorkspace;

  /// Final setup heading.
  ///
  /// In zh, this message translates to:
  /// **'謝謝您！'**
  String get oobeTitleComplete;

  /// First welcome paragraph.
  ///
  /// In zh, this message translates to:
  /// **'感謝您選擇 MonoAshi。'**
  String get oobeWelcomeThanks;

  /// Welcome introduction.
  ///
  /// In zh, this message translates to:
  /// **'我們需要數分鐘時間設定您的程式。'**
  String get oobeWelcomeTime;

  /// Welcome explanation; allow wrapping.
  ///
  /// In zh, this message translates to:
  /// **'接下來的幾個步驟，將協助您調整介面、選擇儲存偏好，並認識創作工作區。'**
  String get oobeWelcomeDescription;

  /// Next setup button; keep directional decoration separate from meaning.
  ///
  /// In zh, this message translates to:
  /// **'下一步  ›'**
  String get oobeNext;

  /// Previous setup step button.
  ///
  /// In zh, this message translates to:
  /// **'上一步'**
  String get oobeBack;

  /// Skip name step button.
  ///
  /// In zh, this message translates to:
  /// **'略過'**
  String get oobeSkip;

  /// Finish setup and open workspace button.
  ///
  /// In zh, this message translates to:
  /// **'開始創作'**
  String get oobeStart;

  /// Setup footer instruction.
  ///
  /// In zh, this message translates to:
  /// **'如果要繼續，請按「下一步」。'**
  String get oobeContinueHint;

  /// Final setup footer instruction.
  ///
  /// In zh, this message translates to:
  /// **'設定完成！'**
  String get oobeCompleteHint;

  /// Setup completion save error.
  ///
  /// In zh, this message translates to:
  /// **'設定尚未儲存完成。請再試一次。'**
  String get oobeSaveFailed;

  /// Accessible setup step label.
  ///
  /// In zh, this message translates to:
  /// **'步驟 {step}，{title}'**
  String oobeProgressSemantics(int step, String title);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
