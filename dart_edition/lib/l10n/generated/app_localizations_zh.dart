// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '物語 Assistant';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsDescription => '調整適合自己的寫作環境';

  @override
  String get generalSettingsTitle => '一般設定';

  @override
  String get generalSettingsDescription => '退出提示與語言';

  @override
  String get exitWarningTitle => '退出時提示';

  @override
  String get exitWarningDescription => '關閉應用前提示儲存未儲存的變更';

  @override
  String get languageTitle => '顯示語言';

  @override
  String get languageSystem => '跟隨系統';

  @override
  String get languageHelp => '立即套用並自動儲存。部分功能仍顯示繁體中文。';

  @override
  String get languageSaveFailed => '無法儲存語言設定，已恢復原選擇。請再試一次。';

  @override
  String initializationFailed(String error) {
    return '初始化失敗：$error';
  }

  @override
  String get oobeStepWelcome => '歡迎';

  @override
  String get oobeStepAppearance => '介面偏好';

  @override
  String get oobeStepStorage => '儲存與備份';

  @override
  String get oobeStepName => '名稱設定';

  @override
  String get oobeStepWorkspace => '開始使用';

  @override
  String get oobeStepComplete => '完成！';

  @override
  String get oobeTitleWelcome => 'ヤッホー！歡迎使用 MonoAshi';

  @override
  String get oobeTitleAppearance => '主題與操作偏好';

  @override
  String get oobeTitleStorage => '檔案與自動備份';

  @override
  String get oobeTitleName => '名稱設定';

  @override
  String get oobeTitleWorkspace => '從第一個故事開始';

  @override
  String get oobeTitleComplete => '謝謝您！';

  @override
  String get oobeWelcomeThanks => '感謝您選擇 MonoAshi。';

  @override
  String get oobeWelcomeTime => '我們需要數分鐘時間設定您的程式。';

  @override
  String get oobeWelcomeDescription => '接下來的幾個步驟，將協助您調整介面、選擇儲存偏好，並認識創作工作區。';

  @override
  String get oobeNext => '下一步  ›';

  @override
  String get oobeBack => '上一步';

  @override
  String get oobeSkip => '略過';

  @override
  String get oobeStart => '開始創作';

  @override
  String get oobeContinueHint => '如果要繼續，請按「下一步」。';

  @override
  String get oobeCompleteHint => '設定完成！';

  @override
  String get oobeSaveFailed => '設定尚未儲存完成。請再試一次。';

  @override
  String oobeProgressSemantics(int step, String title) {
    return '步驟 $step，$title';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');
}
