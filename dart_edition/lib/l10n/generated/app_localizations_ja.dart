// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Monogatari Assistant';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsDescription => '執筆環境を自分に合わせて調整';

  @override
  String get generalSettingsTitle => '一般設定';

  @override
  String get generalSettingsDescription => '終了時の確認と言語';

  @override
  String get exitWarningTitle => '終了前に確認';

  @override
  String get exitWarningDescription => '終了前に未保存の変更を保存するか確認する';

  @override
  String get languageTitle => '表示言語';

  @override
  String get languageSystem => 'システムに従う';

  @override
  String get languageHelp => 'すぐに適用され、自動保存されます。一部の機能は引き続き繁体字中国語で表示されます。';

  @override
  String get languageSaveFailed =>
      '言語設定を保存できませんでした。最後に保存した設定に戻しました。もう一度お試しください。';

  @override
  String initializationFailed(String error) {
    return '初期化に失敗しました：$error';
  }

  @override
  String get oobeStepWelcome => 'ようこそ';

  @override
  String get oobeStepAppearance => '表示設定';

  @override
  String get oobeStepStorage => '保存とバックアップ';

  @override
  String get oobeStepName => '名前の設定';

  @override
  String get oobeStepWorkspace => 'はじめに';

  @override
  String get oobeStepComplete => '設定完了！';

  @override
  String get oobeTitleWelcome => 'ヤッホー！MonoAshi へようこそ';

  @override
  String get oobeTitleAppearance => 'テーマと操作の設定';

  @override
  String get oobeTitleStorage => 'ファイルと自動バックアップ';

  @override
  String get oobeTitleName => '名前の設定';

  @override
  String get oobeTitleWorkspace => '最初の物語を始めましょう';

  @override
  String get oobeTitleComplete => 'ありがとうございます！';

  @override
  String get oobeWelcomeThanks => 'MonoAshi をお選びいただきありがとうございます。';

  @override
  String get oobeWelcomeTime => 'アプリの設定には数分かかります。';

  @override
  String get oobeWelcomeDescription => 'これから画面の表示や保存方法を設定し、執筆ワークスペースをご紹介します。';

  @override
  String get oobeNext => '次へ  ›';

  @override
  String get oobeBack => '戻る';

  @override
  String get oobeSkip => 'スキップ';

  @override
  String get oobeStart => '執筆を始める';

  @override
  String get oobeContinueHint => '続けるには「次へ」を選択してください。';

  @override
  String get oobeCompleteHint => '設定が完了しました！';

  @override
  String get oobeSaveFailed => '設定を保存できませんでした。もう一度お試しください。';

  @override
  String oobeProgressSemantics(int step, String title) {
    return 'ステップ $step、$title';
  }
}
