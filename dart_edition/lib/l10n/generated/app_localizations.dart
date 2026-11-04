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
  /// **'切換後立即套用並自動保存；專案內容不受介面語言影響。'**
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

  /// Application display copy. Source: lib/bin/appbar.dart:194
  ///
  /// In zh, this message translates to:
  /// **'儲存檔案'**
  String get uiSaveFile;

  /// Application display copy. Source: lib/bin/appbar.dart:198
  ///
  /// In zh, this message translates to:
  /// **'新建檔案'**
  String get uiNewFile;

  /// Application display copy. Source: lib/bin/appbar.dart:199
  ///
  /// In zh, this message translates to:
  /// **'開啟檔案'**
  String get uiOpenFile;

  /// Application display copy. Source: lib/bin/appbar.dart:200
  ///
  /// In zh, this message translates to:
  /// **'另存新檔'**
  String get uiSaveAs;

  /// Application display copy. Source: lib/bin/appbar.dart:201, lib/features/phrases/phrase_library_dialog.dart:411
  ///
  /// In zh, this message translates to:
  /// **'匯入'**
  String get uiImport;

  /// Application display copy. Source: lib/bin/appbar.dart:202, lib/features/phrases/phrase_library_dialog.dart:418, lib/presentation/widgets/project_export/export_dialog.dart:150
  ///
  /// In zh, this message translates to:
  /// **'匯出'**
  String get uiExport;

  /// Application display copy. Source: lib/bin/appbar.dart:203, lib/bin/content.dart:2034, lib/features/editor/plain_text_quill_editor_poc.dart:1298
  ///
  /// In zh, this message translates to:
  /// **'全選'**
  String get editorSelectAll;

  /// Application display copy. Source: lib/bin/appbar.dart:204, lib/bin/content.dart:2010, lib/features/editor/plain_text_quill_editor_poc.dart:1303
  ///
  /// In zh, this message translates to:
  /// **'剪下'**
  String get editorCut;

  /// Application display copy. Source: lib/bin/appbar.dart:205, lib/bin/content.dart:2018, lib/features/editor/plain_text_quill_editor_poc.dart:1308
  ///
  /// In zh, this message translates to:
  /// **'複製'**
  String get commonCopy;

  /// Application display copy. Source: lib/bin/appbar.dart:208, lib/bin/content.dart:2026, lib/features/editor/plain_text_quill_editor_poc.dart:1313
  ///
  /// In zh, this message translates to:
  /// **'貼上'**
  String get editorPaste;

  /// Application display copy. Source: lib/bin/appbar.dart:212, lib/features/editor/plain_text_quill_editor_poc.dart:1288, lib/modules/palettesview.dart:237
  ///
  /// In zh, this message translates to:
  /// **'復原'**
  String get editorUndo;

  /// Application display copy. Source: lib/bin/appbar.dart:213, lib/features/editor/plain_text_quill_editor_poc.dart:1293
  ///
  /// In zh, this message translates to:
  /// **'重做'**
  String get editorRedo;

  /// Application display copy. Source: lib/bin/appbar.dart:216, lib/bin/content.dart:1155, lib/features/phrases/phrase_library_dialog.dart:397
  ///
  /// In zh, this message translates to:
  /// **'短語庫'**
  String get uiPhraseLibrary;

  /// Application display copy. Source: lib/bin/appbar.dart:223, lib/bin/content.dart:1117, lib/bin/content.dart:1161
  ///
  /// In zh, this message translates to:
  /// **'插入短語'**
  String get uiInsertPhrase;

  /// Application display copy. Source: lib/bin/appbar.dart:226, lib/bin/appbar.dart:234
  ///
  /// In zh, this message translates to:
  /// **'請先開啟正文編輯頁。'**
  String get uiOpenTheManuscriptEditorFirst;

  /// Application display copy. Source: lib/bin/appbar.dart:230
  ///
  /// In zh, this message translates to:
  /// **'選取內容存為短語'**
  String get uiSaveSelectionAsPhrase;

  /// Application display copy. Source: lib/bin/appbar.dart:239
  ///
  /// In zh, this message translates to:
  /// **'標點符號'**
  String get uiPunctuation;

  /// Application display copy. Source: lib/bin/appbar.dart:245, lib/bin/appbar.dart:428
  ///
  /// In zh, this message translates to:
  /// **'搜尋'**
  String get uiSearch;

  /// Application display copy. Source: lib/bin/appbar.dart:251
  ///
  /// In zh, this message translates to:
  /// **'導覽列'**
  String get uiNavigation;

  /// Application display copy. Source: lib/bin/appbar.dart:258
  ///
  /// In zh, this message translates to:
  /// **'側邊欄'**
  String get uiSidebar;

  /// Application display copy. Source: lib/bin/appbar.dart:265
  ///
  /// In zh, this message translates to:
  /// **'儀表板'**
  String get uiDashboard;

  /// Application display copy. Source: lib/bin/appbar.dart:273, lib/bin/findreplace.dart:3243, lib/bin/findreplace.dart:3244
  ///
  /// In zh, this message translates to:
  /// **'大小寫需相同'**
  String get uiMatchCase;

  /// Application display copy. Source: lib/bin/appbar.dart:274, lib/bin/findreplace.dart:3255, lib/bin/findreplace.dart:3256
  ///
  /// In zh, this message translates to:
  /// **'全字拼寫相符'**
  String get uiWholeWords;

  /// Application display copy. Source: lib/bin/appbar.dart:275, lib/bin/findreplace.dart:3267, lib/bin/findreplace.dart:3268
  ///
  /// In zh, this message translates to:
  /// **'使用正則表示'**
  String get uiRegularExpression;

  /// Application display copy. Source: lib/bin/appbar.dart:276, lib/bin/findreplace.dart:3283, lib/bin/findreplace.dart:3284
  ///
  /// In zh, this message translates to:
  /// **'全半形須相符'**
  String get uiMatchCharacterWidth;

  /// Application display copy. Source: lib/bin/appbar.dart:277, lib/bin/findreplace.dart:3295, lib/bin/findreplace.dart:3296
  ///
  /// In zh, this message translates to:
  /// **'略過標點符號'**
  String get uiIgnorePunctuation;

  /// Application display copy. Source: lib/bin/appbar.dart:278, lib/bin/findreplace.dart:3306, lib/bin/findreplace.dart:3307
  ///
  /// In zh, this message translates to:
  /// **'略過空白字元'**
  String get uiIgnoreWhitespace;

  /// Application display copy. Source: lib/bin/appbar.dart:291
  ///
  /// In zh, this message translates to:
  /// **'正則表示模式固定大小寫與全半形相符，並停用全字拼寫。'**
  String get uiRegularExpressionsAlwaysMatchCaseAndCharacterWidth;

  /// Application display copy. Source: lib/bin/appbar.dart:292
  ///
  /// In zh, this message translates to:
  /// **'搜尋文字含全形字元、標點或空白，無法使用全字拼寫。'**
  String get uiWholeWordMatchingIsUnavailableWhenTheQuery;

  /// Application display copy. Source: lib/bin/appbar.dart:345
  ///
  /// In zh, this message translates to:
  /// **'無法完成「{p1}」，請重試。'**
  String uiCouldNotCompletePleaseTryAgain(String p1);

  /// Application display copy. Source: lib/bin/appbar.dart:356
  ///
  /// In zh, this message translates to:
  /// **'檔案'**
  String get uiFile;

  /// Application display copy. Source: lib/bin/appbar.dart:361
  ///
  /// In zh, this message translates to:
  /// **'專案'**
  String get uiProject;

  /// Application display copy. Source: lib/bin/appbar.dart:373
  ///
  /// In zh, this message translates to:
  /// **'資料交換'**
  String get uiDataExchange;

  /// Application display copy. Source: lib/bin/appbar.dart:383
  ///
  /// In zh, this message translates to:
  /// **'常用'**
  String get uiHome;

  /// Application display copy. Source: lib/bin/appbar.dart:388
  ///
  /// In zh, this message translates to:
  /// **'剪貼簿'**
  String get uiClipboard;

  /// Application display copy. Source: lib/bin/appbar.dart:397
  ///
  /// In zh, this message translates to:
  /// **'歷史'**
  String get uiHistory;

  /// Application display copy. Source: lib/bin/appbar.dart:402
  ///
  /// In zh, this message translates to:
  /// **'寫作工具'**
  String get uiWritingTools;

  /// Application display copy. Source: lib/bin/appbar.dart:407, lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:367, lib/features/poppin/mosaic_intellisense.dart:345
  ///
  /// In zh, this message translates to:
  /// **'短語'**
  String get uiPhrases;

  /// Application display copy. Source: lib/bin/appbar.dart:416
  ///
  /// In zh, this message translates to:
  /// **'顯示區塊'**
  String get uiWorkspacePanels;

  /// Application display copy. Source: lib/bin/appbar.dart:433
  ///
  /// In zh, this message translates to:
  /// **'尋找與取代'**
  String get uiFindAndReplace;

  /// Application display copy. Source: lib/bin/appbar.dart:438
  ///
  /// In zh, this message translates to:
  /// **'符合條件'**
  String get uiMatchOptions;

  /// Application display copy. Source: lib/bin/appbar.dart:451
  ///
  /// In zh, this message translates to:
  /// **'搜尋方式'**
  String get uiSearchMethod;

  /// Application display copy. Source: lib/bin/appbar.dart:687
  ///
  /// In zh, this message translates to:
  /// **'開'**
  String get uiOn;

  /// Application display copy. Source: lib/bin/appbar.dart:687
  ///
  /// In zh, this message translates to:
  /// **'關'**
  String get uiOff;

  /// Application display copy. Source: lib/bin/appbar.dart:718, lib/modules/settingview.dart:647
  ///
  /// In zh, this message translates to:
  /// **'工具列模式'**
  String get uiToolbarMode;

  /// Application display copy. Source: lib/bin/appbar.dart:730
  ///
  /// In zh, this message translates to:
  /// **'自動（桌面 Full／手機 Moderate）'**
  String get uiAutomaticFullOnDesktopModerateOnMobile;

  /// Application display copy. Source: lib/bin/appbar.dart:769, lib/modules/characterview.dart:2983, lib/modules/characterview.dart:5062
  ///
  /// In zh, this message translates to:
  /// **'說明'**
  String get uiHelp;

  /// Application display copy. Source: lib/bin/appbar.dart:799, lib/features/help/help_viewer.dart:121
  ///
  /// In zh, this message translates to:
  /// **'說明首頁'**
  String get uiHelpHome;

  /// Application display copy. Source: lib/bin/appbar.dart:800
  ///
  /// In zh, this message translates to:
  /// **'目前功能說明（F1）'**
  String get uiHelpForThisFeatureF1;

  /// Application display copy. Source: lib/bin/appbar.dart:801
  ///
  /// In zh, this message translates to:
  /// **'這是什麼？（Shift+F1）'**
  String get uiWhatSThisShiftF1;

  /// Application display copy. Source: lib/bin/content.dart:528
  ///
  /// In zh, this message translates to:
  /// **'輸入其他顯示文字（不加入別名）'**
  String get uiEnterAlternativeDisplayTextNotAddedAsAn;

  /// Application display copy. Source: lib/bin/content.dart:529
  ///
  /// In zh, this message translates to:
  /// **'插入'**
  String get uiInsert;

  /// Application display copy. Source: lib/bin/content.dart:530, lib/features/inline_annotations/inline_annotation_details_dialog.dart:349, lib/features/inline_annotations/inline_annotation_edit_dialog.dart:241
  ///
  /// In zh, this message translates to:
  /// **'顯示文字'**
  String get uiDisplayText;

  /// Application display copy. Source: lib/bin/content.dart:585, lib/ui_library/alias_terms.dart:88
  ///
  /// In zh, this message translates to:
  /// **'新增別名'**
  String get uiAddAlias;

  /// Application display copy. Source: lib/bin/content.dart:664, lib/features/inline_annotations/inline_annotation_details_dialog.dart:332, lib/features/phrases/phrase_library_dialog.dart:822
  ///
  /// In zh, this message translates to:
  /// **'人物'**
  String get uiCharacter;

  /// Application display copy. Source: lib/bin/content.dart:665, lib/features/inline_annotations/inline_annotation_details_dialog.dart:333, lib/features/phrases/phrase_library_dialog.dart:828
  ///
  /// In zh, this message translates to:
  /// **'地點'**
  String get uiLocation;

  /// Application display copy. Source: lib/bin/content.dart:666, lib/features/inline_annotations/inline_annotation_details_dialog.dart:334, lib/features/phrases/phrase_library_dialog.dart:829
  ///
  /// In zh, this message translates to:
  /// **'事件'**
  String get uiEvent;

  /// Application display copy. Source: lib/bin/content.dart:667, lib/features/inline_annotations/inline_annotation_details_dialog.dart:335, lib/presentation/widgets/radial_gauge_dashboard.dart:190
  ///
  /// In zh, this message translates to:
  /// **'伏筆'**
  String get uiForeshadowing;

  /// Application display copy. Source: lib/bin/content.dart:668, lib/features/inline_annotations/inline_annotation_details_dialog.dart:336, lib/presentation/widgets/radial_gauge_dashboard.dart:190
  ///
  /// In zh, this message translates to:
  /// **'計畫'**
  String get uiPlan;

  /// Application display copy. Source: lib/bin/content.dart:669, lib/features/inline_annotations/inline_annotation_details_dialog.dart:337, lib/features/phrases/phrase_library_dialog.dart:824
  ///
  /// In zh, this message translates to:
  /// **'物品'**
  String get uiItem;

  /// Application display copy. Source: lib/bin/content.dart:670, lib/features/revision_tracking/application/revision_field_registry.dart:92
  ///
  /// In zh, this message translates to:
  /// **'重點'**
  String get uiKeyPoint;

  /// Application display copy. Source: lib/bin/content.dart:677, lib/bin/ui_library.dart:773, lib/bin/ui_library.dart:794
  ///
  /// In zh, this message translates to:
  /// **'新增{p1}'**
  String uiAdd(String p1);

  /// Application display copy. Source: lib/bin/content.dart:702, lib/bin/file.dart:598, lib/bin/file.dart:691
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get commonCancel;

  /// Application display copy. Source: lib/bin/content.dart:973, lib/bin/content.dart:1134
  ///
  /// In zh, this message translates to:
  /// **'正文已變更，請重新選取短語'**
  String get uiTheManuscriptHasChangedSelectThePhraseAgain;

  /// Application display copy. Source: lib/bin/content.dart:984
  ///
  /// In zh, this message translates to:
  /// **'無法插入短語：{p1}'**
  String uiCouldNotInsertThePhrase(String p1);

  /// Application display copy. Source: lib/bin/content.dart:1000
  ///
  /// In zh, this message translates to:
  /// **'重新連結「{p1}」'**
  String uiRelink(String p1);

  /// Application display copy. Source: lib/bin/content.dart:1010
  ///
  /// In zh, this message translates to:
  /// **'搜尋對象'**
  String get uiSearchTargets;

  /// Application display copy. Source: lib/bin/content.dart:1040
  ///
  /// In zh, this message translates to:
  /// **'取消插入'**
  String get uiCancelInsertion;

  /// Application display copy. Source: lib/bin/content.dart:1045
  ///
  /// In zh, this message translates to:
  /// **'改為純文字'**
  String get uiConvertToPlainText;

  /// Application display copy. Source: lib/bin/content.dart:1069
  ///
  /// In zh, this message translates to:
  /// **'請先選取要存為短語的正文內容'**
  String get uiSelectManuscriptTextToSaveAsAPhrase;

  /// Application display copy. Source: lib/bin/content.dart:1109
  ///
  /// In zh, this message translates to:
  /// **'尚無可插入的短語，請先在短語庫新增短語'**
  String get uiNoPhrasesAreAvailableAddAPhraseIn;

  /// Application display copy. Source: lib/bin/content.dart:1917
  ///
  /// In zh, this message translates to:
  /// **'遺失對象'**
  String get uiMissingTarget;

  /// Application display copy. Source: lib/bin/content.dart:1918
  ///
  /// In zh, this message translates to:
  /// **'原名：{p1}\n備註：{p2}'**
  String uiOriginalNameNotes(String p1, String p2);

  /// Application display copy. Source: lib/bin/content.dart:1918, lib/features/revision_tracking/presentation/revision_tracking_panel.dart:564, lib/features/revision_tracking/presentation/revision_tracking_panel.dart:564
  ///
  /// In zh, this message translates to:
  /// **'無'**
  String get uiNone;

  /// Application display copy. Source: lib/bin/content.dart:2039
  ///
  /// In zh, this message translates to:
  /// **'新增 Mention'**
  String get uiAddMention;

  /// Application display copy. Source: lib/bin/content.dart:2047
  ///
  /// In zh, this message translates to:
  /// **'存成短語'**
  String get uiSaveAsPhrase;

  /// Application display copy. Source: lib/bin/file.dart:586
  ///
  /// In zh, this message translates to:
  /// **'以後不再提示'**
  String get uiDonTAskAgain;

  /// Application display copy. Source: lib/bin/file.dart:610
  ///
  /// In zh, this message translates to:
  /// **'不儲存'**
  String get uiDonTSave;

  /// Application display copy. Source: lib/bin/file.dart:628, lib/features/inline_annotations/inline_annotation_edit_dialog.dart:348, lib/features/phrases/phrase_library_dialog.dart:930
  ///
  /// In zh, this message translates to:
  /// **'儲存'**
  String get commonSave;

  /// Application display copy. Source: lib/bin/file.dart:652
  ///
  /// In zh, this message translates to:
  /// **'未儲存的變更'**
  String get uiUnsavedChanges;

  /// Application display copy. Source: lib/bin/file.dart:653
  ///
  /// In zh, this message translates to:
  /// **'您有未儲存的變更，是否要在退出前儲存？'**
  String get uiYouHaveUnsavedChangesSaveBeforeExiting;

  /// Application display copy. Source: lib/bin/file.dart:678
  ///
  /// In zh, this message translates to:
  /// **'版本相容性警告'**
  String get uiVersionCompatibilityWarning;

  /// Application display copy. Source: lib/bin/file.dart:682
  ///
  /// In zh, this message translates to:
  /// **'此檔案版本（{p1}）高於目前支援版本（{p2}）。\n若繼續開啟並儲存，可能遺失部分數據。\n\n是否仍要繼續開啟？'**
  String uiThisFileSVersionIsNewerThanThe(String p1, String p2);

  /// Application display copy. Source: lib/bin/file.dart:697
  ///
  /// In zh, this message translates to:
  /// **'繼續開啟'**
  String get uiOpenAnyway;

  /// Application display copy. Source: lib/bin/file.dart:721, lib/main.dart:5584
  ///
  /// In zh, this message translates to:
  /// **'建立新專案'**
  String get uiCreateProject;

  /// Application display copy. Source: lib/bin/file.dart:722, lib/main.dart:5585
  ///
  /// In zh, this message translates to:
  /// **'您有未儲存的變更，是否要在建立新專案前儲存？'**
  String get uiYouHaveUnsavedChangesSaveBeforeCreatingA;

  /// Application display copy. Source: lib/bin/file.dart:736, lib/main.dart:5626
  ///
  /// In zh, this message translates to:
  /// **'新專案建立成功！'**
  String get uiProjectCreated;

  /// Application display copy. Source: lib/bin/file.dart:739, lib/main.dart:5635
  ///
  /// In zh, this message translates to:
  /// **'建立新專案失敗：{p1}'**
  String uiCouldNotCreateTheProject(String p1);

  /// Application display copy. Source: lib/bin/file.dart:755, lib/main.dart:5650, lib/main.dart:5908
  ///
  /// In zh, this message translates to:
  /// **'開啟專案'**
  String get uiOpenProject;

  /// Application display copy. Source: lib/bin/file.dart:756, lib/main.dart:5651, lib/main.dart:5910
  ///
  /// In zh, this message translates to:
  /// **'您有未儲存的變更，是否要在開啟新專案前儲存？'**
  String get uiYouHaveUnsavedChangesSaveBeforeOpeningAnother;

  /// Application display copy. Source: lib/bin/file.dart:784, lib/bin/file.dart:846, lib/main.dart:5706
  ///
  /// In zh, this message translates to:
  /// **'已取消開啟較新版本檔案。'**
  String get uiOpeningTheNewerFileWasCancelled;

  /// Application display copy. Source: lib/bin/file.dart:792, lib/bin/file.dart:854
  ///
  /// In zh, this message translates to:
  /// **'專案開啟成功：{p1}'**
  String uiProjectOpened(String p1);

  /// Application display copy. Source: lib/bin/file.dart:795, lib/main.dart:5761, lib/main.dart:5820
  ///
  /// In zh, this message translates to:
  /// **'開啟專案失敗：{p1}'**
  String uiCouldNotOpenTheProject(String p1);

  /// Application display copy. Source: lib/bin/file.dart:815, lib/main.dart:5908, lib/main.dart:6023
  ///
  /// In zh, this message translates to:
  /// **'開啟最近專案'**
  String get uiOpenRecentProject;

  /// Application display copy. Source: lib/bin/file.dart:816, lib/main.dart:5911
  ///
  /// In zh, this message translates to:
  /// **'您有未儲存的變更，是否要在開啟最近專案前儲存？'**
  String get uiYouHaveUnsavedChangesSaveBeforeOpeningA;

  /// Application display copy. Source: lib/bin/file.dart:856
  ///
  /// In zh, this message translates to:
  /// **'開啟最近專案失敗：{p1}'**
  String uiCouldNotOpenTheRecentProject(String p1);

  /// Application display copy. Source: lib/bin/file.dart:893, lib/main.dart:6097
  ///
  /// In zh, this message translates to:
  /// **'專案儲存成功！'**
  String get uiProjectSaved;

  /// Application display copy. Source: lib/bin/file.dart:896, lib/main.dart:6099
  ///
  /// In zh, this message translates to:
  /// **'儲存專案失敗：{p1}'**
  String uiCouldNotSaveTheProject(String p1);

  /// Application display copy. Source: lib/bin/file.dart:921, lib/main.dart:6170
  ///
  /// In zh, this message translates to:
  /// **'專案另存成功：{p1}'**
  String uiProjectSavedAs(String p1);

  /// Application display copy. Source: lib/bin/file.dart:924, lib/main.dart:6172
  ///
  /// In zh, this message translates to:
  /// **'另存專案失敗：{p1}'**
  String uiCouldNotSaveTheProjectAsANew(String p1);

  /// Application display copy. Source: lib/bin/findreplace.dart:1843
  ///
  /// In zh, this message translates to:
  /// **'正則表達式錯誤: {p1}'**
  String uiInvalidRegularExpression(String p1);

  /// Application display copy. Source: lib/bin/findreplace.dart:1945
  ///
  /// In zh, this message translates to:
  /// **'全部取代失敗：{p1}'**
  String uiReplaceAllFailed(String p1);

  /// Application display copy. Source: lib/bin/findreplace.dart:1966
  ///
  /// In zh, this message translates to:
  /// **'格式無效'**
  String get uiInvalidFormat;

  /// Application display copy. Source: lib/bin/findreplace.dart:1967
  ///
  /// In zh, this message translates to:
  /// **'正則表達式錯誤：{p1}'**
  String uiInvalidRegularExpression2(String p1);

  /// Application display copy. Source: lib/bin/findreplace.dart:1970
  ///
  /// In zh, this message translates to:
  /// **'全部取代已取消：匹配數超過 {p1} 筆，請縮小搜尋範圍。'**
  String uiReplaceAllCancelledMoreThanMatchesNarrowYour(String p1);

  /// Application display copy. Source: lib/bin/findreplace.dart:1973
  ///
  /// In zh, this message translates to:
  /// **'全部取代已取消：結果超過允許的文字大小，請分段處理。'**
  String get uiReplaceAllCancelledTheResultingTextIsToo;

  /// Application display copy. Source: lib/bin/findreplace.dart:1976
  ///
  /// In zh, this message translates to:
  /// **'全部取代已取消：運算時間超過限制，請縮小搜尋範圍。'**
  String get uiReplaceAllCancelledTheTimeLimitWasExceeded;

  /// Application display copy. Source: lib/bin/findreplace.dart:1992
  ///
  /// In zh, this message translates to:
  /// **'確認大量取代'**
  String get uiConfirmLargeReplacement;

  /// Application display copy. Source: lib/bin/findreplace.dart:1994
  ///
  /// In zh, this message translates to:
  /// **'將取代 {p1} 處，結果約 {p2} MiB。確定繼續嗎？'**
  String uiMatchesToReplaceEstimatedResultMiBContinue(String p1, String p2);

  /// Application display copy. Source: lib/bin/findreplace.dart:1996
  ///
  /// In zh, this message translates to:
  /// **'繼續取代'**
  String get uiContinueReplacing;

  /// Application display copy. Source: lib/bin/findreplace.dart:2017
  ///
  /// In zh, this message translates to:
  /// **'全部取代已取消：無法安全映射標記範圍。'**
  String get uiReplaceAllCancelledAnnotationRangesCouldNotBe;

  /// Application display copy. Source: lib/bin/findreplace.dart:2034
  ///
  /// In zh, this message translates to:
  /// **'全部取代已取消：無法安全映射正則標記範圍。'**
  String get uiReplaceAllCancelledRegularExpressionAnnotationRangesCould;

  /// Application display copy. Source: lib/bin/findreplace.dart:2049
  ///
  /// In zh, this message translates to:
  /// **'全部取代已取消：標記投影驗證失敗。'**
  String get uiReplaceAllCancelledAnnotationProjectionValidationFailed;

  /// Application display copy. Source: lib/bin/findreplace.dart:2986
  ///
  /// In zh, this message translates to:
  /// **'搜尋……'**
  String get uiSearch2;

  /// Application display copy. Source: lib/bin/findreplace.dart:3038
  ///
  /// In zh, this message translates to:
  /// **'上一個'**
  String get uiPrevious;

  /// Application display copy. Source: lib/bin/findreplace.dart:3058
  ///
  /// In zh, this message translates to:
  /// **'下一個'**
  String get uiNext;

  /// Application display copy. Source: lib/bin/findreplace.dart:3081, lib/modules/planview.dart:1570, lib/presentation/widgets/snapshot_panel_card.dart:46
  ///
  /// In zh, this message translates to:
  /// **'收合'**
  String get uiCollapse;

  /// Application display copy. Source: lib/bin/findreplace.dart:3081, lib/bin/findreplace.dart:3656
  ///
  /// In zh, this message translates to:
  /// **'展開取代'**
  String get uiExpandReplace;

  /// Application display copy. Source: lib/bin/findreplace.dart:3106, lib/bin/findreplace.dart:3678
  ///
  /// In zh, this message translates to:
  /// **'搜尋選項'**
  String get uiSearchOptions;

  /// Application display copy. Source: lib/bin/findreplace.dart:3135
  ///
  /// In zh, this message translates to:
  /// **'取代為……'**
  String get uiReplaceWith;

  /// Application display copy. Source: lib/bin/findreplace.dart:3166, lib/bin/findreplace.dart:3769
  ///
  /// In zh, this message translates to:
  /// **'取代'**
  String get uiReplace;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1348
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get uiAll;

  /// Application display copy. Source: lib/bin/findreplace.dart:3530
  ///
  /// In zh, this message translates to:
  /// **'尋找內容:'**
  String get uiFind;

  /// Application display copy. Source: lib/bin/findreplace.dart:3656
  ///
  /// In zh, this message translates to:
  /// **'摺疊'**
  String get uiCollapse2;

  /// Application display copy. Source: lib/bin/findreplace.dart:3709
  ///
  /// In zh, this message translates to:
  /// **'取代為:'**
  String get uiReplaceWith2;

  /// Application display copy. Source: lib/bin/findreplace.dart:3806
  ///
  /// In zh, this message translates to:
  /// **'全部取代'**
  String get uiReplaceAll;

  /// Application display copy. Source: lib/bin/input_assist.dart:104, lib/bin/statusbar.dart:297, lib/bin/statusbar.dart:365
  ///
  /// In zh, this message translates to:
  /// **'全形'**
  String get uiFullWidth;

  /// Application display copy. Source: lib/bin/input_assist.dart:105, lib/bin/statusbar.dart:305, lib/bin/statusbar.dart:365
  ///
  /// In zh, this message translates to:
  /// **'半形'**
  String get uiHalfWidth;

  /// Application display copy. Source: lib/bin/mobile_function_page.dart:54
  ///
  /// In zh, this message translates to:
  /// **'功能'**
  String get uiFeatures;

  /// Application display copy. Source: lib/bin/mobile_function_page.dart:55
  ///
  /// In zh, this message translates to:
  /// **'編輯器'**
  String get uiEditor;

  /// Application display copy. Source: lib/bin/punctuation_panel.dart:113
  ///
  /// In zh, this message translates to:
  /// **'全'**
  String get uiFull;

  /// Application display copy. Source: lib/bin/punctuation_panel.dart:120
  ///
  /// In zh, this message translates to:
  /// **'半'**
  String get uiHalf;

  /// Application display copy. Source: lib/bin/slidebar.dart:291, lib/bin/slidebar.dart:418
  ///
  /// In zh, this message translates to:
  /// **'展開導覽'**
  String get uiExpandNavigation;

  /// Application display copy. Source: lib/bin/slidebar.dart:300
  ///
  /// In zh, this message translates to:
  /// **'關閉導覽'**
  String get uiCloseNavigation;

  /// Application display copy. Source: lib/bin/slidebar.dart:403
  ///
  /// In zh, this message translates to:
  /// **'說明模組'**
  String get uiHelpModule;

  /// Application display copy. Source: lib/bin/slidebar.dart:420
  ///
  /// In zh, this message translates to:
  /// **'收合導覽'**
  String get uiCollapseNavigation;

  /// Application display copy. Source: lib/bin/slidebar.dart:421
  ///
  /// In zh, this message translates to:
  /// **'固定導覽'**
  String get uiPinNavigation;

  /// Application display copy. Source: lib/bin/statusbar.dart:183
  ///
  /// In zh, this message translates to:
  /// **'Overtype Mode (Ins)'**
  String get uiOvertypeModeIns;

  /// Application display copy. Source: lib/bin/statusbar.dart:184
  ///
  /// In zh, this message translates to:
  /// **'Default Mode (Ins)'**
  String get uiInsertModeIns;

  /// Application display copy. Source: lib/bin/statusbar.dart:215
  ///
  /// In zh, this message translates to:
  /// **'{p1} / {p2} 字'**
  String uiCharacters(String p1, String p2);

  /// Application display copy. Source: lib/bin/statusbar.dart:347
  ///
  /// In zh, this message translates to:
  /// **'行首留空'**
  String get uiIndentLineStart;

  /// Application display copy. Source: lib/bin/statusbar.dart:358
  ///
  /// In zh, this message translates to:
  /// **'Tab 插入空格'**
  String get uiInsertSpacesWithTab;

  /// Application display copy. Source: lib/bin/ui_library.dart:799
  ///
  /// In zh, this message translates to:
  /// **'請先輸入{p1}'**
  String uiEnterFirst(String p1);

  /// Application display copy. Source: lib/bin/ui_library.dart:800
  ///
  /// In zh, this message translates to:
  /// **'目前不可新增'**
  String get uiCannotAddRightNow;

  /// Application display copy. Source: lib/bin/ui_library.dart:959
  ///
  /// In zh, this message translates to:
  /// **'轉為正式物品關聯'**
  String get uiConvertToItemLink;

  /// Application display copy. Source: lib/features/editor/plain_text_quill_editor_poc.dart:1285
  ///
  /// In zh, this message translates to:
  /// **'Quill 純文字正文 PoC'**
  String get uiQuillPlainTextManuscriptPreview;

  /// Application display copy. Source: lib/features/editor/plain_text_quill_mention_overlay.dart:172, lib/features/inline_annotations/inline_annotation_symbol_overlay.dart:242
  ///
  /// In zh, this message translates to:
  /// **'{p1}標記：{p2}'**
  String uiAnnotation(String p1, String p2);

  /// Application display copy. Source: lib/features/editor/plain_text_quill_remote_cursor_overlay.dart:179, lib/presentation/widgets/remote_text_cursor_overlay.dart:167
  ///
  /// In zh, this message translates to:
  /// **'{p1} 的游標'**
  String uiSCursor(String p1);

  /// Application display copy. Source: lib/features/help/help_controller.dart:298
  ///
  /// In zh, this message translates to:
  /// **'點選項目查看說明，Esc 取消'**
  String get uiSelectAControlToViewHelpEscCancels;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:106
  ///
  /// In zh, this message translates to:
  /// **'說明中心'**
  String get uiHelpCenter;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:110
  ///
  /// In zh, this message translates to:
  /// **'關閉說明（Esc）'**
  String get uiCloseHelpEsc;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:126
  ///
  /// In zh, this message translates to:
  /// **'上一頁'**
  String get uiPreviousPage;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:131
  ///
  /// In zh, this message translates to:
  /// **'下一頁'**
  String get uiNextPage;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:144
  ///
  /// In zh, this message translates to:
  /// **'閱讀文章'**
  String get uiReadArticle;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:144
  ///
  /// In zh, this message translates to:
  /// **'目錄與搜尋'**
  String get uiContentsAndSearch;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:150
  ///
  /// In zh, this message translates to:
  /// **'搜尋說明'**
  String get uiSearchHelp;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:165
  ///
  /// In zh, this message translates to:
  /// **'無法載入內建說明，請重試。'**
  String get uiCouldNotLoadOfflineHelpPleaseTryAgain;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:171, lib/features/oobe/oobe_gate.dart:82, lib/modules/glossaryview.dart:2195
  ///
  /// In zh, this message translates to:
  /// **'重試'**
  String get commonRetry;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:222
  ///
  /// In zh, this message translates to:
  /// **'找不到符合的說明'**
  String get uiNoMatchingHelpTopics;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:228
  ///
  /// In zh, this message translates to:
  /// **'返回目錄'**
  String get uiBackToContents;

  /// Application display copy. Source: lib/features/help/help_viewer.dart:291
  ///
  /// In zh, this message translates to:
  /// **'相關說明'**
  String get uiRelatedTopics;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:106, lib/features/inline_annotations/inline_annotation_details_dialog.dart:127
  ///
  /// In zh, this message translates to:
  /// **'完整語法無效，請修正後再套用。'**
  String get uiInvalidAnnotationSyntaxCorrectItBeforeApplying;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:176, lib/features/oobe/oobe_screen.dart:624, lib/features/oobe/oobe_screen.dart:627
  ///
  /// In zh, this message translates to:
  /// **'關閉'**
  String get commonClose;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:193, lib/modules/characterview.dart:3034, lib/modules/itemview.dart:440
  ///
  /// In zh, this message translates to:
  /// **'備註'**
  String get uiNotes;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:212, lib/features/inline_annotations/inline_annotation_edit_dialog.dart:176, lib/modules/baseinfoview.dart:566
  ///
  /// In zh, this message translates to:
  /// **'類型'**
  String get uiType;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:216
  ///
  /// In zh, this message translates to:
  /// **'對象'**
  String get uiTarget;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:226, lib/features/inline_annotations/inline_annotation_edit_dialog.dart:210, lib/modules/characterview.dart:2982
  ///
  /// In zh, this message translates to:
  /// **'狀態'**
  String get uiStatus;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:230
  ///
  /// In zh, this message translates to:
  /// **'色彩'**
  String get uiColor;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:258
  ///
  /// In zh, this message translates to:
  /// **'開啟節點'**
  String get uiOpenNode;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:272, lib/features/inline_annotations/inline_annotation_edit_dialog.dart:149
  ///
  /// In zh, this message translates to:
  /// **'編輯標記'**
  String get uiEditAnnotation;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:280, lib/modules/timelineview.dart:1322, lib/presentation/widgets/writing_goal_dialog.dart:212
  ///
  /// In zh, this message translates to:
  /// **'套用'**
  String get uiApply;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:299
  ///
  /// In zh, this message translates to:
  /// **'更多標記操作'**
  String get uiMoreAnnotationActions;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:309
  ///
  /// In zh, this message translates to:
  /// **'更新為目前名稱'**
  String get uiUpdateToCurrentName;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:318, lib/features/inline_annotations/inline_annotation_relink_dialog.dart:52
  ///
  /// In zh, this message translates to:
  /// **'重新連結遺失對象'**
  String get uiRelinkMissingTarget;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:324
  ///
  /// In zh, this message translates to:
  /// **'移除標記但保留文字'**
  String get uiRemoveAnnotationKeepText;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:338, lib/features/editor/plain_text_quill_mention_overlay.dart:199, lib/features/inline_annotations/inline_annotation_edit_dialog.dart:378
  ///
  /// In zh, this message translates to:
  /// **'高亮'**
  String get uiHighlight;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:378, lib/features/inline_annotations/inline_annotation_edit_dialog.dart:316
  ///
  /// In zh, this message translates to:
  /// **'完整語法'**
  String get uiFullSyntax;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:387
  ///
  /// In zh, this message translates to:
  /// **'複製語法'**
  String get uiCopySyntax;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:406, lib/features/inline_annotations/inline_annotation_edit_dialog.dart:382
  ///
  /// In zh, this message translates to:
  /// **'一般'**
  String get uiGeneral;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:407, lib/features/inline_annotations/inline_annotation_edit_dialog.dart:383
  ///
  /// In zh, this message translates to:
  /// **'開始'**
  String get uiStart;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_details_dialog.dart:408, lib/features/inline_annotations/inline_annotation_edit_dialog.dart:384
  ///
  /// In zh, this message translates to:
  /// **'結束'**
  String get uiEnd;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_edit_dialog.dart:141
  ///
  /// In zh, this message translates to:
  /// **'此標記類型需要 UUID。'**
  String get uiThisAnnotationTypeRequiresAUUID;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_edit_dialog.dart:143
  ///
  /// In zh, this message translates to:
  /// **'標記資料無效：{p1}'**
  String uiInvalidAnnotationData(String p1);

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_edit_dialog.dart:263
  ///
  /// In zh, this message translates to:
  /// **'背景色碼'**
  String get uiBackgroundColorCode;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_edit_dialog.dart:288
  ///
  /// In zh, this message translates to:
  /// **'文字色碼'**
  String get uiTextColorCode;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_edit_dialog.dart:304
  ///
  /// In zh, this message translates to:
  /// **'備註（可留空）'**
  String get uiNotesOptional;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_edit_dialog.dart:316
  ///
  /// In zh, this message translates to:
  /// **'直接修改此欄會優先套用完整語法。'**
  String get uiEditingThisFieldAppliesTheFullSyntaxIn;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_edit_dialog.dart:356
  ///
  /// In zh, this message translates to:
  /// **'0（自動）'**
  String get uiAutomatic;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_relink_dialog.dart:66
  ///
  /// In zh, this message translates to:
  /// **'搜尋名稱、路徑或 UUID'**
  String get uiSearchNamePathOrUUID;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_relink_dialog.dart:75
  ///
  /// In zh, this message translates to:
  /// **'沒有相符的可連結對象'**
  String get uiNoMatchingLinkTargets;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_relink_dialog.dart:87, lib/modules/planview.dart:1210, lib/modules/planview.dart:1373
  ///
  /// In zh, this message translates to:
  /// **'（未命名）'**
  String get uiUntitled;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_relink_dialog.dart:104
  ///
  /// In zh, this message translates to:
  /// **'目前顯示前 {p1} 筆，請輸入關鍵字縮小範圍。'**
  String uiShowingTheFirstResultsEnterKeywordsToNarrow(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_gate.dart:78
  ///
  /// In zh, this message translates to:
  /// **'無法讀取初次設定，請重試。'**
  String get uiCouldNotReadInitialSetupPleaseTryAgain;

  /// Application display copy. Source: lib/features/oobe/oobe_gate.dart:102
  ///
  /// In zh, this message translates to:
  /// **'無法讀取備份位置，按此重試'**
  String get uiCouldNotReadTheBackupLocationSelectTo;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:138, lib/modules/settingview.dart:944
  ///
  /// In zh, this message translates to:
  /// **'選擇自動備份資料夾'**
  String get uiChooseAutomaticBackupFolder;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:146
  ///
  /// In zh, this message translates to:
  /// **'無法選擇資料夾，請再試一次。'**
  String get uiCouldNotSelectAFolderPleaseTryAgain;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:402
  ///
  /// In zh, this message translates to:
  /// **'選擇適合您的閱讀與操作方式。這些選項稍後都能在「設定」中調整。'**
  String get uiChooseHowYouPreferToReadAndWork;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:404
  ///
  /// In zh, this message translates to:
  /// **'介面主題'**
  String get uiInterfaceTheme;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:411
  ///
  /// In zh, this message translates to:
  /// **'使用{p1}主題'**
  String uiUseTheTheme(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:428
  ///
  /// In zh, this message translates to:
  /// **'側邊導覽'**
  String get uiSideNavigation;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:455
  ///
  /// In zh, this message translates to:
  /// **'作品會以 .mnproj 專案檔保存在您選擇的位置。依照寫作習慣，決定是否啟用以下功能。'**
  String get uiYourWorkIsSavedAsAMnprojProject;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:462, lib/modules/settingview.dart:817
  ///
  /// In zh, this message translates to:
  /// **'自動儲存'**
  String get uiAutoSave;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:464
  ///
  /// In zh, this message translates to:
  /// **'每 {p1} 分鐘寫回目前的專案檔。請先手動儲存一次，選定檔案位置。'**
  String uiSaveToTheCurrentProjectFileEveryMinutes(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:476, lib/modules/settingview.dart:832
  ///
  /// In zh, this message translates to:
  /// **'儲存間隔'**
  String get uiSaveInterval;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:481, lib/features/oobe/oobe_screen.dart:512, lib/modules/settingview.dart:839
  ///
  /// In zh, this message translates to:
  /// **'{p1} 分鐘'**
  String uiMinutes(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:493, lib/modules/settingview.dart:863
  ///
  /// In zh, this message translates to:
  /// **'自動備份'**
  String get uiAutomaticBackup;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:495
  ///
  /// In zh, this message translates to:
  /// **'每 {p1} 分鐘另存備份，保留目前專案的位置；可在設定中管理備份。'**
  String uiCreateASeparateBackupEveryMinutesWithoutChanging(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:507, lib/modules/settingview.dart:878
  ///
  /// In zh, this message translates to:
  /// **'備份間隔'**
  String get uiBackupInterval;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:528
  ///
  /// In zh, this message translates to:
  /// **'此平台的自動備份資料夾可於設定中管理。'**
  String get uiManageTheAutomaticBackupFolderInSettingsOn;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:536
  ///
  /// In zh, this message translates to:
  /// **'本程式可離線使用。請記得用「儲存」保存新專案。'**
  String get uiThisAppWorksOfflineRememberToSaveNew;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:539
  ///
  /// In zh, this message translates to:
  /// **'開啟歡迎頁面時，您的名稱會出現在「歡迎訊息」欄位。請輸入您希望出現的名稱。您也可以略過這個步驟。'**
  String get uiYourNameAppearsInTheWelcomeMessageOn;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:549
  ///
  /// In zh, this message translates to:
  /// **'名稱（選填）'**
  String get uiNameOptional;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:550
  ///
  /// In zh, this message translates to:
  /// **'輸入您的名稱或筆名'**
  String get uiEnterYourNameOrPenName;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:558
  ///
  /// In zh, this message translates to:
  /// **'範例：中野梓'**
  String get uiExampleAzusaNakano;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:564
  ///
  /// In zh, this message translates to:
  /// **'作為預設筆名'**
  String get uiUseAsDefaultPenName;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:565
  ///
  /// In zh, this message translates to:
  /// **'新建專案時，自動填入作者欄位。'**
  String get uiFillInTheAuthorAutomaticallyWhenCreatingA;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:577
  ///
  /// In zh, this message translates to:
  /// **'進入工作區後，您可以從歡迎頁新建專案，或開啟已有的 .mnproj 檔案。'**
  String get uiFromTheWorkspaceHomePageCreateAProject;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:581
  ///
  /// In zh, this message translates to:
  /// **'01  建立您的作品'**
  String get uiCreateYourWork;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:582
  ///
  /// In zh, this message translates to:
  /// **'新建專案，填寫作品名稱與故事基本資料。'**
  String get uiCreateAProjectAndEnterItsTitleAnd;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:587
  ///
  /// In zh, this message translates to:
  /// **'02  寫下第一個章節'**
  String get uiWriteYourFirstChapter;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:588
  ///
  /// In zh, this message translates to:
  /// **'在「章節」新增資料夾與章節，選取章節後開始撰寫正文。'**
  String get uiAddFoldersAndChaptersInChaptersThenSelect;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:593
  ///
  /// In zh, this message translates to:
  /// **'03  構建您的設定'**
  String get uiBuildYourStoryWorld;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:594
  ///
  /// In zh, this message translates to:
  /// **'用大綱、角色、世界觀與時間軸，整理您的故事。需要協助時可從「說明」選單開啟指南。'**
  String get uiOrganizeYourStoryWithOutlinesCharactersWorldbuildingAnd;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:598
  ///
  /// In zh, this message translates to:
  /// **'恭喜！您現在可以開始使用本程式。以下是您的完成報告：'**
  String get uiYouReReadyToBeginHereIsA;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:607, lib/modules/worldsettingsview.dart:2144
  ///
  /// In zh, this message translates to:
  /// **'名稱：{p1}'**
  String uiName(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:607, lib/modules/itemview.dart:1428, lib/modules/itemview.dart:1460
  ///
  /// In zh, this message translates to:
  /// **'未設定'**
  String get uiNotSet;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:610
  ///
  /// In zh, this message translates to:
  /// **'作為預設筆名：{p1}'**
  String uiDefaultPenName(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:610, lib/modules/worldsettingsview.dart:787, lib/modules/worldsettingsview.dart:787
  ///
  /// In zh, this message translates to:
  /// **'是'**
  String get uiYes;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:610, lib/modules/worldsettingsview.dart:787, lib/modules/worldsettingsview.dart:787
  ///
  /// In zh, this message translates to:
  /// **'否'**
  String get uiNo;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:612
  ///
  /// In zh, this message translates to:
  /// **'主題：{p1}'**
  String uiTheme(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:614
  ///
  /// In zh, this message translates to:
  /// **'主題顏色：{p1}'**
  String uiThemeColor(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:616
  ///
  /// In zh, this message translates to:
  /// **'文字大小：{p1}'**
  String uiTextSize(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:618
  ///
  /// In zh, this message translates to:
  /// **'導覽：{p1}'**
  String uiNavigation2(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:621
  ///
  /// In zh, this message translates to:
  /// **'Ribbon 模式：{p1}'**
  String uiRibbonMode(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:621
  ///
  /// In zh, this message translates to:
  /// **'自動（{p1}）'**
  String uiAutomatic2(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:624
  ///
  /// In zh, this message translates to:
  /// **'自動儲存：{p1}'**
  String uiAutoSave2(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:624, lib/features/oobe/oobe_screen.dart:627
  ///
  /// In zh, this message translates to:
  /// **'每 {p1} 分鐘'**
  String uiEveryMinutes(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:627
  ///
  /// In zh, this message translates to:
  /// **'自動備份：{p1}'**
  String uiAutomaticBackup2(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:630
  ///
  /// In zh, this message translates to:
  /// **'自動備份資料夾：{p1}'**
  String uiAutomaticBackupFolder(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:630, lib/features/oobe/oobe_screen.dart:753
  ///
  /// In zh, this message translates to:
  /// **'使用預設備份資料夾'**
  String get uiUseDefaultBackupFolder;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:637
  ///
  /// In zh, this message translates to:
  /// **'介面與儲存偏好可在「設定」中修改，名稱可重新開啟初次設定調整。'**
  String get uiChangeAppearanceAndStorageOptionsInSettingsReopen;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:648
  ///
  /// In zh, this message translates to:
  /// **'Ribbon 模式'**
  String get uiRibbonMode2;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:654, lib/modules/settingview.dart:655, lib/modules/settingview.dart:684
  ///
  /// In zh, this message translates to:
  /// **'自動'**
  String get uiAutomatic3;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:656, lib/modules/settingview.dart:656
  ///
  /// In zh, this message translates to:
  /// **'依裝置選擇：桌面 Full，手機 Moderate。'**
  String get uiChooseByDeviceFullOnDesktopModerateOn;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:676, lib/modules/settingview.dart:672
  ///
  /// In zh, this message translates to:
  /// **'自動使用 {p1}：{p2}'**
  String uiAutomaticallyUsing(String p1, String p2);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:688, lib/modules/settingview.dart:573
  ///
  /// In zh, this message translates to:
  /// **'主題顏色'**
  String get uiThemeColor2;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:710
  ///
  /// In zh, this message translates to:
  /// **'文字大小  {p1}sp'**
  String uiTextSizeSp(String p1);

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:744
  ///
  /// In zh, this message translates to:
  /// **'自動備份資料夾'**
  String get uiAutomaticBackupFolder2;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:769
  ///
  /// In zh, this message translates to:
  /// **'選擇資料夾'**
  String get uiChooseFolder;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:781
  ///
  /// In zh, this message translates to:
  /// **'還原預設'**
  String get uiResetToDefault;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:980, lib/presentation/widgets/splash_screen.dart:179
  ///
  /// In zh, this message translates to:
  /// **'物語 Assistant'**
  String get uiMonogatariAssistant;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:166
  ///
  /// In zh, this message translates to:
  /// **'刪除短語？'**
  String get uiDeletePhrase;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:167
  ///
  /// In zh, this message translates to:
  /// **'短碼「{p1}」會從短語庫移除。'**
  String uiRemoveShortcutFromThePhraseLibrary(String p1);

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:175, lib/features/phrases/phrase_library_dialog.dart:534, lib/modules/character_relationship_graph_view.dart:1566
  ///
  /// In zh, this message translates to:
  /// **'刪除'**
  String get commonDelete;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:220
  ///
  /// In zh, this message translates to:
  /// **'短語庫已匯出'**
  String get uiPhraseLibraryExported;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:236
  ///
  /// In zh, this message translates to:
  /// **'短碼「{p1}」發生衝突'**
  String uiShortcutConflicts(String p1);

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:238
  ///
  /// In zh, this message translates to:
  /// **'匯入項目與現有短語的 ID 或短碼相同：\n{p1}\n\n可以保留現有項目、覆蓋，或以「{p2}」另存一份。'**
  String uiTheImportedPhraseHasTheSameIDOr(String p1, String p2);

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:239, lib/features/phrases/phrase_library_dialog.dart:486
  ///
  /// In zh, this message translates to:
  /// **'所有專案'**
  String get uiAllProjects;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:239, lib/features/phrases/phrase_library_dialog.dart:486, lib/modules/settingview.dart:409
  ///
  /// In zh, this message translates to:
  /// **'目前專案'**
  String get uiCurrentProject;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:245
  ///
  /// In zh, this message translates to:
  /// **'取消匯入'**
  String get uiCancelImport;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:250
  ///
  /// In zh, this message translates to:
  /// **'保留現有'**
  String get uiKeepExisting;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:255
  ///
  /// In zh, this message translates to:
  /// **'另存一份'**
  String get uiSaveACopy;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:260, lib/modules/worldsettingsview.dart:2619
  ///
  /// In zh, this message translates to:
  /// **'覆蓋'**
  String get uiOverwrite;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:326
  ///
  /// In zh, this message translates to:
  /// **'已匯入 {p1} 筆，保留 {p2} 筆現有短語。{p3}'**
  String uiImportedExistingPhrasesKept(String p1, String p2, String p3);

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:327
  ///
  /// In zh, this message translates to:
  /// **'含 Mention 的短語已限於目前專案，插入前須重新連結。'**
  String get uiPhrasesWithMentionsAreLimitedToThisProject;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:423, lib/features/phrases/phrase_library_dialog.dart:730
  ///
  /// In zh, this message translates to:
  /// **'新增短語'**
  String get uiAddPhrase;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:438
  ///
  /// In zh, this message translates to:
  /// **'全域短語庫讀取失敗：{p1}'**
  String uiCouldNotLoadTheGlobalPhraseLibrary(String p1);

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:448
  ///
  /// In zh, this message translates to:
  /// **'搜尋內容、短碼或標籤'**
  String get uiSearchContentShortcutsOrTags;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:464
  ///
  /// In zh, this message translates to:
  /// **'已停用'**
  String get uiDisabled;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:508
  ///
  /// In zh, this message translates to:
  /// **'複製短語'**
  String get uiDuplicatePhrase;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:513
  ///
  /// In zh, this message translates to:
  /// **'停用'**
  String get uiDisable;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:513
  ///
  /// In zh, this message translates to:
  /// **'啟用'**
  String get uiEnable;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:730
  ///
  /// In zh, this message translates to:
  /// **'編輯短語'**
  String get uiEditPhrase;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:741
  ///
  /// In zh, this message translates to:
  /// **'短碼（1–32 位英數、_、-）'**
  String get uiShortcutLettersDigitsOr;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:749
  ///
  /// In zh, this message translates to:
  /// **'所有專案可用'**
  String get uiAvailableInAllProjects;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:761
  ///
  /// In zh, this message translates to:
  /// **'含 Mention，只能用於目前專案'**
  String get uiContainsMentionsCurrentProjectOnly;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:765, lib/modules/baseinfoview.dart:642, lib/features/revision_tracking/application/revision_field_registry.dart:63
  ///
  /// In zh, this message translates to:
  /// **'標籤'**
  String get uiTags;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:785, lib/features/phrases/phrase_library_dialog.dart:793
  ///
  /// In zh, this message translates to:
  /// **'新增標籤'**
  String get uiAddTag;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:804, lib/modules/planview.dart:1680
  ///
  /// In zh, this message translates to:
  /// **'內容'**
  String get uiContent;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:807
  ///
  /// In zh, this message translates to:
  /// **'提及限目前專案；文字標記可供所有專案使用'**
  String get uiMentionsAreProjectSpecificTextAnnotationsCanBe;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:841
  ///
  /// In zh, this message translates to:
  /// **'標記'**
  String get uiAnnotation2;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:919
  ///
  /// In zh, this message translates to:
  /// **'Mosaic 語法不完整'**
  String get uiIncompleteMosaicSyntax;

  /// Application display copy. Source: lib/features/phrases/phrase_library_dialog.dart:928
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get uiBack;

  /// Application display copy. Source: lib/features/poppin/poppin_panel.dart:97
  ///
  /// In zh, this message translates to:
  /// **'找不到符合的候選項目'**
  String get uiNoMatchingSuggestions;

  /// Application display copy. Source: lib/features/poppin/poppin_panel.dart:123
  ///
  /// In zh, this message translates to:
  /// **'返回 {p1}'**
  String uiBackTo(String p1);

  /// Application display copy. Source: lib/features/poppin/poppin_panel.dart:170
  ///
  /// In zh, this message translates to:
  /// **'按 Enter 選取，按向右鍵展開下一層'**
  String get uiEnterSelectsRightArrowOpensTheNextLevel;

  /// Application display copy. Source: lib/features/poppin/poppin_panel.dart:170
  ///
  /// In zh, this message translates to:
  /// **'按 Enter 或 Tab 選取'**
  String get uiEnterOrTabSelects;

  /// Application display copy. Source: lib/features/poppin/poppin_panel.dart:205
  ///
  /// In zh, this message translates to:
  /// **'展開 {p1} 的下一層'**
  String uiExpandTheNextLevelOf(String p1);

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_field_marker.dart:66
  ///
  /// In zh, this message translates to:
  /// **'{p1} 修訂：{p2}'**
  String uiChanges(String p1, String p2);

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_field_marker.dart:116
  ///
  /// In zh, this message translates to:
  /// **'項目修訂：{p1}'**
  String uiItemChanges(String p1);

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:177
  ///
  /// In zh, this message translates to:
  /// **'修訂追蹤'**
  String get uiTrackChanges;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:182
  ///
  /// In zh, this message translates to:
  /// **'收合修訂窗格'**
  String get uiCollapseChangesPane;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:199
  ///
  /// In zh, this message translates to:
  /// **'追蹤資料無法讀取'**
  String get uiCouldNotReadChangeTrackingData;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:200
  ///
  /// In zh, this message translates to:
  /// **'從目前內容建立比較基準，開始查看修訂。'**
  String get uiCreateABaselineFromTheCurrentContentTo;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:207, lib/presentation/widgets/radial_gauge_dashboard.dart:409
  ///
  /// In zh, this message translates to:
  /// **'開始追蹤'**
  String get uiStartTracking;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:221
  ///
  /// In zh, this message translates to:
  /// **'基準：{p1}'**
  String uiBaseline(String p1);

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:226
  ///
  /// In zh, this message translates to:
  /// **'{p1}：{p2} · 目標：目前內容'**
  String uiComparingToCurrentContent(String p1, String p2);

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:226
  ///
  /// In zh, this message translates to:
  /// **'唯讀版本'**
  String get uiReadOnlyVersion;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:226, lib/modules/character_relationship_graph_view.dart:1726, lib/modules/characterview.dart:5768
  ///
  /// In zh, this message translates to:
  /// **'建立'**
  String get commonCreate;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:258
  ///
  /// In zh, this message translates to:
  /// **'儲存目前內容為檢查點並套用'**
  String get uiSaveCurrentContentAsCheckpointAndApply;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:267
  ///
  /// In zh, this message translates to:
  /// **'顯示已接受'**
  String get uiShowAcceptedChanges;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:275
  ///
  /// In zh, this message translates to:
  /// **'結束追蹤'**
  String get uiStopTracking;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:287
  ///
  /// In zh, this message translates to:
  /// **'正文'**
  String get uiManuscript;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:288, lib/modules/worldsettingsview.dart:902, lib/modules/worldsettingsview.dart:2457
  ///
  /// In zh, this message translates to:
  /// **'設定'**
  String get uiSettings;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:302
  ///
  /// In zh, this message translates to:
  /// **'範圍：'**
  String get uiScope;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:310
  ///
  /// In zh, this message translates to:
  /// **'目前章節／頁面'**
  String get uiCurrentChapterPage;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:314
  ///
  /// In zh, this message translates to:
  /// **'全專案'**
  String get uiEntireProject;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:329
  ///
  /// In zh, this message translates to:
  /// **'正文 +{p1} / -{p2} 行 · 設定 +{p3} / -{p4} / M{p5}'**
  String uiManuscriptLinesSettingsM(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  );

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:339
  ///
  /// In zh, this message translates to:
  /// **'接受此範圍 {p1} 筆'**
  String uiAcceptChangesInScope(String p1);

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:354
  ///
  /// In zh, this message translates to:
  /// **'拒絕此範圍正文'**
  String get uiRejectManuscriptChangesInScope;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:360
  ///
  /// In zh, this message translates to:
  /// **'大型差異已簡化，行數可能非最小值'**
  String get uiLargeDifferencesAreSimplifiedLineCountsMayNot;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:366
  ///
  /// In zh, this message translates to:
  /// **'部分資料類型尚未納入比較'**
  String get uiSomeDataTypesAreNotYetIncludedIn;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:374
  ///
  /// In zh, this message translates to:
  /// **'上一筆'**
  String get uiPreviousChange;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:381
  ///
  /// In zh, this message translates to:
  /// **'下一筆'**
  String get uiNextChange;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:398
  ///
  /// In zh, this message translates to:
  /// **'計算修訂失敗：{p1}'**
  String uiCouldNotCalculateChanges(String p1);

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:398
  ///
  /// In zh, this message translates to:
  /// **'未知錯誤'**
  String get uiUnknownError;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:402, lib/presentation/widgets/radial_gauge_dashboard.dart:353
  ///
  /// In zh, this message translates to:
  /// **'比較來源尚未取得'**
  String get uiComparisonSourceIsNotAvailableYet;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:405
  ///
  /// In zh, this message translates to:
  /// **'此範圍沒有修訂'**
  String get uiNoChangesInThisScope;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:545
  ///
  /// In zh, this message translates to:
  /// **'正文／{p1} · 舊 {p2} → 新 {p3}'**
  String uiManuscriptBeforeAfter(String p1, String p2, String p3);

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:561
  ///
  /// In zh, this message translates to:
  /// **'另有 {p1} 行…'**
  String uiAdditionalLines(String p1);

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:564
  ///
  /// In zh, this message translates to:
  /// **'行尾換行：{p1} → {p2}'**
  String uiTrailingNewline(String p1, String p2);

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:564, lib/features/revision_tracking/presentation/revision_tracking_panel.dart:564
  ///
  /// In zh, this message translates to:
  /// **'有'**
  String get uiPresent;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:567
  ///
  /// In zh, this message translates to:
  /// **'大型差異概略呈現'**
  String get uiLargeDifferencesOverview;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:573
  ///
  /// In zh, this message translates to:
  /// **'完整標記'**
  String get uiFullAnnotation;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:578, lib/features/revision_tracking/presentation/revision_tracking_panel.dart:761
  ///
  /// In zh, this message translates to:
  /// **'取消接受'**
  String get uiUndoAcceptance;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:578, lib/features/revision_tracking/presentation/revision_tracking_panel.dart:761
  ///
  /// In zh, this message translates to:
  /// **'接受'**
  String get uiAccept;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:581, lib/features/revision_tracking/presentation/revision_tracking_panel.dart:769
  ///
  /// In zh, this message translates to:
  /// **'拒絕'**
  String get uiReject;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:594
  ///
  /// In zh, this message translates to:
  /// **'{p1} · 完整標記'**
  String uiFullAnnotation2(String p1);

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:673
  ///
  /// In zh, this message translates to:
  /// **'專案資訊'**
  String get uiProjectInformation;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:689
  ///
  /// In zh, this message translates to:
  /// **'新增項目'**
  String get uiAddedItem;

  /// Application display copy. Source: lib/features/revision_tracking/presentation/revision_tracking_panel.dart:689
  ///
  /// In zh, this message translates to:
  /// **'刪除項目'**
  String get uiDeletedItem;

  /// Application display copy. Source: lib/main.dart:792
  ///
  /// In zh, this message translates to:
  /// **'切換模組，目前為{p1}'**
  String uiSwitchModuleCurrent(String p1);

  /// Application display copy. Source: lib/main.dart:1487
  ///
  /// In zh, this message translates to:
  /// **'無可用對象'**
  String get uiNoTargetsAvailable;

  /// Application display copy. Source: lib/main.dart:1488
  ///
  /// In zh, this message translates to:
  /// **'請先建立相同類型的對象，再重新連結此標記。'**
  String get uiCreateATargetOfTheSameTypeBefore;

  /// Application display copy. Source: lib/main.dart:1514
  ///
  /// In zh, this message translates to:
  /// **'已複製完整標記語法。'**
  String get uiFullAnnotationSyntaxCopied;

  /// Application display copy. Source: lib/main.dart:3394
  ///
  /// In zh, this message translates to:
  /// **'開啟儀表板'**
  String get uiOpenDashboard;

  /// Application display copy. Source: lib/main.dart:3505
  ///
  /// In zh, this message translates to:
  /// **'正文已變更，請等待修訂重新計算後再批次拒絕。'**
  String get uiTheManuscriptChangedWaitForChangesToBe;

  /// Application display copy. Source: lib/main.dart:3540
  ///
  /// In zh, this message translates to:
  /// **'批次拒絕的來源已變更；請重新計算差異。'**
  String get uiTheBatchRejectionSourceHasChangedRecalculateThe;

  /// Application display copy. Source: lib/main.dart:3573
  ///
  /// In zh, this message translates to:
  /// **'正文已變更，請等待修訂重新計算後再拒絕。'**
  String get uiTheManuscriptChangedWaitForChangesToBe2;

  /// Application display copy. Source: lib/main.dart:3598
  ///
  /// In zh, this message translates to:
  /// **'此區塊位置已失效，請重新計算差異。'**
  String get uiThisBlockSPositionIsNoLongerValid;

  /// Application display copy. Source: lib/main.dart:3610, lib/main.dart:3620
  ///
  /// In zh, this message translates to:
  /// **'欄位已變更，請等待修訂重新計算。'**
  String get uiTheFieldChangedWaitForChangesToBe;

  /// Application display copy. Source: lib/main.dart:3826
  ///
  /// In zh, this message translates to:
  /// **'章節已刪除；可在修訂窗格查看舊內容。'**
  String get uiThisChapterWasDeletedViewItsPreviousContent;

  /// Application display copy. Source: lib/main.dart:4161
  ///
  /// In zh, this message translates to:
  /// **'無法準備三方合併。'**
  String get uiCouldNotPrepareTheThreeWayMerge;

  /// Application display copy. Source: lib/main.dart:4183
  ///
  /// In zh, this message translates to:
  /// **'合併期間 revision heads 已變更；未套用過期的衝突選擇。'**
  String get uiRevisionHeadsChangedDuringMergingOutdatedConflictChoices;

  /// Application display copy. Source: lib/main.dart:4191
  ///
  /// In zh, this message translates to:
  /// **'無法套用衝突選擇：{p1}'**
  String uiCouldNotApplyConflictChoices(String p1);

  /// Application display copy. Source: lib/main.dart:4226
  ///
  /// In zh, this message translates to:
  /// **'合併文件已寫入，但 resolve revision 建立失敗；請立即重試同步以復原 metadata。'**
  String get uiTheMergedFileWasSavedButCreatingThe;

  /// Application display copy. Source: lib/main.dart:4239
  ///
  /// In zh, this message translates to:
  /// **'欄位衝突已解決並建立雙 parent revision；正在等待對方 ACK。'**
  String get uiFieldConflictsResolvedAndARevisionWithTwo;

  /// Application display copy. Source: lib/main.dart:4242
  ///
  /// In zh, this message translates to:
  /// **'無法保存 resolve revision：{p1}'**
  String uiCouldNotSaveTheResolutionRevision(String p1);

  /// Application display copy. Source: lib/main.dart:4251
  ///
  /// In zh, this message translates to:
  /// **'遠端版本已失效，請重新下載完整 snapshot。'**
  String get uiTheRemoteRevisionIsNoLongerValidDownload;

  /// Application display copy. Source: lib/main.dart:4257
  ///
  /// In zh, this message translates to:
  /// **'遠端專案格式較新，無法安全比較。'**
  String get uiTheRemoteProjectFormatIsNewerAndCannot;

  /// Application display copy. Source: lib/main.dart:4271
  ///
  /// In zh, this message translates to:
  /// **'遠端版本屬於另一個專案，未加入比較。'**
  String get uiTheRemoteRevisionBelongsToAnotherProjectAnd;

  /// Application display copy. Source: lib/main.dart:4287
  ///
  /// In zh, this message translates to:
  /// **'已載入完整遠端版本供唯讀比較。'**
  String get uiTheCompleteRemoteRevisionIsAvailableForRead;

  /// Application display copy. Source: lib/main.dart:4290
  ///
  /// In zh, this message translates to:
  /// **'無法比較遠端版本：{p1}'**
  String uiCouldNotCompareTheRemoteRevision(String p1);

  /// Application display copy. Source: lib/main.dart:4298
  ///
  /// In zh, this message translates to:
  /// **'同步 session 或遠端 revision 已變更，請重新下載 snapshot。'**
  String get uiTheSyncSessionOrRemoteRevisionChangedDownload;

  /// Application display copy. Source: lib/main.dart:4313
  ///
  /// In zh, this message translates to:
  /// **'目前工作副本已有即時 operation；snapshot 僅供初始化或 checkpoint，不能覆蓋編輯中的專案。'**
  String get uiTheWorkingCopyHasLiveOperationsSnapshotsAre;

  /// Application display copy. Source: lib/main.dart:4333
  ///
  /// In zh, this message translates to:
  /// **'儲存並開啟遠端版本？'**
  String get uiSaveAndOpenRemoteRevision;

  /// Application display copy. Source: lib/main.dart:4336
  ///
  /// In zh, this message translates to:
  /// **'遠端 snapshot 已完整驗證。請選擇儲存位置；若選擇既有檔案，確認後會覆蓋該檔案。取消不會修改目前編輯器。'**
  String get uiTheRemoteSnapshotIsFullyVerifiedChooseWhere;

  /// Application display copy. Source: lib/main.dart:4337
  ///
  /// In zh, this message translates to:
  /// **'遠端 snapshot 已完整驗證，但目前文件不能安全地直接套用。請另存副本。'**
  String get uiTheRemoteSnapshotIsVerifiedButItCannot;

  /// Application display copy. Source: lib/main.dart:4350
  ///
  /// In zh, this message translates to:
  /// **'選擇儲存位置'**
  String get uiChooseSaveLocation;

  /// Application display copy. Source: lib/main.dart:4362
  ///
  /// In zh, this message translates to:
  /// **'確認期間同步 session 已變更，未寫入任何專案。'**
  String get uiTheSyncSessionChangedDuringConfirmationNoProject;

  /// Application display copy. Source: lib/main.dart:4420
  ///
  /// In zh, this message translates to:
  /// **'snapshot 已寫入，但同步 session 已失效，因此未切換目前編輯器。'**
  String get uiTheSnapshotWasSavedButTheSyncSession;

  /// Application display copy. Source: lib/main.dart:4445
  ///
  /// In zh, this message translates to:
  /// **'遠端 snapshot 已覆蓋並開啟：{p1}'**
  String uiRemoteSnapshotOverwrittenAndOpened(String p1);

  /// Application display copy. Source: lib/main.dart:4446
  ///
  /// In zh, this message translates to:
  /// **'遠端 snapshot 已另存並開啟：{p1}'**
  String uiRemoteSnapshotSavedAsACopyAndOpened(String p1);

  /// Application display copy. Source: lib/main.dart:4464
  ///
  /// In zh, this message translates to:
  /// **'無法儲存或開啟遠端 snapshot：{p1}'**
  String uiCouldNotSaveOrOpenTheRemoteSnapshot(String p1);

  /// Application display copy. Source: lib/main.dart:4504
  ///
  /// In zh, this message translates to:
  /// **'允許此 Session 自動套用同步？'**
  String get uiAllowAutomaticSyncForThisSession;

  /// Application display copy. Source: lib/main.dart:4507
  ///
  /// In zh, this message translates to:
  /// **'遠端 draft 已完整驗證。允許後，此安全 session 的後續 draft 會在本機沒有自行修改時自動套用到編輯器；不會頻繁寫入 .mnproj，直到您手動儲存。'**
  String get uiTheRemoteDraftIsFullyVerifiedIfAllowed;

  /// Application display copy. Source: lib/main.dart:4508
  ///
  /// In zh, this message translates to:
  /// **'遠端 revision 已完整驗證。允許後，此安全 session 在本機乾淨時可自動套用後續版本，不再逐次顯示覆蓋確認。目標專案：{p1}。'**
  String uiTheRemoteRevisionIsFullyVerifiedIfAllowed(String p1);

  /// Application display copy. Source: lib/main.dart:4513
  ///
  /// In zh, this message translates to:
  /// **'暫不允許'**
  String get uiNotNow;

  /// Application display copy. Source: lib/main.dart:4517
  ///
  /// In zh, this message translates to:
  /// **'允許此 Session'**
  String get uiAllowThisSession;

  /// Application display copy. Source: lib/main.dart:4565
  ///
  /// In zh, this message translates to:
  /// **'遠端 draft 已近即時套用；.mnproj 尚未寫入，手動儲存時才會升格。'**
  String get uiRemoteDraftAppliedInNearRealTimeThe;

  /// Application display copy. Source: lib/main.dart:4568
  ///
  /// In zh, this message translates to:
  /// **'無法在記憶體中套用遠端 draft：{p1}'**
  String uiCouldNotApplyTheRemoteDraftInMemory(String p1);

  /// Application display copy. Source: lib/main.dart:4987
  ///
  /// In zh, this message translates to:
  /// **'匯入模組'**
  String get uiImportModules;

  /// Application display copy. Source: lib/main.dart:4996, lib/presentation/widgets/radial_gauge_dashboard.dart:268
  ///
  /// In zh, this message translates to:
  /// **'來源：{p1}'**
  String uiSource(String p1);

  /// Application display copy. Source: lib/main.dart:4998
  ///
  /// In zh, this message translates to:
  /// **'勾選的模組會取代目前專案中的對應資料。'**
  String get uiSelectedModulesReplaceTheCorrespondingDataInThis;

  /// Application display copy. Source: lib/main.dart:5002
  ///
  /// In zh, this message translates to:
  /// **'這是細項匯出檔：匯入不會逐項合併，未附的目標資料可能被移除。請先備份，再明確勾選要替換的模組。'**
  String get uiThisIsASelectiveExportImportingReplacesWhole;

  /// Application display copy. Source: lib/main.dart:5006
  ///
  /// In zh, this message translates to:
  /// **'{p1}含必要祖先／依賴，目前已有資料，請改匯入空白專案。'**
  String uiIncludesRequiredAncestorsOrDependenciesImportIntoAn(String p1);

  /// Application display copy. Source: lib/main.dart:5015
  ///
  /// In zh, this message translates to:
  /// **'（細項，替換整個模組）'**
  String get uiSelectiveContentReplacesTheEntireModule;

  /// Application display copy. Source: lib/main.dart:5019
  ///
  /// In zh, this message translates to:
  /// **'目前 {p1} 項 → 匯入後 {p2} 項（含結構節點）'**
  String uiCurrentAfterImportIncludingStructuralNodes(String p1, String p2);

  /// Application display copy. Source: lib/main.dart:5039
  ///
  /// In zh, this message translates to:
  /// **'需要稍後修復的引用：{p1}'**
  String uiReferencesRequiringRepair(String p1);

  /// Application display copy. Source: lib/main.dart:5070
  ///
  /// In zh, this message translates to:
  /// **'套用匯入'**
  String get uiApplyImport;

  /// Application display copy. Source: lib/main.dart:5081
  ///
  /// In zh, this message translates to:
  /// **'確認期間作品已變更，請重新開始匯入。'**
  String get uiTheWorkChangedDuringConfirmationStartTheImport;

  /// Application display copy. Source: lib/main.dart:5107
  ///
  /// In zh, this message translates to:
  /// **'；{p1} 筆引用需要修復'**
  String uiReferencesRequiringRepair2(String p1);

  /// Application display copy. Source: lib/main.dart:5108
  ///
  /// In zh, this message translates to:
  /// **'已匯入 {p1} 個模組{p2}。'**
  String uiModulesImported(String p1, String p2);

  /// Application display copy. Source: lib/main.dart:5110
  ///
  /// In zh, this message translates to:
  /// **'匯入失敗：{p1}'**
  String uiImportFailed(String p1);

  /// Application display copy. Source: lib/main.dart:5151
  ///
  /// In zh, this message translates to:
  /// **'匯出完成：{p1}'**
  String uiExportComplete(String p1);

  /// Application display copy. Source: lib/main.dart:5155, lib/modules/worldsettingsview.dart:2743, lib/presentation/widgets/project_export/export_dialog.dart:122
  ///
  /// In zh, this message translates to:
  /// **'匯出失敗：{p1}'**
  String uiExportFailed(String p1);

  /// Application display copy. Source: lib/main.dart:5730, lib/main.dart:5991
  ///
  /// In zh, this message translates to:
  /// **'（已在記憶體升級至 {p1}，{p2} 項警告）'**
  String uiUpgradedToInMemoryWarnings(String p1, String p2);

  /// Application display copy. Source: lib/main.dart:5738, lib/main.dart:5999
  ///
  /// In zh, this message translates to:
  /// **'專案開啟成功：{p1}{p2}'**
  String uiProjectOpened2(String p1, String p2);

  /// Application display copy. Source: lib/main.dart:5802, lib/main.dart:5836, lib/main.dart:5864
  ///
  /// In zh, this message translates to:
  /// **'未命名.mnproj'**
  String get uiUntitledMnproj;

  /// Application display copy. Source: lib/main.dart:5883
  ///
  /// In zh, this message translates to:
  /// **'外部專案.mnproj'**
  String get uiExternalProjectMnproj;

  /// Application display copy. Source: lib/main.dart:5901
  ///
  /// In zh, this message translates to:
  /// **'此最近檔案沒有可用的本機路徑，請改用一般「開啟檔案」。'**
  String get uiThisRecentFileHasNoUsableLocalPath;

  /// Application display copy. Source: lib/main.dart:6023
  ///
  /// In zh, this message translates to:
  /// **'{p1}失敗：{p2}'**
  String uiFailed(String p1, String p2);

  /// Application display copy. Source: lib/main.dart:6044
  ///
  /// In zh, this message translates to:
  /// **'已從最近清單移除：{p1}'**
  String uiRemovedFromRecentProjects(String p1);

  /// Application display copy. Source: lib/modules/AboutView.dart:66, lib/presentation/widgets/splash_screen.dart:181
  ///
  /// In zh, this message translates to:
  /// **'Codename Hana'**
  String get uiCodenameHana;

  /// Application display copy. Source: lib/modules/AboutView.dart:82
  ///
  /// In zh, this message translates to:
  /// **'MonoAshi 是一個專為作家和創作者設計的寫作輔助工具。它提供了完整的故事管理功能，包括章節管理、角色設定、世界觀建構等，讓您能夠更輕鬆地組織和創作您的故事。'**
  String get uiMonoAshiIsAWritingAssistantForAuthorsAnd;

  /// Application display copy. Source: lib/modules/AboutView.dart:103
  ///
  /// In zh, this message translates to:
  /// **'主要功能'**
  String get uiKeyFeatures;

  /// Application display copy. Source: lib/modules/AboutView.dart:105
  ///
  /// In zh, this message translates to:
  /// **'故事設定管理'**
  String get uiStorySettingsManagement;

  /// Application display copy. Source: lib/modules/AboutView.dart:106
  ///
  /// In zh, this message translates to:
  /// **'章節與段落編輯'**
  String get uiChapterAndParagraphEditing;

  /// Application display copy. Source: lib/modules/AboutView.dart:107
  ///
  /// In zh, this message translates to:
  /// **'大綱規劃'**
  String get uiOutlinePlanning;

  /// Application display copy. Source: lib/modules/AboutView.dart:108
  ///
  /// In zh, this message translates to:
  /// **'世界觀設定'**
  String get uiWorldbuilding;

  /// Application display copy. Source: lib/modules/AboutView.dart:109
  ///
  /// In zh, this message translates to:
  /// **'角色資料庫'**
  String get uiCharacterDatabase;

  /// Application display copy. Source: lib/modules/AboutView.dart:118
  ///
  /// In zh, this message translates to:
  /// **'© 2025~2026 Heyairu(部屋伊琉).'**
  String get uiHeyairu;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:343
  ///
  /// In zh, this message translates to:
  /// **'載入姓名資料失敗，請稍後再試。'**
  String get uiCouldNotLoadTheNameDataTryAgain;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:363
  ///
  /// In zh, this message translates to:
  /// **'已複製姓名結果'**
  String get uiNameResultsCopied;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:369
  ///
  /// In zh, this message translates to:
  /// **'目前尚未連接新建專案功能'**
  String get uiCreatingAProjectIsNotConnectedYet;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:379
  ///
  /// In zh, this message translates to:
  /// **'目前尚未連接開啟檔案功能'**
  String get uiOpeningFilesIsNotConnectedYet;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:389
  ///
  /// In zh, this message translates to:
  /// **'目前尚未連接最近檔案功能'**
  String get uiRecentProjectsAreNotConnectedYet;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:399
  ///
  /// In zh, this message translates to:
  /// **'目前尚未連接刪除最近檔案功能'**
  String get uiRemovingRecentProjectsIsNotConnectedYet;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:416, lib/modules/WelcomeView.dart:434
  ///
  /// In zh, this message translates to:
  /// **'Port 必須是 1–65535 的整數'**
  String get uiPortMustBeAnIntegerFromTo;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:433
  ///
  /// In zh, this message translates to:
  /// **'請輸入有效的內網 IPv4 位址'**
  String get uiEnterAValidLocalNetworkIPv4Address;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:461
  ///
  /// In zh, this message translates to:
  /// **'雙方都沒有同步文件'**
  String get uiNeitherDeviceHasASyncProject;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:461
  ///
  /// In zh, this message translates to:
  /// **'同步文件不同'**
  String get uiDifferentSyncProjects;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:470
  ///
  /// In zh, this message translates to:
  /// **'本機與對方都沒有記憶體中的目標專案；建立新專案後即可直接協作，不必先儲存檔案。'**
  String get uiNeitherDeviceHasTheTargetProjectInMemory;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:471
  ///
  /// In zh, this message translates to:
  /// **'雙方的 Project UUID 不同，請決定本次同步應採用哪一份文件。'**
  String get uiTheDevicesHaveDifferentProjectUUIDsChooseWhich;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:475, lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:270
  ///
  /// In zh, this message translates to:
  /// **'本機'**
  String get uiThisDevice;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:477, lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:271
  ///
  /// In zh, this message translates to:
  /// **'對方'**
  String get uiPeer;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:492
  ///
  /// In zh, this message translates to:
  /// **'建立本機專案'**
  String get uiCreateLocalProject;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:501
  ///
  /// In zh, this message translates to:
  /// **'開啟其他文件'**
  String get uiOpenAnotherFile;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:507
  ///
  /// In zh, this message translates to:
  /// **'使用對方文件'**
  String get uiUsePeerSFile;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:513
  ///
  /// In zh, this message translates to:
  /// **'使用本機文件'**
  String get uiUseLocalFile;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:570, lib/modules/WelcomeView.dart:1931
  ///
  /// In zh, this message translates to:
  /// **'沒有可同步文件'**
  String get uiNoProjectToSync;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:587
  ///
  /// In zh, this message translates to:
  /// **'目前記憶體專案已可即時同步；儲存只用來建立 XML checkpoint。'**
  String get uiTheInMemoryProjectIsReadyForLive;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:594
  ///
  /// In zh, this message translates to:
  /// **'目前專案已儲存且 UUID 有效，等待安全配對。'**
  String get uiTheProjectIsSavedWithAValidUUID;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:609
  ///
  /// In zh, this message translates to:
  /// **'準備同步專案'**
  String get uiPrepareProjectForSync;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:616
  ///
  /// In zh, this message translates to:
  /// **'即時協作只需要記憶體中的有效 Project UUID，不要求先寫入檔案。'**
  String get uiLiveCollaborationRequiresAValidProjectUUIDIn;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:647
  ///
  /// In zh, this message translates to:
  /// **'建立記憶體專案'**
  String get uiCreateInMemoryProject;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:655
  ///
  /// In zh, this message translates to:
  /// **'開啟已儲存文件'**
  String get uiOpenSavedFile;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:662
  ///
  /// In zh, this message translates to:
  /// **'另存為新作品'**
  String get uiSaveAsNewWork;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:698
  ///
  /// In zh, this message translates to:
  /// **'尚未開啟專案。'**
  String get uiNoProjectIsOpen;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:701
  ///
  /// In zh, this message translates to:
  /// **'目前專案尚未儲存到可重新開啟的位置。'**
  String get uiTheCurrentProjectHasNotBeenSavedTo;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:704
  ///
  /// In zh, this message translates to:
  /// **'目前專案仍有未儲存修改。'**
  String get uiTheCurrentProjectHasUnsavedChanges;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:707
  ///
  /// In zh, this message translates to:
  /// **'目前專案沒有有效的 Project UUID。'**
  String get uiTheCurrentProjectHasNoValidProjectUUID;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:712
  ///
  /// In zh, this message translates to:
  /// **'目前專案格式尚不支援 P2P 同步。'**
  String get uiThisProjectFormatDoesNotSupportP2PSync;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:715
  ///
  /// In zh, this message translates to:
  /// **'目前專案仍有尚未解決的同步衝突。'**
  String get uiTheCurrentProjectHasUnresolvedSyncConflicts;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:722
  ///
  /// In zh, this message translates to:
  /// **'服務未開啟'**
  String get uiServiceOff;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:723
  ///
  /// In zh, this message translates to:
  /// **'正在開啟服務'**
  String get uiStartingService;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:724
  ///
  /// In zh, this message translates to:
  /// **'服務中'**
  String get uiServiceRunning;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:725
  ///
  /// In zh, this message translates to:
  /// **'正在停止服務'**
  String get uiStoppingService;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:726
  ///
  /// In zh, this message translates to:
  /// **'服務錯誤'**
  String get uiServiceError;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:742
  ///
  /// In zh, this message translates to:
  /// **'將由對方提供記憶體專案；不必先選擇儲存位置'**
  String get uiThePeerWillProvideAnInMemoryProject;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:745
  ///
  /// In zh, this message translates to:
  /// **'記憶體專案可即時同步；尚未建立 XML checkpoint'**
  String get uiInMemoryProjectReadyForLiveSyncNo;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:747
  ///
  /// In zh, this message translates to:
  /// **'請先建立或開啟一個專案'**
  String get uiCreateOrOpenAProjectFirst;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:751
  ///
  /// In zh, this message translates to:
  /// **'有尚未解決的同步衝突'**
  String get uiUnresolvedSyncConflicts;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:755
  ///
  /// In zh, this message translates to:
  /// **'已儲存；revision 已同步'**
  String get uiSavedRevisionsSynchronized;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:756
  ///
  /// In zh, this message translates to:
  /// **'已儲存；可通知對方同步'**
  String get uiSavedReadyToNotifyThePeer;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:757
  ///
  /// In zh, this message translates to:
  /// **'已儲存；可下載並套用對方版本'**
  String get uiSavedReadyToDownloadAndApplyThePeer;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:758
  ///
  /// In zh, this message translates to:
  /// **'已儲存；可進行欄位級衝突合併'**
  String get uiSavedFieldLevelConflictMergingAvailable;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:759
  ///
  /// In zh, this message translates to:
  /// **'已儲存；等待 revision 協商'**
  String get uiSavedWaitingForRevisionNegotiation;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:760
  ///
  /// In zh, this message translates to:
  /// **'已儲存；等待連線協商與安全配對'**
  String get uiSavedWaitingForConnectionNegotiationAndSecurePairing;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:763
  ///
  /// In zh, this message translates to:
  /// **'同步文件尚未就緒'**
  String get uiSyncProjectIsNotReady;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:768
  ///
  /// In zh, this message translates to:
  /// **'尚未配對'**
  String get uiNotPaired;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:769
  ///
  /// In zh, this message translates to:
  /// **'等待對方建立配對 challenge'**
  String get uiWaitingForThePeerSPairingChallenge;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:770
  ///
  /// In zh, this message translates to:
  /// **'等待人工比對配對碼'**
  String get uiWaitingForManualPairingCodeComparison;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:771
  ///
  /// In zh, this message translates to:
  /// **'已加入本機信任清單'**
  String get uiAddedToThisDeviceSTrustList;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:772
  ///
  /// In zh, this message translates to:
  /// **'本機已確認；等待對方簽章確認'**
  String get uiConfirmedLocallyWaitingForThePeerSSignature;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:773
  ///
  /// In zh, this message translates to:
  /// **'雙端已確認同一配對 transcript'**
  String get uiBothDevicesConfirmedTheSamePairingTranscript;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:774
  ///
  /// In zh, this message translates to:
  /// **'配對錯誤'**
  String get uiPairingError;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:783
  ///
  /// In zh, this message translates to:
  /// **'持久驗證：雙方皆已開啟，配對成功後有效 14 天'**
  String get uiPersistentVerificationEnabledOnBothDevicesValidFor;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:794
  ///
  /// In zh, this message translates to:
  /// **'持久驗證有效至 {p1}；成功連線會再續簽 14 天'**
  String uiPersistentVerificationExpiresEachSuccessfulConnectionRenewsIt(
    String p1,
  );

  /// Application display copy. Source: lib/modules/WelcomeView.dart:795
  ///
  /// In zh, this message translates to:
  /// **'持久驗證已到期；本次需重新確認配對碼'**
  String get uiPersistentVerificationExpiredConfirmThePairingCodeAgain;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:799
  ///
  /// In zh, this message translates to:
  /// **'本機 revision：載入中…'**
  String get uiLocalRevisionLoading;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:801
  ///
  /// In zh, this message translates to:
  /// **'本機 revision：metadata 錯誤'**
  String get uiLocalRevisionMetadataError;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:805
  ///
  /// In zh, this message translates to:
  /// **'本機 revision：尚未建立（成功儲存後建立）'**
  String get uiLocalRevisionNotCreatedYetCreatedAfterA;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:808
  ///
  /// In zh, this message translates to:
  /// **'本機 revision：{p1} 個 concurrent heads'**
  String uiLocalRevisionConcurrentHeads(String p1);

  /// Application display copy. Source: lib/modules/WelcomeView.dart:811
  ///
  /// In zh, this message translates to:
  /// **'本機 revision：{p1}  ·  {p2}'**
  String uiLocalRevision(String p1, String p2);

  /// Application display copy. Source: lib/modules/WelcomeView.dart:816
  ///
  /// In zh, this message translates to:
  /// **'加密通道：尚未建立'**
  String get uiEncryptedChannelNotEstablished;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:817
  ///
  /// In zh, this message translates to:
  /// **'加密通道：正在驗證身分與派生 session key…'**
  String get uiEncryptedChannelVerifyingIdentityAndDerivingASession;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:818
  ///
  /// In zh, this message translates to:
  /// **'加密通道：已驗證並加密'**
  String get uiEncryptedChannelAuthenticatedAndEncrypted;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:819
  ///
  /// In zh, this message translates to:
  /// **'加密通道：建立失敗'**
  String get uiEncryptedChannelConnectionFailed;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:822
  ///
  /// In zh, this message translates to:
  /// **'；revision heads 相同'**
  String get uiRevisionHeadsMatch;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:823
  ///
  /// In zh, this message translates to:
  /// **'；本機 revision 較新'**
  String get uiLocalRevisionIsNewer;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:824
  ///
  /// In zh, this message translates to:
  /// **'；對方 revision 較新'**
  String get uiPeerRevisionIsNewer;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:825
  ///
  /// In zh, this message translates to:
  /// **'；偵測到 concurrent revisions'**
  String get uiConcurrentRevisionsDetected;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:829
  ///
  /// In zh, this message translates to:
  /// **'；snapshot chunk gate 已啟用'**
  String get uiSnapshotChunkValidationEnabled;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:837
  ///
  /// In zh, this message translates to:
  /// **'本機 manifest：尚未建立'**
  String get uiLocalManifestNotCreated;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:838
  ///
  /// In zh, this message translates to:
  /// **'本機 manifest：{p1} bytes／{p2} chunks'**
  String uiLocalManifestBytesChunks(String p1, String p2);

  /// Application display copy. Source: lib/modules/WelcomeView.dart:840
  ///
  /// In zh, this message translates to:
  /// **'對方 manifest：尚未協商'**
  String get uiPeerManifestNotNegotiated;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:841
  ///
  /// In zh, this message translates to:
  /// **'對方 manifest：要求中…'**
  String get uiPeerManifestRequesting;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:843
  ///
  /// In zh, this message translates to:
  /// **'對方 manifest：已驗證（{p1} bytes）'**
  String uiPeerManifestVerifiedBytes(String p1);

  /// Application display copy. Source: lib/modules/WelcomeView.dart:844
  ///
  /// In zh, this message translates to:
  /// **'對方 manifest：目前不可用'**
  String get uiPeerManifestCurrentlyUnavailable;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:845
  ///
  /// In zh, this message translates to:
  /// **'對方 manifest：驗證失敗'**
  String get uiPeerManifestVerificationFailed;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:851
  ///
  /// In zh, this message translates to:
  /// **'Revision DAG：正在交換 graph pages…'**
  String get uiRevisionDAGExchangingGraphPages;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:856
  ///
  /// In zh, this message translates to:
  /// **'Revision DAG：尚未交換完整歷史'**
  String get uiRevisionDAGFullHistoryNotYetExchanged;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:860
  ///
  /// In zh, this message translates to:
  /// **'Revision DAG：遠端 {p1} revisions；{p2} 個 maximal common ancestors；等待 resolve/ACK'**
  String uiRevisionDAGRemoteRevisionsMaximalCommonAncestorsWaiting(
    String p1,
    String p2,
  );

  /// Application display copy. Source: lib/modules/WelcomeView.dart:861
  ///
  /// In zh, this message translates to:
  /// **'Revision DAG：對方已 ACK resolve {p1}'**
  String uiRevisionDAGPeerAcknowledgedResolution(String p1);

  /// Application display copy. Source: lib/modules/WelcomeView.dart:878
  ///
  /// In zh, this message translates to:
  /// **'無法直接開啟連結，已複製到剪貼簿'**
  String get uiCouldNotOpenTheLinkItHasBeen;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1065
  ///
  /// In zh, this message translates to:
  /// **'New Project'**
  String get uiNewProject;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1076
  ///
  /// In zh, this message translates to:
  /// **'Open File'**
  String get uiOpenFile2;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1088
  ///
  /// In zh, this message translates to:
  /// **'Open GitHub Repo for This Project'**
  String get uiOpenThisProjectOnGitHub;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1101
  ///
  /// In zh, this message translates to:
  /// **'Heyairu\'\'s Profile on KadoKado'**
  String get uiHeyairuSKadoKadoProfile;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1126
  ///
  /// In zh, this message translates to:
  /// **'Comment (on Google Forms)'**
  String get uiSendFeedbackGoogleForms;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1139
  ///
  /// In zh, this message translates to:
  /// **'Comment (on GitHub Issues)'**
  String get uiSendFeedbackGitHubIssues;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1215
  ///
  /// In zh, this message translates to:
  /// **'尚無最近開啟檔案'**
  String get uiNoRecentFiles;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1216
  ///
  /// In zh, this message translates to:
  /// **'開啟專案後會顯示在這裡'**
  String get uiProjectsYouOpenWillAppearHere;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1223
  ///
  /// In zh, this message translates to:
  /// **'無可用路徑'**
  String get uiNoUsablePath;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1266
  ///
  /// In zh, this message translates to:
  /// **'從最近清單移除'**
  String get uiRemoveFromRecentProjects;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1290
  ///
  /// In zh, this message translates to:
  /// **'姓名產生器'**
  String get uiNameGenerator;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1300
  ///
  /// In zh, this message translates to:
  /// **'語言'**
  String get uiLanguage;

  /// English-style names
  ///
  /// In zh, this message translates to:
  /// **'英式'**
  String get uiEnglish;

  /// Name generator country option
  ///
  /// In zh, this message translates to:
  /// **'英國'**
  String get uiNameUnitedKingdom;

  /// Name generator country option
  ///
  /// In zh, this message translates to:
  /// **'美國'**
  String get uiNameUnitedStates;

  /// Name generator country option
  ///
  /// In zh, this message translates to:
  /// **'加拿大'**
  String get uiNameCanada;

  /// Name generator country option
  ///
  /// In zh, this message translates to:
  /// **'澳洲'**
  String get uiNameAustralia;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1310
  ///
  /// In zh, this message translates to:
  /// **'日式'**
  String get uiJapanese;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1314
  ///
  /// In zh, this message translates to:
  /// **'中式'**
  String get uiChinese;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1318
  ///
  /// In zh, this message translates to:
  /// **'韓式'**
  String get uiKorean;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1337, lib/features/revision_tracking/application/revision_field_registry.dart:67
  ///
  /// In zh, this message translates to:
  /// **'性別'**
  String get uiGender;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1352
  ///
  /// In zh, this message translates to:
  /// **'男性'**
  String get uiMale;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1357
  ///
  /// In zh, this message translates to:
  /// **'中性'**
  String get uiNeutral;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1361
  ///
  /// In zh, this message translates to:
  /// **'女性'**
  String get uiFemale;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1382
  ///
  /// In zh, this message translates to:
  /// **'生成數'**
  String get uiNumberToGenerate;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1414
  ///
  /// In zh, this message translates to:
  /// **'生成'**
  String get uiGenerate;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1433
  ///
  /// In zh, this message translates to:
  /// **'結果'**
  String get uiResults;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1439
  ///
  /// In zh, this message translates to:
  /// **'複製結果'**
  String get uiCopyResults;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1461
  ///
  /// In zh, this message translates to:
  /// **'按下「生成」來產生姓名'**
  String get uiSelectGenerateToCreateNames;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1492
  ///
  /// In zh, this message translates to:
  /// **'內容同步'**
  String get uiContentSync;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1517
  ///
  /// In zh, this message translates to:
  /// **'完成簽章配對與 authenticated transport 後，可交換加密 revision、manifest 與 snapshot chunks；接收內容只會進入隔離驗證區。'**
  String get uiAfterSignedPairingAndAnAuthenticatedConnectionDevices;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1523
  ///
  /// In zh, this message translates to:
  /// **'本機服務'**
  String get uiLocalService;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1533
  ///
  /// In zh, this message translates to:
  /// **'尚未找到可用 LAN IPv4'**
  String get uiNoUsableLANIPv4AddressFound;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1552
  ///
  /// In zh, this message translates to:
  /// **'重新偵測本機 IP'**
  String get uiDetectLocalIPAgain;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1572
  ///
  /// In zh, this message translates to:
  /// **'本機 Port'**
  String get uiLocalPort;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1590
  ///
  /// In zh, this message translates to:
  /// **'中斷服務'**
  String get uiStopService;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1590
  ///
  /// In zh, this message translates to:
  /// **'開啟服務'**
  String get uiStartService;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1620
  ///
  /// In zh, this message translates to:
  /// **'連線至裝置'**
  String get uiConnectToDevice;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1637
  ///
  /// In zh, this message translates to:
  /// **'對方 IP'**
  String get uiPeerIP;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1638
  ///
  /// In zh, this message translates to:
  /// **'例如 192.168.1.23'**
  String get uiForExample;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1649
  ///
  /// In zh, this message translates to:
  /// **'對方 Port'**
  String get uiPeerPort;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1677
  ///
  /// In zh, this message translates to:
  /// **'端點已驗證'**
  String get uiEndpointVerified;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1679
  ///
  /// In zh, this message translates to:
  /// **'連線中…'**
  String get uiConnecting;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1680
  ///
  /// In zh, this message translates to:
  /// **'連線'**
  String get uiConnect;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1692
  ///
  /// In zh, this message translates to:
  /// **'中斷連線'**
  String get uiDisconnect;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1711
  ///
  /// In zh, this message translates to:
  /// **'裝置身分與配對'**
  String get uiDeviceIdentityAndPairing;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1716
  ///
  /// In zh, this message translates to:
  /// **'本機指紋：{p1}'**
  String uiLocalFingerprint(String p1);

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1716
  ///
  /// In zh, this message translates to:
  /// **'初始化中…'**
  String get uiInitializing;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1729
  ///
  /// In zh, this message translates to:
  /// **'確認模式：單端確認（雙方設定皆已開啟）'**
  String get uiConfirmationOneDeviceEnabledOnBothDevices;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1730
  ///
  /// In zh, this message translates to:
  /// **'確認模式：雙端各自確認（至少一方已關閉單端確認）'**
  String get uiConfirmationBothDevicesOneOrBothDisabledSingle;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1792
  ///
  /// In zh, this message translates to:
  /// **'請確認兩台裝置顯示完全相同的配對碼：'**
  String get uiConfirmBothDevicesDisplayExactlyTheSamePairing;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1806
  ///
  /// In zh, this message translates to:
  /// **'若數字不同請取消配對；任一端確認後，另一端會驗證簽章並自動回簽。'**
  String get uiCancelIfTheCodesDifferAfterEitherDevice;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1807
  ///
  /// In zh, this message translates to:
  /// **'若數字不同請取消配對；目前需兩端各自確認，完成後才會開啟加密內容通道。'**
  String get uiCancelIfTheCodesDifferBothDevicesMust;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1854
  ///
  /// In zh, this message translates to:
  /// **'開始安全配對'**
  String get uiStartSecurePairing;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1868
  ///
  /// In zh, this message translates to:
  /// **'確認配對碼相同'**
  String get uiConfirmCodesMatch;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1882
  ///
  /// In zh, this message translates to:
  /// **'取消配對'**
  String get uiCancelPairing;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1892
  ///
  /// In zh, this message translates to:
  /// **'雙方身分與短期 ECDH key 已綁定至同一 transcript；相同 project session 可交換加密 snapshot chunks，接收後仍須通過 quarantine 驗證。'**
  String get uiBothIdentitiesAndTemporaryECDHKeysAreBound;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1893
  ///
  /// In zh, this message translates to:
  /// **'雙方已簽署同一組 challenge，正在建立 authenticated encrypted transport；建立前不交換 revision summary 或內容。'**
  String get uiBothDevicesSignedTheSameChallengeEstablishingAuthenticated;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1915
  ///
  /// In zh, this message translates to:
  /// **'同步文件'**
  String get uiSyncProject;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1920
  ///
  /// In zh, this message translates to:
  /// **'尚未開啟專案'**
  String get uiNoProjectOpen;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1931
  ///
  /// In zh, this message translates to:
  /// **'對方文件：{p1}'**
  String uiPeerFile(String p1);

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1936
  ///
  /// In zh, this message translates to:
  /// **'對方 UUID：{p1}'**
  String uiPeerUUID(String p1);

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1983
  ///
  /// In zh, this message translates to:
  /// **'更換同步文件'**
  String get uiChangeSyncProject;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1984
  ///
  /// In zh, this message translates to:
  /// **'準備同步文件'**
  String get uiPrepareSyncProject;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1991
  ///
  /// In zh, this message translates to:
  /// **'雙方 revision 並行，必須先進入欄位級衝突處理'**
  String get uiRevisionsDivergedResolveFieldLevelConflictsFirst;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1994
  ///
  /// In zh, this message translates to:
  /// **'透過 authenticated transport 要求接收端下載目前 snapshot'**
  String get uiAskTheReceiverToDownloadTheCurrentSnapshot;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:1995
  ///
  /// In zh, this message translates to:
  /// **'僅接受 authenticated transport 中與目前 session 完全相符的遠端 snapshot'**
  String get uiOnlyAcceptARemoteSnapshotThatExactlyMatches;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:2027
  ///
  /// In zh, this message translates to:
  /// **'正在套用'**
  String get uiApplying;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:2031
  ///
  /// In zh, this message translates to:
  /// **'正在下載'**
  String get uiDownloading;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:2032
  ///
  /// In zh, this message translates to:
  /// **'立即同步'**
  String get uiSyncNow;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:2056
  ///
  /// In zh, this message translates to:
  /// **'比較遠端版本'**
  String get uiCompareRemoteRevision;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:2068
  ///
  /// In zh, this message translates to:
  /// **'取消傳輸'**
  String get uiCancelTransfer;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:502
  ///
  /// In zh, this message translates to:
  /// **'基本資訊'**
  String get uiBasicInformation;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:518, lib/features/revision_tracking/application/revision_field_registry.dart:57
  ///
  /// In zh, this message translates to:
  /// **'書名'**
  String get uiBookTitle;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:519
  ///
  /// In zh, this message translates to:
  /// **'輸入書名'**
  String get uiEnterTheBookTitle;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:530, lib/features/revision_tracking/application/revision_field_registry.dart:58
  ///
  /// In zh, this message translates to:
  /// **'作者'**
  String get uiAuthor;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:531
  ///
  /// In zh, this message translates to:
  /// **'輸入作者名'**
  String get uiEnterTheAuthorSName;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:542
  ///
  /// In zh, this message translates to:
  /// **'主旨'**
  String get uiTheme2;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:543
  ///
  /// In zh, this message translates to:
  /// **'輸入故事主旨'**
  String get uiEnterTheStorySTheme;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:554
  ///
  /// In zh, this message translates to:
  /// **'一句話簡介'**
  String get uiOneLineSummary;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:555
  ///
  /// In zh, this message translates to:
  /// **'輸入一句話簡介'**
  String get uiEnterAOneLineSummary;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:567
  ///
  /// In zh, this message translates to:
  /// **'輸入作品類型'**
  String get uiEnterTheGenre;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:656, lib/features/revision_tracking/application/revision_field_registry.dart:62
  ///
  /// In zh, this message translates to:
  /// **'簡介'**
  String get uiSynopsis;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:675
  ///
  /// In zh, this message translates to:
  /// **'輸入作品簡介'**
  String get uiEnterASynopsis;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:709
  ///
  /// In zh, this message translates to:
  /// **'統計資訊'**
  String get uiStatistics;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:715
  ///
  /// In zh, this message translates to:
  /// **'最後儲存時間'**
  String get uiLastSaved;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:725
  ///
  /// In zh, this message translates to:
  /// **'總字數'**
  String get uiTotalCount;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:725, lib/modules/baseinfoview.dart:729, lib/modules/chapterselectionview.dart:1634
  ///
  /// In zh, this message translates to:
  /// **'{p1} 字'**
  String uiCharacters2(String p1);

  /// Application display copy. Source: lib/modules/baseinfoview.dart:729, lib/presentation/widgets/radial_gauge_dashboard.dart:21
  ///
  /// In zh, this message translates to:
  /// **'本章字數'**
  String get uiChapterCount;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:708
  ///
  /// In zh, this message translates to:
  /// **'資料夾 {p1}'**
  String uiFolder(String p1);

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1045, lib/features/navigation/app_module.dart:65
  ///
  /// In zh, this message translates to:
  /// **'章節選擇'**
  String get uiChapters;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1067
  ///
  /// In zh, this message translates to:
  /// **'全書共 {p1} 字'**
  String uiTotalCharacters(String p1);

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1173
  ///
  /// In zh, this message translates to:
  /// **'資料夾與章節位於同一清單；移除資料夾會一併移除其中章節。'**
  String get uiFoldersAndChaptersShareOneListDeletingA;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1178
  ///
  /// In zh, this message translates to:
  /// **'長按拖曳排序；章節可拖入其他資料夾。根目錄固定隱藏。'**
  String get uiLongPressAndDragToReorderDragChapters;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1186
  ///
  /// In zh, this message translates to:
  /// **'搜尋資料夾或章節名稱'**
  String get uiSearchFolderOrChapterNames;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1191, lib/modules/character_relationship_graph_view.dart:505, lib/modules/palettesview.dart:487
  ///
  /// In zh, this message translates to:
  /// **'清除搜尋'**
  String get uiClearSearch;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1227
  ///
  /// In zh, this message translates to:
  /// **'章節樹'**
  String get uiChapterTree;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1235
  ///
  /// In zh, this message translates to:
  /// **'尚無章節'**
  String get uiNoChapters;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1236
  ///
  /// In zh, this message translates to:
  /// **'請新增第一個資料夾'**
  String get uiAddYourFirstFolder;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1270
  ///
  /// In zh, this message translates to:
  /// **'章節名稱'**
  String get uiChapterName;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1270
  ///
  /// In zh, this message translates to:
  /// **'請先選擇資料夾'**
  String get uiSelectAFolderFirst;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1272
  ///
  /// In zh, this message translates to:
  /// **'子資料夾'**
  String get uiSubfolder;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1272
  ///
  /// In zh, this message translates to:
  /// **'請先選擇父資料夾'**
  String get uiSelectAParentFolderFirst;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1273
  ///
  /// In zh, this message translates to:
  /// **'根資料夾'**
  String get uiRootFolder;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1302
  ///
  /// In zh, this message translates to:
  /// **'新增章節'**
  String get uiAddChapter;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1307
  ///
  /// In zh, this message translates to:
  /// **'新增子資料夾'**
  String get uiAddSubfolder;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1312
  ///
  /// In zh, this message translates to:
  /// **'新增根資料夾'**
  String get uiAddRootFolder;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1339, lib/modules/chapterselectionview.dart:1434
  ///
  /// In zh, this message translates to:
  /// **'（未命名資料夾）'**
  String get uiUnnamedFolder;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1458
  ///
  /// In zh, this message translates to:
  /// **'{p1} 章 • {p2} 個子資料夾 • {p3} 字'**
  String uiChaptersSubfoldersCount(String p1, String p2, String p3);

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1467
  ///
  /// In zh, this message translates to:
  /// **'收合資料夾'**
  String get uiCollapseFolder;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1467
  ///
  /// In zh, this message translates to:
  /// **'展開資料夾'**
  String get uiExpandFolder;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1502
  ///
  /// In zh, this message translates to:
  /// **'刪除此資料夾與其中章節'**
  String get uiDeleteThisFolderAndItsChapters;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1502, lib/modules/chapterselectionview.dart:1659
  ///
  /// In zh, this message translates to:
  /// **'至少須保留一章'**
  String get uiAtLeastOneChapterIsRequired;

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1556
  ///
  /// In zh, this message translates to:
  /// **'章節已移動到「{p1}」'**
  String uiChapterMovedTo(String p1);

  /// Application display copy. Source: lib/modules/chapterselectionview.dart:1659
  ///
  /// In zh, this message translates to:
  /// **'刪除此章節'**
  String get uiDeleteThisChapter;

  /// Application display copy. Source: lib/modules/character_relationship_editor.dart:177
  ///
  /// In zh, this message translates to:
  /// **'來源人物'**
  String get uiSourceCharacter;

  /// Application display copy. Source: lib/modules/character_relationship_editor.dart:203, lib/modules/character_relationship_graph_view.dart:2046
  ///
  /// In zh, this message translates to:
  /// **'目標人物'**
  String get uiTargetCharacter;

  /// Application display copy. Source: lib/modules/character_relationship_editor.dart:204
  ///
  /// In zh, this message translates to:
  /// **'選擇現有人物或輸入新人物名稱'**
  String get uiSelectAnExistingCharacterOrEnterANew;

  /// Application display copy. Source: lib/modules/character_relationship_editor.dart:212, lib/modules/character_relationship_graph_view.dart:440, lib/modules/characterview.dart:4772
  ///
  /// In zh, this message translates to:
  /// **'外在關係'**
  String get uiExternalRelationship;

  /// Application display copy. Source: lib/modules/character_relationship_editor.dart:213
  ///
  /// In zh, this message translates to:
  /// **'例如：朋友、家人、競爭對手'**
  String get uiForExampleFriendFamilyRival;

  /// Application display copy. Source: lib/modules/character_relationship_editor.dart:221, lib/modules/character_relationship_graph_view.dart:436, lib/modules/characterview.dart:4773
  ///
  /// In zh, this message translates to:
  /// **'內在關係'**
  String get uiInternalRelationship;

  /// Application display copy. Source: lib/modules/character_relationship_editor.dart:222
  ///
  /// In zh, this message translates to:
  /// **'例如：信任、崇拜、嫉妒'**
  String get uiForExampleTrustAdmirationEnvy;

  /// Application display copy. Source: lib/modules/character_relationship_editor.dart:233
  ///
  /// In zh, this message translates to:
  /// **'雙向關係'**
  String get uiBidirectionalRelationship;

  /// Application display copy. Source: lib/modules/character_relationship_editor.dart:234
  ///
  /// In zh, this message translates to:
  /// **'同時建立目標人物指回來源人物的關係'**
  String get uiAlsoCreateARelationshipFromTheTargetBack;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:337
  ///
  /// In zh, this message translates to:
  /// **'尚無人物資料'**
  String get uiNoCharactersYet;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:339
  ///
  /// In zh, this message translates to:
  /// **'請先到角色設定新增人物，再回來建立與查看關係。'**
  String get uiAddCharactersInCharacterSettingsBeforeCreatingAnd;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:352
  ///
  /// In zh, this message translates to:
  /// **'最小化時間軸與快照'**
  String get uiMinimizeTimelineAndSnapshots;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:367
  ///
  /// In zh, this message translates to:
  /// **'歷史預覽唯讀；每位角色採用此 Tick 前的有效變更。切回預設資料可編輯。'**
  String get uiHistoricalPreviewsAreReadOnlyEachCharacterUses;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:405, lib/features/navigation/app_module.dart:75
  ///
  /// In zh, this message translates to:
  /// **'關係設定'**
  String get uiCharacterRelationships;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:410
  ///
  /// In zh, this message translates to:
  /// **'收合工具列'**
  String get uiCollapseToolbar;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:410
  ///
  /// In zh, this message translates to:
  /// **'展開工具列'**
  String get uiExpandToolbar;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:420
  ///
  /// In zh, this message translates to:
  /// **'啟用快照'**
  String get uiEnableSnapshots;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:422
  ///
  /// In zh, this message translates to:
  /// **'顯示快照 Card'**
  String get uiShowSnapshotCards;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:423
  ///
  /// In zh, this message translates to:
  /// **'關閉快照'**
  String get uiCloseSnapshots;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:432
  ///
  /// In zh, this message translates to:
  /// **'顯示關係'**
  String get uiShowRelationships;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:455
  ///
  /// In zh, this message translates to:
  /// **'角色排列'**
  String get uiArrangeCharacters;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:459
  ///
  /// In zh, this message translates to:
  /// **'角色定位'**
  String get uiLocateCharacter;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:463
  ///
  /// In zh, this message translates to:
  /// **'關係群集'**
  String get uiRelationshipClusters;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:470
  ///
  /// In zh, this message translates to:
  /// **'外在 ━   內在 ┄   拖曳角色可調整位置'**
  String get uiExternalInternalDragCharactersToReposition;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:499
  ///
  /// In zh, this message translates to:
  /// **'搜尋或選擇人物'**
  String get uiSearchOrSelectCharacter;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:516
  ///
  /// In zh, this message translates to:
  /// **'搜尋並聚焦'**
  String get uiSearchAndFocus;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:573
  ///
  /// In zh, this message translates to:
  /// **'只顯示一階鄰居'**
  String get uiShowDirectNeighborsOnly;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:582
  ///
  /// In zh, this message translates to:
  /// **'先選擇角色'**
  String get uiSelectACharacterFirst;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:587
  ///
  /// In zh, this message translates to:
  /// **'全局預覽'**
  String get uiOverview;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:592, lib/modules/character_relationship_graph_view.dart:1353
  ///
  /// In zh, this message translates to:
  /// **'新增關係'**
  String get uiAddRelationship;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:598
  ///
  /// In zh, this message translates to:
  /// **'歷史預覽唯讀'**
  String get uiHistoricalPreviewIsReadOnly;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:601
  ///
  /// In zh, this message translates to:
  /// **'自動重新排列'**
  String get uiRearrangeAutomatically;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:606
  ///
  /// In zh, this message translates to:
  /// **'重設縮放'**
  String get uiResetZoom;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:611, lib/presentation/widgets/snapshot_timeline_preview.dart:484
  ///
  /// In zh, this message translates to:
  /// **'縮小'**
  String get uiZoomOut;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:616, lib/presentation/widgets/snapshot_timeline_preview.dart:491
  ///
  /// In zh, this message translates to:
  /// **'放大'**
  String get uiZoomIn;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:622
  ///
  /// In zh, this message translates to:
  /// **'合併相同的雙向關係'**
  String get uiMergeIdenticalBidirectionalRelationships;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:742
  ///
  /// In zh, this message translates to:
  /// **'找不到符合的人物'**
  String get uiNoMatchingCharacters;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:956
  ///
  /// In zh, this message translates to:
  /// **'目前沒有關係；可在此新增，或回到角色設定編輯。'**
  String get uiNoRelationshipsYetAddOneHereOrEdit;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:962, lib/modules/characterview.dart:4887, lib/modules/characterview.dart:5141
  ///
  /// In zh, this message translates to:
  /// **'新增'**
  String get commonAdd;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1174
  ///
  /// In zh, this message translates to:
  /// **'{p1} 與 {p2}'**
  String uiAnd(String p1, String p2);

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1181
  ///
  /// In zh, this message translates to:
  /// **'開啟人物編輯'**
  String get uiOpenCharacterEditor;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1195
  ///
  /// In zh, this message translates to:
  /// **'收合詳細資料'**
  String get uiCollapseDetails;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1195
  ///
  /// In zh, this message translates to:
  /// **'展開詳細資料'**
  String get uiExpandDetails;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1228
  ///
  /// In zh, this message translates to:
  /// **'此名稱目前無法唯一對應到人物資料。請選取連線進行修正。'**
  String get uiThisNameDoesNotUniquelyIdentifyACharacter;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1246
  ///
  /// In zh, this message translates to:
  /// **'職業：{p1}'**
  String uiOccupation(String p1);

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1247
  ///
  /// In zh, this message translates to:
  /// **'年齡：{p1}'**
  String uiAge(String p1);

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1248
  ///
  /// In zh, this message translates to:
  /// **'性別：{p1}'**
  String uiGender2(String p1);

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1268, lib/modules/characterview.dart:2902
  ///
  /// In zh, this message translates to:
  /// **'所屬組織'**
  String get uiOrganizations;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1312
  ///
  /// In zh, this message translates to:
  /// **'相鄰關係：{p1}'**
  String uiAdjacentRelationships(String p1);

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1319
  ///
  /// In zh, this message translates to:
  /// **'解除釘選'**
  String get uiUnpin;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1320
  ///
  /// In zh, this message translates to:
  /// **'釘選位置'**
  String get uiPinPosition;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1325
  ///
  /// In zh, this message translates to:
  /// **'釘選位置與其他釘選角色重疊，可拖曳調整。'**
  String get uiThisPinnedPositionOverlapsAnotherPinnedCharacterDrag;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1360, lib/modules/character_relationship_graph_view.dart:1722, lib/modules/character_relationship_graph_view.dart:1763
  ///
  /// In zh, this message translates to:
  /// **'建立目標人物'**
  String get uiCreateTargetCharacter;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1394
  ///
  /// In zh, this message translates to:
  /// **'目前顯示：{p1}'**
  String uiShowing(String p1);

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1397, lib/modules/character_relationship_graph_mapper.dart:88
  ///
  /// In zh, this message translates to:
  /// **'外在'**
  String get uiExternal;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1398, lib/modules/character_relationship_graph_mapper.dart:88
  ///
  /// In zh, this message translates to:
  /// **'內在'**
  String get uiInternal;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1405
  ///
  /// In zh, this message translates to:
  /// **'顯示全部關係'**
  String get uiShowAllRelationships;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1420
  ///
  /// In zh, this message translates to:
  /// **'有多位同名人物，請編輯並選擇含 NanoID 的人物。'**
  String get uiSeveralCharactersShareThisNameEditAndSelect;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1421
  ///
  /// In zh, this message translates to:
  /// **'找不到對應人物，可修正名稱或建立新人物。'**
  String get uiNoMatchingCharacterCorrectTheNameOrCreate;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1430
  ///
  /// In zh, this message translates to:
  /// **'建立人物'**
  String get uiCreateCharacter;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1468
  ///
  /// In zh, this message translates to:
  /// **'編輯'**
  String get uiEdit;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1474
  ///
  /// In zh, this message translates to:
  /// **'修正目標人物'**
  String get uiCorrectTargetCharacter;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1484
  ///
  /// In zh, this message translates to:
  /// **'刪除{p1}'**
  String uiDelete(String p1);

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1494
  ///
  /// In zh, this message translates to:
  /// **'刪除此方向全部關係'**
  String get uiDeleteAllRelationshipsInThisDirection;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1521, lib/modules/character_relationship_graph_view.dart:1625, lib/modules/character_relationship_graph_view.dart:1752
  ///
  /// In zh, this message translates to:
  /// **'關係已變更，請重新選取後再操作。'**
  String get uiTheRelationshipChangedSelectItAgainBeforeContinuing;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1539
  ///
  /// In zh, this message translates to:
  /// **'{p1} → {p2} · 編輯{p3}關係'**
  String uiEditRelationship(String p1, String p2, String p3);

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1540
  ///
  /// In zh, this message translates to:
  /// **'{p1}關係'**
  String uiRelationship(String p1);

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1562
  ///
  /// In zh, this message translates to:
  /// **'刪除人物關係'**
  String get uiDeleteCharacterRelationship;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1564
  ///
  /// In zh, this message translates to:
  /// **'確定刪除此方向的外在與內在關係？反向關係會保留。'**
  String get uiDeleteBothExternalAndInternalRelationshipsInThis;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1565
  ///
  /// In zh, this message translates to:
  /// **'確定刪除此方向的{p1}關係「{p2}」？另一類型與反向關係會保留。'**
  String uiDeleteTheRelationshipInThisDirectionOtherTypes(String p1, String p2);

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1609
  ///
  /// In zh, this message translates to:
  /// **'請從清單選擇能唯一對應的現有人物。'**
  String get uiSelectAnExistingCharacterThatCanBeUniquely;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1669
  ///
  /// In zh, this message translates to:
  /// **'有多位同名人物，請從清單選擇含 NanoID 的人物'**
  String get uiSeveralCharactersShareThisNameSelectOneWith;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1723
  ///
  /// In zh, this message translates to:
  /// **'建立後，這筆關係會依人物名稱自動連結。'**
  String get uiAfterCreationThisRelationshipWillLinkAutomaticallyBy;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1724, lib/modules/character_relationship_graph_view.dart:1765
  ///
  /// In zh, this message translates to:
  /// **'人物名稱'**
  String get uiCharacterName;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1764
  ///
  /// In zh, this message translates to:
  /// **'新人物建立後，會同時新增由目前人物指向他的關係。'**
  String get uiCreatingTheCharacterAlsoAddsARelationshipFrom;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1766
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get uiNext2;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:1788
  ///
  /// In zh, this message translates to:
  /// **'設定新人物關係'**
  String get uiSetUpNewCharacterRelationship;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:2040
  ///
  /// In zh, this message translates to:
  /// **'修正此方向的目標人物'**
  String get uiCorrectTheTargetInThisDirection;

  /// Application display copy. Source: lib/modules/character_relationship_graph_view.dart:2048
  ///
  /// In zh, this message translates to:
  /// **'選擇現有人物；內外關係將一起移至該人物'**
  String get uiSelectAnExistingCharacterBothRelationshipTypesMove;

  /// Application display copy. Source: lib/modules/characterview.dart:2443
  ///
  /// In zh, this message translates to:
  /// **'角色編輯'**
  String get uiCharacterEditor;

  /// Application display copy. Source: lib/modules/characterview.dart:2467, lib/modules/characterview.dart:2478
  ///
  /// In zh, this message translates to:
  /// **'角色列表'**
  String get uiCharacterList;

  /// Application display copy. Source: lib/modules/characterview.dart:2472
  ///
  /// In zh, this message translates to:
  /// **'角色名稱'**
  String get uiCharacterName2;

  /// Application display copy. Source: lib/modules/characterview.dart:2483
  ///
  /// In zh, this message translates to:
  /// **'尚無角色'**
  String get uiNoCharacters;

  /// Application display copy. Source: lib/modules/characterview.dart:2484
  ///
  /// In zh, this message translates to:
  /// **'請新增第一個角色'**
  String get uiAddYourFirstCharacter;

  /// Application display copy. Source: lib/modules/characterview.dart:2515
  ///
  /// In zh, this message translates to:
  /// **'角色類型：{p1}'**
  String uiCharacterType(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:2607
  ///
  /// In zh, this message translates to:
  /// **'請選取一個角色'**
  String get uiSelectACharacter;

  /// Application display copy. Source: lib/modules/characterview.dart:2608
  ///
  /// In zh, this message translates to:
  /// **'從左側列表選擇要編輯的角色'**
  String get uiSelectACharacterFromTheListOnThe;

  /// Application display copy. Source: lib/modules/characterview.dart:2625
  ///
  /// In zh, this message translates to:
  /// **'角色卡'**
  String get uiCharacterCard;

  /// Application display copy. Source: lib/modules/characterview.dart:2626, lib/modules/characterview.dart:4029
  ///
  /// In zh, this message translates to:
  /// **'自訂資料'**
  String get uiCustomData;

  /// Application display copy. Source: lib/modules/characterview.dart:2627, lib/modules/characterview.dart:2693
  ///
  /// In zh, this message translates to:
  /// **'進階設定'**
  String get uiAdvancedSettings;

  /// Application display copy. Source: lib/modules/characterview.dart:2658, lib/modules/itemview.dart:1486, lib/modules/itemview.dart:1687
  ///
  /// In zh, this message translates to:
  /// **'新增快照'**
  String get uiAddSnapshot;

  /// Application display copy. Source: lib/modules/characterview.dart:2665, lib/modules/characterview.dart:3263, lib/modules/itemview.dart:1486
  ///
  /// In zh, this message translates to:
  /// **'複製快照'**
  String get uiDuplicateSnapshot;

  /// Application display copy. Source: lib/modules/characterview.dart:2668, lib/presentation/widgets/radial_gauge_dashboard.dart:268, lib/presentation/widgets/writing_goal_dialog.dart:149
  ///
  /// In zh, this message translates to:
  /// **'預設'**
  String get uiDefault;

  /// Application display copy. Source: lib/modules/characterview.dart:2674, lib/modules/characterview.dart:3277, lib/presentation/widgets/snapshot_timeline_preview.dart:304
  ///
  /// In zh, this message translates to:
  /// **'刪除快照'**
  String get uiDeleteSnapshot;

  /// Application display copy. Source: lib/modules/characterview.dart:2680
  ///
  /// In zh, this message translates to:
  /// **'預設快照不可刪除'**
  String get uiTheDefaultSnapshotCannotBeDeleted;

  /// Application display copy. Source: lib/modules/characterview.dart:2794
  ///
  /// In zh, this message translates to:
  /// **'基本識別'**
  String get uiBasicIdentity;

  /// Application display copy. Source: lib/modules/characterview.dart:2796
  ///
  /// In zh, this message translates to:
  /// **'姓名（必填）：'**
  String get uiNameRequired;

  /// Application display copy. Source: lib/modules/characterview.dart:2797
  ///
  /// In zh, this message translates to:
  /// **'身份／職業：'**
  String get uiRoleOccupation;

  /// Application display copy. Source: lib/modules/characterview.dart:2799
  ///
  /// In zh, this message translates to:
  /// **'年齡：'**
  String get uiAge2;

  /// Application display copy. Source: lib/modules/characterview.dart:2800
  ///
  /// In zh, this message translates to:
  /// **'性別：'**
  String get uiGender3;

  /// Application display copy. Source: lib/modules/characterview.dart:2801
  ///
  /// In zh, this message translates to:
  /// **'生日：'**
  String get uiBirthday;

  /// Application display copy. Source: lib/modules/characterview.dart:2825
  ///
  /// In zh, this message translates to:
  /// **'角色類型'**
  String get uiCharacterType2;

  /// Application display copy. Source: lib/modules/characterview.dart:2832
  ///
  /// In zh, this message translates to:
  /// **'外觀摘要'**
  String get uiAppearanceSummary;

  /// Application display copy. Source: lib/modules/characterview.dart:2833
  ///
  /// In zh, this message translates to:
  /// **'紀錄角色大致外觀。'**
  String get uiDescribeTheCharacterSGeneralAppearance;

  /// Application display copy. Source: lib/modules/characterview.dart:2836
  ///
  /// In zh, this message translates to:
  /// **'身高：'**
  String get uiHeight;

  /// Application display copy. Source: lib/modules/characterview.dart:2837
  ///
  /// In zh, this message translates to:
  /// **'體重：'**
  String get uiWeight;

  /// Application display copy. Source: lib/modules/characterview.dart:2838
  ///
  /// In zh, this message translates to:
  /// **'髮色：'**
  String get uiHairColor;

  /// Application display copy. Source: lib/modules/characterview.dart:2839
  ///
  /// In zh, this message translates to:
  /// **'瞳色：'**
  String get uiEyeColor;

  /// Application display copy. Source: lib/modules/characterview.dart:2840
  ///
  /// In zh, this message translates to:
  /// **'外觀摘要：'**
  String get uiAppearanceSummary2;

  /// Application display copy. Source: lib/modules/characterview.dart:2849
  ///
  /// In zh, this message translates to:
  /// **'性格與故事核心'**
  String get uiPersonalityAndStoryCore;

  /// Application display copy. Source: lib/modules/characterview.dart:2851
  ///
  /// In zh, this message translates to:
  /// **'紀錄角色個性，以及在故事中遇到的困難。'**
  String get uiDescribeTheCharacterSPersonalityAndTheChallenges;

  /// Application display copy. Source: lib/modules/characterview.dart:2854
  ///
  /// In zh, this message translates to:
  /// **'個性：'**
  String get uiPersonality;

  /// Application display copy. Source: lib/modules/characterview.dart:2856
  ///
  /// In zh, this message translates to:
  /// **'說話風格：'**
  String get uiSpeechStyle;

  /// Application display copy. Source: lib/modules/characterview.dart:2857
  ///
  /// In zh, this message translates to:
  /// **'動機：'**
  String get uiMotivation;

  /// Application display copy. Source: lib/modules/characterview.dart:2858
  ///
  /// In zh, this message translates to:
  /// **'目標：'**
  String get uiGoal;

  /// Application display copy. Source: lib/modules/characterview.dart:2859
  ///
  /// In zh, this message translates to:
  /// **'價值觀與信念：'**
  String get uiValuesAndBeliefs;

  /// Application display copy. Source: lib/modules/characterview.dart:2860
  ///
  /// In zh, this message translates to:
  /// **'恐懼：'**
  String get uiFear;

  /// Application display copy. Source: lib/modules/characterview.dart:2863
  ///
  /// In zh, this message translates to:
  /// **'阻礙與解決方式'**
  String get uiObstaclesAndResolutions;

  /// Application display copy. Source: lib/modules/characterview.dart:2865
  ///
  /// In zh, this message translates to:
  /// **'阻礙事件'**
  String get uiObstacle;

  /// Application display copy. Source: lib/modules/characterview.dart:2866
  ///
  /// In zh, this message translates to:
  /// **'解決方式'**
  String get uiResolution;

  /// Application display copy. Source: lib/modules/characterview.dart:2867
  ///
  /// In zh, this message translates to:
  /// **'在下方輸入事件與解決方式後新增'**
  String get uiEnterAnObstacleAndResolutionBelowThenAdd;

  /// Application display copy. Source: lib/modules/characterview.dart:2893
  ///
  /// In zh, this message translates to:
  /// **'人物關係描述'**
  String get uiCharacterRelationships2;

  /// Application display copy. Source: lib/modules/characterview.dart:2894
  ///
  /// In zh, this message translates to:
  /// **'描述角色與其他人的連結。'**
  String get uiDescribeTheCharacterSConnectionsWithOthers;

  /// Application display copy. Source: lib/modules/characterview.dart:2897
  ///
  /// In zh, this message translates to:
  /// **'人物關係簡述：'**
  String get uiRelationshipSummary;

  /// Application display copy. Source: lib/modules/characterview.dart:2904, lib/modules/characterview.dart:2918
  ///
  /// In zh, this message translates to:
  /// **'組織'**
  String get uiOrganization;

  /// Application display copy. Source: lib/modules/characterview.dart:2905
  ///
  /// In zh, this message translates to:
  /// **'身分／職位'**
  String get uiPositionTitle;

  /// Application display copy. Source: lib/modules/characterview.dart:2906
  ///
  /// In zh, this message translates to:
  /// **'在下方輸入組織與身分或職位後新增'**
  String get uiEnterAnOrganizationAndPositionBelowThenAdd;

  /// Application display copy. Source: lib/modules/characterview.dart:2914, lib/modules/characterview.dart:2919
  ///
  /// In zh, this message translates to:
  /// **'選擇地點或組織，或自行輸入'**
  String get uiSelectALocationOrOrganizationOrEnterYour;

  /// Application display copy. Source: lib/modules/characterview.dart:2975, lib/modules/characterview.dart:2980
  ///
  /// In zh, this message translates to:
  /// **'角色狀態'**
  String get uiCharacterStatus;

  /// Application display copy. Source: lib/modules/characterview.dart:2976
  ///
  /// In zh, this message translates to:
  /// **'角色的大致狀態。'**
  String get uiDescribeTheCharacterSGeneralState;

  /// Application display copy. Source: lib/modules/characterview.dart:2984
  ///
  /// In zh, this message translates to:
  /// **'在下方輸入狀態與說明後新增'**
  String get uiEnterAStatusAndDescriptionBelowThenAdd;

  /// Application display copy. Source: lib/modules/characterview.dart:3036
  ///
  /// In zh, this message translates to:
  /// **'備註：'**
  String get uiNotes2;

  /// Application display copy. Source: lib/modules/characterview.dart:3046
  ///
  /// In zh, this message translates to:
  /// **'請先選取角色'**
  String get uiSelectACharacterFirst2;

  /// Application display copy. Source: lib/modules/characterview.dart:3047
  ///
  /// In zh, this message translates to:
  /// **'選取角色後即可預覽時間軸與管理快照'**
  String get uiSelectACharacterToPreviewTheTimelineAnd;

  /// Application display copy. Source: lib/modules/characterview.dart:3093
  ///
  /// In zh, this message translates to:
  /// **'故事狀態 · 編輯中：預設資料'**
  String get uiStoryStateEditingDefaultData;

  /// Application display copy. Source: lib/modules/characterview.dart:3094
  ///
  /// In zh, this message translates to:
  /// **'故事狀態 · Tick {p1} · {p2}'**
  String uiStoryStateTick(String p1, String p2);

  /// Application display copy. Source: lib/modules/characterview.dart:3094
  ///
  /// In zh, this message translates to:
  /// **'唯讀預覽；已開啟跟隨時間軸。'**
  String get uiReadOnlyPreviewFollowingTheTimeline;

  /// Application display copy. Source: lib/modules/characterview.dart:3094, lib/modules/itemview.dart:2452, lib/modules/itemview.dart:2618
  ///
  /// In zh, this message translates to:
  /// **'編輯中：{p1}'**
  String uiEditing(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3104
  ///
  /// In zh, this message translates to:
  /// **'正在編輯 Scene 快照：阻礙、人物關係、組織、角色狀態、擁有物品與自訂欄位可修改；其餘固定資料已鎖定。'**
  String get uiEditingASceneSnapshotObstaclesRelationshipsOrganizationsStatus;

  /// Application display copy. Source: lib/modules/characterview.dart:3137, lib/modules/characterview.dart:3146
  ///
  /// In zh, this message translates to:
  /// **'預設資料'**
  String get uiDefaultData;

  /// Application display copy. Source: lib/modules/characterview.dart:3138, lib/modules/characterview.dart:3811
  ///
  /// In zh, this message translates to:
  /// **'目前播放頭狀態'**
  String get uiStateAtPlayhead;

  /// Application display copy. Source: lib/modules/characterview.dart:3147
  ///
  /// In zh, this message translates to:
  /// **'目前 Tick {p1}'**
  String uiCurrentTick(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3150
  ///
  /// In zh, this message translates to:
  /// **'複製目前狀態'**
  String get uiCopyCurrentState;

  /// Application display copy. Source: lib/modules/characterview.dart:3173
  ///
  /// In zh, this message translates to:
  /// **'預設物品配置'**
  String get uiDefaultItemAssignments;

  /// Application display copy. Source: lib/modules/characterview.dart:3174
  ///
  /// In zh, this message translates to:
  /// **'Tick {p1} 的物品配置'**
  String uiItemAssignmentsAtTick(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3187
  ///
  /// In zh, this message translates to:
  /// **'所有快照'**
  String get uiAllSnapshots;

  /// Application display copy. Source: lib/modules/characterview.dart:3189
  ///
  /// In zh, this message translates to:
  /// **'共 {p1} 筆（含預設）'**
  String uiTotalIncludingDefault(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3195
  ///
  /// In zh, this message translates to:
  /// **'快照歷程與編輯'**
  String get uiSnapshotHistoryAndEditing;

  /// Application display copy. Source: lib/modules/characterview.dart:3224
  ///
  /// In zh, this message translates to:
  /// **'預設快照（故事開始前）'**
  String get uiDefaultSnapshotBeforeTheStory;

  /// Application display copy. Source: lib/modules/characterview.dart:3231
  ///
  /// In zh, this message translates to:
  /// **'Scene 尚未排定或主要 placement 已失效'**
  String get uiTheSceneIsUnscheduledOrItsPrimaryPlacement;

  /// Application display copy. Source: lib/modules/characterview.dart:3232
  ///
  /// In zh, this message translates to:
  /// **'Fallback Tick'**
  String get uiFallbackTick;

  /// Application display copy. Source: lib/modules/characterview.dart:3241
  ///
  /// In zh, this message translates to:
  /// **'變更：{p1}'**
  String uiChanges2(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3247
  ///
  /// In zh, this message translates to:
  /// **'備註：{p1}'**
  String uiNotes3(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3259, lib/modules/characterview.dart:3821
  ///
  /// In zh, this message translates to:
  /// **'預設快照'**
  String get uiDefaultSnapshot;

  /// Application display copy. Source: lib/modules/characterview.dart:3269
  ///
  /// In zh, this message translates to:
  /// **'定位快照'**
  String get uiLocateSnapshot;

  /// Application display copy. Source: lib/modules/characterview.dart:3274
  ///
  /// In zh, this message translates to:
  /// **'編輯快照'**
  String get uiEditSnapshot;

  /// Application display copy. Source: lib/modules/characterview.dart:3327
  ///
  /// In zh, this message translates to:
  /// **'刪除快照？'**
  String get uiDeleteSnapshot2;

  /// Application display copy. Source: lib/modules/characterview.dart:3328
  ///
  /// In zh, this message translates to:
  /// **'刪除後，這個 Scene 之後的角色狀態會重新推導。'**
  String get uiDeletingThisSnapshotRecalculatesTheCharacterSState;

  /// Application display copy. Source: lib/modules/characterview.dart:3356
  ///
  /// In zh, this message translates to:
  /// **'{p1}已鎖定'**
  String uiIsLocked(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3357
  ///
  /// In zh, this message translates to:
  /// **'Scene 快照只允許修改五組角色 Table 與自訂欄位；切回「預設」即可編輯固定資料。'**
  String get uiSceneSnapshotsAllowChangesOnlyToTheFive;

  /// Application display copy. Source: lib/modules/characterview.dart:3428
  ///
  /// In zh, this message translates to:
  /// **'中箱：{p1}'**
  String uiEvent2(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3429
  ///
  /// In zh, this message translates to:
  /// **'此中箱尚無小箱；新 Scene 會建立在這個中箱中。'**
  String get uiThisEventHasNoScenesYetANew;

  /// Application display copy. Source: lib/modules/characterview.dart:3439
  ///
  /// In zh, this message translates to:
  /// **'大箱：{p1}'**
  String uiStoryline(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3440
  ///
  /// In zh, this message translates to:
  /// **'找不到指定中箱；新中箱會建立在這個大箱中。'**
  String get uiTheSpecifiedEventWasNotFoundANew;

  /// Application display copy. Source: lib/modules/characterview.dart:3450
  ///
  /// In zh, this message translates to:
  /// **'全域預覽'**
  String get uiGlobalPreview;

  /// Application display copy. Source: lib/modules/characterview.dart:3451
  ///
  /// In zh, this message translates to:
  /// **'找不到指定大箱；將建立新的大箱、中箱與 Scene。'**
  String get uiTheSpecifiedStorylineWasNotFoundANew;

  /// Application display copy. Source: lib/modules/characterview.dart:3588
  ///
  /// In zh, this message translates to:
  /// **'角色快照'**
  String get uiCharacterSnapshot;

  /// Application display copy. Source: lib/modules/characterview.dart:3593
  ///
  /// In zh, this message translates to:
  /// **'角色快照 Scene'**
  String get uiCharacterSnapshotScene;

  /// Application display copy. Source: lib/modules/characterview.dart:3595
  ///
  /// In zh, this message translates to:
  /// **'新 Scene'**
  String get uiNewScene;

  /// Application display copy. Source: lib/modules/characterview.dart:3643, lib/modules/itemview.dart:2160, lib/modules/itemview.dart:2344
  ///
  /// In zh, this message translates to:
  /// **'新增 Scene 快照'**
  String get uiAddSceneSnapshot;

  /// Application display copy. Source: lib/modules/characterview.dart:3643
  ///
  /// In zh, this message translates to:
  /// **'複製 {p1}'**
  String uiDuplicate(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3663, lib/modules/itemview.dart:669, lib/modules/itemview.dart:1385
  ///
  /// In zh, this message translates to:
  /// **'綁定 Scene'**
  String get uiLinkToScene;

  /// Application display copy. Source: lib/modules/characterview.dart:3673
  ///
  /// In zh, this message translates to:
  /// **'＋ 快速建立新 Scene'**
  String get uiQuickCreateScene;

  /// Application display copy. Source: lib/modules/characterview.dart:3698
  ///
  /// In zh, this message translates to:
  /// **'Scene 階層'**
  String get uiSceneHierarchy;

  /// Application display copy. Source: lib/modules/characterview.dart:3713
  ///
  /// In zh, this message translates to:
  /// **'大箱（可選既有或輸入新名稱）'**
  String get uiStorylineSelectExistingOrEnterAName;

  /// Application display copy. Source: lib/modules/characterview.dart:3714, lib/modules/timelineview.dart:954
  ///
  /// In zh, this message translates to:
  /// **'例如：第一幕'**
  String get uiForExampleActOne;

  /// Application display copy. Source: lib/modules/characterview.dart:3753
  ///
  /// In zh, this message translates to:
  /// **'中箱（可選既有或輸入新名稱）'**
  String get uiEventSelectExistingOrEnterAName;

  /// Application display copy. Source: lib/modules/characterview.dart:3754
  ///
  /// In zh, this message translates to:
  /// **'例如：城門衝突'**
  String get uiForExampleConflictAtTheGate;

  /// Application display copy. Source: lib/modules/characterview.dart:3762
  ///
  /// In zh, this message translates to:
  /// **'小箱（Scene 名稱）'**
  String get uiSceneName;

  /// Application display copy. Source: lib/modules/characterview.dart:3763
  ///
  /// In zh, this message translates to:
  /// **'例如：抵達城門'**
  String get uiForExampleArrivingAtTheGate;

  /// Application display copy. Source: lib/modules/characterview.dart:3780
  ///
  /// In zh, this message translates to:
  /// **'時間軸 Tick'**
  String get uiTimelineTick;

  /// Application display copy. Source: lib/modules/characterview.dart:3782
  ///
  /// In zh, this message translates to:
  /// **'可輸入 {p1}～+{p2}，或在上方時間軸點擊／拖動 Scrubber。'**
  String uiEnterToOrClickOrDragTheScrubber(String p1, String p2);

  /// Application display copy. Source: lib/modules/characterview.dart:3793, lib/modules/characterview.dart:3862
  ///
  /// In zh, this message translates to:
  /// **'Tick 必須介於 {p1}～+{p2}。'**
  String uiTickMustBeBetweenAnd(String p1, String p2);

  /// Application display copy. Source: lib/modules/characterview.dart:3806
  ///
  /// In zh, this message translates to:
  /// **'初始內容'**
  String get uiInitialContent;

  /// Application display copy. Source: lib/modules/characterview.dart:3808
  ///
  /// In zh, this message translates to:
  /// **'空白狀態'**
  String get uiEmptyState;

  /// Application display copy. Source: lib/modules/characterview.dart:3831
  ///
  /// In zh, this message translates to:
  /// **'複製來源：{p1}'**
  String uiCopyFrom(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3831
  ///
  /// In zh, this message translates to:
  /// **'指定快照'**
  String get uiSpecificSnapshot;

  /// Application display copy. Source: lib/modules/characterview.dart:3832
  ///
  /// In zh, this message translates to:
  /// **'會複製來源當下的完整推導狀態。'**
  String get uiCopiesTheCompleteDerivedStateAtTheSource;

  /// Application display copy. Source: lib/modules/characterview.dart:3871
  ///
  /// In zh, this message translates to:
  /// **'請填寫大箱、中箱與小箱名稱。'**
  String get uiEnterNamesForTheStorylineEventAndScene;

  /// Application display copy. Source: lib/modules/characterview.dart:3878
  ///
  /// In zh, this message translates to:
  /// **'建立快照'**
  String get uiCreateSnapshot;

  /// Application display copy. Source: lib/modules/characterview.dart:3938
  ///
  /// In zh, this message translates to:
  /// **'複製自 {p1}'**
  String uiCopiedFrom(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3952
  ///
  /// In zh, this message translates to:
  /// **'已新增 Scene 快照'**
  String get uiSceneSnapshotAdded;

  /// Application display copy. Source: lib/modules/characterview.dart:3965
  ///
  /// In zh, this message translates to:
  /// **'已定位至 Tick {p1}'**
  String uiMovedToTick(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:3973
  ///
  /// In zh, this message translates to:
  /// **'識別設定'**
  String get uiIdentitySettings;

  /// Application display copy. Source: lib/modules/characterview.dart:3974
  ///
  /// In zh, this message translates to:
  /// **'供角色重名時辨識用的 8 位 NanoID'**
  String get uiAnCharacterNanoIDDistinguishesCharactersWithTheSame;

  /// Application display copy. Source: lib/modules/characterview.dart:3981
  ///
  /// In zh, this message translates to:
  /// **'詳細基本資料與外觀'**
  String get uiDetailedProfileAndAppearance;

  /// Application display copy. Source: lib/modules/characterview.dart:3982
  ///
  /// In zh, this message translates to:
  /// **'居住地、五官與服裝'**
  String get uiResidenceFeaturesAndClothing;

  /// Application display copy. Source: lib/modules/characterview.dart:3986
  ///
  /// In zh, this message translates to:
  /// **'性格工具'**
  String get uiPersonalityTools;

  /// Application display copy. Source: lib/modules/characterview.dart:3987
  ///
  /// In zh, this message translates to:
  /// **'習慣、陣營與性格量表'**
  String get uiHabitsAlignmentAndPersonalityScales;

  /// Application display copy. Source: lib/modules/characterview.dart:3991
  ///
  /// In zh, this message translates to:
  /// **'喜好與能力'**
  String get uiPreferencesAndAbilities;

  /// Application display copy. Source: lib/modules/characterview.dart:3992
  ///
  /// In zh, this message translates to:
  /// **'能力清單與生活技能量表'**
  String get uiAbilityListsAndEverydaySkillScales;

  /// Application display copy. Source: lib/modules/characterview.dart:3996
  ///
  /// In zh, this message translates to:
  /// **'社交問卷'**
  String get uiSocialQuestionnaire;

  /// Application display copy. Source: lib/modules/characterview.dart:3997
  ///
  /// In zh, this message translates to:
  /// **'社交行為、傾向與戀愛概況'**
  String get uiSocialBehaviorTendenciesAndRomance;

  /// Application display copy. Source: lib/modules/characterview.dart:4001
  ///
  /// In zh, this message translates to:
  /// **'其他舊欄位'**
  String get uiOtherLegacyFields;

  /// Application display copy. Source: lib/modules/characterview.dart:4002
  ///
  /// In zh, this message translates to:
  /// **'原文姓名、喜惡與其他補充'**
  String get uiOriginalLanguageNamePreferencesAndExtraNotes;

  /// Application display copy. Source: lib/modules/characterview.dart:4011
  ///
  /// In zh, this message translates to:
  /// **'文字'**
  String get uiText;

  /// Application display copy. Source: lib/modules/characterview.dart:4012
  ///
  /// In zh, this message translates to:
  /// **'滑桿'**
  String get uiSlider;

  /// Application display copy. Source: lib/modules/characterview.dart:4013
  ///
  /// In zh, this message translates to:
  /// **'核取方塊'**
  String get uiCheckbox;

  /// Application display copy. Source: lib/modules/characterview.dart:4014
  ///
  /// In zh, this message translates to:
  /// **'清單'**
  String get uiList;

  /// Application display copy. Source: lib/modules/characterview.dart:4040, lib/features/revision_tracking/application/revision_field_registry.dart:78
  ///
  /// In zh, this message translates to:
  /// **'欄位名稱'**
  String get uiFieldName;

  /// Application display copy. Source: lib/modules/characterview.dart:4049
  ///
  /// In zh, this message translates to:
  /// **'型別'**
  String get uiDataType;

  /// Application display copy. Source: lib/modules/characterview.dart:4070
  ///
  /// In zh, this message translates to:
  /// **'尚無自訂資料'**
  String get uiNoCustomData;

  /// Application display copy. Source: lib/modules/characterview.dart:4071
  ///
  /// In zh, this message translates to:
  /// **'輸入欄位名稱並選擇型別後新增'**
  String get uiEnterAFieldNameSelectItsTypeAnd;

  /// Application display copy. Source: lib/modules/characterview.dart:4170
  ///
  /// In zh, this message translates to:
  /// **'移除{p1}'**
  String uiRemove(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:4245
  ///
  /// In zh, this message translates to:
  /// **'出生地：'**
  String get uiBirthplace;

  /// Application display copy. Source: lib/modules/characterview.dart:4246
  ///
  /// In zh, this message translates to:
  /// **'居住地：'**
  String get uiResidence;

  /// Application display copy. Source: lib/modules/characterview.dart:4247
  ///
  /// In zh, this message translates to:
  /// **'住址：'**
  String get uiAddress;

  /// Application display copy. Source: lib/modules/characterview.dart:4249, lib/features/revision_tracking/application/revision_field_registry.dart:69
  ///
  /// In zh, this message translates to:
  /// **'外觀'**
  String get uiAppearance;

  /// Application display copy. Source: lib/modules/characterview.dart:4251
  ///
  /// In zh, this message translates to:
  /// **'血型：'**
  String get uiBloodType;

  /// Application display copy. Source: lib/modules/characterview.dart:4252
  ///
  /// In zh, this message translates to:
  /// **'膚色：'**
  String get uiSkinColor;

  /// Application display copy. Source: lib/modules/characterview.dart:4253
  ///
  /// In zh, this message translates to:
  /// **'臉型：'**
  String get uiFaceShape;

  /// Application display copy. Source: lib/modules/characterview.dart:4254
  ///
  /// In zh, this message translates to:
  /// **'眼型：'**
  String get uiEyeShape;

  /// Application display copy. Source: lib/modules/characterview.dart:4255
  ///
  /// In zh, this message translates to:
  /// **'耳型：'**
  String get uiEarShape;

  /// Application display copy. Source: lib/modules/characterview.dart:4256
  ///
  /// In zh, this message translates to:
  /// **'鼻型：'**
  String get uiNoseShape;

  /// Application display copy. Source: lib/modules/characterview.dart:4257
  ///
  /// In zh, this message translates to:
  /// **'嘴型：'**
  String get uiMouthShape;

  /// Application display copy. Source: lib/modules/characterview.dart:4258
  ///
  /// In zh, this message translates to:
  /// **'眉型：'**
  String get uiEyebrowShape;

  /// Application display copy. Source: lib/modules/characterview.dart:4259
  ///
  /// In zh, this message translates to:
  /// **'體格：'**
  String get uiBuild;

  /// Application display copy. Source: lib/modules/characterview.dart:4260
  ///
  /// In zh, this message translates to:
  /// **'服裝：'**
  String get uiClothing;

  /// Application display copy. Source: lib/modules/characterview.dart:4272
  ///
  /// In zh, this message translates to:
  /// **'口頭禪、慣用語：'**
  String get uiCatchphrasesAndExpressions;

  /// Application display copy. Source: lib/modules/characterview.dart:4273
  ///
  /// In zh, this message translates to:
  /// **'興趣：'**
  String get uiInterests;

  /// Application display copy. Source: lib/modules/characterview.dart:4274
  ///
  /// In zh, this message translates to:
  /// **'習慣、癖好：'**
  String get uiHabitsAndQuirks;

  /// Application display copy. Source: lib/modules/characterview.dart:4275
  ///
  /// In zh, this message translates to:
  /// **'信仰：'**
  String get uiFaith;

  /// Application display copy. Source: lib/modules/characterview.dart:4276
  ///
  /// In zh, this message translates to:
  /// **'底線'**
  String get uiBoundaries;

  /// Application display copy. Source: lib/modules/characterview.dart:4277
  ///
  /// In zh, this message translates to:
  /// **'將來想變得如何？'**
  String get uiWhatDoTheyWantToBecome;

  /// Application display copy. Source: lib/modules/characterview.dart:4278
  ///
  /// In zh, this message translates to:
  /// **'最珍視的事物？'**
  String get uiWhatDoTheyValueMost;

  /// Application display copy. Source: lib/modules/characterview.dart:4279
  ///
  /// In zh, this message translates to:
  /// **'最厭惡的事物？'**
  String get uiWhatDoTheyDespiseMost;

  /// Application display copy. Source: lib/modules/characterview.dart:4280
  ///
  /// In zh, this message translates to:
  /// **'最害怕的事物？'**
  String get uiWhatDoTheyFearMost;

  /// Application display copy. Source: lib/modules/characterview.dart:4281
  ///
  /// In zh, this message translates to:
  /// **'最好奇的事物？'**
  String get uiWhatIntriguesThemMost;

  /// Application display copy. Source: lib/modules/characterview.dart:4282
  ///
  /// In zh, this message translates to:
  /// **'最期待的事物？'**
  String get uiWhatDoTheyLookForwardToMost;

  /// Application display copy. Source: lib/modules/characterview.dart:4291
  ///
  /// In zh, this message translates to:
  /// **'陣營'**
  String get uiAlignment;

  /// Application display copy. Source: lib/modules/characterview.dart:4306
  ///
  /// In zh, this message translates to:
  /// **'性格特質'**
  String get uiPersonalityTraits;

  /// Application display copy. Source: lib/modules/characterview.dart:4321
  ///
  /// In zh, this message translates to:
  /// **'行事作風'**
  String get uiApproachToLife;

  /// Application display copy. Source: lib/modules/characterview.dart:4329
  ///
  /// In zh, this message translates to:
  /// **'其他補充：'**
  String get uiAdditionalNotes;

  /// Application display copy. Source: lib/modules/characterview.dart:4342
  ///
  /// In zh, this message translates to:
  /// **'熱愛做的事情'**
  String get uiThingsTheyLoveDoing;

  /// Application display copy. Source: lib/modules/characterview.dart:4350
  ///
  /// In zh, this message translates to:
  /// **'想要做還沒做的事情'**
  String get uiThingsTheyWantToTry;

  /// Application display copy. Source: lib/modules/characterview.dart:4358
  ///
  /// In zh, this message translates to:
  /// **'討厭做的事情'**
  String get uiThingsTheyDislikeDoing;

  /// Application display copy. Source: lib/modules/characterview.dart:4366
  ///
  /// In zh, this message translates to:
  /// **'害怕做的事情'**
  String get uiThingsTheyFearDoing;

  /// Application display copy. Source: lib/modules/characterview.dart:4374
  ///
  /// In zh, this message translates to:
  /// **'擅長做的事情'**
  String get uiThingsTheyDoWell;

  /// Application display copy. Source: lib/modules/characterview.dart:4382
  ///
  /// In zh, this message translates to:
  /// **'不擅長做的事情'**
  String get uiThingsTheyStruggleWith;

  /// Application display copy. Source: lib/modules/characterview.dart:4397
  ///
  /// In zh, this message translates to:
  /// **'生活常用技能'**
  String get uiEverydaySkills;

  /// Application display copy. Source: lib/modules/characterview.dart:4415
  ///
  /// In zh, this message translates to:
  /// **'來自他人的印象'**
  String get uiOthersImpressions;

  /// Application display copy. Source: lib/modules/characterview.dart:4417
  ///
  /// In zh, this message translates to:
  /// **'最受他人欣賞/喜愛的特點'**
  String get uiMostAdmiredOrLovedQualities;

  /// Application display copy. Source: lib/modules/characterview.dart:4419
  ///
  /// In zh, this message translates to:
  /// **'簡述原生家庭'**
  String get uiFamilyBackground;

  /// Application display copy. Source: lib/modules/characterview.dart:4429
  ///
  /// In zh, this message translates to:
  /// **'如何表達「喜歡」'**
  String get uiHowTheyExpressAffection;

  /// Application display copy. Source: lib/modules/characterview.dart:4433, lib/modules/characterview.dart:4451, lib/modules/characterview.dart:4472
  ///
  /// In zh, this message translates to:
  /// **'其他'**
  String get uiOther;

  /// Application display copy. Source: lib/modules/characterview.dart:4447
  ///
  /// In zh, this message translates to:
  /// **'如何表達好意'**
  String get uiHowTheyShowKindness;

  /// Application display copy. Source: lib/modules/characterview.dart:4467
  ///
  /// In zh, this message translates to:
  /// **'如何應對討厭的人？'**
  String get uiHowDoTheyHandlePeopleTheyDislike;

  /// Application display copy. Source: lib/modules/characterview.dart:4486
  ///
  /// In zh, this message translates to:
  /// **'戀愛關係'**
  String get uiRomanticRelationships;

  /// Application display copy. Source: lib/modules/characterview.dart:4502
  ///
  /// In zh, this message translates to:
  /// **'社交相關項目'**
  String get uiSocialTendencies;

  /// Application display copy. Source: lib/modules/characterview.dart:4521
  ///
  /// In zh, this message translates to:
  /// **'原文姓名'**
  String get uiOriginalLanguageName;

  /// Application display copy. Source: lib/modules/characterview.dart:4523
  ///
  /// In zh, this message translates to:
  /// **'例如：桜田如羽'**
  String get uiForExample2;

  /// Application display copy. Source: lib/modules/characterview.dart:4527
  ///
  /// In zh, this message translates to:
  /// **'喜歡的事物'**
  String get uiThingsTheyLike;

  /// Application display copy. Source: lib/modules/characterview.dart:4535
  ///
  /// In zh, this message translates to:
  /// **'憧憬的事物'**
  String get uiThingsTheyAdmire;

  /// Application display copy. Source: lib/modules/characterview.dart:4543
  ///
  /// In zh, this message translates to:
  /// **'討厭的事物'**
  String get uiThingsTheyDislike;

  /// Application display copy. Source: lib/modules/characterview.dart:4551
  ///
  /// In zh, this message translates to:
  /// **'害怕的事物'**
  String get uiThingsTheyFear;

  /// Application display copy. Source: lib/modules/characterview.dart:4559
  ///
  /// In zh, this message translates to:
  /// **'習慣的事物'**
  String get uiFamiliarThings;

  /// Application display copy. Source: lib/modules/characterview.dart:4566
  ///
  /// In zh, this message translates to:
  /// **'其他補充'**
  String get uiAdditionalNotes2;

  /// Application display copy. Source: lib/modules/characterview.dart:4767
  ///
  /// In zh, this message translates to:
  /// **'人物關係'**
  String get uiCharacterRelationships3;

  /// Application display copy. Source: lib/modules/characterview.dart:4777
  ///
  /// In zh, this message translates to:
  /// **'尚無人物關係'**
  String get uiNoCharacterRelationships;

  /// Application display copy. Source: lib/modules/characterview.dart:4778
  ///
  /// In zh, this message translates to:
  /// **'在下方輸入人物、外在關係與內在關係後新增'**
  String get uiEnterACharacterAndExternalInternalRelationshipsBelow;

  /// Application display copy. Source: lib/modules/characterview.dart:4829
  ///
  /// In zh, this message translates to:
  /// **'選擇角色或自行輸入'**
  String get uiSelectACharacterOrEnterAName;

  /// Application display copy. Source: lib/modules/characterview.dart:4838
  ///
  /// In zh, this message translates to:
  /// **'外在關係（可留空）'**
  String get uiExternalRelationshipOptional;

  /// Application display copy. Source: lib/modules/characterview.dart:4842
  ///
  /// In zh, this message translates to:
  /// **'內在關係（可留空）'**
  String get uiInternalRelationshipOptional;

  /// Application display copy. Source: lib/modules/characterview.dart:4888, lib/modules/characterview.dart:5141, lib/ui_library/tables.dart:599
  ///
  /// In zh, this message translates to:
  /// **'更新'**
  String get uiUpdate;

  /// Application display copy. Source: lib/modules/characterview.dart:4961, lib/presentation/widgets/radial_gauge_dashboard.dart:190
  ///
  /// In zh, this message translates to:
  /// **'尚無{p1}'**
  String uiNoYet(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:5003
  ///
  /// In zh, this message translates to:
  /// **'{p1}（可留空）'**
  String uiOptional(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:5056
  ///
  /// In zh, this message translates to:
  /// **'擁有物品'**
  String get uiPossessions;

  /// Application display copy. Source: lib/modules/characterview.dart:5061, lib/modules/characterview.dart:5125, lib/modules/characterview.dart:5437
  ///
  /// In zh, this message translates to:
  /// **'數量'**
  String get uiQuantity;

  /// Application display copy. Source: lib/modules/characterview.dart:5066
  ///
  /// In zh, this message translates to:
  /// **'尚無擁有物品'**
  String get uiNoPossessions;

  /// Application display copy. Source: lib/modules/characterview.dart:5067
  ///
  /// In zh, this message translates to:
  /// **'在下方輸入物品、數量與說明後新增'**
  String get uiEnterAnItemQuantityAndDescriptionBelowThen;

  /// Application display copy. Source: lib/modules/characterview.dart:5128
  ///
  /// In zh, this message translates to:
  /// **'說明（可留空）'**
  String get uiDescriptionOptional;

  /// Application display copy. Source: lib/modules/characterview.dart:5146, lib/modules/characterview.dart:5216, lib/modules/outlineview.dart:2747
  ///
  /// In zh, this message translates to:
  /// **'轉換為正式物品'**
  String get uiConvertToManagedItem;

  /// Application display copy. Source: lib/modules/characterview.dart:5194
  ///
  /// In zh, this message translates to:
  /// **'以下是舊版擁有物品資料。請逐筆轉換為正式物品；此頁已不再新增舊格式資料。'**
  String get uiTheseAreLegacyPossessionsConvertEachEntryTo;

  /// Application display copy. Source: lib/modules/characterview.dart:5208
  ///
  /// In zh, this message translates to:
  /// **'數量：{p1}'**
  String uiQuantity2(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:5210, lib/modules/characterview.dart:5377, lib/modules/itemview.dart:2216
  ///
  /// In zh, this message translates to:
  /// **'・'**
  String get uiLiteral;

  /// Application display copy. Source: lib/modules/characterview.dart:5224, lib/modules/outlineview.dart:2752
  ///
  /// In zh, this message translates to:
  /// **'刪除舊資料'**
  String get uiDeleteLegacyEntry;

  /// Application display copy. Source: lib/modules/characterview.dart:5296, lib/modules/worldsettingsview.dart:1273
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get uiUnknown;

  /// Application display copy. Source: lib/modules/characterview.dart:5350, lib/modules/worldsettingsview.dart:1325
  ///
  /// In zh, this message translates to:
  /// **'一般關聯物品'**
  String get uiRelatedItems;

  /// Application display copy. Source: lib/modules/characterview.dart:5356, lib/modules/worldsettingsview.dart:1333
  ///
  /// In zh, this message translates to:
  /// **'連結物品'**
  String get uiLinkItem;

  /// Application display copy. Source: lib/modules/characterview.dart:5362, lib/modules/worldsettingsview.dart:1339
  ///
  /// In zh, this message translates to:
  /// **'尚未設定一般物品關聯。'**
  String get uiNoRelatedItemsAreConfigured;

  /// Application display copy. Source: lib/modules/characterview.dart:5386, lib/modules/outlineview.dart:2628, lib/modules/outlineview.dart:2834
  ///
  /// In zh, this message translates to:
  /// **'開啟物品頁'**
  String get uiOpenItems;

  /// Application display copy. Source: lib/modules/characterview.dart:5394, lib/modules/outlineview.dart:2645, lib/modules/worldsettingsview.dart:1371
  ///
  /// In zh, this message translates to:
  /// **'解除關聯'**
  String get uiUnlink;

  /// Application display copy. Source: lib/modules/characterview.dart:5411
  ///
  /// In zh, this message translates to:
  /// **'目前持有物品'**
  String get uiCurrentlyHeldItems;

  /// Application display copy. Source: lib/modules/characterview.dart:5418, lib/modules/outlineview.dart:2591, lib/modules/outlineview.dart:2806
  ///
  /// In zh, this message translates to:
  /// **'分配物品'**
  String get uiAssignItem;

  /// Application display copy. Source: lib/modules/characterview.dart:5425
  ///
  /// In zh, this message translates to:
  /// **'目前沒有已連結物品'**
  String get uiNoLinkedItems;

  /// Application display copy. Source: lib/modules/characterview.dart:5426
  ///
  /// In zh, this message translates to:
  /// **'按「分配物品」即可在此頁設定持有人或聚合數量'**
  String get uiSelectAssignItemToSetTheHolderOr;

  /// Application display copy. Source: lib/modules/characterview.dart:5438, lib/modules/worldsettingsview.dart:1419
  ///
  /// In zh, this message translates to:
  /// **'狀態／備註'**
  String get uiStatusNotes;

  /// Application display copy. Source: lib/modules/characterview.dart:5439, lib/modules/worldsettingsview.dart:1420
  ///
  /// In zh, this message translates to:
  /// **'操作'**
  String get uiActions;

  /// Application display copy. Source: lib/modules/characterview.dart:5463, lib/modules/worldsettingsview.dart:1442
  ///
  /// In zh, this message translates to:
  /// **'清除預設分配'**
  String get uiClearDefaultAssignment;

  /// Application display copy. Source: lib/modules/characterview.dart:5485
  ///
  /// In zh, this message translates to:
  /// **'選擇要分配給角色的物品'**
  String get uiSelectAnItemToAssignToTheCharacter;

  /// Application display copy. Source: lib/modules/characterview.dart:5503, lib/modules/worldsettingsview.dart:1522
  ///
  /// In zh, this message translates to:
  /// **'分配「{p1}」'**
  String uiAssign(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:5513, lib/modules/itemview.dart:543, lib/modules/worldsettingsview.dart:1532
  ///
  /// In zh, this message translates to:
  /// **'留空代表數量未知'**
  String get uiLeaveBlankIfTheQuantityIsUnknown;

  /// Application display copy. Source: lib/modules/characterview.dart:5526, lib/modules/worldsettingsview.dart:1545
  ///
  /// In zh, this message translates to:
  /// **'分配'**
  String get uiAssign2;

  /// Application display copy. Source: lib/modules/characterview.dart:5539, lib/modules/worldsettingsview.dart:1558
  ///
  /// In zh, this message translates to:
  /// **'數量必須是零或正整數。'**
  String get uiQuantityMustBeZeroOrAPositiveInteger;

  /// Application display copy. Source: lib/modules/characterview.dart:5567, lib/modules/worldsettingsview.dart:1586
  ///
  /// In zh, this message translates to:
  /// **'無法分配物品：{p1}'**
  String uiCouldNotAssignTheItem(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:5609, lib/modules/outlineview.dart:2904
  ///
  /// In zh, this message translates to:
  /// **'轉換「{p1}」'**
  String uiConvert(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:5610
  ///
  /// In zh, this message translates to:
  /// **'會移除角色預設與可定位 Scene 快照中的同名舊資料，並建立正式物品狀態。'**
  String get uiRemovesMatchingLegacyEntriesFromTheDefaultCharacter;

  /// Application display copy. Source: lib/modules/characterview.dart:5619, lib/modules/outlineview.dart:2917
  ///
  /// In zh, this message translates to:
  /// **'連結既有'**
  String get uiLinkExisting;

  /// Application display copy. Source: lib/modules/characterview.dart:5624
  ///
  /// In zh, this message translates to:
  /// **'建立並轉換'**
  String get uiCreateAndConvert;

  /// Application display copy. Source: lib/modules/characterview.dart:5634
  ///
  /// In zh, this message translates to:
  /// **'選擇「{p1}」對應的正式物品'**
  String uiSelectTheManagedItemFor(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:5660
  ///
  /// In zh, this message translates to:
  /// **'確認持有物轉換'**
  String get uiConfirmPossessionConversion;

  /// Application display copy. Source: lib/modules/characterview.dart:5665
  ///
  /// In zh, this message translates to:
  /// **'預設／baseline：{p1} 筆'**
  String uiDefaultBaselineEntries(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:5666
  ///
  /// In zh, this message translates to:
  /// **'Scene 快照：{p1} 筆'**
  String uiSceneSnapshotEntries(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:5669
  ///
  /// In zh, this message translates to:
  /// **'另有 {p1} 筆舊 CharacterState 無法可靠連結 Scene，將保留原文字。'**
  String uiLegacyCharacterStateEntriesWithoutReliableSceneLinksTheir(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:5681
  ///
  /// In zh, this message translates to:
  /// **'套用轉換'**
  String get uiApplyConversion;

  /// Application display copy. Source: lib/modules/characterview.dart:5697
  ///
  /// In zh, this message translates to:
  /// **'持有物轉換失敗：{p1}'**
  String uiPossessionConversionFailed(String p1);

  /// Application display copy. Source: lib/modules/characterview.dart:5714, lib/modules/outlineview.dart:2995
  ///
  /// In zh, this message translates to:
  /// **'建立正式物品'**
  String get uiCreateManagedItem;

  /// Application display copy. Source: lib/modules/characterview.dart:5722
  ///
  /// In zh, this message translates to:
  /// **'物品名稱'**
  String get uiItemName;

  /// Application display copy. Source: lib/modules/characterview.dart:5737, lib/modules/outlineview.dart:3020
  ///
  /// In zh, this message translates to:
  /// **'物品模式'**
  String get uiItemMode;

  /// Application display copy. Source: lib/modules/characterview.dart:5742, lib/modules/outlineview.dart:3025
  ///
  /// In zh, this message translates to:
  /// **'專用（建立獨立 ID）'**
  String get uiDedicatedIndependentID;

  /// Application display copy. Source: lib/modules/characterview.dart:5746, lib/modules/outlineview.dart:3029
  ///
  /// In zh, this message translates to:
  /// **'半專用（Class 內建立一件）'**
  String get uiSemiDedicatedOneInstanceInADefinition;

  /// Application display copy. Source: lib/modules/characterview.dart:5750
  ///
  /// In zh, this message translates to:
  /// **'非專用（保留數量）'**
  String get uiNonDedicatedKeepQuantity;

  /// Application display copy. Source: lib/modules/characterview.dart:5902
  ///
  /// In zh, this message translates to:
  /// **'選擇要連結的人物物品'**
  String get uiSelectACharacterRelatedItemToLink;

  /// Application display copy. Source: lib/modules/characterview.dart:5920, lib/modules/worldsettingsview.dart:1496
  ///
  /// In zh, this message translates to:
  /// **'相關'**
  String get uiRelated;

  /// Application display copy. Source: lib/modules/characterview.dart:5987
  ///
  /// In zh, this message translates to:
  /// **'其他：'**
  String get uiOther2;

  /// Application display copy. Source: lib/modules/characterview.dart:5989
  ///
  /// In zh, this message translates to:
  /// **'其他……'**
  String get uiOther3;

  /// Application display copy. Source: lib/modules/characterview.dart:5993
  ///
  /// In zh, this message translates to:
  /// **'另尋新歡？'**
  String get uiLookingForNewLove;

  /// Application display copy. Source: lib/modules/characterview.dart:6005
  ///
  /// In zh, this message translates to:
  /// **'后宮型作品？'**
  String get uiHaremStory;

  /// Application display copy. Source: lib/modules/characterview.dart:7232
  ///
  /// In zh, this message translates to:
  /// **'簡易時間軸'**
  String get uiCompactTimeline;

  /// Application display copy. Source: lib/modules/characterview.dart:7266
  ///
  /// In zh, this message translates to:
  /// **'點擊或拖曳選擇時間 · 菱形表示既有快照'**
  String get uiClickOrDragToSelectTimeDiamondsMark;

  /// Application display copy. Source: lib/modules/copliot.dart:293
  ///
  /// In zh, this message translates to:
  /// **'Copilot 安全設定無法載入；API Key 未載入。'**
  String get uiCouldNotLoadSecureCopilotSettingsTheAPI;

  /// Application display copy. Source: lib/modules/copliot.dart:524
  ///
  /// In zh, this message translates to:
  /// **'已抓取 {p1} 個模型。'**
  String uiModelsRetrieved(String p1);

  /// Application display copy. Source: lib/modules/copliot.dart:625
  ///
  /// In zh, this message translates to:
  /// **'，以及{p1}'**
  String uiAlongWith(String p1);

  /// Application display copy. Source: lib/modules/copliot.dart:629
  ///
  /// In zh, this message translates to:
  /// **'傳送作品內容？'**
  String get uiSendYourWorkSContent;

  /// Application display copy. Source: lib/modules/copliot.dart:631
  ///
  /// In zh, this message translates to:
  /// **'此模式會將目前章節「{p1}」{p2}傳送到 {p3}。資料會直接送往你選擇的模型服務。另會附帶 App 內建的 .mnproj 結構說明（不含作品內容）。{p4}'**
  String uiThisModeSendsTheCurrentChapterToData(
    String p1,
    String p2,
    String p3,
    String p4,
  );

  /// Application display copy. Source: lib/modules/copliot.dart:634
  ///
  /// In zh, this message translates to:
  /// **'已設定的 API Key 也會一併傳送。'**
  String get uiYourConfiguredAPIKeyWillAlsoBeSent;

  /// Application display copy. Source: lib/modules/copliot.dart:643, lib/modules/copliot.dart:675
  ///
  /// In zh, this message translates to:
  /// **'允許本次連線'**
  String get uiAllowThisConnection;

  /// Application display copy. Source: lib/modules/copliot.dart:666
  ///
  /// In zh, this message translates to:
  /// **'傳送 API Key？'**
  String get uiSendAPIKey;

  /// Application display copy. Source: lib/modules/copliot.dart:667
  ///
  /// In zh, this message translates to:
  /// **'API Key 將直接傳送到 {p1}。請確認這是你信任的模型服務。'**
  String uiTheAPIKeyWillBeSentDirectlyTo(String p1);

  /// Application display copy. Source: lib/modules/copliot.dart:695
  ///
  /// In zh, this message translates to:
  /// **'已取消請求。'**
  String get uiRequestCancelled;

  /// Application display copy. Source: lib/modules/copliot.dart:708
  ///
  /// In zh, this message translates to:
  /// **'請先選擇或輸入使用模型。'**
  String get uiSelectOrEnterAModelFirst;

  /// Application display copy. Source: lib/modules/copliot.dart:772
  ///
  /// In zh, this message translates to:
  /// **'設定已變更，已取消舊請求。'**
  String get uiSettingsChangedThePreviousRequestWasCancelled;

  /// Application display copy. Source: lib/modules/copliot.dart:799, lib/modules/copliot.dart:864
  ///
  /// In zh, this message translates to:
  /// **'設定已變更，已取消舊請求結果。'**
  String get uiSettingsChangedThePreviousRequestResultWasDiscarded;

  /// Application display copy. Source: lib/modules/copliot.dart:889
  ///
  /// In zh, this message translates to:
  /// **'目前沒有已儲存的 API Key。'**
  String get uiNoAPIKeyIsSaved;

  /// Application display copy. Source: lib/modules/copliot.dart:897
  ///
  /// In zh, this message translates to:
  /// **'清除 API Key？'**
  String get uiClearAPIKey;

  /// Application display copy. Source: lib/modules/copliot.dart:898
  ///
  /// In zh, this message translates to:
  /// **'這會從此裝置的安全儲存空間移除 API Key。作品與對話內容不會受影響。'**
  String get uiThisRemovesTheAPIKeyFromThisDevice;

  /// Application display copy. Source: lib/modules/copliot.dart:906
  ///
  /// In zh, this message translates to:
  /// **'清除 Key'**
  String get uiClearKey;

  /// Application display copy. Source: lib/modules/copliot.dart:921
  ///
  /// In zh, this message translates to:
  /// **'API Key 已從此裝置移除。'**
  String get uiAPIKeyRemovedFromThisDevice;

  /// Application display copy. Source: lib/modules/copliot.dart:925
  ///
  /// In zh, this message translates to:
  /// **'無法從此裝置移除 API Key，請稍後再試。'**
  String get uiCouldNotRemoveTheAPIKeyTryAgain;

  /// Application display copy. Source: lib/modules/copliot.dart:942
  ///
  /// In zh, this message translates to:
  /// **'Ask／Plan Beta 已納入功能旗標，只讀取目前章節且不會修改專案；Agent 模式暫不可用。'**
  String get uiAskPlanBetaAreControlledByFeatureFlags;

  /// Application display copy. Source: lib/modules/copliot.dart:958
  ///
  /// In zh, this message translates to:
  /// **'模型選擇'**
  String get uiModelSelection;

  /// Application display copy. Source: lib/modules/copliot.dart:991, lib/modules/copliot.dart:166
  ///
  /// In zh, this message translates to:
  /// **'自訂'**
  String get uiCustom;

  /// Application display copy. Source: lib/modules/copliot.dart:995
  ///
  /// In zh, this message translates to:
  /// **'供應商'**
  String get uiProvider;

  /// Application display copy. Source: lib/modules/copliot.dart:1039
  ///
  /// In zh, this message translates to:
  /// **'使用模型'**
  String get uiModel;

  /// Application display copy. Source: lib/modules/copliot.dart:1040
  ///
  /// In zh, this message translates to:
  /// **'選擇或輸入模型 ID'**
  String get uiSelectOrEnterAModelID;

  /// Application display copy. Source: lib/modules/copliot.dart:1082
  ///
  /// In zh, this message translates to:
  /// **'抓取'**
  String get uiFetch;

  /// Application display copy. Source: lib/modules/copliot.dart:1103
  ///
  /// In zh, this message translates to:
  /// **'隱藏 API Key'**
  String get uiHideAPIKey;

  /// Application display copy. Source: lib/modules/copliot.dart:1103
  ///
  /// In zh, this message translates to:
  /// **'顯示 API Key'**
  String get uiShowAPIKey;

  /// Application display copy. Source: lib/modules/copliot.dart:1115
  ///
  /// In zh, this message translates to:
  /// **'清除已儲存 Key'**
  String get uiClearSavedKey;

  /// Application display copy. Source: lib/modules/copliot.dart:1131
  ///
  /// In zh, this message translates to:
  /// **'隱私、第三方服務與已知限制'**
  String get uiPrivacyThirdPartyServicesAndLimitations;

  /// Application display copy. Source: lib/modules/copliot.dart:1143
  ///
  /// In zh, this message translates to:
  /// **'Chat 會傳送你輸入的訊息；Ask／Plan 另會傳送畫面標示的作品上下文。資料直接送往你設定的 provider 與 API URL，不經 Monogatari Assistant 伺服器。'**
  String get uiChatSendsYourMessagesAskPlanAlsoSend;

  /// Application display copy. Source: lib/modules/copliot.dart:1148
  ///
  /// In zh, this message translates to:
  /// **'第三方 provider 是否保存或使用資料，依該服務的條款與帳號設定決定。localhost Ollama 可留在本機，但其他自訂 URL 不一定私密。'**
  String get uiWhetherAProviderStoresOrUsesDataDepends;

  /// Application display copy. Source: lib/modules/copliot.dart:1152
  ///
  /// In zh, this message translates to:
  /// **'對話與 Plan 目前只保留在本次畫面工作階段，不會寫入專案，也不會跨啟動還原。'**
  String get uiConversationsAndPlansExistOnlyForThisScreen;

  /// Application display copy. Source: lib/modules/copliot.dart:1156
  ///
  /// In zh, this message translates to:
  /// **'AI 回覆可能不正確。Plan 僅供檢視與匯出，不會自動修改作品；Agent 模式目前停用。'**
  String get uiAIResponsesMayBeIncorrectPlansAreFor;

  /// Application display copy. Source: lib/modules/copliot.dart:1176, lib/modules/copliot.dart:1189
  ///
  /// In zh, this message translates to:
  /// **'對話紀錄'**
  String get uiConversationHistory;

  /// Application display copy. Source: lib/modules/copliot.dart:1183
  ///
  /// In zh, this message translates to:
  /// **'清空'**
  String get uiClearAll;

  /// Application display copy. Source: lib/modules/copliot.dart:1195
  ///
  /// In zh, this message translates to:
  /// **'尚無對話紀錄'**
  String get uiNoConversations;

  /// Application display copy. Source: lib/modules/copliot.dart:1196
  ///
  /// In zh, this message translates to:
  /// **'送出訊息後會顯示在這裡'**
  String get uiMessagesWillAppearHereAfterYouSendThem;

  /// Application display copy. Source: lib/modules/copliot.dart:1280
  ///
  /// In zh, this message translates to:
  /// **'你'**
  String get uiYou;

  /// Application display copy. Source: lib/modules/copliot.dart:1302
  ///
  /// In zh, this message translates to:
  /// **'模型未提供可驗證的結構化來源。'**
  String get uiTheModelSuppliedNoVerifiableStructuredSources;

  /// Application display copy. Source: lib/modules/copliot.dart:1314
  ///
  /// In zh, this message translates to:
  /// **'無法驗證 Plan：{p1}\n已保留模型原始回覆，未套用任何變更。'**
  String uiCouldNotValidateThePlanTheOriginalResponse(String p1);

  /// Application display copy. Source: lib/modules/copliot.dart:1338
  ///
  /// In zh, this message translates to:
  /// **'模型未提供可驗證來源。'**
  String get uiTheModelSuppliedNoVerifiableSources;

  /// Application display copy. Source: lib/modules/copliot.dart:1345
  ///
  /// In zh, this message translates to:
  /// **'來源'**
  String get uiSources;

  /// Application display copy. Source: lib/modules/copliot.dart:1364
  ///
  /// In zh, this message translates to:
  /// **'不確定：{p1}'**
  String uiUncertain(String p1);

  /// Application display copy. Source: lib/modules/copliot.dart:1373
  ///
  /// In zh, this message translates to:
  /// **'已忽略模型提供的無效來源。'**
  String get uiInvalidSourcesSuppliedByTheModelWereIgnored;

  /// Application display copy. Source: lib/modules/copliot.dart:1407
  ///
  /// In zh, this message translates to:
  /// **'開啟來源：{p1}'**
  String uiOpenSource(String p1);

  /// Application display copy. Source: lib/modules/copliot.dart:1432
  ///
  /// In zh, this message translates to:
  /// **'已複製 Plan JSON。'**
  String get uiPlanJSONCopied;

  /// Application display copy. Source: lib/modules/copliot.dart:1458
  ///
  /// In zh, this message translates to:
  /// **'Plan JSON 匯出完成。'**
  String get uiPlanJSONExported;

  /// Application display copy. Source: lib/modules/copliot.dart:1462
  ///
  /// In zh, this message translates to:
  /// **'Plan JSON 匯出失敗，請確認儲存位置與檔案權限。'**
  String get uiCouldNotExportThePlanJSONCheckThe;

  /// Application display copy. Source: lib/modules/copliot.dart:1498
  ///
  /// In zh, this message translates to:
  /// **'複製 Plan JSON'**
  String get uiCopyPlanJSON;

  /// Application display copy. Source: lib/modules/copliot.dart:1504
  ///
  /// In zh, this message translates to:
  /// **'匯出 Plan JSON'**
  String get uiExportPlanJSON;

  /// Application display copy. Source: lib/modules/copliot.dart:1512
  ///
  /// In zh, this message translates to:
  /// **'目前章節已變更，這份計畫可能已過期。'**
  String get uiTheCurrentChapterChangedThisPlanMayBe;

  /// Application display copy. Source: lib/modules/copliot.dart:1533
  ///
  /// In zh, this message translates to:
  /// **'風險：{p1}'**
  String uiRisk(String p1);

  /// Application display copy. Source: lib/modules/copliot.dart:1542
  ///
  /// In zh, this message translates to:
  /// **'待確認：{p1}'**
  String uiToConfirm(String p1);

  /// Application display copy. Source: lib/modules/copliot.dart:1550
  ///
  /// In zh, this message translates to:
  /// **'唯讀計畫・尚未套用任何變更'**
  String get uiReadOnlyPlanNoChangesApplied;

  /// Application display copy. Source: lib/modules/copliot.dart:1562, lib/modules/copliot.dart:1564, lib/modules/copliot.dart:1733
  ///
  /// In zh, this message translates to:
  /// **'目前章節'**
  String get uiCurrentChapter;

  /// Application display copy. Source: lib/modules/copliot.dart:1565
  ///
  /// In zh, this message translates to:
  /// **'目前章節與專案索引摘要'**
  String get uiCurrentChapterAndProjectIndexSummary;

  /// Application display copy. Source: lib/modules/copliot.dart:1566
  ///
  /// In zh, this message translates to:
  /// **'目前章節與勾選的補充資源'**
  String get uiCurrentChapterAndSelectedSupplementalResources;

  /// Application display copy. Source: lib/modules/copliot.dart:1585
  ///
  /// In zh, this message translates to:
  /// **'{p1} 會把{p2}直接傳送到你設定的模型服務；不會修改專案。'**
  String uiSendsDirectlyToYourConfiguredModelServiceWithout(
    String p1,
    String p2,
  );

  /// Application display copy. Source: lib/modules/copliot.dart:1603
  ///
  /// In zh, this message translates to:
  /// **'選擇補充資源（{p1}/{p2}）'**
  String uiSelectSupplementalResources(String p1, String p2);

  /// Application display copy. Source: lib/modules/copliot.dart:1641
  ///
  /// In zh, this message translates to:
  /// **'輸入訊息，Shift+Enter 換行，Enter 發送'**
  String get uiEnterAMessageShiftEnterForANew;

  /// Application display copy. Source: lib/modules/copliot.dart:1642
  ///
  /// In zh, this message translates to:
  /// **'詢問目前章節內容'**
  String get uiAskAboutTheCurrentChapter;

  /// Application display copy. Source: lib/modules/copliot.dart:1643
  ///
  /// In zh, this message translates to:
  /// **'描述希望規劃的修改目標'**
  String get uiDescribeTheChangesYouWantToPlan;

  /// Application display copy. Source: lib/modules/copliot.dart:1644
  ///
  /// In zh, this message translates to:
  /// **'Agent 模式暫不可用'**
  String get uiAgentIsUnavailable;

  /// Application display copy. Source: lib/modules/copliot.dart:1663
  ///
  /// In zh, this message translates to:
  /// **'取消請求'**
  String get uiCancelRequest;

  /// Application display copy. Source: lib/modules/copliot.dart:1663
  ///
  /// In zh, this message translates to:
  /// **'發送'**
  String get uiSend;

  /// Application display copy. Source: lib/modules/copliot.dart:1674
  ///
  /// In zh, this message translates to:
  /// **'Shift+Enter 換行、Enter 發送'**
  String get uiShiftEnterNewLineEnterSend;

  /// Application display copy. Source: lib/modules/copliot.dart:1689
  ///
  /// In zh, this message translates to:
  /// **'模式選擇'**
  String get uiModeSelection;

  /// Application display copy. Source: lib/modules/copliot.dart:1707
  ///
  /// In zh, this message translates to:
  /// **'Agent (暫不可用)'**
  String get uiAgentUnavailable;

  /// Application display copy. Source: lib/modules/copliot.dart:1729
  ///
  /// In zh, this message translates to:
  /// **'Ask 上下文'**
  String get uiAskContext;

  /// Application display copy. Source: lib/modules/copliot.dart:1737
  ///
  /// In zh, this message translates to:
  /// **'目前章節＋專案摘要'**
  String get uiCurrentChapterProjectSummary;

  /// Application display copy. Source: lib/modules/copliot.dart:1741
  ///
  /// In zh, this message translates to:
  /// **'目前章節＋選取資源'**
  String get uiCurrentChapterSelectedResources;

  /// Application display copy. Source: lib/modules/copliot.dart:1798
  ///
  /// In zh, this message translates to:
  /// **'選擇 Ask 補充資源'**
  String get uiSelectAskSupplementalResources;

  /// Application display copy. Source: lib/modules/copliot.dart:1813
  ///
  /// In zh, this message translates to:
  /// **'搜尋角色、世界觀、大綱或詞語'**
  String get uiSearchCharactersWorldbuildingOutlinesOrWords;

  /// Application display copy. Source: lib/modules/copliot.dart:1821
  ///
  /// In zh, this message translates to:
  /// **'已選 {p1}/{p2}；只會傳送勾選項目的內容。'**
  String uiSelectedOnlySelectedResourcesAreSent(String p1, String p2);

  /// Application display copy. Source: lib/modules/copliot.dart:1829
  ///
  /// In zh, this message translates to:
  /// **'沒有符合的資源。'**
  String get uiNoMatchingResources;

  /// Application display copy. Source: lib/modules/copliot.dart:1878
  ///
  /// In zh, this message translates to:
  /// **'清除'**
  String get uiClear;

  /// Application display copy. Source: lib/modules/copliot.dart:1888
  ///
  /// In zh, this message translates to:
  /// **'使用選取項目'**
  String get uiUseSelection;

  /// Application display copy. Source: lib/modules/copliot.dart:1903
  ///
  /// In zh, this message translates to:
  /// **'，已截斷'**
  String get uiTruncated;

  /// Application display copy. Source: lib/modules/copliot.dart:1908
  ///
  /// In zh, this message translates to:
  /// **'＋專案索引摘要（上限 24 KiB）'**
  String get uiProjectIndexSummaryUpToKiB;

  /// Application display copy. Source: lib/modules/copliot.dart:1912
  ///
  /// In zh, this message translates to:
  /// **'＋已選 {p1} 個補充資源（上限 32 KiB）'**
  String uiSelectedResourcesUpToKiB(String p1);

  /// Application display copy. Source: lib/modules/copliot.dart:1914
  ///
  /// In zh, this message translates to:
  /// **'上下文：{p1}（{p2} bytes{p3}）{p4}'**
  String uiContextBytes(String p1, String p2, String p3, String p4);

  /// Application display copy. Source: lib/modules/copliot.dart:1916
  ///
  /// In zh, this message translates to:
  /// **'上下文：尚未選擇章節'**
  String get uiContextNoChapterSelected;

  /// Application display copy. Source: lib/modules/glossaryview.dart:575
  ///
  /// In zh, this message translates to:
  /// **'未知類別'**
  String get uiUnknownCategory;

  /// Application display copy. Source: lib/modules/glossaryview.dart:786
  ///
  /// In zh, this message translates to:
  /// **'匯出詞語'**
  String get uiExportWordReference;

  /// Application display copy. Source: lib/modules/glossaryview.dart:804
  ///
  /// In zh, this message translates to:
  /// **'匯出失敗：無法寫入檔案'**
  String get uiExportFailedCouldNotWriteTheFile;

  /// Application display copy. Source: lib/modules/glossaryview.dart:814
  ///
  /// In zh, this message translates to:
  /// **'匯出完成：{p1}\n{p2}'**
  String uiExportComplete2(String p1, String p2);

  /// Application display copy. Source: lib/modules/glossaryview.dart:894
  ///
  /// In zh, this message translates to:
  /// **'(空白詞條)'**
  String get uiEmptyEntry;

  /// Application display copy. Source: lib/modules/glossaryview.dart:923
  ///
  /// In zh, this message translates to:
  /// **'(未命名分類)'**
  String get uiUnnamedCategory;

  /// Application display copy. Source: lib/modules/glossaryview.dart:965
  ///
  /// In zh, this message translates to:
  /// **'匯入預覽'**
  String get uiImportPreview;

  /// Application display copy. Source: lib/modules/glossaryview.dart:974
  ///
  /// In zh, this message translates to:
  /// **'將新增分類：{p1}'**
  String uiCategoriesToAdd(String p1);

  /// Application display copy. Source: lib/modules/glossaryview.dart:975
  ///
  /// In zh, this message translates to:
  /// **'將合併到既有分類：{p1}'**
  String uiCategoriesToMerge(String p1);

  /// Application display copy. Source: lib/modules/glossaryview.dart:976
  ///
  /// In zh, this message translates to:
  /// **'將匯入新詞條：{p1}'**
  String uiNewEntriesToImport(String p1);

  /// Application display copy. Source: lib/modules/glossaryview.dart:977
  ///
  /// In zh, this message translates to:
  /// **'將重用既有詞條：{p1}'**
  String uiExistingEntriesToReuse(String p1);

  /// Application display copy. Source: lib/modules/glossaryview.dart:978
  ///
  /// In zh, this message translates to:
  /// **'將新增分類條目連結：{p1}'**
  String uiCategoryEntryLinksToAdd(String p1);

  /// Application display copy. Source: lib/modules/glossaryview.dart:981
  ///
  /// In zh, this message translates to:
  /// **'新增分類（最多顯示 6 筆）'**
  String get uiNewCategoriesUpToShown;

  /// Application display copy. Source: lib/modules/glossaryview.dart:988
  ///
  /// In zh, this message translates to:
  /// **'新增詞條（最多顯示 6 筆）'**
  String get uiNewEntriesUpToShown;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1004
  ///
  /// In zh, this message translates to:
  /// **'確認匯入'**
  String get uiConfirmImport;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1038
  ///
  /// In zh, this message translates to:
  /// **'匯入檔案格式錯誤'**
  String get uiInvalidImportFileFormat;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1160
  ///
  /// In zh, this message translates to:
  /// **'匯入完成：新增類別 {p1}、匯入新詞條 {p2}、重用既有詞條 {p3}、連結詞條 {p4}'**
  String uiImportCompleteNewCategoriesNewEntriesReusedEntries(
    String p1,
    String p2,
    String p3,
    String p4,
  );

  /// Application display copy. Source: lib/modules/glossaryview.dart:1195
  ///
  /// In zh, this message translates to:
  /// **'新增分類'**
  String get uiAddCategory;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1195, lib/modules/glossaryview.dart:1570
  ///
  /// In zh, this message translates to:
  /// **'新增子分類'**
  String get uiAddSubcategory;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1196
  ///
  /// In zh, this message translates to:
  /// **'輸入分類名稱'**
  String get uiEnterACategoryName;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1276, lib/modules/glossaryview.dart:1728
  ///
  /// In zh, this message translates to:
  /// **'刪除分類'**
  String get uiDeleteCategory;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1277
  ///
  /// In zh, this message translates to:
  /// **'確定要刪除「{p1}」及其子分類嗎？'**
  String uiDeleteAndItsSubcategories(String p1);

  /// Application display copy. Source: lib/modules/glossaryview.dart:1325
  ///
  /// In zh, this message translates to:
  /// **'移除詞條'**
  String get uiRemoveEntry;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1327
  ///
  /// In zh, this message translates to:
  /// **'確定要從「{p1}」移除「{p2}」嗎？'**
  String uiRemoveFrom(String p1, String p2);

  /// Application display copy. Source: lib/modules/glossaryview.dart:1411
  ///
  /// In zh, this message translates to:
  /// **'第 {p1} 組'**
  String uiGroup(String p1);

  /// Application display copy. Source: lib/modules/glossaryview.dart:1418
  ///
  /// In zh, this message translates to:
  /// **'刪除此組'**
  String get uiDeleteThisGroup;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1433
  ///
  /// In zh, this message translates to:
  /// **'意義'**
  String get uiMeaning;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1445
  ///
  /// In zh, this message translates to:
  /// **'例句'**
  String get uiExample;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1537, lib/modules/proofreadingview.dart:1231
  ///
  /// In zh, this message translates to:
  /// **'本功能正在開發中，使用時可能出現錯誤。'**
  String get uiThisFeatureIsInDevelopmentAndMayContain;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1562, lib/modules/glossaryview.dart:1628
  ///
  /// In zh, this message translates to:
  /// **'詞語類別'**
  String get uiWordCategories;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1565
  ///
  /// In zh, this message translates to:
  /// **'新增根分類'**
  String get uiAddRootCategory;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1577
  ///
  /// In zh, this message translates to:
  /// **'匯入匯出'**
  String get uiImportExport;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1596
  ///
  /// In zh, this message translates to:
  /// **'匯入…'**
  String get uiImport2;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1601
  ///
  /// In zh, this message translates to:
  /// **'匯出……（已禁用）'**
  String get uiExportDisabled;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1606
  ///
  /// In zh, this message translates to:
  /// **'匯出選取類別'**
  String get uiExportSelectedCategory;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1610
  ///
  /// In zh, this message translates to:
  /// **'匯出全部'**
  String get uiExportAll;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1623
  ///
  /// In zh, this message translates to:
  /// **'長按卡片可拖曳，支援排序與改為子目錄。'**
  String get uiLongPressCardsToDragReorderOrMove;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1635
  ///
  /// In zh, this message translates to:
  /// **'尚無詞語類別'**
  String get uiNoWordCategories;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1636
  ///
  /// In zh, this message translates to:
  /// **'請新增第一個分類'**
  String get uiAddYourFirstCategory;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1679
  ///
  /// In zh, this message translates to:
  /// **'（未命名分類）'**
  String get uiUnnamedCategory2;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1688
  ///
  /// In zh, this message translates to:
  /// **'共 {p1} 條'**
  String uiEntries(String p1);

  /// Application display copy. Source: lib/modules/glossaryview.dart:1692
  ///
  /// In zh, this message translates to:
  /// **'分類操作'**
  String get uiCategoryActions;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1718
  ///
  /// In zh, this message translates to:
  /// **'收合子分類'**
  String get uiCollapseSubcategories;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1718
  ///
  /// In zh, this message translates to:
  /// **'展開子分類'**
  String get uiExpandSubcategories;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1724
  ///
  /// In zh, this message translates to:
  /// **'重命名'**
  String get uiRename;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1785
  ///
  /// In zh, this message translates to:
  /// **'移動到前方'**
  String get uiMoveBefore;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1786
  ///
  /// In zh, this message translates to:
  /// **'移動到子目錄'**
  String get uiMoveToSubcategory;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1787
  ///
  /// In zh, this message translates to:
  /// **'移動到後方'**
  String get uiMoveAfter;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1791
  ///
  /// In zh, this message translates to:
  /// **'「{p1}」已{p2}'**
  String uiLiteral2(String p1, String p2);

  /// Application display copy. Source: lib/modules/glossaryview.dart:1806
  ///
  /// In zh, this message translates to:
  /// **'「{p1}」已移到「{p2}」'**
  String uiMovedInto(String p1, String p2);

  /// Application display copy. Source: lib/modules/glossaryview.dart:1837, lib/modules/glossaryview.dart:1865, lib/modules/glossaryview.dart:1873
  ///
  /// In zh, this message translates to:
  /// **'詞語條目'**
  String get uiWordEntries;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1840
  ///
  /// In zh, this message translates to:
  /// **'請先選擇詞語類別'**
  String get uiSelectAWordCategoryFirst;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1868
  ///
  /// In zh, this message translates to:
  /// **'詞條可長按拖曳，支援排序與移動到其他分類。'**
  String get uiLongPressEntriesToDragReorderOrMove;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1880
  ///
  /// In zh, this message translates to:
  /// **'此類別目前沒有詞條'**
  String get uiThisCategoryHasNoEntries;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1881
  ///
  /// In zh, this message translates to:
  /// **'請新增第一個詞條'**
  String get uiAddYourFirstEntry;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1884, lib/modules/glossaryview.dart:2061
  ///
  /// In zh, this message translates to:
  /// **'詞條名稱'**
  String get uiEntryName;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1914, lib/modules/glossaryview.dart:1916
  ///
  /// In zh, this message translates to:
  /// **'尚未填寫意義'**
  String get uiNoMeaningEnteredYet;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1939
  ///
  /// In zh, this message translates to:
  /// **'詞性：{p1}'**
  String uiPartOfSpeech(String p1);

  /// Application display copy. Source: lib/modules/glossaryview.dart:1945
  ///
  /// In zh, this message translates to:
  /// **'來源：本目錄'**
  String get uiSourceThisCategory;

  /// Application display copy. Source: lib/modules/glossaryview.dart:1946
  ///
  /// In zh, this message translates to:
  /// **'來源：子目錄 {p1}'**
  String uiSourceSubcategory(String p1);

  /// Application display copy. Source: lib/modules/glossaryview.dart:1952
  ///
  /// In zh, this message translates to:
  /// **'從此分類移除'**
  String get uiRemoveFromThisCategory;

  /// Application display copy. Source: lib/modules/glossaryview.dart:2025
  ///
  /// In zh, this message translates to:
  /// **'「{p1}」已移動到「{p2}」'**
  String uiMovedTo(String p1, String p2);

  /// Application display copy. Source: lib/modules/glossaryview.dart:2053
  ///
  /// In zh, this message translates to:
  /// **'詞語解釋、例句'**
  String get uiMeaningsAndExamples;

  /// Application display copy. Source: lib/modules/glossaryview.dart:2056
  ///
  /// In zh, this message translates to:
  /// **'請從上方選擇一個詞條。'**
  String get uiSelectAnEntryAbove;

  /// Application display copy. Source: lib/modules/glossaryview.dart:2071
  ///
  /// In zh, this message translates to:
  /// **'詞性'**
  String get uiPartOfSpeech2;

  /// Application display copy. Source: lib/modules/glossaryview.dart:2091
  ///
  /// In zh, this message translates to:
  /// **'自訂詞性'**
  String get uiCustomPartOfSpeech;

  /// Application display copy. Source: lib/modules/glossaryview.dart:2102
  ///
  /// In zh, this message translates to:
  /// **'情感傾向'**
  String get uiSentiment;

  /// Application display copy. Source: lib/modules/glossaryview.dart:2134
  ///
  /// In zh, this message translates to:
  /// **'意義 + 例句組'**
  String get uiMeaningAndExampleGroups;

  /// Application display copy. Source: lib/modules/glossaryview.dart:2143
  ///
  /// In zh, this message translates to:
  /// **'新增一組'**
  String get uiAddGroup;

  /// Application display copy. Source: lib/modules/glossaryview.dart:2185
  ///
  /// In zh, this message translates to:
  /// **'讀取詞語資料失敗'**
  String get uiCouldNotLoadWordData;

  /// Application display copy. Source: lib/modules/glossaryview.dart:2213, lib/features/navigation/app_module.dart:85
  ///
  /// In zh, this message translates to:
  /// **'詞語參考'**
  String get uiWordReference;

  /// Application display copy. Source: lib/modules/itemview.dart:78
  ///
  /// In zh, this message translates to:
  /// **'新物品'**
  String get uiNewItem;

  /// Application display copy. Source: lib/modules/itemview.dart:110, lib/modules/itemview.dart:2012
  ///
  /// In zh, this message translates to:
  /// **'封存物品'**
  String get uiArchiveItem;

  /// Application display copy. Source: lib/modules/itemview.dart:112
  ///
  /// In zh, this message translates to:
  /// **'要封存「{p1}」嗎？現有關聯與歷史快照會保留，{p2} 件單件物品會一併封存。'**
  String uiArchiveExistingLinksAndHistoricalSnapshotsWillBe(
    String p1,
    String p2,
  );

  /// Application display copy. Source: lib/modules/itemview.dart:112, lib/modules/itemview.dart:1994
  ///
  /// In zh, this message translates to:
  /// **'未命名物品'**
  String get uiUnnamedItem;

  /// Application display copy. Source: lib/modules/itemview.dart:114, lib/features/revision_tracking/application/revision_field_registry.dart:98
  ///
  /// In zh, this message translates to:
  /// **'封存'**
  String get uiArchive;

  /// Application display copy. Source: lib/modules/itemview.dart:185
  ///
  /// In zh, this message translates to:
  /// **'{p1}（單件）'**
  String uiIndividual(String p1);

  /// Application display copy. Source: lib/modules/itemview.dart:282
  ///
  /// In zh, this message translates to:
  /// **'物品或 Scene 已更新，請重新開啟預覽後再提交。'**
  String get uiTheItemOrSceneChangedReopenThePreview;

  /// Application display copy. Source: lib/modules/itemview.dart:345
  ///
  /// In zh, this message translates to:
  /// **'請先建立人物、地點或事件，再新增物品關聯。'**
  String get uiCreateACharacterLocationOrEventBeforeAdding;

  /// Application display copy. Source: lib/modules/itemview.dart:357
  ///
  /// In zh, this message translates to:
  /// **'新增物品關聯'**
  String get uiAddItemLink;

  /// Application display copy. Source: lib/modules/itemview.dart:385
  ///
  /// In zh, this message translates to:
  /// **'單件：{p1}'**
  String uiIndividual2(String p1);

  /// Application display copy. Source: lib/modules/itemview.dart:410
  ///
  /// In zh, this message translates to:
  /// **'選擇連結目標'**
  String get uiChooseLinkTarget;

  /// Application display copy. Source: lib/modules/itemview.dart:433
  ///
  /// In zh, this message translates to:
  /// **'關係／用途'**
  String get uiRelationshipPurpose;

  /// Application display copy. Source: lib/modules/itemview.dart:454, lib/modules/itemview.dart:2835
  ///
  /// In zh, this message translates to:
  /// **'新增關聯'**
  String get uiAddLink;

  /// Application display copy. Source: lib/modules/itemview.dart:487
  ///
  /// In zh, this message translates to:
  /// **'請先建立人物或地點，再新增數量分配。'**
  String get uiCreateACharacterOrLocationBeforeAddingA;

  /// Application display copy. Source: lib/modules/itemview.dart:497
  ///
  /// In zh, this message translates to:
  /// **'新增數量分配'**
  String get uiAddQuantityAllocation;

  /// Application display copy. Source: lib/modules/itemview.dart:513
  ///
  /// In zh, this message translates to:
  /// **'分配對象'**
  String get uiAllocateTo;

  /// Application display copy. Source: lib/modules/itemview.dart:565, lib/modules/itemview.dart:2923
  ///
  /// In zh, this message translates to:
  /// **'新增分配'**
  String get uiAddAllocation;

  /// Application display copy. Source: lib/modules/itemview.dart:579
  ///
  /// In zh, this message translates to:
  /// **'數量必須是零或正整數，也可以留空表示未知。'**
  String get uiQuantityMustBeZeroOrAPositiveInteger2;

  /// Application display copy. Source: lib/modules/itemview.dart:632
  ///
  /// In zh, this message translates to:
  /// **'轉移前需要至少一個場景及另一個人物或地點。'**
  String get uiATransferRequiresAtLeastOneSceneAnd;

  /// Application display copy. Source: lib/modules/itemview.dart:653
  ///
  /// In zh, this message translates to:
  /// **'轉移聚合數量'**
  String get uiTransferAggregateQuantity;

  /// Application display copy. Source: lib/modules/itemview.dart:695
  ///
  /// In zh, this message translates to:
  /// **'轉移至'**
  String get uiTransferTo;

  /// Application display copy. Source: lib/modules/itemview.dart:723, lib/modules/itemview.dart:2965
  ///
  /// In zh, this message translates to:
  /// **'轉移數量'**
  String get uiQuantityToTransfer;

  /// Application display copy. Source: lib/modules/itemview.dart:733
  ///
  /// In zh, this message translates to:
  /// **'轉移後來源數量'**
  String get uiSourceQuantityAfterTransfer;

  /// Application display copy. Source: lib/modules/itemview.dart:734, lib/modules/itemview.dart:930
  ///
  /// In zh, this message translates to:
  /// **'來源數量未知，必須明確設定'**
  String get uiSourceQuantityIsUnknownSetItExplicitly;

  /// Application display copy. Source: lib/modules/itemview.dart:752
  ///
  /// In zh, this message translates to:
  /// **'轉移後目的數量'**
  String get uiDestinationQuantityAfterTransfer;

  /// Application display copy. Source: lib/modules/itemview.dart:753
  ///
  /// In zh, this message translates to:
  /// **'目的數量未知，必須明確設定'**
  String get uiDestinationQuantityIsUnknownSetItExplicitly;

  /// Application display copy. Source: lib/modules/itemview.dart:775
  ///
  /// In zh, this message translates to:
  /// **'建立轉移快照'**
  String get uiCreateTransferSnapshot;

  /// Application display copy. Source: lib/modules/itemview.dart:844
  ///
  /// In zh, this message translates to:
  /// **'請先將 Scene 放入時間軸，再拆出單件物品。'**
  String get uiAddTheSceneToTheTimelineBeforeSeparating;

  /// Application display copy. Source: lib/modules/itemview.dart:872
  ///
  /// In zh, this message translates to:
  /// **'建立專用單件'**
  String get uiCreateDedicatedItem;

  /// Application display copy. Source: lib/modules/itemview.dart:872
  ///
  /// In zh, this message translates to:
  /// **'從聚合數量拆出單件'**
  String get uiSeparateItemFromAggregateQuantity;

  /// Application display copy. Source: lib/modules/itemview.dart:889
  ///
  /// In zh, this message translates to:
  /// **'建立於 Scene'**
  String get uiCreatedInScene;

  /// Application display copy. Source: lib/modules/itemview.dart:906
  ///
  /// In zh, this message translates to:
  /// **'所選 Scene 尚無這筆聚合分配。'**
  String get uiThisAggregateAllocationDoesNotExistInThe;

  /// Application display copy. Source: lib/modules/itemview.dart:908
  ///
  /// In zh, this message translates to:
  /// **'所選 Scene 的來源數量未知。'**
  String get uiSourceQuantityIsUnknownInTheSelectedScene;

  /// Application display copy. Source: lib/modules/itemview.dart:909
  ///
  /// In zh, this message translates to:
  /// **'所選 Scene 的來源數量：{p1}'**
  String uiSourceQuantityInSelectedScene(String p1);

  /// Application display copy. Source: lib/modules/itemview.dart:918
  ///
  /// In zh, this message translates to:
  /// **'單件名稱'**
  String get uiIndividualItemName;

  /// Application display copy. Source: lib/modules/itemview.dart:929
  ///
  /// In zh, this message translates to:
  /// **'拆出後來源數量'**
  String get uiSourceQuantityAfterSeparation;

  /// Application display copy. Source: lib/modules/itemview.dart:939, lib/modules/itemview.dart:1107
  ///
  /// In zh, this message translates to:
  /// **'轉換備註'**
  String get uiConversionNotes;

  /// Application display copy. Source: lib/modules/itemview.dart:955
  ///
  /// In zh, this message translates to:
  /// **'建立單件'**
  String get uiCreateIndividualItem;

  /// Application display copy. Source: lib/modules/itemview.dart:1007
  ///
  /// In zh, this message translates to:
  /// **'已從聚合數量建立單件物品。'**
  String get uiCreatedAnIndividualItemFromTheAggregateQuantity;

  /// Application display copy. Source: lib/modules/itemview.dart:1027
  ///
  /// In zh, this message translates to:
  /// **'請先將 Scene 放入時間軸，再轉為非專用。'**
  String get uiAddTheSceneToTheTimelineBeforeConverting;

  /// Application display copy. Source: lib/modules/itemview.dart:1063
  ///
  /// In zh, this message translates to:
  /// **'安全轉為非專用'**
  String get uiSafelyConvertToNonDedicated;

  /// Application display copy. Source: lib/modules/itemview.dart:1080
  ///
  /// In zh, this message translates to:
  /// **'轉換 Scene'**
  String get uiConversionScene;

  /// Application display copy. Source: lib/modules/itemview.dart:1097
  ///
  /// In zh, this message translates to:
  /// **'將彙總 {p1} 件當時存在的單件，建立 {p2} 筆聚合分配。'**
  String uiAggregateExistingIndividualItemsIntoQuantityAllocations(
    String p1,
    String p2,
  );

  /// Application display copy. Source: lib/modules/itemview.dart:1101
  ///
  /// In zh, this message translates to:
  /// **'原 Class、instance ID、快照與一般關聯會保留為封存歷史。'**
  String get uiTheOriginalClassInstanceIDsSnapshotsAndGeneral;

  /// Application display copy. Source: lib/modules/itemview.dart:1121
  ///
  /// In zh, this message translates to:
  /// **'建立聚合 Class'**
  String get uiCreateAggregateClass;

  /// Application display copy. Source: lib/modules/itemview.dart:1187
  ///
  /// In zh, this message translates to:
  /// **'已建立新的非專用聚合 Class。'**
  String get uiCreatedANewNonDedicatedAggregateClass;

  /// Application display copy. Source: lib/modules/itemview.dart:1233
  ///
  /// In zh, this message translates to:
  /// **'轉為專用前只能剩下一筆、數量為 1 的聚合分配；可先轉為半專用逐件拆分。'**
  String get uiConvertingToDedicatedModeRequiresOneAllocationWith;

  /// Application display copy. Source: lib/modules/itemview.dart:1250
  ///
  /// In zh, this message translates to:
  /// **'目前有多個固定 ID，不能直接合併為一件專用物品。'**
  String get uiMultipleFixedIDsCannotBeMergedDirectlyInto;

  /// Application display copy. Source: lib/modules/itemview.dart:1266
  ///
  /// In zh, this message translates to:
  /// **'仍有未拆分的聚合數量，請先逐件拆分後再轉為專用。'**
  String get uiSeparateAllRemainingAggregateQuantitiesBeforeConvertingTo;

  /// Application display copy. Source: lib/modules/itemview.dart:1297
  ///
  /// In zh, this message translates to:
  /// **'搬移世界設定物品'**
  String get uiMoveWorldbuildingItems;

  /// Application display copy. Source: lib/modules/itemview.dart:1298
  ///
  /// In zh, this message translates to:
  /// **'將 {p1} 筆世界設定物品搬到獨立物品頁。原物品 ID、內容與來源路徑會保留。'**
  String uiMoveWorldbuildingItemsToTheItemsPageIDs(String p1);

  /// Application display copy. Source: lib/modules/itemview.dart:1306, lib/modules/worldsettingsview.dart:1631
  ///
  /// In zh, this message translates to:
  /// **'搬移'**
  String get uiMove;

  /// Application display copy. Source: lib/modules/itemview.dart:1333
  ///
  /// In zh, this message translates to:
  /// **'已搬移 {p1} 筆物品{p2}'**
  String uiMovedItems(String p1, String p2);

  /// Application display copy. Source: lib/modules/itemview.dart:1333
  ///
  /// In zh, this message translates to:
  /// **'，{p1} 筆需留意'**
  String uiNeedAttention(String p1);

  /// Application display copy. Source: lib/modules/itemview.dart:1347
  ///
  /// In zh, this message translates to:
  /// **'請先將 Scene 放入時間軸，再新增物品快照。'**
  String get uiAddTheSceneToTheTimelineBeforeAdding;

  /// Application display copy. Source: lib/modules/itemview.dart:1369
  ///
  /// In zh, this message translates to:
  /// **'新增物品場景快照'**
  String get uiAddItemSceneSnapshot;

  /// Application display copy. Source: lib/modules/itemview.dart:1369
  ///
  /// In zh, this message translates to:
  /// **'複製物品場景快照'**
  String get uiDuplicateItemSceneSnapshot;

  /// Application display copy. Source: lib/modules/itemview.dart:1402, lib/modules/itemview.dart:1602, lib/modules/worldsettingsview.dart:979
  ///
  /// In zh, this message translates to:
  /// **'此時已存在'**
  String get uiExistsAtThisPoint;

  /// Application display copy. Source: lib/modules/itemview.dart:1425, lib/modules/itemview.dart:1625, lib/presentation/widgets/snapshot_state_editor.dart:69
  ///
  /// In zh, this message translates to:
  /// **'持有人'**
  String get uiHolder;

  /// Application display copy. Source: lib/modules/itemview.dart:1435, lib/modules/itemview.dart:1465, lib/modules/itemview.dart:1635
  ///
  /// In zh, this message translates to:
  /// **'找不到：{p1}'**
  String uiNotFound(String p1);

  /// Application display copy. Source: lib/modules/itemview.dart:1457, lib/modules/itemview.dart:1657, lib/presentation/widgets/snapshot_state_editor.dart:82
  ///
  /// In zh, this message translates to:
  /// **'所在地'**
  String get uiLocation2;

  /// Application display copy. Source: lib/modules/itemview.dart:1544
  ///
  /// In zh, this message translates to:
  /// **'請先將 Scene 放入時間軸，再新增單件物品快照。'**
  String get uiAddTheSceneToTheTimelineBeforeAdding2;

  /// Application display copy. Source: lib/modules/itemview.dart:1568, lib/modules/worldsettingsview.dart:817
  ///
  /// In zh, this message translates to:
  /// **'{p1}「{p2}」場景快照'**
  String uiSceneSnapshot(String p1, String p2);

  /// Application display copy. Source: lib/modules/itemview.dart:1797, lib/features/navigation/app_module.dart:80, lib/features/revision_tracking/application/revision_field_registry.dart:54
  ///
  /// In zh, this message translates to:
  /// **'物品設定'**
  String get uiItemSettings;

  /// Application display copy. Source: lib/modules/itemview.dart:1803
  ///
  /// In zh, this message translates to:
  /// **'搬移世界設定中的 {p1} 筆物品'**
  String uiMoveItemsFromWorldbuilding(String p1);

  /// Application display copy. Source: lib/modules/itemview.dart:1809
  ///
  /// In zh, this message translates to:
  /// **'新增物品'**
  String get uiAddItem;

  /// Application display copy. Source: lib/modules/itemview.dart:1843
  ///
  /// In zh, this message translates to:
  /// **'請先選取物品'**
  String get uiSelectAnItemFirst;

  /// Application display copy. Source: lib/modules/itemview.dart:1844
  ///
  /// In zh, this message translates to:
  /// **'選取物品後即可預覽時間軸與管理快照'**
  String get uiSelectAnItemToPreviewItsTimelineAnd;

  /// Application display copy. Source: lib/modules/itemview.dart:1877, lib/modules/itemview.dart:1953
  ///
  /// In zh, this message translates to:
  /// **'物品清單'**
  String get uiItemList;

  /// Application display copy. Source: lib/modules/itemview.dart:1885
  ///
  /// In zh, this message translates to:
  /// **'搜尋物品'**
  String get uiSearchItems;

  /// Application display copy. Source: lib/modules/itemview.dart:1901, lib/modules/itemview.dart:2718, lib/features/revision_tracking/application/revision_field_registry.dart:96
  ///
  /// In zh, this message translates to:
  /// **'管理模式'**
  String get uiManagementMode;

  /// Application display copy. Source: lib/modules/itemview.dart:1919
  ///
  /// In zh, this message translates to:
  /// **'歸屬'**
  String get uiOwnership;

  /// Application display copy. Source: lib/modules/itemview.dart:1922
  ///
  /// In zh, this message translates to:
  /// **'已有歸屬'**
  String get uiAssigned;

  /// Application display copy. Source: lib/modules/itemview.dart:1923
  ///
  /// In zh, this message translates to:
  /// **'尚無歸屬'**
  String get uiUnassigned;

  /// Application display copy. Source: lib/modules/itemview.dart:1936, lib/modules/itemview.dart:2709, lib/features/revision_tracking/application/revision_field_registry.dart:94
  ///
  /// In zh, this message translates to:
  /// **'分類'**
  String get uiCategory;

  /// Application display copy. Source: lib/modules/itemview.dart:1938
  ///
  /// In zh, this message translates to:
  /// **'全部分類'**
  String get uiAllCategories;

  /// Application display copy. Source: lib/modules/itemview.dart:1960
  ///
  /// In zh, this message translates to:
  /// **'尚無物品'**
  String get uiNoItemsYet;

  /// Application display copy. Source: lib/modules/itemview.dart:1961
  ///
  /// In zh, this message translates to:
  /// **'新增第一個物品'**
  String get uiAddYourFirstItem;

  /// Application display copy. Source: lib/modules/itemview.dart:1997
  ///
  /// In zh, this message translates to:
  /// **'{p1} · {p2} 件單件 · {p3} 個關聯{p4}'**
  String uiIndividualItemsLinks(String p1, String p2, String p3, String p4);

  /// Application display copy. Source: lib/modules/itemview.dart:1998
  ///
  /// In zh, this message translates to:
  /// **' · 已有歸屬'**
  String get uiAssigned2;

  /// Application display copy. Source: lib/modules/itemview.dart:2011
  ///
  /// In zh, this message translates to:
  /// **'編輯物品'**
  String get uiEditItem;

  /// Application display copy. Source: lib/modules/itemview.dart:2043, lib/modules/itemview.dart:2069
  ///
  /// In zh, this message translates to:
  /// **'物品詳情'**
  String get uiItemDetails;

  /// Application display copy. Source: lib/modules/itemview.dart:2051
  ///
  /// In zh, this message translates to:
  /// **'選擇或新增物品'**
  String get uiSelectOrAddAnItem;

  /// Application display copy. Source: lib/modules/itemview.dart:2052
  ///
  /// In zh, this message translates to:
  /// **'物品的模式、快照、歸屬與關聯會顯示在這裡'**
  String get uiItemModeSnapshotsOwnershipAndLinksAppearHere;

  /// Application display copy. Source: lib/modules/itemview.dart:2184, lib/modules/itemview.dart:2387, lib/modules/worldsettingsview.dart:2125
  ///
  /// In zh, this message translates to:
  /// **'刪除目前快照'**
  String get uiDeleteCurrentSnapshot;

  /// Application display copy. Source: lib/modules/itemview.dart:2197, lib/modules/itemview.dart:2405, lib/modules/worldsettingsview.dart:2131
  ///
  /// In zh, this message translates to:
  /// **'尚未選取快照'**
  String get uiNoSnapshotSelected;

  /// Application display copy. Source: lib/modules/itemview.dart:2205, lib/modules/worldsettingsview.dart:2139
  ///
  /// In zh, this message translates to:
  /// **'目前故事狀態'**
  String get uiCurrentStoryState;

  /// Application display copy. Source: lib/modules/itemview.dart:2208, lib/modules/worldsettingsview.dart:2142
  ///
  /// In zh, this message translates to:
  /// **'無快照'**
  String get uiNoSnapshots;

  /// Application display copy. Source: lib/modules/itemview.dart:2210, lib/modules/worldsettingsview.dart:2149
  ///
  /// In zh, this message translates to:
  /// **'存在'**
  String get uiExists;

  /// Application display copy. Source: lib/modules/itemview.dart:2210, lib/modules/worldsettingsview.dart:2149
  ///
  /// In zh, this message translates to:
  /// **'尚未存在'**
  String get uiDoesNotExistYet;

  /// Application display copy. Source: lib/modules/itemview.dart:2211
  ///
  /// In zh, this message translates to:
  /// **'未設定狀態'**
  String get uiStateNotSet;

  /// Application display copy. Source: lib/modules/itemview.dart:2213, lib/modules/itemview.dart:2521, lib/presentation/widgets/project_object_selector.dart:323
  ///
  /// In zh, this message translates to:
  /// **'持有人：{p1}'**
  String uiHolder2(String p1);

  /// Application display copy. Source: lib/modules/itemview.dart:2215, lib/modules/itemview.dart:2523, lib/presentation/widgets/project_object_selector.dart:325
  ///
  /// In zh, this message translates to:
  /// **'所在地：{p1}'**
  String uiLocation3(String p1);

  /// Application display copy. Source: lib/modules/itemview.dart:2224, lib/modules/worldsettingsview.dart:2164
  ///
  /// In zh, this message translates to:
  /// **'快照歷程（{p1}）'**
  String uiSnapshotHistory(String p1);

  /// Application display copy. Source: lib/modules/itemview.dart:2237, lib/modules/itemview.dart:2545, lib/modules/worldsettingsview.dart:2177
  ///
  /// In zh, this message translates to:
  /// **'連結此 Scene'**
  String get uiLinkThisScene;

  /// Application display copy. Source: lib/modules/itemview.dart:2249
  ///
  /// In zh, this message translates to:
  /// **'移除快照'**
  String get uiRemoveSnapshot;

  /// Application display copy. Source: lib/modules/itemview.dart:2517
  ///
  /// In zh, this message translates to:
  /// **'此場景尚未存在'**
  String get uiDoesNotExistInThisScene;

  /// Application display copy. Source: lib/modules/itemview.dart:2517
  ///
  /// In zh, this message translates to:
  /// **'此場景存在'**
  String get uiExistsInThisScene;

  /// Application display copy. Source: lib/modules/itemview.dart:2673, lib/modules/outlineview.dart:3004, lib/modules/worldsettingsview.dart:2353
  ///
  /// In zh, this message translates to:
  /// **'名稱'**
  String get uiName2;

  /// Application display copy. Source: lib/modules/itemview.dart:2693, lib/features/revision_tracking/application/revision_field_registry.dart:95
  ///
  /// In zh, this message translates to:
  /// **'數量單位'**
  String get uiQuantityUnit;

  /// Application display copy. Source: lib/modules/itemview.dart:2757, lib/features/revision_tracking/application/revision_field_registry.dart:93
  ///
  /// In zh, this message translates to:
  /// **'設定說明'**
  String get uiDescription;

  /// Application display copy. Source: lib/modules/itemview.dart:2778, lib/modules/outlineview.dart:2616, lib/modules/outlineview.dart:2828
  ///
  /// In zh, this message translates to:
  /// **'單件物品'**
  String get uiIndividualItems;

  /// Application display copy. Source: lib/modules/itemview.dart:2788
  ///
  /// In zh, this message translates to:
  /// **'新增單件'**
  String get uiAddIndividualItem;

  /// Application display copy. Source: lib/modules/itemview.dart:2806
  ///
  /// In zh, this message translates to:
  /// **'尚未建立單件物品。'**
  String get uiNoIndividualItemsCreatedYet;

  /// Application display copy. Source: lib/modules/itemview.dart:2829
  ///
  /// In zh, this message translates to:
  /// **'關聯'**
  String get uiLinks;

  /// Application display copy. Source: lib/modules/itemview.dart:2842
  ///
  /// In zh, this message translates to:
  /// **'尚未連結人物、地點或事件。'**
  String get uiNoCharactersLocationsOrEventsLinkedYet;

  /// Application display copy. Source: lib/modules/itemview.dart:2870
  ///
  /// In zh, this message translates to:
  /// **'移除關聯'**
  String get uiRemoveLink;

  /// Application display copy. Source: lib/modules/itemview.dart:2905
  ///
  /// In zh, this message translates to:
  /// **'非專用模式以 Class 與聚合分配管理，不建立單件 ID。'**
  String get uiNonDedicatedModeUsesClassesAndAggregateAllocations;

  /// Application display copy. Source: lib/modules/itemview.dart:2906
  ///
  /// In zh, this message translates to:
  /// **'半專用模式保留尚未識別的聚合數量，並可在 Scene 中逐件拆出固定 ID。'**
  String get uiSemiDedicatedModeKeepsUnidentifiedAggregateQuantitiesAnd;

  /// Application display copy. Source: lib/modules/itemview.dart:2907
  ///
  /// In zh, this message translates to:
  /// **'此區顯示轉為專用前的歷史聚合數量。'**
  String get uiThisSectionShowsHistoricalAggregateQuantitiesFromBefore;

  /// Application display copy. Source: lib/modules/itemview.dart:2914
  ///
  /// In zh, this message translates to:
  /// **'數量分配：{p1}{p2}{p3}'**
  String uiAllocatedQuantity(String p1, String p2, String p3);

  /// Application display copy. Source: lib/modules/itemview.dart:2914
  ///
  /// In zh, this message translates to:
  /// **'，另有未知數量'**
  String get uiPlusAnUnknownQuantity;

  /// Application display copy. Source: lib/modules/itemview.dart:2930
  ///
  /// In zh, this message translates to:
  /// **'尚未分配數量。'**
  String get uiNoQuantityAllocatedYet;

  /// Application display copy. Source: lib/modules/itemview.dart:2950
  ///
  /// In zh, this message translates to:
  /// **'找不到分配對象'**
  String get uiAllocationTargetNotFound;

  /// Application display copy. Source: lib/modules/itemview.dart:2950, lib/presentation/widgets/project_object_selector.dart:286
  ///
  /// In zh, this message translates to:
  /// **'未分配'**
  String get uiUnallocated;

  /// Application display copy. Source: lib/modules/itemview.dart:2955
  ///
  /// In zh, this message translates to:
  /// **'數量未知'**
  String get uiUnknownQuantity;

  /// Application display copy. Source: lib/modules/itemview.dart:2980
  ///
  /// In zh, this message translates to:
  /// **'拆出單件物品'**
  String get uiSeparateIndividualItem;

  /// Application display copy. Source: lib/modules/itemview.dart:2988
  ///
  /// In zh, this message translates to:
  /// **'移除預設分配'**
  String get uiRemoveDefaultAllocation;

  /// Application display copy. Source: lib/modules/outlineview.dart:1726, lib/features/navigation/app_module.dart:66, lib/features/revision_tracking/application/revision_field_registry.dart:53
  ///
  /// In zh, this message translates to:
  /// **'大綱調整'**
  String get uiOutline;

  /// Application display copy. Source: lib/modules/outlineview.dart:1787
  ///
  /// In zh, this message translates to:
  /// **'大箱（故事線）'**
  String get uiStorylines;

  /// Application display copy. Source: lib/modules/outlineview.dart:1829
  ///
  /// In zh, this message translates to:
  /// **'暫無故事線'**
  String get uiNoStorylinesYet;

  /// Application display copy. Source: lib/modules/outlineview.dart:1853, lib/modules/outlineview.dart:2044
  ///
  /// In zh, this message translates to:
  /// **'故事線名稱'**
  String get uiStorylineName;

  /// Application display copy. Source: lib/modules/outlineview.dart:1867
  ///
  /// In zh, this message translates to:
  /// **'大箱：故事的大致走向。標記可以使用「三幕劇」、「起承轉合」、「故事七步驟」等結構'**
  String get uiStorylineTheBroadDirectionOfYourStoryUse;

  /// Application display copy. Source: lib/modules/outlineview.dart:1898, lib/modules/outlineview.dart:2217
  ///
  /// In zh, this message translates to:
  /// **'(未命名故事線)'**
  String get uiUntitledStoryline;

  /// Application display copy. Source: lib/modules/outlineview.dart:1921, lib/modules/outlineview.dart:2343
  ///
  /// In zh, this message translates to:
  /// **'(未命名事件)'**
  String get uiUntitledEvent;

  /// Application display copy. Source: lib/modules/outlineview.dart:1945, lib/modules/outlineview.dart:3349
  ///
  /// In zh, this message translates to:
  /// **'(未命名場景)'**
  String get uiUntitledScene;

  /// Application display copy. Source: lib/modules/outlineview.dart:2031
  ///
  /// In zh, this message translates to:
  /// **'大箱內容（故事線細節）'**
  String get uiStorylineDetails;

  /// Application display copy. Source: lib/modules/outlineview.dart:2056
  ///
  /// In zh, this message translates to:
  /// **'類型 (如：開頭、中段、高潮、結尾)'**
  String get uiTypeEGOpeningMiddleClimaxEnding;

  /// Application display copy. Source: lib/modules/outlineview.dart:2068
  ///
  /// In zh, this message translates to:
  /// **'主要衝突'**
  String get uiMainConflict;

  /// Application display copy. Source: lib/modules/outlineview.dart:2081, lib/modules/outlineview.dart:2674, lib/modules/outlineview.dart:3736
  ///
  /// In zh, this message translates to:
  /// **'輸入備註...'**
  String get uiEnterNotes;

  /// Application display copy. Source: lib/modules/outlineview.dart:2102
  ///
  /// In zh, this message translates to:
  /// **'中箱（事件）'**
  String get uiEvents;

  /// Application display copy. Source: lib/modules/outlineview.dart:2131
  ///
  /// In zh, this message translates to:
  /// **'此故事線暫無事件'**
  String get uiNoEventsInThisStorylineYet;

  /// Application display copy. Source: lib/modules/outlineview.dart:2154, lib/modules/outlineview.dart:2495
  ///
  /// In zh, this message translates to:
  /// **'事件名稱'**
  String get uiEventName;

  /// Application display copy. Source: lib/modules/outlineview.dart:2170
  ///
  /// In zh, this message translates to:
  /// **'請先選擇故事線'**
  String get uiSelectAStorylineFirst;

  /// Application display copy. Source: lib/modules/outlineview.dart:2171
  ///
  /// In zh, this message translates to:
  /// **'選擇故事線後即可新增與編輯事件'**
  String get uiSelectAStorylineToAddAndEditEvents;

  /// Application display copy. Source: lib/modules/outlineview.dart:2178
  ///
  /// In zh, this message translates to:
  /// **'中箱：具體發生的事件。'**
  String get uiEventASpecificOccurrenceInTheStory;

  /// Application display copy. Source: lib/modules/outlineview.dart:2226, lib/presentation/widgets/scene_range_view.dart:71
  ///
  /// In zh, this message translates to:
  /// **'未設定類型'**
  String get uiTypeNotSet;

  /// Application display copy. Source: lib/modules/outlineview.dart:2251
  ///
  /// In zh, this message translates to:
  /// **'刪除故事線'**
  String get uiDeleteStoryline;

  /// Application display copy. Source: lib/modules/outlineview.dart:2308
  ///
  /// In zh, this message translates to:
  /// **'事件已移動到「{p1}」'**
  String uiEventMovedTo(String p1);

  /// Application display copy. Source: lib/modules/outlineview.dart:2352
  ///
  /// In zh, this message translates to:
  /// **'{p1} 個場景'**
  String uiScenes(String p1);

  /// Application display copy. Source: lib/modules/outlineview.dart:2374
  ///
  /// In zh, this message translates to:
  /// **'刪除事件'**
  String get uiDeleteEvent;

  /// Application display copy. Source: lib/modules/outlineview.dart:2474
  ///
  /// In zh, this message translates to:
  /// **'中箱內容（事件細節）'**
  String get uiEventDetails;

  /// Application display copy. Source: lib/modules/outlineview.dart:2518, lib/modules/outlineview.dart:3624
  ///
  /// In zh, this message translates to:
  /// **'衝突點'**
  String get uiPointOfConflict;

  /// Application display copy. Source: lib/modules/outlineview.dart:2528
  ///
  /// In zh, this message translates to:
  /// **'預設人物'**
  String get uiDefaultCharacters;

  /// Application display copy. Source: lib/modules/outlineview.dart:2583, lib/modules/outlineview.dart:2798
  ///
  /// In zh, this message translates to:
  /// **'物品分配'**
  String get uiItemAllocations;

  /// Application display copy. Source: lib/modules/outlineview.dart:2597, lib/modules/outlineview.dart:2812
  ///
  /// In zh, this message translates to:
  /// **'尚未分配正式物品。'**
  String get uiNoTrackedItemsAllocatedYet;

  /// Application display copy. Source: lib/modules/outlineview.dart:2615, lib/modules/outlineview.dart:2827
  ///
  /// In zh, this message translates to:
  /// **'物品 Class'**
  String get uiItemClass;

  /// Application display copy. Source: lib/modules/outlineview.dart:2700
  ///
  /// In zh, this message translates to:
  /// **'選擇要連結的事件物品'**
  String get uiChooseAnEventItemToLink;

  /// Application display copy. Source: lib/modules/outlineview.dart:2718, lib/modules/outlineview.dart:2889, lib/modules/outlineview.dart:3184
  ///
  /// In zh, this message translates to:
  /// **'大綱物件'**
  String get uiOutlineObjects;

  /// Application display copy. Source: lib/modules/outlineview.dart:2733
  ///
  /// In zh, this message translates to:
  /// **'以下是舊版文字物件。請轉換為正式物品；大綱已不再新增舊格式物件。'**
  String get uiTheseAreLegacyTextObjectsConvertThemTo;

  /// Application display copy. Source: lib/modules/outlineview.dart:2842
  ///
  /// In zh, this message translates to:
  /// **'移除分配'**
  String get uiRemoveAllocation;

  /// Application display copy. Source: lib/modules/outlineview.dart:2871
  ///
  /// In zh, this message translates to:
  /// **'選擇要分配給場景的物品'**
  String get uiChooseAnItemToAllocateToTheScene;

  /// Application display copy. Source: lib/modules/outlineview.dart:2905
  ///
  /// In zh, this message translates to:
  /// **'轉換成功後會移除這筆舊文字，改用可追蹤的正式物品 ID 關聯。'**
  String get uiAfterConversionThisLegacyTextIsReplacedWith;

  /// Application display copy. Source: lib/modules/outlineview.dart:2925, lib/modules/outlineview.dart:3052
  ///
  /// In zh, this message translates to:
  /// **'建立並連結'**
  String get uiCreateAndLink;

  /// Application display copy. Source: lib/modules/outlineview.dart:2952
  ///
  /// In zh, this message translates to:
  /// **'選擇「{p1}」對應的物品'**
  String uiChooseTheItemFor(String p1);

  /// Application display copy. Source: lib/modules/outlineview.dart:2977
  ///
  /// In zh, this message translates to:
  /// **'已轉為正式物品關聯。'**
  String get uiConvertedToATrackedItemLink;

  /// Application display copy. Source: lib/modules/outlineview.dart:3033
  ///
  /// In zh, this message translates to:
  /// **'非專用（只建立 Class）'**
  String get uiNonDedicatedClassOnly;

  /// Application display copy. Source: lib/modules/outlineview.dart:3185
  ///
  /// In zh, this message translates to:
  /// **'由舊文字「{p1}」轉換'**
  String uiConvertedFromLegacyText(String p1);

  /// Application display copy. Source: lib/modules/outlineview.dart:3212
  ///
  /// In zh, this message translates to:
  /// **'小箱（場景）'**
  String get uiScenes2;

  /// Application display copy. Source: lib/modules/outlineview.dart:3254
  ///
  /// In zh, this message translates to:
  /// **'暫無場景'**
  String get uiNoScenesYet;

  /// Application display copy. Source: lib/modules/outlineview.dart:3284, lib/modules/outlineview.dart:3519
  ///
  /// In zh, this message translates to:
  /// **'場景名稱'**
  String get uiSceneName2;

  /// Application display copy. Source: lib/modules/outlineview.dart:3299
  ///
  /// In zh, this message translates to:
  /// **'請先選擇一個事件'**
  String get uiSelectAnEventFirst;

  /// Application display copy. Source: lib/modules/outlineview.dart:3300
  ///
  /// In zh, this message translates to:
  /// **'選擇事件後即可新增與編輯場景'**
  String get uiSelectAnEventToAddAndEditScenes;

  /// Application display copy. Source: lib/modules/outlineview.dart:3307
  ///
  /// In zh, this message translates to:
  /// **'小箱：事件的詳細場景。'**
  String get uiSceneADetailedSceneWithinAnEvent;

  /// Application display copy. Source: lib/modules/outlineview.dart:3413
  ///
  /// In zh, this message translates to:
  /// **'刪除場景'**
  String get uiDeleteScene;

  /// Application display copy. Source: lib/modules/outlineview.dart:3498
  ///
  /// In zh, this message translates to:
  /// **'小箱內容（場景細節）'**
  String get uiSceneDetails;

  /// Application display copy. Source: lib/modules/outlineview.dart:3546, lib/features/revision_tracking/application/revision_field_registry.dart:90
  ///
  /// In zh, this message translates to:
  /// **'時間'**
  String get uiTime;

  /// Application display copy. Source: lib/modules/outlineview.dart:3600
  ///
  /// In zh, this message translates to:
  /// **'聚焦點'**
  String get uiFocus;

  /// Application display copy. Source: lib/modules/outlineview.dart:3694, lib/features/revision_tracking/application/revision_field_registry.dart:89
  ///
  /// In zh, this message translates to:
  /// **'行動'**
  String get uiAction;

  /// Application display copy. Source: lib/modules/outlineview.dart:3750
  ///
  /// In zh, this message translates to:
  /// **'故事線 {p1}'**
  String uiStoryline2(String p1);

  /// Application display copy. Source: lib/modules/outlineview.dart:3779
  ///
  /// In zh, this message translates to:
  /// **'事件 {p1}'**
  String uiEvent3(String p1);

  /// Application display copy. Source: lib/modules/outlineview.dart:3813
  ///
  /// In zh, this message translates to:
  /// **'場景 {p1}'**
  String uiScene(String p1);

  /// Application display copy. Source: lib/modules/palettesview.dart:102
  ///
  /// In zh, this message translates to:
  /// **'已略過或修復 {p1} 項調色盤資料問題。'**
  String uiSkippedOrRepairedPaletteDataIssues(String p1);

  /// Application display copy. Source: lib/modules/palettesview.dart:111
  ///
  /// In zh, this message translates to:
  /// **'調色盤資料無法讀取：{p1}'**
  String uiCouldNotReadPaletteData(String p1);

  /// Application display copy. Source: lib/modules/palettesview.dart:235
  ///
  /// In zh, this message translates to:
  /// **'已刪除「{p1}」'**
  String uiDeleted(String p1);

  /// Application display copy. Source: lib/modules/palettesview.dart:283
  ///
  /// In zh, this message translates to:
  /// **'匯出文字色票'**
  String get uiExportTextPalette;

  /// Application display copy. Source: lib/modules/palettesview.dart:311
  ///
  /// In zh, this message translates to:
  /// **'色票匯出完成：{p1}'**
  String uiPaletteExported(String p1);

  /// Application display copy. Source: lib/modules/palettesview.dart:320
  ///
  /// In zh, this message translates to:
  /// **'色票匯出失敗：{p1}'**
  String uiPaletteExportFailed(String p1);

  /// Application display copy. Source: lib/modules/palettesview.dart:331
  ///
  /// In zh, this message translates to:
  /// **'匯入文字色票'**
  String get uiImportTextPalette;

  /// Application display copy. Source: lib/modules/palettesview.dart:365
  ///
  /// In zh, this message translates to:
  /// **'，另略過 {p1} 項格式問題'**
  String uiWithFormatIssuesSkipped(String p1);

  /// Application display copy. Source: lib/modules/palettesview.dart:369
  ///
  /// In zh, this message translates to:
  /// **'匯入完成：新增 {p1} 個色票詞條、略過 {p2} 個重複詞條{p3}'**
  String uiImportedPaletteEntriesSkippedDuplicates(
    String p1,
    String p2,
    String p3,
  );

  /// Application display copy. Source: lib/modules/palettesview.dart:385
  ///
  /// In zh, this message translates to:
  /// **'色票匯入失敗：檔案格式錯誤或無法讀取'**
  String get uiPaletteImportFailedInvalidFormatOrUnreadableFile;

  /// Application display copy. Source: lib/modules/palettesview.dart:404
  ///
  /// In zh, this message translates to:
  /// **'調色盤載入失敗'**
  String get uiCouldNotLoadPalettes;

  /// Application display copy. Source: lib/modules/palettesview.dart:442
  ///
  /// In zh, this message translates to:
  /// **'尚未寫入磁碟'**
  String get uiNotSavedToDiskYet;

  /// Application display copy. Source: lib/modules/palettesview.dart:473, lib/features/navigation/app_module.dart:86
  ///
  /// In zh, this message translates to:
  /// **'文字色票'**
  String get uiTextPalettes;

  /// Application display copy. Source: lib/modules/palettesview.dart:482
  ///
  /// In zh, this message translates to:
  /// **'搜尋詞條……'**
  String get uiSearchEntries;

  /// Application display copy. Source: lib/modules/palettesview.dart:496
  ///
  /// In zh, this message translates to:
  /// **'匯入或匯出色票'**
  String get uiImportOrExportPalettes;

  /// Application display copy. Source: lib/modules/palettesview.dart:514
  ///
  /// In zh, this message translates to:
  /// **'匯入色票……'**
  String get uiImportPalette;

  /// Application display copy. Source: lib/modules/palettesview.dart:522
  ///
  /// In zh, this message translates to:
  /// **'匯出色票……'**
  String get uiExportPalette;

  /// Application display copy. Source: lib/modules/palettesview.dart:557
  ///
  /// In zh, this message translates to:
  /// **'灰階'**
  String get uiGrayscale;

  /// Application display copy. Source: lib/modules/palettesview.dart:694
  ///
  /// In zh, this message translates to:
  /// **'色相 {p1}°，飽和度 80%，明度 100%'**
  String uiHueSaturationBrightness(String p1);

  /// Application display copy. Source: lib/modules/palettesview.dart:788
  ///
  /// In zh, this message translates to:
  /// **'{p1}，{p2} 個詞條'**
  String uiEntries2(String p1, String p2);

  /// Application display copy. Source: lib/modules/palettesview.dart:806
  ///
  /// In zh, this message translates to:
  /// **'{p1} 個詞條'**
  String uiEntries3(String p1);

  /// Application display copy. Source: lib/modules/palettesview.dart:811
  ///
  /// In zh, this message translates to:
  /// **'色格操作'**
  String get uiColorCellActions;

  /// Application display copy. Source: lib/modules/palettesview.dart:824
  ///
  /// In zh, this message translates to:
  /// **'依文字排序'**
  String get uiSortByText;

  /// Application display copy. Source: lib/modules/palettesview.dart:852, lib/ui_library/alias_terms.dart:80
  ///
  /// In zh, this message translates to:
  /// **'編輯「{p1}」'**
  String uiEdit2(String p1);

  /// Application display copy. Source: lib/modules/palettesview.dart:866
  ///
  /// In zh, this message translates to:
  /// **'新增詞條'**
  String get uiAddEntry;

  /// Application display copy. Source: lib/modules/palettesview.dart:890
  ///
  /// In zh, this message translates to:
  /// **'輸入詞條'**
  String get uiEnterATerm;

  /// Application display copy. Source: lib/modules/palettesview.dart:925
  ///
  /// In zh, this message translates to:
  /// **'找不到包含「{p1}」的詞條'**
  String uiNoEntriesContaining(String p1);

  /// Application display copy. Source: lib/modules/planview.dart:1178, lib/modules/planview.dart:1181
  ///
  /// In zh, this message translates to:
  /// **'伏筆列表'**
  String get uiForeshadowingList;

  /// Application display copy. Source: lib/modules/planview.dart:1187
  ///
  /// In zh, this message translates to:
  /// **'尚無伏筆'**
  String get uiNoForeshadowingYet;

  /// Application display copy. Source: lib/modules/planview.dart:1188, lib/modules/planview.dart:1351
  ///
  /// In zh, this message translates to:
  /// **'請新增第一個項目'**
  String get uiAddYourFirstEntry2;

  /// Application display copy. Source: lib/modules/planview.dart:1282
  ///
  /// In zh, this message translates to:
  /// **'新增伏筆'**
  String get uiAddForeshadowing;

  /// Application display copy. Source: lib/modules/planview.dart:1286
  ///
  /// In zh, this message translates to:
  /// **'請選擇一個伏筆'**
  String get uiSelectAForeshadowingEntry;

  /// Application display copy. Source: lib/modules/planview.dart:1287, lib/modules/planview.dart:1447, lib/modules/planview.dart:1661
  ///
  /// In zh, this message translates to:
  /// **'選取後即可編輯內容'**
  String get uiSelectAnEntryToEditItsContent;

  /// Application display copy. Source: lib/modules/planview.dart:1298
  ///
  /// In zh, this message translates to:
  /// **'伏筆名稱'**
  String get uiForeshadowingName;

  /// Application display copy. Source: lib/modules/planview.dart:1314
  ///
  /// In zh, this message translates to:
  /// **'已揭露'**
  String get uiRevealed;

  /// Application display copy. Source: lib/modules/planview.dart:1341, lib/modules/planview.dart:1344, lib/presentation/widgets/radial_gauge_dashboard.dart:23
  ///
  /// In zh, this message translates to:
  /// **'更新計畫'**
  String get uiReleasePlans;

  /// Application display copy. Source: lib/modules/planview.dart:1350
  ///
  /// In zh, this message translates to:
  /// **'尚無更新計畫'**
  String get uiNoReleasePlansYet;

  /// Application display copy. Source: lib/modules/planview.dart:1442
  ///
  /// In zh, this message translates to:
  /// **'新增更新計畫'**
  String get uiAddReleasePlan;

  /// Application display copy. Source: lib/modules/planview.dart:1446
  ///
  /// In zh, this message translates to:
  /// **'請選擇一個更新計畫'**
  String get uiSelectAReleasePlan;

  /// Application display copy. Source: lib/modules/planview.dart:1458
  ///
  /// In zh, this message translates to:
  /// **'計畫名稱'**
  String get uiPlanName;

  /// Application display copy. Source: lib/modules/planview.dart:1474, lib/features/inline_annotations/inline_annotation_target_resolver.dart:61, lib/features/inline_annotations/inline_annotation_target_resolver.dart:291
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get uiCompleted;

  /// Application display copy. Source: lib/modules/planview.dart:1496
  ///
  /// In zh, this message translates to:
  /// **'靈感列表'**
  String get uiIdeaList;

  /// Application display copy. Source: lib/modules/planview.dart:1502
  ///
  /// In zh, this message translates to:
  /// **'尚無靈感'**
  String get uiNoIdeasYet;

  /// Application display copy. Source: lib/modules/planview.dart:1503
  ///
  /// In zh, this message translates to:
  /// **'請新增資料夾或靈感'**
  String get uiAddAFolderOrIdea;

  /// Application display copy. Source: lib/modules/planview.dart:1570, lib/presentation/widgets/snapshot_panel_card.dart:46
  ///
  /// In zh, this message translates to:
  /// **'展開'**
  String get uiExpand;

  /// Application display copy. Source: lib/modules/planview.dart:1648
  ///
  /// In zh, this message translates to:
  /// **'資料夾'**
  String get uiFolder2;

  /// Application display copy. Source: lib/modules/planview.dart:1650
  ///
  /// In zh, this message translates to:
  /// **'靈感'**
  String get uiIdea;

  /// Application display copy. Source: lib/modules/planview.dart:1660
  ///
  /// In zh, this message translates to:
  /// **'請選擇一則靈感'**
  String get uiSelectAnIdea;

  /// Application display copy. Source: lib/modules/planview.dart:1674
  ///
  /// In zh, this message translates to:
  /// **'靈感標題'**
  String get uiIdeaTitle;

  /// Application display copy. Source: lib/modules/planview.dart:1703
  ///
  /// In zh, this message translates to:
  /// **'靈感筆記'**
  String get uiIdeaNotes;

  /// Application display copy. Source: lib/modules/planview.dart:1766, lib/features/navigation/app_module.dart:84
  ///
  /// In zh, this message translates to:
  /// **'計畫規劃'**
  String get uiPlanning;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:568
  ///
  /// In zh, this message translates to:
  /// **'無法載入贅字詞庫：{p1}'**
  String uiCouldNotLoadTheFillerWordDictionary(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1251, lib/features/navigation/app_module.dart:87
  ///
  /// In zh, this message translates to:
  /// **'文本校正'**
  String get uiProofreading;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1270
  ///
  /// In zh, this message translates to:
  /// **'此處可協助執行文本檢查。'**
  String get uiCheckYourTextHere;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1274
  ///
  /// In zh, this message translates to:
  /// **'當前文本長度：{p1} 字元'**
  String uiCurrentTextLengthCharacters(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1276
  ///
  /// In zh, this message translates to:
  /// **'載入贅字詞庫中'**
  String get uiLoadingFillerWordDictionary;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1280
  ///
  /// In zh, this message translates to:
  /// **'贅字詞庫已載入 {p1} 筆'**
  String uiFillerWordDictionaryLoadedEntries(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1300, lib/modules/proofreadingview.dart:1466
  ///
  /// In zh, this message translates to:
  /// **'引號、括號閉合檢查'**
  String get uiQuoteAndBracketMatching;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1306
  ///
  /// In zh, this message translates to:
  /// **'結果數量過多，目前只保留各檢測的前段樣本；完整統計共 {p1} 筆。'**
  String uiTooManyResultsOnlyInitialSamplesAreShown(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1315, lib/modules/proofreadingview.dart:1482
  ///
  /// In zh, this message translates to:
  /// **'標點異常檢測'**
  String get uiPunctuationAnomalies;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1320, lib/modules/proofreadingview.dart:1529
  ///
  /// In zh, this message translates to:
  /// **'行尾辨識'**
  String get uiLineEndingCheck;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1324, lib/modules/proofreadingview.dart:1497
  ///
  /// In zh, this message translates to:
  /// **'標點符號格式統一'**
  String get uiPunctuationConsistency;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1328, lib/modules/proofreadingview.dart:1513
  ///
  /// In zh, this message translates to:
  /// **'贅字檢查'**
  String get uiFillerWordCheck;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1334
  ///
  /// In zh, this message translates to:
  /// **'贅字率計算'**
  String get uiFillerWordRatio;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1353
  ///
  /// In zh, this message translates to:
  /// **'檢測設定'**
  String get uiCheckSettings;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1413
  ///
  /// In zh, this message translates to:
  /// **'顯示更多（剩餘 {p1}）'**
  String uiShowMoreRemaining(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1467
  ///
  /// In zh, this message translates to:
  /// **'檢查配對與閉合狀態'**
  String get uiCheckPairedAndUnclosedDelimiters;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1483
  ///
  /// In zh, this message translates to:
  /// **'檢查連續標點與引號層級'**
  String get uiCheckRepeatedPunctuationAndQuoteNesting;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1498
  ///
  /// In zh, this message translates to:
  /// **'檢查可統一的標點替換'**
  String get uiFindPunctuationThatCanBeStandardized;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1514
  ///
  /// In zh, this message translates to:
  /// **'檢查詞庫中的贅字出現位置'**
  String get uiFindFillerWordsListedInTheDictionary;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1530
  ///
  /// In zh, this message translates to:
  /// **'檢查行尾符號是否符合規則'**
  String get uiCheckLineEndingsAgainstTheRules;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1546
  ///
  /// In zh, this message translates to:
  /// **'行尾辨識細項'**
  String get uiLineEndingOptions;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1549
  ///
  /// In zh, this message translates to:
  /// **'行尾逗號不提示'**
  String get uiIgnoreCommasAtLineEnd;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1550
  ///
  /// In zh, this message translates to:
  /// **'行尾為 , 或 ，時不顯示提示'**
  String get uiDoNotFlagLinesEndingInOr;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1565
  ///
  /// In zh, this message translates to:
  /// **'行尾破折號不提示'**
  String get uiIgnoreDashesAtLineEnd;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1566
  ///
  /// In zh, this message translates to:
  /// **'行尾為 — 或 - 時不顯示提示'**
  String get uiDoNotFlagLinesEndingInOr2;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1581
  ///
  /// In zh, this message translates to:
  /// **'行尾刪節號不提示'**
  String get uiIgnoreEllipsesAtLineEnd;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1582
  ///
  /// In zh, this message translates to:
  /// **'行尾為 … / …… 時不顯示提示'**
  String get uiDoNotFlagLinesEndingInOr3;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1597
  ///
  /// In zh, this message translates to:
  /// **'行尾冒號不提示'**
  String get uiIgnoreColonsAtLineEnd;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1598
  ///
  /// In zh, this message translates to:
  /// **'行尾為 : 或 ：時不顯示提示'**
  String get uiDoNotFlagLinesEndingInOr4;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1613
  ///
  /// In zh, this message translates to:
  /// **'行尾分號不提示'**
  String get uiIgnoreSemicolonsAtLineEnd;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1614
  ///
  /// In zh, this message translates to:
  /// **'行尾為；時不顯示提示'**
  String get uiDoNotFlagLinesEndingIn;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1630
  ///
  /// In zh, this message translates to:
  /// **'格式選項'**
  String get uiFormatOptions;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1641
  ///
  /// In zh, this message translates to:
  /// **'標點符號檢查格式'**
  String get uiPunctuationStyle;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1642
  ///
  /// In zh, this message translates to:
  /// **'請選擇格式'**
  String get uiChooseAStyle;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1646
  ///
  /// In zh, this message translates to:
  /// **'目前格式：{p1}'**
  String uiCurrentStyle(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1655
  ///
  /// In zh, this message translates to:
  /// **'拉丁文句檢測'**
  String get uiDetectLatinScriptSentences;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1657
  ///
  /// In zh, this message translates to:
  /// **'偵測到拉丁文字時，自動套用拉丁標點'**
  String get uiAutomaticallyUseLatinPunctuationWhenLatinTextIs;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1666
  ///
  /// In zh, this message translates to:
  /// **'拉丁字母辨識細項'**
  String get uiLatinScriptDetectionOptions;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1669
  ///
  /// In zh, this message translates to:
  /// **'允許字尾使用 CJK 引號/括號'**
  String get uiAllowCJKQuotesBracketsAtWordEnd;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1670
  ///
  /// In zh, this message translates to:
  /// **'拉丁字尾可接受 CJK 引號與括號'**
  String get uiAllowCJKQuotesAndBracketsAfterLatinText;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1685
  ///
  /// In zh, this message translates to:
  /// **'允許字尾使用 CJK 驚嘆號/問號'**
  String get uiAllowCJKExclamationQuestionMarksAtWordEnd;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1686
  ///
  /// In zh, this message translates to:
  /// **'拉丁字尾可接受 ！與 ？'**
  String get uiAllowAndAfterLatinText;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1701
  ///
  /// In zh, this message translates to:
  /// **'允許在 CJK 文字前後加入 CJK 標點'**
  String get uiAllowCJKPunctuationAroundCJKText;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1702
  ///
  /// In zh, this message translates to:
  /// **'若任一側語境為行首/CJK/行尾，CJK 標點不視為拉丁延伸'**
  String get uiDoNotTreatCJKPunctuationAsLatinContinuation;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1722, lib/modules/proofreadingview.dart:1793, lib/modules/proofreadingview.dart:1883
  ///
  /// In zh, this message translates to:
  /// **'此檢測已關閉。'**
  String get uiThisCheckIsDisabled;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1726, lib/modules/proofreadingview.dart:1797, lib/modules/proofreadingview.dart:1887
  ///
  /// In zh, this message translates to:
  /// **'請先輸入文本。'**
  String get uiEnterSomeTextFirst;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1731
  ///
  /// In zh, this message translates to:
  /// **'未發現閉合問題。'**
  String get uiNoUnclosedDelimitersFound;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1801
  ///
  /// In zh, this message translates to:
  /// **'尚未執行檢查。'**
  String get uiNoCheckRunYet;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1806
  ///
  /// In zh, this message translates to:
  /// **'格式已一致，無需調整。'**
  String get uiPunctuationIsConsistentNoChangesNeeded;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1822
  ///
  /// In zh, this message translates to:
  /// **'共偵測到 {p1} 處可統一的標點。'**
  String uiFoundPunctuationMarksThatCanBeStandardized(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1875, lib/modules/proofreadingview.dart:2014
  ///
  /// In zh, this message translates to:
  /// **'全部解決'**
  String get uiResolveAll;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1892
  ///
  /// In zh, this message translates to:
  /// **'未發現標點符號異常。'**
  String get uiNoPunctuationAnomaliesFound;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1990
  ///
  /// In zh, this message translates to:
  /// **'建議：{p1}'**
  String uiSuggestion(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2031
  ///
  /// In zh, this message translates to:
  /// **'未發現行尾異常。'**
  String get uiNoLineEndingIssuesFound;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2101
  ///
  /// In zh, this message translates to:
  /// **'未偵測到詞庫中的贅字。'**
  String get uiNoDictionaryFillerWordsFound;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2117
  ///
  /// In zh, this message translates to:
  /// **'點擊下列贅字展開位置列表。'**
  String get uiClickAFillerWordBelowToExpandIts;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2164
  ///
  /// In zh, this message translates to:
  /// **'出現 {p1} 次'**
  String uiOccurrences(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2188
  ///
  /// In zh, this message translates to:
  /// **'僅顯示前 {p1} 個位置。'**
  String uiShowingOnlyTheFirstLocations(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2231
  ///
  /// In zh, this message translates to:
  /// **'贅字總次數：{p1}'**
  String uiTotalFillerWordOccurrences(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2232
  ///
  /// In zh, this message translates to:
  /// **'有效字數：{p1}'**
  String uiEffectiveWordCount(String p1);

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2233
  ///
  /// In zh, this message translates to:
  /// **'贅字率：{p1}%'**
  String uiFillerWordRatio2(String p1);

  /// Application display copy. Source: lib/modules/settingview.dart:107
  ///
  /// In zh, this message translates to:
  /// **'請在系統提示中允許不受電池最佳化限制。'**
  String get uiAllowUnrestrictedBatteryUsageInTheSystemPrompt;

  /// Application display copy. Source: lib/modules/settingview.dart:112
  ///
  /// In zh, this message translates to:
  /// **'無法開啟背景執行權限。'**
  String get uiCouldNotOpenBackgroundExecutionPermissions;

  /// Application display copy. Source: lib/modules/settingview.dart:128
  ///
  /// In zh, this message translates to:
  /// **'已複製 MCP Host 設定。請貼到 Host 的 MCP 設定中。'**
  String get uiMCPHostConfigurationCopiedPasteItIntoYour;

  /// Application display copy. Source: lib/modules/settingview.dart:217
  ///
  /// In zh, this message translates to:
  /// **'外觀與介面'**
  String get uiAppearanceAndInterface;

  /// Application display copy. Source: lib/modules/settingview.dart:218
  ///
  /// In zh, this message translates to:
  /// **'主題、導覽、工具列與字體'**
  String get uiThemeNavigationToolbarAndFonts;

  /// Application display copy. Source: lib/modules/settingview.dart:231
  ///
  /// In zh, this message translates to:
  /// **'工具列項目編輯'**
  String get uiCustomizeToolbarItems;

  /// Application display copy. Source: lib/modules/settingview.dart:236
  ///
  /// In zh, this message translates to:
  /// **'編輯與輸入'**
  String get uiEditingAndInput;

  /// Application display copy. Source: lib/modules/settingview.dart:237
  ///
  /// In zh, this message translates to:
  /// **'智慧候選、覆寫、縮排與字數統計'**
  String get uiSmartSuggestionsOverwriteIndentationAndWordCount;

  /// Application display copy. Source: lib/modules/settingview.dart:243
  ///
  /// In zh, this message translates to:
  /// **'寫作目標'**
  String get uiWritingGoals;

  /// Application display copy. Source: lib/modules/settingview.dart:244
  ///
  /// In zh, this message translates to:
  /// **'每日進度與每章、全文預設目標'**
  String get uiDailyProgressAndDefaultChapterAndProjectGoals;

  /// Application display copy. Source: lib/modules/settingview.dart:250
  ///
  /// In zh, this message translates to:
  /// **'儲存與備份'**
  String get uiSavingAndBackups;

  /// Application display copy. Source: lib/modules/settingview.dart:251
  ///
  /// In zh, this message translates to:
  /// **'自動儲存、備份排程與容量'**
  String get uiAutosaveBackupScheduleAndStorageLimits;

  /// Application display copy. Source: lib/modules/settingview.dart:266
  ///
  /// In zh, this message translates to:
  /// **'同步與連線'**
  String get uiSyncAndConnections;

  /// Application display copy. Source: lib/modules/settingview.dart:267
  ///
  /// In zh, this message translates to:
  /// **'裝置配對、持久驗證與背景執行'**
  String get uiDevicePairingPersistentAuthenticationAndBackgroundExecution;

  /// Application display copy. Source: lib/modules/settingview.dart:297
  ///
  /// In zh, this message translates to:
  /// **'外部整合'**
  String get uiExternalIntegrations;

  /// Application display copy. Source: lib/modules/settingview.dart:298
  ///
  /// In zh, this message translates to:
  /// **'MCP 專案唯讀存取與授權'**
  String get uiReadOnlyMCPProjectAccessAndAuthorization;

  /// Application display copy. Source: lib/modules/settingview.dart:313
  ///
  /// In zh, this message translates to:
  /// **'啟用 Poppin IntelliSense'**
  String get uiEnablePoppinIntelliSense;

  /// Application display copy. Source: lib/modules/settingview.dart:315
  ///
  /// In zh, this message translates to:
  /// **'輸入標記類型、/ 或 \\ 時顯示游標旁候選清單'**
  String get uiShowSuggestionsNearTheCursorWhenEnteringA;

  /// Application display copy. Source: lib/modules/settingview.dart:326
  ///
  /// In zh, this message translates to:
  /// **'啟用覆寫模式'**
  String get uiEnableOverwriteMode;

  /// Application display copy. Source: lib/modules/settingview.dart:328
  ///
  /// In zh, this message translates to:
  /// **'允許使用 Ins 或狀態列切換覆寫模式；關閉時使用插入模式'**
  String get uiUseInsOrTheStatusBarToToggle;

  /// Application display copy. Source: lib/modules/settingview.dart:340
  ///
  /// In zh, this message translates to:
  /// **'空格與縮排'**
  String get uiSpacesAndIndentation;

  /// Application display copy. Source: lib/modules/settingview.dart:343
  ///
  /// In zh, this message translates to:
  /// **'Tab 空格數量'**
  String get uiSpacesPerTab;

  /// Application display copy. Source: lib/modules/settingview.dart:344
  ///
  /// In zh, this message translates to:
  /// **'按 Tab 或自動留空時插入的空格數'**
  String get uiNumberOfSpacesInsertedByTabOrAutomatic;

  /// Application display copy. Source: lib/modules/settingview.dart:362
  ///
  /// In zh, this message translates to:
  /// **'使用全形空格'**
  String get uiUseFullWidthSpaces;

  /// Application display copy. Source: lib/modules/settingview.dart:364
  ///
  /// In zh, this message translates to:
  /// **'關閉時使用半形空格'**
  String get uiUseHalfWidthSpacesWhenDisabled;

  /// Application display copy. Source: lib/modules/settingview.dart:373
  ///
  /// In zh, this message translates to:
  /// **'行首自動留空'**
  String get uiAutomaticallyIndentNewLines;

  /// Application display copy. Source: lib/modules/settingview.dart:375
  ///
  /// In zh, this message translates to:
  /// **'Enter 換行後插入設定的空格；Shift+Enter 僅換行'**
  String get uiInsertConfiguredSpacesAfterEnterShiftEnterInserts;

  /// Application display copy. Source: lib/modules/settingview.dart:388
  ///
  /// In zh, this message translates to:
  /// **'修改別名時更新正文 Mention'**
  String get uiUpdateManuscriptMentionsWhenAliasesChange;

  /// Application display copy. Source: lib/modules/settingview.dart:390
  ///
  /// In zh, this message translates to:
  /// **'更新同角色且顯示文字等於原別名的標記'**
  String get uiUpdateMarkersForTheSameCharacterWhoseDisplay;

  /// Application display copy. Source: lib/modules/settingview.dart:407, lib/ui_library/neon_icon_button.dart:50
  ///
  /// In zh, this message translates to:
  /// **'未啟用'**
  String get uiDisabled2;

  /// Application display copy. Source: lib/modules/settingview.dart:408
  ///
  /// In zh, this message translates to:
  /// **'正在建立本機授權…'**
  String get uiCreatingLocalAuthorization;

  /// Application display copy. Source: lib/modules/settingview.dart:409
  ///
  /// In zh, this message translates to:
  /// **'已授權：{p1}（僅本機、唯讀）'**
  String uiAuthorizedLocalReadOnly(String p1);

  /// Application display copy. Source: lib/modules/settingview.dart:410
  ///
  /// In zh, this message translates to:
  /// **'授權已到期'**
  String get uiAuthorizationExpired;

  /// Application display copy. Source: lib/modules/settingview.dart:411
  ///
  /// In zh, this message translates to:
  /// **'啟用失敗'**
  String get uiCouldNotEnable;

  /// Application display copy. Source: lib/modules/settingview.dart:415, lib/modules/settingview.dart:421
  ///
  /// In zh, this message translates to:
  /// **'MCP 唯讀整合'**
  String get uiReadOnlyMCPIntegration;

  /// Application display copy. Source: lib/modules/settingview.dart:423
  ///
  /// In zh, this message translates to:
  /// **'只公開目前授權專案的摘要、章節、角色、世界觀、大綱與詞語；不提供修改工具。{p1}'**
  String uiExposeOnlyTheAuthorizedProjectSSummaryChapters(String p1);

  /// Application display copy. Source: lib/modules/settingview.dart:433
  ///
  /// In zh, this message translates to:
  /// **'MCP sidecar 僅支援 Windows、macOS 與 Linux。'**
  String get uiTheMCPSidecarSupportsWindowsMacOSAndLinux;

  /// Application display copy. Source: lib/modules/settingview.dart:444
  ///
  /// In zh, this message translates to:
  /// **'連線設定檔：{p1}'**
  String uiConnectionConfiguration(String p1);

  /// Application display copy. Source: lib/modules/settingview.dart:453
  ///
  /// In zh, this message translates to:
  /// **'MCP Host 已取得一次性授權；如要改連其他 Host，請停止後重新啟用。'**
  String get uiAnMCPHostHasClaimedTheOneTime;

  /// Application display copy. Source: lib/modules/settingview.dart:466
  ///
  /// In zh, this message translates to:
  /// **'複製 MCP Host 設定'**
  String get uiCopyMCPHostConfiguration;

  /// Application display copy. Source: lib/modules/settingview.dart:472
  ///
  /// In zh, this message translates to:
  /// **'停止目前授權'**
  String get uiStopCurrentAuthorization;

  /// Application display copy. Source: lib/modules/settingview.dart:489
  ///
  /// In zh, this message translates to:
  /// **'允許單端確認配對碼'**
  String get uiAllowOneSidedPairingConfirmation;

  /// Application display copy. Source: lib/modules/settingview.dart:491
  ///
  /// In zh, this message translates to:
  /// **'僅在兩台裝置都開啟時生效；任一台確認後，另一台會驗證簽章並自動回簽'**
  String get uiRequiresBothDevicesToEnableThisOptionAfter;

  /// Application display copy. Source: lib/modules/settingview.dart:502
  ///
  /// In zh, this message translates to:
  /// **'持久驗證（14 天）'**
  String get uiPersistentAuthenticationDays;

  /// Application display copy. Source: lib/modules/settingview.dart:504
  ///
  /// In zh, this message translates to:
  /// **'僅在兩台裝置都開啟時生效；期限內可自動驗證，每次成功連線會重新續簽 14 天'**
  String get uiRequiresBothDevicesToEnableThisOptionAuthenticate;

  /// Application display copy. Source: lib/modules/settingview.dart:531
  ///
  /// In zh, this message translates to:
  /// **'允許背景常駐'**
  String get uiAllowBackgroundExecution;

  /// Application display copy. Source: lib/modules/settingview.dart:533
  ///
  /// In zh, this message translates to:
  /// **'已允許不受電池最佳化限制'**
  String get uiUnrestrictedBatteryUsageIsAllowed;

  /// Application display copy. Source: lib/modules/settingview.dart:533
  ///
  /// In zh, this message translates to:
  /// **'讓已啟用的背景工作較不易被系統暫停'**
  String get uiReduceTheChanceOfTheSystemSuspendingActive;

  /// Application display copy. Source: lib/modules/settingview.dart:546
  ///
  /// In zh, this message translates to:
  /// **'已允許'**
  String get uiAllowed;

  /// Application display copy. Source: lib/modules/settingview.dart:546
  ///
  /// In zh, this message translates to:
  /// **'允許'**
  String get uiAllow;

  /// Application display copy. Source: lib/modules/settingview.dart:555
  ///
  /// In zh, this message translates to:
  /// **'字體大小調整'**
  String get uiFontSize;

  /// Application display copy. Source: lib/modules/settingview.dart:594, lib/features/oobe/oobe_screen.dart:434, lib/features/oobe/oobe_screen.dart:618
  ///
  /// In zh, this message translates to:
  /// **'僅圖示'**
  String get uiIconsOnly;

  /// Application display copy. Source: lib/modules/settingview.dart:595
  ///
  /// In zh, this message translates to:
  /// **'圖示與名稱'**
  String get uiIconsAndLabels;

  /// Application display copy. Source: lib/modules/settingview.dart:596
  ///
  /// In zh, this message translates to:
  /// **'點擊展開'**
  String get uiExpandOnClick;

  /// Application display copy. Source: lib/modules/settingview.dart:597, lib/features/oobe/oobe_screen.dart:434, lib/features/oobe/oobe_screen.dart:618
  ///
  /// In zh, this message translates to:
  /// **'懸停展開'**
  String get uiExpandOnHover;

  /// Application display copy. Source: lib/modules/settingview.dart:603
  ///
  /// In zh, this message translates to:
  /// **'導覽模式'**
  String get uiNavigationStyle;

  /// Application display copy. Source: lib/modules/settingview.dart:630
  ///
  /// In zh, this message translates to:
  /// **'首頁固定頂端；設定、關於固定底端。窄視窗使用按鈕開啟導覽。'**
  String get uiHomeStaysAtTheTopSettingsAndAbout;

  /// Application display copy. Source: lib/modules/settingview.dart:682, lib/modules/settingview.dart:744, lib/features/oobe/oobe_screen.dart:881
  ///
  /// In zh, this message translates to:
  /// **'淺色'**
  String get uiLight;

  /// Application display copy. Source: lib/modules/settingview.dart:683, lib/modules/settingview.dart:744, lib/features/oobe/oobe_screen.dart:882
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get uiDark;

  /// Application display copy. Source: lib/modules/settingview.dart:689
  ///
  /// In zh, this message translates to:
  /// **'主題模式'**
  String get uiThemeMode;

  /// Application display copy. Source: lib/modules/settingview.dart:698
  ///
  /// In zh, this message translates to:
  /// **'跟隨系統的淺色或深色外觀。'**
  String get uiFollowTheSystemSLightOrDarkAppearance;

  /// Application display copy. Source: lib/modules/settingview.dart:699
  ///
  /// In zh, this message translates to:
  /// **'使用{p1}外觀。'**
  String uiUseAppearance(String p1);

  /// Application display copy. Source: lib/modules/settingview.dart:744
  ///
  /// In zh, this message translates to:
  /// **'目前使用：{p1}模式'**
  String uiCurrentlyUsingMode(String p1);

  /// Application display copy. Source: lib/modules/settingview.dart:771, lib/modules/settingview.dart:786
  ///
  /// In zh, this message translates to:
  /// **'字數統計模式'**
  String get uiWordCountMode;

  /// Application display copy. Source: lib/modules/settingview.dart:774
  ///
  /// In zh, this message translates to:
  /// **'純字元數 (不建議)'**
  String get uiCharacterCountNotRecommended;

  /// Application display copy. Source: lib/modules/settingview.dart:775
  ///
  /// In zh, this message translates to:
  /// **'全形字元 + 半形單字'**
  String get uiFullWidthCharactersHalfWidthWords;

  /// Application display copy. Source: lib/modules/settingview.dart:790
  ///
  /// In zh, this message translates to:
  /// **'字元數 (不建議)'**
  String get uiCharactersNotRecommended;

  /// Application display copy. Source: lib/modules/settingview.dart:794
  ///
  /// In zh, this message translates to:
  /// **'混合模式'**
  String get uiMixedMode;

  /// Application display copy. Source: lib/modules/settingview.dart:819
  ///
  /// In zh, this message translates to:
  /// **'依排程儲存檔案（需要檔案存在）'**
  String get uiSaveOnAScheduleRequiresAnExistingFile;

  /// Application display copy. Source: lib/modules/settingview.dart:865
  ///
  /// In zh, this message translates to:
  /// **'依排程建立專案備份，不覆蓋原檔案'**
  String get uiCreateScheduledProjectBackupsWithoutOverwritingTheOriginal;

  /// Application display copy. Source: lib/modules/settingview.dart:901
  ///
  /// In zh, this message translates to:
  /// **'備份最高上限'**
  String get uiMaximumBackupStorage;

  /// Application display copy. Source: lib/modules/settingview.dart:956
  ///
  /// In zh, this message translates to:
  /// **'開啟'**
  String get uiOpen;

  /// Application display copy. Source: lib/modules/settingview.dart:962
  ///
  /// In zh, this message translates to:
  /// **'重新選擇'**
  String get uiChooseAgain;

  /// Application display copy. Source: lib/modules/settingview.dart:968, lib/modules/settingview.dart:982
  ///
  /// In zh, this message translates to:
  /// **'選擇'**
  String get uiChoose;

  /// Application display copy. Source: lib/modules/settingview.dart:972
  ///
  /// In zh, this message translates to:
  /// **'AutoBackup 目錄選項'**
  String get uiAutoBackupFolderOptions;

  /// Application display copy. Source: lib/modules/settingview.dart:983
  ///
  /// In zh, this message translates to:
  /// **'重設'**
  String get uiReset;

  /// Application display copy. Source: lib/modules/settingview.dart:994
  ///
  /// In zh, this message translates to:
  /// **'{p1} / {p2} MB ・ {p3} 份'**
  String uiMBBackups(String p1, String p2, String p3);

  /// Application display copy. Source: lib/modules/settingview.dart:1002
  ///
  /// In zh, this message translates to:
  /// **'清理全部備份'**
  String get uiDeleteAllBackups;

  /// Application display copy. Source: lib/modules/settingview.dart:1029
  ///
  /// In zh, this message translates to:
  /// **'已清理 {p1} 份備份，釋放 {p2}。'**
  String uiDeletedBackupsFreeing(String p1, String p2);

  /// Application display copy. Source: lib/modules/settingview.dart:1045
  ///
  /// In zh, this message translates to:
  /// **'已開啟 AutoBackup 目錄：{p1}'**
  String uiOpenedAutoBackupFolder(String p1);

  /// Application display copy. Source: lib/modules/settingview.dart:1063
  ///
  /// In zh, this message translates to:
  /// **'AutoBackup 目錄已設定：{p1}'**
  String uiAutoBackupFolderSet(String p1);

  /// Application display copy. Source: lib/modules/settingview.dart:1081
  ///
  /// In zh, this message translates to:
  /// **'AutoBackup 目錄已重設：{p1}'**
  String uiAutoBackupFolderReset(String p1);

  /// Application display copy. Source: lib/modules/settingview.dart:1101
  ///
  /// In zh, this message translates to:
  /// **'即將推出'**
  String get uiComingSoon;

  /// Application display copy. Source: lib/modules/timelineview.dart:267, lib/features/navigation/app_module.dart:70
  ///
  /// In zh, this message translates to:
  /// **'時間軸'**
  String get uiTimeline;

  /// Application display copy. Source: lib/modules/timelineview.dart:271
  ///
  /// In zh, this message translates to:
  /// **'偵測到 {p1} 筆缺失引用；資料已保留，請重新連結或移除對應節點。'**
  String uiFoundMissingReferencesDataHasBeenPreservedRelink(String p1);

  /// Application display copy. Source: lib/modules/timelineview.dart:280
  ///
  /// In zh, this message translates to:
  /// **'搜尋時間軸'**
  String get uiSearchTimeline;

  /// Application display copy. Source: lib/modules/timelineview.dart:307
  ///
  /// In zh, this message translates to:
  /// **'全部狀態變更'**
  String get uiAllStateChanges;

  /// Application display copy. Source: lib/modules/timelineview.dart:308, lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:364
  ///
  /// In zh, this message translates to:
  /// **'角色'**
  String get uiCharacters3;

  /// Application display copy. Source: lib/modules/timelineview.dart:589
  ///
  /// In zh, this message translates to:
  /// **'主時間軸'**
  String get uiMainTimeline;

  /// Application display copy. Source: lib/modules/timelineview.dart:617
  ///
  /// In zh, this message translates to:
  /// **'新增大箱'**
  String get uiAddStoryline;

  /// Application display copy. Source: lib/modules/timelineview.dart:618
  ///
  /// In zh, this message translates to:
  /// **'新增中箱'**
  String get uiAddEvent;

  /// Application display copy. Source: lib/modules/timelineview.dart:619
  ///
  /// In zh, this message translates to:
  /// **'新增小箱'**
  String get uiAddScene;

  /// Application display copy. Source: lib/modules/timelineview.dart:620
  ///
  /// In zh, this message translates to:
  /// **'小箱是最末層節點'**
  String get uiScenesAreLeafNodes;

  /// Application display copy. Source: lib/modules/timelineview.dart:644
  ///
  /// In zh, this message translates to:
  /// **'只看目前章節'**
  String get uiCurrentChapterOnly;

  /// Application display copy. Source: lib/modules/timelineview.dart:661
  ///
  /// In zh, this message translates to:
  /// **'未連結章節'**
  String get uiNoChapterLinked;

  /// Application display copy. Source: lib/modules/timelineview.dart:675
  ///
  /// In zh, this message translates to:
  /// **'自動排序大綱\n依起始 Tick、時間軌順序排列大綱；大綱順序變更時同步調整時間軸。'**
  String get uiAutomaticallySortOutlineSortByStartTickAnd;

  /// Application display copy. Source: lib/modules/timelineview.dart:690
  ///
  /// In zh, this message translates to:
  /// **'顯示時間軸空白區段'**
  String get uiShowEmptyTimelineRanges;

  /// Application display copy. Source: lib/modules/timelineview.dart:691
  ///
  /// In zh, this message translates to:
  /// **'省略時間軸空白區段'**
  String get uiSkipEmptyTimelineRanges;

  /// Application display copy. Source: lib/modules/timelineview.dart:704
  ///
  /// In zh, this message translates to:
  /// **'返回目前時間軸'**
  String get uiReturnToCurrentTimeline;

  /// Application display copy. Source: lib/modules/timelineview.dart:739
  ///
  /// In zh, this message translates to:
  /// **'畫面 Tick 寬度'**
  String get uiVisibleTickWidth;

  /// Application display copy. Source: lib/modules/timelineview.dart:761
  ///
  /// In zh, this message translates to:
  /// **'目前 Tick'**
  String get uiCurrentTick2;

  /// Application display copy. Source: lib/modules/timelineview.dart:804
  ///
  /// In zh, this message translates to:
  /// **'未排定大箱'**
  String get uiUnscheduledStorylines;

  /// Application display copy. Source: lib/modules/timelineview.dart:808
  ///
  /// In zh, this message translates to:
  /// **'所有大綱大箱皆已同步'**
  String get uiAllOutlineStorylinesAreSynced;

  /// Application display copy. Source: lib/modules/timelineview.dart:815
  ///
  /// In zh, this message translates to:
  /// **'同步時會建立或補齊整個大箱、中箱與小箱階層，不會把單一場景放進目前中箱。'**
  String get uiSyncCreatesOrCompletesTheEntireStorylineEvent;

  /// Application display copy. Source: lib/modules/timelineview.dart:824
  ///
  /// In zh, this message translates to:
  /// **'未命名大箱'**
  String get uiUntitledStoryline2;

  /// Application display copy. Source: lib/modules/timelineview.dart:829
  ///
  /// In zh, this message translates to:
  /// **'時間軸大箱不存在；包含 {p1} 個中箱、{p2} 個小箱'**
  String uiTimelineStorylineMissingContainsEventsAndScenes(
    String p1,
    String p2,
  );

  /// Application display copy. Source: lib/modules/timelineview.dart:830
  ///
  /// In zh, this message translates to:
  /// **'待補齊 {p1} 個中箱、{p2} 個小箱'**
  String uiMissingEventsAndScenes(String p1, String p2);

  /// Application display copy. Source: lib/modules/timelineview.dart:833
  ///
  /// In zh, this message translates to:
  /// **'同步整個大箱'**
  String get uiSyncEntireStoryline;

  /// Application display copy. Source: lib/modules/timelineview.dart:852
  ///
  /// In zh, this message translates to:
  /// **'故事刻度設定'**
  String get uiStoryTimeScale;

  /// Application display copy. Source: lib/modules/timelineview.dart:859
  ///
  /// In zh, this message translates to:
  /// **'Tick 單位'**
  String get uiTickUnit;

  /// Application display copy. Source: lib/modules/timelineview.dart:878
  ///
  /// In zh, this message translates to:
  /// **'Tick 對應單位數'**
  String get uiUnitsPerTick;

  /// Application display copy. Source: lib/modules/timelineview.dart:890
  ///
  /// In zh, this message translates to:
  /// **'每小箱 Tick 數'**
  String get uiTicksPerScene;

  /// Application display copy. Source: lib/modules/timelineview.dart:896
  ///
  /// In zh, this message translates to:
  /// **'每中箱的小箱數'**
  String get uiScenesPerEvent;

  /// Application display copy. Source: lib/modules/timelineview.dart:902
  ///
  /// In zh, this message translates to:
  /// **'每大箱的中箱數'**
  String get uiEventsPerStoryline;

  /// Application display copy. Source: lib/modules/timelineview.dart:910
  ///
  /// In zh, this message translates to:
  /// **'1 Tick = {p1} {p2}；1 小箱 = {p3} Tick；1 中箱 = {p4} Tick；1 大箱 = {p5} Tick。'**
  String uiTickSceneTicksEventTicksStorylineTicks(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  );

  /// Application display copy. Source: lib/modules/timelineview.dart:951, lib/modules/timelineview.dart:2354
  ///
  /// In zh, this message translates to:
  /// **'節點名稱'**
  String get uiNodeName;

  /// Application display copy. Source: lib/modules/timelineview.dart:953
  ///
  /// In zh, this message translates to:
  /// **'未選場景時必填'**
  String get uiRequiredWhenNoSceneIsSelected;

  /// Application display copy. Source: lib/modules/timelineview.dart:961
  ///
  /// In zh, this message translates to:
  /// **'新增中箱時會同步建立對應的大綱事件。'**
  String get uiAddingAnEventAlsoCreatesItsCorrespondingOutline;

  /// Application display copy. Source: lib/modules/timelineview.dart:969
  ///
  /// In zh, this message translates to:
  /// **'大綱場景（可選）'**
  String get uiOutlineSceneOptional;

  /// Application display copy. Source: lib/modules/timelineview.dart:973
  ///
  /// In zh, this message translates to:
  /// **'建立新的大綱場景'**
  String get uiCreateNewOutlineScene;

  /// Application display copy. Source: lib/modules/timelineview.dart:979, lib/modules/timelineview.dart:2414, lib/presentation/widgets/project_object_selector.dart:247
  ///
  /// In zh, this message translates to:
  /// **'未命名場景'**
  String get uiUntitledScene2;

  /// Application display copy. Source: lib/modules/timelineview.dart:1025, lib/modules/timelineview.dart:1689
  ///
  /// In zh, this message translates to:
  /// **'新增軌道'**
  String get uiAddTrack;

  /// Application display copy. Source: lib/modules/timelineview.dart:1026
  ///
  /// In zh, this message translates to:
  /// **'軌道名稱'**
  String get uiTrackName;

  /// Application display copy. Source: lib/modules/timelineview.dart:1042
  ///
  /// In zh, this message translates to:
  /// **'重新命名軌道'**
  String get uiRenameTrack;

  /// Application display copy. Source: lib/modules/timelineview.dart:1059, lib/modules/timelineview.dart:1860
  ///
  /// In zh, this message translates to:
  /// **'刪除軌道'**
  String get uiDeleteTrack;

  /// Application display copy. Source: lib/modules/timelineview.dart:1060
  ///
  /// In zh, this message translates to:
  /// **'軌道上的節點會移到其他軌道，不會刪除大綱場景。'**
  String get uiNodesMoveToAnotherTrackOutlineScenesWill;

  /// Application display copy. Source: lib/modules/timelineview.dart:1109
  ///
  /// In zh, this message translates to:
  /// **'選擇要開啟的章節'**
  String get uiChooseAChapterToOpen;

  /// Application display copy. Source: lib/modules/timelineview.dart:1221
  ///
  /// In zh, this message translates to:
  /// **'刪除時間軸節點'**
  String get uiDeleteTimelineNode;

  /// Application display copy. Source: lib/modules/timelineview.dart:1222
  ///
  /// In zh, this message translates to:
  /// **'將刪除此節點與其子節點；大綱場景和章節內容不會被刪除。'**
  String get uiThisDeletesTheNodeAndItsChildrenOutline;

  /// Application display copy. Source: lib/modules/timelineview.dart:1256, lib/modules/timelineview.dart:2489
  ///
  /// In zh, this message translates to:
  /// **'連結章節並套用到所有子節點'**
  String get uiLinkChaptersAndApplyToAllChildren;

  /// Application display copy. Source: lib/modules/timelineview.dart:1256
  ///
  /// In zh, this message translates to:
  /// **'選擇關聯章節'**
  String get uiChooseLinkedChapters;

  /// Application display copy. Source: lib/modules/timelineview.dart:1273
  ///
  /// In zh, this message translates to:
  /// **'套用後，{p1} 個子場景會使用完全相同的章節選擇。'**
  String uiAllChildScenesWillUseTheSameChapter(String p1);

  /// Application display copy. Source: lib/modules/timelineview.dart:1280
  ///
  /// In zh, this message translates to:
  /// **'目前沒有章節'**
  String get uiNoChaptersYet;

  /// Application display copy. Source: lib/modules/timelineview.dart:1294
  ///
  /// In zh, this message translates to:
  /// **'{p1} · 目前 {p2}/{p3} 個子場景'**
  String uiCurrentlyChildScenes(String p1, String p2, String p3);

  /// Application display copy. Source: lib/modules/timelineview.dart:1556
  ///
  /// In zh, this message translates to:
  /// **'時間 Scrubber，目前 {p1} Tick'**
  String uiTimeScrubberCurrentlyTicks(String p1);

  /// Application display copy. Source: lib/modules/timelineview.dart:1571
  ///
  /// In zh, this message translates to:
  /// **'拖動目前時間：{p1} Tick'**
  String uiDragCurrentTimeTicks(String p1);

  /// Application display copy. Source: lib/modules/timelineview.dart:1683
  ///
  /// In zh, this message translates to:
  /// **'軌道'**
  String get uiTrack;

  /// Application display copy. Source: lib/modules/timelineview.dart:1816
  ///
  /// In zh, this message translates to:
  /// **'軌道選項'**
  String get uiTrackOptions;

  /// Application display copy. Source: lib/modules/timelineview.dart:1824, lib/ui_library/collections.dart:186, lib/ui_library/collections.dart:221
  ///
  /// In zh, this message translates to:
  /// **'重新命名'**
  String get commonRename;

  /// Application display copy. Source: lib/modules/timelineview.dart:1834
  ///
  /// In zh, this message translates to:
  /// **'展開軌道'**
  String get uiExpandTrack;

  /// Application display copy. Source: lib/modules/timelineview.dart:1834
  ///
  /// In zh, this message translates to:
  /// **'收合軌道'**
  String get uiCollapseTrack;

  /// Application display copy. Source: lib/modules/timelineview.dart:1843
  ///
  /// In zh, this message translates to:
  /// **'上移'**
  String get uiMoveUp;

  /// Application display copy. Source: lib/modules/timelineview.dart:1851
  ///
  /// In zh, this message translates to:
  /// **'下移'**
  String get uiMoveDown;

  /// Application display copy. Source: lib/modules/timelineview.dart:1983
  ///
  /// In zh, this message translates to:
  /// **'拖曳調整頭端 Tick'**
  String get uiDragToAdjustStartTick;

  /// Application display copy. Source: lib/modules/timelineview.dart:1983
  ///
  /// In zh, this message translates to:
  /// **'拖曳調整尾端 Tick'**
  String get uiDragToAdjustEndTick;

  /// Application display copy. Source: lib/modules/timelineview.dart:1985
  ///
  /// In zh, this message translates to:
  /// **'調整頭端 Tick'**
  String get uiAdjustStartTick;

  /// Application display copy. Source: lib/modules/timelineview.dart:1985
  ///
  /// In zh, this message translates to:
  /// **'調整尾端 Tick'**
  String get uiAdjustEndTick;

  /// Application display copy. Source: lib/modules/timelineview.dart:2126
  ///
  /// In zh, this message translates to:
  /// **'拖曳以調整時間'**
  String get uiDragToAdjustTime;

  /// Application display copy. Source: lib/modules/timelineview.dart:2172
  ///
  /// In zh, this message translates to:
  /// **'狀態變更：角色 {p1}、物品 {p2}、地點 {p3}'**
  String uiStateChangesCharactersItemsLocations(
    String p1,
    String p2,
    String p3,
  );

  /// Application display copy. Source: lib/modules/timelineview.dart:2286, lib/modules/timelineview.dart:2332
  ///
  /// In zh, this message translates to:
  /// **'節點屬性'**
  String get uiNodeProperties;

  /// Application display copy. Source: lib/modules/timelineview.dart:2289
  ///
  /// In zh, this message translates to:
  /// **'尚未選取節點'**
  String get uiNoNodeSelected;

  /// Application display copy. Source: lib/modules/timelineview.dart:2290
  ///
  /// In zh, this message translates to:
  /// **'點一下時間軸節點即可檢視與調整 Tick、軌道及章節關聯。'**
  String get uiSelectATimelineNodeToViewAndAdjust;

  /// Application display copy. Source: lib/modules/timelineview.dart:2336
  ///
  /// In zh, this message translates to:
  /// **'刪除節點'**
  String get uiDeleteNode;

  /// Application display copy. Source: lib/modules/timelineview.dart:2353
  ///
  /// In zh, this message translates to:
  /// **'自訂名稱'**
  String get uiCustomName;

  /// Application display copy. Source: lib/modules/timelineview.dart:2368
  ///
  /// In zh, this message translates to:
  /// **'所在軌道'**
  String get uiAssignedTrack;

  /// Application display copy. Source: lib/modules/timelineview.dart:2381
  ///
  /// In zh, this message translates to:
  /// **'頭端 Tick'**
  String get uiStartTick;

  /// Application display copy. Source: lib/modules/timelineview.dart:2389
  ///
  /// In zh, this message translates to:
  /// **'Tick 數'**
  String get uiTickCount;

  /// Application display copy. Source: lib/modules/timelineview.dart:2396
  ///
  /// In zh, this message translates to:
  /// **'尾端 Tick'**
  String get uiEndTick;

  /// Application display copy. Source: lib/modules/timelineview.dart:2423
  ///
  /// In zh, this message translates to:
  /// **'在大綱中開啟'**
  String get uiOpenInOutline;

  /// Application display copy. Source: lib/modules/timelineview.dart:2431
  ///
  /// In zh, this message translates to:
  /// **'以下章節彙整自 {p1} 個子場景。'**
  String uiChaptersBelowAreCollectedFromChildScenes(String p1);

  /// Application display copy. Source: lib/modules/timelineview.dart:2439
  ///
  /// In zh, this message translates to:
  /// **'場景狀態變更'**
  String get uiSceneStateChanges;

  /// Application display copy. Source: lib/modules/timelineview.dart:2444
  ///
  /// In zh, this message translates to:
  /// **'角色 {p1}・物品 {p2}・地點 {p3}'**
  String uiCharactersItemsLocations(String p1, String p2, String p3);

  /// Application display copy. Source: lib/modules/timelineview.dart:2452
  ///
  /// In zh, this message translates to:
  /// **'此場景沒有角色、物品或地點快照變更。'**
  String get uiNoCharacterItemOrLocationSnapshotChangesIn;

  /// Application display copy. Source: lib/modules/timelineview.dart:2484
  ///
  /// In zh, this message translates to:
  /// **'關聯章節'**
  String get uiLinkedChapters;

  /// Application display copy. Source: lib/modules/timelineview.dart:2489
  ///
  /// In zh, this message translates to:
  /// **'選擇章節'**
  String get uiChooseChapters;

  /// Application display copy. Source: lib/modules/timelineview.dart:2497
  ///
  /// In zh, this message translates to:
  /// **'子場景尚未連結章節'**
  String get uiChildScenesHaveNoLinkedChaptersYet;

  /// Application display copy. Source: lib/modules/timelineview.dart:2497
  ///
  /// In zh, this message translates to:
  /// **'此場景尚未連結章節'**
  String get uiThisSceneHasNoLinkedChaptersYet;

  /// Application display copy. Source: lib/modules/timelineview.dart:2498
  ///
  /// In zh, this message translates to:
  /// **'可選擇章節並一次套用到所有子節點。'**
  String get uiChooseChaptersAndApplyThemToAllChild;

  /// Application display copy. Source: lib/modules/timelineview.dart:2498
  ///
  /// In zh, this message translates to:
  /// **'不會自動切換到第一章。'**
  String get uiTheFirstChapterWillNotOpenAutomatically;

  /// Application display copy. Source: lib/modules/timelineview.dart:2511
  ///
  /// In zh, this message translates to:
  /// **'缺失章節'**
  String get uiMissingChapter;

  /// Application display copy. Source: lib/modules/timelineview.dart:2527
  ///
  /// In zh, this message translates to:
  /// **'此容器目前沒有可連結章節的子場景；請先新增小箱。'**
  String get uiThisContainerHasNoChildScenesThatCan;

  /// Application display copy. Source: lib/modules/timelineview.dart:2528
  ///
  /// In zh, this message translates to:
  /// **'此小箱尚未連結大綱場景，無法建立章節關聯。'**
  String get uiThisSceneHasNoOutlineSceneLinkedSo;

  /// Application display copy. Source: lib/modules/timelineview.dart:2555
  ///
  /// In zh, this message translates to:
  /// **'開啟{p1}'**
  String uiOpen2(String p1);

  /// Application display copy. Source: lib/modules/timelineview.dart:2655
  ///
  /// In zh, this message translates to:
  /// **'減少'**
  String get uiDecrease;

  /// Application display copy. Source: lib/modules/timelineview.dart:2700
  ///
  /// In zh, this message translates to:
  /// **'增加'**
  String get uiIncrease;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:722
  ///
  /// In zh, this message translates to:
  /// **'請先將 Scene 放入時間軸，再新增地點快照。'**
  String get uiAddTheSceneToTheTimelineBeforeAdding3;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:787
  ///
  /// In zh, this message translates to:
  /// **'存在 {p1} → {p2}'**
  String uiExistence(String p1, String p2);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:792
  ///
  /// In zh, this message translates to:
  /// **'可進入 {p1} → {p2}'**
  String uiAccess(String p1, String p2);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:797
  ///
  /// In zh, this message translates to:
  /// **'狀態「{p1}」 → 「{p2}」'**
  String uiState(String p1, String p2);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:803
  ///
  /// In zh, this message translates to:
  /// **'控制者 {p1} → {p2}'**
  String uiController(String p1, String p2);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:807
  ///
  /// In zh, this message translates to:
  /// **'無變更'**
  String get uiNoChanges;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:853
  ///
  /// In zh, this message translates to:
  /// **'套用至所有子地點'**
  String get uiApplyToAllChildLocations;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:856
  ///
  /// In zh, this message translates to:
  /// **'將建立 {p1} 筆獨立快照'**
  String uiCreatesIndependentSnapshots(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:857
  ///
  /// In zh, this message translates to:
  /// **'目前只會修改「{p1}」'**
  String uiOnlyWillBeModified(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:871, lib/presentation/widgets/snapshot_state_editor.dart:31, lib/presentation/widgets/snapshot_state_editor.dart:132
  ///
  /// In zh, this message translates to:
  /// **'當時名稱'**
  String get uiNameAtThisPoint;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:880, lib/presentation/widgets/snapshot_state_editor.dart:40, lib/presentation/widgets/snapshot_state_editor.dart:141
  ///
  /// In zh, this message translates to:
  /// **'當時描述'**
  String get uiDescriptionAtThisPoint;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:888
  ///
  /// In zh, this message translates to:
  /// **'當時自訂屬性'**
  String get uiCustomPropertiesAtThisPoint;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:923, lib/modules/worldsettingsview.dart:2458, lib/modules/worldsettingsview.dart:2515
  ///
  /// In zh, this message translates to:
  /// **'鍵值'**
  String get uiValue;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:938
  ///
  /// In zh, this message translates to:
  /// **'移除屬性'**
  String get uiRemoveProperty;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:958
  ///
  /// In zh, this message translates to:
  /// **'新增屬性'**
  String get uiAddProperty;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:975
  ///
  /// In zh, this message translates to:
  /// **'批次套用會保留各子地點原有的名稱、描述與自訂屬性。'**
  String get uiBatchApplicationPreservesEachChildLocationSExisting;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:985
  ///
  /// In zh, this message translates to:
  /// **'此時可進入'**
  String get uiAccessibleAtThisPoint;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1011, lib/presentation/widgets/snapshot_state_editor.dart:182
  ///
  /// In zh, this message translates to:
  /// **'控制者'**
  String get uiController2;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1051
  ///
  /// In zh, this message translates to:
  /// **'批次差異預覽'**
  String get uiBatchChangesPreview;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1085
  ///
  /// In zh, this message translates to:
  /// **'屬性有鍵值時必須填寫設定名稱。'**
  String get uiPropertiesWithAValueMustHaveAName;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1086
  ///
  /// In zh, this message translates to:
  /// **'自訂屬性的設定名稱不可重複。'**
  String get uiCustomPropertyNamesMustBeUnique;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1161
  ///
  /// In zh, this message translates to:
  /// **'已新增地點快照'**
  String get uiLocationSnapshotAdded;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1161
  ///
  /// In zh, this message translates to:
  /// **'已新增 {p1} 筆地點快照'**
  String uiAddedLocationSnapshots(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1180
  ///
  /// In zh, this message translates to:
  /// **'刪除整批地點快照？'**
  String get uiDeleteAllSnapshotsInThisBatch;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1181
  ///
  /// In zh, this message translates to:
  /// **'這筆快照與其他子地點屬於同一次批次操作，將一併刪除 {p1} 筆快照。'**
  String uiThisSnapshotBelongsToTheSameBatchAs(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1190
  ///
  /// In zh, this message translates to:
  /// **'整批刪除'**
  String get uiDeleteBatch;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1205
  ///
  /// In zh, this message translates to:
  /// **'已刪除 {p1} 筆地點快照'**
  String uiDeletedLocationSnapshots(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1205
  ///
  /// In zh, this message translates to:
  /// **'已刪除地點快照'**
  String get uiLocationSnapshotDeleted;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1390
  ///
  /// In zh, this message translates to:
  /// **'目前位於本地點的物品'**
  String get uiItemsCurrentlyAtThisLocation;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1406
  ///
  /// In zh, this message translates to:
  /// **'目前沒有物品'**
  String get uiNoItemsHere;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1407
  ///
  /// In zh, this message translates to:
  /// **'按「分配物品」即可在此頁設定所在地或聚合數量'**
  String get uiUseAllocateItemsToSetLocationsOrAggregate;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1478
  ///
  /// In zh, this message translates to:
  /// **'選擇要連結的地點物品'**
  String get uiChooseALocationItemToLink;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1504
  ///
  /// In zh, this message translates to:
  /// **'選擇要放在本地點的物品'**
  String get uiChooseAnItemToPlaceHere;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1621
  ///
  /// In zh, this message translates to:
  /// **'搬移舊版世界物品'**
  String get uiMoveLegacyWorldbuildingItems;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1622
  ///
  /// In zh, this message translates to:
  /// **'將 {p1} 筆物品子節點搬到新版物品管理；原 ID、內容與來源路徑會保留。'**
  String uiMoveItemNodesToTheNewItemManager(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1663
  ///
  /// In zh, this message translates to:
  /// **'已搬移 {p1} 筆物品到新版物品管理。'**
  String uiMovedItemsToTheNewItemManager(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1695, lib/features/navigation/app_module.dart:76, lib/features/revision_tracking/application/revision_field_registry.dart:52
  ///
  /// In zh, this message translates to:
  /// **'世界設定'**
  String get uiWorldbuilding2;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1703
  ///
  /// In zh, this message translates to:
  /// **'模板管理'**
  String get uiManageTemplates;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1731
  ///
  /// In zh, this message translates to:
  /// **'匯入模板檔案…'**
  String get uiImportTemplateFile;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1736
  ///
  /// In zh, this message translates to:
  /// **'匯出選取模板…'**
  String get uiExportSelectedTemplate;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1741
  ///
  /// In zh, this message translates to:
  /// **'匯出全部模板…'**
  String get uiExportAllTemplates;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1746
  ///
  /// In zh, this message translates to:
  /// **'儲存預設模板…'**
  String get uiSaveTemplatePreset;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1751
  ///
  /// In zh, this message translates to:
  /// **'更改預設名稱…'**
  String get uiRenamePreset;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1758
  ///
  /// In zh, this message translates to:
  /// **'刪除選取預設'**
  String get uiDeleteSelectedPreset;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1771, lib/modules/worldsettingsview.dart:1780
  ///
  /// In zh, this message translates to:
  /// **'世界結構'**
  String get uiWorldStructure;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1787
  ///
  /// In zh, this message translates to:
  /// **'尚無地點'**
  String get uiNoLocationsYet;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1788
  ///
  /// In zh, this message translates to:
  /// **'請新增第一個地點'**
  String get uiAddYourFirstLocation;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1802
  ///
  /// In zh, this message translates to:
  /// **'子地點'**
  String get uiChildLocation;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1802
  ///
  /// In zh, this message translates to:
  /// **'頂層地點'**
  String get uiTopLevelLocation;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1813
  ///
  /// In zh, this message translates to:
  /// **'節點詳情'**
  String get uiNodeDetails;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1915
  ///
  /// In zh, this message translates to:
  /// **'此 Tick 尚未存在'**
  String get uiDoesNotExistAtThisTick;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1916
  ///
  /// In zh, this message translates to:
  /// **'保留樹殼：仍有存在的子地點'**
  String get uiTreeShellRetainedExistingChildLocationsRemain;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1918
  ///
  /// In zh, this message translates to:
  /// **'父層在此 Tick 不存在；此節點仍獨立存在'**
  String get uiParentDoesNotExistAtThisTickThis;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1922
  ///
  /// In zh, this message translates to:
  /// **'當時名稱：{p1}'**
  String uiNameAtThisPoint2(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1936
  ///
  /// In zh, this message translates to:
  /// **'刪除地點'**
  String get uiDeleteLocation;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1995
  ///
  /// In zh, this message translates to:
  /// **'之前'**
  String get uiBefore;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:1999
  ///
  /// In zh, this message translates to:
  /// **'的子地點'**
  String get uiAsAChildLocation;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2003
  ///
  /// In zh, this message translates to:
  /// **'之後'**
  String get uiAfter;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2008
  ///
  /// In zh, this message translates to:
  /// **'「{p1}」已成為「{p2}」{p3}'**
  String uiIsNowPlaced(String p1, String p2, String p3);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2009
  ///
  /// In zh, this message translates to:
  /// **'「{p1}」已移動到「{p2}」{p3}'**
  String uiMoved(String p1, String p2, String p3);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2032
  ///
  /// In zh, this message translates to:
  /// **'請先選取地點'**
  String get uiSelectALocationFirst;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2033
  ///
  /// In zh, this message translates to:
  /// **'選取地點後即可預覽時間軸與管理快照'**
  String get uiSelectALocationToPreviewItsTimelineAnd;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2146
  ///
  /// In zh, this message translates to:
  /// **'描述：{p1}'**
  String uiDescription2(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2148
  ///
  /// In zh, this message translates to:
  /// **'屬性：{p1}'**
  String uiProperties(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2150, lib/presentation/widgets/snapshot_state_editor.dart:172
  ///
  /// In zh, this message translates to:
  /// **'可進入'**
  String get uiAccessible;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2150
  ///
  /// In zh, this message translates to:
  /// **'不可進入'**
  String get uiInaccessible;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2153
  ///
  /// In zh, this message translates to:
  /// **'控制者：{p1}'**
  String uiController3(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2180
  ///
  /// In zh, this message translates to:
  /// **'移除地點快照'**
  String get uiRemoveLocationSnapshot;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2201
  ///
  /// In zh, this message translates to:
  /// **'請選擇一個地點'**
  String get uiChooseALocation;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2202
  ///
  /// In zh, this message translates to:
  /// **'選取地點後即可編輯詳細資料'**
  String get uiSelectALocationToEditItsDetails;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2211
  ///
  /// In zh, this message translates to:
  /// **'找不到該地點'**
  String get uiLocationNotFound;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2296
  ///
  /// In zh, this message translates to:
  /// **'應用模板: '**
  String get uiApplyTemplate;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2308
  ///
  /// In zh, this message translates to:
  /// **'選擇模板'**
  String get uiChooseTemplate;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2311, lib/modules/worldsettingsview.dart:2842, lib/modules/worldsettingsview.dart:2854
  ///
  /// In zh, this message translates to:
  /// **'空白'**
  String get uiBlank;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2325, lib/modules/worldsettingsview.dart:3084, lib/modules/worldsettingsview.dart:3094
  ///
  /// In zh, this message translates to:
  /// **'確定'**
  String get commonConfirm;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2411
  ///
  /// In zh, this message translates to:
  /// **'這是舊版物品子節點。新版物品不再存放於世界設定樹，請搬移後在本頁地點區直接管理分配。'**
  String get uiThisIsALegacyItemNodeItemsAre;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2418
  ///
  /// In zh, this message translates to:
  /// **'搬移全部物品'**
  String get uiMoveAllItems;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2424
  ///
  /// In zh, this message translates to:
  /// **'節點類別'**
  String get uiNodeType;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2454
  ///
  /// In zh, this message translates to:
  /// **'自訂值表:'**
  String get uiCustomProperties;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2462
  ///
  /// In zh, this message translates to:
  /// **'尚無自訂值'**
  String get uiNoCustomProperties;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2463
  ///
  /// In zh, this message translates to:
  /// **'在下方輸入設定與鍵值後新增'**
  String get uiEnterAPropertyNameAndValueBelowTo;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2524
  ///
  /// In zh, this message translates to:
  /// **'備註:'**
  String get uiNotes4;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2617
  ///
  /// In zh, this message translates to:
  /// **'儲存預設模板'**
  String get uiSaveTemplatePreset2;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2618
  ///
  /// In zh, this message translates to:
  /// **'同名模板已存在，是否要覆蓋？'**
  String get uiATemplateWithThisNameExistsOverwriteIt;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2634
  ///
  /// In zh, this message translates to:
  /// **'更改預設名稱'**
  String get uiRenamePreset2;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2635
  ///
  /// In zh, this message translates to:
  /// **'新模板名稱'**
  String get uiNewTemplateName;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2686
  ///
  /// In zh, this message translates to:
  /// **'匯入失敗：檔案中沒有找到任何 <Type> 節點。'**
  String get uiImportFailedNoTypeNodesFoundInThe;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2708
  ///
  /// In zh, this message translates to:
  /// **'讀取檔案失敗：{p1}'**
  String uiCouldNotReadFile(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2728, lib/presentation/widgets/project_export/export_dialog.dart:345
  ///
  /// In zh, this message translates to:
  /// **'匯出檔案'**
  String get uiExportFile;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2741
  ///
  /// In zh, this message translates to:
  /// **'檔案已匯出至：{p1}'**
  String uiFileExportedTo(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2949
  ///
  /// In zh, this message translates to:
  /// **'永久刪除「{p1}」？'**
  String uiPermanentlyDelete(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2954
  ///
  /// In zh, this message translates to:
  /// **'若只是讓地點在故事中消失，請新增 Scene 快照並關閉「此時已存在」。'**
  String get uiToMakeALocationDisappearOnlyWithinThe;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2956
  ///
  /// In zh, this message translates to:
  /// **'將永久刪除 {p1} 個地點節點'**
  String uiPermanentlyDeleteLocationNodes(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2957
  ///
  /// In zh, this message translates to:
  /// **'移除 {p1} 筆地點快照'**
  String uiRemoveLocationSnapshots(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2958
  ///
  /// In zh, this message translates to:
  /// **'移除 {p1} 筆物品關聯'**
  String uiRemoveItemLinks(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2959
  ///
  /// In zh, this message translates to:
  /// **'清除 {p1} 筆物品地點記錄'**
  String uiClearItemLocationRecords(String p1);

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:2970
  ///
  /// In zh, this message translates to:
  /// **'永久刪除'**
  String get uiDeletePermanently;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:3082, lib/ui_library/neon_icon_button.dart:55
  ///
  /// In zh, this message translates to:
  /// **'錯誤'**
  String get uiError;

  /// Application display copy. Source: lib/modules/worldsettingsview.dart:3092
  ///
  /// In zh, this message translates to:
  /// **'成功'**
  String get uiSuccess;

  /// Application display copy. Source: lib/presentation/widgets/module_switcher.dart:96
  ///
  /// In zh, this message translates to:
  /// **'切換模組'**
  String get uiSwitchModule;

  /// Application display copy. Source: lib/presentation/widgets/module_switcher.dart:108
  ///
  /// In zh, this message translates to:
  /// **'搜尋模組'**
  String get uiSearchModules;

  /// Application display copy. Source: lib/presentation/widgets/module_switcher.dart:125
  ///
  /// In zh, this message translates to:
  /// **'找不到符合的模組'**
  String get uiNoMatchingModules;

  /// Application display copy. Source: lib/presentation/widgets/module_switcher.dart:137
  ///
  /// In zh, this message translates to:
  /// **'目前模組'**
  String get uiCurrentModule;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:129
  ///
  /// In zh, this message translates to:
  /// **'同步衝突：選擇各欄位使用版本'**
  String get uiSyncConflictsChooseAVersionForEachField;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:138
  ///
  /// In zh, this message translates to:
  /// **'所有 {p1} 個衝突欄位皆已決定'**
  String uiAllConflictingFieldsResolved(String p1);

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:139
  ///
  /// In zh, this message translates to:
  /// **'尚有 {p1} 個衝突欄位未決定'**
  String uiUnresolvedFields(String p1);

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:148
  ///
  /// In zh, this message translates to:
  /// **'全部欄位預設本機'**
  String get uiDefaultAllFieldsToLocal;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:152
  ///
  /// In zh, this message translates to:
  /// **'全部欄位預設對方'**
  String get uiDefaultAllFieldsToRemote;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:169
  ///
  /// In zh, this message translates to:
  /// **'取消並保留兩個版本'**
  String get uiCancelAndKeepBothVersions;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:174
  ///
  /// In zh, this message translates to:
  /// **'套用 {p1} 個欄位選擇並完成同步'**
  String uiApplyFieldChoicesAndFinishSync(String p1);

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:190
  ///
  /// In zh, this message translates to:
  /// **'{p1} 個衝突欄位 · {p2}'**
  String uiConflictingFields(String p1, String p2);

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:205
  ///
  /// In zh, this message translates to:
  /// **'預設使用：'**
  String get uiDefaultVersion;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:208, lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:290
  ///
  /// In zh, this message translates to:
  /// **'本機版本'**
  String get uiLocalVersion;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:216, lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:297
  ///
  /// In zh, this message translates to:
  /// **'對方版本'**
  String get uiRemoteVersion;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:243
  ///
  /// In zh, this message translates to:
  /// **'同上（本機版本）'**
  String get uiInheritLocalVersion;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:244
  ///
  /// In zh, this message translates to:
  /// **'同上（對方版本）'**
  String get uiInheritRemoteVersion;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:245
  ///
  /// In zh, this message translates to:
  /// **'同上（尚未設定）'**
  String get uiInheritNotSet;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:258
  ///
  /// In zh, this message translates to:
  /// **'衝突欄位：{p1}'**
  String uiConflictingField(String p1);

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:260
  ///
  /// In zh, this message translates to:
  /// **'尚未決定'**
  String get uiUnresolved;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:260
  ///
  /// In zh, this message translates to:
  /// **'已決定'**
  String get uiResolved;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:269
  ///
  /// In zh, this message translates to:
  /// **'共同祖先'**
  String get uiCommonAncestor;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:348
  ///
  /// In zh, this message translates to:
  /// **'（不存在／已刪除）'**
  String get uiMissingDeleted;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:363
  ///
  /// In zh, this message translates to:
  /// **'作品'**
  String get uiWork;

  /// Application display copy. Source: lib/presentation/widgets/p2p_conflict_resolution_dialog.dart:365
  ///
  /// In zh, this message translates to:
  /// **'專案區段'**
  String get uiProjectSections;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:69
  ///
  /// In zh, this message translates to:
  /// **'準備內容與封裝…'**
  String get uiPreparingContentAndPackage;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:99
  ///
  /// In zh, this message translates to:
  /// **'無法準備匯出：{p1}'**
  String uiCouldNotPrepareExport(String p1);

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:110
  ///
  /// In zh, this message translates to:
  /// **'選擇位置並儲存…'**
  String get uiChooseALocationAndSave;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:119
  ///
  /// In zh, this message translates to:
  /// **'已取消儲存，可重新選擇位置。'**
  String get uiSaveCancelledYouCanChooseAnotherLocation;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:165
  ///
  /// In zh, this message translates to:
  /// **'來源：{p1}（開啟匯出時的內容快照）'**
  String uiSourceSnapshotTakenWhenExportOpened(String p1);

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:165
  ///
  /// In zh, this message translates to:
  /// **'目前作品'**
  String get uiCurrentWork;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:182
  ///
  /// In zh, this message translates to:
  /// **'用途'**
  String get uiPurpose;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:186
  ///
  /// In zh, this message translates to:
  /// **'正文交稿'**
  String get uiManuscriptDelivery;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:190
  ///
  /// In zh, this message translates to:
  /// **'設定資料閱讀稿'**
  String get uiReferenceMaterial;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:194
  ///
  /// In zh, this message translates to:
  /// **'局部專案交換'**
  String get uiPartialProjectExchange;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:212
  ///
  /// In zh, this message translates to:
  /// **'內容格式'**
  String get uiContentFormat;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:229
  ///
  /// In zh, this message translates to:
  /// **'檔案組織'**
  String get uiFileOrganization;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:233
  ///
  /// In zh, this message translates to:
  /// **'合併為單一文件'**
  String get uiCombineIntoOneDocument;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:237
  ///
  /// In zh, this message translates to:
  /// **'分散文件（ZIP）'**
  String get uiSeparateDocumentsZIP;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:246
  ///
  /// In zh, this message translates to:
  /// **'包含作品資訊'**
  String get uiIncludeWorkInformation;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:251
  ///
  /// In zh, this message translates to:
  /// **'包含資料夾／文稿標題'**
  String get uiIncludeFolderManuscriptTitles;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:263
  ///
  /// In zh, this message translates to:
  /// **'僅目前文稿'**
  String get uiCurrentManuscriptOnly;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:275
  ///
  /// In zh, this message translates to:
  /// **'預覽：{p1} 份文件 · {p2} bytes · .{p3}'**
  String uiPreviewDocumentsBytes(String p1, String p2, String p3);

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:340
  ///
  /// In zh, this message translates to:
  /// **'產生預覽'**
  String get uiGeneratePreview;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:340
  ///
  /// In zh, this message translates to:
  /// **'返回選項'**
  String get uiBackToOptions;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_dialog.dart:394
  ///
  /// In zh, this message translates to:
  /// **'此模組以完整內容匯出。'**
  String get uiThisModuleIsExportedInFull;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_file_tree.dart:42
  ///
  /// In zh, this message translates to:
  /// **'ZIP 檔案樹'**
  String get uiZIPFileTree;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_file_tree.dart:50
  ///
  /// In zh, this message translates to:
  /// **'匯出說明'**
  String get uiExportNotes;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_file_tree.dart:56
  ///
  /// In zh, this message translates to:
  /// **'檔案與階層索引'**
  String get uiFileAndHierarchyIndex;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_selection_tree.dart:57
  ///
  /// In zh, this message translates to:
  /// **'搜尋名稱（保留原選取）'**
  String get uiSearchNamesKeepSelection;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_selection_tree.dart:68
  ///
  /// In zh, this message translates to:
  /// **'全選清單'**
  String get uiSelectEntireList;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_selection_tree.dart:72
  ///
  /// In zh, this message translates to:
  /// **'清除清單'**
  String get uiClearListSelection;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_selection_tree.dart:76
  ///
  /// In zh, this message translates to:
  /// **'全部展開'**
  String get uiExpandAll;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_selection_tree.dart:80
  ///
  /// In zh, this message translates to:
  /// **'全部收合'**
  String get uiCollapseAll;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_selection_tree.dart:84
  ///
  /// In zh, this message translates to:
  /// **'已選 {p1}／{p2} 項'**
  String uiSelectedOf(String p1, String p2);

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_selection_tree.dart:88
  ///
  /// In zh, this message translates to:
  /// **'沒有符合的項目'**
  String get uiNoMatchingEntries;

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_selection_tree.dart:111
  ///
  /// In zh, this message translates to:
  /// **'收合 {p1}'**
  String uiCollapse3(String p1);

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_selection_tree.dart:112
  ///
  /// In zh, this message translates to:
  /// **'展開 {p1}'**
  String uiExpand2(String p1);

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_selection_tree.dart:141
  ///
  /// In zh, this message translates to:
  /// **'{p1}，{p2}，已選 {p3}／{p4}'**
  String uiSelectedOf2(String p1, String p2, String p3, String p4);

  /// Application display copy. Source: lib/presentation/widgets/project_export/export_selection_tree.dart:180
  ///
  /// In zh, this message translates to:
  /// **'僅此項：{p1}'**
  String uiOnlyThisItem(String p1);

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:123
  ///
  /// In zh, this message translates to:
  /// **'搜尋名稱、類型或所屬資訊'**
  String get uiSearchNameTypeOrAffiliation;

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:137
  ///
  /// In zh, this message translates to:
  /// **'顯示封存物品'**
  String get uiShowArchivedItems;

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:146
  ///
  /// In zh, this message translates to:
  /// **'沒有符合條件的物件。'**
  String get uiNoMatchingObjects;

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:183
  ///
  /// In zh, this message translates to:
  /// **'未命名地點'**
  String get uiUntitledLocation;

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:200
  ///
  /// In zh, this message translates to:
  /// **'未命名人物'**
  String get uiUnnamedCharacter;

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:203
  ///
  /// In zh, this message translates to:
  /// **'人物{p1}'**
  String uiCharacter2(String p1);

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:203
  ///
  /// In zh, this message translates to:
  /// **'・{p1}'**
  String uiLiteral3(String p1);

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:229
  ///
  /// In zh, this message translates to:
  /// **'未命名事件'**
  String get uiUntitledEvent2;

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:239
  ///
  /// In zh, this message translates to:
  /// **'事件・{p1}'**
  String uiEvent4(String p1);

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:256
  ///
  /// In zh, this message translates to:
  /// **'場景・{p1}'**
  String uiScene2(String p1);

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:282
  ///
  /// In zh, this message translates to:
  /// **'未命名物品 Class'**
  String get uiUntitledItemClass;

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:287
  ///
  /// In zh, this message translates to:
  /// **'{p1} 筆分配'**
  String uiAllocations(String p1);

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:297
  ///
  /// In zh, this message translates to:
  /// **'物品 Class・{p1}・{p2}{p3}'**
  String uiItemClass2(String p1, String p2, String p3);

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:297, lib/presentation/widgets/project_object_selector.dart:336
  ///
  /// In zh, this message translates to:
  /// **'・已封存'**
  String get uiArchived;

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:336
  ///
  /// In zh, this message translates to:
  /// **'單件物品・{p1}・{p2}{p3}'**
  String uiIndividualItem(String p1, String p2, String p3);

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:336
  ///
  /// In zh, this message translates to:
  /// **'未指派'**
  String get uiUnassigned2;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:121
  ///
  /// In zh, this message translates to:
  /// **'新增儀表，查看寫作進度。'**
  String get uiAddAGaugeToViewYourWritingProgress;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:124
  ///
  /// In zh, this message translates to:
  /// **'新增儀表'**
  String get uiAddGauge;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:124
  ///
  /// In zh, this message translates to:
  /// **'已顯示全部儀表'**
  String get uiAllGaugesAreAlreadyShown;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:191
  ///
  /// In zh, this message translates to:
  /// **' 字'**
  String get uiWords;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:191
  ///
  /// In zh, this message translates to:
  /// **' 項'**
  String get uiEntries4;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:204
  ///
  /// In zh, this message translates to:
  /// **'統計暫時無法使用'**
  String get uiStatisticsTemporarilyUnavailable;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:206
  ///
  /// In zh, this message translates to:
  /// **'請選擇章節'**
  String get uiChooseAChapter;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:209
  ///
  /// In zh, this message translates to:
  /// **'尚無進度'**
  String get uiNoProgressYet;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:211
  ///
  /// In zh, this message translates to:
  /// **'字'**
  String get uiWords2;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:211
  ///
  /// In zh, this message translates to:
  /// **'項'**
  String get uiEntries5;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:231
  ///
  /// In zh, this message translates to:
  /// **'{p1}資訊'**
  String uiInformation(String p1);

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:236
  ///
  /// In zh, this message translates to:
  /// **'目前：{p1} {p2}'**
  String uiCurrent(String p1, String p2);

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:240, lib/features/revision_tracking/application/revision_field_registry.dart:73
  ///
  /// In zh, this message translates to:
  /// **'目標'**
  String get uiGoal2;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:240
  ///
  /// In zh, this message translates to:
  /// **'總計'**
  String get uiTotal;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:245
  ///
  /// In zh, this message translates to:
  /// **'{p1} · 本機所有作品合計'**
  String uiAllLocalWorks(String p1);

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:247
  ///
  /// In zh, this message translates to:
  /// **'全形字元＋半形單字；新增減去刪除'**
  String get uiFullWidthCharactersHalfWidthWordsAdditionsMinus;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:248
  ///
  /// In zh, this message translates to:
  /// **'今日淨減 {p1} 字'**
  String uiNetDecreaseTodayWords(String p1);

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:250
  ///
  /// In zh, this message translates to:
  /// **'統計處理中…'**
  String get uiProcessingStatistics;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:263
  ///
  /// In zh, this message translates to:
  /// **'統計無法保存，點此重試'**
  String get uiCouldNotSaveStatisticsClickToRetry;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:268, lib/presentation/widgets/writing_goal_dialog.dart:152
  ///
  /// In zh, this message translates to:
  /// **'僅限本檔案'**
  String get uiThisFileOnly;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:283
  ///
  /// In zh, this message translates to:
  /// **'設定字數目標'**
  String get uiSetWordCountGoal;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:296, lib/presentation/widgets/radial_gauge_dashboard.dart:428
  ///
  /// In zh, this message translates to:
  /// **'刪除儀表'**
  String get uiRemoveGauge;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:350
  ///
  /// In zh, this message translates to:
  /// **'尚未開始追蹤'**
  String get uiTrackingNotStarted;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:351
  ///
  /// In zh, this message translates to:
  /// **'計算中'**
  String get uiCalculating;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:352
  ///
  /// In zh, this message translates to:
  /// **'計算失敗'**
  String get uiCalculationFailed;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:354
  ///
  /// In zh, this message translates to:
  /// **'尚無校訂'**
  String get uiNoRevisionsYet;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:354
  ///
  /// In zh, this message translates to:
  /// **'比較完成'**
  String get uiComparisonComplete;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:359
  ///
  /// In zh, this message translates to:
  /// **'外環新增：{p1} 筆（{p2}%）\n內環校訂：{p3} 筆（{p4}%）\n{p5}'**
  String uiOuterRingAdditionsInnerRingRevisions(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  );

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:378
  ///
  /// In zh, this message translates to:
  /// **'追蹤校訂資訊'**
  String get uiRevisionTrackingInformation;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:381
  ///
  /// In zh, this message translates to:
  /// **'外環新增：{p1} 筆'**
  String uiOuterRingAdditions(String p1);

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:386
  ///
  /// In zh, this message translates to:
  /// **'內環校訂：{p1} 筆'**
  String uiInnerRingRevisions(String p1);

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:393
  ///
  /// In zh, this message translates to:
  /// **'比較基準：{p1}'**
  String uiComparisonBaseline(String p1);

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:396
  ///
  /// In zh, this message translates to:
  /// **'正文按變動行、設定按資料筆數統計。修改會在新增與校訂各計一筆。'**
  String get uiManuscriptChangesAreCountedByChangedLinesSettings;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:398
  ///
  /// In zh, this message translates to:
  /// **'兩環顯示各類計數占合計的比例。'**
  String get uiEachRingShowsItsCountAsAShare;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:416
  ///
  /// In zh, this message translates to:
  /// **'查看校訂明細'**
  String get uiViewRevisionDetails;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:435, lib/presentation/widgets/radial_gauge_dashboard.dart:461, lib/presentation/widgets/radial_gauge_dashboard.dart:25
  ///
  /// In zh, this message translates to:
  /// **'追蹤校訂'**
  String get uiTrackRevisions;

  /// Application display copy. Source: lib/presentation/widgets/remote_text_cursor_overlay.dart:231, lib/presentation/widgets/remote_text_cursor_overlay.dart:233
  ///
  /// In zh, this message translates to:
  /// **'{p1} 正在編輯此章節'**
  String uiIsEditingThisChapter(String p1);

  /// Application display copy. Source: lib/presentation/widgets/scene_range_view.dart:100
  ///
  /// In zh, this message translates to:
  /// **'場次範圍'**
  String get uiStoryRange;

  /// Application display copy. Source: lib/presentation/widgets/scene_range_view.dart:103
  ///
  /// In zh, this message translates to:
  /// **'依大箱類型與順序 · 權重＝1＋中箱數＋小箱數'**
  String get uiByStorylineTypeAndOrderWeightEventsScenes;

  /// Application display copy. Source: lib/presentation/widgets/scene_range_view.dart:110
  ///
  /// In zh, this message translates to:
  /// **'新增大箱後，會在這裡顯示場次範圍。'**
  String get uiAddStorylinesToDisplayTheStoryRangeHere;

  /// Application display copy. Source: lib/presentation/widgets/scene_range_view.dart:126
  ///
  /// In zh, this message translates to:
  /// **'{p1}，第 {p2} 至 {p3} 個大箱，權重 {p4}'**
  String uiStorylinesWeight(String p1, String p2, String p3, String p4);

  /// Application display copy. Source: lib/presentation/widgets/scene_snapshot_timeline_preview.dart:82
  ///
  /// In zh, this message translates to:
  /// **'快照綁定：{p1} · 起點 Tick {p2}'**
  String uiSnapshotBoundToStartTick(String p1, String p2);

  /// Application display copy. Source: lib/presentation/widgets/scene_snapshot_timeline_preview.dart:82
  ///
  /// In zh, this message translates to:
  /// **'未選擇 Scene'**
  String get uiNoSceneSelected;

  /// Application display copy. Source: lib/presentation/widgets/scene_snapshot_timeline_preview.dart:84
  ///
  /// In zh, this message translates to:
  /// **'拖曳至單一 Scene 可選取；空白或重疊區域請使用 Scene 選單。'**
  String get uiDragOntoASingleSceneToSelectIt;

  /// Application display copy. Source: lib/presentation/widgets/settings/app_language_selector.dart:63
  ///
  /// In zh, this message translates to:
  /// **'繁體中文'**
  String get uiLiteral4;

  /// Application display copy. Source: lib/presentation/widgets/settings/app_language_selector.dart:71
  ///
  /// In zh, this message translates to:
  /// **'日本語'**
  String get uiLiteral5;

  /// Application display copy. Source: lib/presentation/widgets/settings/settings_color_picker.dart:46
  ///
  /// In zh, this message translates to:
  /// **'除了使用這個主題外，你還可以做什麼……'**
  String get uiBeyondUsingThisThemeWhatElseCanYou;

  /// Application display copy. Source: lib/presentation/widgets/settings/settings_color_picker.dart:54
  ///
  /// In zh, this message translates to:
  /// **'尊重每個人的名字與代名詞、參加「同志遊行」等活動、傾聽 LGBTQ+ 的故事，並在日常生活中支持平等、制止歧視。'**
  String get uiRespectPeopleSNamesAndPronounsJoinEvents;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_panel_card.dart:38
  ///
  /// In zh, this message translates to:
  /// **'時間軸與快照'**
  String get uiTimelineAndSnapshots;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:161
  ///
  /// In zh, this message translates to:
  /// **'Tick {p1} 的事件'**
  String uiEventsAtTick(String p1);

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:284
  ///
  /// In zh, this message translates to:
  /// **'目前編輯預設資料；開啟「跟隨時間軸」可預覽指定 Tick。'**
  String get uiEditingDefaultDataEnableFollowTimelineToPreview;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:286
  ///
  /// In zh, this message translates to:
  /// **'此 Tick 無快照，僅供預覽；新增快照後即可編輯。若要編輯預設資料，請關閉「跟隨時間軸」。'**
  String get uiNoSnapshotAtThisTickPreviewOnlyAdd;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:288
  ///
  /// In zh, this message translates to:
  /// **'此 Tick 僅有 Class 繼承狀態，僅供預覽；新增單件快照後即可編輯。'**
  String get uiOnlyAnInheritedClassStateExistsAtThis;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:289
  ///
  /// In zh, this message translates to:
  /// **'目前編輯此 Tick 的快照，變更只會儲存至此事件。'**
  String get uiEditingThisTickSSnapshotChangesAreSaved;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:373
  ///
  /// In zh, this message translates to:
  /// **'獨立預覽'**
  String get uiIndependentPreview;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:383, lib/ui_library/neon_icon_button.dart:61
  ///
  /// In zh, this message translates to:
  /// **'歷史預覽'**
  String get uiHistoricalPreview;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:399
  ///
  /// In zh, this message translates to:
  /// **'跟隨時間軸'**
  String get uiFollowTimeline;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:421
  ///
  /// In zh, this message translates to:
  /// **'上一事件'**
  String get uiPreviousEvent;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:455
  ///
  /// In zh, this message translates to:
  /// **'下一事件'**
  String get uiNextEvent;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:469
  ///
  /// In zh, this message translates to:
  /// **'定位主時間軸'**
  String get uiLocateOnMainTimeline;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:500
  ///
  /// In zh, this message translates to:
  /// **'Scene 顯示範圍'**
  String get uiSceneDisplayRange;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:503
  ///
  /// In zh, this message translates to:
  /// **'相關 Scene'**
  String get uiRelatedScenes;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:504
  ///
  /// In zh, this message translates to:
  /// **'完整 Scene'**
  String get uiAllScenes;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:545
  ///
  /// In zh, this message translates to:
  /// **'尚無快照事件，可在任意 Tick 預覽'**
  String get uiNoSnapshotEventsPreviewAnyTick;

  /// Application display copy. Source: lib/presentation/widgets/snapshot_timeline_preview.dart:545
  ///
  /// In zh, this message translates to:
  /// **'Scene 尚未排定，使用回退時間'**
  String get uiSceneNotScheduledUsingFallbackTime;

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:38
  ///
  /// In zh, this message translates to:
  /// **'無法載入寫作目標：{p1}'**
  String uiCouldNotLoadWritingGoals(String p1);

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:166
  ///
  /// In zh, this message translates to:
  /// **'本機所有作品合計的每日淨增字數'**
  String get uiDailyNetWordGainAcrossAllLocalWorks;

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:168
  ///
  /// In zh, this message translates to:
  /// **'隨目前作品保存，套用至本檔案。'**
  String get uiSavedWithTheCurrentWorkAndAppliedTo;

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:169
  ///
  /// In zh, this message translates to:
  /// **'套用至所有未設定檔案專屬目標的作品。'**
  String get uiApplyToWorksWithoutAFileSpecificGoal;

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:172
  ///
  /// In zh, this message translates to:
  /// **'本檔案仍使用專屬目標 {p1} 字。'**
  String uiThisFileStillUsesItsOwnGoalOf(String p1);

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:180
  ///
  /// In zh, this message translates to:
  /// **'目標字數'**
  String get uiWordCountGoal;

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:204
  ///
  /// In zh, this message translates to:
  /// **'恢復使用預設'**
  String get uiRestoreDefault;

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:212
  ///
  /// In zh, this message translates to:
  /// **'保存中…'**
  String get uiSaving;

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:229
  ///
  /// In zh, this message translates to:
  /// **'無法讀取寫作目標，點此重試'**
  String get uiCouldNotReadWritingGoalsClickToRetry;

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:238
  ///
  /// In zh, this message translates to:
  /// **'本機所有作品合計'**
  String get uiAllLocalWorksCombined;

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:238
  ///
  /// In zh, this message translates to:
  /// **'預設；檔案專屬值可從對應儀表設定'**
  String get uiDefaultFileSpecificValuesCanBeSetFrom;

  /// Application display copy. Source: lib/ui_library/alias_terms.dart:45
  ///
  /// In zh, this message translates to:
  /// **'請輸入別名'**
  String get uiEnterAnAlias;

  /// Application display copy. Source: lib/ui_library/alias_terms.dart:45
  ///
  /// In zh, this message translates to:
  /// **'別名已存在'**
  String get uiAliasAlreadyExists;

  /// Application display copy. Source: lib/ui_library/alias_terms.dart:54
  ///
  /// In zh, this message translates to:
  /// **'此別名已移除，請取消後重試'**
  String get uiThisAliasWasRemovedCancelAndTryAgain;

  /// Application display copy. Source: lib/ui_library/alias_terms.dart:70
  ///
  /// In zh, this message translates to:
  /// **'別名'**
  String get uiAlias;

  /// Application display copy. Source: lib/ui_library/alias_terms.dart:104
  ///
  /// In zh, this message translates to:
  /// **'輸入別名'**
  String get uiEnterAlias;

  /// Application display copy. Source: lib/ui_library/mini_timeline.dart:533, lib/ui_library/mini_timeline.dart:590
  ///
  /// In zh, this message translates to:
  /// **'時間標記'**
  String get uiTimeMarker;

  /// Application display copy. Source: lib/ui_library/mini_timeline.dart:555
  ///
  /// In zh, this message translates to:
  /// **'未命名節點'**
  String get uiUntitledNode;

  /// Application display copy. Source: lib/ui_library/neon_icon_button.dart:50
  ///
  /// In zh, this message translates to:
  /// **'已啟用'**
  String get uiEnabled;

  /// Application display copy. Source: lib/ui_library/neon_icon_button.dart:54
  ///
  /// In zh, this message translates to:
  /// **'待命'**
  String get uiStandby;

  /// Application display copy. Source: lib/ui_library/neon_icon_button.dart:56
  ///
  /// In zh, this message translates to:
  /// **'異常需要處理'**
  String get uiAttentionRequired;

  /// Application display copy. Source: lib/ui_library/neon_icon_button.dart:57
  ///
  /// In zh, this message translates to:
  /// **'待確認'**
  String get uiAwaitingConfirmation;

  /// Application display copy. Source: lib/ui_library/neon_icon_button.dart:58
  ///
  /// In zh, this message translates to:
  /// **'持續生效'**
  String get uiActive;

  /// Application display copy. Source: lib/ui_library/neon_icon_button.dart:59
  ///
  /// In zh, this message translates to:
  /// **'已連結'**
  String get uiLinked;

  /// Application display copy. Source: lib/ui_library/neon_icon_button.dart:60
  ///
  /// In zh, this message translates to:
  /// **'資訊'**
  String get uiInformation2;

  /// Application display copy. Source: lib/ui_library/neon_icon_button.dart:63
  ///
  /// In zh, this message translates to:
  /// **'處理中'**
  String get uiProcessing;

  /// Application display copy. Source: lib/bin/file.dart:364, lib/bin/file.dart:372
  ///
  /// In zh, this message translates to:
  /// **'儲存專案檔案'**
  String get uiSaveProjectFile;

  /// Application display copy. Source: lib/bin/file.dart:390, lib/bin/file.dart:398
  ///
  /// In zh, this message translates to:
  /// **'匯出文字檔案'**
  String get uiExportTextFile;

  /// Application display copy. Source: lib/bin/file.dart:1259
  ///
  /// In zh, this message translates to:
  /// **'字數目標含無法解析的資料，已保留原始區塊；目前使用可讀目標或預設值。'**
  String get uiSomeWordCountGoalsCouldNotBeParsed;

  /// Application display copy. Source: lib/bin/file.dart:1280
  ///
  /// In zh, this message translates to:
  /// **'<?xml version=\"1.0\" encoding=\"UTF-8\"?>'**
  String get uiXmlVersionEncodingUTF;

  /// Application display copy. Source: lib/bin/file.dart:2118
  ///
  /// In zh, this message translates to:
  /// **'選擇 AutoBackup 目錄'**
  String get uiChooseAutoBackupFolder;

  /// Application display copy. Source: lib/features/editor/plain_text_quill_editor_poc.dart:508
  ///
  /// In zh, this message translates to:
  /// **'開始撰寫正文…'**
  String get uiStartWriting;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_target_resolver.dart:57, lib/features/inline_annotations/inline_annotation_target_resolver.dart:282
  ///
  /// In zh, this message translates to:
  /// **'已回收'**
  String get uiResolved2;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_target_resolver.dart:57, lib/features/inline_annotations/inline_annotation_target_resolver.dart:282
  ///
  /// In zh, this message translates to:
  /// **'未回收'**
  String get uiUnresolved2;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_target_resolver.dart:61, lib/features/inline_annotations/inline_annotation_target_resolver.dart:291
  ///
  /// In zh, this message translates to:
  /// **'進行中'**
  String get uiInProgress;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_target_resolver.dart:310, lib/modules/itemview.dart:3012, lib/presentation/widgets/project_object_selector.dart:355
  ///
  /// In zh, this message translates to:
  /// **'專用'**
  String get uiDedicated;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_target_resolver.dart:311, lib/modules/itemview.dart:3013, lib/presentation/widgets/project_object_selector.dart:356
  ///
  /// In zh, this message translates to:
  /// **'半專用'**
  String get uiSemiDedicated;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_target_resolver.dart:312, lib/modules/itemview.dart:3014, lib/presentation/widgets/project_object_selector.dart:357
  ///
  /// In zh, this message translates to:
  /// **'非專用'**
  String get uiNonDedicated;

  /// Application display copy. Source: lib/features/inline_annotations/inline_annotation_target_resolver.dart:315
  ///
  /// In zh, this message translates to:
  /// **'已封存'**
  String get uiArchived2;

  /// Application display copy. Source: lib/features/navigation/app_module.dart:63
  ///
  /// In zh, this message translates to:
  /// **'首頁'**
  String get uiHome2;

  /// Application display copy. Source: lib/features/navigation/app_module.dart:64
  ///
  /// In zh, this message translates to:
  /// **'故事設定'**
  String get uiStorySettings;

  /// Application display copy. Source: lib/features/navigation/app_module.dart:74, lib/features/revision_tracking/application/revision_field_registry.dart:51
  ///
  /// In zh, this message translates to:
  /// **'角色設定'**
  String get uiCharacters4;

  /// Application display copy. Source: lib/features/navigation/app_module.dart:89
  ///
  /// In zh, this message translates to:
  /// **'正文編輯'**
  String get uiManuscriptEditor;

  /// Application display copy. Source: lib/features/navigation/app_module.dart:106
  ///
  /// In zh, this message translates to:
  /// **'關於'**
  String get uiAbout;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:21, lib/features/poppin/mosaic_intellisense.dart:69, lib/presentation/widgets/settings/settings_color_picker.dart:140
  ///
  /// In zh, this message translates to:
  /// **'灰色'**
  String get uiGray;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:22, lib/presentation/widgets/settings/settings_color_picker.dart:141
  ///
  /// In zh, this message translates to:
  /// **'紅色'**
  String get uiRed;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:23
  ///
  /// In zh, this message translates to:
  /// **'橘色'**
  String get uiOrange;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:24, lib/features/poppin/mosaic_intellisense.dart:68, lib/presentation/widgets/settings/settings_color_picker.dart:143
  ///
  /// In zh, this message translates to:
  /// **'黃色'**
  String get uiYellow;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:25, lib/features/poppin/mosaic_intellisense.dart:64, lib/presentation/widgets/settings/settings_color_picker.dart:144
  ///
  /// In zh, this message translates to:
  /// **'綠色'**
  String get uiGreen;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:26, lib/presentation/widgets/settings/settings_color_picker.dart:145
  ///
  /// In zh, this message translates to:
  /// **'青色'**
  String get uiCyan;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:27, lib/features/poppin/mosaic_intellisense.dart:65, lib/presentation/widgets/settings/settings_color_picker.dart:146
  ///
  /// In zh, this message translates to:
  /// **'藍色'**
  String get uiBlue;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:28, lib/features/poppin/mosaic_intellisense.dart:67, lib/presentation/widgets/settings/settings_color_picker.dart:147
  ///
  /// In zh, this message translates to:
  /// **'紫色'**
  String get uiPurple;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:29, lib/presentation/widgets/settings/settings_color_picker.dart:148
  ///
  /// In zh, this message translates to:
  /// **'粉紅色'**
  String get uiPink;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:434, lib/features/oobe/oobe_screen.dart:618
  ///
  /// In zh, this message translates to:
  /// **'圖示與文字'**
  String get uiIconsAndText;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:434, lib/features/oobe/oobe_screen.dart:618
  ///
  /// In zh, this message translates to:
  /// **'按鈕展開'**
  String get uiExpandWithButton;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:883
  ///
  /// In zh, this message translates to:
  /// **'跟隨系統'**
  String get uiFollowSystem;

  /// Application display copy. Source: lib/features/oobe/oobe_screen.dart:1012
  ///
  /// In zh, this message translates to:
  /// **'MonoAshi'**
  String get uiMonoAshi;

  /// Application display copy. Source: lib/features/phrases/phrase_body_validator.dart:59
  ///
  /// In zh, this message translates to:
  /// **'Mosaic 標記未完成或無效'**
  String get uiMosaicMarkerIsIncompleteOrInvalid;

  /// Application display copy. Source: lib/features/phrases/phrase_transfer_io.dart:25
  ///
  /// In zh, this message translates to:
  /// **'匯出短語庫'**
  String get uiExportPhraseLibrary;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:66
  ///
  /// In zh, this message translates to:
  /// **'粉色'**
  String get uiPink2;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:338
  ///
  /// In zh, this message translates to:
  /// **'人物候選'**
  String get uiCharacterSuggestions;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:346
  ///
  /// In zh, this message translates to:
  /// **'搜尋並插入專案短語'**
  String get uiSearchAndInsertProjectPhrases;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:355
  ///
  /// In zh, this message translates to:
  /// **'地點候選'**
  String get uiLocationSuggestions;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:363
  ///
  /// In zh, this message translates to:
  /// **'事件候選'**
  String get uiEventSuggestions;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:371
  ///
  /// In zh, this message translates to:
  /// **'伏筆候選'**
  String get uiForeshadowingSuggestions;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:379
  ///
  /// In zh, this message translates to:
  /// **'計畫候選'**
  String get uiPlanSuggestions;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:387
  ///
  /// In zh, this message translates to:
  /// **'物品候選'**
  String get uiItemSuggestions;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:395
  ///
  /// In zh, this message translates to:
  /// **'高亮色彩候選'**
  String get uiHighlightColorSuggestions;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:403
  ///
  /// In zh, this message translates to:
  /// **'人物標記骨架'**
  String get uiCharacterMarkerTemplate;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:409
  ///
  /// In zh, this message translates to:
  /// **'地點標記骨架'**
  String get uiLocationMarkerTemplate;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:415
  ///
  /// In zh, this message translates to:
  /// **'事件標記骨架'**
  String get uiEventMarkerTemplate;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:421
  ///
  /// In zh, this message translates to:
  /// **'伏筆標記骨架'**
  String get uiForeshadowingMarkerTemplate;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:427
  ///
  /// In zh, this message translates to:
  /// **'計畫標記骨架'**
  String get uiPlanMarkerTemplate;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:433
  ///
  /// In zh, this message translates to:
  /// **'物品標記骨架'**
  String get uiItemMarkerTemplate;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:439
  ///
  /// In zh, this message translates to:
  /// **'高亮標記骨架'**
  String get uiHighlightMarkerTemplate;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:444
  ///
  /// In zh, this message translates to:
  /// **'插入字面 /'**
  String get uiInsertLiteral;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:445
  ///
  /// In zh, this message translates to:
  /// **'以 \\/ 寫入，避免被解析為語法界線'**
  String get uiWriteAsToPreventParsingAsASyntax;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:450
  ///
  /// In zh, this message translates to:
  /// **'插入字面 \\'**
  String get uiInsertLiteral2;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:451
  ///
  /// In zh, this message translates to:
  /// **'以 \\\\ 寫入'**
  String get uiWriteAs;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:670
  ///
  /// In zh, this message translates to:
  /// **'人物 · 主名稱'**
  String get uiCharacterPrimaryName;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:699
  ///
  /// In zh, this message translates to:
  /// **'新增別名…'**
  String get uiAddAlias2;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:722, lib/features/poppin/mosaic_intellisense.dart:842
  ///
  /// In zh, this message translates to:
  /// **'輸入其他顯示文字…'**
  String get uiEnterOtherDisplayText;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:723
  ///
  /// In zh, this message translates to:
  /// **'僅用於此 Mention，不加入別名'**
  String get uiUseOnlyForThisMentionDoNotAdd;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:738
  ///
  /// In zh, this message translates to:
  /// **'新增子地點…'**
  String get uiAddChildLocation;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:745
  ///
  /// In zh, this message translates to:
  /// **'新增事件…'**
  String get uiAddEvent2;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:752
  ///
  /// In zh, this message translates to:
  /// **'新增場景…'**
  String get uiAddScene2;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:781, lib/modules/timelineview.dart:2910
  ///
  /// In zh, this message translates to:
  /// **'大箱'**
  String get uiStoryline3;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:782, lib/modules/timelineview.dart:2911
  ///
  /// In zh, this message translates to:
  /// **'中箱'**
  String get uiEvent5;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:783, lib/modules/timelineview.dart:2912
  ///
  /// In zh, this message translates to:
  /// **'小箱'**
  String get uiScene3;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:799
  ///
  /// In zh, this message translates to:
  /// **'建立後立即插入標記'**
  String get uiInsertMarkerImmediatelyAfterCreation;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:816
  ///
  /// In zh, this message translates to:
  /// **'高亮背景色 · 文字色自動'**
  String get uiHighlightBackgroundAutomaticTextColor;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:843
  ///
  /// In zh, this message translates to:
  /// **'僅用於此標註'**
  String get uiOnlyForThisAnnotation;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:852
  ///
  /// In zh, this message translates to:
  /// **'標註'**
  String get uiAnnotation3;

  /// Application display copy. Source: lib/features/poppin/mosaic_intellisense.dart:871
  ///
  /// In zh, this message translates to:
  /// **'標記背景色碼 · 文字色自動'**
  String get uiMarkerBackgroundColorCodeAutomaticTextColor;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:49
  ///
  /// In zh, this message translates to:
  /// **'作品資訊'**
  String get uiWorkInformation;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:50
  ///
  /// In zh, this message translates to:
  /// **'章節'**
  String get uiChapters2;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:59
  ///
  /// In zh, this message translates to:
  /// **'創作目的'**
  String get uiCreativePurpose;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:60
  ///
  /// In zh, this message translates to:
  /// **'摘要'**
  String get uiSynopsis2;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:61
  ///
  /// In zh, this message translates to:
  /// **'故事類型'**
  String get uiGenre;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:66
  ///
  /// In zh, this message translates to:
  /// **'年齡'**
  String get uiAge3;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:68
  ///
  /// In zh, this message translates to:
  /// **'角色／職業'**
  String get uiRoleOccupation2;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:70
  ///
  /// In zh, this message translates to:
  /// **'性格'**
  String get uiPersonality2;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:71
  ///
  /// In zh, this message translates to:
  /// **'說話方式'**
  String get uiSpeechStyle2;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:72
  ///
  /// In zh, this message translates to:
  /// **'動機'**
  String get uiMotivation2;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:76, lib/features/revision_tracking/application/revision_field_registry.dart:77
  ///
  /// In zh, this message translates to:
  /// **'自訂欄位'**
  String get uiCustomField;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:79, lib/features/revision_tracking/application/revision_field_registry.dart:80
  ///
  /// In zh, this message translates to:
  /// **'欄位值'**
  String get uiFieldValue;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:81
  ///
  /// In zh, this message translates to:
  /// **'地點類型'**
  String get uiLocationType;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:82
  ///
  /// In zh, this message translates to:
  /// **'節點類型'**
  String get uiNodeType2;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:86
  ///
  /// In zh, this message translates to:
  /// **'衝突'**
  String get uiConflict;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:97
  ///
  /// In zh, this message translates to:
  /// **'預設狀態'**
  String get uiDefaultState;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:99
  ///
  /// In zh, this message translates to:
  /// **'狀態變更'**
  String get uiStateChanges;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:100
  ///
  /// In zh, this message translates to:
  /// **'所屬'**
  String get uiAffiliation;

  /// Application display copy. Source: lib/features/revision_tracking/application/revision_field_registry.dart:101
  ///
  /// In zh, this message translates to:
  /// **'排序'**
  String get uiOrder;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:81
  ///
  /// In zh, this message translates to:
  /// **'中國最偉大、最永久的藝術，就是男人扮女人'**
  String get uiChinaSGreatestAndMostEnduringArtIs;

  /// Application display copy. Source: lib/modules/WelcomeView.dart:82
  ///
  /// In zh, this message translates to:
  /// **'—— 魯迅（1881-1936）'**
  String get uiLuXun;

  /// Application display copy. Source: lib/modules/baseinfoview.dart:247
  ///
  /// In zh, this message translates to:
  /// **'yyyy.MM.dd HH:mm:ss'**
  String get uiYyyyMMDdHHMmSs;

  /// Application display copy. Source: lib/modules/character_relationship_editor.dart:55
  ///
  /// In zh, this message translates to:
  /// **'新增人物關係'**
  String get uiAddCharacterRelationship;

  /// Application display copy. Source: lib/modules/character_relationship_graph_layout.dart:347
  ///
  /// In zh, this message translates to:
  /// **'主角'**
  String get uiProtagonist;

  /// Application display copy. Source: lib/modules/character_relationship_graph_layout.dart:348
  ///
  /// In zh, this message translates to:
  /// **'重要配角'**
  String get uiMajorSupportingCharacter;

  /// Application display copy. Source: lib/modules/character_relationship_graph_layout.dart:349
  ///
  /// In zh, this message translates to:
  /// **'主要反派'**
  String get uiMainAntagonist;

  /// Application display copy. Source: lib/modules/character_relationship_graph_layout.dart:350
  ///
  /// In zh, this message translates to:
  /// **'次要反派'**
  String get uiSecondaryAntagonist;

  /// Application display copy. Source: lib/modules/character_relationship_graph_mapper.dart:194
  ///
  /// In zh, this message translates to:
  /// **'未命名'**
  String get uiUntitled2;

  /// Application display copy. Source: lib/modules/characterview.dart:210
  ///
  /// In zh, this message translates to:
  /// **'料理'**
  String get uiCooking;

  /// Application display copy. Source: lib/modules/characterview.dart:213, lib/modules/characterview.dart:221, lib/modules/characterview.dart:229
  ///
  /// In zh, this message translates to:
  /// **'不擅長'**
  String get uiUnskilled;

  /// Application display copy. Source: lib/modules/characterview.dart:214, lib/modules/characterview.dart:222, lib/modules/characterview.dart:230
  ///
  /// In zh, this message translates to:
  /// **'擅長'**
  String get uiSkilled;

  /// Application display copy. Source: lib/modules/characterview.dart:218
  ///
  /// In zh, this message translates to:
  /// **'清潔'**
  String get uiCleaning;

  /// Application display copy. Source: lib/modules/characterview.dart:226
  ///
  /// In zh, this message translates to:
  /// **'理財'**
  String get uiMoneyManagement;

  /// Application display copy. Source: lib/modules/characterview.dart:234
  ///
  /// In zh, this message translates to:
  /// **'體能'**
  String get uiFitness;

  /// Application display copy. Source: lib/modules/characterview.dart:242
  ///
  /// In zh, this message translates to:
  /// **'藝術'**
  String get uiArt;

  /// Application display copy. Source: lib/modules/characterview.dart:250
  ///
  /// In zh, this message translates to:
  /// **'音樂'**
  String get uiMusic;

  /// Application display copy. Source: lib/modules/characterview.dart:258
  ///
  /// In zh, this message translates to:
  /// **'舞蹈'**
  String get uiDance;

  /// Application display copy. Source: lib/modules/characterview.dart:266
  ///
  /// In zh, this message translates to:
  /// **'手工'**
  String get uiCrafts;

  /// Application display copy. Source: lib/modules/characterview.dart:274
  ///
  /// In zh, this message translates to:
  /// **'社交'**
  String get uiSocialSkills;

  /// Application display copy. Source: lib/modules/characterview.dart:282
  ///
  /// In zh, this message translates to:
  /// **'領導'**
  String get uiLeadership;

  /// Application display copy. Source: lib/modules/characterview.dart:290
  ///
  /// In zh, this message translates to:
  /// **'分析'**
  String get uiAnalysis;

  /// Application display copy. Source: lib/modules/characterview.dart:298
  ///
  /// In zh, this message translates to:
  /// **'創意'**
  String get uiCreativity;

  /// Application display copy. Source: lib/modules/characterview.dart:306
  ///
  /// In zh, this message translates to:
  /// **'記憶'**
  String get uiMemory;

  /// Application display copy. Source: lib/modules/characterview.dart:314
  ///
  /// In zh, this message translates to:
  /// **'觀察'**
  String get uiObservation;

  /// Application display copy. Source: lib/modules/characterview.dart:322
  ///
  /// In zh, this message translates to:
  /// **'應變'**
  String get uiAdaptability;

  /// Application display copy. Source: lib/modules/characterview.dart:330
  ///
  /// In zh, this message translates to:
  /// **'學習'**
  String get uiLearning;

  /// Application display copy. Source: lib/modules/characterview.dart:344
  ///
  /// In zh, this message translates to:
  /// **'內向'**
  String get uiIntroverted;

  /// Application display copy. Source: lib/modules/characterview.dart:345
  ///
  /// In zh, this message translates to:
  /// **'外向'**
  String get uiExtroverted;

  /// Application display copy. Source: lib/modules/characterview.dart:352
  ///
  /// In zh, this message translates to:
  /// **'感性'**
  String get uiEmotional;

  /// Application display copy. Source: lib/modules/characterview.dart:353
  ///
  /// In zh, this message translates to:
  /// **'理性'**
  String get uiRational;

  /// Application display copy. Source: lib/modules/characterview.dart:360
  ///
  /// In zh, this message translates to:
  /// **'被動'**
  String get uiPassive;

  /// Application display copy. Source: lib/modules/characterview.dart:361
  ///
  /// In zh, this message translates to:
  /// **'主動'**
  String get uiProactive;

  /// Application display copy. Source: lib/modules/characterview.dart:368
  ///
  /// In zh, this message translates to:
  /// **'保守'**
  String get uiConservative;

  /// Application display copy. Source: lib/modules/characterview.dart:369
  ///
  /// In zh, this message translates to:
  /// **'開放'**
  String get uiOpenMinded;

  /// Application display copy. Source: lib/modules/characterview.dart:376
  ///
  /// In zh, this message translates to:
  /// **'謹慎'**
  String get uiCautious;

  /// Application display copy. Source: lib/modules/characterview.dart:377
  ///
  /// In zh, this message translates to:
  /// **'冒險'**
  String get uiAdventurous;

  /// Application display copy. Source: lib/modules/characterview.dart:384
  ///
  /// In zh, this message translates to:
  /// **'依賴'**
  String get uiDependent;

  /// Application display copy. Source: lib/modules/characterview.dart:385
  ///
  /// In zh, this message translates to:
  /// **'獨立'**
  String get uiIndependent;

  /// Application display copy. Source: lib/modules/characterview.dart:392
  ///
  /// In zh, this message translates to:
  /// **'柔順'**
  String get uiGentle;

  /// Application display copy. Source: lib/modules/characterview.dart:393
  ///
  /// In zh, this message translates to:
  /// **'固執'**
  String get uiStubborn;

  /// Application display copy. Source: lib/modules/characterview.dart:400, lib/modules/characterview.dart:526
  ///
  /// In zh, this message translates to:
  /// **'悲觀'**
  String get uiPessimistic;

  /// Application display copy. Source: lib/modules/characterview.dart:401, lib/modules/characterview.dart:527
  ///
  /// In zh, this message translates to:
  /// **'樂觀'**
  String get uiOptimistic;

  /// Application display copy. Source: lib/modules/characterview.dart:408, lib/modules/characterview.dart:491
  ///
  /// In zh, this message translates to:
  /// **'嚴肅'**
  String get uiSerious;

  /// Application display copy. Source: lib/modules/characterview.dart:409
  ///
  /// In zh, this message translates to:
  /// **'幽默'**
  String get uiHumorous;

  /// Application display copy. Source: lib/modules/characterview.dart:416
  ///
  /// In zh, this message translates to:
  /// **'害羞'**
  String get uiShy;

  /// Application display copy. Source: lib/modules/characterview.dart:417
  ///
  /// In zh, this message translates to:
  /// **'大方'**
  String get uiOutgoing;

  /// Application display copy. Source: lib/modules/characterview.dart:427
  ///
  /// In zh, this message translates to:
  /// **'低調'**
  String get uiLowKey;

  /// Application display copy. Source: lib/modules/characterview.dart:428
  ///
  /// In zh, this message translates to:
  /// **'高調'**
  String get uiShowy;

  /// Application display copy. Source: lib/modules/characterview.dart:435
  ///
  /// In zh, this message translates to:
  /// **'消極'**
  String get uiNegative;

  /// Application display copy. Source: lib/modules/characterview.dart:436
  ///
  /// In zh, this message translates to:
  /// **'積極'**
  String get uiPositive;

  /// Application display copy. Source: lib/modules/characterview.dart:443
  ///
  /// In zh, this message translates to:
  /// **'狡猾'**
  String get uiCunning;

  /// Application display copy. Source: lib/modules/characterview.dart:444
  ///
  /// In zh, this message translates to:
  /// **'老實'**
  String get uiHonest;

  /// Application display copy. Source: lib/modules/characterview.dart:451
  ///
  /// In zh, this message translates to:
  /// **'幼稚'**
  String get uiChildish;

  /// Application display copy. Source: lib/modules/characterview.dart:452
  ///
  /// In zh, this message translates to:
  /// **'成熟'**
  String get uiMature;

  /// Application display copy. Source: lib/modules/characterview.dart:459
  ///
  /// In zh, this message translates to:
  /// **'冷靜'**
  String get uiCalm;

  /// Application display copy. Source: lib/modules/characterview.dart:460
  ///
  /// In zh, this message translates to:
  /// **'衝動'**
  String get uiImpulsive;

  /// Application display copy. Source: lib/modules/characterview.dart:467
  ///
  /// In zh, this message translates to:
  /// **'寡言'**
  String get uiQuiet;

  /// Application display copy. Source: lib/modules/characterview.dart:468
  ///
  /// In zh, this message translates to:
  /// **'多話'**
  String get uiTalkative;

  /// Application display copy. Source: lib/modules/characterview.dart:475
  ///
  /// In zh, this message translates to:
  /// **'執拗'**
  String get uiObstinate;

  /// Application display copy. Source: lib/modules/characterview.dart:476
  ///
  /// In zh, this message translates to:
  /// **'順從'**
  String get uiCompliant;

  /// Application display copy. Source: lib/modules/characterview.dart:483
  ///
  /// In zh, this message translates to:
  /// **'奔放'**
  String get uiUnrestrained;

  /// Application display copy. Source: lib/modules/characterview.dart:484
  ///
  /// In zh, this message translates to:
  /// **'自律'**
  String get uiSelfDisciplined;

  /// Application display copy. Source: lib/modules/characterview.dart:492
  ///
  /// In zh, this message translates to:
  /// **'輕浮'**
  String get uiFrivolous;

  /// Application display copy. Source: lib/modules/characterview.dart:499
  ///
  /// In zh, this message translates to:
  /// **'彆扭'**
  String get uiAwkward;

  /// Application display copy. Source: lib/modules/characterview.dart:500
  ///
  /// In zh, this message translates to:
  /// **'坦率'**
  String get uiFrank;

  /// Application display copy. Source: lib/modules/characterview.dart:507
  ///
  /// In zh, this message translates to:
  /// **'淡漠'**
  String get uiIndifferent;

  /// Application display copy. Source: lib/modules/characterview.dart:508
  ///
  /// In zh, this message translates to:
  /// **'好奇'**
  String get uiCurious;

  /// Application display copy. Source: lib/modules/characterview.dart:515
  ///
  /// In zh, this message translates to:
  /// **'遲鈍'**
  String get uiSlowToNotice;

  /// Application display copy. Source: lib/modules/characterview.dart:516
  ///
  /// In zh, this message translates to:
  /// **'敏銳'**
  String get uiPerceptive;

  /// Application display copy. Source: lib/modules/characterview.dart:534
  ///
  /// In zh, this message translates to:
  /// **'面癱'**
  String get uiExpressionless;

  /// Application display copy. Source: lib/modules/characterview.dart:535
  ///
  /// In zh, this message translates to:
  /// **'生動'**
  String get uiExpressive;

  /// Application display copy. Source: lib/modules/characterview.dart:542
  ///
  /// In zh, this message translates to:
  /// **'笨蛋'**
  String get uiFoolish;

  /// Application display copy. Source: lib/modules/characterview.dart:543
  ///
  /// In zh, this message translates to:
  /// **'天才'**
  String get uiGenius;

  /// Application display copy. Source: lib/modules/characterview.dart:550
  ///
  /// In zh, this message translates to:
  /// **'單純'**
  String get uiSimple;

  /// Application display copy. Source: lib/modules/characterview.dart:551
  ///
  /// In zh, this message translates to:
  /// **'複雜'**
  String get uiComplex;

  /// Application display copy. Source: lib/modules/characterview.dart:558
  ///
  /// In zh, this message translates to:
  /// **'臉薄'**
  String get uiEasilyEmbarrassed;

  /// Application display copy. Source: lib/modules/characterview.dart:559
  ///
  /// In zh, this message translates to:
  /// **'厚顏'**
  String get uiShameless;

  /// Application display copy. Source: lib/modules/characterview.dart:566
  ///
  /// In zh, this message translates to:
  /// **'溫和'**
  String get uiMild;

  /// Application display copy. Source: lib/modules/characterview.dart:567
  ///
  /// In zh, this message translates to:
  /// **'火爆'**
  String get uiHotTempered;

  /// Application display copy. Source: lib/modules/characterview.dart:574
  ///
  /// In zh, this message translates to:
  /// **'粗魯'**
  String get uiRough;

  /// Application display copy. Source: lib/modules/characterview.dart:575
  ///
  /// In zh, this message translates to:
  /// **'斯文'**
  String get uiRefined;

  /// Application display copy. Source: lib/modules/characterview.dart:582
  ///
  /// In zh, this message translates to:
  /// **'軟弱'**
  String get uiWeakWilled;

  /// Application display copy. Source: lib/modules/characterview.dart:583
  ///
  /// In zh, this message translates to:
  /// **'堅定'**
  String get uiDetermined;

  /// Application display copy. Source: lib/modules/characterview.dart:590
  ///
  /// In zh, this message translates to:
  /// **'無慾'**
  String get uiWithoutDesire;

  /// Application display copy. Source: lib/modules/characterview.dart:591
  ///
  /// In zh, this message translates to:
  /// **'強烈'**
  String get uiIntense;

  /// Application display copy. Source: lib/modules/characterview.dart:598
  ///
  /// In zh, this message translates to:
  /// **'膽小'**
  String get uiTimid;

  /// Application display copy. Source: lib/modules/characterview.dart:599
  ///
  /// In zh, this message translates to:
  /// **'勇敢'**
  String get uiBrave;

  /// Application display copy. Source: lib/modules/characterview.dart:606
  ///
  /// In zh, this message translates to:
  /// **'木訥'**
  String get uiInarticulate;

  /// Application display copy. Source: lib/modules/characterview.dart:607
  ///
  /// In zh, this message translates to:
  /// **'風趣'**
  String get uiWitty;

  /// Application display copy. Source: lib/modules/characterview.dart:614
  ///
  /// In zh, this message translates to:
  /// **'輕信'**
  String get uiTrusting;

  /// Application display copy. Source: lib/modules/characterview.dart:615
  ///
  /// In zh, this message translates to:
  /// **'多疑'**
  String get uiSuspicious;

  /// Application display copy. Source: lib/modules/characterview.dart:622
  ///
  /// In zh, this message translates to:
  /// **'自卑'**
  String get uiInsecure;

  /// Application display copy. Source: lib/modules/characterview.dart:623
  ///
  /// In zh, this message translates to:
  /// **'自信'**
  String get uiConfident;

  /// Application display copy. Source: lib/modules/characterview.dart:630
  ///
  /// In zh, this message translates to:
  /// **'退縮'**
  String get uiWithdrawn;

  /// Application display copy. Source: lib/modules/characterview.dart:631
  ///
  /// In zh, this message translates to:
  /// **'果敢'**
  String get uiDecisive;

  /// Application display copy. Source: lib/modules/characterview.dart:638
  ///
  /// In zh, this message translates to:
  /// **'陰角'**
  String get uiSociallyReserved;

  /// Application display copy. Source: lib/modules/characterview.dart:639
  ///
  /// In zh, this message translates to:
  /// **'陽角'**
  String get uiSociallyOutgoing;

  /// Application display copy. Source: lib/modules/characterview.dart:2127
  ///
  /// In zh, this message translates to:
  /// **'直接告白'**
  String get uiConfessDirectly;

  /// Application display copy. Source: lib/modules/characterview.dart:2128
  ///
  /// In zh, this message translates to:
  /// **'送禮物'**
  String get uiGiveGifts;

  /// Application display copy. Source: lib/modules/characterview.dart:2129
  ///
  /// In zh, this message translates to:
  /// **'常常找對方講話'**
  String get uiTalkToThemOften;

  /// Application display copy. Source: lib/modules/characterview.dart:2130
  ///
  /// In zh, this message translates to:
  /// **'做些小動作引起注意'**
  String get uiDoLittleThingsToGetAttention;

  /// Application display copy. Source: lib/modules/characterview.dart:2131
  ///
  /// In zh, this message translates to:
  /// **'默默關注對方'**
  String get uiQuietlyPayAttention;

  /// Application display copy. Source: lib/modules/characterview.dart:2144
  ///
  /// In zh, this message translates to:
  /// **'微笑'**
  String get uiSmile;

  /// Application display copy. Source: lib/modules/characterview.dart:2145
  ///
  /// In zh, this message translates to:
  /// **'主動打招呼'**
  String get uiGreetThemFirst;

  /// Application display copy. Source: lib/modules/characterview.dart:2146
  ///
  /// In zh, this message translates to:
  /// **'主動幫忙'**
  String get uiOfferHelp;

  /// Application display copy. Source: lib/modules/characterview.dart:2147
  ///
  /// In zh, this message translates to:
  /// **'送小禮物'**
  String get uiGiveSmallGifts;

  /// Application display copy. Source: lib/modules/characterview.dart:2148
  ///
  /// In zh, this message translates to:
  /// **'邀請對方'**
  String get uiInviteThem;

  /// Application display copy. Source: lib/modules/characterview.dart:2149
  ///
  /// In zh, this message translates to:
  /// **'分享自己的事'**
  String get uiSharePersonalStories;

  /// Application display copy. Source: lib/modules/characterview.dart:2162
  ///
  /// In zh, this message translates to:
  /// **'直接無視'**
  String get uiIgnoreThem;

  /// Application display copy. Source: lib/modules/characterview.dart:2163
  ///
  /// In zh, this message translates to:
  /// **'保持距離'**
  String get uiKeepADistance;

  /// Application display copy. Source: lib/modules/characterview.dart:2164
  ///
  /// In zh, this message translates to:
  /// **'禮貌應對'**
  String get uiRespondPolitely;

  /// Application display copy. Source: lib/modules/characterview.dart:2165
  ///
  /// In zh, this message translates to:
  /// **'冷嘲熱諷'**
  String get uiUseSarcasm;

  /// Application display copy. Source: lib/modules/characterview.dart:2166
  ///
  /// In zh, this message translates to:
  /// **'正面衝突'**
  String get uiConfrontThem;

  /// Application display copy. Source: lib/modules/characterview.dart:2167
  ///
  /// In zh, this message translates to:
  /// **'找人幫忙'**
  String get uiAskOthersForHelp;

  /// Application display copy. Source: lib/modules/characterview.dart:4653
  ///
  /// In zh, this message translates to:
  /// **'守序\n善良'**
  String get uiLawfulGood;

  /// Application display copy. Source: lib/modules/characterview.dart:4653
  ///
  /// In zh, this message translates to:
  /// **'中立\n善良'**
  String get uiNeutralGood;

  /// Application display copy. Source: lib/modules/characterview.dart:4653
  ///
  /// In zh, this message translates to:
  /// **'混亂\n善良'**
  String get uiChaoticGood;

  /// Application display copy. Source: lib/modules/characterview.dart:4654
  ///
  /// In zh, this message translates to:
  /// **'守序\n中立'**
  String get uiLawfulNeutral;

  /// Application display copy. Source: lib/modules/characterview.dart:4654
  ///
  /// In zh, this message translates to:
  /// **'絕對\n中立'**
  String get uiTrueNeutral;

  /// Application display copy. Source: lib/modules/characterview.dart:4654
  ///
  /// In zh, this message translates to:
  /// **'混亂\n中立'**
  String get uiChaoticNeutral;

  /// Application display copy. Source: lib/modules/characterview.dart:4655
  ///
  /// In zh, this message translates to:
  /// **'守序\n邪惡'**
  String get uiLawfulEvil;

  /// Application display copy. Source: lib/modules/characterview.dart:4655
  ///
  /// In zh, this message translates to:
  /// **'中立\n邪惡'**
  String get uiNeutralEvil;

  /// Application display copy. Source: lib/modules/characterview.dart:4655
  ///
  /// In zh, this message translates to:
  /// **'絕對\n邪惡'**
  String get uiAbsoluteEvil;

  /// Application display copy. Source: lib/modules/characterview.dart:5965
  ///
  /// In zh, this message translates to:
  /// **'單身'**
  String get uiSingle;

  /// Application display copy. Source: lib/modules/characterview.dart:5965
  ///
  /// In zh, this message translates to:
  /// **'已婚/準備結婚'**
  String get uiMarriedEngaged;

  /// Application display copy. Source: lib/modules/characterview.dart:5965
  ///
  /// In zh, this message translates to:
  /// **'戀愛中/準備戀愛'**
  String get uiDatingStartingARelationship;

  /// Application display copy. Source: lib/modules/characterview.dart:5965
  ///
  /// In zh, this message translates to:
  /// **'喪偶'**
  String get uiWidowed;

  /// Application display copy. Source: lib/modules/itemview.dart:3021
  ///
  /// In zh, this message translates to:
  /// **'場景'**
  String get uiScene4;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:233, lib/modules/proofreadingview.dart:234
  ///
  /// In zh, this message translates to:
  /// **'逗號'**
  String get uiComma;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:235, lib/modules/proofreadingview.dart:236
  ///
  /// In zh, this message translates to:
  /// **'句號'**
  String get uiPeriod;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:237
  ///
  /// In zh, this message translates to:
  /// **'頓號'**
  String get uiEnumerationComma;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:238
  ///
  /// In zh, this message translates to:
  /// **'刪節號'**
  String get uiEllipsis;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:239, lib/modules/proofreadingview.dart:240, lib/modules/proofreadingview.dart:241
  ///
  /// In zh, this message translates to:
  /// **'同類引號'**
  String get uiSameTypeQuotes;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:1421
  ///
  /// In zh, this message translates to:
  /// **'解決單項'**
  String get uiResolveThisIssue;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2369, lib/modules/proofreadingview.dart:2374
  ///
  /// In zh, this message translates to:
  /// **'Proofreading worker has been disposed.'**
  String get uiProofreadingWorkerHasBeenDisposed;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2791
  ///
  /// In zh, this message translates to:
  /// **'引號結構應以\" \"開頭，不應以\'\' \'\'開頭。'**
  String get uiQuotesShouldStartWithNot;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2809
  ///
  /// In zh, this message translates to:
  /// **'偵測到引號層級未交錯，建議以\" \"與\'\' \'\'交替。'**
  String get uiQuoteLevelsShouldAlternateBetweenAnd;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2945
  ///
  /// In zh, this message translates to:
  /// **'引號結構應以「」開頭，不應以『』開頭。'**
  String get uiQuotesShouldStartWithNot2;

  /// Application display copy. Source: lib/modules/proofreadingview.dart:2973
  ///
  /// In zh, this message translates to:
  /// **'偵測到引號層級未交錯，建議以「『』」為一循環交替。'**
  String get uiQuoteLevelsShouldAlternateInACycle;

  /// Application display copy. Source: lib/modules/timelineview.dart:2916
  ///
  /// In zh, this message translates to:
  /// **'秒'**
  String get uiSeconds;

  /// Application display copy. Source: lib/modules/timelineview.dart:2917
  ///
  /// In zh, this message translates to:
  /// **'分鐘'**
  String get uiMinutes2;

  /// Application display copy. Source: lib/modules/timelineview.dart:2918
  ///
  /// In zh, this message translates to:
  /// **'小時'**
  String get uiHours;

  /// Application display copy. Source: lib/modules/timelineview.dart:2919
  ///
  /// In zh, this message translates to:
  /// **'天'**
  String get uiDays;

  /// Application display copy. Source: lib/modules/timelineview.dart:2920
  ///
  /// In zh, this message translates to:
  /// **'週'**
  String get uiWeeks;

  /// Application display copy. Source: lib/modules/timelineview.dart:2921
  ///
  /// In zh, this message translates to:
  /// **'月'**
  String get uiMonths;

  /// Application display copy. Source: lib/modules/timelineview.dart:2922
  ///
  /// In zh, this message translates to:
  /// **'季節'**
  String get uiSeasons;

  /// Application display copy. Source: lib/modules/timelineview.dart:2923
  ///
  /// In zh, this message translates to:
  /// **'年'**
  String get uiYears;

  /// Application display copy. Source: lib/modules/timelineview.dart:2924
  ///
  /// In zh, this message translates to:
  /// **'十年'**
  String get uiDecades;

  /// Application display copy. Source: lib/modules/timelineview.dart:2925
  ///
  /// In zh, this message translates to:
  /// **'世紀'**
  String get uiCenturies;

  /// Application display copy. Source: lib/modules/timelineview.dart:2926
  ///
  /// In zh, this message translates to:
  /// **'自訂單位'**
  String get uiCustomUnit;

  /// Application display copy. Source: lib/presentation/widgets/project_object_selector.dart:53, lib/presentation/widgets/project_object_selector.dart:74
  ///
  /// In zh, this message translates to:
  /// **'選擇物件'**
  String get uiChooseObject;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:20, lib/presentation/widgets/writing_goal_dialog.dart:11
  ///
  /// In zh, this message translates to:
  /// **'每日目標'**
  String get uiDailyGoal;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:22
  ///
  /// In zh, this message translates to:
  /// **'全書字數'**
  String get uiBookWordCount;

  /// Application display copy. Source: lib/presentation/widgets/radial_gauge_dashboard.dart:24
  ///
  /// In zh, this message translates to:
  /// **'伏筆回收'**
  String get uiForeshadowingResolution;

  /// Application display copy. Source: lib/presentation/widgets/settings/settings_color_picker.dart:142
  ///
  /// In zh, this message translates to:
  /// **'橙色'**
  String get uiOrange2;

  /// Application display copy. Source: lib/presentation/widgets/timeline_mini_view.dart:41, lib/ui_library/mini_timeline.dart:86
  ///
  /// In zh, this message translates to:
  /// **'尚無時間軸節點'**
  String get uiNoTimelineNodesYet;

  /// Application display copy. Source: lib/presentation/widgets/timeline_mini_view.dart:42, lib/ui_library/mini_timeline.dart:87
  ///
  /// In zh, this message translates to:
  /// **'微型時間軸'**
  String get uiMiniTimeline;

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:12
  ///
  /// In zh, this message translates to:
  /// **'每章字數目標'**
  String get uiDefaultChapterWordCountGoal;

  /// Application display copy. Source: lib/presentation/widgets/writing_goal_dialog.dart:13
  ///
  /// In zh, this message translates to:
  /// **'全文字數目標'**
  String get uiDefaultProjectWordCountGoal;

  /// Application display copy. Source: lib/ui_library/collections.dart:318, lib/ui_library/collections.dart:347, lib/ui_library/collections.dart:373
  ///
  /// In zh, this message translates to:
  /// **'尚無資料'**
  String get uiNoDataYet;

  /// Application display copy. Source: lib/ui_library/dialogs.dart:37
  ///
  /// In zh, this message translates to:
  /// **'Use either title or titleWidget, not both.'**
  String get uiUseEitherTitleOrTitleWidgetNotBoth;

  /// Application display copy. Source: lib/ui_library/forms.dart:160
  ///
  /// In zh, this message translates to:
  /// **'controller and initialValue cannot both be supplied.'**
  String get uiControllerAndInitialValueCannotBothBeSupplied;

  /// Application display copy. Source: lib/ui_library/forms.dart:164
  ///
  /// In zh, this message translates to:
  /// **'minLines and maxLines must be null when expands is true.'**
  String get uiMinLinesAndMaxLinesMustBeNullWhenExpands;

  /// Application display copy. Source: lib/ui_library/layout.dart:147
  ///
  /// In zh, this message translates to:
  /// **'Use either title or a custom header, not both.'**
  String get uiUseEitherTitleOrACustomHeaderNot;

  /// Application display copy. Source: lib/ui_library/layout.dart:151
  ///
  /// In zh, this message translates to:
  /// **'Use either backgroundColor or color, not both.'**
  String get uiUseEitherBackgroundColorOrColorNotBoth;

  /// Application display copy. Source: lib/ui_library/layout.dart:259
  ///
  /// In zh, this message translates to:
  /// **'Use either action or actionLabel/onAction.'**
  String get uiUseEitherActionOrActionLabelOnAction;

  /// Application display copy. Source: lib/ui_library/layout.dart:263
  ///
  /// In zh, this message translates to:
  /// **'actionLabel and onAction must be provided together.'**
  String get uiActionLabelAndOnActionMustBeProvidedTogether;

  /// Application display copy. Source: lib/ui_library/tables.dart:61
  ///
  /// In zh, this message translates to:
  /// **'A controller is required when showScrollbar is true.'**
  String get uiAControllerIsRequiredWhenShowScrollbarIsTrue;

  /// Application display copy. Source: lib/ui_library/tables.dart:470
  ///
  /// In zh, this message translates to:
  /// **'（空白）'**
  String get uiBlank2;

  /// Application display copy. Source: lib/ui_library/theme_palette.dart:5
  ///
  /// In zh, this message translates to:
  /// **'一般配色'**
  String get uiStandard;

  /// Application display copy. Source: lib/ui_library/theme_palette.dart:6
  ///
  /// In zh, this message translates to:
  /// **'高對比'**
  String get uiHighContrast;

  /// Application display copy. Source: lib/ui_library/theme_palette.dart:7
  ///
  /// In zh, this message translates to:
  /// **'Show Your Pride/彩虹旗'**
  String get uiShowYourPrideRainbow;

  /// Application display copy. Source: lib/ui_library/theme_palette.dart:8
  ///
  /// In zh, this message translates to:
  /// **'Show Your Pride/女同志'**
  String get uiShowYourPrideLesbian;

  /// Application display copy. Source: lib/ui_library/theme_palette.dart:9
  ///
  /// In zh, this message translates to:
  /// **'Show Your Pride/雙性戀'**
  String get uiShowYourPrideBisexual;

  /// Application display copy. Source: lib/ui_library/theme_palette.dart:10
  ///
  /// In zh, this message translates to:
  /// **'Show Your Pride/跨性別'**
  String get uiShowYourPrideTransgender;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'僅顯示圖示，停留或聚焦時顯示名稱。'**
  String get navigationTooltipDescription;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'圖示下方常駐顯示名稱。'**
  String get navigationLabelDescription;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'使用底部按鈕展開導覽，並推開內容側欄。'**
  String get navigationDrawerDescription;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'游標停留時預覽，移開後收合；固定開啟時推開內容側欄。'**
  String get navigationHoverDescription;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'完整功能區，顯示頁籤、群組與指令名稱。'**
  String get toolbarFullDescription;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'保留功能區頁籤，該頁指令以單行圖示與文字顯示，可橫向捲動。'**
  String get toolbarModerateDescription;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'保留功能區頁籤，該頁指令以純圖示單行排列，可橫向捲動。'**
  String get toolbarConciseDescription;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'Word（尚未開放）'**
  String get exportWordUnavailable;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'PDF（尚未開放）'**
  String get exportPdfUnavailable;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'章節內容'**
  String get exchangeChapters;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'大綱與時間軸'**
  String get exchangeOutline;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'更新計畫與伏筆'**
  String get exchangePlans;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'世界設定與地點快照'**
  String get exchangeWorld;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'角色設定與快照'**
  String get exchangeCharacters;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'物品設定與快照'**
  String get exchangeItems;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'次要配角'**
  String get characterMinorSupporting;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'未命名{label}'**
  String untitledTimelineNode(String label);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'早安，\n{name}！'**
  String welcomeMorning(String name);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'午安，\n{name}！'**
  String welcomeAfternoon(String name);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'晚安，\n{name}！'**
  String welcomeEvening(String name);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'夜深了，\n{name}！'**
  String welcomeNight(String name);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'使用者'**
  String get welcomeUser;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'更多選項'**
  String get ribbonMoreOptions;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'自訂功能區'**
  String get ribbonCustomize;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'快速存取工具列'**
  String get ribbonQuickAccess;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'功能區索引標籤'**
  String get ribbonTabs;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'展開快速存取工具列'**
  String get ribbonExpandQuickAccess;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'收合快速存取工具列'**
  String get ribbonCollapseQuickAccess;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'自訂快速存取工具列'**
  String get ribbonCustomizeQuickAccess;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'更多快速存取命令'**
  String get ribbonMoreQuickAccess;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'展開功能區（{shortcut}）'**
  String ribbonExpand(String shortcut);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'收合功能區（{shortcut}）'**
  String ribbonCollapse(String shortcut);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'搜尋命令'**
  String get ribbonSearch;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'文字色彩'**
  String get ribbonTextColor;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'色彩'**
  String get ribbonColor;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'字型'**
  String get ribbonFont;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'{label} 索引標籤'**
  String ribbonTabSemantics(String label);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'上移 {label}'**
  String ribbonMoveTabUp(String label);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'下移 {label}'**
  String ribbonMoveTabDown(String label);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'{label} 命令'**
  String ribbonCommandsSemantics(String label);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'{label} 群組'**
  String ribbonGroupSemantics(String label);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'使用左右方向鍵、Home 或 End 切換。'**
  String get ribbonTabNavigation;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'重設為預設值'**
  String get ribbonReset;

  /// Complete Ribbon customization.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get ribbonDone;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'瀏覽{p1}對象'**
  String completionBrowseTargets(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'待連結 {p1}'**
  String completionPendingLink(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'{p1} · {p2}的別名'**
  String completionAlias(String p1, String p2);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'人物 · {p1}的別名'**
  String completionCharacterAlias(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'為 {p1} 新增別名'**
  String completionAddAlias(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'新增{p1}…'**
  String completionCreateTarget(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'高亮文字色 · 背景 {p1}'**
  String completionHighlightForeground(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'標記文字色碼 · 背景 {p1}'**
  String completionMarkerForeground(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'名稱不明確：{p1}'**
  String relationshipAmbiguousName(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'未連結：{p1}'**
  String relationshipUnlinked(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'阻礙 {p1}'**
  String snapshotConflictsCount(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'人物關係 {p1}'**
  String snapshotRelationshipsCount(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'組織 {p1}'**
  String snapshotOrganizationsCount(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'角色狀態 {p1}'**
  String snapshotStatusesCount(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'擁有物品 {p1}'**
  String snapshotPossessionsCount(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'自訂欄位 {p1}'**
  String snapshotCustomFieldsCount(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'{p1} 則靈感'**
  String inspirationNoteCount(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'出現未配對的右符號「{p1}」。'**
  String proofUnmatchedClosing(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'右符號「{p1}」與左符號「{p2}」不匹配，預期為「{p3}」。'**
  String proofMismatchedPair(String p1, String p2, String p3);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'左符號「{p1}」未閉合，缺少「{p2}」。'**
  String proofUnclosedPair(String p1, String p2);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'刪節號建議使用「……」，目前為「{p1}」。'**
  String proofEllipsisSuggestion(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'連續{p1}個{p2}「{p3}」。'**
  String proofConsecutiveSymbols(String p1, String p2, String p3);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'[{p1}] 行尾未符合結尾規則，目前為「{p2}」。'**
  String proofInvalidLineEnding(String p1, String p2);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'未命名{p1}'**
  String timelineUnnamedLevel(String p1);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'{p1} • {p2} 個子節點'**
  String worldChildNodeCount(String p1, String p2);

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'取消接受'**
  String get revisionUnaccept;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'接受'**
  String get revisionAccept;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'拒絕'**
  String get revisionReject;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'外在'**
  String get relationshipExternal;

  /// Localized application presentation label.
  ///
  /// In zh, this message translates to:
  /// **'內在'**
  String get relationshipInternal;

  /// Validation message for positive writing goal input.
  ///
  /// In zh, this message translates to:
  /// **'請輸入 1 到 999,999,999 的整數'**
  String get writingGoalInvalid;

  /// Application-owned enum label, not the stored value.
  ///
  /// In zh, this message translates to:
  /// **'規則'**
  String get worldRule;

  /// Application-owned enum label, not the stored value.
  ///
  /// In zh, this message translates to:
  /// **'組織'**
  String get worldOrganization;

  /// Application-owned enum label, not the stored value.
  ///
  /// In zh, this message translates to:
  /// **'正面'**
  String get glossaryPositive;

  /// Application-owned enum label, not the stored value.
  ///
  /// In zh, this message translates to:
  /// **'負面'**
  String get glossaryNegative;

  /// Application-owned enum label, not the stored value.
  ///
  /// In zh, this message translates to:
  /// **'中性'**
  String get glossaryNeutral;

  /// Application-owned enum label, not the stored value.
  ///
  /// In zh, this message translates to:
  /// **'名詞'**
  String get glossaryNoun;

  /// Application-owned enum label, not the stored value.
  ///
  /// In zh, this message translates to:
  /// **'動詞'**
  String get glossaryVerb;

  /// Application-owned enum label, not the stored value.
  ///
  /// In zh, this message translates to:
  /// **'形容詞'**
  String get glossaryAdjective;

  /// Application-owned enum label, not the stored value.
  ///
  /// In zh, this message translates to:
  /// **'副詞'**
  String get glossaryAdverb;

  /// Application-owned enum label, not the stored value.
  ///
  /// In zh, this message translates to:
  /// **'代詞'**
  String get glossaryPronoun;

  /// Application-owned enum label, not the stored value.
  ///
  /// In zh, this message translates to:
  /// **'未指定'**
  String get glossaryUnspecified;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'不擅長做'**
  String get conflictUnskilledActivities;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'人格特質'**
  String get conflictPersonalityTraits;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'值'**
  String get conflictValue;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'價值觀'**
  String get conflictValuesAndBeliefs;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'內在衝突'**
  String get conflictInternalConflict;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'分配數量'**
  String get conflictAllocatedQuantity;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'喜歡做'**
  String get conflictFavoriteActivities;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'喜歡項目'**
  String get conflictLikes;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'回顧'**
  String get conflictSynopsis;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'姓名'**
  String get conflictName;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'害怕做'**
  String get conflictFearedActivities;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'害怕項目'**
  String get conflictFears;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'尋找新戀情'**
  String get conflictSeekingANewRelationship;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'崇拜項目'**
  String get conflictAdmiredThings;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'常用能力'**
  String get conflictCommonAbilities;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'常用能力值'**
  String get conflictCommonAbilityValues;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'後宮'**
  String get conflictHarem;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'恐懼'**
  String get conflictFear;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'想做'**
  String get conflictDesiredActivities;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'描述'**
  String get conflictDescription;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'擅長做'**
  String get conflictSkilledActivities;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'文字欄位'**
  String get conflictTextFields;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'熟悉項目'**
  String get conflictFamiliarThings;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'物品資料'**
  String get conflictItemData;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'特質值'**
  String get conflictTraitValues;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'社交值'**
  String get conflictSocialValues;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'社交特質'**
  String get conflictSocialTraits;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'職業或角色'**
  String get conflictOccupationOrRole;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'舊版欄位'**
  String get conflictLegacyFields;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'處事值'**
  String get conflictApproachValues;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'處事方式'**
  String get conflictApproaches;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'處理厭惡'**
  String get conflictHandlingDislike;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'表達好感'**
  String get conflictShowingGoodwill;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'表達愛'**
  String get conflictShowingLove;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'解決'**
  String get conflictResolution;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'解法'**
  String get conflictResolutionMethod;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'討厭做'**
  String get conflictDislikedActivities;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'討厭項目'**
  String get conflictDislikes;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'進階能力'**
  String get conflictAdvancedAbilities;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'關係'**
  String get conflictRelationship;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'關係摘要'**
  String get conflictRelationshipSummary;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'阻礙'**
  String get conflictObstacle;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'目標復原資料'**
  String get conflictGoalRecoveryData;

  /// App-owned conflict schema field label; identity remains unchanged.
  ///
  /// In zh, this message translates to:
  /// **'整體版本'**
  String get conflictWholeVersion;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'{p1} 已連入並驗證本機端點；TCP 可雙向通訊，不需要再從本機反向連線。'**
  String p2pConnectedAndVerifiedThisEndpointTCPWorks(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'{p1} 已送達安全配對要求；本機正在自動回應。'**
  String p2pSentASecurePairingRequestThisDevice(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'處理遠端安全配對事件失敗：{p1}'**
  String p2pCouldNotProcessTheRemotePairingEvent(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已拒絕無效的遠端 revision graph：{p1}'**
  String p2pRejectedAnInvalidRemoteRevisionGraph(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已忽略對方上一輪過期的配對 challenge，等待自動更新。'**
  String get p2pIgnoredAnExpiredPairingChallengeFromThe;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'對方的配對 challenge 無效、遭竄改或已過期。'**
  String get p2pThePeerSPairingChallengeIsInvalid;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已信任裝置的公開金鑰發生變更；已拒絕配對。'**
  String get p2pTheTrustedDeviceSPublicKeyChanged;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'對方要求安全配對，但本機暫時無法建立 challenge；正在等待重試。'**
  String get p2pThePeerRequestedSecurePairingButThis;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'請在兩台裝置上比較六位數配對碼；完全相同才可確認。'**
  String get p2pCompareTheSixDigitPairingCodeOn;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'雙端 14 天持久驗證仍有效；已自動回簽本次短期 session。'**
  String get p2pBothDevicesDayAuthenticationIsValidThis;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'持久驗證自動回簽失敗：{p1}'**
  String p2pPersistentAuthenticationCouldNotSignAutomatically(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已忽略上一輪的 pairing confirmation，等待目前 challenge 的回簽。'**
  String get p2pIgnoredAPreviousPairingConfirmationWaitingFor;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'對方的 pairing confirmation 簽章或 transcript 不一致。'**
  String get p2pThePeerSPairingConfirmationSignatureOr;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'對方已確認配對碼；雙方皆允許單端確認，本機驗證簽章後已自動回簽。'**
  String get p2pThePeerConfirmedTheCodeBothDevices;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法自動完成安全配對：{p1}'**
  String p2pCouldNotCompleteSecurePairingAutomatically(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'雙方已簽署確認同一份配對 transcript；正在建立 authenticated encrypted transport。'**
  String get p2pBothDevicesSignedTheSamePairingTranscript;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'對方已確認配對碼；目前設定要求本機也必須確認。'**
  String get p2pThePeerConfirmedTheCodeYourSettings;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'authenticated encrypted transport 已建立；revision summary 與 snapshot chunks 僅透過此通道交換。'**
  String get p2pAuthenticatedEncryptedTransportIsReadyRevisionSummaries;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法驗證加密通道的裝置身分或 transcript：{p1}'**
  String p2pCouldNotVerifyTheEncryptedChannelS(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法建立加密通道：{p1}'**
  String p2pCouldNotEstablishAnEncryptedChannel(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'加密 revision summary 暫時無法交換：{p1}'**
  String p2pEncryptedRevisionSummariesAreTemporarilyUnavailable(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已拒絕無效的加密 revision summary：{p1}'**
  String p2pRejectedAnInvalidEncryptedRevisionSummary(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'加密通道目前不可用：{p1}'**
  String p2pTheEncryptedChannelIsCurrentlyUnavailable(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已拒絕無效的加密 revision graph：{p1}'**
  String p2pRejectedAnInvalidEncryptedRevisionGraph(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'revision graph 傳輸暫時中斷，可重新連線續傳：{p1}'**
  String p2pRevisionGraphTransferWasInterruptedReconnectTo(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'revision graph 目前不可用：{p1}'**
  String p2pTheRevisionGraphIsCurrentlyUnavailable(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'尚未取得已驗證的對方服務端點；請等待加密 revision summary 交換完成。'**
  String get p2pNoVerifiedPeerEndpointYetWaitFor;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'目前沒有可透過已驗證連線提供給對方的 snapshot。'**
  String get p2pNoSnapshotIsCurrentlyAvailableToSend;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已透過加密通道送出同步要求；等待接收端下載並選擇儲存位置。'**
  String get p2pSyncRequestedThroughTheEncryptedChannelWaiting;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法送出同步要求：{p1}'**
  String p2pCouldNotSendASyncRequest(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'對方已透過加密通道要求同步；正在準備下載 snapshot。'**
  String get p2pThePeerRequestedSyncThroughTheEncrypted;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已拒絕身分或 project session 不一致的遠端 ACK。'**
  String get p2pRejectedARemoteAcknowledgementWithAMismatched;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已收到對方 resolve ACK；等待已驗證 revision graph 完成後確認。'**
  String get p2pReceivedThePeerSResolutionAcknowledgementWaiting;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已拒絕內容或 parent 與本機 resolve revision 不一致的遠端 ACK。'**
  String get p2pRejectedAnAcknowledgementWhoseContentOrParent;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'對方已 ACK resolve revision；雙方 revision DAG 已收斂。'**
  String get p2pThePeerAcknowledgedTheResolutionRevisionBoth;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已拒絕未包含於對方已驗證 revision graph 的遠端 ACK。'**
  String get p2pRejectedAnAcknowledgementAbsentFromThePeer;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'對方已 ACK 遠端 resolve revision；等待下載並安裝該 revision。'**
  String get p2pThePeerAcknowledgedTheRemoteResolutionRevision;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已建立十分鐘有效的配對 challenge，等待對方開始配對。'**
  String get p2pCreatedAPairingChallengeValidForTen;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法開始安全配對：{p1}'**
  String p2pCouldNotStartSecurePairing(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'本機已簽署確認；等待對方驗證後自動回簽。'**
  String get p2pThisDeviceSignedItsConfirmationWaitingFor;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'本機已簽署確認並加入信任清單；等待對方手動確認同一配對 transcript。'**
  String get p2pThisDeviceSignedAndTrustedThePeer;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'儲存信任裝置失敗：{p1}'**
  String p2pCouldNotSaveTheTrustedDevice(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已取消本次配對。'**
  String get p2pPairingCancelled;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'配對確認設定已變更；請重新開始配對。'**
  String get p2pPairingConfirmationSettingsChangedStartPairingAgain;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法載入 revision metadata：{p1}'**
  String p2pCouldNotLoadRevisionMetadata(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法建立 revision：project UUID 無效。'**
  String get p2pCouldNotCreateARevisionInvalidProject;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已儲存新 revision；正在透過加密通道即時通知對方同步。'**
  String get p2pNewRevisionSavedNotifyingThePeerThrough;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法建立 revision metadata：{p1}'**
  String p2pCouldNotCreateRevisionMetadata(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'draft revision 已建立；正在透過加密通道傳送 summary。'**
  String get p2pDraftRevisionCreatedSendingItsSummaryThrough;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'draft revision 已建立；正在透過加密通道傳送 summary/delta。'**
  String get p2pDraftRevisionCreatedSendingItsSummaryAnd;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法建立 draft revision：{p1}'**
  String p2pCouldNotCreateADraftRevision(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已拒絕無效的 revision delta，將改用完整 snapshot：{p1}'**
  String p2pRejectedAnInvalidRevisionDeltaFallingBack(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法保存遠端歷史：{p1}。'**
  String p2pCouldNotSaveRemoteHistory(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'遠端 snapshot 已開啟，但保存 revision DAG 失敗：{p1}'**
  String p2pRemoteSnapshotOpenedButItsRevisionGraph(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法暫存遠端 conflict snapshot：session 或 DAG 已失效。'**
  String get p2pCouldNotStageTheRemoteConflictSnapshot;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法暫存遠端 conflict snapshot：{p1}'**
  String p2pCouldNotStageTheRemoteConflictSnapshot2(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'偵測到多個 maximal common ancestors；必須先取得 recursive merge base，未進行猜測式合併。'**
  String get p2pMultipleMaximalCommonAncestorsFoundARecursive;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法建立欄位合併：authenticated session 或 concurrent heads 已失效。'**
  String get p2pCouldNotPrepareFieldMergingTheAuthenticated;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法建立 ProjectData 欄位合併：{p1}'**
  String p2pCouldNotPrepareProjectFieldMerging(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已建立雙 parent resolve revision；等待透過加密通道傳播。'**
  String get p2pCreatedAResolutionRevisionWithTwoParents;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法建立 resolve revision：{p1}'**
  String p2pCouldNotCreateAResolutionRevision(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已自動回應對方的安全配對要求，正在建立比較碼。'**
  String get p2pRespondedAutomaticallyToThePeerSSecure;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法自動建立本機 pairing challenge：{p1}'**
  String p2pCouldNotAutomaticallyCreateALocalPairing(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'配對 challenge 已自動更新；等待對方取得新比較碼。'**
  String get p2pPairingChallengeRefreshedAutomaticallyWaitingForThe;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法更新配對 challenge：{p1}'**
  String p2pCouldNotRefreshThePairingChallenge(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'對方已更換同步文件，連線已中斷。'**
  String get p2pThePeerChangedItsSyncDocumentDisconnected;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'本機已更換同步文件，連線已中斷。'**
  String get p2pThisDeviceChangedItsSyncDocumentDisconnected;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法初始化裝置安全身分：{p1}'**
  String p2pCouldNotInitializeTheDeviceSSecure(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法取得本機 LAN IP：{p1}'**
  String p2pCouldNotObtainALocalLANIP(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'正在開啟本機服務…'**
  String get p2pStartingLocalService;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'本機端點已開啟；完成安全配對後可交換加密 revision 與 snapshot chunks。'**
  String get p2pLocalEndpointReadySecurePairingEnablesEncrypted;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法開啟 Port {p1}：{p2}'**
  String p2pCouldNotOpenPort(String p1, String p2);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'正在停止本機服務…'**
  String get p2pStoppingLocalService;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'本機服務已停止。'**
  String get p2pLocalServiceStopped;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'停止本機服務失敗：{p1}'**
  String p2pCouldNotStopLocalService(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'正在測試 {p1}:{p2}…'**
  String p2pTesting(String p1, String p2);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'端點可達；完成安全配對後才會啟用加密內容通道。'**
  String get p2pEndpointReachableSecurePairingIsRequiredTo;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法連線至 {p1}：{p2}'**
  String p2pCouldNotConnectTo(String p1, String p2);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'正在連線並協商同步文件 {p1}:{p2}…'**
  String p2pConnectingAndNegotiatingTheSyncDocumentAt(String p1, String p2);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已選擇由本機提供同步文件。'**
  String get p2pThisDeviceWillProvideTheSyncDocument;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已選擇由對方提供同步文件。'**
  String get p2pThePeerWillProvideTheSyncDocument;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已中斷目前 peer；本機服務仍在監聽。'**
  String get p2pPeerDisconnectedTheLocalServiceIsStill;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已中斷目前 peer。'**
  String get p2pPeerDisconnected;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'目前沒有可在已驗證連線中下載的遠端 snapshot。'**
  String get p2pNoRemoteSnapshotIsAvailableForDownload;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'正在透過 authenticated encrypted transport 重建或下載並驗證 snapshot…'**
  String get p2pReconstructingOrDownloadingAndVerifyingTheSnapshot;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'snapshot 已完成 chunk、SHA-256、XML、UUID 與版本驗證；尚未寫入專案。'**
  String get p2pSnapshotChunksSHAXMLUUIDAndVersion;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'snapshot 已由加密 delta 重建，並完成 SHA-256、XML、UUID 與版本驗證；尚未寫入專案。'**
  String get p2pSnapshotReconstructedFromAnEncryptedDeltaSHA;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'snapshot 下載已取消。'**
  String get p2pSnapshotDownloadCancelled;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'snapshot 下載或驗證失敗：{p1}'**
  String p2pSnapshotDownloadOrVerificationFailed(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'雙方 revisions concurrent；必須完成逐欄 conflict resolution，不能直接覆寫本機文件。'**
  String get p2pRevisionsDivergedResolveConflictsFieldByField;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已驗證 snapshot 已失效；請重新建立安全連線後下載。'**
  String get p2pTheVerifiedSnapshotIsNoLongerValid;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'尚未取得包含此 snapshot 的已驗證 revision graph；未寫入專案。'**
  String get p2pNoVerifiedRevisionGraphContainingThisSnapshot;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'authenticated snapshot session capability 不存在；未寫入專案。'**
  String get p2pAuthenticatedSnapshotSessionCapabilityIsMissingThe;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'等待確認儲存位置並安全開啟 snapshot…'**
  String get p2pWaitingToConfirmTheSaveLocationAnd;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'同步 session 已變更；已停止將 snapshot 套用至編輯器。'**
  String get p2pTheSyncSessionChangedSnapshotApplicationTo;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'snapshot 已另存並開啟，但遠端 revision 歷史尚未保存；請勿繼續編輯並重試同步。'**
  String get p2pSnapshotSavedAndOpenedButRemoteRevision;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'遠端 snapshot 已另存並開啟。'**
  String get p2pRemoteSnapshotSavedAndOpened;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'已取消套用；驗證結果仍保留在記憶體中。'**
  String get p2pApplicationCancelledVerificationResultsRemainInMemory;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'無法儲存或開啟 snapshot：{p1}'**
  String p2pCouldNotSaveOrOpenTheSnapshot(String p1);

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'concurrent snapshot 已完成逐欄合併並建立 resolve revision。'**
  String get p2pConcurrentSnapshotsMergedFieldByFieldAnd;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'snapshot 傳輸已取消。'**
  String get p2pSnapshotTransferCancelled;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'連線、文件或 revision 已變更；舊 snapshot 已失效。'**
  String get p2pConnectionDocumentOrRevisionChangedThePrevious;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'雙方 UUID 相同，已選定同一份同步文件。'**
  String get p2pBothUUIDsMatchTheSameSyncDocument;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'對方沒有目標文件，將由本機提供文件。'**
  String get p2pThePeerHasNoTargetDocumentThis;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'本機沒有目標文件，將由對方提供文件。'**
  String get p2pThisDeviceHasNoTargetDocumentThe;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'雙方都沒有可同步文件，需要先決定文件。'**
  String get p2pNeitherDeviceHasASyncDocumentChoose;

  /// P2P presentation state. Parameters captured at event time; locale resolved at display time.
  ///
  /// In zh, this message translates to:
  /// **'雙方文件 UUID 不同，需要選擇同步文件。'**
  String get p2pTheDocumentUUIDsDifferChooseWhichDocument;

  /// Accessible description of a palette color, resolved at the UI boundary.
  ///
  /// In zh, this message translates to:
  /// **'灰階，明度 {value}%'**
  String paletteGraySemantics(String value);

  /// Accessible description of a palette color, resolved at the UI boundary.
  ///
  /// In zh, this message translates to:
  /// **'色相 {hue} 度，飽和度 {saturation}%，明度 {value}%'**
  String paletteColorSemantics(String hue, String saturation, String value);

  /// Default name for a new local revision checkpoint; saved as a name at creation.
  ///
  /// In zh, this message translates to:
  /// **'檢查點 {timestamp}'**
  String revisionCheckpointLabel(String timestamp);

  /// Localized project file or export failure: AccessDenied
  ///
  /// In zh, this message translates to:
  /// **'無法存取檔案。請重新選取原檔案以恢復授權，或使用「另存新檔」保留變更。'**
  String get projectErrorAccessDenied;

  /// Localized project file or export failure: FileMissing
  ///
  /// In zh, this message translates to:
  /// **'找不到檔案。請確認檔案是否已移動或刪除。'**
  String get projectErrorFileMissing;

  /// Localized project file or export failure: InvalidPath
  ///
  /// In zh, this message translates to:
  /// **'檔案路徑無效，請重新選取檔案或儲存位置。'**
  String get projectErrorInvalidPath;

  /// Localized project file or export failure: InvalidData
  ///
  /// In zh, this message translates to:
  /// **'專案資料格式無效，請檢查檔案或從備份還原。'**
  String get projectErrorInvalidData;

  /// Localized project file or export failure: Cancelled
  ///
  /// In zh, this message translates to:
  /// **'已取消檔案操作，尚未儲存變更。'**
  String get projectErrorCancelled;

  /// Localized project file or export failure: NoSaveLocation
  ///
  /// In zh, this message translates to:
  /// **'專案尚未指定儲存位置，請先儲存或另存新檔。'**
  String get projectErrorNoSaveLocation;

  /// Localized project file or export failure: NoSpace
  ///
  /// In zh, this message translates to:
  /// **'儲存空間不足，請釋放空間或選擇其他儲存位置。'**
  String get projectErrorNoSpace;

  /// Localized project file or export failure: BackupLimit
  ///
  /// In zh, this message translates to:
  /// **'專案超過備份容量上限，請到設定提高上限。'**
  String get projectErrorBackupLimit;

  /// Localized project file or export failure: Unsupported
  ///
  /// In zh, this message translates to:
  /// **'此平台不支援這項檔案操作。'**
  String get projectErrorUnsupported;

  /// Localized project file or export failure: DuplicateIdentity
  ///
  /// In zh, this message translates to:
  /// **'資料包含空白或重複的識別碼，請重新開啟專案以修復章節樹。'**
  String get projectErrorDuplicateIdentity;

  /// Localized project file or export failure: TreeTooDeep
  ///
  /// In zh, this message translates to:
  /// **'樹狀結構超過 256 層，請減少巢狀深度後重試。'**
  String get projectErrorTreeTooDeep;

  /// Localized project file or export failure: ExportFormat
  ///
  /// In zh, this message translates to:
  /// **'匯出用途、格式或範圍不相容，或此格式尚未支援。'**
  String get projectErrorExportFormat;

  /// Localized project file or export failure: ExportSelection
  ///
  /// In zh, this message translates to:
  /// **'匯出選取範圍無效，請重新選取至少一個項目。'**
  String get projectErrorExportSelection;

  /// Localized project file or export failure: ExportEmpty
  ///
  /// In zh, this message translates to:
  /// **'所選範圍沒有可匯出的內容，請重新選取。'**
  String get projectErrorExportEmpty;

  /// Localized project file or export failure: MissingItemDefinition
  ///
  /// In zh, this message translates to:
  /// **'物品缺少定義，請修復物品資料後再匯出。'**
  String get projectErrorMissingItemDefinition;

  /// Localized project file or export failure: ProjectChanged
  ///
  /// In zh, this message translates to:
  /// **'來源專案已切換，請重新開啟匯出視窗。'**
  String get projectErrorProjectChanged;

  /// Localized project file or export failure: Unknown
  ///
  /// In zh, this message translates to:
  /// **'操作未完成。變更仍保留在編輯器中，請重試或另存新檔。'**
  String get projectErrorUnknown;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'模型服務不接受此請求的格式或參數，請檢查設定。'**
  String get copilotErrorInvalidConfiguration;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'API Key 無效或已失效，請檢查憑證設定。'**
  String get copilotErrorAuthenticationFailed;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'模型服務拒絕此憑證或模型的存取權限。'**
  String get copilotErrorPermissionDenied;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'模型服務目前請求過多或額度不足，請稍後重試。'**
  String get copilotErrorRateLimited;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'找不到指定模型或 API endpoint，請重新選擇模型。'**
  String get copilotErrorModelUnavailable;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'傳送內容超過模型服務限制，請縮小上下文範圍。'**
  String get copilotErrorContextTooLarge;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'模型回覆超過允許的大小上限。'**
  String get copilotErrorResponseTooLarge;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'Copilot 請求逾時，請稍後重試。'**
  String get copilotErrorRequestTimedOut;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'模型回覆格式無法解析，請重試或更換模型。'**
  String get copilotErrorInvalidResponse;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'Copilot 請求失敗，請檢查網路、API URL、模型與憑證設定。'**
  String get copilotErrorNetworkUnavailable;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'模型服務暫時無法使用，請稍後重試。'**
  String get copilotErrorServiceUnavailable;

  /// Localized Copilot failure
  ///
  /// In zh, this message translates to:
  /// **'請確認目前章節、所選資源及 API URL 設定後重試。'**
  String get copilotErrorValidation;

  /// Label for implicit mentions in manuscript annotations.
  ///
  /// In zh, this message translates to:
  /// **'隱式提及'**
  String get uiImplicitMention;

  /// Palette continuous color search interface
  ///
  /// In zh, this message translates to:
  /// **'搜尋範圍'**
  String get paletteSearchRange;

  /// Palette continuous color search interface
  ///
  /// In zh, this message translates to:
  /// **'較精確'**
  String get paletteRangePrecise;

  /// Palette continuous color search interface
  ///
  /// In zh, this message translates to:
  /// **'適中'**
  String get paletteRangeDefault;

  /// Palette continuous color search interface
  ///
  /// In zh, this message translates to:
  /// **'較寬鬆'**
  String get paletteRangeBroad;

  /// Palette continuous color search interface
  ///
  /// In zh, this message translates to:
  /// **'範圍內沒有相近詞條'**
  String get paletteNoNearbyEntries;

  /// Palette continuous color search interface
  ///
  /// In zh, this message translates to:
  /// **'最近的詞條（超出範圍）'**
  String get paletteOutsideRange;

  /// Palette continuous color search interface
  ///
  /// In zh, this message translates to:
  /// **'請輸入六位 HEX 色碼'**
  String get paletteInvalidHex;
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
