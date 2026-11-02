// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '物語アシスタント';

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
  String get languageHelp => '変更はすぐに適用され、自動保存されます。プロジェクトの内容は元の言語を保持します。';

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
  String get oobeTitleWelcome => 'ヤッホー！ものアシへようこそ';

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
  String get oobeWelcomeThanks => 'ものアシをお選びいただきありがとうございます。';

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

  @override
  String get uiSaveFile => 'ファイルを保存';

  @override
  String get uiNewFile => '新規ファイル';

  @override
  String get uiOpenFile => 'ファイルを開く';

  @override
  String get uiSaveAs => '名前を付けて保存';

  @override
  String get uiImport => 'インポート';

  @override
  String get uiExport => 'エクスポート';

  @override
  String get editorSelectAll => 'すべて選択';

  @override
  String get editorCut => '切り取り';

  @override
  String get commonCopy => 'コピー';

  @override
  String get editorPaste => '貼り付け';

  @override
  String get editorUndo => '元に戻す';

  @override
  String get editorRedo => 'やり直す';

  @override
  String get uiPhraseLibrary => 'フレーズ集';

  @override
  String get uiInsertPhrase => 'フレーズを挿入';

  @override
  String get uiOpenTheManuscriptEditorFirst => '先に本文編集を開いてください。';

  @override
  String get uiSaveSelectionAsPhrase => '選択範囲をフレーズとして保存';

  @override
  String get uiPunctuation => '句読点・記号';

  @override
  String get uiSearch => '検索';

  @override
  String get uiNavigation => 'ナビゲーション';

  @override
  String get uiSidebar => 'サイドバー';

  @override
  String get uiDashboard => 'ダッシュボード';

  @override
  String get uiMatchCase => '大文字・小文字を区別';

  @override
  String get uiWholeWords => '単語単位で検索';

  @override
  String get uiRegularExpression => '正規表現';

  @override
  String get uiMatchCharacterWidth => '全角・半角を区別';

  @override
  String get uiIgnorePunctuation => '句読点を無視';

  @override
  String get uiIgnoreWhitespace => '空白を無視';

  @override
  String get uiRegularExpressionsAlwaysMatchCaseAndCharacterWidth =>
      '正規表現では大文字・小文字と全角・半角を区別し、単語単位の検索は無効になります。';

  @override
  String get uiWholeWordMatchingIsUnavailableWhenTheQuery =>
      '検索語に全角文字、句読点、空白が含まれる場合、単語単位では検索できません。';

  @override
  String uiCouldNotCompletePleaseTryAgain(String p1) {
    return '「$p1」を完了できませんでした。もう一度お試しください。';
  }

  @override
  String get uiFile => 'ファイル';

  @override
  String get uiProject => 'プロジェクト';

  @override
  String get uiDataExchange => 'データ交換';

  @override
  String get uiHome => 'ホーム';

  @override
  String get uiClipboard => 'クリップボード';

  @override
  String get uiHistory => '履歴';

  @override
  String get uiWritingTools => '執筆ツール';

  @override
  String get uiPhrases => 'フレーズ';

  @override
  String get uiWorkspacePanels => '表示パネル';

  @override
  String get uiFindAndReplace => '検索と置換';

  @override
  String get uiMatchOptions => '一致条件';

  @override
  String get uiSearchMethod => '検索方法';

  @override
  String get uiOn => 'オン';

  @override
  String get uiOff => 'オフ';

  @override
  String get uiToolbarMode => 'ツールバーモード';

  @override
  String get uiAutomaticFullOnDesktopModerateOnMobile =>
      '自動（デスクトップは Full、モバイルは Moderate）';

  @override
  String get uiHelp => 'ヘルプ';

  @override
  String get uiHelpHome => 'ヘルプのホーム';

  @override
  String get uiHelpForThisFeatureF1 => '現在の機能のヘルプ（F1）';

  @override
  String get uiWhatSThisShiftF1 => 'これは何ですか？（Shift+F1）';

  @override
  String get uiEnterAlternativeDisplayTextNotAddedAsAn =>
      '別の表示テキストを入力（別名には追加しません）';

  @override
  String get uiInsert => '挿入';

  @override
  String get uiDisplayText => '表示テキスト';

  @override
  String get uiAddAlias => '別名を追加';

  @override
  String get uiCharacter => 'キャラクター';

  @override
  String get uiLocation => '場所';

  @override
  String get uiEvent => '出来事';

  @override
  String get uiForeshadowing => '伏線';

  @override
  String get uiPlan => '計画';

  @override
  String get uiItem => 'アイテム';

  @override
  String get uiKeyPoint => '要点';

  @override
  String uiAdd(String p1) {
    return '$p1を追加';
  }

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get uiTheManuscriptHasChangedSelectThePhraseAgain =>
      '本文が変更されました。フレーズを選択し直してください。';

  @override
  String uiCouldNotInsertThePhrase(String p1) {
    return 'フレーズを挿入できませんでした：$p1';
  }

  @override
  String uiRelink(String p1) {
    return '「$p1」の参照先を再設定';
  }

  @override
  String get uiSearchTargets => '参照先を検索';

  @override
  String get uiCancelInsertion => '挿入をキャンセル';

  @override
  String get uiConvertToPlainText => 'プレーンテキストに変換';

  @override
  String get uiSelectManuscriptTextToSaveAsAPhrase =>
      '先にフレーズとして保存する本文を選択してください。';

  @override
  String get uiNoPhrasesAreAvailableAddAPhraseIn =>
      '挿入できるフレーズがありません。先にフレーズ集へ追加してください。';

  @override
  String get uiMissingTarget => '参照先が見つかりません';

  @override
  String uiOriginalNameNotes(String p1, String p2) {
    return '元の名前：$p1\nメモ：$p2';
  }

  @override
  String get uiNone => 'なし';

  @override
  String get uiAddMention => 'Mention を追加';

  @override
  String get uiSaveAsPhrase => 'フレーズとして保存';

  @override
  String get uiDonTAskAgain => '今後確認しない';

  @override
  String get uiDonTSave => '保存しない';

  @override
  String get commonSave => '保存';

  @override
  String get uiUnsavedChanges => '未保存の変更';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeExiting =>
      '未保存の変更があります。終了前に保存しますか？';

  @override
  String get uiVersionCompatibilityWarning => 'バージョン互換性の警告';

  @override
  String uiThisFileSVersionIsNewerThanThe(String p1, String p2) {
    return 'このファイルのバージョン（$p1）は対応バージョン（$p2）より新しいものです。\n開いて保存すると、一部のデータが失われるおそれがあります。\n\nそれでも開きますか？';
  }

  @override
  String get uiOpenAnyway => 'それでも開く';

  @override
  String get uiCreateProject => '新規プロジェクトを作成';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeCreatingA =>
      '未保存の変更があります。新規プロジェクトの作成前に保存しますか？';

  @override
  String get uiProjectCreated => 'プロジェクトを作成しました。';

  @override
  String uiCouldNotCreateTheProject(String p1) {
    return 'プロジェクトを作成できませんでした：$p1';
  }

  @override
  String get uiOpenProject => 'プロジェクトを開く';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeOpeningAnother =>
      '未保存の変更があります。別のプロジェクトを開く前に保存しますか？';

  @override
  String get uiOpeningTheNewerFileWasCancelled =>
      '新しいバージョンのファイルを開く操作をキャンセルしました。';

  @override
  String uiProjectOpened(String p1) {
    return 'プロジェクトを開きました：$p1';
  }

  @override
  String uiCouldNotOpenTheProject(String p1) {
    return 'プロジェクトを開けませんでした：$p1';
  }

  @override
  String get uiOpenRecentProject => '最近のプロジェクトを開く';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeOpeningA =>
      '未保存の変更があります。最近のプロジェクトを開く前に保存しますか？';

  @override
  String uiCouldNotOpenTheRecentProject(String p1) {
    return '最近のプロジェクトを開けませんでした：$p1';
  }

  @override
  String get uiProjectSaved => 'プロジェクトを保存しました。';

  @override
  String uiCouldNotSaveTheProject(String p1) {
    return 'プロジェクトを保存できませんでした：$p1';
  }

  @override
  String uiProjectSavedAs(String p1) {
    return '別名で保存しました：$p1';
  }

  @override
  String uiCouldNotSaveTheProjectAsANew(String p1) {
    return 'プロジェクトを別名で保存できませんでした：$p1';
  }

  @override
  String uiInvalidRegularExpression(String p1) {
    return '正規表現が無効です：$p1';
  }

  @override
  String uiReplaceAllFailed(String p1) {
    return 'すべて置換に失敗しました：$p1';
  }

  @override
  String get uiInvalidFormat => '形式が無効です';

  @override
  String uiInvalidRegularExpression2(String p1) {
    return '正規表現が無効です：$p1';
  }

  @override
  String uiReplaceAllCancelledMoreThanMatchesNarrowYour(String p1) {
    return 'すべて置換を中止しました。一致件数が $p1 件を超えています。検索範囲を絞ってください。';
  }

  @override
  String get uiReplaceAllCancelledTheResultingTextIsToo =>
      'すべて置換を中止しました。結果のテキストが大きすぎます。範囲を分けて処理してください。';

  @override
  String get uiReplaceAllCancelledTheTimeLimitWasExceeded =>
      'すべて置換を中止しました。処理時間の上限を超えました。検索範囲を絞ってください。';

  @override
  String get uiConfirmLargeReplacement => '大量置換の確認';

  @override
  String uiMatchesToReplaceEstimatedResultMiBContinue(String p1, String p2) {
    return '置換箇所：$p1。結果の推定サイズ：$p2 MiB。続行しますか？';
  }

  @override
  String get uiContinueReplacing => '置換を続行';

  @override
  String get uiReplaceAllCancelledAnnotationRangesCouldNotBe =>
      'すべて置換を中止しました。マークの範囲を安全に対応付けできませんでした。';

  @override
  String get uiReplaceAllCancelledRegularExpressionAnnotationRangesCould =>
      'すべて置換を中止しました。正規表現とマークの範囲を安全に対応付けできませんでした。';

  @override
  String get uiReplaceAllCancelledAnnotationProjectionValidationFailed =>
      'すべて置換を中止しました。マークの表示変換を検証できませんでした。';

  @override
  String get uiSearch2 => '検索…';

  @override
  String get uiPrevious => '前へ';

  @override
  String get uiNext => '次へ';

  @override
  String get uiCollapse => '折りたたむ';

  @override
  String get uiExpandReplace => '置換欄を表示';

  @override
  String get uiSearchOptions => '検索オプション';

  @override
  String get uiReplaceWith => '置換後の文字列…';

  @override
  String get uiReplace => '置換';

  @override
  String get uiAll => 'すべて';

  @override
  String get uiFind => '検索する文字列：';

  @override
  String get uiCollapse2 => '折りたたむ';

  @override
  String get uiReplaceWith2 => '置換後の文字列：';

  @override
  String get uiReplaceAll => 'すべて置換';

  @override
  String get uiFullWidth => '全角';

  @override
  String get uiHalfWidth => '半角';

  @override
  String get uiFeatures => '機能';

  @override
  String get uiEditor => 'エディター';

  @override
  String get uiFull => '全角';

  @override
  String get uiHalf => '半角';

  @override
  String get uiExpandNavigation => 'ナビゲーションを展開';

  @override
  String get uiCloseNavigation => 'ナビゲーションを閉じる';

  @override
  String get uiHelpModule => 'ヘルプ';

  @override
  String get uiCollapseNavigation => 'ナビゲーションを折りたたむ';

  @override
  String get uiPinNavigation => 'ナビゲーションを固定';

  @override
  String get uiOvertypeModeIns => '上書きモード（Ins）';

  @override
  String get uiInsertModeIns => '挿入モード（Ins）';

  @override
  String uiCharacters(String p1, String p2) {
    return '$p1 / $p2 文字';
  }

  @override
  String get uiIndentLineStart => '行頭を字下げ';

  @override
  String get uiInsertSpacesWithTab => 'Tab で空白を挿入';

  @override
  String uiEnterFirst(String p1) {
    return '先に$p1を入力してください。';
  }

  @override
  String get uiCannotAddRightNow => '現在は追加できません';

  @override
  String get uiConvertToItemLink => '正式なアイテム関連に変換';

  @override
  String get uiQuillPlainTextManuscriptPreview => 'Quill プレーンテキスト本文プレビュー';

  @override
  String uiAnnotation(String p1, String p2) {
    return '$p1のマーク：$p2';
  }

  @override
  String uiSCursor(String p1) {
    return '$p1 のカーソル';
  }

  @override
  String get uiSelectAControlToViewHelpEscCancels =>
      '項目を選んでヘルプを表示します。Esc でキャンセル';

  @override
  String get uiHelpCenter => 'ヘルプセンター';

  @override
  String get uiCloseHelpEsc => 'ヘルプを閉じる（Esc）';

  @override
  String get uiPreviousPage => '前のページ';

  @override
  String get uiNextPage => '次のページ';

  @override
  String get uiReadArticle => '記事を読む';

  @override
  String get uiContentsAndSearch => '目次と検索';

  @override
  String get uiSearchHelp => 'ヘルプを検索';

  @override
  String get uiCouldNotLoadOfflineHelpPleaseTryAgain =>
      'オフラインヘルプを読み込めませんでした。もう一度お試しください。';

  @override
  String get commonRetry => '再試行';

  @override
  String get uiNoMatchingHelpTopics => '一致するヘルプがありません';

  @override
  String get uiBackToContents => '目次へ戻る';

  @override
  String get uiRelatedTopics => '関連するヘルプ';

  @override
  String get uiInvalidAnnotationSyntaxCorrectItBeforeApplying =>
      'マークの構文が無効です。修正してから適用してください。';

  @override
  String get commonClose => '閉じる';

  @override
  String get uiNotes => 'メモ';

  @override
  String get uiType => '種類';

  @override
  String get uiTarget => '対象';

  @override
  String get uiStatus => '状態';

  @override
  String get uiColor => '色';

  @override
  String get uiOpenNode => '対象の項目を開く';

  @override
  String get uiEditAnnotation => 'マークを編集';

  @override
  String get uiApply => '適用';

  @override
  String get uiMoreAnnotationActions => 'マークのその他の操作';

  @override
  String get uiUpdateToCurrentName => '現在の名前に更新';

  @override
  String get uiRelinkMissingTarget => '失われた参照先を再設定';

  @override
  String get uiRemoveAnnotationKeepText => '文字を残してマークを削除';

  @override
  String get uiHighlight => 'ハイライト';

  @override
  String get uiFullSyntax => '完全な構文';

  @override
  String get uiCopySyntax => '構文をコピー';

  @override
  String get uiGeneral => '一般';

  @override
  String get uiStart => '開始';

  @override
  String get uiEnd => '終了';

  @override
  String get uiThisAnnotationTypeRequiresAUUID => 'このマークの種類には UUID が必要です。';

  @override
  String uiInvalidAnnotationData(String p1) {
    return 'マークのデータが無効です：$p1';
  }

  @override
  String get uiBackgroundColorCode => '背景色コード';

  @override
  String get uiTextColorCode => '文字色コード';

  @override
  String get uiNotesOptional => 'メモ（省略可）';

  @override
  String get uiEditingThisFieldAppliesTheFullSyntaxIn =>
      'この欄を直接編集すると、他の欄より完全な構文が優先されます。';

  @override
  String get uiAutomatic => '0（自動）';

  @override
  String get uiSearchNamePathOrUUID => '名前、パス、UUID で検索';

  @override
  String get uiNoMatchingLinkTargets => '一致する参照先がありません';

  @override
  String get uiUntitled => '（無題）';

  @override
  String uiShowingTheFirstResultsEnterKeywordsToNarrow(String p1) {
    return '先頭の $p1 件を表示しています。キーワードで絞り込んでください。';
  }

  @override
  String get uiCouldNotReadInitialSetupPleaseTryAgain =>
      '初期設定を読み込めませんでした。もう一度お試しください。';

  @override
  String get uiCouldNotReadTheBackupLocationSelectTo =>
      'バックアップ先を読み込めませんでした。選択して再試行してください。';

  @override
  String get uiChooseAutomaticBackupFolder => '自動バックアップ先を選択';

  @override
  String get uiCouldNotSelectAFolderPleaseTryAgain =>
      'フォルダーを選択できませんでした。もう一度お試しください。';

  @override
  String get uiChooseHowYouPreferToReadAndWork =>
      '読みやすく使いやすい表示を選びましょう。これらの設定は後から変更できます。';

  @override
  String get uiInterfaceTheme => '画面のテーマ';

  @override
  String uiUseTheTheme(String p1) {
    return '$p1テーマを使用';
  }

  @override
  String get uiSideNavigation => 'サイドナビゲーション';

  @override
  String get uiYourWorkIsSavedAsAMnprojProject =>
      '作品は選択した場所に .mnproj プロジェクトファイルとして保存されます。執筆スタイルに合わせて次の機能を設定してください。';

  @override
  String get uiAutoSave => '自動保存';

  @override
  String uiSaveToTheCurrentProjectFileEveryMinutes(String p1) {
    return '$p1 分ごとに現在のプロジェクトファイルへ保存します。先に一度手動保存して保存先を指定してください。';
  }

  @override
  String get uiSaveInterval => '保存間隔';

  @override
  String uiMinutes(String p1) {
    return '$p1 分';
  }

  @override
  String get uiAutomaticBackup => '自動バックアップ';

  @override
  String uiCreateASeparateBackupEveryMinutesWithoutChanging(String p1) {
    return 'プロジェクトの保存先を変えず、$p1 分ごとにバックアップを作成します。バックアップは設定で管理できます。';
  }

  @override
  String get uiBackupInterval => 'バックアップ間隔';

  @override
  String get uiManageTheAutomaticBackupFolderInSettingsOn =>
      'このプラットフォームの自動バックアップ先は設定で管理できます。';

  @override
  String get uiThisAppWorksOfflineRememberToSaveNew =>
      'このアプリはオフラインで使用できます。新規プロジェクトは「保存」で保存してください。';

  @override
  String get uiYourNameAppearsInTheWelcomeMessageOn =>
      'ホームのあいさつに表示する名前を入力してください。この手順はスキップすることもできます。';

  @override
  String get uiNameOptional => '名前（省略可）';

  @override
  String get uiEnterYourNameOrPenName => '名前またはペンネームを入力';

  @override
  String get uiExampleAzusaNakano => '例：中野梓';

  @override
  String get uiUseAsDefaultPenName => '既定のペンネームにする';

  @override
  String get uiFillInTheAuthorAutomaticallyWhenCreatingA =>
      '新規プロジェクトの作者欄に自動入力します。';

  @override
  String get uiFromTheWorkspaceHomePageCreateAProject =>
      'ワークスペースのホームで、新規プロジェクトを作成するか既存の .mnproj ファイルを開けます。';

  @override
  String get uiCreateYourWork => '01  作品を作成';

  @override
  String get uiCreateAProjectAndEnterItsTitleAnd =>
      'プロジェクトを作成し、作品名と物語の基本情報を入力します。';

  @override
  String get uiWriteYourFirstChapter => '02  最初の章を執筆';

  @override
  String get uiAddFoldersAndChaptersInChaptersThenSelect =>
      '章節一覧でフォルダーと章を追加し、章を選択して本文を書き始めます。';

  @override
  String get uiBuildYourStoryWorld => '03  物語の設定を構築';

  @override
  String get uiOrganizeYourStoryWithOutlinesCharactersWorldbuildingAnd =>
      'アウトライン、キャラクター、世界観、タイムラインで物語を整理しましょう。困ったときはヘルプからガイドを開けます。';

  @override
  String get uiYouReReadyToBeginHereIsA => 'これで使い始められます！設定内容をご確認ください。';

  @override
  String uiName(String p1) {
    return '名前：$p1';
  }

  @override
  String get uiNotSet => '未設定';

  @override
  String uiDefaultPenName(String p1) {
    return '既定のペンネーム：$p1';
  }

  @override
  String get uiYes => 'はい';

  @override
  String get uiNo => 'いいえ';

  @override
  String uiTheme(String p1) {
    return 'テーマ：$p1';
  }

  @override
  String uiThemeColor(String p1) {
    return 'テーマの色：$p1';
  }

  @override
  String uiTextSize(String p1) {
    return '文字サイズ：$p1';
  }

  @override
  String uiNavigation2(String p1) {
    return 'ナビゲーション：$p1';
  }

  @override
  String uiRibbonMode(String p1) {
    return 'リボンモード：$p1';
  }

  @override
  String uiAutomatic2(String p1) {
    return '自動（$p1）';
  }

  @override
  String uiAutoSave2(String p1) {
    return '自動保存：$p1';
  }

  @override
  String uiEveryMinutes(String p1) {
    return '$p1 分ごと';
  }

  @override
  String uiAutomaticBackup2(String p1) {
    return '自動バックアップ：$p1';
  }

  @override
  String uiAutomaticBackupFolder(String p1) {
    return '自動バックアップ先：$p1';
  }

  @override
  String get uiUseDefaultBackupFolder => '既定のバックアップ先を使用';

  @override
  String get uiChangeAppearanceAndStorageOptionsInSettingsReopen =>
      '表示と保存方法は設定で変更できます。名前の変更は初期設定を開き直してください。';

  @override
  String get uiRibbonMode2 => 'リボンモード';

  @override
  String get uiAutomatic3 => '自動';

  @override
  String get uiChooseByDeviceFullOnDesktopModerateOn =>
      '端末に合わせて選択：デスクトップは Full、モバイルは Moderate。';

  @override
  String uiAutomaticallyUsing(String p1, String p2) {
    return '自動で $p1 を使用：$p2';
  }

  @override
  String get uiThemeColor2 => 'テーマの色';

  @override
  String uiTextSizeSp(String p1) {
    return '文字サイズ  ${p1}sp';
  }

  @override
  String get uiAutomaticBackupFolder2 => '自動バックアップ先';

  @override
  String get uiChooseFolder => 'フォルダーを選択';

  @override
  String get uiResetToDefault => '既定に戻す';

  @override
  String get uiMonogatariAssistant => '物語アシスタント';

  @override
  String get uiDeletePhrase => 'フレーズを削除しますか？';

  @override
  String uiRemoveShortcutFromThePhraseLibrary(String p1) {
    return '短縮コード「$p1」をフレーズ集から削除します。';
  }

  @override
  String get commonDelete => '削除';

  @override
  String get uiPhraseLibraryExported => 'フレーズ集をエクスポートしました。';

  @override
  String uiShortcutConflicts(String p1) {
    return '短縮コード「$p1」が競合しています';
  }

  @override
  String uiTheImportedPhraseHasTheSameIDOr(String p1, String p2) {
    return 'インポートするフレーズの ID または短縮コードが既存のフレーズと重複しています：\n$p1\n\n既存の項目を残す、上書きする、または「$p2」としてコピーを保存できます。';
  }

  @override
  String get uiAllProjects => 'すべてのプロジェクト';

  @override
  String get uiCurrentProject => '現在のプロジェクト';

  @override
  String get uiCancelImport => 'インポートをキャンセル';

  @override
  String get uiKeepExisting => '既存の項目を残す';

  @override
  String get uiSaveACopy => 'コピーを保存';

  @override
  String get uiOverwrite => '上書き';

  @override
  String uiImportedExistingPhrasesKept(String p1, String p2, String p3) {
    return 'インポート：$p1 件。保持した既存のフレーズ：$p2 件。$p3';
  }

  @override
  String get uiPhrasesWithMentionsAreLimitedToThisProject =>
      'Mention を含むフレーズは現在のプロジェクト専用です。挿入前に参照先を再設定してください。';

  @override
  String get uiAddPhrase => 'フレーズを追加';

  @override
  String uiCouldNotLoadTheGlobalPhraseLibrary(String p1) {
    return '共通フレーズ集を読み込めませんでした：$p1';
  }

  @override
  String get uiSearchContentShortcutsOrTags => '内容、短縮コード、タグで検索';

  @override
  String get uiDisabled => '無効';

  @override
  String get uiDuplicatePhrase => 'フレーズを複製';

  @override
  String get uiDisable => '無効にする';

  @override
  String get uiEnable => '有効にする';

  @override
  String get uiEditPhrase => 'フレーズを編集';

  @override
  String get uiShortcutLettersDigitsOr => '短縮コード（英数字・_・-、1～32 文字）';

  @override
  String get uiAvailableInAllProjects => 'すべてのプロジェクトで使用';

  @override
  String get uiContainsMentionsCurrentProjectOnly =>
      'Mention を含むため、現在のプロジェクトのみ';

  @override
  String get uiTags => 'タグ';

  @override
  String get uiAddTag => 'タグを追加';

  @override
  String get uiContent => '内容';

  @override
  String get uiMentionsAreProjectSpecificTextAnnotationsCanBe =>
      'Mention は現在のプロジェクト専用です。文字マークはすべてのプロジェクトで使えます。';

  @override
  String get uiAnnotation2 => 'マーク';

  @override
  String get uiIncompleteMosaicSyntax => 'モザイクの構文が不完全です';

  @override
  String get uiBack => '戻る';

  @override
  String get uiNoMatchingSuggestions => '一致する候補がありません';

  @override
  String uiBackTo(String p1) {
    return '$p1へ戻る';
  }

  @override
  String get uiEnterSelectsRightArrowOpensTheNextLevel =>
      'Enter で選択、右矢印キーで次の階層を展開';

  @override
  String get uiEnterOrTabSelects => 'Enter または Tab で選択';

  @override
  String uiExpandTheNextLevelOf(String p1) {
    return '$p1の次の階層を展開';
  }

  @override
  String uiChanges(String p1, String p2) {
    return '$p1の変更：$p2';
  }

  @override
  String uiItemChanges(String p1) {
    return '項目の変更：$p1';
  }

  @override
  String get uiTrackChanges => '変更履歴';

  @override
  String get uiCollapseChangesPane => '変更履歴ペインを折りたたむ';

  @override
  String get uiCouldNotReadChangeTrackingData => '変更履歴のデータを読み込めません';

  @override
  String get uiCreateABaselineFromTheCurrentContentTo =>
      '現在の内容から比較基準を作成して、変更を確認します。';

  @override
  String get uiStartTracking => '変更の追跡を開始';

  @override
  String uiBaseline(String p1) {
    return '比較基準：$p1';
  }

  @override
  String uiComparingToCurrentContent(String p1, String p2) {
    return '$p1：$p2 · 比較先：現在の内容';
  }

  @override
  String get uiReadOnlyVersion => '読み取り専用バージョン';

  @override
  String get commonCreate => '作成';

  @override
  String get uiSaveCurrentContentAsCheckpointAndApply =>
      '現在の内容をチェックポイントに保存して適用';

  @override
  String get uiShowAcceptedChanges => '反映済みの変更を表示';

  @override
  String get uiStopTracking => '追跡を終了';

  @override
  String get uiManuscript => '本文';

  @override
  String get uiSettings => '設定';

  @override
  String get uiScope => '範囲：';

  @override
  String get uiCurrentChapterPage => '現在の章／ページ';

  @override
  String get uiEntireProject => 'プロジェクト全体';

  @override
  String uiManuscriptLinesSettingsM(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  ) {
    return '本文 +$p1 / −$p2 行 · 設定 +$p3 / −$p4 / 変更$p5';
  }

  @override
  String uiAcceptChangesInScope(String p1) {
    return 'この範囲の変更を反映（$p1 件）';
  }

  @override
  String get uiRejectManuscriptChangesInScope => 'この範囲の本文の変更を元に戻す';

  @override
  String get uiLargeDifferencesAreSimplifiedLineCountsMayNot =>
      '大きな差分は簡略表示されるため、行数が最小とは限りません。';

  @override
  String get uiSomeDataTypesAreNotYetIncludedIn => '一部のデータ形式は比較対象に含まれていません。';

  @override
  String get uiPreviousChange => '前の変更';

  @override
  String get uiNextChange => '次の変更';

  @override
  String uiCouldNotCalculateChanges(String p1) {
    return '変更を計算できませんでした：$p1';
  }

  @override
  String get uiUnknownError => '不明なエラー';

  @override
  String get uiComparisonSourceIsNotAvailableYet => '比較元をまだ取得できません';

  @override
  String get uiNoChangesInThisScope => 'この範囲に変更はありません';

  @override
  String uiManuscriptBeforeAfter(String p1, String p2, String p3) {
    return '本文／$p1 · 変更前 $p2 → 変更後 $p3';
  }

  @override
  String uiAdditionalLines(String p1) {
    return 'ほか $p1 行…';
  }

  @override
  String uiTrailingNewline(String p1, String p2) {
    return '末尾の改行：$p1 → $p2';
  }

  @override
  String get uiPresent => 'あり';

  @override
  String get uiLargeDifferencesOverview => '大きな差分の概要';

  @override
  String get uiFullAnnotation => '完全なマーク';

  @override
  String get uiUndoAcceptance => '反映を取り消す';

  @override
  String get uiAccept => '反映';

  @override
  String get uiReject => '元に戻す';

  @override
  String uiFullAnnotation2(String p1) {
    return '$p1 · 完全なマーク';
  }

  @override
  String get uiProjectInformation => 'プロジェクト情報';

  @override
  String get uiAddedItem => '追加された項目';

  @override
  String get uiDeletedItem => '削除された項目';

  @override
  String uiSwitchModuleCurrent(String p1) {
    return 'モジュールを切り替え（現在：$p1）';
  }

  @override
  String get uiNoTargetsAvailable => '対象がありません';

  @override
  String get uiCreateATargetOfTheSameTypeBefore =>
      '同じ種類の対象を作成してから、このマークの参照先を再設定してください。';

  @override
  String get uiFullAnnotationSyntaxCopied => '完全なマーク構文をコピーしました。';

  @override
  String get uiOpenDashboard => 'ダッシュボードを開く';

  @override
  String get uiTheManuscriptChangedWaitForChangesToBe =>
      '本文が変更されました。差分の再計算後に一括で元に戻してください。';

  @override
  String get uiTheBatchRejectionSourceHasChangedRecalculateThe =>
      '一括で元に戻す操作の比較元が変更されました。差分を再計算してください。';

  @override
  String get uiTheManuscriptChangedWaitForChangesToBe2 =>
      '本文が変更されました。差分の再計算後に元に戻してください。';

  @override
  String get uiThisBlockSPositionIsNoLongerValid =>
      'このブロックの位置は無効になりました。差分を再計算してください。';

  @override
  String get uiTheFieldChangedWaitForChangesToBe =>
      'フィールドが変更されました。差分の再計算をお待ちください。';

  @override
  String get uiThisChapterWasDeletedViewItsPreviousContent =>
      'この章は削除されました。変更履歴ペインで以前の内容を確認できます。';

  @override
  String get uiCouldNotPrepareTheThreeWayMerge => '三方向マージを準備できませんでした。';

  @override
  String get uiRevisionHeadsChangedDuringMergingOutdatedConflictChoices =>
      'マージ中にリビジョンの先頭が変わったため、古い競合の選択結果は適用しませんでした。';

  @override
  String uiCouldNotApplyConflictChoices(String p1) {
    return '競合の選択結果を適用できませんでした：$p1';
  }

  @override
  String get uiTheMergedFileWasSavedButCreatingThe =>
      'マージしたファイルは保存されましたが、解決リビジョンを作成できませんでした。今すぐ同期を再試行してメタデータを復元してください。';

  @override
  String get uiFieldConflictsResolvedAndARevisionWithTwo =>
      'フィールドの競合を解決し、二つの親を持つリビジョンを作成しました。相手の ACK を待っています。';

  @override
  String uiCouldNotSaveTheResolutionRevision(String p1) {
    return '解決リビジョンを保存できませんでした：$p1';
  }

  @override
  String get uiTheRemoteRevisionIsNoLongerValidDownload =>
      '相手のリビジョンは無効になりました。完全なスナップショットを再ダウンロードしてください。';

  @override
  String get uiTheRemoteProjectFormatIsNewerAndCannot =>
      '相手のプロジェクト形式が新しいため、安全に比較できません。';

  @override
  String get uiTheRemoteRevisionBelongsToAnotherProjectAnd =>
      '相手のリビジョンは別のプロジェクトのため、比較に追加しませんでした。';

  @override
  String get uiTheCompleteRemoteRevisionIsAvailableForRead =>
      '完全な相手のリビジョンを読み取り専用の比較用に読み込みました。';

  @override
  String uiCouldNotCompareTheRemoteRevision(String p1) {
    return '相手のリビジョンを比較できませんでした：$p1';
  }

  @override
  String get uiTheSyncSessionOrRemoteRevisionChangedDownload =>
      '同期セッションまたは相手のリビジョンが変わりました。スナップショットを再ダウンロードしてください。';

  @override
  String get uiTheWorkingCopyHasLiveOperationsSnapshotsAre =>
      '作業中のプロジェクトには共同編集操作があります。スナップショットは初期化やチェックポイント専用のため、編集中のプロジェクトを上書きできません。';

  @override
  String get uiSaveAndOpenRemoteRevision => '相手のリビジョンを保存して開きますか？';

  @override
  String get uiTheRemoteSnapshotIsFullyVerifiedChooseWhere =>
      '相手のスナップショットは検証済みです。保存先を選んでください。既存ファイルを選ぶと、確認後に上書きします。キャンセルしても現在の編集内容は変わりません。';

  @override
  String get uiTheRemoteSnapshotIsVerifiedButItCannot =>
      '相手のスナップショットは検証済みですが、現在のファイルへ安全に適用できません。コピーとして保存してください。';

  @override
  String get uiChooseSaveLocation => '保存先を選択';

  @override
  String get uiTheSyncSessionChangedDuringConfirmationNoProject =>
      '確認中に同期セッションが変わったため、プロジェクトは書き込みませんでした。';

  @override
  String get uiTheSnapshotWasSavedButTheSyncSession =>
      'スナップショットは保存しましたが、同期セッションが無効になったため、現在の編集画面は切り替えていません。';

  @override
  String uiRemoteSnapshotOverwrittenAndOpened(String p1) {
    return '相手のスナップショットで上書きし、開きました：$p1';
  }

  @override
  String uiRemoteSnapshotSavedAsACopyAndOpened(String p1) {
    return '相手のスナップショットをコピーとして保存し、開きました：$p1';
  }

  @override
  String uiCouldNotSaveOrOpenTheRemoteSnapshot(String p1) {
    return '相手のスナップショットを保存または開けませんでした：$p1';
  }

  @override
  String get uiAllowAutomaticSyncForThisSession => 'このセッションで同期の自動適用を許可しますか？';

  @override
  String get uiTheRemoteDraftIsFullyVerifiedIfAllowed =>
      '相手の下書きは検証済みです。許可すると、この安全なセッションの下書きはローカルの変更がないときに自動適用されます。.mnproj は頻繁には書き込まず、手動保存時に保存します。';

  @override
  String uiTheRemoteRevisionIsFullyVerifiedIfAllowed(String p1) {
    return '相手のリビジョンは検証済みです。許可すると、ローカルに変更がないときは後続のリビジョンを自動適用し、上書きを毎回確認しません。対象プロジェクト：$p1。';
  }

  @override
  String get uiNotNow => '今は許可しない';

  @override
  String get uiAllowThisSession => 'このセッションで許可';

  @override
  String get uiRemoteDraftAppliedInNearRealTimeThe =>
      '相手の下書きをほぼリアルタイムで適用しました。.mnproj はまだ更新していません。手動保存時に保存します。';

  @override
  String uiCouldNotApplyTheRemoteDraftInMemory(String p1) {
    return '相手の下書きをメモリに適用できませんでした：$p1';
  }

  @override
  String get uiImportModules => 'モジュールをインポート';

  @override
  String uiSource(String p1) {
    return 'インポート元：$p1';
  }

  @override
  String get uiSelectedModulesReplaceTheCorrespondingDataInThis =>
      '選択したモジュールは、このプロジェクトの対応するデータを置き換えます。';

  @override
  String get uiThisIsASelectiveExportImportingReplacesWhole =>
      'これは項目指定のエクスポートです。インポートは個別にマージせず、モジュール全体を置き換えるため、含まれないデータが削除されることがあります。先にバックアップし、置き換えるモジュールを明示的に選択してください。';

  @override
  String uiIncludesRequiredAncestorsOrDependenciesImportIntoAn(String p1) {
    return '$p1には必要な親項目や依存項目が含まれます。データがあるプロジェクトではなく、空のプロジェクトへインポートしてください。';
  }

  @override
  String get uiSelectiveContentReplacesTheEntireModule => '（項目指定・モジュール全体を置換）';

  @override
  String uiCurrentAfterImportIncludingStructuralNodes(String p1, String p2) {
    return '現在 $p1 件 → インポート後 $p2 件（構造上の項目を含む）';
  }

  @override
  String uiReferencesRequiringRepair(String p1) {
    return '修復が必要な参照：$p1';
  }

  @override
  String get uiApplyImport => 'インポートを適用';

  @override
  String get uiTheWorkChangedDuringConfirmationStartTheImport =>
      '確認中に作品が変更されました。インポートをやり直してください。';

  @override
  String uiReferencesRequiringRepair2(String p1) {
    return '；修復が必要な参照：$p1 件';
  }

  @override
  String uiModulesImported(String p1, String p2) {
    return 'インポートしたモジュール：$p1$p2。';
  }

  @override
  String uiImportFailed(String p1) {
    return 'インポートに失敗しました：$p1';
  }

  @override
  String uiExportComplete(String p1) {
    return 'エクスポートが完了しました：$p1';
  }

  @override
  String uiExportFailed(String p1) {
    return 'エクスポートに失敗しました：$p1';
  }

  @override
  String uiUpgradedToInMemoryWarnings(String p1, String p2) {
    return '（メモリ内で $p1 に更新、警告 $p2 件）';
  }

  @override
  String uiProjectOpened2(String p1, String p2) {
    return 'プロジェクトを開きました：$p1$p2';
  }

  @override
  String get uiUntitledMnproj => '無題.mnproj';

  @override
  String get uiExternalProjectMnproj => '外部プロジェクト.mnproj';

  @override
  String get uiThisRecentFileHasNoUsableLocalPath =>
      'この最近のファイルには使用できるローカルパスがありません。「ファイルを開く」を使用してください。';

  @override
  String uiFailed(String p1, String p2) {
    return '$p1に失敗しました：$p2';
  }

  @override
  String uiRemovedFromRecentProjects(String p1) {
    return '最近のプロジェクトから削除しました：$p1';
  }

  @override
  String get uiCodenameHana => 'コードネーム Hana';

  @override
  String get uiMonoAshiIsAWritingAssistantForAuthorsAnd =>
      'ものアシは作家やクリエイターのための執筆支援ツールです。章節管理、キャラクター設定、世界観の構築など、物語を整理して創作するための機能を備えています。';

  @override
  String get uiKeyFeatures => '主な機能';

  @override
  String get uiStorySettingsManagement => '作品設定の管理';

  @override
  String get uiChapterAndParagraphEditing => '章節と段落の編集';

  @override
  String get uiOutlinePlanning => 'アウトラインの作成';

  @override
  String get uiWorldbuilding => '世界観設定';

  @override
  String get uiCharacterDatabase => 'キャラクターデータベース';

  @override
  String get uiHeyairu => '© 2025–2026 Heyairu（部屋伊琉）。';

  @override
  String get uiCouldNotLoadTheNameDataTryAgain =>
      '名前のデータを読み込めませんでした。しばらくしてからお試しください。';

  @override
  String get uiNameResultsCopied => '生成した名前をコピーしました。';

  @override
  String get uiCreatingAProjectIsNotConnectedYet => '新規プロジェクト作成機能はまだ接続されていません。';

  @override
  String get uiOpeningFilesIsNotConnectedYet => 'ファイルを開く機能はまだ接続されていません。';

  @override
  String get uiRecentProjectsAreNotConnectedYet =>
      '最近のプロジェクトを開く機能はまだ接続されていません。';

  @override
  String get uiRemovingRecentProjectsIsNotConnectedYet =>
      '最近のプロジェクトを削除する機能はまだ接続されていません。';

  @override
  String get uiPortMustBeAnIntegerFromTo => 'ポートには 1～65535 の整数を指定してください。';

  @override
  String get uiEnterAValidLocalNetworkIPv4Address =>
      '有効なローカルネットワークの IPv4 アドレスを入力してください。';

  @override
  String get uiNeitherDeviceHasASyncProject => 'どちらの端末にも同期するプロジェクトがありません';

  @override
  String get uiDifferentSyncProjects => '同期するプロジェクトが異なります';

  @override
  String get uiNeitherDeviceHasTheTargetProjectInMemory =>
      'どちらの端末にも対象プロジェクトがメモリ上にありません。新規プロジェクトを作成すれば、先にファイルを保存せずに共同編集できます。';

  @override
  String get uiTheDevicesHaveDifferentProjectUUIDsChooseWhich =>
      '双方のプロジェクト UUID が異なります。今回の同期で使用するファイルを選択してください。';

  @override
  String get uiThisDevice => 'この端末';

  @override
  String get uiPeer => '相手の端末';

  @override
  String get uiCreateLocalProject => 'ローカルプロジェクトを作成';

  @override
  String get uiOpenAnotherFile => '別のファイルを開く';

  @override
  String get uiUsePeerSFile => '相手のファイルを使用';

  @override
  String get uiUseLocalFile => 'ローカルファイルを使用';

  @override
  String get uiNoProjectToSync => '同期できるプロジェクトがありません';

  @override
  String get uiTheInMemoryProjectIsReadyForLive =>
      'メモリ上のプロジェクトは共同編集できます。保存は XML チェックポイントの作成にのみ必要です。';

  @override
  String get uiTheProjectIsSavedWithAValidUUID =>
      'プロジェクトは有効な UUID で保存済みです。安全なペアリングを待っています。';

  @override
  String get uiPrepareProjectForSync => '同期用プロジェクトを準備';

  @override
  String get uiLiveCollaborationRequiresAValidProjectUUIDIn =>
      '共同編集にはメモリ上の有効なプロジェクト UUID があればよく、事前のファイル保存は不要です。';

  @override
  String get uiCreateInMemoryProject => 'メモリ上にプロジェクトを作成';

  @override
  String get uiOpenSavedFile => '保存済みのファイルを開く';

  @override
  String get uiSaveAsNewWork => '新しい作品として保存';

  @override
  String get uiNoProjectIsOpen => 'プロジェクトが開かれていません。';

  @override
  String get uiTheCurrentProjectHasNotBeenSavedTo =>
      '現在のプロジェクトは再度開ける場所に保存されていません。';

  @override
  String get uiTheCurrentProjectHasUnsavedChanges => '現在のプロジェクトには未保存の変更があります。';

  @override
  String get uiTheCurrentProjectHasNoValidProjectUUID =>
      '現在のプロジェクトに有効なプロジェクト UUID がありません。';

  @override
  String get uiThisProjectFormatDoesNotSupportP2PSync =>
      'このプロジェクト形式は P2P 同期に対応していません。';

  @override
  String get uiTheCurrentProjectHasUnresolvedSyncConflicts =>
      '現在のプロジェクトに未解決の同期競合があります。';

  @override
  String get uiServiceOff => 'サービス停止中';

  @override
  String get uiStartingService => 'サービスを開始中';

  @override
  String get uiServiceRunning => 'サービス稼働中';

  @override
  String get uiStoppingService => 'サービスを停止中';

  @override
  String get uiServiceError => 'サービスエラー';

  @override
  String get uiThePeerWillProvideAnInMemoryProject =>
      '相手がメモリ上のプロジェクトを提供します。先に保存先を指定する必要はありません。';

  @override
  String get uiInMemoryProjectReadyForLiveSyncNo =>
      'メモリ上のプロジェクトは共同編集できます。XML チェックポイントは未作成です';

  @override
  String get uiCreateOrOpenAProjectFirst => '先にプロジェクトを作成するか開いてください';

  @override
  String get uiUnresolvedSyncConflicts => '未解決の同期競合があります';

  @override
  String get uiSavedRevisionsSynchronized => '保存済み・リビジョン同期済み';

  @override
  String get uiSavedReadyToNotifyThePeer => '保存済み・相手に同期を通知できます';

  @override
  String get uiSavedReadyToDownloadAndApplyThePeer =>
      '保存済み・相手のリビジョンをダウンロードして適用できます';

  @override
  String get uiSavedFieldLevelConflictMergingAvailable =>
      '保存済み・フィールド単位で競合をマージできます';

  @override
  String get uiSavedWaitingForRevisionNegotiation => '保存済み・リビジョンの交渉を待っています';

  @override
  String get uiSavedWaitingForConnectionNegotiationAndSecurePairing =>
      '保存済み・接続の交渉と安全なペアリングを待っています';

  @override
  String get uiSyncProjectIsNotReady => '同期するプロジェクトが準備できていません';

  @override
  String get uiNotPaired => '未ペアリング';

  @override
  String get uiWaitingForThePeerSPairingChallenge => '相手のペアリングチャレンジを待っています';

  @override
  String get uiWaitingForManualPairingCodeComparison => 'ペアリングコードの目視確認を待っています';

  @override
  String get uiAddedToThisDeviceSTrustList => 'この端末の信頼リストに追加済みです';

  @override
  String get uiConfirmedLocallyWaitingForThePeerSSignature =>
      'この端末では確認済みです。相手の署名を待っています';

  @override
  String get uiBothDevicesConfirmedTheSamePairingTranscript =>
      '両端末で同じペアリング記録を確認しました';

  @override
  String get uiPairingError => 'ペアリングエラー';

  @override
  String get uiPersistentVerificationEnabledOnBothDevicesValidFor =>
      '両端末で継続認証が有効です。ペアリング後 14 日間有効になります';

  @override
  String uiPersistentVerificationExpiresEachSuccessfulConnectionRenewsIt(
    String p1,
  ) {
    return '継続認証の期限：$p1。接続成功時に 14 日間延長します';
  }

  @override
  String get uiPersistentVerificationExpiredConfirmThePairingCodeAgain =>
      '継続認証の期限が切れました。ペアリングコードを再確認してください。';

  @override
  String get uiLocalRevisionLoading => 'ローカルリビジョン：読み込み中…';

  @override
  String get uiLocalRevisionMetadataError => 'ローカルリビジョン：メタデータエラー';

  @override
  String get uiLocalRevisionNotCreatedYetCreatedAfterA =>
      'ローカルリビジョン：未作成（保存成功後に作成）';

  @override
  String uiLocalRevisionConcurrentHeads(String p1) {
    return 'ローカルリビジョン：並行する先頭リビジョン $p1 件';
  }

  @override
  String uiLocalRevision(String p1, String p2) {
    return 'ローカルリビジョン：$p1  ·  $p2';
  }

  @override
  String get uiEncryptedChannelNotEstablished => '暗号化通信：未確立';

  @override
  String get uiEncryptedChannelVerifyingIdentityAndDerivingASession =>
      '暗号化通信：身元の検証とセッション鍵の生成中…';

  @override
  String get uiEncryptedChannelAuthenticatedAndEncrypted => '暗号化通信：認証・暗号化済み';

  @override
  String get uiEncryptedChannelConnectionFailed => '暗号化通信：確立に失敗';

  @override
  String get uiRevisionHeadsMatch => '；先頭リビジョンが一致';

  @override
  String get uiLocalRevisionIsNewer => '；ローカルのリビジョンが新しい';

  @override
  String get uiPeerRevisionIsNewer => '；相手のリビジョンが新しい';

  @override
  String get uiConcurrentRevisionsDetected => '；並行リビジョンを検出';

  @override
  String get uiSnapshotChunkValidationEnabled => '；スナップショットチャンクの検証が有効';

  @override
  String get uiLocalManifestNotCreated => 'ローカルマニフェスト：未作成';

  @override
  String uiLocalManifestBytesChunks(String p1, String p2) {
    return 'ローカルマニフェスト：$p1 バイト／$p2 チャンク';
  }

  @override
  String get uiPeerManifestNotNegotiated => '相手のマニフェスト：未交渉';

  @override
  String get uiPeerManifestRequesting => '相手のマニフェスト：要求中…';

  @override
  String uiPeerManifestVerifiedBytes(String p1) {
    return '相手のマニフェスト：検証済み（$p1 バイト）';
  }

  @override
  String get uiPeerManifestCurrentlyUnavailable => '相手のマニフェスト：現在利用できません';

  @override
  String get uiPeerManifestVerificationFailed => '相手のマニフェスト：検証に失敗';

  @override
  String get uiRevisionDAGExchangingGraphPages => 'リビジョン DAG：グラフページを交換中…';

  @override
  String get uiRevisionDAGFullHistoryNotYetExchanged => 'リビジョン DAG：完全な履歴は未交換';

  @override
  String uiRevisionDAGRemoteRevisionsMaximalCommonAncestorsWaiting(
    String p1,
    String p2,
  ) {
    return 'リビジョン DAG：相手のリビジョン $p1 件、最大共通祖先 $p2 件。解決／ACK を待機中';
  }

  @override
  String uiRevisionDAGPeerAcknowledgedResolution(String p1) {
    return 'リビジョン DAG：相手が解決 $p1 を ACK 済み';
  }

  @override
  String get uiCouldNotOpenTheLinkItHasBeen => 'リンクを開けなかったため、クリップボードにコピーしました。';

  @override
  String get uiNewProject => '新規プロジェクト';

  @override
  String get uiOpenFile2 => 'ファイルを開く';

  @override
  String get uiOpenThisProjectOnGitHub => 'このプロジェクトの GitHub を開く';

  @override
  String get uiHeyairuSKadoKadoProfile => 'Heyairu の KadoKado プロフィール';

  @override
  String get uiSendFeedbackGoogleForms => 'フィードバック（Google フォーム）';

  @override
  String get uiSendFeedbackGitHubIssues => 'フィードバック（GitHub Issues）';

  @override
  String get uiNoRecentFiles => '最近開いたファイルはありません';

  @override
  String get uiProjectsYouOpenWillAppearHere => '開いたプロジェクトがここに表示されます。';

  @override
  String get uiNoUsablePath => '使用できるパスがありません';

  @override
  String get uiRemoveFromRecentProjects => '最近のプロジェクトから削除';

  @override
  String get uiNameGenerator => '名前ジェネレーター';

  @override
  String get uiLanguage => '言語';

  @override
  String get uiJapanese => '日本風';

  @override
  String get uiChinese => '中国風';

  @override
  String get uiKorean => '韓国風';

  @override
  String get uiGender => '性別';

  @override
  String get uiAllUnavailable => 'すべて（利用不可）';

  @override
  String get uiMale => '男性';

  @override
  String get uiNeutralUnavailable => '中性（利用不可）';

  @override
  String get uiFemale => '女性';

  @override
  String get uiNumberToGenerate => '生成数';

  @override
  String get uiGenerate => '生成';

  @override
  String get uiResults => '結果';

  @override
  String get uiCopyResults => '結果をコピー';

  @override
  String get uiSelectGenerateToCreateNames => '「生成」を選択すると名前を作成します。';

  @override
  String get uiContentSync => '内容の同期';

  @override
  String get uiAfterSignedPairingAndAnAuthenticatedConnectionDevices =>
      '署名付きペアリングと認証済み接続の確立後、暗号化されたリビジョン、マニフェスト、スナップショットチャンクを交換できます。受信内容は検証用の隔離領域にのみ保存されます。';

  @override
  String get uiLocalService => 'この端末のサービス';

  @override
  String get uiNoUsableLANIPv4AddressFound => '利用できる LAN IPv4 アドレスがありません';

  @override
  String get uiDetectLocalIPAgain => 'この端末の IP を再検出';

  @override
  String get uiLocalPort => 'この端末のポート';

  @override
  String get uiStopService => 'サービスを停止';

  @override
  String get uiStartService => 'サービスを開始';

  @override
  String get uiConnectToDevice => '端末に接続';

  @override
  String get uiPeerIP => '相手の IP';

  @override
  String get uiForExample => '例：192.168.1.23';

  @override
  String get uiPeerPort => '相手のポート';

  @override
  String get uiEndpointVerified => '接続先を検証済み';

  @override
  String get uiConnecting => '接続中…';

  @override
  String get uiConnect => '接続';

  @override
  String get uiDisconnect => '切断';

  @override
  String get uiDeviceIdentityAndPairing => '端末の識別とペアリング';

  @override
  String uiLocalFingerprint(String p1) {
    return 'この端末のフィンガープリント：$p1';
  }

  @override
  String get uiInitializing => '初期化中…';

  @override
  String get uiConfirmationOneDeviceEnabledOnBothDevices =>
      '確認方式：片方の端末で確認（双方の設定が有効）';

  @override
  String get uiConfirmationBothDevicesOneOrBothDisabledSingle =>
      '確認方式：両端末で個別に確認（いずれかが片方のみの確認を無効化）';

  @override
  String get uiConfirmBothDevicesDisplayExactlyTheSamePairing =>
      '両端末にまったく同じペアリングコードが表示されているか確認してください：';

  @override
  String get uiCancelIfTheCodesDifferAfterEitherDevice =>
      'コードが異なる場合はキャンセルしてください。片方で確認すると、もう片方が署名を検証して自動で署名を返します。';

  @override
  String get uiCancelIfTheCodesDifferBothDevicesMust =>
      'コードが異なる場合はキャンセルしてください。両端末で個別に確認した後、暗号化通信が開始されます。';

  @override
  String get uiStartSecurePairing => '安全なペアリングを開始';

  @override
  String get uiConfirmCodesMatch => 'コードの一致を確認';

  @override
  String get uiCancelPairing => 'ペアリングをキャンセル';

  @override
  String get uiBothIdentitiesAndTemporaryECDHKeysAreBound =>
      '双方の身元と一時 ECDH 鍵を同じ通信記録に結び付けました。同じプロジェクトセッションで暗号化スナップショットを交換できます。受信内容は引き続き隔離検証が必要です。';

  @override
  String get uiBothDevicesSignedTheSameChallengeEstablishingAuthenticated =>
      '双方が同じチャレンジへ署名しました。認証付き暗号化通信を確立中です。確立前にリビジョン概要や内容は交換しません。';

  @override
  String get uiSyncProject => '同期するプロジェクト';

  @override
  String get uiNoProjectOpen => 'プロジェクト未選択';

  @override
  String uiPeerFile(String p1) {
    return '相手のファイル：$p1';
  }

  @override
  String uiPeerUUID(String p1) {
    return '相手の UUID：$p1';
  }

  @override
  String get uiChangeSyncProject => '同期するプロジェクトを変更';

  @override
  String get uiPrepareSyncProject => '同期するプロジェクトを準備';

  @override
  String get uiRevisionsDivergedResolveFieldLevelConflictsFirst =>
      '双方のリビジョンが分岐しています。先にフィールド単位の競合を解決してください。';

  @override
  String get uiAskTheReceiverToDownloadTheCurrentSnapshot =>
      '認証済み接続で、受信側に現在のスナップショットのダウンロードを要求します。';

  @override
  String get uiOnlyAcceptARemoteSnapshotThatExactlyMatches =>
      '現在の認証済みセッションと完全に一致する相手のスナップショットのみ受け入れます。';

  @override
  String get uiApplying => '適用中';

  @override
  String get uiDownloading => 'ダウンロード中';

  @override
  String get uiSyncNow => '今すぐ同期';

  @override
  String get uiCompareRemoteRevision => '相手のリビジョンと比較';

  @override
  String get uiCancelTransfer => '転送をキャンセル';

  @override
  String get uiBasicInformation => '基本情報';

  @override
  String get uiBookTitle => '作品名';

  @override
  String get uiEnterTheBookTitle => '作品名を入力';

  @override
  String get uiAuthor => '作者';

  @override
  String get uiEnterTheAuthorSName => '作者名を入力';

  @override
  String get uiTheme2 => '主題';

  @override
  String get uiEnterTheStorySTheme => '物語の主題を入力';

  @override
  String get uiOneLineSummary => '一行あらすじ';

  @override
  String get uiEnterAOneLineSummary => '一行あらすじを入力';

  @override
  String get uiEnterTheGenre => 'ジャンルを入力';

  @override
  String get uiSynopsis => 'あらすじ';

  @override
  String get uiEnterASynopsis => '作品のあらすじを入力';

  @override
  String get uiStatistics => '統計';

  @override
  String get uiLastSaved => '最終保存日時';

  @override
  String get uiTotalCount => '全文の文字・単語数';

  @override
  String uiCharacters2(String p1) {
    return '$p1 文字';
  }

  @override
  String get uiChapterCount => 'この章の文字・単語数';

  @override
  String uiFolder(String p1) {
    return 'フォルダー $p1';
  }

  @override
  String get uiChapters => '章節一覧';

  @override
  String uiTotalCharacters(String p1) {
    return '全文：$p1 文字';
  }

  @override
  String get uiFoldersAndChaptersShareOneListDeletingA =>
      'フォルダーと章は同じ一覧に表示されます。フォルダーを削除すると、中の章も削除されます。';

  @override
  String get uiLongPressAndDragToReorderDragChapters =>
      '長押ししてドラッグすると並べ替えられます。章は別のフォルダーへ移動できます。ルートフォルダーは常に非表示です。';

  @override
  String get uiSearchFolderOrChapterNames => 'フォルダー名・章名を検索';

  @override
  String get uiClearSearch => '検索をクリア';

  @override
  String get uiChapterTree => '章の構成';

  @override
  String get uiNoChapters => '章がありません';

  @override
  String get uiAddYourFirstFolder => '最初のフォルダーを追加してください。';

  @override
  String get uiChapterName => '章名';

  @override
  String get uiSelectAFolderFirst => '先にフォルダーを選択してください。';

  @override
  String get uiSubfolder => 'サブフォルダー';

  @override
  String get uiSelectAParentFolderFirst => '先に親フォルダーを選択してください。';

  @override
  String get uiRootFolder => 'ルートフォルダー';

  @override
  String get uiAddChapter => '章を追加';

  @override
  String get uiAddSubfolder => 'サブフォルダーを追加';

  @override
  String get uiAddRootFolder => 'ルートフォルダーを追加';

  @override
  String get uiUnnamedFolder => '（名前のないフォルダー）';

  @override
  String uiChaptersSubfoldersCount(String p1, String p2, String p3) {
    return '$p1 章 • サブフォルダー $p2 個 • $p3 文字';
  }

  @override
  String get uiCollapseFolder => 'フォルダーを折りたたむ';

  @override
  String get uiExpandFolder => 'フォルダーを展開';

  @override
  String get uiDeleteThisFolderAndItsChapters => 'このフォルダーと中の章を削除';

  @override
  String get uiAtLeastOneChapterIsRequired => '少なくとも一つの章が必要です。';

  @override
  String uiChapterMovedTo(String p1) {
    return '章を「$p1」に移動しました。';
  }

  @override
  String get uiDeleteThisChapter => 'この章を削除';

  @override
  String get uiSourceCharacter => '関係元のキャラクター';

  @override
  String get uiTargetCharacter => '関係先のキャラクター';

  @override
  String get uiSelectAnExistingCharacterOrEnterANew =>
      '既存のキャラクターを選択、または新しい名前を入力';

  @override
  String get uiExternalRelationship => '表向きの関係';

  @override
  String get uiForExampleFriendFamilyRival => '例：友人、家族、ライバル';

  @override
  String get uiInternalRelationship => '内面的な関係';

  @override
  String get uiForExampleTrustAdmirationEnvy => '例：信頼、憧れ、嫉妬';

  @override
  String get uiBidirectionalRelationship => '双方向の関係';

  @override
  String get uiAlsoCreateARelationshipFromTheTargetBack =>
      '関係先から関係元への逆方向の関係も作成します。';

  @override
  String get uiNoCharactersYet => 'キャラクターがありません';

  @override
  String get uiAddCharactersInCharacterSettingsBeforeCreatingAnd =>
      '先にキャラクター設定でキャラクターを追加してから、関係を作成・表示してください。';

  @override
  String get uiMinimizeTimelineAndSnapshots => 'タイムラインとスナップショットを最小化';

  @override
  String get uiHistoricalPreviewsAreReadOnlyEachCharacterUses =>
      '履歴プレビューは読み取り専用です。各キャラクターにはこの Tick より前の有効な変更を適用します。編集するには既定データへ戻ってください。';

  @override
  String get uiCharacterRelationships => 'キャラクター相関';

  @override
  String get uiCollapseToolbar => 'ツールバーを折りたたむ';

  @override
  String get uiExpandToolbar => 'ツールバーを展開';

  @override
  String get uiEnableSnapshots => 'スナップショットを有効化';

  @override
  String get uiShowSnapshotCards => 'スナップショットカードを表示';

  @override
  String get uiCloseSnapshots => 'スナップショットを閉じる';

  @override
  String get uiShowRelationships => '関係を表示';

  @override
  String get uiArrangeCharacters => 'キャラクターを配置';

  @override
  String get uiLocateCharacter => 'キャラクターの位置';

  @override
  String get uiRelationshipClusters => '関係のグループ';

  @override
  String get uiExternalInternalDragCharactersToReposition =>
      '表向き ━   内面的 ┄   キャラクターをドラッグして配置';

  @override
  String get uiSearchOrSelectCharacter => 'キャラクターを検索・選択';

  @override
  String get uiSearchAndFocus => '検索してフォーカス';

  @override
  String get uiShowDirectNeighborsOnly => '直接つながる相手のみ表示';

  @override
  String get uiSelectACharacterFirst => '先にキャラクターを選択してください。';

  @override
  String get uiOverview => '全体プレビュー';

  @override
  String get uiAddRelationship => '関係を追加';

  @override
  String get uiHistoricalPreviewIsReadOnly => '履歴プレビューは読み取り専用です';

  @override
  String get uiRearrangeAutomatically => '自動で再配置';

  @override
  String get uiResetZoom => 'ズームをリセット';

  @override
  String get uiZoomOut => '縮小';

  @override
  String get uiZoomIn => '拡大';

  @override
  String get uiMergeIdenticalBidirectionalRelationships => '同じ双方向の関係を統合';

  @override
  String get uiNoMatchingCharacters => '一致するキャラクターがいません';

  @override
  String get uiNoRelationshipsYetAddOneHereOrEdit =>
      '関係がありません。ここで追加するか、キャラクター設定で編集してください。';

  @override
  String get commonAdd => '追加';

  @override
  String uiAnd(String p1, String p2) {
    return '$p1 と $p2';
  }

  @override
  String get uiOpenCharacterEditor => 'キャラクター編集を開く';

  @override
  String get uiCollapseDetails => '詳細を折りたたむ';

  @override
  String get uiExpandDetails => '詳細を展開';

  @override
  String get uiThisNameDoesNotUniquelyIdentifyACharacter =>
      'この名前ではキャラクターを一意に特定できません。接続を選択して修正してください。';

  @override
  String uiOccupation(String p1) {
    return '職業：$p1';
  }

  @override
  String uiAge(String p1) {
    return '年齢：$p1';
  }

  @override
  String uiGender2(String p1) {
    return '性別：$p1';
  }

  @override
  String get uiOrganizations => '所属組織';

  @override
  String uiAdjacentRelationships(String p1) {
    return '隣接する関係：$p1';
  }

  @override
  String get uiUnpin => '固定を解除';

  @override
  String get uiPinPosition => '位置を固定';

  @override
  String get uiThisPinnedPositionOverlapsAnotherPinnedCharacterDrag =>
      '固定位置が別の固定キャラクターと重なっています。ドラッグして調整してください。';

  @override
  String get uiCreateTargetCharacter => '関係先のキャラクターを作成';

  @override
  String uiShowing(String p1) {
    return '表示中：$p1';
  }

  @override
  String get uiExternal => '表向き';

  @override
  String get uiInternal => '内面的';

  @override
  String get uiShowAllRelationships => 'すべての関係を表示';

  @override
  String get uiSeveralCharactersShareThisNameEditAndSelect =>
      '同名のキャラクターが複数います。編集して NanoID 付きのキャラクターを選択してください。';

  @override
  String get uiNoMatchingCharacterCorrectTheNameOrCreate =>
      '該当するキャラクターがいません。名前を修正するか、新しく作成してください。';

  @override
  String get uiCreateCharacter => 'キャラクターを作成';

  @override
  String get uiEdit => '編集';

  @override
  String get uiCorrectTargetCharacter => '関係先のキャラクターを修正';

  @override
  String uiDelete(String p1) {
    return '$p1を削除';
  }

  @override
  String get uiDeleteAllRelationshipsInThisDirection => 'この方向の関係をすべて削除';

  @override
  String get uiTheRelationshipChangedSelectItAgainBeforeContinuing =>
      '関係が変更されました。選択し直してから操作してください。';

  @override
  String uiEditRelationship(String p1, String p2, String p3) {
    return '$p1 → $p2 · $p3の関係を編集';
  }

  @override
  String uiRelationship(String p1) {
    return '$p1の関係';
  }

  @override
  String get uiDeleteCharacterRelationship => 'キャラクターの関係を削除';

  @override
  String get uiDeleteBothExternalAndInternalRelationshipsInThis =>
      'この方向の表向きと内面的な関係を削除しますか？逆方向の関係は残ります。';

  @override
  String uiDeleteTheRelationshipInThisDirectionOtherTypes(
    String p1,
    String p2,
  ) {
    return 'この方向の$p1の関係「$p2」を削除しますか？ほかの種類と逆方向の関係は残ります。';
  }

  @override
  String get uiSelectAnExistingCharacterThatCanBeUniquely =>
      '一覧から一意に特定できる既存のキャラクターを選択してください。';

  @override
  String get uiSeveralCharactersShareThisNameSelectOneWith =>
      '同名のキャラクターが複数います。NanoID 付きのキャラクターを一覧から選択してください。';

  @override
  String get uiAfterCreationThisRelationshipWillLinkAutomaticallyBy =>
      '作成後、キャラクター名を使ってこの関係を自動で接続します。';

  @override
  String get uiCharacterName => 'キャラクター名';

  @override
  String get uiCreatingTheCharacterAlsoAddsARelationshipFrom =>
      '新しいキャラクターを作成すると、現在のキャラクターからその相手への関係も追加します。';

  @override
  String get uiNext2 => '次へ';

  @override
  String get uiSetUpNewCharacterRelationship => '新しいキャラクターとの関係を設定';

  @override
  String get uiCorrectTheTargetInThisDirection => 'この方向の関係先を修正';

  @override
  String get uiSelectAnExistingCharacterBothRelationshipTypesMove =>
      '既存のキャラクターを選択してください。表向きと内面的な関係をまとめて移動します。';

  @override
  String get uiCharacterEditor => 'キャラクター編集';

  @override
  String get uiCharacterList => 'キャラクター一覧';

  @override
  String get uiCharacterName2 => 'キャラクター名';

  @override
  String get uiNoCharacters => 'キャラクターがいません';

  @override
  String get uiAddYourFirstCharacter => '最初のキャラクターを追加してください。';

  @override
  String uiCharacterType(String p1) {
    return 'キャラクターの役割：$p1';
  }

  @override
  String get uiSelectACharacter => 'キャラクターを選択';

  @override
  String get uiSelectACharacterFromTheListOnThe => '左の一覧から編集するキャラクターを選択してください。';

  @override
  String get uiCharacterCard => 'キャラクターカード';

  @override
  String get uiCustomData => 'カスタムデータ';

  @override
  String get uiAdvancedSettings => '詳細設定';

  @override
  String get uiAddSnapshot => 'スナップショットを追加';

  @override
  String get uiDuplicateSnapshot => 'スナップショットを複製';

  @override
  String get uiDefault => '既定';

  @override
  String get uiDeleteSnapshot => 'スナップショットを削除';

  @override
  String get uiTheDefaultSnapshotCannotBeDeleted => '既定のスナップショットは削除できません。';

  @override
  String get uiBasicIdentity => '基本プロフィール';

  @override
  String get uiNameRequired => '名前（必須）：';

  @override
  String get uiRoleOccupation => '身分／職業：';

  @override
  String get uiAge2 => '年齢：';

  @override
  String get uiGender3 => '性別：';

  @override
  String get uiBirthday => '誕生日：';

  @override
  String get uiCharacterType2 => 'キャラクターの役割';

  @override
  String get uiAppearanceSummary => '外見の概要';

  @override
  String get uiDescribeTheCharacterSGeneralAppearance =>
      'キャラクターのおおまかな外見を記録します。';

  @override
  String get uiHeight => '身長：';

  @override
  String get uiWeight => '体重：';

  @override
  String get uiHairColor => '髪の色：';

  @override
  String get uiEyeColor => '瞳の色：';

  @override
  String get uiAppearanceSummary2 => '外見の概要：';

  @override
  String get uiPersonalityAndStoryCore => '性格と物語の核';

  @override
  String get uiDescribeTheCharacterSPersonalityAndTheChallenges =>
      'キャラクターの性格と、物語で直面する困難を記録します。';

  @override
  String get uiPersonality => '性格：';

  @override
  String get uiSpeechStyle => '話し方：';

  @override
  String get uiMotivation => '動機：';

  @override
  String get uiGoal => '目標：';

  @override
  String get uiValuesAndBeliefs => '価値観・信念：';

  @override
  String get uiFear => '恐れているもの：';

  @override
  String get uiObstaclesAndResolutions => '障害と解決方法';

  @override
  String get uiObstacle => '障害となる出来事';

  @override
  String get uiResolution => '解決方法';

  @override
  String get uiEnterAnObstacleAndResolutionBelowThenAdd =>
      '下に出来事と解決方法を入力して追加してください。';

  @override
  String get uiCharacterRelationships2 => '人物関係の説明';

  @override
  String get uiDescribeTheCharacterSConnectionsWithOthers =>
      'ほかの人物とのつながりを記述します。';

  @override
  String get uiRelationshipSummary => '人物関係の概要：';

  @override
  String get uiOrganization => '組織';

  @override
  String get uiPositionTitle => '身分／役職';

  @override
  String get uiEnterAnOrganizationAndPositionBelowThenAdd =>
      '下に組織と身分・役職を入力して追加してください。';

  @override
  String get uiSelectALocationOrOrganizationOrEnterYour => '場所や組織を選択、または自由に入力';

  @override
  String get uiCharacterStatus => 'キャラクターの状態';

  @override
  String get uiDescribeTheCharacterSGeneralState => 'キャラクターのおおまかな状態を記録します。';

  @override
  String get uiEnterAStatusAndDescriptionBelowThenAdd =>
      '下に状態と説明を入力して追加してください。';

  @override
  String get uiNotes2 => 'メモ：';

  @override
  String get uiSelectACharacterFirst2 => '先にキャラクターを選択してください。';

  @override
  String get uiSelectACharacterToPreviewTheTimelineAnd =>
      'キャラクターを選ぶと、タイムラインのプレビューとスナップショットの管理ができます。';

  @override
  String get uiStoryStateEditingDefaultData => '物語の状態 · 既定データを編集中';

  @override
  String uiStoryStateTick(String p1, String p2) {
    return '物語の状態 · Tick $p1 · $p2';
  }

  @override
  String get uiReadOnlyPreviewFollowingTheTimeline =>
      '読み取り専用プレビュー・タイムラインを追従中です。';

  @override
  String uiEditing(String p1) {
    return '編集中：$p1';
  }

  @override
  String get uiEditingASceneSnapshotObstaclesRelationshipsOrganizationsStatus =>
      'シーンのスナップショットを編集中です。障害、人物関係、組織、状態、所持品、カスタムフィールドを変更できます。その他の固定情報はロックされています。';

  @override
  String get uiDefaultData => '既定データ';

  @override
  String get uiStateAtPlayhead => '再生ヘッド位置の状態';

  @override
  String uiCurrentTick(String p1) {
    return '現在の Tick $p1';
  }

  @override
  String get uiCopyCurrentState => '現在の状態をコピー';

  @override
  String get uiDefaultItemAssignments => '既定のアイテム配置';

  @override
  String uiItemAssignmentsAtTick(String p1) {
    return 'Tick $p1 のアイテム配置';
  }

  @override
  String get uiAllSnapshots => 'すべてのスナップショット';

  @override
  String uiTotalIncludingDefault(String p1) {
    return '合計 $p1 件（既定を含む）';
  }

  @override
  String get uiSnapshotHistoryAndEditing => 'スナップショットの履歴と編集';

  @override
  String get uiDefaultSnapshotBeforeTheStory => '既定のスナップショット（物語の開始前）';

  @override
  String get uiTheSceneIsUnscheduledOrItsPrimaryPlacement =>
      'シーンが未配置か、主要な配置が無効です。';

  @override
  String get uiFallbackTick => '代替 Tick';

  @override
  String uiChanges2(String p1) {
    return '変更：$p1';
  }

  @override
  String uiNotes3(String p1) {
    return 'メモ：$p1';
  }

  @override
  String get uiDefaultSnapshot => '既定のスナップショット';

  @override
  String get uiLocateSnapshot => 'スナップショットの位置へ';

  @override
  String get uiEditSnapshot => 'スナップショットを編集';

  @override
  String get uiDeleteSnapshot2 => 'スナップショットを削除しますか？';

  @override
  String get uiDeletingThisSnapshotRecalculatesTheCharacterSState =>
      '削除すると、このシーン以降のキャラクターの状態を再計算します。';

  @override
  String uiIsLocked(String p1) {
    return '$p1はロックされています';
  }

  @override
  String get uiSceneSnapshotsAllowChangesOnlyToTheFive =>
      'シーンのスナップショットでは五つのキャラクター表とカスタムフィールドのみ変更できます。固定情報を編集するには「既定」へ戻ってください。';

  @override
  String uiEvent2(String p1) {
    return 'イベント：$p1';
  }

  @override
  String get uiThisEventHasNoScenesYetANew =>
      'このイベントにシーンはありません。新しいシーンはこのイベント内に作成されます。';

  @override
  String uiStoryline(String p1) {
    return 'ストーリーライン：$p1';
  }

  @override
  String get uiTheSpecifiedEventWasNotFoundANew =>
      '指定のイベントが見つかりません。このストーリーライン内に新しいイベントを作成します。';

  @override
  String get uiGlobalPreview => '全体プレビュー';

  @override
  String get uiTheSpecifiedStorylineWasNotFoundANew =>
      '指定のストーリーラインが見つかりません。新しいストーリーライン、イベント、シーンを作成します。';

  @override
  String get uiCharacterSnapshot => 'キャラクターのスナップショット';

  @override
  String get uiCharacterSnapshotScene => 'キャラクターのスナップショット用シーン';

  @override
  String get uiNewScene => '新しいシーン';

  @override
  String get uiAddSceneSnapshot => 'シーンのスナップショットを追加';

  @override
  String uiDuplicate(String p1) {
    return '$p1を複製';
  }

  @override
  String get uiLinkToScene => 'シーンに関連付け';

  @override
  String get uiQuickCreateScene => '＋ シーンをすばやく作成';

  @override
  String get uiSceneHierarchy => 'シーンの階層';

  @override
  String get uiStorylineSelectExistingOrEnterAName =>
      'ストーリーライン（既存を選択、または名前を入力）';

  @override
  String get uiForExampleActOne => '例：第一幕';

  @override
  String get uiEventSelectExistingOrEnterAName => 'イベント（既存を選択、または名前を入力）';

  @override
  String get uiForExampleConflictAtTheGate => '例：城門での衝突';

  @override
  String get uiSceneName => 'シーン名';

  @override
  String get uiForExampleArrivingAtTheGate => '例：城門に到着';

  @override
  String get uiTimelineTick => 'タイムラインの Tick';

  @override
  String uiEnterToOrClickOrDragTheScrubber(String p1, String p2) {
    return '$p1～+$p2 を入力するか、上の再生ヘッドをクリック・ドラッグしてください。';
  }

  @override
  String uiTickMustBeBetweenAnd(String p1, String p2) {
    return 'Tick は $p1～+$p2 の範囲で指定してください。';
  }

  @override
  String get uiInitialContent => '初期内容';

  @override
  String get uiEmptyState => '空の状態';

  @override
  String uiCopyFrom(String p1) {
    return 'コピー元：$p1';
  }

  @override
  String get uiSpecificSnapshot => '指定のスナップショット';

  @override
  String get uiCopiesTheCompleteDerivedStateAtTheSource =>
      'コピー元の時点で導出された完全な状態をコピーします。';

  @override
  String get uiEnterNamesForTheStorylineEventAndScene =>
      'ストーリーライン、イベント、シーンの名前を入力してください。';

  @override
  String get uiCreateSnapshot => 'スナップショットを作成';

  @override
  String uiCopiedFrom(String p1) {
    return '$p1からコピー';
  }

  @override
  String get uiSceneSnapshotAdded => 'シーンのスナップショットを追加しました。';

  @override
  String uiMovedToTick(String p1) {
    return 'Tick $p1 へ移動しました';
  }

  @override
  String get uiIdentitySettings => '識別設定';

  @override
  String get uiAnCharacterNanoIDDistinguishesCharactersWithTheSame =>
      '同名のキャラクターを識別するための 8 文字の NanoID です。';

  @override
  String get uiDetailedProfileAndAppearance => '詳細プロフィールと外見';

  @override
  String get uiResidenceFeaturesAndClothing => '居住地、顔立ち、服装';

  @override
  String get uiPersonalityTools => '性格ツール';

  @override
  String get uiHabitsAlignmentAndPersonalityScales => '習慣、属性、性格の尺度';

  @override
  String get uiPreferencesAndAbilities => '好みと能力';

  @override
  String get uiAbilityListsAndEverydaySkillScales => '能力の一覧と生活技能の尺度';

  @override
  String get uiSocialQuestionnaire => '社交に関する質問';

  @override
  String get uiSocialBehaviorTendenciesAndRomance => '社交行動、傾向、恋愛の概要';

  @override
  String get uiOtherLegacyFields => 'その他の旧フィールド';

  @override
  String get uiOriginalLanguageNamePreferencesAndExtraNotes => '原語の名前、好き嫌い、補足';

  @override
  String get uiText => 'テキスト';

  @override
  String get uiSlider => 'スライダー';

  @override
  String get uiCheckbox => 'チェックボックス';

  @override
  String get uiList => 'リスト';

  @override
  String get uiFieldName => 'フィールド名';

  @override
  String get uiDataType => 'データ型';

  @override
  String get uiNoCustomData => 'カスタムデータがありません';

  @override
  String get uiEnterAFieldNameSelectItsTypeAnd => 'フィールド名を入力し、型を選択して追加してください。';

  @override
  String uiRemove(String p1) {
    return '$p1を削除';
  }

  @override
  String get uiBirthplace => '出生地：';

  @override
  String get uiResidence => '居住地：';

  @override
  String get uiAddress => '住所：';

  @override
  String get uiAppearance => '外見';

  @override
  String get uiBloodType => '血液型：';

  @override
  String get uiSkinColor => '肌の色：';

  @override
  String get uiFaceShape => '顔の形：';

  @override
  String get uiEyeShape => '目の形：';

  @override
  String get uiEarShape => '耳の形：';

  @override
  String get uiNoseShape => '鼻の形：';

  @override
  String get uiMouthShape => '口の形：';

  @override
  String get uiEyebrowShape => '眉の形：';

  @override
  String get uiBuild => '体格：';

  @override
  String get uiClothing => '服装：';

  @override
  String get uiCatchphrasesAndExpressions => '口癖・よく使う表現：';

  @override
  String get uiInterests => '趣味：';

  @override
  String get uiHabitsAndQuirks => '習慣・癖：';

  @override
  String get uiFaith => '信仰：';

  @override
  String get uiBoundaries => '譲れないこと';

  @override
  String get uiWhatDoTheyWantToBecome => '将来どのようになりたい？';

  @override
  String get uiWhatDoTheyValueMost => '最も大切なものは？';

  @override
  String get uiWhatDoTheyDespiseMost => '最も嫌いなものは？';

  @override
  String get uiWhatDoTheyFearMost => '最も恐れているものは？';

  @override
  String get uiWhatIntriguesThemMost => '最も興味があるものは？';

  @override
  String get uiWhatDoTheyLookForwardToMost => '最も楽しみにしていることは？';

  @override
  String get uiAlignment => '属性';

  @override
  String get uiPersonalityTraits => '性格の特徴';

  @override
  String get uiApproachToLife => '行動傾向';

  @override
  String get uiAdditionalNotes => '補足：';

  @override
  String get uiThingsTheyLoveDoing => '大好きなこと';

  @override
  String get uiThingsTheyWantToTry => 'まだ実現していないやりたいこと';

  @override
  String get uiThingsTheyDislikeDoing => '嫌いなこと';

  @override
  String get uiThingsTheyFearDoing => 'するのが怖いこと';

  @override
  String get uiThingsTheyDoWell => '得意なこと';

  @override
  String get uiThingsTheyStruggleWith => '苦手なこと';

  @override
  String get uiEverydaySkills => '生活で使う技能';

  @override
  String get uiOthersImpressions => '周囲からの印象';

  @override
  String get uiMostAdmiredOrLovedQualities => '周囲に好かれる・評価される特徴';

  @override
  String get uiFamilyBackground => '育った家庭の概要';

  @override
  String get uiHowTheyExpressAffection => '好意の表し方';

  @override
  String get uiOther => 'その他';

  @override
  String get uiHowTheyShowKindness => '親切の表し方';

  @override
  String get uiHowDoTheyHandlePeopleTheyDislike => '苦手な相手への接し方は？';

  @override
  String get uiRomanticRelationships => '恋愛関係';

  @override
  String get uiSocialTendencies => '社交に関する傾向';

  @override
  String get uiOriginalLanguageName => '原語での名前';

  @override
  String get uiForExample2 => '例：桜田如羽';

  @override
  String get uiThingsTheyLike => '好きなもの';

  @override
  String get uiThingsTheyAdmire => '憧れのもの';

  @override
  String get uiThingsTheyDislike => '嫌いなもの';

  @override
  String get uiThingsTheyFear => '怖いもの';

  @override
  String get uiFamiliarThings => '慣れ親しんだもの';

  @override
  String get uiAdditionalNotes2 => '補足';

  @override
  String get uiCharacterRelationships3 => '人物関係';

  @override
  String get uiNoCharacterRelationships => '人物関係がありません';

  @override
  String get uiEnterACharacterAndExternalInternalRelationshipsBelow =>
      '下に人物と表向き・内面的な関係を入力して追加してください。';

  @override
  String get uiSelectACharacterOrEnterAName => 'キャラクターを選択、または名前を入力';

  @override
  String get uiExternalRelationshipOptional => '表向きの関係（省略可）';

  @override
  String get uiInternalRelationshipOptional => '内面的な関係（省略可）';

  @override
  String get uiUpdate => '更新';

  @override
  String uiNoYet(String p1) {
    return '$p1がありません';
  }

  @override
  String uiOptional(String p1) {
    return '$p1（省略可）';
  }

  @override
  String get uiPossessions => '所持品';

  @override
  String get uiQuantity => '数量';

  @override
  String get uiNoPossessions => '所持品がありません';

  @override
  String get uiEnterAnItemQuantityAndDescriptionBelowThen =>
      '下にアイテム、数量、説明を入力して追加してください。';

  @override
  String get uiDescriptionOptional => '説明（省略可）';

  @override
  String get uiConvertToManagedItem => '正式なアイテムに変換';

  @override
  String get uiTheseAreLegacyPossessionsConvertEachEntryTo =>
      '以下は旧形式の所持品です。一件ずつ正式なアイテムへ変換してください。この画面では旧形式のデータを新規追加できません。';

  @override
  String uiQuantity2(String p1) {
    return '数量：$p1';
  }

  @override
  String get uiLiteral => '・';

  @override
  String get uiDeleteLegacyEntry => '旧データを削除';

  @override
  String get uiUnknown => '不明';

  @override
  String get uiRelatedItems => '関連アイテム';

  @override
  String get uiLinkItem => 'アイテムを関連付け';

  @override
  String get uiNoRelatedItemsAreConfigured => '関連アイテムが設定されていません。';

  @override
  String get uiOpenItems => 'アイテム画面を開く';

  @override
  String get uiUnlink => '関連付けを解除';

  @override
  String get uiCurrentlyHeldItems => '現在の所持アイテム';

  @override
  String get uiAssignItem => 'アイテムを割り当て';

  @override
  String get uiNoLinkedItems => '関連付けたアイテムがありません';

  @override
  String get uiSelectAssignItemToSetTheHolderOr =>
      '「アイテムを割り当て」から持ち主や合計数量を設定できます。';

  @override
  String get uiStatusNotes => '状態／メモ';

  @override
  String get uiActions => '操作';

  @override
  String get uiClearDefaultAssignment => '既定の割り当てを解除';

  @override
  String get uiSelectAnItemToAssignToTheCharacter => 'キャラクターに割り当てるアイテムを選択';

  @override
  String uiAssign(String p1) {
    return '「$p1」を割り当て';
  }

  @override
  String get uiLeaveBlankIfTheQuantityIsUnknown => '数量が不明な場合は空欄にしてください。';

  @override
  String get uiAssign2 => '割り当て';

  @override
  String get uiQuantityMustBeZeroOrAPositiveInteger =>
      '数量には 0 または正の整数を指定してください。';

  @override
  String uiCouldNotAssignTheItem(String p1) {
    return 'アイテムを割り当てできませんでした：$p1';
  }

  @override
  String uiConvert(String p1) {
    return '「$p1」を変換';
  }

  @override
  String get uiRemovesMatchingLegacyEntriesFromTheDefaultCharacter =>
      'キャラクターの既定データと特定できるシーンのスナップショットから、同名の旧データを削除し、正式なアイテムの状態を作成します。';

  @override
  String get uiLinkExisting => '既存と関連付け';

  @override
  String get uiCreateAndConvert => '作成して変換';

  @override
  String uiSelectTheManagedItemFor(String p1) {
    return '「$p1」に対応する正式なアイテムを選択';
  }

  @override
  String get uiConfirmPossessionConversion => '所持品の変換を確認';

  @override
  String uiDefaultBaselineEntries(String p1) {
    return '既定／基準データ：$p1 件';
  }

  @override
  String uiSceneSnapshotEntries(String p1) {
    return 'シーンのスナップショット：$p1 件';
  }

  @override
  String uiLegacyCharacterStateEntriesWithoutReliableSceneLinksTheir(
    String p1,
  ) {
    return 'シーンを確実に特定できない旧 CharacterState が $p1 件あります。元の文字列を保持します。';
  }

  @override
  String get uiApplyConversion => '変換を適用';

  @override
  String uiPossessionConversionFailed(String p1) {
    return '所持品の変換に失敗しました：$p1';
  }

  @override
  String get uiCreateManagedItem => '正式なアイテムを作成';

  @override
  String get uiItemName => 'アイテム名';

  @override
  String get uiItemMode => 'アイテムの管理方式';

  @override
  String get uiDedicatedIndependentID => '専用（独立した ID を作成）';

  @override
  String get uiSemiDedicatedOneInstanceInADefinition => '半専用（定義内に一つ作成）';

  @override
  String get uiNonDedicatedKeepQuantity => '非専用（数量を保持）';

  @override
  String get uiSelectACharacterRelatedItemToLink => '関連付けるキャラクターのアイテムを選択';

  @override
  String get uiRelated => '関連';

  @override
  String get uiOther2 => 'その他：';

  @override
  String get uiOther3 => 'その他…';

  @override
  String get uiLookingForNewLove => '新しい恋を探している？';

  @override
  String get uiHaremStory => 'ハーレム作品？';

  @override
  String get uiCompactTimeline => '簡易タイムライン';

  @override
  String get uiClickOrDragToSelectTimeDiamondsMark =>
      'クリック・ドラッグして時刻を選択 · ひし形は既存のスナップショット';

  @override
  String get uiCouldNotLoadSecureCopilotSettingsTheAPI =>
      'Copilot の安全な設定を読み込めなかったため、API キーは読み込んでいません。';

  @override
  String uiModelsRetrieved(String p1) {
    return '取得したモデル：$p1 件。';
  }

  @override
  String uiAlongWith(String p1) {
    return 'と $p1';
  }

  @override
  String get uiSendYourWorkSContent => '作品の内容を送信しますか？';

  @override
  String uiThisModeSendsTheCurrentChapterToData(
    String p1,
    String p2,
    String p3,
    String p4,
  ) {
    return 'このモードでは現在の章「$p1」$p2を $p3 へ送信します。データは選択したモデルサービスへ直接送られます。作品内容を含まない、内蔵の .mnproj 形式説明も添付します。$p4';
  }

  @override
  String get uiYourConfiguredAPIKeyWillAlsoBeSent => '設定済みの API キーも送信されます。';

  @override
  String get uiAllowThisConnection => '今回の接続を許可';

  @override
  String get uiSendAPIKey => 'API キーを送信しますか？';

  @override
  String uiTheAPIKeyWillBeSentDirectlyTo(String p1) {
    return 'API キーは $p1 に直接送信されます。信頼できるモデルサービスであることを確認してください。';
  }

  @override
  String get uiRequestCancelled => 'リクエストをキャンセルしました。';

  @override
  String get uiSelectOrEnterAModelFirst => '先にモデルを選択するか入力してください。';

  @override
  String get uiSettingsChangedThePreviousRequestWasCancelled =>
      '設定が変更されたため、以前のリクエストをキャンセルしました。';

  @override
  String get uiSettingsChangedThePreviousRequestResultWasDiscarded =>
      '設定が変更されたため、以前のリクエスト結果を破棄しました。';

  @override
  String get uiNoAPIKeyIsSaved => '保存済みの API キーはありません。';

  @override
  String get uiClearAPIKey => 'API キーを削除しますか？';

  @override
  String get uiThisRemovesTheAPIKeyFromThisDevice =>
      'この端末の安全な保存領域から API キーを削除します。作品や会話の内容は変わりません。';

  @override
  String get uiClearKey => 'キーを削除';

  @override
  String get uiAPIKeyRemovedFromThisDevice => 'この端末から API キーを削除しました。';

  @override
  String get uiCouldNotRemoveTheAPIKeyTryAgain =>
      'API キーを削除できませんでした。しばらくしてからお試しください。';

  @override
  String get uiAskPlanBetaAreControlledByFeatureFlags =>
      'Ask／Plan Beta は機能フラグで制御され、現在の章を読み取るだけでプロジェクトを変更しません。Agent は利用できません。';

  @override
  String get uiModelSelection => 'モデル選択';

  @override
  String get uiCustom => 'カスタム';

  @override
  String get uiProvider => 'プロバイダー';

  @override
  String get uiModel => '使用するモデル';

  @override
  String get uiSelectOrEnterAModelID => 'モデル ID を選択または入力';

  @override
  String get uiFetch => '取得';

  @override
  String get uiHideAPIKey => 'API キーを隠す';

  @override
  String get uiShowAPIKey => 'API キーを表示';

  @override
  String get uiClearSavedKey => '保存したキーを削除';

  @override
  String get uiPrivacyThirdPartyServicesAndLimitations => 'プライバシー・外部サービス・制限事項';

  @override
  String get uiChatSendsYourMessagesAskPlanAlsoSend =>
      'Chat は入力したメッセージを送信します。Ask／Plan は画面に表示した作品のコンテキストも送信します。データは設定したプロバイダーと API URL へ直接送られ、物語アシスタントのサーバーを経由しません。';

  @override
  String get uiWhetherAProviderStoresOrUsesDataDepends =>
      '外部プロバイダーによるデータの保存・利用は、サービスの規約とアカウント設定に従います。localhost の Ollama は端末内で動作できますが、その他のカスタム URL が非公開とは限りません。';

  @override
  String get uiConversationsAndPlansExistOnlyForThisScreen =>
      '会話と Plan は現在の画面セッション内のみ保持します。プロジェクトには保存せず、再起動後も復元しません。';

  @override
  String get uiAIResponsesMayBeIncorrectPlansAreFor =>
      'AI の回答には誤りが含まれる場合があります。Plan は確認とエクスポート専用で、作品を自動変更しません。Agent は無効です。';

  @override
  String get uiConversationHistory => '会話履歴';

  @override
  String get uiClearAll => 'すべて消去';

  @override
  String get uiNoConversations => '会話履歴がありません';

  @override
  String get uiMessagesWillAppearHereAfterYouSendThem => '送信したメッセージがここに表示されます。';

  @override
  String get uiYou => 'あなた';

  @override
  String get uiTheModelSuppliedNoVerifiableStructuredSources =>
      'モデルから検証可能な構造化された出典は提供されませんでした。';

  @override
  String uiCouldNotValidateThePlanTheOriginalResponse(String p1) {
    return 'Plan を検証できませんでした：$p1\nモデルの元の回答を保持し、変更は適用していません。';
  }

  @override
  String get uiTheModelSuppliedNoVerifiableSources =>
      'モデルから検証可能な出典は提供されませんでした。';

  @override
  String get uiSources => '出典';

  @override
  String uiUncertain(String p1) {
    return '不確かな点：$p1';
  }

  @override
  String get uiInvalidSourcesSuppliedByTheModelWereIgnored =>
      'モデルが提供した無効な出典を無視しました。';

  @override
  String uiOpenSource(String p1) {
    return '出典を開く：$p1';
  }

  @override
  String get uiPlanJSONCopied => 'Plan の JSON をコピーしました。';

  @override
  String get uiPlanJSONExported => 'Plan の JSON をエクスポートしました。';

  @override
  String get uiCouldNotExportThePlanJSONCheckThe =>
      'Plan の JSON をエクスポートできませんでした。保存先とファイルの権限を確認してください。';

  @override
  String get uiCopyPlanJSON => 'Plan の JSON をコピー';

  @override
  String get uiExportPlanJSON => 'Plan の JSON をエクスポート';

  @override
  String get uiTheCurrentChapterChangedThisPlanMayBe =>
      '現在の章が変更されたため、この Plan は古い可能性があります。';

  @override
  String uiRisk(String p1) {
    return 'リスク：$p1';
  }

  @override
  String uiToConfirm(String p1) {
    return '要確認：$p1';
  }

  @override
  String get uiReadOnlyPlanNoChangesApplied => '読み取り専用の Plan · 変更は未適用';

  @override
  String get uiCurrentChapter => '現在の章';

  @override
  String get uiCurrentChapterAndProjectIndexSummary => '現在の章とプロジェクト索引の概要';

  @override
  String get uiCurrentChapterAndSelectedSupplementalResources =>
      '現在の章と選択した補足資料';

  @override
  String uiSendsDirectlyToYourConfiguredModelServiceWithout(
    String p1,
    String p2,
  ) {
    return '$p1 は$p2を設定済みのモデルサービスへ直接送信し、プロジェクトは変更しません。';
  }

  @override
  String uiSelectSupplementalResources(String p1, String p2) {
    return '補足資料を選択（$p1/$p2）';
  }

  @override
  String get uiEnterAMessageShiftEnterForANew =>
      'メッセージを入力。Shift+Enter で改行、Enter で送信';

  @override
  String get uiAskAboutTheCurrentChapter => '現在の章について質問';

  @override
  String get uiDescribeTheChangesYouWantToPlan => '計画したい変更の目的を入力';

  @override
  String get uiAgentIsUnavailable => 'Agent は利用できません';

  @override
  String get uiCancelRequest => 'リクエストをキャンセル';

  @override
  String get uiSend => '送信';

  @override
  String get uiShiftEnterNewLineEnterSend => 'Shift+Enter：改行 · Enter：送信';

  @override
  String get uiModeSelection => 'モード選択';

  @override
  String get uiAgentUnavailable => 'Agent（利用不可）';

  @override
  String get uiAskContext => 'Ask のコンテキスト';

  @override
  String get uiCurrentChapterProjectSummary => '現在の章＋プロジェクト概要';

  @override
  String get uiCurrentChapterSelectedResources => '現在の章＋選択した資料';

  @override
  String get uiSelectAskSupplementalResources => 'Ask の補足資料を選択';

  @override
  String get uiSearchCharactersWorldbuildingOutlinesOrWords =>
      'キャラクター、世界観、アウトライン、語句を検索';

  @override
  String uiSelectedOnlySelectedResourcesAreSent(String p1, String p2) {
    return '選択済み $p1/$p2。選択した資料の内容のみ送信します。';
  }

  @override
  String get uiNoMatchingResources => '一致する資料がありません。';

  @override
  String get uiClear => 'クリア';

  @override
  String get uiUseSelection => '選択した項目を使用';

  @override
  String get uiTruncated => '、切り詰め済み';

  @override
  String get uiProjectIndexSummaryUpToKiB => '＋プロジェクト索引の概要（上限 24 KiB）';

  @override
  String uiSelectedResourcesUpToKiB(String p1) {
    return '＋選択した補足資料 $p1 件（上限 32 KiB）';
  }

  @override
  String uiContextBytes(String p1, String p2, String p3, String p4) {
    return 'コンテキスト：$p1（$p2 バイト$p3）$p4';
  }

  @override
  String get uiContextNoChapterSelected => 'コンテキスト：章が未選択';

  @override
  String get uiUnknownCategory => '不明な分類';

  @override
  String get uiExportWordReference => '表現辞典をエクスポート';

  @override
  String get uiExportFailedCouldNotWriteTheFile => 'エクスポート失敗：ファイルを書き込めませんでした。';

  @override
  String uiExportComplete2(String p1, String p2) {
    return 'エクスポート完了：$p1\n$p2';
  }

  @override
  String get uiEmptyEntry => '（空の項目）';

  @override
  String get uiUnnamedCategory => '（名前のない分類）';

  @override
  String get uiImportPreview => 'インポートのプレビュー';

  @override
  String uiCategoriesToAdd(String p1) {
    return '追加する分類：$p1';
  }

  @override
  String uiCategoriesToMerge(String p1) {
    return '既存の分類へ統合：$p1';
  }

  @override
  String uiNewEntriesToImport(String p1) {
    return '新規インポートする項目：$p1';
  }

  @override
  String uiExistingEntriesToReuse(String p1) {
    return '再利用する既存項目：$p1';
  }

  @override
  String uiCategoryEntryLinksToAdd(String p1) {
    return '追加する分類と項目の関連：$p1';
  }

  @override
  String get uiNewCategoriesUpToShown => '新しい分類（最大 6 件表示）';

  @override
  String get uiNewEntriesUpToShown => '新しい項目（最大 6 件表示）';

  @override
  String get uiConfirmImport => 'インポートを確認';

  @override
  String get uiInvalidImportFileFormat => 'インポートファイルの形式が無効です';

  @override
  String uiImportCompleteNewCategoriesNewEntriesReusedEntries(
    String p1,
    String p2,
    String p3,
    String p4,
  ) {
    return 'インポート完了。新規分類：$p1、新規項目：$p2、再利用項目：$p3、関連付け：$p4。';
  }

  @override
  String get uiAddCategory => '分類を追加';

  @override
  String get uiAddSubcategory => '下位分類を追加';

  @override
  String get uiEnterACategoryName => '分類名を入力';

  @override
  String get uiDeleteCategory => '分類を削除';

  @override
  String uiDeleteAndItsSubcategories(String p1) {
    return '「$p1」とその下位分類を削除しますか？';
  }

  @override
  String get uiRemoveEntry => '項目を削除';

  @override
  String uiRemoveFrom(String p1, String p2) {
    return '「$p1」から「$p2」を削除しますか？';
  }

  @override
  String uiGroup(String p1) {
    return '第 $p1 組';
  }

  @override
  String get uiDeleteThisGroup => 'この組を削除';

  @override
  String get uiMeaning => '意味';

  @override
  String get uiExample => '例文';

  @override
  String get uiThisFeatureIsInDevelopmentAndMayContain =>
      'この機能は開発中のため、エラーが発生する場合があります。';

  @override
  String get uiWordCategories => '語句の分類';

  @override
  String get uiAddRootCategory => '最上位の分類を追加';

  @override
  String get uiImportExport => 'インポート／エクスポート';

  @override
  String get uiImport2 => 'インポート…';

  @override
  String get uiExportDisabled => 'エクスポート…（無効）';

  @override
  String get uiExportSelectedCategory => '選択した分類をエクスポート';

  @override
  String get uiExportAll => 'すべてエクスポート';

  @override
  String get uiLongPressCardsToDragReorderOrMove =>
      'カードを長押ししてドラッグすると、並べ替えや下位分類への移動ができます。';

  @override
  String get uiNoWordCategories => '語句の分類がありません';

  @override
  String get uiAddYourFirstCategory => '最初の分類を追加してください。';

  @override
  String get uiUnnamedCategory2 => '（名前のない分類）';

  @override
  String uiEntries(String p1) {
    return '合計 $p1 件';
  }

  @override
  String get uiCategoryActions => '分類の操作';

  @override
  String get uiCollapseSubcategories => '下位分類を折りたたむ';

  @override
  String get uiExpandSubcategories => '下位分類を展開';

  @override
  String get uiRename => '名前を変更';

  @override
  String get uiMoveBefore => '前へ移動';

  @override
  String get uiMoveToSubcategory => '下位分類へ移動';

  @override
  String get uiMoveAfter => '後へ移動';

  @override
  String uiLiteral2(String p1, String p2) {
    return '「$p1」を$p2しました';
  }

  @override
  String uiMovedInto(String p1, String p2) {
    return '「$p1」を「$p2」へ移動しました。';
  }

  @override
  String get uiWordEntries => '語句の項目';

  @override
  String get uiSelectAWordCategoryFirst => '先に語句の分類を選択してください';

  @override
  String get uiLongPressEntriesToDragReorderOrMove =>
      '項目を長押ししてドラッグすると、並べ替えや別の分類への移動ができます。';

  @override
  String get uiThisCategoryHasNoEntries => 'この分類に項目はありません。';

  @override
  String get uiAddYourFirstEntry => '最初の項目を追加してください。';

  @override
  String get uiEntryName => '項目名';

  @override
  String get uiNoMeaningEnteredYet => '意味が未入力です';

  @override
  String uiPartOfSpeech(String p1) {
    return '品詞：$p1';
  }

  @override
  String get uiSourceThisCategory => '出典：この分類';

  @override
  String uiSourceSubcategory(String p1) {
    return '出典：下位分類 $p1';
  }

  @override
  String get uiRemoveFromThisCategory => 'この分類から削除';

  @override
  String uiMovedTo(String p1, String p2) {
    return '「$p1」を「$p2」へ移動しました。';
  }

  @override
  String get uiMeaningsAndExamples => '意味と例文';

  @override
  String get uiSelectAnEntryAbove => '上から項目を選択してください。';

  @override
  String get uiPartOfSpeech2 => '品詞';

  @override
  String get uiCustomPartOfSpeech => 'カスタム品詞';

  @override
  String get uiSentiment => '感情の傾向';

  @override
  String get uiMeaningAndExampleGroups => '意味と例文の組';

  @override
  String get uiAddGroup => '組を追加';

  @override
  String get uiCouldNotLoadWordData => '語句のデータを読み込めませんでした';

  @override
  String get uiWordReference => '表現辞典';

  @override
  String get uiNewItem => '新しいアイテム';

  @override
  String get uiArchiveItem => 'アイテムをアーカイブ';

  @override
  String uiArchiveExistingLinksAndHistoricalSnapshotsWillBe(
    String p1,
    String p2,
  ) {
    return '「$p1」をアーカイブしますか？既存の関連と履歴のスナップショットは保持し、個別アイテム $p2 件もまとめてアーカイブします。';
  }

  @override
  String get uiUnnamedItem => '名前のないアイテム';

  @override
  String get uiArchive => 'アーカイブ';

  @override
  String uiIndividual(String p1) {
    return '$p1（個別）';
  }

  @override
  String get uiTheItemOrSceneChangedReopenThePreview =>
      'アイテムまたはシーンが更新されました。プレビューを開き直してから確定してください。';

  @override
  String get uiCreateACharacterLocationOrEventBeforeAdding =>
      '先にキャラクター、場所、出来事を作成してからアイテムの関連を追加してください。';

  @override
  String get uiAddItemLink => 'アイテムの関連を追加';

  @override
  String uiIndividual2(String p1) {
    return '個別：$p1';
  }

  @override
  String get uiChooseLinkTarget => 'リンク先を選択';

  @override
  String get uiRelationshipPurpose => '関係・用途';

  @override
  String get uiAddLink => '関連を追加';

  @override
  String get uiCreateACharacterOrLocationBeforeAddingA =>
      '数量を割り当てる前に、人物または場所を作成してください。';

  @override
  String get uiAddQuantityAllocation => '数量割り当てを追加';

  @override
  String get uiAllocateTo => '割り当て先';

  @override
  String get uiAddAllocation => '割り当てを追加';

  @override
  String get uiQuantityMustBeZeroOrAPositiveInteger2 =>
      '数量は 0 以上の整数で入力してください。不明な場合は空欄にできます。';

  @override
  String get uiATransferRequiresAtLeastOneSceneAnd =>
      '移動には、少なくとも 1 つのシーンと、別の人物または場所が必要です。';

  @override
  String get uiTransferAggregateQuantity => '集計数量を移動';

  @override
  String get uiTransferTo => '移動先';

  @override
  String get uiQuantityToTransfer => '移動数量';

  @override
  String get uiSourceQuantityAfterTransfer => '移動後の移動元数量';

  @override
  String get uiSourceQuantityIsUnknownSetItExplicitly =>
      '移動元の数量が不明です。明示的に設定してください。';

  @override
  String get uiDestinationQuantityAfterTransfer => '移動後の移動先数量';

  @override
  String get uiDestinationQuantityIsUnknownSetItExplicitly =>
      '移動先の数量が不明です。明示的に設定してください。';

  @override
  String get uiCreateTransferSnapshot => '移動スナップショットを作成';

  @override
  String get uiAddTheSceneToTheTimelineBeforeSeparating =>
      '個別アイテムを分離する前に、シーンをタイムラインに配置してください。';

  @override
  String get uiCreateDedicatedItem => '専用アイテムを作成';

  @override
  String get uiSeparateItemFromAggregateQuantity => '集計数量から個別アイテムを分離';

  @override
  String get uiCreatedInScene => '作成シーン';

  @override
  String get uiThisAggregateAllocationDoesNotExistInThe =>
      '選択したシーンには、この集計割り当てがまだありません。';

  @override
  String get uiSourceQuantityIsUnknownInTheSelectedScene =>
      '選択したシーンの移動元数量が不明です。';

  @override
  String uiSourceQuantityInSelectedScene(String p1) {
    return '選択したシーンの移動元数量：$p1';
  }

  @override
  String get uiIndividualItemName => '個別アイテム名';

  @override
  String get uiSourceQuantityAfterSeparation => '分離後の移動元数量';

  @override
  String get uiConversionNotes => '変換メモ';

  @override
  String get uiCreateIndividualItem => '個別アイテムを作成';

  @override
  String get uiCreatedAnIndividualItemFromTheAggregateQuantity =>
      '集計数量から個別アイテムを作成しました。';

  @override
  String get uiAddTheSceneToTheTimelineBeforeConverting =>
      '非専用に変換する前に、シーンをタイムラインに配置してください。';

  @override
  String get uiSafelyConvertToNonDedicated => '安全に非専用へ変換';

  @override
  String get uiConversionScene => '変換シーン';

  @override
  String uiAggregateExistingIndividualItemsIntoQuantityAllocations(
    String p1,
    String p2,
  ) {
    return 'その時点で存在する $p1 個の個別アイテムを集計し、$p2 件の数量割り当てを作成します。';
  }

  @override
  String get uiTheOriginalClassInstanceIDsSnapshotsAndGeneral =>
      '元のクラス、インスタンス ID、スナップショット、一般的な関連は履歴として保持されます。';

  @override
  String get uiCreateAggregateClass => '集計クラスを作成';

  @override
  String get uiCreatedANewNonDedicatedAggregateClass => '新しい非専用の集計クラスを作成しました。';

  @override
  String get uiConvertingToDedicatedModeRequiresOneAllocationWith =>
      '専用への変換には、数量 1 の割り当てが 1 件だけ必要です。先に半専用へ切り替え、個別に分離できます。';

  @override
  String get uiMultipleFixedIDsCannotBeMergedDirectlyInto =>
      '複数の固定 ID があるため、1 つの専用アイテムに直接統合できません。';

  @override
  String get uiSeparateAllRemainingAggregateQuantitiesBeforeConvertingTo =>
      '未分離の集計数量が残っています。すべて個別に分離してから専用に変換してください。';

  @override
  String get uiMoveWorldbuildingItems => '世界設定のアイテムを移動';

  @override
  String uiMoveWorldbuildingItemsToTheItemsPageIDs(String p1) {
    return '世界設定のアイテム $p1 件を独立したアイテムページに移動します。ID、内容、元のパスは保持されます。';
  }

  @override
  String get uiMove => '移動';

  @override
  String uiMovedItems(String p1, String p2) {
    return 'アイテム $p1 件を移動しました$p2';
  }

  @override
  String uiNeedAttention(String p1) {
    return '、$p1 件に確認が必要です';
  }

  @override
  String get uiAddTheSceneToTheTimelineBeforeAdding =>
      'アイテムのスナップショットを追加する前に、シーンをタイムラインに配置してください。';

  @override
  String get uiAddItemSceneSnapshot => 'アイテムのシーンスナップショットを追加';

  @override
  String get uiDuplicateItemSceneSnapshot => 'アイテムのシーンスナップショットを複製';

  @override
  String get uiExistsAtThisPoint => 'この時点で存在する';

  @override
  String get uiHolder => '所持者';

  @override
  String uiNotFound(String p1) {
    return '見つかりません：$p1';
  }

  @override
  String get uiLocation2 => '所在地';

  @override
  String get uiAddTheSceneToTheTimelineBeforeAdding2 =>
      '個別アイテムのスナップショットを追加する前に、シーンをタイムラインに配置してください。';

  @override
  String uiSceneSnapshot(String p1, String p2) {
    return '$p1「$p2」のシーンスナップショット';
  }

  @override
  String get uiItemSettings => 'アイテム設定';

  @override
  String uiMoveItemsFromWorldbuilding(String p1) {
    return '世界設定からアイテム $p1 件を移動';
  }

  @override
  String get uiAddItem => 'アイテムを追加';

  @override
  String get uiSelectAnItemFirst => 'アイテムを選択してください';

  @override
  String get uiSelectAnItemToPreviewItsTimelineAnd =>
      'アイテムを選択すると、タイムラインのプレビューとスナップショットの管理ができます';

  @override
  String get uiItemList => 'アイテム一覧';

  @override
  String get uiSearchItems => 'アイテムを検索';

  @override
  String get uiManagementMode => '管理モード';

  @override
  String get uiOwnership => '所有';

  @override
  String get uiAssigned => '割り当て済み';

  @override
  String get uiUnassigned => '未割り当て';

  @override
  String get uiCategory => '分類';

  @override
  String get uiAllCategories => 'すべての分類';

  @override
  String get uiNoItemsYet => 'アイテムがありません';

  @override
  String get uiAddYourFirstItem => '最初のアイテムを追加';

  @override
  String uiIndividualItemsLinks(String p1, String p2, String p3, String p4) {
    return '$p1 · 個別 $p2 個 · 関連 $p3 件$p4';
  }

  @override
  String get uiAssigned2 => ' · 割り当て済み';

  @override
  String get uiEditItem => 'アイテムを編集';

  @override
  String get uiItemDetails => 'アイテムの詳細';

  @override
  String get uiSelectOrAddAnItem => 'アイテムを選択または追加';

  @override
  String get uiItemModeSnapshotsOwnershipAndLinksAppearHere =>
      'アイテムのモード、スナップショット、所有、関連がここに表示されます';

  @override
  String get uiDeleteCurrentSnapshot => '現在のスナップショットを削除';

  @override
  String get uiNoSnapshotSelected => 'スナップショットが選択されていません';

  @override
  String get uiCurrentStoryState => '現在の物語の状態';

  @override
  String get uiNoSnapshots => 'スナップショットなし';

  @override
  String get uiExists => '存在する';

  @override
  String get uiDoesNotExistYet => 'まだ存在しない';

  @override
  String get uiStateNotSet => '状態未設定';

  @override
  String uiHolder2(String p1) {
    return '所持者：$p1';
  }

  @override
  String uiLocation3(String p1) {
    return '所在地：$p1';
  }

  @override
  String uiSnapshotHistory(String p1) {
    return 'スナップショット履歴（$p1）';
  }

  @override
  String get uiLinkThisScene => 'このシーンをリンク';

  @override
  String get uiRemoveSnapshot => 'スナップショットを削除';

  @override
  String get uiDoesNotExistInThisScene => 'このシーンではまだ存在しない';

  @override
  String get uiExistsInThisScene => 'このシーンで存在する';

  @override
  String get uiName2 => '名前';

  @override
  String get uiQuantityUnit => '数量の単位';

  @override
  String get uiDescription => '設定の説明';

  @override
  String get uiIndividualItems => '個別アイテム';

  @override
  String get uiAddIndividualItem => '個別アイテムを追加';

  @override
  String get uiNoIndividualItemsCreatedYet => '個別アイテムはまだ作成されていません。';

  @override
  String get uiLinks => '関連';

  @override
  String get uiNoCharactersLocationsOrEventsLinkedYet =>
      '人物、場所、イベントへの関連はまだありません。';

  @override
  String get uiRemoveLink => '関連を削除';

  @override
  String get uiNonDedicatedModeUsesClassesAndAggregateAllocations =>
      '非専用モードはクラスと集計割り当てで管理し、個別 ID は作成しません。';

  @override
  String get uiSemiDedicatedModeKeepsUnidentifiedAggregateQuantitiesAnd =>
      '半専用モードは未識別の集計数量を保持し、シーン内で固定 ID を個別に分離できます。';

  @override
  String get uiThisSectionShowsHistoricalAggregateQuantitiesFromBefore =>
      '専用に変換する前の集計数量の履歴を表示します。';

  @override
  String uiAllocatedQuantity(String p1, String p2, String p3) {
    return '割り当て数量：$p1$p2$p3';
  }

  @override
  String get uiPlusAnUnknownQuantity => '、ほかに数量不明あり';

  @override
  String get uiNoQuantityAllocatedYet => '数量はまだ割り当てられていません。';

  @override
  String get uiAllocationTargetNotFound => '割り当て先が見つかりません';

  @override
  String get uiUnallocated => '未割り当て';

  @override
  String get uiUnknownQuantity => '数量不明';

  @override
  String get uiSeparateIndividualItem => '個別アイテムを分離';

  @override
  String get uiRemoveDefaultAllocation => '既定の割り当てを削除';

  @override
  String get uiOutline => 'アウトライン';

  @override
  String get uiStorylines => 'ストーリーライン';

  @override
  String get uiNoStorylinesYet => 'ストーリーラインがありません';

  @override
  String get uiStorylineName => 'ストーリーライン名';

  @override
  String get uiStorylineTheBroadDirectionOfYourStoryUse =>
      'ストーリーライン：物語の大きな流れです。三幕構成、起承転結、物語の 7 ステップなどの構成を指定できます。';

  @override
  String get uiUntitledStoryline => '（無題のストーリーライン）';

  @override
  String get uiUntitledEvent => '（無題のイベント）';

  @override
  String get uiUntitledScene => '（無題のシーン）';

  @override
  String get uiStorylineDetails => 'ストーリーラインの詳細';

  @override
  String get uiTypeEGOpeningMiddleClimaxEnding => '種類（例：導入、中盤、クライマックス、結末）';

  @override
  String get uiMainConflict => '主な対立';

  @override
  String get uiEnterNotes => 'メモを入力…';

  @override
  String get uiEvents => 'イベント';

  @override
  String get uiNoEventsInThisStorylineYet => 'このストーリーラインにはイベントがありません';

  @override
  String get uiEventName => 'イベント名';

  @override
  String get uiSelectAStorylineFirst => 'ストーリーラインを選択してください';

  @override
  String get uiSelectAStorylineToAddAndEditEvents =>
      'ストーリーラインを選択すると、イベントを追加・編集できます';

  @override
  String get uiEventASpecificOccurrenceInTheStory => 'イベント：物語で実際に起こる出来事です。';

  @override
  String get uiTypeNotSet => '種類未設定';

  @override
  String get uiDeleteStoryline => 'ストーリーラインを削除';

  @override
  String uiEventMovedTo(String p1) {
    return 'イベントを「$p1」に移動しました';
  }

  @override
  String uiScenes(String p1) {
    return 'シーン数：$p1';
  }

  @override
  String get uiDeleteEvent => 'イベントを削除';

  @override
  String get uiEventDetails => 'イベントの詳細';

  @override
  String get uiPointOfConflict => '対立点';

  @override
  String get uiDefaultCharacters => '既定の人物';

  @override
  String get uiItemAllocations => 'アイテムの割り当て';

  @override
  String get uiNoTrackedItemsAllocatedYet => '正式なアイテムはまだ割り当てられていません。';

  @override
  String get uiItemClass => 'アイテムクラス';

  @override
  String get uiChooseAnEventItemToLink => '関連付けるイベントのアイテムを選択';

  @override
  String get uiOutlineObjects => 'アウトラインのオブジェクト';

  @override
  String get uiTheseAreLegacyTextObjectsConvertThemTo =>
      '旧形式のテキストオブジェクトです。追跡可能な正式アイテムに変換してください。新規追加では旧形式を使用しません。';

  @override
  String get uiRemoveAllocation => '割り当てを削除';

  @override
  String get uiChooseAnItemToAllocateToTheScene => 'シーンに割り当てるアイテムを選択';

  @override
  String get uiAfterConversionThisLegacyTextIsReplacedWith =>
      '変換後、この旧形式のテキストは追跡可能なアイテム ID への関連に置き換わります。';

  @override
  String get uiCreateAndLink => '作成して関連付け';

  @override
  String uiChooseTheItemFor(String p1) {
    return '「$p1」に対応するアイテムを選択';
  }

  @override
  String get uiConvertedToATrackedItemLink => '正式アイテムの関連に変換しました。';

  @override
  String get uiNonDedicatedClassOnly => '非専用（クラスのみ作成）';

  @override
  String uiConvertedFromLegacyText(String p1) {
    return '旧形式のテキスト「$p1」から変換';
  }

  @override
  String get uiScenes2 => 'シーン';

  @override
  String get uiNoScenesYet => 'シーンがありません';

  @override
  String get uiSceneName2 => 'シーン名';

  @override
  String get uiSelectAnEventFirst => 'イベントを選択してください';

  @override
  String get uiSelectAnEventToAddAndEditScenes => 'イベントを選択すると、シーンを追加・編集できます';

  @override
  String get uiSceneADetailedSceneWithinAnEvent => 'シーン：イベント内の具体的な場面です。';

  @override
  String get uiDeleteScene => 'シーンを削除';

  @override
  String get uiSceneDetails => 'シーンの詳細';

  @override
  String get uiTime => '時間';

  @override
  String get uiFocus => '焦点';

  @override
  String get uiAction => '行動';

  @override
  String uiStoryline2(String p1) {
    return 'ストーリーライン $p1';
  }

  @override
  String uiEvent3(String p1) {
    return 'イベント $p1';
  }

  @override
  String uiScene(String p1) {
    return 'シーン $p1';
  }

  @override
  String uiSkippedOrRepairedPaletteDataIssues(String p1) {
    return 'パレットデータの問題 $p1 件をスキップまたは修復しました。';
  }

  @override
  String uiCouldNotReadPaletteData(String p1) {
    return 'パレットデータを読み込めません：$p1';
  }

  @override
  String uiDeleted(String p1) {
    return '「$p1」を削除しました';
  }

  @override
  String get uiExportTextPalette => 'テキストパレットをエクスポート';

  @override
  String uiPaletteExported(String p1) {
    return 'パレットをエクスポートしました：$p1';
  }

  @override
  String uiPaletteExportFailed(String p1) {
    return 'パレットのエクスポートに失敗しました：$p1';
  }

  @override
  String get uiImportTextPalette => 'テキストパレットをインポート';

  @override
  String uiWithFormatIssuesSkipped(String p1) {
    return '、形式の問題 $p1 件をスキップ';
  }

  @override
  String uiImportedPaletteEntriesSkippedDuplicates(
    String p1,
    String p2,
    String p3,
  ) {
    return 'パレットの項目 $p1 件を追加し、重複 $p2 件をスキップしました$p3';
  }

  @override
  String get uiPaletteImportFailedInvalidFormatOrUnreadableFile =>
      'パレットのインポートに失敗しました。形式が無効か、ファイルを読み込めません';

  @override
  String get uiCouldNotLoadPalettes => 'パレットを読み込めませんでした';

  @override
  String get uiNotSavedToDiskYet => 'まだディスクに保存されていません';

  @override
  String get uiTextPalettes => 'テキストパレット';

  @override
  String get uiSearchEntries => '項目を検索…';

  @override
  String get uiImportOrExportPalettes => 'パレットをインポート・エクスポート';

  @override
  String get uiImportPalette => 'パレットをインポート…';

  @override
  String get uiExportPalette => 'パレットをエクスポート…';

  @override
  String get uiGrayscale => 'グレースケール';

  @override
  String uiHueSaturationBrightness(String p1) {
    return '色相 $p1°、彩度 80%、明度 100%';
  }

  @override
  String uiEntries2(String p1, String p2) {
    return '$p1、$p2 項目';
  }

  @override
  String uiEntries3(String p1) {
    return '項目数：$p1';
  }

  @override
  String get uiColorCellActions => 'カラーセルの操作';

  @override
  String get uiSortByText => 'テキストで並べ替え';

  @override
  String uiEdit2(String p1) {
    return '「$p1」を編集';
  }

  @override
  String get uiAddEntry => '項目を追加';

  @override
  String get uiEnterATerm => '語句を入力';

  @override
  String uiNoEntriesContaining(String p1) {
    return '「$p1」を含む項目がありません';
  }

  @override
  String get uiForeshadowingList => '伏線一覧';

  @override
  String get uiNoForeshadowingYet => '伏線がありません';

  @override
  String get uiAddYourFirstEntry2 => '最初の項目を追加してください';

  @override
  String get uiAddForeshadowing => '伏線を追加';

  @override
  String get uiSelectAForeshadowingEntry => '伏線を選択してください';

  @override
  String get uiSelectAnEntryToEditItsContent => '項目を選択すると内容を編集できます';

  @override
  String get uiForeshadowingName => '伏線名';

  @override
  String get uiRevealed => '回収済み';

  @override
  String get uiReleasePlans => '更新計画';

  @override
  String get uiNoReleasePlansYet => '更新計画がありません';

  @override
  String get uiAddReleasePlan => '更新計画を追加';

  @override
  String get uiSelectAReleasePlan => '更新計画を選択してください';

  @override
  String get uiPlanName => '計画名';

  @override
  String get uiCompleted => '完了';

  @override
  String get uiIdeaList => 'アイデア一覧';

  @override
  String get uiNoIdeasYet => 'アイデアがありません';

  @override
  String get uiAddAFolderOrIdea => 'フォルダーまたはアイデアを追加してください';

  @override
  String get uiExpand => '展開';

  @override
  String get uiFolder2 => 'フォルダー';

  @override
  String get uiIdea => 'アイデア';

  @override
  String get uiSelectAnIdea => 'アイデアを選択してください';

  @override
  String get uiIdeaTitle => 'アイデアのタイトル';

  @override
  String get uiIdeaNotes => 'アイデアのメモ';

  @override
  String get uiPlanning => '計画';

  @override
  String uiCouldNotLoadTheFillerWordDictionary(String p1) {
    return '冗長語辞書を読み込めません：$p1';
  }

  @override
  String get uiProofreading => '校正';

  @override
  String get uiCheckYourTextHere => 'ここで文章をチェックできます。';

  @override
  String uiCurrentTextLengthCharacters(String p1) {
    return '現在の文章の長さ：$p1 文字';
  }

  @override
  String get uiLoadingFillerWordDictionary => '冗長語辞書を読み込み中';

  @override
  String uiFillerWordDictionaryLoadedEntries(String p1) {
    return '冗長語辞書を読み込みました：$p1 項目';
  }

  @override
  String get uiQuoteAndBracketMatching => '引用符・括弧の対応チェック';

  @override
  String uiTooManyResultsOnlyInitialSamplesAreShown(String p1) {
    return '結果が多いため、各チェックの先頭部分のみ表示しています。総件数：$p1。';
  }

  @override
  String get uiPunctuationAnomalies => '句読点の異常検出';

  @override
  String get uiLineEndingCheck => '行末チェック';

  @override
  String get uiPunctuationConsistency => '句読点の統一';

  @override
  String get uiFillerWordCheck => '冗長語チェック';

  @override
  String get uiFillerWordRatio => '冗長語率';

  @override
  String get uiCheckSettings => 'チェック設定';

  @override
  String uiShowMoreRemaining(String p1) {
    return 'さらに表示（残り $p1）';
  }

  @override
  String get uiCheckPairedAndUnclosedDelimiters => '括弧や引用符の対応と閉じ忘れをチェック';

  @override
  String get uiCheckRepeatedPunctuationAndQuoteNesting =>
      '連続した句読点と引用符の入れ子をチェック';

  @override
  String get uiFindPunctuationThatCanBeStandardized => '統一できる句読点をチェック';

  @override
  String get uiFindFillerWordsListedInTheDictionary => '辞書にある冗長語の出現箇所をチェック';

  @override
  String get uiCheckLineEndingsAgainstTheRules => '行末の記号が規則に合うかチェック';

  @override
  String get uiLineEndingOptions => '行末チェックの詳細';

  @override
  String get uiIgnoreCommasAtLineEnd => '行末のコンマを許可';

  @override
  String get uiDoNotFlagLinesEndingInOr => '行末が , または ，の場合は通知しない';

  @override
  String get uiIgnoreDashesAtLineEnd => '行末のダッシュを許可';

  @override
  String get uiDoNotFlagLinesEndingInOr2 => '行末が — または - の場合は通知しない';

  @override
  String get uiIgnoreEllipsesAtLineEnd => '行末の三点リーダーを許可';

  @override
  String get uiDoNotFlagLinesEndingInOr3 => '行末が … または …… の場合は通知しない';

  @override
  String get uiIgnoreColonsAtLineEnd => '行末のコロンを許可';

  @override
  String get uiDoNotFlagLinesEndingInOr4 => '行末が : または ：の場合は通知しない';

  @override
  String get uiIgnoreSemicolonsAtLineEnd => '行末のセミコロンを許可';

  @override
  String get uiDoNotFlagLinesEndingIn => '行末が ；の場合は通知しない';

  @override
  String get uiFormatOptions => '書式オプション';

  @override
  String get uiPunctuationStyle => '句読点のスタイル';

  @override
  String get uiChooseAStyle => 'スタイルを選択してください';

  @override
  String uiCurrentStyle(String p1) {
    return '現在のスタイル：$p1';
  }

  @override
  String get uiDetectLatinScriptSentences => 'ラテン文字の文を検出';

  @override
  String get uiAutomaticallyUseLatinPunctuationWhenLatinTextIs =>
      'ラテン文字を検出した場合、欧文の句読点を自動適用';

  @override
  String get uiLatinScriptDetectionOptions => 'ラテン文字判定の詳細';

  @override
  String get uiAllowCJKQuotesBracketsAtWordEnd => '語尾の CJK 引用符・括弧を許可';

  @override
  String get uiAllowCJKQuotesAndBracketsAfterLatinText =>
      'ラテン文字の語尾で CJK 引用符と括弧を許可';

  @override
  String get uiAllowCJKExclamationQuestionMarksAtWordEnd =>
      '語尾の CJK 感嘆符・疑問符を許可';

  @override
  String get uiAllowAndAfterLatinText => 'ラテン文字の語尾で ！ と ？ を許可';

  @override
  String get uiAllowCJKPunctuationAroundCJKText => 'CJK 文字の前後で CJK 句読点を許可';

  @override
  String get uiDoNotTreatCJKPunctuationAsLatinContinuation =>
      '前後のいずれかが行頭・CJK 文字・行末なら、CJK 句読点をラテン文字の続きとみなさない';

  @override
  String get uiThisCheckIsDisabled => 'このチェックは無効です。';

  @override
  String get uiEnterSomeTextFirst => '先に文章を入力してください。';

  @override
  String get uiNoUnclosedDelimitersFound => '閉じ忘れは見つかりませんでした。';

  @override
  String get uiNoCheckRunYet => 'まだチェックしていません。';

  @override
  String get uiPunctuationIsConsistentNoChangesNeeded =>
      '句読点は統一されています。変更は不要です。';

  @override
  String uiFoundPunctuationMarksThatCanBeStandardized(String p1) {
    return '統一できる句読点が $p1 箇所見つかりました。';
  }

  @override
  String get uiResolveAll => 'すべて修正';

  @override
  String get uiNoPunctuationAnomaliesFound => '句読点の異常は見つかりませんでした。';

  @override
  String uiSuggestion(String p1) {
    return '提案：$p1';
  }

  @override
  String get uiNoLineEndingIssuesFound => '行末の問題は見つかりませんでした。';

  @override
  String get uiNoDictionaryFillerWordsFound => '辞書にある冗長語は見つかりませんでした。';

  @override
  String get uiClickAFillerWordBelowToExpandIts =>
      '以下の冗長語をクリックすると、出現箇所を表示できます。';

  @override
  String uiOccurrences(String p1) {
    return '出現回数：$p1';
  }

  @override
  String uiShowingOnlyTheFirstLocations(String p1) {
    return '最初の $p1 箇所のみ表示しています。';
  }

  @override
  String uiTotalFillerWordOccurrences(String p1) {
    return '冗長語の総出現回数：$p1';
  }

  @override
  String uiEffectiveWordCount(String p1) {
    return '有効文字数：$p1';
  }

  @override
  String uiFillerWordRatio2(String p1) {
    return '冗長語率：$p1%';
  }

  @override
  String get uiAllowUnrestrictedBatteryUsageInTheSystemPrompt =>
      'システムの確認画面で、バッテリー最適化の制限を解除してください。';

  @override
  String get uiCouldNotOpenBackgroundExecutionPermissions =>
      'バックグラウンド実行の権限設定を開けません。';

  @override
  String get uiMCPHostConfigurationCopiedPasteItIntoYour =>
      'MCP ホスト設定をコピーしました。ホストの MCP 設定に貼り付けてください。';

  @override
  String get uiAppearanceAndInterface => '外観とインターフェース';

  @override
  String get uiThemeNavigationToolbarAndFonts => 'テーマ、ナビゲーション、ツールバー、フォント';

  @override
  String get uiCustomizeToolbarItems => 'ツールバー項目を編集';

  @override
  String get uiEditingAndInput => '編集と入力';

  @override
  String get uiSmartSuggestionsOverwriteIndentationAndWordCount =>
      '入力候補、上書き、インデント、文字数';

  @override
  String get uiWritingGoals => '執筆目標';

  @override
  String get uiDailyProgressAndDefaultChapterAndProjectGoals =>
      '毎日の進捗と、章・全文の既定の目標';

  @override
  String get uiSavingAndBackups => '保存とバックアップ';

  @override
  String get uiAutosaveBackupScheduleAndStorageLimits =>
      '自動保存、バックアップのスケジュール、容量';

  @override
  String get uiSyncAndConnections => '同期と接続';

  @override
  String get uiDevicePairingPersistentAuthenticationAndBackgroundExecution =>
      'デバイスのペアリング、継続認証、バックグラウンド実行';

  @override
  String get uiExternalIntegrations => '外部連携';

  @override
  String get uiReadOnlyMCPProjectAccessAndAuthorization =>
      'MCP によるプロジェクトの読み取り専用アクセスと認可';

  @override
  String get uiEnablePoppinIntelliSense => 'Poppin IntelliSense を有効化';

  @override
  String get uiShowSuggestionsNearTheCursorWhenEnteringA =>
      'マーカーの種類、/、\\ を入力すると、カーソル付近に候補を表示';

  @override
  String get uiEnableOverwriteMode => '上書きモードを有効化';

  @override
  String get uiUseInsOrTheStatusBarToToggle =>
      'Ins キーまたはステータスバーで上書きモードを切り替えます。無効時は挿入モードを使用します';

  @override
  String get uiSpacesAndIndentation => '空白とインデント';

  @override
  String get uiSpacesPerTab => 'Tab の空白数';

  @override
  String get uiNumberOfSpacesInsertedByTabOrAutomatic =>
      'Tab または自動インデントで挿入する空白の数';

  @override
  String get uiUseFullWidthSpaces => '全角空白を使用';

  @override
  String get uiUseHalfWidthSpacesWhenDisabled => '無効時は半角空白を使用';

  @override
  String get uiAutomaticallyIndentNewLines => '行頭を自動インデント';

  @override
  String get uiInsertConfiguredSpacesAfterEnterShiftEnterInserts =>
      'Enter の改行後に設定した空白を挿入。Shift+Enter は改行のみ';

  @override
  String get uiUpdateManuscriptMentionsWhenAliasesChange =>
      '別名の変更時に本文のメンションを更新';

  @override
  String get uiUpdateMarkersForTheSameCharacterWhoseDisplay =>
      '同じ人物で、表示文字が変更前の別名と一致するマーカーを更新';

  @override
  String get uiDisabled2 => '無効';

  @override
  String get uiCreatingLocalAuthorization => 'ローカルの認可を作成中…';

  @override
  String uiAuthorizedLocalReadOnly(String p1) {
    return '認可済み：$p1（ローカル・読み取り専用）';
  }

  @override
  String get uiAuthorizationExpired => '認可の期限切れ';

  @override
  String get uiCouldNotEnable => '有効化に失敗しました';

  @override
  String get uiReadOnlyMCPIntegration => 'MCP 読み取り専用連携';

  @override
  String uiExposeOnlyTheAuthorizedProjectSSummaryChapters(String p1) {
    return '認可されたプロジェクトの概要、章、人物、世界設定、アウトライン、語句のみを公開します。編集ツールは提供しません。$p1';
  }

  @override
  String get uiTheMCPSidecarSupportsWindowsMacOSAndLinux =>
      'MCP サイドカーは Windows、macOS、Linux のみに対応しています。';

  @override
  String uiConnectionConfiguration(String p1) {
    return '接続設定ファイル：$p1';
  }

  @override
  String get uiAnMCPHostHasClaimedTheOneTime =>
      'MCP ホストが一度限りの認可を取得しました。別のホストに接続するには、停止して再度有効化してください。';

  @override
  String get uiCopyMCPHostConfiguration => 'MCP ホスト設定をコピー';

  @override
  String get uiStopCurrentAuthorization => '現在の認可を停止';

  @override
  String get uiAllowOneSidedPairingConfirmation => '片方のデバイスでのペアリング確認を許可';

  @override
  String get uiRequiresBothDevicesToEnableThisOptionAfter =>
      '両方のデバイスで有効にする必要があります。片方が確認すると、もう片方が署名を検証して自動的に署名を返します';

  @override
  String get uiPersistentAuthenticationDays => '継続認証（14 日間）';

  @override
  String get uiRequiresBothDevicesToEnableThisOptionAuthenticate =>
      '両方のデバイスで有効にする必要があります。期間中は自動認証し、接続が成功するたびに 14 日間更新します';

  @override
  String get uiAllowBackgroundExecution => 'バックグラウンド常駐を許可';

  @override
  String get uiUnrestrictedBatteryUsageIsAllowed => 'バッテリー最適化の制限解除を許可済み';

  @override
  String get uiReduceTheChanceOfTheSystemSuspendingActive =>
      '実行中のバックグラウンド処理がシステムに一時停止されにくくなります';

  @override
  String get uiAllowed => '許可済み';

  @override
  String get uiAllow => '許可';

  @override
  String get uiFontSize => '文字サイズ';

  @override
  String get uiIconsOnly => 'アイコンのみ';

  @override
  String get uiIconsAndLabels => 'アイコンと名前';

  @override
  String get uiExpandOnClick => 'クリックで展開';

  @override
  String get uiExpandOnHover => 'ホバーで展開';

  @override
  String get uiNavigationStyle => 'ナビゲーションの形式';

  @override
  String get uiHomeStaysAtTheTopSettingsAndAbout =>
      'ホームは上部、設定とバージョン情報は下部に固定されます。幅の狭いウィンドウではボタンでナビゲーションを開きます。';

  @override
  String get uiLight => 'ライト';

  @override
  String get uiDark => 'ダーク';

  @override
  String get uiThemeMode => 'テーマ';

  @override
  String get uiFollowTheSystemSLightOrDarkAppearance => 'システムのライト・ダーク設定に合わせます。';

  @override
  String uiUseAppearance(String p1) {
    return '$p1の外観を使用します。';
  }

  @override
  String uiCurrentlyUsingMode(String p1) {
    return '現在のモード：$p1';
  }

  @override
  String get uiWordCountMode => '文字数の集計方法';

  @override
  String get uiCharacterCountNotRecommended => '文字数のみ（非推奨）';

  @override
  String get uiFullWidthCharactersHalfWidthWords => '全角文字数＋半角単語数';

  @override
  String get uiCharactersNotRecommended => '文字数（非推奨）';

  @override
  String get uiMixedMode => '混合モード';

  @override
  String get uiSaveOnAScheduleRequiresAnExistingFile => '指定間隔で保存（既存ファイルが必要）';

  @override
  String get uiCreateScheduledProjectBackupsWithoutOverwritingTheOriginal =>
      '指定間隔でプロジェクトをバックアップし、元のファイルを保持';

  @override
  String get uiMaximumBackupStorage => 'バックアップの容量上限';

  @override
  String get uiOpen => '開く';

  @override
  String get uiChooseAgain => '再選択';

  @override
  String get uiChoose => '選択';

  @override
  String get uiAutoBackupFolderOptions => 'AutoBackup フォルダーの設定';

  @override
  String get uiReset => 'リセット';

  @override
  String uiMBBackups(String p1, String p2, String p3) {
    return '$p1 / $p2 MB · $p3 件';
  }

  @override
  String get uiDeleteAllBackups => 'すべてのバックアップを削除';

  @override
  String uiDeletedBackupsFreeing(String p1, String p2) {
    return 'バックアップ $p1 件を削除し、$p2 を解放しました。';
  }

  @override
  String uiOpenedAutoBackupFolder(String p1) {
    return 'AutoBackup フォルダーを開きました：$p1';
  }

  @override
  String uiAutoBackupFolderSet(String p1) {
    return 'AutoBackup フォルダーを設定しました：$p1';
  }

  @override
  String uiAutoBackupFolderReset(String p1) {
    return 'AutoBackup フォルダーをリセットしました：$p1';
  }

  @override
  String get uiComingSoon => '近日公開';

  @override
  String get uiTimeline => 'タイムライン';

  @override
  String uiFoundMissingReferencesDataHasBeenPreservedRelink(String p1) {
    return '参照切れが $p1 件見つかりました。データは保持されています。該当ノードを再リンクするか削除してください。';
  }

  @override
  String get uiSearchTimeline => 'タイムラインを検索';

  @override
  String get uiAllStateChanges => 'すべての状態変化';

  @override
  String get uiCharacters3 => '人物';

  @override
  String get uiMainTimeline => 'メインタイムライン';

  @override
  String get uiAddStoryline => 'ストーリーラインを追加';

  @override
  String get uiAddEvent => 'イベントを追加';

  @override
  String get uiAddScene => 'シーンを追加';

  @override
  String get uiScenesAreLeafNodes => 'シーンは最下層のノードです';

  @override
  String get uiCurrentChapterOnly => '現在の章のみ表示';

  @override
  String get uiNoChapterLinked => '章の関連なし';

  @override
  String get uiAutomaticallySortOutlineSortByStartTickAnd =>
      'アウトラインを自動並べ替え\n開始 Tick とトラック順で並べ替え、アウトラインの順序変更をタイムラインにも反映します。';

  @override
  String get uiShowEmptyTimelineRanges => 'タイムラインの空白区間を表示';

  @override
  String get uiSkipEmptyTimelineRanges => 'タイムラインの空白区間を省略';

  @override
  String get uiReturnToCurrentTimeline => '現在のタイムラインに戻る';

  @override
  String get uiVisibleTickWidth => '表示する Tick の幅';

  @override
  String get uiCurrentTick2 => '現在の Tick';

  @override
  String get uiUnscheduledStorylines => '未配置のストーリーライン';

  @override
  String get uiAllOutlineStorylinesAreSynced => 'すべてのストーリーラインが同期済みです';

  @override
  String get uiSyncCreatesOrCompletesTheEntireStorylineEvent =>
      '同期時はストーリーライン・イベント・シーンの階層全体を作成または補完します。個別のシーンを現在のイベントに追加する操作ではありません。';

  @override
  String get uiUntitledStoryline2 => '無題のストーリーライン';

  @override
  String uiTimelineStorylineMissingContainsEventsAndScenes(
    String p1,
    String p2,
  ) {
    return 'タイムラインにストーリーラインがありません。イベント $p1 件、シーン $p2 件を含みます';
  }

  @override
  String uiMissingEventsAndScenes(String p1, String p2) {
    return 'イベント $p1 件、シーン $p2 件が未配置';
  }

  @override
  String get uiSyncEntireStoryline => 'ストーリーライン全体を同期';

  @override
  String get uiStoryTimeScale => '物語の時間尺度';

  @override
  String get uiTickUnit => 'Tick の単位';

  @override
  String get uiUnitsPerTick => '1 Tick あたりの単位数';

  @override
  String get uiTicksPerScene => 'シーンあたりの Tick 数';

  @override
  String get uiScenesPerEvent => 'イベントあたりのシーン数';

  @override
  String get uiEventsPerStoryline => 'ストーリーラインあたりのイベント数';

  @override
  String uiTickSceneTicksEventTicksStorylineTicks(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  ) {
    return '1 Tick = $p1 $p2、1 シーン = $p3 Tick、1 イベント = $p4 Tick、1 ストーリーライン = $p5 Tick。';
  }

  @override
  String get uiNodeName => 'ノード名';

  @override
  String get uiRequiredWhenNoSceneIsSelected => 'シーン未選択時は必須';

  @override
  String get uiAddingAnEventAlsoCreatesItsCorrespondingOutline =>
      'イベントの追加時に、対応するアウトラインのイベントも作成します。';

  @override
  String get uiOutlineSceneOptional => 'アウトラインのシーン（任意）';

  @override
  String get uiCreateNewOutlineScene => '新しいアウトラインのシーンを作成';

  @override
  String get uiUntitledScene2 => '無題のシーン';

  @override
  String get uiAddTrack => 'トラックを追加';

  @override
  String get uiTrackName => 'トラック名';

  @override
  String get uiRenameTrack => 'トラック名を変更';

  @override
  String get uiDeleteTrack => 'トラックを削除';

  @override
  String get uiNodesMoveToAnotherTrackOutlineScenesWill =>
      'ノードは別のトラックに移動します。アウトラインのシーンは削除されません。';

  @override
  String get uiChooseAChapterToOpen => '開く章を選択';

  @override
  String get uiDeleteTimelineNode => 'タイムラインのノードを削除';

  @override
  String get uiThisDeletesTheNodeAndItsChildrenOutline =>
      'このノードと子ノードを削除します。アウトラインのシーンと章の本文は保持されます。';

  @override
  String get uiLinkChaptersAndApplyToAllChildren => '章を関連付けてすべての子ノードに適用';

  @override
  String get uiChooseLinkedChapters => '関連付ける章を選択';

  @override
  String uiAllChildScenesWillUseTheSameChapter(String p1) {
    return '適用後、子シーン $p1 件すべてに同じ章の選択を使用します。';
  }

  @override
  String get uiNoChaptersYet => '章がありません';

  @override
  String uiCurrentlyChildScenes(String p1, String p2, String p3) {
    return '$p1 · 現在 $p2/$p3 子シーン';
  }

  @override
  String uiTimeScrubberCurrentlyTicks(String p1) {
    return '時間スクラバー、現在 $p1 Tick';
  }

  @override
  String uiDragCurrentTimeTicks(String p1) {
    return '現在時刻をドラッグ：$p1 Tick';
  }

  @override
  String get uiTrack => 'トラック';

  @override
  String get uiTrackOptions => 'トラックの設定';

  @override
  String get commonRename => '名前を変更';

  @override
  String get uiExpandTrack => 'トラックを展開';

  @override
  String get uiCollapseTrack => 'トラックを折りたたむ';

  @override
  String get uiMoveUp => '上へ移動';

  @override
  String get uiMoveDown => '下へ移動';

  @override
  String get uiDragToAdjustStartTick => 'ドラッグして開始 Tick を調整';

  @override
  String get uiDragToAdjustEndTick => 'ドラッグして終了 Tick を調整';

  @override
  String get uiAdjustStartTick => '開始 Tick を調整';

  @override
  String get uiAdjustEndTick => '終了 Tick を調整';

  @override
  String get uiDragToAdjustTime => 'ドラッグして時間を調整';

  @override
  String uiStateChangesCharactersItemsLocations(
    String p1,
    String p2,
    String p3,
  ) {
    return '状態変化：人物 $p1、アイテム $p2、場所 $p3';
  }

  @override
  String get uiNodeProperties => 'ノードのプロパティ';

  @override
  String get uiNoNodeSelected => 'ノードが選択されていません';

  @override
  String get uiSelectATimelineNodeToViewAndAdjust =>
      'タイムラインのノードを選択すると、Tick、トラック、章の関連を確認・調整できます。';

  @override
  String get uiDeleteNode => 'ノードを削除';

  @override
  String get uiCustomName => 'カスタム名';

  @override
  String get uiAssignedTrack => '所属トラック';

  @override
  String get uiStartTick => '開始 Tick';

  @override
  String get uiTickCount => 'Tick 数';

  @override
  String get uiEndTick => '終了 Tick';

  @override
  String get uiOpenInOutline => 'アウトラインで開く';

  @override
  String uiChaptersBelowAreCollectedFromChildScenes(String p1) {
    return '以下の章は子シーン $p1 件から集約されています。';
  }

  @override
  String get uiSceneStateChanges => 'シーンの状態変化';

  @override
  String uiCharactersItemsLocations(String p1, String p2, String p3) {
    return '人物 $p1・アイテム $p2・場所 $p3';
  }

  @override
  String get uiNoCharacterItemOrLocationSnapshotChangesIn =>
      'このシーンには人物・アイテム・場所のスナップショットの変化がありません。';

  @override
  String get uiLinkedChapters => '関連する章';

  @override
  String get uiChooseChapters => '章を選択';

  @override
  String get uiChildScenesHaveNoLinkedChaptersYet => '子シーンに関連する章がありません';

  @override
  String get uiThisSceneHasNoLinkedChaptersYet => 'このシーンに関連する章がありません';

  @override
  String get uiChooseChaptersAndApplyThemToAllChild =>
      '章を選択し、すべての子ノードにまとめて適用できます。';

  @override
  String get uiTheFirstChapterWillNotOpenAutomatically => '最初の章には自動的に切り替わりません。';

  @override
  String get uiMissingChapter => '参照先の章がありません';

  @override
  String get uiThisContainerHasNoChildScenesThatCan =>
      '章を関連付けられる子シーンがありません。先にシーンを追加してください。';

  @override
  String get uiThisSceneHasNoOutlineSceneLinkedSo =>
      'アウトラインのシーンが関連付けられていないため、章を関連付けられません。';

  @override
  String uiOpen2(String p1) {
    return '$p1を開く';
  }

  @override
  String get uiDecrease => '減らす';

  @override
  String get uiIncrease => '増やす';

  @override
  String get uiAddTheSceneToTheTimelineBeforeAdding3 =>
      '場所のスナップショットを追加する前に、シーンをタイムラインに配置してください。';

  @override
  String uiExistence(String p1, String p2) {
    return '存在 $p1 → $p2';
  }

  @override
  String uiAccess(String p1, String p2) {
    return '進入可否 $p1 → $p2';
  }

  @override
  String uiState(String p1, String p2) {
    return '状態「$p1」→「$p2」';
  }

  @override
  String uiController(String p1, String p2) {
    return '支配者 $p1 → $p2';
  }

  @override
  String get uiNoChanges => '変更なし';

  @override
  String get uiApplyToAllChildLocations => 'すべての子の場所に適用';

  @override
  String uiCreatesIndependentSnapshots(String p1) {
    return '個別のスナップショットを $p1 件作成します';
  }

  @override
  String uiOnlyWillBeModified(String p1) {
    return '「$p1」のみ変更します';
  }

  @override
  String get uiNameAtThisPoint => 'この時点の名前';

  @override
  String get uiDescriptionAtThisPoint => 'この時点の説明';

  @override
  String get uiCustomPropertiesAtThisPoint => 'この時点のカスタム属性';

  @override
  String get uiValue => '値';

  @override
  String get uiRemoveProperty => '属性を削除';

  @override
  String get uiAddProperty => '属性を追加';

  @override
  String get uiBatchApplicationPreservesEachChildLocationSExisting =>
      '一括適用でも、子の場所それぞれの名前・説明・カスタム属性は保持されます。';

  @override
  String get uiAccessibleAtThisPoint => 'この時点で進入可能';

  @override
  String get uiController2 => '支配者';

  @override
  String get uiBatchChangesPreview => '一括変更のプレビュー';

  @override
  String get uiPropertiesWithAValueMustHaveAName => '値がある属性には名前が必要です。';

  @override
  String get uiCustomPropertyNamesMustBeUnique => 'カスタム属性の名前は重複できません。';

  @override
  String get uiLocationSnapshotAdded => '場所のスナップショットを追加しました';

  @override
  String uiAddedLocationSnapshots(String p1) {
    return '場所のスナップショットを $p1 件追加しました';
  }

  @override
  String get uiDeleteAllSnapshotsInThisBatch => 'この一括操作のスナップショットをすべて削除しますか？';

  @override
  String uiThisSnapshotBelongsToTheSameBatchAs(String p1) {
    return '他の子の場所と同じ一括操作に属するため、スナップショット $p1 件をまとめて削除します。';
  }

  @override
  String get uiDeleteBatch => 'まとめて削除';

  @override
  String uiDeletedLocationSnapshots(String p1) {
    return '場所のスナップショットを $p1 件削除しました';
  }

  @override
  String get uiLocationSnapshotDeleted => '場所のスナップショットを削除しました';

  @override
  String get uiItemsCurrentlyAtThisLocation => '現在この場所にあるアイテム';

  @override
  String get uiNoItemsHere => 'アイテムがありません';

  @override
  String get uiUseAllocateItemsToSetLocationsOrAggregate =>
      '「アイテムを割り当て」で所在地や集計数量を設定できます';

  @override
  String get uiChooseALocationItemToLink => '関連付ける場所のアイテムを選択';

  @override
  String get uiChooseAnItemToPlaceHere => 'この場所に置くアイテムを選択';

  @override
  String get uiMoveLegacyWorldbuildingItems => '旧形式の世界設定アイテムを移動';

  @override
  String uiMoveItemNodesToTheNewItemManager(String p1) {
    return 'アイテムの子ノード $p1 件を新しいアイテム管理に移動します。ID、内容、元のパスは保持されます。';
  }

  @override
  String uiMovedItemsToTheNewItemManager(String p1) {
    return '新しいアイテム管理に $p1 件移動しました。';
  }

  @override
  String get uiWorldbuilding2 => '世界設定';

  @override
  String get uiManageTemplates => 'テンプレート管理';

  @override
  String get uiImportTemplateFile => 'テンプレートをインポート…';

  @override
  String get uiExportSelectedTemplate => '選択したテンプレートをエクスポート…';

  @override
  String get uiExportAllTemplates => 'すべてのテンプレートをエクスポート…';

  @override
  String get uiSaveTemplatePreset => 'テンプレートのプリセットを保存…';

  @override
  String get uiRenamePreset => 'プリセット名を変更…';

  @override
  String get uiDeleteSelectedPreset => '選択したプリセットを削除';

  @override
  String get uiWorldStructure => '世界の構造';

  @override
  String get uiNoLocationsYet => '場所がありません';

  @override
  String get uiAddYourFirstLocation => '最初の場所を追加してください';

  @override
  String get uiChildLocation => '子の場所';

  @override
  String get uiTopLevelLocation => '最上位の場所';

  @override
  String get uiNodeDetails => 'ノードの詳細';

  @override
  String get uiDoesNotExistAtThisTick => 'この Tick ではまだ存在しない';

  @override
  String get uiTreeShellRetainedExistingChildLocationsRemain =>
      'ツリー構造を保持：存在する子の場所があります';

  @override
  String get uiParentDoesNotExistAtThisTickThis =>
      'この Tick では親が存在しませんが、このノードは独立して存在します';

  @override
  String uiNameAtThisPoint2(String p1) {
    return 'この時点の名前：$p1';
  }

  @override
  String get uiDeleteLocation => '場所を削除';

  @override
  String get uiBefore => 'の前';

  @override
  String get uiAsAChildLocation => 'の子の場所';

  @override
  String get uiAfter => 'の後';

  @override
  String uiIsNowPlaced(String p1, String p2, String p3) {
    return '「$p1」は「$p2」$p3になりました';
  }

  @override
  String uiMoved(String p1, String p2, String p3) {
    return '「$p1」を「$p2」$p3に移動しました';
  }

  @override
  String get uiSelectALocationFirst => '場所を選択してください';

  @override
  String get uiSelectALocationToPreviewItsTimelineAnd =>
      '場所を選択すると、タイムラインのプレビューとスナップショットの管理ができます';

  @override
  String uiDescription2(String p1) {
    return '説明：$p1';
  }

  @override
  String uiProperties(String p1) {
    return '属性：$p1';
  }

  @override
  String get uiAccessible => '進入可能';

  @override
  String get uiInaccessible => '進入不可';

  @override
  String uiController3(String p1) {
    return '支配者：$p1';
  }

  @override
  String get uiRemoveLocationSnapshot => '場所のスナップショットを削除';

  @override
  String get uiChooseALocation => '場所を選択';

  @override
  String get uiSelectALocationToEditItsDetails => '場所を選択すると、詳細を編集できます';

  @override
  String get uiLocationNotFound => '場所が見つかりません';

  @override
  String get uiApplyTemplate => 'テンプレートを適用：';

  @override
  String get uiChooseTemplate => 'テンプレートを選択';

  @override
  String get uiBlank => '空白';

  @override
  String get commonConfirm => '確定';

  @override
  String get uiThisIsALegacyItemNodeItemsAre =>
      '旧形式のアイテムの子ノードです。新しいアイテムは世界設定ツリーに保存しません。移動後、この場所のページで割り当てを管理できます。';

  @override
  String get uiMoveAllItems => 'すべてのアイテムを移動';

  @override
  String get uiNodeType => 'ノードの種類';

  @override
  String get uiCustomProperties => 'カスタム属性：';

  @override
  String get uiNoCustomProperties => 'カスタム属性がありません';

  @override
  String get uiEnterAPropertyNameAndValueBelowTo => '下に属性名と値を入力して追加してください';

  @override
  String get uiNotes4 => 'メモ：';

  @override
  String get uiSaveTemplatePreset2 => 'テンプレートのプリセットを保存';

  @override
  String get uiATemplateWithThisNameExistsOverwriteIt =>
      '同名のテンプレートがあります。上書きしますか？';

  @override
  String get uiRenamePreset2 => 'プリセット名を変更';

  @override
  String get uiNewTemplateName => '新しいテンプレート名';

  @override
  String get uiImportFailedNoTypeNodesFoundInThe =>
      'インポートに失敗しました。ファイルに <Type> ノードがありません。';

  @override
  String uiCouldNotReadFile(String p1) {
    return 'ファイルを読み込めません：$p1';
  }

  @override
  String get uiExportFile => 'ファイルをエクスポート';

  @override
  String uiFileExportedTo(String p1) {
    return 'ファイルをエクスポートしました：$p1';
  }

  @override
  String uiPermanentlyDelete(String p1) {
    return '「$p1」を完全に削除しますか？';
  }

  @override
  String get uiToMakeALocationDisappearOnlyWithinThe =>
      '物語の中で場所を消滅させるだけなら、シーンのスナップショットを追加して「この時点で存在する」をオフにしてください。';

  @override
  String uiPermanentlyDeleteLocationNodes(String p1) {
    return '場所のノード $p1 件を完全に削除';
  }

  @override
  String uiRemoveLocationSnapshots(String p1) {
    return '場所のスナップショット $p1 件を削除';
  }

  @override
  String uiRemoveItemLinks(String p1) {
    return 'アイテムの関連 $p1 件を削除';
  }

  @override
  String uiClearItemLocationRecords(String p1) {
    return 'アイテムの所在地記録 $p1 件を消去';
  }

  @override
  String get uiDeletePermanently => '完全に削除';

  @override
  String get uiError => 'エラー';

  @override
  String get uiSuccess => '成功';

  @override
  String get uiSwitchModule => 'モジュールを切り替え';

  @override
  String get uiSearchModules => 'モジュールを検索';

  @override
  String get uiNoMatchingModules => '一致するモジュールがありません';

  @override
  String get uiCurrentModule => '現在のモジュール';

  @override
  String get uiSyncConflictsChooseAVersionForEachField =>
      '同期の競合：各フィールドのバージョンを選択';

  @override
  String uiAllConflictingFieldsResolved(String p1) {
    return '競合する $p1 フィールドすべてを選択済み';
  }

  @override
  String uiUnresolvedFields(String p1) {
    return '未選択の競合フィールド：$p1';
  }

  @override
  String get uiDefaultAllFieldsToLocal => 'すべての既定値をローカルにする';

  @override
  String get uiDefaultAllFieldsToRemote => 'すべての既定値を相手側にする';

  @override
  String get uiCancelAndKeepBothVersions => 'キャンセルして両方のバージョンを保持';

  @override
  String uiApplyFieldChoicesAndFinishSync(String p1) {
    return '$p1 フィールドの選択を適用して同期を完了';
  }

  @override
  String uiConflictingFields(String p1, String p2) {
    return '競合 $p1 フィールド · $p2';
  }

  @override
  String get uiDefaultVersion => '既定のバージョン：';

  @override
  String get uiLocalVersion => 'ローカルのバージョン';

  @override
  String get uiRemoteVersion => '相手側のバージョン';

  @override
  String get uiInheritLocalVersion => '継承（ローカル）';

  @override
  String get uiInheritRemoteVersion => '継承（相手側）';

  @override
  String get uiInheritNotSet => '継承（未設定）';

  @override
  String uiConflictingField(String p1) {
    return '競合フィールド：$p1';
  }

  @override
  String get uiUnresolved => '未選択';

  @override
  String get uiResolved => '選択済み';

  @override
  String get uiCommonAncestor => '共通の祖先';

  @override
  String get uiMissingDeleted => '（存在しない・削除済み）';

  @override
  String get uiWork => '作品';

  @override
  String get uiProjectSections => 'プロジェクトの区分';

  @override
  String get uiPreparingContentAndPackage => '内容とパッケージを準備中…';

  @override
  String uiCouldNotPrepareExport(String p1) {
    return 'エクスポートを準備できません：$p1';
  }

  @override
  String get uiChooseALocationAndSave => '保存先を選んで保存…';

  @override
  String get uiSaveCancelledYouCanChooseAnotherLocation =>
      '保存をキャンセルしました。保存先を選び直せます。';

  @override
  String uiSourceSnapshotTakenWhenExportOpened(String p1) {
    return '出力元：$p1（エクスポートを開いた時点のスナップショット）';
  }

  @override
  String get uiCurrentWork => '現在の作品';

  @override
  String get uiPurpose => '用途';

  @override
  String get uiManuscriptDelivery => '本文の提出';

  @override
  String get uiReferenceMaterial => '設定資料の閲覧用';

  @override
  String get uiPartialProjectExchange => 'プロジェクトの一部を交換';

  @override
  String get uiContentFormat => '出力形式';

  @override
  String get uiFileOrganization => 'ファイルの構成';

  @override
  String get uiCombineIntoOneDocument => '1 つの文書にまとめる';

  @override
  String get uiSeparateDocumentsZIP => '文書を分割（ZIP）';

  @override
  String get uiIncludeWorkInformation => '作品情報を含める';

  @override
  String get uiIncludeFolderManuscriptTitles => 'フォルダー・原稿のタイトルを含める';

  @override
  String get uiCurrentManuscriptOnly => '現在の原稿のみ';

  @override
  String uiPreviewDocumentsBytes(String p1, String p2, String p3) {
    return 'プレビュー：$p1 文書 · $p2 bytes · .$p3';
  }

  @override
  String get uiGeneratePreview => 'プレビューを生成';

  @override
  String get uiBackToOptions => '設定に戻る';

  @override
  String get uiThisModuleIsExportedInFull => 'このモジュールは全内容をエクスポートします。';

  @override
  String get uiZIPFileTree => 'ZIP ファイルツリー';

  @override
  String get uiExportNotes => 'エクスポートの説明';

  @override
  String get uiFileAndHierarchyIndex => 'ファイルと階層の索引';

  @override
  String get uiSearchNamesKeepSelection => '名前で検索（選択を保持）';

  @override
  String get uiSelectEntireList => '一覧をすべて選択';

  @override
  String get uiClearListSelection => '一覧の選択を解除';

  @override
  String get uiExpandAll => 'すべて展開';

  @override
  String get uiCollapseAll => 'すべて折りたたむ';

  @override
  String uiSelectedOf(String p1, String p2) {
    return '$p1／$p2 項目を選択';
  }

  @override
  String get uiNoMatchingEntries => '一致する項目がありません';

  @override
  String uiCollapse3(String p1) {
    return '$p1を折りたたむ';
  }

  @override
  String uiExpand2(String p1) {
    return '$p1を展開';
  }

  @override
  String uiSelectedOf2(String p1, String p2, String p3, String p4) {
    return '$p1、$p2、$p3／$p4 を選択';
  }

  @override
  String uiOnlyThisItem(String p1) {
    return 'この項目のみ：$p1';
  }

  @override
  String get uiSearchNameTypeOrAffiliation => '名前、種類、所属情報で検索';

  @override
  String get uiShowArchivedItems => 'アーカイブ済みアイテムを表示';

  @override
  String get uiNoMatchingObjects => '一致するオブジェクトがありません。';

  @override
  String get uiUntitledLocation => '無題の場所';

  @override
  String get uiUnnamedCharacter => '名前のない人物';

  @override
  String uiCharacter2(String p1) {
    return '人物$p1';
  }

  @override
  String uiLiteral3(String p1) {
    return '・$p1';
  }

  @override
  String get uiUntitledEvent2 => '無題のイベント';

  @override
  String uiEvent4(String p1) {
    return 'イベント・$p1';
  }

  @override
  String uiScene2(String p1) {
    return 'シーン・$p1';
  }

  @override
  String get uiUntitledItemClass => '無題のアイテムクラス';

  @override
  String uiAllocations(String p1) {
    return '割り当て：$p1 件';
  }

  @override
  String uiItemClass2(String p1, String p2, String p3) {
    return 'アイテムクラス・$p1・$p2$p3';
  }

  @override
  String get uiArchived => '・アーカイブ済み';

  @override
  String uiIndividualItem(String p1, String p2, String p3) {
    return '個別アイテム・$p1・$p2$p3';
  }

  @override
  String get uiUnassigned2 => '未指定';

  @override
  String get uiAddAGaugeToViewYourWritingProgress => 'ゲージを追加すると執筆の進捗を確認できます。';

  @override
  String get uiAddGauge => 'ゲージを追加';

  @override
  String get uiAllGaugesAreAlreadyShown => 'すべてのゲージを表示中';

  @override
  String get uiWords => ' 文字';

  @override
  String get uiEntries4 => ' 件';

  @override
  String get uiStatisticsTemporarilyUnavailable => '統計を一時的に利用できません';

  @override
  String get uiChooseAChapter => '章を選択してください';

  @override
  String get uiNoProgressYet => 'まだ進捗がありません';

  @override
  String get uiWords2 => '文字';

  @override
  String get uiEntries5 => '件';

  @override
  String uiInformation(String p1) {
    return '$p1の情報';
  }

  @override
  String uiCurrent(String p1, String p2) {
    return '現在：$p1 $p2';
  }

  @override
  String get uiGoal2 => '目標';

  @override
  String get uiTotal => '合計';

  @override
  String uiAllLocalWorks(String p1) {
    return '$p1 · ローカルの全作品の合計';
  }

  @override
  String get uiFullWidthCharactersHalfWidthWordsAdditionsMinus =>
      '全角文字数＋半角単語数。追加から削除を差し引きます';

  @override
  String uiNetDecreaseTodayWords(String p1) {
    return '今日の純減：$p1 文字';
  }

  @override
  String get uiProcessingStatistics => '統計を処理中…';

  @override
  String get uiCouldNotSaveStatisticsClickToRetry => '統計を保存できません。クリックして再試行';

  @override
  String get uiThisFileOnly => 'このファイルのみ';

  @override
  String get uiSetWordCountGoal => '文字数の目標を設定';

  @override
  String get uiRemoveGauge => 'ゲージを削除';

  @override
  String get uiTrackingNotStarted => '追跡未開始';

  @override
  String get uiCalculating => '計算中';

  @override
  String get uiCalculationFailed => '計算失敗';

  @override
  String get uiNoRevisionsYet => 'まだ校訂がありません';

  @override
  String get uiComparisonComplete => '比較完了';

  @override
  String uiOuterRingAdditionsInnerRingRevisions(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  ) {
    return '外側の追加：$p1 件（$p2%）\n内側の校訂：$p3 件（$p4%）\n$p5';
  }

  @override
  String get uiRevisionTrackingInformation => '変更履歴の情報';

  @override
  String uiOuterRingAdditions(String p1) {
    return '外側の追加：$p1 件';
  }

  @override
  String uiInnerRingRevisions(String p1) {
    return '内側の校訂：$p1 件';
  }

  @override
  String uiComparisonBaseline(String p1) {
    return '比較の基準：$p1';
  }

  @override
  String get uiManuscriptChangesAreCountedByChangedLinesSettings =>
      '本文は変更行、設定はデータ件数で集計します。変更は追加と校訂にそれぞれ 1 件として数えます。';

  @override
  String get uiEachRingShowsItsCountAsAShare => '2 つのリングは、各種の件数が合計に占める割合を示します。';

  @override
  String get uiViewRevisionDetails => '校訂の詳細を表示';

  @override
  String get uiTrackRevisions => '変更履歴';

  @override
  String uiIsEditingThisChapter(String p1) {
    return '$p1 がこの章を編集中';
  }

  @override
  String get uiStoryRange => '物語の範囲';

  @override
  String get uiByStorylineTypeAndOrderWeightEventsScenes =>
      'ストーリーラインの種類と順序別 · 重み＝1＋イベント数＋シーン数';

  @override
  String get uiAddStorylinesToDisplayTheStoryRangeHere =>
      'ストーリーラインを追加すると、ここに物語の範囲を表示します。';

  @override
  String uiStorylinesWeight(String p1, String p2, String p3, String p4) {
    return '$p1、ストーリーライン $p2〜$p3、重み $p4';
  }

  @override
  String uiSnapshotBoundToStartTick(String p1, String p2) {
    return 'スナップショットの関連先：$p1 · 開始 Tick $p2';
  }

  @override
  String get uiNoSceneSelected => 'シーン未選択';

  @override
  String get uiDragOntoASingleSceneToSelectIt =>
      '単一のシーンにドラッグして選択できます。空白や重複部分ではシーンメニューを使用してください。';

  @override
  String get uiLiteral4 => '繁體中文';

  @override
  String get uiLiteral5 => '日本語';

  @override
  String get uiBeyondUsingThisThemeWhatElseCanYou => 'このテーマを使うほかに、できること…';

  @override
  String get uiRespectPeopleSNamesAndPronounsJoinEvents =>
      '一人ひとりの名前や代名詞を尊重し、プライドなどのイベントに参加し、LGBTQ+ の声に耳を傾け、日常で平等を支え、差別をなくす行動をしましょう。';

  @override
  String get uiTimelineAndSnapshots => 'タイムラインとスナップショット';

  @override
  String uiEventsAtTick(String p1) {
    return 'Tick $p1 のイベント';
  }

  @override
  String get uiEditingDefaultDataEnableFollowTimelineToPreview =>
      '既定データを編集中です。「タイムラインに追従」を有効にすると、指定 Tick をプレビューできます。';

  @override
  String get uiNoSnapshotAtThisTickPreviewOnlyAdd =>
      'この Tick にはスナップショットがないためプレビューのみです。編集するには追加してください。既定データを編集するには「タイムラインに追従」を無効にします。';

  @override
  String get uiOnlyAnInheritedClassStateExistsAtThis =>
      'この Tick にはクラスから継承した状態のみあります。編集するには個別スナップショットを追加してください。';

  @override
  String get uiEditingThisTickSSnapshotChangesAreSaved =>
      'この Tick のスナップショットを編集中です。変更はこのイベントのみに保存されます。';

  @override
  String get uiIndependentPreview => '独立プレビュー';

  @override
  String get uiHistoricalPreview => '履歴プレビュー';

  @override
  String get uiFollowTimeline => 'タイムラインに追従';

  @override
  String get uiPreviousEvent => '前のイベント';

  @override
  String get uiNextEvent => '次のイベント';

  @override
  String get uiLocateOnMainTimeline => 'メインタイムラインで表示';

  @override
  String get uiSceneDisplayRange => 'シーンの表示範囲';

  @override
  String get uiRelatedScenes => '関連するシーン';

  @override
  String get uiAllScenes => 'すべてのシーン';

  @override
  String get uiNoSnapshotEventsPreviewAnyTick =>
      'スナップショットのイベントがありません。任意の Tick をプレビューできます';

  @override
  String get uiSceneNotScheduledUsingFallbackTime => 'シーンが未配置のため、代替の時間を使用';

  @override
  String uiCouldNotLoadWritingGoals(String p1) {
    return '執筆目標を読み込めません：$p1';
  }

  @override
  String get uiDailyNetWordGainAcrossAllLocalWorks => 'ローカルの全作品を合計した 1 日の純増文字数';

  @override
  String get uiSavedWithTheCurrentWorkAndAppliedTo =>
      '現在の作品と一緒に保存し、このファイルに適用します。';

  @override
  String get uiApplyToWorksWithoutAFileSpecificGoal => 'ファイル専用の目標がない作品に適用します。';

  @override
  String uiThisFileStillUsesItsOwnGoalOf(String p1) {
    return 'このファイルは引き続き専用の目標 $p1 文字を使用します。';
  }

  @override
  String get uiWordCountGoal => '目標文字数';

  @override
  String get uiRestoreDefault => '既定に戻す';

  @override
  String get uiSaving => '保存中…';

  @override
  String get uiCouldNotReadWritingGoalsClickToRetry => '執筆目標を読み込めません。クリックして再試行';

  @override
  String get uiAllLocalWorksCombined => 'ローカルの全作品の合計';

  @override
  String get uiDefaultFileSpecificValuesCanBeSetFrom =>
      '既定値。ファイル専用の値は各ゲージから設定できます';

  @override
  String get uiEnterAnAlias => '別名を入力してください';

  @override
  String get uiAliasAlreadyExists => 'この別名はすでに存在します';

  @override
  String get uiThisAliasWasRemovedCancelAndTryAgain =>
      'この別名は削除されています。キャンセルして再試行してください';

  @override
  String get uiAlias => '別名';

  @override
  String get uiEnterAlias => '別名を入力';

  @override
  String get uiTimeMarker => '時間マーカー';

  @override
  String get uiUntitledNode => '無題のノード';

  @override
  String get uiEnabled => '有効';

  @override
  String get uiStandby => '待機';

  @override
  String get uiAttentionRequired => '対処が必要';

  @override
  String get uiAwaitingConfirmation => '確認待ち';

  @override
  String get uiActive => '継続中';

  @override
  String get uiLinked => 'リンク済み';

  @override
  String get uiInformation2 => '情報';

  @override
  String get uiProcessing => '処理中';

  @override
  String get uiSaveProjectFile => 'プロジェクトファイルを保存';

  @override
  String get uiExportTextFile => 'テキストファイルをエクスポート';

  @override
  String get uiSomeWordCountGoalsCouldNotBeParsed =>
      '文字数の目標に読み取れないデータがあります。元のデータは保持し、読み取れる目標または既定値を使用します。';

  @override
  String get uiXmlVersionEncodingUTF =>
      '<?xml version=\"1.0\" encoding=\"UTF-8\"?>';

  @override
  String get uiChooseAutoBackupFolder => 'AutoBackup フォルダーを選択';

  @override
  String get uiStartWriting => '本文を書き始める…';

  @override
  String get uiResolved2 => '回収済み';

  @override
  String get uiUnresolved2 => '未回収';

  @override
  String get uiInProgress => '進行中';

  @override
  String get uiDedicated => '専用';

  @override
  String get uiSemiDedicated => '半専用';

  @override
  String get uiNonDedicated => '非専用';

  @override
  String get uiArchived2 => 'アーカイブ済み';

  @override
  String get uiHome2 => 'ホーム';

  @override
  String get uiStorySettings => '作品設定';

  @override
  String get uiCharacters4 => '人物設定';

  @override
  String get uiManuscriptEditor => '本文編集';

  @override
  String get uiAbout => 'バージョン情報';

  @override
  String get uiGray => 'グレー';

  @override
  String get uiRed => '赤';

  @override
  String get uiOrange => 'オレンジ';

  @override
  String get uiYellow => '黄';

  @override
  String get uiGreen => '緑';

  @override
  String get uiCyan => 'シアン';

  @override
  String get uiBlue => '青';

  @override
  String get uiPurple => '紫';

  @override
  String get uiPink => 'ピンク';

  @override
  String get uiIconsAndText => 'アイコンとテキスト';

  @override
  String get uiExpandWithButton => 'ボタンで展開';

  @override
  String get uiFollowSystem => 'システムに合わせる';

  @override
  String get uiMonoAshi => 'ものアシ';

  @override
  String get uiMosaicMarkerIsIncompleteOrInvalid => 'モザイクのマーカーが未完成か無効です';

  @override
  String get uiExportPhraseLibrary => 'フレーズ集をエクスポート';

  @override
  String get uiPink2 => 'ピンク';

  @override
  String get uiCharacterSuggestions => '人物の候補';

  @override
  String get uiSearchAndInsertProjectPhrases => 'プロジェクトのフレーズを検索して挿入';

  @override
  String get uiLocationSuggestions => '場所の候補';

  @override
  String get uiEventSuggestions => 'イベントの候補';

  @override
  String get uiForeshadowingSuggestions => '伏線の候補';

  @override
  String get uiPlanSuggestions => '計画の候補';

  @override
  String get uiItemSuggestions => 'アイテムの候補';

  @override
  String get uiHighlightColorSuggestions => 'ハイライト色の候補';

  @override
  String get uiCharacterMarkerTemplate => '人物マーカーのひな形';

  @override
  String get uiLocationMarkerTemplate => '場所マーカーのひな形';

  @override
  String get uiEventMarkerTemplate => 'イベントマーカーのひな形';

  @override
  String get uiForeshadowingMarkerTemplate => '伏線マーカーのひな形';

  @override
  String get uiPlanMarkerTemplate => '計画マーカーのひな形';

  @override
  String get uiItemMarkerTemplate => 'アイテムマーカーのひな形';

  @override
  String get uiHighlightMarkerTemplate => 'ハイライトマーカーのひな形';

  @override
  String get uiInsertLiteral => '文字として / を挿入';

  @override
  String get uiWriteAsToPreventParsingAsASyntax => '構文の区切りと解釈されないよう \\/ として挿入';

  @override
  String get uiInsertLiteral2 => '文字として \\ を挿入';

  @override
  String get uiWriteAs => '\\\\ として挿入';

  @override
  String get uiCharacterPrimaryName => '人物・正式名';

  @override
  String get uiAddAlias2 => '別名を追加…';

  @override
  String get uiEnterOtherDisplayText => '別の表示文字を入力…';

  @override
  String get uiUseOnlyForThisMentionDoNotAdd => 'このメンションのみに使用し、別名には追加しない';

  @override
  String get uiAddChildLocation => '子の場所を追加…';

  @override
  String get uiAddEvent2 => 'イベントを追加…';

  @override
  String get uiAddScene2 => 'シーンを追加…';

  @override
  String get uiStoryline3 => 'ストーリーライン';

  @override
  String get uiEvent5 => 'イベント';

  @override
  String get uiScene3 => 'シーン';

  @override
  String get uiInsertMarkerImmediatelyAfterCreation => '作成後すぐにマーカーを挿入';

  @override
  String get uiHighlightBackgroundAutomaticTextColor => '背景をハイライト・文字色は自動';

  @override
  String get uiOnlyForThisAnnotation => 'この注釈のみに使用';

  @override
  String get uiAnnotation3 => '注釈';

  @override
  String get uiMarkerBackgroundColorCodeAutomaticTextColor =>
      'マーカーの背景色コード・文字色は自動';

  @override
  String get uiWorkInformation => '作品情報';

  @override
  String get uiChapters2 => '章';

  @override
  String get uiCreativePurpose => '創作の目的';

  @override
  String get uiSynopsis2 => 'あらすじ';

  @override
  String get uiGenre => 'ジャンル';

  @override
  String get uiAge3 => '年齢';

  @override
  String get uiRoleOccupation2 => '役割・職業';

  @override
  String get uiPersonality2 => '性格';

  @override
  String get uiSpeechStyle2 => '話し方';

  @override
  String get uiMotivation2 => '動機';

  @override
  String get uiCustomField => 'カスタムフィールド';

  @override
  String get uiFieldValue => 'フィールドの値';

  @override
  String get uiLocationType => '場所の種類';

  @override
  String get uiNodeType2 => 'ノードの種類';

  @override
  String get uiConflict => '対立';

  @override
  String get uiDefaultState => '既定の状態';

  @override
  String get uiStateChanges => '状態変化';

  @override
  String get uiAffiliation => '所属';

  @override
  String get uiOrder => '順序';

  @override
  String get uiChinaSGreatestAndMostEnduringArtIs =>
      '中国の最も偉大で最も永続的な芸術は、男性が女性を演じることである';

  @override
  String get uiLuXun => '—— 魯迅（1881–1936）';

  @override
  String get uiYyyyMMDdHHMmSs => 'yyyy.MM.dd HH:mm:ss';

  @override
  String get uiAddCharacterRelationship => '人物関係を追加';

  @override
  String get uiProtagonist => '主人公';

  @override
  String get uiMajorSupportingCharacter => '主要な脇役';

  @override
  String get uiMainAntagonist => '主要な敵役';

  @override
  String get uiSecondaryAntagonist => '副次的な敵役';

  @override
  String get uiUntitled2 => '無題';

  @override
  String get uiCooking => '料理';

  @override
  String get uiUnskilled => '苦手';

  @override
  String get uiSkilled => '得意';

  @override
  String get uiCleaning => '掃除';

  @override
  String get uiMoneyManagement => '金銭管理';

  @override
  String get uiFitness => '体力';

  @override
  String get uiArt => '美術';

  @override
  String get uiMusic => '音楽';

  @override
  String get uiDance => 'ダンス';

  @override
  String get uiCrafts => '手作業';

  @override
  String get uiSocialSkills => '社交';

  @override
  String get uiLeadership => '統率';

  @override
  String get uiAnalysis => '分析';

  @override
  String get uiCreativity => '創造力';

  @override
  String get uiMemory => '記憶力';

  @override
  String get uiObservation => '観察力';

  @override
  String get uiAdaptability => '対応力';

  @override
  String get uiLearning => '学習';

  @override
  String get uiIntroverted => '内向的';

  @override
  String get uiExtroverted => '外向的';

  @override
  String get uiEmotional => '感情的';

  @override
  String get uiRational => '理性的';

  @override
  String get uiPassive => '受動的';

  @override
  String get uiProactive => '能動的';

  @override
  String get uiConservative => '保守的';

  @override
  String get uiOpenMinded => '開放的';

  @override
  String get uiCautious => '慎重';

  @override
  String get uiAdventurous => '冒険的';

  @override
  String get uiDependent => '依存的';

  @override
  String get uiIndependent => '自立的';

  @override
  String get uiGentle => '従順';

  @override
  String get uiStubborn => '頑固';

  @override
  String get uiPessimistic => '悲観的';

  @override
  String get uiOptimistic => '楽観的';

  @override
  String get uiSerious => '真面目';

  @override
  String get uiHumorous => 'ユーモラス';

  @override
  String get uiShy => '恥ずかしがり';

  @override
  String get uiOutgoing => 'おおらか';

  @override
  String get uiLowKey => '控えめ';

  @override
  String get uiShowy => '目立ちたがり';

  @override
  String get uiNegative => '消極的';

  @override
  String get uiPositive => '積極的';

  @override
  String get uiCunning => '狡猾';

  @override
  String get uiHonest => '正直';

  @override
  String get uiChildish => '幼稚';

  @override
  String get uiMature => '成熟';

  @override
  String get uiCalm => '冷静';

  @override
  String get uiImpulsive => '衝動的';

  @override
  String get uiQuiet => '寡黙';

  @override
  String get uiTalkative => 'おしゃべり';

  @override
  String get uiObstinate => '執拗';

  @override
  String get uiCompliant => '従順';

  @override
  String get uiUnrestrained => '奔放';

  @override
  String get uiSelfDisciplined => '自律的';

  @override
  String get uiFrivolous => '軽薄';

  @override
  String get uiAwkward => 'ひねくれ';

  @override
  String get uiFrank => '率直';

  @override
  String get uiIndifferent => '淡白';

  @override
  String get uiCurious => '好奇心旺盛';

  @override
  String get uiSlowToNotice => '鈍感';

  @override
  String get uiPerceptive => '敏感';

  @override
  String get uiExpressionless => '無表情';

  @override
  String get uiExpressive => '表情豊か';

  @override
  String get uiFoolish => 'おバカ';

  @override
  String get uiGenius => '天才';

  @override
  String get uiSimple => '単純';

  @override
  String get uiComplex => '複雑';

  @override
  String get uiEasilyEmbarrassed => '恥ずかしがり';

  @override
  String get uiShameless => '厚かましい';

  @override
  String get uiMild => '温和';

  @override
  String get uiHotTempered => '短気';

  @override
  String get uiRough => '粗野';

  @override
  String get uiRefined => '上品';

  @override
  String get uiWeakWilled => '気弱';

  @override
  String get uiDetermined => '意志が強い';

  @override
  String get uiWithoutDesire => '無欲';

  @override
  String get uiIntense => '欲望が強い';

  @override
  String get uiTimid => '臆病';

  @override
  String get uiBrave => '勇敢';

  @override
  String get uiInarticulate => '口下手';

  @override
  String get uiWitty => '機知に富む';

  @override
  String get uiTrusting => '信じやすい';

  @override
  String get uiSuspicious => '疑い深い';

  @override
  String get uiInsecure => '自信がない';

  @override
  String get uiConfident => '自信がある';

  @override
  String get uiWithdrawn => '引っ込み思案';

  @override
  String get uiDecisive => '果敢';

  @override
  String get uiSociallyReserved => '陰キャ';

  @override
  String get uiSociallyOutgoing => '陽キャ';

  @override
  String get uiConfessDirectly => '直接告白する';

  @override
  String get uiGiveGifts => '贈り物をする';

  @override
  String get uiTalkToThemOften => 'よく話しかける';

  @override
  String get uiDoLittleThingsToGetAttention => 'さりげなく気を引く';

  @override
  String get uiQuietlyPayAttention => 'ひそかに見守る';

  @override
  String get uiSmile => '微笑む';

  @override
  String get uiGreetThemFirst => '自分から挨拶する';

  @override
  String get uiOfferHelp => '自分から手伝う';

  @override
  String get uiGiveSmallGifts => 'ささやかな贈り物をする';

  @override
  String get uiInviteThem => '誘う';

  @override
  String get uiSharePersonalStories => '自分のことを話す';

  @override
  String get uiIgnoreThem => '無視する';

  @override
  String get uiKeepADistance => '距離を置く';

  @override
  String get uiRespondPolitely => '礼儀正しく接する';

  @override
  String get uiUseSarcasm => '皮肉を言う';

  @override
  String get uiConfrontThem => '正面から対立する';

  @override
  String get uiAskOthersForHelp => '人に助けを求める';

  @override
  String get uiLawfulGood => '秩序にして\n善';

  @override
  String get uiNeutralGood => '中立にして\n善';

  @override
  String get uiChaoticGood => '混沌にして\n善';

  @override
  String get uiLawfulNeutral => '秩序にして\n中立';

  @override
  String get uiTrueNeutral => '真なる\n中立';

  @override
  String get uiChaoticNeutral => '混沌にして\n中立';

  @override
  String get uiLawfulEvil => '秩序にして\n悪';

  @override
  String get uiNeutralEvil => '中立にして\n悪';

  @override
  String get uiAbsoluteEvil => '絶対的な\n悪';

  @override
  String get uiSingle => '独身';

  @override
  String get uiMarriedEngaged => '既婚・婚約中';

  @override
  String get uiDatingStartingARelationship => '交際中・交際予定';

  @override
  String get uiWidowed => '死別';

  @override
  String get uiScene4 => 'シーン';

  @override
  String get uiComma => 'コンマ';

  @override
  String get uiPeriod => '句点';

  @override
  String get uiEnumerationComma => '読点';

  @override
  String get uiEllipsis => '三点リーダー';

  @override
  String get uiSameTypeQuotes => '同種の引用符';

  @override
  String get uiResolveThisIssue => 'この項目を修正';

  @override
  String get uiProofreadingWorkerHasBeenDisposed => '校正ワーカーは終了しました。';

  @override
  String get uiQuotesShouldStartWithNot => '引用符は \' \' ではなく \" \" から始めてください。';

  @override
  String get uiQuoteLevelsShouldAlternateBetweenAnd =>
      '引用符の階層は \" \" と \' \' を交互に使用してください。';

  @override
  String get uiQuotesShouldStartWithNot2 => '引用符は『』ではなく「」から始めてください。';

  @override
  String get uiQuoteLevelsShouldAlternateInACycle =>
      '引用符の階層は「『』」の順に交互に使用してください。';

  @override
  String get uiSeconds => '秒';

  @override
  String get uiMinutes2 => '分';

  @override
  String get uiHours => '時間';

  @override
  String get uiDays => '日';

  @override
  String get uiWeeks => '週';

  @override
  String get uiMonths => 'か月';

  @override
  String get uiSeasons => '季節';

  @override
  String get uiYears => '年';

  @override
  String get uiDecades => '十年';

  @override
  String get uiCenturies => '世紀';

  @override
  String get uiCustomUnit => 'カスタム単位';

  @override
  String get uiChooseObject => 'オブジェクトを選択';

  @override
  String get uiDailyGoal => '毎日の目標';

  @override
  String get uiBookWordCount => '全書の文字数';

  @override
  String get uiForeshadowingResolution => '伏線の回収';

  @override
  String get uiOrange2 => 'オレンジ';

  @override
  String get uiNoTimelineNodesYet => 'タイムラインのノードがありません';

  @override
  String get uiMiniTimeline => 'ミニタイムライン';

  @override
  String get uiDefaultChapterWordCountGoal => '章あたりの目標文字数';

  @override
  String get uiDefaultProjectWordCountGoal => '全文の目標文字数';

  @override
  String get uiNoDataYet => 'データがありません';

  @override
  String get uiUseEitherTitleOrTitleWidgetNotBoth =>
      'title と titleWidget は同時に指定できません。';

  @override
  String get uiControllerAndInitialValueCannotBothBeSupplied =>
      'controller と initialValue は同時に指定できません。';

  @override
  String get uiMinLinesAndMaxLinesMustBeNullWhenExpands =>
      'expands が true の場合、minLines と maxLines は null にしてください。';

  @override
  String get uiUseEitherTitleOrACustomHeaderNot =>
      'title とカスタムヘッダーは同時に指定できません。';

  @override
  String get uiUseEitherBackgroundColorOrColorNotBoth =>
      'backgroundColor と color は同時に指定できません。';

  @override
  String get uiUseEitherActionOrActionLabelOnAction =>
      'action または actionLabel/onAction のいずれかを使用してください。';

  @override
  String get uiActionLabelAndOnActionMustBeProvidedTogether =>
      'actionLabel と onAction は一緒に指定してください。';

  @override
  String get uiAControllerIsRequiredWhenShowScrollbarIsTrue =>
      'showScrollbar が true の場合は controller が必要です。';

  @override
  String get uiBlank2 => '（空白）';

  @override
  String get uiStandard => '標準';

  @override
  String get uiHighContrast => 'ハイコントラスト';

  @override
  String get uiShowYourPrideRainbow => 'Show Your Pride／レインボー';

  @override
  String get uiShowYourPrideLesbian => 'Show Your Pride／レズビアン';

  @override
  String get uiShowYourPrideBisexual => 'Show Your Pride／バイセクシュアル';

  @override
  String get uiShowYourPrideTransgender => 'Show Your Pride／トランスジェンダー';

  @override
  String get navigationTooltipDescription => 'アイコンのみ表示し、ホバーまたはフォーカス時に名前を表示します。';

  @override
  String get navigationLabelDescription => 'アイコンの下に常に名前を表示します。';

  @override
  String get navigationDrawerDescription =>
      '下部のボタンでナビゲーションを展開し、コンテンツのサイドバーを移動します。';

  @override
  String get navigationHoverDescription =>
      'ホバーでプレビューし、離れると折りたたみます。固定するとサイドバーを移動して表示します。';

  @override
  String get toolbarFullDescription => 'タブ、グループ、コマンド名を含むリボン全体を表示します。';

  @override
  String get toolbarModerateDescription =>
      'リボンのタブを保持し、アイコンと名前を横スクロールできる 1 行で表示します。';

  @override
  String get toolbarConciseDescription =>
      'リボンのタブを保持し、アイコンを横スクロールできる 1 行で表示します。';

  @override
  String get exportWordUnavailable => 'Word（近日公開）';

  @override
  String get exportPdfUnavailable => 'PDF（近日公開）';

  @override
  String get exchangeChapters => '章の本文';

  @override
  String get exchangeOutline => 'アウトラインとタイムライン';

  @override
  String get exchangePlans => '更新計画と伏線';

  @override
  String get exchangeWorld => '世界設定と場所のスナップショット';

  @override
  String get exchangeCharacters => '人物設定とスナップショット';

  @override
  String get exchangeItems => 'アイテム設定とスナップショット';

  @override
  String get characterMinorSupporting => '脇役';

  @override
  String untitledTimelineNode(String label) {
    return '無題の$label';
  }

  @override
  String welcomeMorning(String name) {
    return 'おはようございます。\n$nameさん！';
  }

  @override
  String welcomeAfternoon(String name) {
    return 'こんにちは。\n$nameさん！';
  }

  @override
  String welcomeEvening(String name) {
    return 'こんばんは。\n$nameさん！';
  }

  @override
  String welcomeNight(String name) {
    return '夜も更けました。\n$nameさん！';
  }

  @override
  String get welcomeUser => 'ユーザー';

  @override
  String get ribbonMoreOptions => 'その他のオプション';

  @override
  String get ribbonCustomize => 'リボンをカスタマイズ';

  @override
  String get ribbonQuickAccess => 'クイックアクセスツールバー';

  @override
  String get ribbonTabs => 'リボンタブ';

  @override
  String get ribbonExpandQuickAccess => 'クイックアクセスツールバーを展開';

  @override
  String get ribbonCollapseQuickAccess => 'クイックアクセスツールバーを折りたたむ';

  @override
  String get ribbonCustomizeQuickAccess => 'クイックアクセスツールバーをカスタマイズ';

  @override
  String get ribbonMoreQuickAccess => 'その他のクイックアクセスコマンド';

  @override
  String ribbonExpand(String shortcut) {
    return 'リボンを展開（$shortcut）';
  }

  @override
  String ribbonCollapse(String shortcut) {
    return 'リボンを折りたたむ（$shortcut）';
  }

  @override
  String get ribbonSearch => 'コマンドを検索';

  @override
  String get ribbonTextColor => '文字の色';

  @override
  String get ribbonColor => '色';

  @override
  String get ribbonFont => 'フォント';

  @override
  String ribbonTabSemantics(String label) {
    return '$labelタブ';
  }

  @override
  String ribbonMoveTabUp(String label) {
    return '$labelを上へ移動';
  }

  @override
  String ribbonMoveTabDown(String label) {
    return '$labelを下へ移動';
  }

  @override
  String ribbonCommandsSemantics(String label) {
    return '$labelのコマンド';
  }

  @override
  String ribbonGroupSemantics(String label) {
    return '$labelグループ';
  }

  @override
  String get ribbonTabNavigation => '左右の方向キー、Home、End でタブを切り替えます。';

  @override
  String get ribbonReset => '既定値に戻す';

  @override
  String get ribbonDone => '完了';

  @override
  String completionBrowseTargets(String p1) {
    return '$p1の対象を参照';
  }

  @override
  String completionPendingLink(String p1) {
    return 'リンク待ち：$p1';
  }

  @override
  String completionAlias(String p1, String p2) {
    return '$p1・$p2の別名';
  }

  @override
  String completionCharacterAlias(String p1) {
    return '人物・$p1の別名';
  }

  @override
  String completionAddAlias(String p1) {
    return '$p1の別名を追加';
  }

  @override
  String completionCreateTarget(String p1) {
    return '$p1を追加…';
  }

  @override
  String completionHighlightForeground(String p1) {
    return 'ハイライト文字色・背景 $p1';
  }

  @override
  String completionMarkerForeground(String p1) {
    return 'マーカー文字色コード・背景 $p1';
  }

  @override
  String relationshipAmbiguousName(String p1) {
    return '名前が一意ではありません：$p1';
  }

  @override
  String relationshipUnlinked(String p1) {
    return '未リンク：$p1';
  }

  @override
  String snapshotConflictsCount(String p1) {
    return '障害 $p1';
  }

  @override
  String snapshotRelationshipsCount(String p1) {
    return '人物関係 $p1';
  }

  @override
  String snapshotOrganizationsCount(String p1) {
    return '組織 $p1';
  }

  @override
  String snapshotStatusesCount(String p1) {
    return '人物の状態 $p1';
  }

  @override
  String snapshotPossessionsCount(String p1) {
    return '所持品 $p1';
  }

  @override
  String snapshotCustomFieldsCount(String p1) {
    return 'カスタムフィールド $p1';
  }

  @override
  String inspirationNoteCount(String p1) {
    return 'アイデア $p1 件';
  }

  @override
  String proofUnmatchedClosing(String p1) {
    return '対応する開始記号がない閉じ記号「$p1」があります。';
  }

  @override
  String proofMismatchedPair(String p1, String p2, String p3) {
    return '閉じ記号「$p1」が開始記号「$p2」に対応していません。「$p3」が必要です。';
  }

  @override
  String proofUnclosedPair(String p1, String p2) {
    return '開始記号「$p1」が閉じられていません。「$p2」が不足しています。';
  }

  @override
  String proofEllipsisSuggestion(String p1) {
    return '三点リーダーには「……」を推奨します。現在は「$p1」です。';
  }

  @override
  String proofConsecutiveSymbols(String p1, String p2, String p3) {
    return '$p2が $p1 個連続しています：「$p3」。';
  }

  @override
  String proofInvalidLineEnding(String p1, String p2) {
    return '[$p1] 行末が規則に合っていません。現在は「$p2」です。';
  }

  @override
  String timelineUnnamedLevel(String p1) {
    return '無題の$p1';
  }

  @override
  String worldChildNodeCount(String p1, String p2) {
    return '$p1・子ノード $p2 件';
  }

  @override
  String get revisionUnaccept => '受け入れを取り消す';

  @override
  String get revisionAccept => '受け入れる';

  @override
  String get revisionReject => '拒否';

  @override
  String get relationshipExternal => '外的';

  @override
  String get relationshipInternal => '内的';

  @override
  String get writingGoalInvalid => '1 から 999,999,999 までの整数を入力してください。';

  @override
  String get worldRule => '規則';

  @override
  String get worldOrganization => '組織';

  @override
  String get glossaryPositive => '肯定的';

  @override
  String get glossaryNegative => '否定的';

  @override
  String get glossaryNeutral => '中立';

  @override
  String get glossaryNoun => '名詞';

  @override
  String get glossaryVerb => '動詞';

  @override
  String get glossaryAdjective => '形容詞';

  @override
  String get glossaryAdverb => '副詞';

  @override
  String get glossaryPronoun => '代名詞';

  @override
  String get glossaryUnspecified => '未指定';

  @override
  String get conflictUnskilledActivities => '苦手なこと';

  @override
  String get conflictPersonalityTraits => '性格の特性';

  @override
  String get conflictValue => '値';

  @override
  String get conflictValuesAndBeliefs => '価値観';

  @override
  String get conflictInternalConflict => '内面的な葛藤';

  @override
  String get conflictAllocatedQuantity => '割り当て数量';

  @override
  String get conflictFavoriteActivities => '好きなこと';

  @override
  String get conflictLikes => '好きなもの';

  @override
  String get conflictSynopsis => 'あらすじ';

  @override
  String get conflictName => '名前';

  @override
  String get conflictFearedActivities => '恐れていること';

  @override
  String get conflictFears => '怖いもの';

  @override
  String get conflictSeekingANewRelationship => '新しい恋を探す';

  @override
  String get conflictAdmiredThings => '憧れるもの';

  @override
  String get conflictCommonAbilities => '基本能力';

  @override
  String get conflictCommonAbilityValues => '基本能力値';

  @override
  String get conflictHarem => 'ハーレム';

  @override
  String get conflictFear => '恐れ';

  @override
  String get conflictDesiredActivities => 'やりたいこと';

  @override
  String get conflictDescription => '説明';

  @override
  String get conflictSkilledActivities => '得意なこと';

  @override
  String get conflictTextFields => 'テキストフィールド';

  @override
  String get conflictFamiliarThings => 'なじみのあるもの';

  @override
  String get conflictItemData => 'アイテムデータ';

  @override
  String get conflictTraitValues => '特性値';

  @override
  String get conflictSocialValues => '社交値';

  @override
  String get conflictSocialTraits => '社交の特性';

  @override
  String get conflictOccupationOrRole => '職業・役割';

  @override
  String get conflictLegacyFields => '旧形式のフィールド';

  @override
  String get conflictApproachValues => '対処の値';

  @override
  String get conflictApproaches => '対処の仕方';

  @override
  String get conflictHandlingDislike => '嫌いな相手への対応';

  @override
  String get conflictShowingGoodwill => '好意の示し方';

  @override
  String get conflictShowingLove => '愛情の示し方';

  @override
  String get conflictResolution => '解決';

  @override
  String get conflictResolutionMethod => '解決方法';

  @override
  String get conflictDislikedActivities => '嫌いなこと';

  @override
  String get conflictDislikes => '嫌いなもの';

  @override
  String get conflictAdvancedAbilities => '詳細な能力';

  @override
  String get conflictRelationship => '関係';

  @override
  String get conflictRelationshipSummary => '関係の概要';

  @override
  String get conflictObstacle => '障害';

  @override
  String get conflictGoalRecoveryData => '目標の復元データ';

  @override
  String get conflictWholeVersion => '全体のバージョン';

  @override
  String p2pConnectedAndVerifiedThisEndpointTCPWorks(String p1) {
    return '$p1 が接続し、この端点を検証しました。TCP は双方向で通信できるため、逆方向の接続は不要です。';
  }

  @override
  String p2pSentASecurePairingRequestThisDevice(String p1) {
    return '$p1 から安全なペアリング要求を受信しました。このデバイスが自動応答しています。';
  }

  @override
  String p2pCouldNotProcessTheRemotePairingEvent(String p1) {
    return '相手側のペアリングイベントを処理できません：$p1';
  }

  @override
  String p2pRejectedAnInvalidRemoteRevisionGraph(String p1) {
    return '無効な相手側のリビジョングラフを拒否しました：$p1';
  }

  @override
  String get p2pIgnoredAnExpiredPairingChallengeFromThe =>
      '前回の期限切れのペアリングチャレンジを無視しました。自動更新を待っています。';

  @override
  String get p2pThePeerSPairingChallengeIsInvalid =>
      '相手側のペアリングチャレンジが無効、改変済み、または期限切れです。';

  @override
  String get p2pTheTrustedDeviceSPublicKeyChanged =>
      '信頼済みデバイスの公開鍵が変わったため、ペアリングを拒否しました。';

  @override
  String get p2pThePeerRequestedSecurePairingButThis =>
      '安全なペアリングが要求されましたが、チャレンジをまだ作成できません。再試行を待っています。';

  @override
  String get p2pCompareTheSixDigitPairingCodeOn =>
      '両方のデバイスで 6 桁のコードを比較し、完全に一致する場合のみ確認してください。';

  @override
  String get p2pBothDevicesDayAuthenticationIsValidThis =>
      '両方のデバイスの 14 日間認証が有効なため、今回の短期セッションに自動署名しました。';

  @override
  String p2pPersistentAuthenticationCouldNotSignAutomatically(String p1) {
    return '継続認証の自動署名に失敗しました：$p1';
  }

  @override
  String get p2pIgnoredAPreviousPairingConfirmationWaitingFor =>
      '前回のペアリング確認を無視しました。現在のチャレンジへの署名を待っています。';

  @override
  String get p2pThePeerSPairingConfirmationSignatureOr =>
      '相手側のペアリング確認の署名またはトランスクリプトが一致しません。';

  @override
  String get p2pThePeerConfirmedTheCodeBothDevices =>
      '相手側がコードを確認しました。両方で片側確認が許可されているため、このデバイスも検証して自動署名しました。';

  @override
  String p2pCouldNotCompleteSecurePairingAutomatically(String p1) {
    return '安全なペアリングを自動完了できません：$p1';
  }

  @override
  String get p2pBothDevicesSignedTheSamePairingTranscript =>
      '両方のデバイスが同じペアリング内容に署名しました。認証済みの暗号化通信を確立しています。';

  @override
  String get p2pThePeerConfirmedTheCodeYourSettings =>
      '相手側がコードを確認しました。現在の設定では、このデバイスでの確認も必要です。';

  @override
  String get p2pAuthenticatedEncryptedTransportIsReadyRevisionSummaries =>
      '認証済みの暗号化通信を確立しました。リビジョンの概要とスナップショットのチャンクは、この経路のみで交換します。';

  @override
  String p2pCouldNotVerifyTheEncryptedChannelS(String p1) {
    return '暗号化経路のデバイス ID またはトランスクリプトを検証できません：$p1';
  }

  @override
  String p2pCouldNotEstablishAnEncryptedChannel(String p1) {
    return '暗号化経路を確立できません：$p1';
  }

  @override
  String p2pEncryptedRevisionSummariesAreTemporarilyUnavailable(String p1) {
    return '暗号化されたリビジョン概要を一時的に交換できません：$p1';
  }

  @override
  String p2pRejectedAnInvalidEncryptedRevisionSummary(String p1) {
    return '無効な暗号化リビジョン概要を拒否しました：$p1';
  }

  @override
  String p2pTheEncryptedChannelIsCurrentlyUnavailable(String p1) {
    return '暗号化経路を現在利用できません：$p1';
  }

  @override
  String p2pRejectedAnInvalidEncryptedRevisionGraph(String p1) {
    return '無効な暗号化リビジョングラフを拒否しました：$p1';
  }

  @override
  String p2pRevisionGraphTransferWasInterruptedReconnectTo(String p1) {
    return 'リビジョングラフの転送が中断されました。再接続して再開できます：$p1';
  }

  @override
  String p2pTheRevisionGraphIsCurrentlyUnavailable(String p1) {
    return 'リビジョングラフを現在利用できません：$p1';
  }

  @override
  String get p2pNoVerifiedPeerEndpointYetWaitFor =>
      '相手側の端点がまだ検証されていません。暗号化リビジョン概要の交換を待ってください。';

  @override
  String get p2pNoSnapshotIsCurrentlyAvailableToSend =>
      '検証済み接続で送信できるスナップショットがありません。';

  @override
  String get p2pSyncRequestedThroughTheEncryptedChannelWaiting =>
      '暗号化経路で同期を要求しました。受信側のダウンロードと保存先の選択を待っています。';

  @override
  String p2pCouldNotSendASyncRequest(String p1) {
    return '同期要求を送信できません：$p1';
  }

  @override
  String get p2pThePeerRequestedSyncThroughTheEncrypted =>
      '相手側が暗号化経路で同期を要求しました。スナップショットのダウンロードを準備しています。';

  @override
  String get p2pRejectedARemoteAcknowledgementWithAMismatched =>
      'デバイス ID またはプロジェクトのセッションが一致しない確認応答を拒否しました。';

  @override
  String get p2pReceivedThePeerSResolutionAcknowledgementWaiting =>
      '相手側の解決確認応答を受信しました。検証済みリビジョングラフの完成を待っています。';

  @override
  String get p2pRejectedAnAcknowledgementWhoseContentOrParent =>
      '内容または親がローカルの解決リビジョンと一致しない確認応答を拒否しました。';

  @override
  String get p2pThePeerAcknowledgedTheResolutionRevisionBoth =>
      '相手側が解決リビジョンを確認し、双方のリビジョングラフが一致しました。';

  @override
  String get p2pRejectedAnAcknowledgementAbsentFromThePeer =>
      '相手側の検証済みリビジョングラフに含まれない確認応答を拒否しました。';

  @override
  String get p2pThePeerAcknowledgedTheRemoteResolutionRevision =>
      '相手側がリモートの解決リビジョンを確認しました。ダウンロードと適用を待っています。';

  @override
  String get p2pCreatedAPairingChallengeValidForTen =>
      '10 分間有効なペアリングチャレンジを作成しました。相手側のペアリング開始を待っています。';

  @override
  String p2pCouldNotStartSecurePairing(String p1) {
    return '安全なペアリングを開始できません：$p1';
  }

  @override
  String get p2pThisDeviceSignedItsConfirmationWaitingFor =>
      'このデバイスが確認に署名しました。相手側の検証と自動署名を待っています。';

  @override
  String get p2pThisDeviceSignedAndTrustedThePeer =>
      'このデバイスが署名し、相手側を信頼リストに追加しました。相手側で同じ内容の手動確認を待っています。';

  @override
  String p2pCouldNotSaveTheTrustedDevice(String p1) {
    return '信頼済みデバイスを保存できません：$p1';
  }

  @override
  String get p2pPairingCancelled => 'ペアリングをキャンセルしました。';

  @override
  String get p2pPairingConfirmationSettingsChangedStartPairingAgain =>
      'ペアリング確認の設定が変わりました。ペアリングをやり直してください。';

  @override
  String p2pCouldNotLoadRevisionMetadata(String p1) {
    return 'リビジョンのメタデータを読み込めません：$p1';
  }

  @override
  String get p2pCouldNotCreateARevisionInvalidProject =>
      'リビジョンを作成できません。プロジェクトの UUID が無効です。';

  @override
  String get p2pNewRevisionSavedNotifyingThePeerThrough =>
      '新しいリビジョンを保存しました。暗号化経路で相手側に同期を通知しています。';

  @override
  String p2pCouldNotCreateRevisionMetadata(String p1) {
    return 'リビジョンのメタデータを作成できません：$p1';
  }

  @override
  String get p2pDraftRevisionCreatedSendingItsSummaryThrough =>
      '下書きのリビジョンを作成しました。暗号化経路で概要を送信しています。';

  @override
  String get p2pDraftRevisionCreatedSendingItsSummaryAnd =>
      '下書きのリビジョンを作成しました。暗号化経路で概要と差分を送信しています。';

  @override
  String p2pCouldNotCreateADraftRevision(String p1) {
    return '下書きのリビジョンを作成できません：$p1';
  }

  @override
  String p2pRejectedAnInvalidRevisionDeltaFallingBack(String p1) {
    return '無効なリビジョン差分を拒否し、完全なスナップショットを使用します：$p1';
  }

  @override
  String p2pCouldNotSaveRemoteHistory(String p1) {
    return '相手側の履歴を保存できません：$p1。';
  }

  @override
  String p2pRemoteSnapshotOpenedButItsRevisionGraph(String p1) {
    return '相手側のスナップショットを開きましたが、リビジョングラフを保存できません：$p1';
  }

  @override
  String get p2pCouldNotStageTheRemoteConflictSnapshot =>
      'セッションまたはグラフが無効になったため、相手側の競合スナップショットを一時保存できません。';

  @override
  String p2pCouldNotStageTheRemoteConflictSnapshot2(String p1) {
    return '相手側の競合スナップショットを一時保存できません：$p1';
  }

  @override
  String get p2pMultipleMaximalCommonAncestorsFoundARecursive =>
      '最大共通祖先が複数あります。マージには再帰的なマージ基準が必要です。';

  @override
  String get p2pCouldNotPrepareFieldMergingTheAuthenticated =>
      '認証済みセッションまたは並行する先頭リビジョンが無効なため、フィールドのマージを準備できません。';

  @override
  String p2pCouldNotPrepareProjectFieldMerging(String p1) {
    return 'プロジェクトのフィールドマージを準備できません：$p1';
  }

  @override
  String get p2pCreatedAResolutionRevisionWithTwoParents =>
      '2 つの親を持つ解決リビジョンを作成しました。暗号化経路での送信を待っています。';

  @override
  String p2pCouldNotCreateAResolutionRevision(String p1) {
    return '解決リビジョンを作成できません：$p1';
  }

  @override
  String get p2pRespondedAutomaticallyToThePeerSSecure =>
      '安全なペアリング要求に自動応答しました。照合コードを作成しています。';

  @override
  String p2pCouldNotAutomaticallyCreateALocalPairing(String p1) {
    return 'ローカルのペアリングチャレンジを自動作成できません：$p1';
  }

  @override
  String get p2pPairingChallengeRefreshedAutomaticallyWaitingForThe =>
      'ペアリングチャレンジを自動更新しました。相手側の新しいコード取得を待っています。';

  @override
  String p2pCouldNotRefreshThePairingChallenge(String p1) {
    return 'ペアリングチャレンジを更新できません：$p1';
  }

  @override
  String get p2pThePeerChangedItsSyncDocumentDisconnected =>
      '相手側の同期文書が変わったため、切断しました。';

  @override
  String get p2pThisDeviceChangedItsSyncDocumentDisconnected =>
      'このデバイスの同期文書が変わったため、切断しました。';

  @override
  String p2pCouldNotInitializeTheDeviceSSecure(String p1) {
    return 'デバイスの安全な識別情報を初期化できません：$p1';
  }

  @override
  String p2pCouldNotObtainALocalLANIP(String p1) {
    return 'ローカルの LAN IP アドレスを取得できません：$p1';
  }

  @override
  String get p2pStartingLocalService => 'ローカルサービスを起動中…';

  @override
  String get p2pLocalEndpointReadySecurePairingEnablesEncrypted =>
      'ローカル端点を起動しました。安全なペアリング後、暗号化リビジョンとスナップショットを交換できます。';

  @override
  String p2pCouldNotOpenPort(String p1, String p2) {
    return 'ポート $p1 を開けません：$p2';
  }

  @override
  String get p2pStoppingLocalService => 'ローカルサービスを停止中…';

  @override
  String get p2pLocalServiceStopped => 'ローカルサービスを停止しました。';

  @override
  String p2pCouldNotStopLocalService(String p1) {
    return 'ローカルサービスを停止できません：$p1';
  }

  @override
  String p2pTesting(String p1, String p2) {
    return '$p1:$p2 をテスト中…';
  }

  @override
  String get p2pEndpointReachableSecurePairingIsRequiredTo =>
      '端点に接続できます。暗号化した内容の転送には安全なペアリングが必要です。';

  @override
  String p2pCouldNotConnectTo(String p1, String p2) {
    return '$p1 に接続できません：$p2';
  }

  @override
  String p2pConnectingAndNegotiatingTheSyncDocumentAt(String p1, String p2) {
    return '$p1:$p2 に接続し、同期文書を確認中…';
  }

  @override
  String get p2pThisDeviceWillProvideTheSyncDocument => 'このデバイスの文書を同期元に選択しました。';

  @override
  String get p2pThePeerWillProvideTheSyncDocument => '相手側の文書を同期元に選択しました。';

  @override
  String get p2pPeerDisconnectedTheLocalServiceIsStill =>
      '相手側との接続を切断しました。ローカルサービスは待ち受けを続けています。';

  @override
  String get p2pPeerDisconnected => '相手側との接続を切断しました。';

  @override
  String get p2pNoRemoteSnapshotIsAvailableForDownload =>
      '検証済み接続でダウンロードできる相手側のスナップショットがありません。';

  @override
  String get p2pReconstructingOrDownloadingAndVerifyingTheSnapshot =>
      '認証済みの暗号化通信で、スナップショットの再構築またはダウンロードと検証を実行中…';

  @override
  String get p2pSnapshotChunksSHAXMLUUIDAndVersion =>
      'スナップショットのチャンク、SHA-256、XML、UUID、バージョンを検証しました。プロジェクトにはまだ書き込んでいません。';

  @override
  String get p2pSnapshotReconstructedFromAnEncryptedDeltaSHA =>
      '暗号化差分からスナップショットを再構築し、SHA-256、XML、UUID、バージョンを検証しました。まだプロジェクトには書き込んでいません。';

  @override
  String get p2pSnapshotDownloadCancelled => 'スナップショットのダウンロードをキャンセルしました。';

  @override
  String p2pSnapshotDownloadOrVerificationFailed(String p1) {
    return 'スナップショットのダウンロードまたは検証に失敗しました：$p1';
  }

  @override
  String get p2pRevisionsDivergedResolveConflictsFieldByField =>
      'リビジョンが分岐しています。ローカル文書を置き換える前に、フィールドごとの競合を解決してください。';

  @override
  String get p2pTheVerifiedSnapshotIsNoLongerValid =>
      '検証済みスナップショットが無効になりました。安全に再接続して、再度ダウンロードしてください。';

  @override
  String get p2pNoVerifiedRevisionGraphContainingThisSnapshot =>
      'このスナップショットを含む検証済みリビジョングラフがありません。プロジェクトは変更していません。';

  @override
  String get p2pAuthenticatedSnapshotSessionCapabilityIsMissingThe =>
      '認証済みスナップショットのセッション権限がありません。プロジェクトは変更していません。';

  @override
  String get p2pWaitingToConfirmTheSaveLocationAnd =>
      '保存先の確認とスナップショットの安全な読み込みを待っています…';

  @override
  String get p2pTheSyncSessionChangedSnapshotApplicationTo =>
      '同期セッションが変わったため、エディターへのスナップショットの適用を停止しました。';

  @override
  String get p2pSnapshotSavedAndOpenedButRemoteRevision =>
      'スナップショットを保存して開きましたが、相手側の履歴を保存できませんでした。編集を止め、同期を再試行してください。';

  @override
  String get p2pRemoteSnapshotSavedAndOpened => '相手側のスナップショットを保存して開きました。';

  @override
  String get p2pApplicationCancelledVerificationResultsRemainInMemory =>
      '適用をキャンセルしました。検証結果はメモリ上に保持されています。';

  @override
  String p2pCouldNotSaveOrOpenTheSnapshot(String p1) {
    return 'スナップショットを保存または開くことができません：$p1';
  }

  @override
  String get p2pConcurrentSnapshotsMergedFieldByFieldAnd =>
      '分岐したスナップショットをフィールドごとにマージし、解決リビジョンを作成しました。';

  @override
  String get p2pSnapshotTransferCancelled => 'スナップショットの転送をキャンセルしました。';

  @override
  String get p2pConnectionDocumentOrRevisionChangedThePrevious =>
      '接続、文書、リビジョンのいずれかが変わり、以前のスナップショットが無効になりました。';

  @override
  String get p2pBothUUIDsMatchTheSameSyncDocument =>
      '双方の UUID が一致し、同じ同期文書を選択しました。';

  @override
  String get p2pThePeerHasNoTargetDocumentThis =>
      '相手側に対象文書がないため、このデバイスから提供します。';

  @override
  String get p2pThisDeviceHasNoTargetDocumentThe =>
      'このデバイスに対象文書がないため、相手側から取得します。';

  @override
  String get p2pNeitherDeviceHasASyncDocumentChoose =>
      'どちらにも同期できる文書がありません。先に文書を選択してください。';

  @override
  String get p2pTheDocumentUUIDsDifferChooseWhichDocument =>
      '双方の文書の UUID が異なります。同期する文書を選択してください。';

  @override
  String paletteGraySemantics(String value) {
    return 'グレースケール、明度 $value%';
  }

  @override
  String paletteColorSemantics(String hue, String saturation, String value) {
    return '色相 $hue 度、彩度 $saturation%、明度 $value%';
  }

  @override
  String revisionCheckpointLabel(String timestamp) {
    return 'チェックポイント $timestamp';
  }

  @override
  String get projectErrorAccessDenied =>
      'ファイルへのアクセスが拒否されました。元のファイルを選び直してアクセスを許可するか、「名前を付けて保存」で変更を保存してください。';

  @override
  String get projectErrorFileMissing => 'ファイルが見つかりません。移動または削除されていないか確認してください。';

  @override
  String get projectErrorInvalidPath => 'ファイルのパスが無効です。ファイルまたは保存先を選び直してください。';

  @override
  String get projectErrorInvalidData =>
      'プロジェクトのデータ形式が無効です。ファイルを確認するか、バックアップから復元してください。';

  @override
  String get projectErrorCancelled => 'ファイル操作をキャンセルしました。変更は保存されていません。';

  @override
  String get projectErrorNoSaveLocation =>
      'プロジェクトの保存先が未指定です。先に保存するか、「名前を付けて保存」を使用してください。';

  @override
  String get projectErrorNoSpace => '空き容量が不足しています。容量を確保するか、別の保存先を選択してください。';

  @override
  String get projectErrorBackupLimit =>
      'プロジェクトがバックアップの容量上限を超えています。設定で上限を増やしてください。';

  @override
  String get projectErrorUnsupported => 'このプラットフォームでは、このファイル操作に対応していません。';

  @override
  String get projectErrorDuplicateIdentity =>
      'データに空または重複した ID があります。プロジェクトを開き直して章節ツリーを修復してください。';

  @override
  String get projectErrorTreeTooDeep =>
      'ツリーが 256 階層を超えています。階層を浅くしてから再試行してください。';

  @override
  String get projectErrorExportFormat =>
      'エクスポートの用途・形式・範囲が一致していないか、その形式にはまだ対応していません。';

  @override
  String get projectErrorExportSelection =>
      'エクスポートの選択範囲が無効です。項目を 1 つ以上選び直してください。';

  @override
  String get projectErrorExportEmpty => '選択範囲にエクスポートできる内容がありません。選び直してください。';

  @override
  String get projectErrorMissingItemDefinition =>
      '物品の定義が見つかりません。物品データを修復してからエクスポートしてください。';

  @override
  String get projectErrorProjectChanged =>
      '元のプロジェクトが切り替わりました。エクスポート画面を開き直してください。';

  @override
  String get projectErrorUnknown =>
      '操作を完了できませんでした。変更はエディターに残っています。再試行するか、「名前を付けて保存」を使用してください。';

  @override
  String get copilotErrorInvalidConfiguration =>
      'モデルサービスがリクエストの形式またはパラメーターを拒否しました。設定を確認してください。';

  @override
  String get copilotErrorAuthenticationFailed =>
      'API キーが無効または期限切れです。認証情報を確認してください。';

  @override
  String get copilotErrorPermissionDenied =>
      'モデルサービスが、この認証情報またはモデルへのアクセスを拒否しました。';

  @override
  String get copilotErrorRateLimited =>
      'モデルサービスのリクエスト数または利用上限に達しました。時間をおいて再試行してください。';

  @override
  String get copilotErrorModelUnavailable =>
      '指定のモデルまたは API エンドポイントが見つかりません。モデルを選び直してください。';

  @override
  String get copilotErrorContextTooLarge =>
      '送信内容がサイズの上限を超えています。メッセージまたはコンテキストを短くしてください。';

  @override
  String get copilotErrorResponseTooLarge => 'モデルの応答が許容サイズを超えています。';

  @override
  String get copilotErrorRequestTimedOut =>
      'Copilot のリクエストがタイムアウトしました。時間をおいて再試行してください。';

  @override
  String get copilotErrorInvalidResponse =>
      'モデルの応答を解析できませんでした。再試行するか、別のモデルを選択してください。';

  @override
  String get copilotErrorNetworkUnavailable =>
      'Copilot のリクエストに失敗しました。ネットワーク、API URL、モデル、認証情報を確認してください。';

  @override
  String get copilotErrorServiceUnavailable =>
      'モデルサービスを一時的に利用できません。時間をおいて再試行してください。';

  @override
  String get copilotErrorValidation =>
      '現在の章節、選択した資料、API URL の設定を確認してから再試行してください。';
}
