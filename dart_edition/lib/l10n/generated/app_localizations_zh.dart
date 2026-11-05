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
  String get languageHelp => '切換後立即套用並自動保存；專案內容不受介面語言影響。';

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

  @override
  String get uiSaveFile => '儲存檔案';

  @override
  String get uiNewFile => '新建檔案';

  @override
  String get uiOpenFile => '開啟檔案';

  @override
  String get uiSaveAs => '另存新檔';

  @override
  String get uiImport => '匯入';

  @override
  String get uiExport => '匯出';

  @override
  String get editorSelectAll => '全選';

  @override
  String get editorCut => '剪下';

  @override
  String get commonCopy => '複製';

  @override
  String get editorPaste => '貼上';

  @override
  String get editorUndo => '復原';

  @override
  String get editorRedo => '重做';

  @override
  String get uiPhraseLibrary => '短語庫';

  @override
  String get uiInsertPhrase => '插入短語';

  @override
  String get uiOpenTheManuscriptEditorFirst => '請先開啟正文編輯頁。';

  @override
  String get uiSaveSelectionAsPhrase => '選取內容存為短語';

  @override
  String get uiPunctuation => '標點符號';

  @override
  String get uiSearch => '搜尋';

  @override
  String get uiNavigation => '導覽列';

  @override
  String get uiSidebar => '側邊欄';

  @override
  String get uiDashboard => '儀表板';

  @override
  String get uiMatchCase => '大小寫需相同';

  @override
  String get uiWholeWords => '全字拼寫相符';

  @override
  String get uiRegularExpression => '使用正則表示';

  @override
  String get uiMatchCharacterWidth => '全半形須相符';

  @override
  String get uiIgnorePunctuation => '略過標點符號';

  @override
  String get uiIgnoreWhitespace => '略過空白字元';

  @override
  String get uiRegularExpressionsAlwaysMatchCaseAndCharacterWidth =>
      '正則表示模式固定大小寫與全半形相符，並停用全字拼寫。';

  @override
  String get uiWholeWordMatchingIsUnavailableWhenTheQuery =>
      '搜尋文字含全形字元、標點或空白，無法使用全字拼寫。';

  @override
  String uiCouldNotCompletePleaseTryAgain(String p1) {
    return '無法完成「$p1」，請重試。';
  }

  @override
  String get uiFile => '檔案';

  @override
  String get uiProject => '專案';

  @override
  String get uiDataExchange => '資料交換';

  @override
  String get uiHome => '常用';

  @override
  String get uiClipboard => '剪貼簿';

  @override
  String get uiHistory => '歷史';

  @override
  String get uiWritingTools => '寫作工具';

  @override
  String get uiPhrases => '短語';

  @override
  String get uiWorkspacePanels => '顯示區塊';

  @override
  String get uiFindAndReplace => '尋找與取代';

  @override
  String get uiMatchOptions => '符合條件';

  @override
  String get uiSearchMethod => '搜尋方式';

  @override
  String get uiOn => '開';

  @override
  String get uiOff => '關';

  @override
  String get uiToolbarMode => '工具列模式';

  @override
  String get uiAutomaticFullOnDesktopModerateOnMobile =>
      '自動（桌面 Full／手機 Moderate）';

  @override
  String get uiHelp => '說明';

  @override
  String get uiHelpHome => '說明首頁';

  @override
  String get uiHelpForThisFeatureF1 => '目前功能說明（F1）';

  @override
  String get uiWhatSThisShiftF1 => '這是什麼？（Shift+F1）';

  @override
  String get uiEnterAlternativeDisplayTextNotAddedAsAn => '輸入其他顯示文字（不加入別名）';

  @override
  String get uiInsert => '插入';

  @override
  String get uiDisplayText => '顯示文字';

  @override
  String get uiAddAlias => '新增別名';

  @override
  String get uiCharacter => '人物';

  @override
  String get uiLocation => '地點';

  @override
  String get uiEvent => '事件';

  @override
  String get uiForeshadowing => '伏筆';

  @override
  String get uiPlan => '計畫';

  @override
  String get uiItem => '物品';

  @override
  String get uiKeyPoint => '重點';

  @override
  String uiAdd(String p1) {
    return '新增$p1';
  }

  @override
  String get commonCancel => '取消';

  @override
  String get uiTheManuscriptHasChangedSelectThePhraseAgain => '正文已變更，請重新選取短語';

  @override
  String uiCouldNotInsertThePhrase(String p1) {
    return '無法插入短語：$p1';
  }

  @override
  String uiRelink(String p1) {
    return '重新連結「$p1」';
  }

  @override
  String get uiSearchTargets => '搜尋對象';

  @override
  String get uiCancelInsertion => '取消插入';

  @override
  String get uiConvertToPlainText => '改為純文字';

  @override
  String get uiSelectManuscriptTextToSaveAsAPhrase => '請先選取要存為短語的正文內容';

  @override
  String get uiNoPhrasesAreAvailableAddAPhraseIn => '尚無可插入的短語，請先在短語庫新增短語';

  @override
  String get uiMissingTarget => '遺失對象';

  @override
  String uiOriginalNameNotes(String p1, String p2) {
    return '原名：$p1\n備註：$p2';
  }

  @override
  String get uiNone => '無';

  @override
  String get uiAddMention => '新增 Mention';

  @override
  String get uiSaveAsPhrase => '存成短語';

  @override
  String get uiDonTAskAgain => '以後不再提示';

  @override
  String get uiDonTSave => '不儲存';

  @override
  String get commonSave => '儲存';

  @override
  String get uiUnsavedChanges => '未儲存的變更';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeExiting => '您有未儲存的變更，是否要在退出前儲存？';

  @override
  String get uiVersionCompatibilityWarning => '版本相容性警告';

  @override
  String uiThisFileSVersionIsNewerThanThe(String p1, String p2) {
    return '此檔案版本（$p1）高於目前支援版本（$p2）。\n若繼續開啟並儲存，可能遺失部分數據。\n\n是否仍要繼續開啟？';
  }

  @override
  String get uiOpenAnyway => '繼續開啟';

  @override
  String get uiCreateProject => '建立新專案';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeCreatingA =>
      '您有未儲存的變更，是否要在建立新專案前儲存？';

  @override
  String get uiProjectCreated => '新專案建立成功！';

  @override
  String uiCouldNotCreateTheProject(String p1) {
    return '建立新專案失敗：$p1';
  }

  @override
  String get uiOpenProject => '開啟專案';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeOpeningAnother =>
      '您有未儲存的變更，是否要在開啟新專案前儲存？';

  @override
  String get uiOpeningTheNewerFileWasCancelled => '已取消開啟較新版本檔案。';

  @override
  String uiProjectOpened(String p1) {
    return '專案開啟成功：$p1';
  }

  @override
  String uiCouldNotOpenTheProject(String p1) {
    return '開啟專案失敗：$p1';
  }

  @override
  String get uiOpenRecentProject => '開啟最近專案';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeOpeningA =>
      '您有未儲存的變更，是否要在開啟最近專案前儲存？';

  @override
  String uiCouldNotOpenTheRecentProject(String p1) {
    return '開啟最近專案失敗：$p1';
  }

  @override
  String get uiProjectSaved => '專案儲存成功！';

  @override
  String uiCouldNotSaveTheProject(String p1) {
    return '儲存專案失敗：$p1';
  }

  @override
  String uiProjectSavedAs(String p1) {
    return '專案另存成功：$p1';
  }

  @override
  String uiCouldNotSaveTheProjectAsANew(String p1) {
    return '另存專案失敗：$p1';
  }

  @override
  String uiInvalidRegularExpression(String p1) {
    return '正則表達式錯誤: $p1';
  }

  @override
  String uiReplaceAllFailed(String p1) {
    return '全部取代失敗：$p1';
  }

  @override
  String get uiInvalidFormat => '格式無效';

  @override
  String uiInvalidRegularExpression2(String p1) {
    return '正則表達式錯誤：$p1';
  }

  @override
  String uiReplaceAllCancelledMoreThanMatchesNarrowYour(String p1) {
    return '全部取代已取消：匹配數超過 $p1 筆，請縮小搜尋範圍。';
  }

  @override
  String get uiReplaceAllCancelledTheResultingTextIsToo =>
      '全部取代已取消：結果超過允許的文字大小，請分段處理。';

  @override
  String get uiReplaceAllCancelledTheTimeLimitWasExceeded =>
      '全部取代已取消：運算時間超過限制，請縮小搜尋範圍。';

  @override
  String get uiConfirmLargeReplacement => '確認大量取代';

  @override
  String uiMatchesToReplaceEstimatedResultMiBContinue(String p1, String p2) {
    return '將取代 $p1 處，結果約 $p2 MiB。確定繼續嗎？';
  }

  @override
  String get uiContinueReplacing => '繼續取代';

  @override
  String get uiReplaceAllCancelledAnnotationRangesCouldNotBe =>
      '全部取代已取消：無法安全映射標記範圍。';

  @override
  String get uiReplaceAllCancelledRegularExpressionAnnotationRangesCould =>
      '全部取代已取消：無法安全映射正則標記範圍。';

  @override
  String get uiReplaceAllCancelledAnnotationProjectionValidationFailed =>
      '全部取代已取消：標記投影驗證失敗。';

  @override
  String get uiSearch2 => '搜尋……';

  @override
  String get uiPrevious => '上一個';

  @override
  String get uiNext => '下一個';

  @override
  String get uiCollapse => '收合';

  @override
  String get uiExpandReplace => '展開取代';

  @override
  String get uiSearchOptions => '搜尋選項';

  @override
  String get uiReplaceWith => '取代為……';

  @override
  String get uiReplace => '取代';

  @override
  String get uiAll => '全部';

  @override
  String get uiFind => '尋找內容:';

  @override
  String get uiCollapse2 => '摺疊';

  @override
  String get uiReplaceWith2 => '取代為:';

  @override
  String get uiReplaceAll => '全部取代';

  @override
  String get uiFullWidth => '全形';

  @override
  String get uiHalfWidth => '半形';

  @override
  String get uiFeatures => '功能';

  @override
  String get uiEditor => '編輯器';

  @override
  String get uiFull => '全';

  @override
  String get uiHalf => '半';

  @override
  String get uiExpandNavigation => '展開導覽';

  @override
  String get uiCloseNavigation => '關閉導覽';

  @override
  String get uiHelpModule => '說明模組';

  @override
  String get uiCollapseNavigation => '收合導覽';

  @override
  String get uiPinNavigation => '固定導覽';

  @override
  String get uiOvertypeModeIns => 'Overtype Mode (Ins)';

  @override
  String get uiInsertModeIns => 'Default Mode (Ins)';

  @override
  String uiCharacters(String p1, String p2) {
    return '$p1 / $p2 字';
  }

  @override
  String get uiIndentLineStart => '行首留空';

  @override
  String get uiInsertSpacesWithTab => 'Tab 插入空格';

  @override
  String uiEnterFirst(String p1) {
    return '請先輸入$p1';
  }

  @override
  String get uiCannotAddRightNow => '目前不可新增';

  @override
  String get uiConvertToItemLink => '轉為正式物品關聯';

  @override
  String get uiQuillPlainTextManuscriptPreview => 'Quill 純文字正文 PoC';

  @override
  String uiAnnotation(String p1, String p2) {
    return '$p1標記：$p2';
  }

  @override
  String uiSCursor(String p1) {
    return '$p1 的游標';
  }

  @override
  String get uiSelectAControlToViewHelpEscCancels => '點選項目查看說明，Esc 取消';

  @override
  String get uiHelpCenter => '說明中心';

  @override
  String get uiCloseHelpEsc => '關閉說明（Esc）';

  @override
  String get uiPreviousPage => '上一頁';

  @override
  String get uiNextPage => '下一頁';

  @override
  String get uiReadArticle => '閱讀文章';

  @override
  String get uiContentsAndSearch => '目錄與搜尋';

  @override
  String get uiSearchHelp => '搜尋說明';

  @override
  String get uiCouldNotLoadOfflineHelpPleaseTryAgain => '無法載入內建說明，請重試。';

  @override
  String get commonRetry => '重試';

  @override
  String get uiNoMatchingHelpTopics => '找不到符合的說明';

  @override
  String get uiBackToContents => '返回目錄';

  @override
  String get uiRelatedTopics => '相關說明';

  @override
  String get uiInvalidAnnotationSyntaxCorrectItBeforeApplying =>
      '完整語法無效，請修正後再套用。';

  @override
  String get commonClose => '關閉';

  @override
  String get uiNotes => '備註';

  @override
  String get uiType => '類型';

  @override
  String get uiTarget => '對象';

  @override
  String get uiStatus => '狀態';

  @override
  String get uiColor => '色彩';

  @override
  String get uiOpenNode => '開啟節點';

  @override
  String get uiEditAnnotation => '編輯標記';

  @override
  String get uiApply => '套用';

  @override
  String get uiMoreAnnotationActions => '更多標記操作';

  @override
  String get uiUpdateToCurrentName => '更新為目前名稱';

  @override
  String get uiRelinkMissingTarget => '重新連結遺失對象';

  @override
  String get uiRemoveAnnotationKeepText => '移除標記但保留文字';

  @override
  String get uiHighlight => '高亮';

  @override
  String get uiFullSyntax => '完整語法';

  @override
  String get uiCopySyntax => '複製語法';

  @override
  String get uiGeneral => '一般';

  @override
  String get uiStart => '開始';

  @override
  String get uiEnd => '結束';

  @override
  String get uiThisAnnotationTypeRequiresAUUID => '此標記類型需要 UUID。';

  @override
  String uiInvalidAnnotationData(String p1) {
    return '標記資料無效：$p1';
  }

  @override
  String get uiBackgroundColorCode => '背景色碼';

  @override
  String get uiTextColorCode => '文字色碼';

  @override
  String get uiNotesOptional => '備註（可留空）';

  @override
  String get uiEditingThisFieldAppliesTheFullSyntaxIn => '直接修改此欄會優先套用完整語法。';

  @override
  String get uiAutomatic => '0（自動）';

  @override
  String get uiSearchNamePathOrUUID => '搜尋名稱、路徑或 UUID';

  @override
  String get uiNoMatchingLinkTargets => '沒有相符的可連結對象';

  @override
  String get uiUntitled => '（未命名）';

  @override
  String uiShowingTheFirstResultsEnterKeywordsToNarrow(String p1) {
    return '目前顯示前 $p1 筆，請輸入關鍵字縮小範圍。';
  }

  @override
  String get uiCouldNotReadInitialSetupPleaseTryAgain => '無法讀取初次設定，請重試。';

  @override
  String get uiCouldNotReadTheBackupLocationSelectTo => '無法讀取備份位置，按此重試';

  @override
  String get uiChooseAutomaticBackupFolder => '選擇自動備份資料夾';

  @override
  String get uiCouldNotSelectAFolderPleaseTryAgain => '無法選擇資料夾，請再試一次。';

  @override
  String get uiChooseHowYouPreferToReadAndWork =>
      '選擇適合您的閱讀與操作方式。這些選項稍後都能在「設定」中調整。';

  @override
  String get uiInterfaceTheme => '介面主題';

  @override
  String uiUseTheTheme(String p1) {
    return '使用$p1主題';
  }

  @override
  String get uiSideNavigation => '側邊導覽';

  @override
  String get uiYourWorkIsSavedAsAMnprojProject =>
      '作品會以 .mnproj 專案檔保存在您選擇的位置。依照寫作習慣，決定是否啟用以下功能。';

  @override
  String get uiAutoSave => '自動儲存';

  @override
  String uiSaveToTheCurrentProjectFileEveryMinutes(String p1) {
    return '每 $p1 分鐘寫回目前的專案檔。請先手動儲存一次，選定檔案位置。';
  }

  @override
  String get uiSaveInterval => '儲存間隔';

  @override
  String uiMinutes(String p1) {
    return '$p1 分鐘';
  }

  @override
  String get uiAutomaticBackup => '自動備份';

  @override
  String uiCreateASeparateBackupEveryMinutesWithoutChanging(String p1) {
    return '每 $p1 分鐘另存備份，保留目前專案的位置；可在設定中管理備份。';
  }

  @override
  String get uiBackupInterval => '備份間隔';

  @override
  String get uiManageTheAutomaticBackupFolderInSettingsOn =>
      '此平台的自動備份資料夾可於設定中管理。';

  @override
  String get uiThisAppWorksOfflineRememberToSaveNew =>
      '本程式可離線使用。請記得用「儲存」保存新專案。';

  @override
  String get uiYourNameAppearsInTheWelcomeMessageOn =>
      '開啟歡迎頁面時，您的名稱會出現在「歡迎訊息」欄位。請輸入您希望出現的名稱。您也可以略過這個步驟。';

  @override
  String get uiNameOptional => '名稱（選填）';

  @override
  String get uiEnterYourNameOrPenName => '輸入您的名稱或筆名';

  @override
  String get uiExampleAzusaNakano => '範例：中野梓';

  @override
  String get uiUseAsDefaultPenName => '作為預設筆名';

  @override
  String get uiFillInTheAuthorAutomaticallyWhenCreatingA => '新建專案時，自動填入作者欄位。';

  @override
  String get uiFromTheWorkspaceHomePageCreateAProject =>
      '進入工作區後，您可以從歡迎頁新建專案，或開啟已有的 .mnproj 檔案。';

  @override
  String get uiCreateYourWork => '01  建立您的作品';

  @override
  String get uiCreateAProjectAndEnterItsTitleAnd => '新建專案，填寫作品名稱與故事基本資料。';

  @override
  String get uiWriteYourFirstChapter => '02  寫下第一個章節';

  @override
  String get uiAddFoldersAndChaptersInChaptersThenSelect =>
      '在「章節」新增資料夾與章節，選取章節後開始撰寫正文。';

  @override
  String get uiBuildYourStoryWorld => '03  構建您的設定';

  @override
  String get uiOrganizeYourStoryWithOutlinesCharactersWorldbuildingAnd =>
      '用大綱、角色、世界觀與時間軸，整理您的故事。需要協助時可從「說明」選單開啟指南。';

  @override
  String get uiYouReReadyToBeginHereIsA => '恭喜！您現在可以開始使用本程式。以下是您的完成報告：';

  @override
  String uiName(String p1) {
    return '名稱：$p1';
  }

  @override
  String get uiNotSet => '未設定';

  @override
  String uiDefaultPenName(String p1) {
    return '作為預設筆名：$p1';
  }

  @override
  String get uiYes => '是';

  @override
  String get uiNo => '否';

  @override
  String uiTheme(String p1) {
    return '主題：$p1';
  }

  @override
  String uiThemeColor(String p1) {
    return '主題顏色：$p1';
  }

  @override
  String uiTextSize(String p1) {
    return '文字大小：$p1';
  }

  @override
  String uiNavigation2(String p1) {
    return '導覽：$p1';
  }

  @override
  String uiRibbonMode(String p1) {
    return 'Ribbon 模式：$p1';
  }

  @override
  String uiAutomatic2(String p1) {
    return '自動（$p1）';
  }

  @override
  String uiAutoSave2(String p1) {
    return '自動儲存：$p1';
  }

  @override
  String uiEveryMinutes(String p1) {
    return '每 $p1 分鐘';
  }

  @override
  String uiAutomaticBackup2(String p1) {
    return '自動備份：$p1';
  }

  @override
  String uiAutomaticBackupFolder(String p1) {
    return '自動備份資料夾：$p1';
  }

  @override
  String get uiUseDefaultBackupFolder => '使用預設備份資料夾';

  @override
  String get uiChangeAppearanceAndStorageOptionsInSettingsReopen =>
      '介面與儲存偏好可在「設定」中修改，名稱可重新開啟初次設定調整。';

  @override
  String get uiRibbonMode2 => 'Ribbon 模式';

  @override
  String get uiAutomatic3 => '自動';

  @override
  String get uiChooseByDeviceFullOnDesktopModerateOn =>
      '依裝置選擇：桌面 Full，手機 Moderate。';

  @override
  String uiAutomaticallyUsing(String p1, String p2) {
    return '自動使用 $p1：$p2';
  }

  @override
  String get uiThemeColor2 => '主題顏色';

  @override
  String uiTextSizeSp(String p1) {
    return '文字大小  ${p1}sp';
  }

  @override
  String get uiAutomaticBackupFolder2 => '自動備份資料夾';

  @override
  String get uiChooseFolder => '選擇資料夾';

  @override
  String get uiResetToDefault => '還原預設';

  @override
  String get uiMonogatariAssistant => '物語 Assistant';

  @override
  String get uiDeletePhrase => '刪除短語？';

  @override
  String uiRemoveShortcutFromThePhraseLibrary(String p1) {
    return '短碼「$p1」會從短語庫移除。';
  }

  @override
  String get commonDelete => '刪除';

  @override
  String get uiPhraseLibraryExported => '短語庫已匯出';

  @override
  String uiShortcutConflicts(String p1) {
    return '短碼「$p1」發生衝突';
  }

  @override
  String uiTheImportedPhraseHasTheSameIDOr(String p1, String p2) {
    return '匯入項目與現有短語的 ID 或短碼相同：\n$p1\n\n可以保留現有項目、覆蓋，或以「$p2」另存一份。';
  }

  @override
  String get uiAllProjects => '所有專案';

  @override
  String get uiCurrentProject => '目前專案';

  @override
  String get uiCancelImport => '取消匯入';

  @override
  String get uiKeepExisting => '保留現有';

  @override
  String get uiSaveACopy => '另存一份';

  @override
  String get uiOverwrite => '覆蓋';

  @override
  String uiImportedExistingPhrasesKept(String p1, String p2, String p3) {
    return '已匯入 $p1 筆，保留 $p2 筆現有短語。$p3';
  }

  @override
  String get uiPhrasesWithMentionsAreLimitedToThisProject =>
      '含 Mention 的短語已限於目前專案，插入前須重新連結。';

  @override
  String get uiAddPhrase => '新增短語';

  @override
  String uiCouldNotLoadTheGlobalPhraseLibrary(String p1) {
    return '全域短語庫讀取失敗：$p1';
  }

  @override
  String get uiSearchContentShortcutsOrTags => '搜尋內容、短碼或標籤';

  @override
  String get uiDisabled => '已停用';

  @override
  String get uiDuplicatePhrase => '複製短語';

  @override
  String get uiDisable => '停用';

  @override
  String get uiEnable => '啟用';

  @override
  String get uiEditPhrase => '編輯短語';

  @override
  String get uiShortcutLettersDigitsOr => '短碼（1–32 位英數、_、-）';

  @override
  String get uiAvailableInAllProjects => '所有專案可用';

  @override
  String get uiContainsMentionsCurrentProjectOnly => '含 Mention，只能用於目前專案';

  @override
  String get uiTags => '標籤';

  @override
  String get uiAddTag => '新增標籤';

  @override
  String get uiContent => '內容';

  @override
  String get uiMentionsAreProjectSpecificTextAnnotationsCanBe =>
      '提及限目前專案；文字標記可供所有專案使用';

  @override
  String get uiAnnotation2 => '標記';

  @override
  String get uiIncompleteMosaicSyntax => 'Mosaic 語法不完整';

  @override
  String get uiBack => '返回';

  @override
  String get uiNoMatchingSuggestions => '找不到符合的候選項目';

  @override
  String uiBackTo(String p1) {
    return '返回 $p1';
  }

  @override
  String get uiEnterSelectsRightArrowOpensTheNextLevel =>
      '按 Enter 選取，按向右鍵展開下一層';

  @override
  String get uiEnterOrTabSelects => '按 Enter 或 Tab 選取';

  @override
  String uiExpandTheNextLevelOf(String p1) {
    return '展開 $p1 的下一層';
  }

  @override
  String uiChanges(String p1, String p2) {
    return '$p1 修訂：$p2';
  }

  @override
  String uiItemChanges(String p1) {
    return '項目修訂：$p1';
  }

  @override
  String get uiTrackChanges => '修訂追蹤';

  @override
  String get uiCollapseChangesPane => '收合修訂窗格';

  @override
  String get uiCouldNotReadChangeTrackingData => '追蹤資料無法讀取';

  @override
  String get uiCreateABaselineFromTheCurrentContentTo => '從目前內容建立比較基準，開始查看修訂。';

  @override
  String get uiStartTracking => '開始追蹤';

  @override
  String uiBaseline(String p1) {
    return '基準：$p1';
  }

  @override
  String uiComparingToCurrentContent(String p1, String p2) {
    return '$p1：$p2 · 目標：目前內容';
  }

  @override
  String get uiReadOnlyVersion => '唯讀版本';

  @override
  String get commonCreate => '建立';

  @override
  String get uiSaveCurrentContentAsCheckpointAndApply => '儲存目前內容為檢查點並套用';

  @override
  String get uiShowAcceptedChanges => '顯示已接受';

  @override
  String get uiStopTracking => '結束追蹤';

  @override
  String get uiManuscript => '正文';

  @override
  String get uiSettings => '設定';

  @override
  String get uiScope => '範圍：';

  @override
  String get uiCurrentChapterPage => '目前章節／頁面';

  @override
  String get uiEntireProject => '全專案';

  @override
  String uiManuscriptLinesSettingsM(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  ) {
    return '正文 +$p1 / -$p2 行 · 設定 +$p3 / -$p4 / M$p5';
  }

  @override
  String uiAcceptChangesInScope(String p1) {
    return '接受此範圍 $p1 筆';
  }

  @override
  String get uiRejectManuscriptChangesInScope => '拒絕此範圍正文';

  @override
  String get uiLargeDifferencesAreSimplifiedLineCountsMayNot =>
      '大型差異已簡化，行數可能非最小值';

  @override
  String get uiSomeDataTypesAreNotYetIncludedIn => '部分資料類型尚未納入比較';

  @override
  String get uiPreviousChange => '上一筆';

  @override
  String get uiNextChange => '下一筆';

  @override
  String uiCouldNotCalculateChanges(String p1) {
    return '計算修訂失敗：$p1';
  }

  @override
  String get uiUnknownError => '未知錯誤';

  @override
  String get uiComparisonSourceIsNotAvailableYet => '比較來源尚未取得';

  @override
  String get uiNoChangesInThisScope => '此範圍沒有修訂';

  @override
  String uiManuscriptBeforeAfter(String p1, String p2, String p3) {
    return '正文／$p1 · 舊 $p2 → 新 $p3';
  }

  @override
  String uiAdditionalLines(String p1) {
    return '另有 $p1 行…';
  }

  @override
  String uiTrailingNewline(String p1, String p2) {
    return '行尾換行：$p1 → $p2';
  }

  @override
  String get uiPresent => '有';

  @override
  String get uiLargeDifferencesOverview => '大型差異概略呈現';

  @override
  String get uiFullAnnotation => '完整標記';

  @override
  String get uiUndoAcceptance => '取消接受';

  @override
  String get uiAccept => '接受';

  @override
  String get uiReject => '拒絕';

  @override
  String uiFullAnnotation2(String p1) {
    return '$p1 · 完整標記';
  }

  @override
  String get uiProjectInformation => '專案資訊';

  @override
  String get uiAddedItem => '新增項目';

  @override
  String get uiDeletedItem => '刪除項目';

  @override
  String uiSwitchModuleCurrent(String p1) {
    return '切換模組，目前為$p1';
  }

  @override
  String get uiNoTargetsAvailable => '無可用對象';

  @override
  String get uiCreateATargetOfTheSameTypeBefore => '請先建立相同類型的對象，再重新連結此標記。';

  @override
  String get uiFullAnnotationSyntaxCopied => '已複製完整標記語法。';

  @override
  String get uiOpenDashboard => '開啟儀表板';

  @override
  String get uiTheManuscriptChangedWaitForChangesToBe =>
      '正文已變更，請等待修訂重新計算後再批次拒絕。';

  @override
  String get uiTheBatchRejectionSourceHasChangedRecalculateThe =>
      '批次拒絕的來源已變更；請重新計算差異。';

  @override
  String get uiTheManuscriptChangedWaitForChangesToBe2 =>
      '正文已變更，請等待修訂重新計算後再拒絕。';

  @override
  String get uiThisBlockSPositionIsNoLongerValid => '此區塊位置已失效，請重新計算差異。';

  @override
  String get uiTheFieldChangedWaitForChangesToBe => '欄位已變更，請等待修訂重新計算。';

  @override
  String get uiThisChapterWasDeletedViewItsPreviousContent =>
      '章節已刪除；可在修訂窗格查看舊內容。';

  @override
  String get uiCouldNotPrepareTheThreeWayMerge => '無法準備三方合併。';

  @override
  String get uiRevisionHeadsChangedDuringMergingOutdatedConflictChoices =>
      '合併期間 revision heads 已變更；未套用過期的衝突選擇。';

  @override
  String uiCouldNotApplyConflictChoices(String p1) {
    return '無法套用衝突選擇：$p1';
  }

  @override
  String get uiTheMergedFileWasSavedButCreatingThe =>
      '合併文件已寫入，但 resolve revision 建立失敗；請立即重試同步以復原 metadata。';

  @override
  String get uiFieldConflictsResolvedAndARevisionWithTwo =>
      '欄位衝突已解決並建立雙 parent revision；正在等待對方 ACK。';

  @override
  String uiCouldNotSaveTheResolutionRevision(String p1) {
    return '無法保存 resolve revision：$p1';
  }

  @override
  String get uiTheRemoteRevisionIsNoLongerValidDownload =>
      '遠端版本已失效，請重新下載完整 snapshot。';

  @override
  String get uiTheRemoteProjectFormatIsNewerAndCannot => '遠端專案格式較新，無法安全比較。';

  @override
  String get uiTheRemoteRevisionBelongsToAnotherProjectAnd =>
      '遠端版本屬於另一個專案，未加入比較。';

  @override
  String get uiTheCompleteRemoteRevisionIsAvailableForRead => '已載入完整遠端版本供唯讀比較。';

  @override
  String uiCouldNotCompareTheRemoteRevision(String p1) {
    return '無法比較遠端版本：$p1';
  }

  @override
  String get uiTheSyncSessionOrRemoteRevisionChangedDownload =>
      '同步 session 或遠端 revision 已變更，請重新下載 snapshot。';

  @override
  String get uiTheWorkingCopyHasLiveOperationsSnapshotsAre =>
      '目前工作副本已有即時 operation；snapshot 僅供初始化或 checkpoint，不能覆蓋編輯中的專案。';

  @override
  String get uiSaveAndOpenRemoteRevision => '儲存並開啟遠端版本？';

  @override
  String get uiTheRemoteSnapshotIsFullyVerifiedChooseWhere =>
      '遠端 snapshot 已完整驗證。請選擇儲存位置；若選擇既有檔案，確認後會覆蓋該檔案。取消不會修改目前編輯器。';

  @override
  String get uiTheRemoteSnapshotIsVerifiedButItCannot =>
      '遠端 snapshot 已完整驗證，但目前文件不能安全地直接套用。請另存副本。';

  @override
  String get uiChooseSaveLocation => '選擇儲存位置';

  @override
  String get uiTheSyncSessionChangedDuringConfirmationNoProject =>
      '確認期間同步 session 已變更，未寫入任何專案。';

  @override
  String get uiTheSnapshotWasSavedButTheSyncSession =>
      'snapshot 已寫入，但同步 session 已失效，因此未切換目前編輯器。';

  @override
  String uiRemoteSnapshotOverwrittenAndOpened(String p1) {
    return '遠端 snapshot 已覆蓋並開啟：$p1';
  }

  @override
  String uiRemoteSnapshotSavedAsACopyAndOpened(String p1) {
    return '遠端 snapshot 已另存並開啟：$p1';
  }

  @override
  String uiCouldNotSaveOrOpenTheRemoteSnapshot(String p1) {
    return '無法儲存或開啟遠端 snapshot：$p1';
  }

  @override
  String get uiAllowAutomaticSyncForThisSession => '允許此 Session 自動套用同步？';

  @override
  String get uiTheRemoteDraftIsFullyVerifiedIfAllowed =>
      '遠端 draft 已完整驗證。允許後，此安全 session 的後續 draft 會在本機沒有自行修改時自動套用到編輯器；不會頻繁寫入 .mnproj，直到您手動儲存。';

  @override
  String uiTheRemoteRevisionIsFullyVerifiedIfAllowed(String p1) {
    return '遠端 revision 已完整驗證。允許後，此安全 session 在本機乾淨時可自動套用後續版本，不再逐次顯示覆蓋確認。目標專案：$p1。';
  }

  @override
  String get uiNotNow => '暫不允許';

  @override
  String get uiAllowThisSession => '允許此 Session';

  @override
  String get uiRemoteDraftAppliedInNearRealTimeThe =>
      '遠端 draft 已近即時套用；.mnproj 尚未寫入，手動儲存時才會升格。';

  @override
  String uiCouldNotApplyTheRemoteDraftInMemory(String p1) {
    return '無法在記憶體中套用遠端 draft：$p1';
  }

  @override
  String get uiImportModules => '匯入模組';

  @override
  String uiSource(String p1) {
    return '來源：$p1';
  }

  @override
  String get uiSelectedModulesReplaceTheCorrespondingDataInThis =>
      '勾選的模組會取代目前專案中的對應資料。';

  @override
  String get uiThisIsASelectiveExportImportingReplacesWhole =>
      '這是細項匯出檔：匯入不會逐項合併，未附的目標資料可能被移除。請先備份，再明確勾選要替換的模組。';

  @override
  String uiIncludesRequiredAncestorsOrDependenciesImportIntoAn(String p1) {
    return '$p1含必要祖先／依賴，目前已有資料，請改匯入空白專案。';
  }

  @override
  String get uiSelectiveContentReplacesTheEntireModule => '（細項，替換整個模組）';

  @override
  String uiCurrentAfterImportIncludingStructuralNodes(String p1, String p2) {
    return '目前 $p1 項 → 匯入後 $p2 項（含結構節點）';
  }

  @override
  String uiReferencesRequiringRepair(String p1) {
    return '需要稍後修復的引用：$p1';
  }

  @override
  String get uiApplyImport => '套用匯入';

  @override
  String get uiTheWorkChangedDuringConfirmationStartTheImport =>
      '確認期間作品已變更，請重新開始匯入。';

  @override
  String uiReferencesRequiringRepair2(String p1) {
    return '；$p1 筆引用需要修復';
  }

  @override
  String uiModulesImported(String p1, String p2) {
    return '已匯入 $p1 個模組$p2。';
  }

  @override
  String uiImportFailed(String p1) {
    return '匯入失敗：$p1';
  }

  @override
  String uiExportComplete(String p1) {
    return '匯出完成：$p1';
  }

  @override
  String uiExportFailed(String p1) {
    return '匯出失敗：$p1';
  }

  @override
  String uiUpgradedToInMemoryWarnings(String p1, String p2) {
    return '（已在記憶體升級至 $p1，$p2 項警告）';
  }

  @override
  String uiProjectOpened2(String p1, String p2) {
    return '專案開啟成功：$p1$p2';
  }

  @override
  String get uiUntitledMnproj => '未命名.mnproj';

  @override
  String get uiExternalProjectMnproj => '外部專案.mnproj';

  @override
  String get uiThisRecentFileHasNoUsableLocalPath =>
      '此最近檔案沒有可用的本機路徑，請改用一般「開啟檔案」。';

  @override
  String uiFailed(String p1, String p2) {
    return '$p1失敗：$p2';
  }

  @override
  String uiRemovedFromRecentProjects(String p1) {
    return '已從最近清單移除：$p1';
  }

  @override
  String get uiCodenameHana => 'Codename Hana';

  @override
  String get uiMonoAshiIsAWritingAssistantForAuthorsAnd =>
      'MonoAshi 是一個專為作家和創作者設計的寫作輔助工具。它提供了完整的故事管理功能，包括章節管理、角色設定、世界觀建構等，讓您能夠更輕鬆地組織和創作您的故事。';

  @override
  String get uiKeyFeatures => '主要功能';

  @override
  String get uiStorySettingsManagement => '故事設定管理';

  @override
  String get uiChapterAndParagraphEditing => '章節與段落編輯';

  @override
  String get uiOutlinePlanning => '大綱規劃';

  @override
  String get uiWorldbuilding => '世界觀設定';

  @override
  String get uiCharacterDatabase => '角色資料庫';

  @override
  String get uiHeyairu => '© 2025~2026 Heyairu(部屋伊琉).';

  @override
  String get uiCouldNotLoadTheNameDataTryAgain => '載入姓名資料失敗，請稍後再試。';

  @override
  String get uiNameResultsCopied => '已複製姓名結果';

  @override
  String get uiCreatingAProjectIsNotConnectedYet => '目前尚未連接新建專案功能';

  @override
  String get uiOpeningFilesIsNotConnectedYet => '目前尚未連接開啟檔案功能';

  @override
  String get uiRecentProjectsAreNotConnectedYet => '目前尚未連接最近檔案功能';

  @override
  String get uiRemovingRecentProjectsIsNotConnectedYet => '目前尚未連接刪除最近檔案功能';

  @override
  String get uiPortMustBeAnIntegerFromTo => 'Port 必須是 1–65535 的整數';

  @override
  String get uiEnterAValidLocalNetworkIPv4Address => '請輸入有效的內網 IPv4 位址';

  @override
  String get uiNeitherDeviceHasASyncProject => '雙方都沒有同步文件';

  @override
  String get uiDifferentSyncProjects => '同步文件不同';

  @override
  String get uiNeitherDeviceHasTheTargetProjectInMemory =>
      '本機與對方都沒有記憶體中的目標專案；建立新專案後即可直接協作，不必先儲存檔案。';

  @override
  String get uiTheDevicesHaveDifferentProjectUUIDsChooseWhich =>
      '雙方的 Project UUID 不同，請決定本次同步應採用哪一份文件。';

  @override
  String get uiThisDevice => '本機';

  @override
  String get uiPeer => '對方';

  @override
  String get uiCreateLocalProject => '建立本機專案';

  @override
  String get uiOpenAnotherFile => '開啟其他文件';

  @override
  String get uiUsePeerSFile => '使用對方文件';

  @override
  String get uiUseLocalFile => '使用本機文件';

  @override
  String get uiNoProjectToSync => '沒有可同步文件';

  @override
  String get uiTheInMemoryProjectIsReadyForLive =>
      '目前記憶體專案已可即時同步；儲存只用來建立 XML checkpoint。';

  @override
  String get uiTheProjectIsSavedWithAValidUUID => '目前專案已儲存且 UUID 有效，等待安全配對。';

  @override
  String get uiPrepareProjectForSync => '準備同步專案';

  @override
  String get uiLiveCollaborationRequiresAValidProjectUUIDIn =>
      '即時協作只需要記憶體中的有效 Project UUID，不要求先寫入檔案。';

  @override
  String get uiCreateInMemoryProject => '建立記憶體專案';

  @override
  String get uiOpenSavedFile => '開啟已儲存文件';

  @override
  String get uiSaveAsNewWork => '另存為新作品';

  @override
  String get uiNoProjectIsOpen => '尚未開啟專案。';

  @override
  String get uiTheCurrentProjectHasNotBeenSavedTo => '目前專案尚未儲存到可重新開啟的位置。';

  @override
  String get uiTheCurrentProjectHasUnsavedChanges => '目前專案仍有未儲存修改。';

  @override
  String get uiTheCurrentProjectHasNoValidProjectUUID =>
      '目前專案沒有有效的 Project UUID。';

  @override
  String get uiThisProjectFormatDoesNotSupportP2PSync => '目前專案格式尚不支援 P2P 同步。';

  @override
  String get uiTheCurrentProjectHasUnresolvedSyncConflicts =>
      '目前專案仍有尚未解決的同步衝突。';

  @override
  String get uiServiceOff => '服務未開啟';

  @override
  String get uiStartingService => '正在開啟服務';

  @override
  String get uiServiceRunning => '服務中';

  @override
  String get uiStoppingService => '正在停止服務';

  @override
  String get uiServiceError => '服務錯誤';

  @override
  String get uiThePeerWillProvideAnInMemoryProject => '將由對方提供記憶體專案；不必先選擇儲存位置';

  @override
  String get uiInMemoryProjectReadyForLiveSyncNo =>
      '記憶體專案可即時同步；尚未建立 XML checkpoint';

  @override
  String get uiCreateOrOpenAProjectFirst => '請先建立或開啟一個專案';

  @override
  String get uiUnresolvedSyncConflicts => '有尚未解決的同步衝突';

  @override
  String get uiSavedRevisionsSynchronized => '已儲存；revision 已同步';

  @override
  String get uiSavedReadyToNotifyThePeer => '已儲存；可通知對方同步';

  @override
  String get uiSavedReadyToDownloadAndApplyThePeer => '已儲存；可下載並套用對方版本';

  @override
  String get uiSavedFieldLevelConflictMergingAvailable => '已儲存；可進行欄位級衝突合併';

  @override
  String get uiSavedWaitingForRevisionNegotiation => '已儲存；等待 revision 協商';

  @override
  String get uiSavedWaitingForConnectionNegotiationAndSecurePairing =>
      '已儲存；等待連線協商與安全配對';

  @override
  String get uiSyncProjectIsNotReady => '同步文件尚未就緒';

  @override
  String get uiNotPaired => '尚未配對';

  @override
  String get uiWaitingForThePeerSPairingChallenge => '等待對方建立配對 challenge';

  @override
  String get uiWaitingForManualPairingCodeComparison => '等待人工比對配對碼';

  @override
  String get uiAddedToThisDeviceSTrustList => '已加入本機信任清單';

  @override
  String get uiConfirmedLocallyWaitingForThePeerSSignature => '本機已確認；等待對方簽章確認';

  @override
  String get uiBothDevicesConfirmedTheSamePairingTranscript =>
      '雙端已確認同一配對 transcript';

  @override
  String get uiPairingError => '配對錯誤';

  @override
  String get uiPersistentVerificationEnabledOnBothDevicesValidFor =>
      '持久驗證：雙方皆已開啟，配對成功後有效 14 天';

  @override
  String uiPersistentVerificationExpiresEachSuccessfulConnectionRenewsIt(
    String p1,
  ) {
    return '持久驗證有效至 $p1；成功連線會再續簽 14 天';
  }

  @override
  String get uiPersistentVerificationExpiredConfirmThePairingCodeAgain =>
      '持久驗證已到期；本次需重新確認配對碼';

  @override
  String get uiLocalRevisionLoading => '本機 revision：載入中…';

  @override
  String get uiLocalRevisionMetadataError => '本機 revision：metadata 錯誤';

  @override
  String get uiLocalRevisionNotCreatedYetCreatedAfterA =>
      '本機 revision：尚未建立（成功儲存後建立）';

  @override
  String uiLocalRevisionConcurrentHeads(String p1) {
    return '本機 revision：$p1 個 concurrent heads';
  }

  @override
  String uiLocalRevision(String p1, String p2) {
    return '本機 revision：$p1  ·  $p2';
  }

  @override
  String get uiEncryptedChannelNotEstablished => '加密通道：尚未建立';

  @override
  String get uiEncryptedChannelVerifyingIdentityAndDerivingASession =>
      '加密通道：正在驗證身分與派生 session key…';

  @override
  String get uiEncryptedChannelAuthenticatedAndEncrypted => '加密通道：已驗證並加密';

  @override
  String get uiEncryptedChannelConnectionFailed => '加密通道：建立失敗';

  @override
  String get uiRevisionHeadsMatch => '；revision heads 相同';

  @override
  String get uiLocalRevisionIsNewer => '；本機 revision 較新';

  @override
  String get uiPeerRevisionIsNewer => '；對方 revision 較新';

  @override
  String get uiConcurrentRevisionsDetected => '；偵測到 concurrent revisions';

  @override
  String get uiSnapshotChunkValidationEnabled => '；snapshot chunk gate 已啟用';

  @override
  String get uiLocalManifestNotCreated => '本機 manifest：尚未建立';

  @override
  String uiLocalManifestBytesChunks(String p1, String p2) {
    return '本機 manifest：$p1 bytes／$p2 chunks';
  }

  @override
  String get uiPeerManifestNotNegotiated => '對方 manifest：尚未協商';

  @override
  String get uiPeerManifestRequesting => '對方 manifest：要求中…';

  @override
  String uiPeerManifestVerifiedBytes(String p1) {
    return '對方 manifest：已驗證（$p1 bytes）';
  }

  @override
  String get uiPeerManifestCurrentlyUnavailable => '對方 manifest：目前不可用';

  @override
  String get uiPeerManifestVerificationFailed => '對方 manifest：驗證失敗';

  @override
  String get uiRevisionDAGExchangingGraphPages =>
      'Revision DAG：正在交換 graph pages…';

  @override
  String get uiRevisionDAGFullHistoryNotYetExchanged => 'Revision DAG：尚未交換完整歷史';

  @override
  String uiRevisionDAGRemoteRevisionsMaximalCommonAncestorsWaiting(
    String p1,
    String p2,
  ) {
    return 'Revision DAG：遠端 $p1 revisions；$p2 個 maximal common ancestors；等待 resolve/ACK';
  }

  @override
  String uiRevisionDAGPeerAcknowledgedResolution(String p1) {
    return 'Revision DAG：對方已 ACK resolve $p1';
  }

  @override
  String get uiCouldNotOpenTheLinkItHasBeen => '無法直接開啟連結，已複製到剪貼簿';

  @override
  String get uiNewProject => 'New Project';

  @override
  String get uiOpenFile2 => 'Open File';

  @override
  String get uiOpenThisProjectOnGitHub => 'Open GitHub Repo for This Project';

  @override
  String get uiHeyairuSKadoKadoProfile => 'Heyairu\'s Profile on KadoKado';

  @override
  String get uiSendFeedbackGoogleForms => 'Comment (on Google Forms)';

  @override
  String get uiSendFeedbackGitHubIssues => 'Comment (on GitHub Issues)';

  @override
  String get uiNoRecentFiles => '尚無最近開啟檔案';

  @override
  String get uiProjectsYouOpenWillAppearHere => '開啟專案後會顯示在這裡';

  @override
  String get uiNoUsablePath => '無可用路徑';

  @override
  String get uiRemoveFromRecentProjects => '從最近清單移除';

  @override
  String get uiNameGenerator => '姓名產生器';

  @override
  String get uiLanguage => '語言';

  @override
  String get uiEnglish => '英式';

  @override
  String get uiNameUnitedKingdom => '英國';

  @override
  String get uiNameUnitedStates => '美國';

  @override
  String get uiNameCanada => '加拿大';

  @override
  String get uiNameAustralia => '澳洲';

  @override
  String get uiJapanese => '日式';

  @override
  String get uiChinese => '中式';

  @override
  String get uiKorean => '韓式';

  @override
  String get uiGender => '性別';

  @override
  String get uiMale => '男性';

  @override
  String get uiNeutral => '中性';

  @override
  String get uiFemale => '女性';

  @override
  String get uiNumberToGenerate => '生成數';

  @override
  String get uiGenerate => '生成';

  @override
  String get uiResults => '結果';

  @override
  String get uiCopyResults => '複製結果';

  @override
  String get uiSelectGenerateToCreateNames => '按下「生成」來產生姓名';

  @override
  String get uiContentSync => '內容同步';

  @override
  String get uiAfterSignedPairingAndAnAuthenticatedConnectionDevices =>
      '完成簽章配對與 authenticated transport 後，可交換加密 revision、manifest 與 snapshot chunks；接收內容只會進入隔離驗證區。';

  @override
  String get uiLocalService => '本機服務';

  @override
  String get uiNoUsableLANIPv4AddressFound => '尚未找到可用 LAN IPv4';

  @override
  String get uiDetectLocalIPAgain => '重新偵測本機 IP';

  @override
  String get uiLocalPort => '本機 Port';

  @override
  String get uiStopService => '中斷服務';

  @override
  String get uiStartService => '開啟服務';

  @override
  String get uiConnectToDevice => '連線至裝置';

  @override
  String get uiPeerIP => '對方 IP';

  @override
  String get uiForExample => '例如 192.168.1.23';

  @override
  String get uiPeerPort => '對方 Port';

  @override
  String get uiEndpointVerified => '端點已驗證';

  @override
  String get uiConnecting => '連線中…';

  @override
  String get uiConnect => '連線';

  @override
  String get uiDisconnect => '中斷連線';

  @override
  String get uiDeviceIdentityAndPairing => '裝置身分與配對';

  @override
  String uiLocalFingerprint(String p1) {
    return '本機指紋：$p1';
  }

  @override
  String get uiInitializing => '初始化中…';

  @override
  String get uiConfirmationOneDeviceEnabledOnBothDevices =>
      '確認模式：單端確認（雙方設定皆已開啟）';

  @override
  String get uiConfirmationBothDevicesOneOrBothDisabledSingle =>
      '確認模式：雙端各自確認（至少一方已關閉單端確認）';

  @override
  String get uiConfirmBothDevicesDisplayExactlyTheSamePairing =>
      '請確認兩台裝置顯示完全相同的配對碼：';

  @override
  String get uiCancelIfTheCodesDifferAfterEitherDevice =>
      '若數字不同請取消配對；任一端確認後，另一端會驗證簽章並自動回簽。';

  @override
  String get uiCancelIfTheCodesDifferBothDevicesMust =>
      '若數字不同請取消配對；目前需兩端各自確認，完成後才會開啟加密內容通道。';

  @override
  String get uiStartSecurePairing => '開始安全配對';

  @override
  String get uiConfirmCodesMatch => '確認配對碼相同';

  @override
  String get uiCancelPairing => '取消配對';

  @override
  String get uiBothIdentitiesAndTemporaryECDHKeysAreBound =>
      '雙方身分與短期 ECDH key 已綁定至同一 transcript；相同 project session 可交換加密 snapshot chunks，接收後仍須通過 quarantine 驗證。';

  @override
  String get uiBothDevicesSignedTheSameChallengeEstablishingAuthenticated =>
      '雙方已簽署同一組 challenge，正在建立 authenticated encrypted transport；建立前不交換 revision summary 或內容。';

  @override
  String get uiSyncProject => '同步文件';

  @override
  String get uiNoProjectOpen => '尚未開啟專案';

  @override
  String uiPeerFile(String p1) {
    return '對方文件：$p1';
  }

  @override
  String uiPeerUUID(String p1) {
    return '對方 UUID：$p1';
  }

  @override
  String get uiChangeSyncProject => '更換同步文件';

  @override
  String get uiPrepareSyncProject => '準備同步文件';

  @override
  String get uiRevisionsDivergedResolveFieldLevelConflictsFirst =>
      '雙方 revision 並行，必須先進入欄位級衝突處理';

  @override
  String get uiAskTheReceiverToDownloadTheCurrentSnapshot =>
      '透過 authenticated transport 要求接收端下載目前 snapshot';

  @override
  String get uiOnlyAcceptARemoteSnapshotThatExactlyMatches =>
      '僅接受 authenticated transport 中與目前 session 完全相符的遠端 snapshot';

  @override
  String get uiApplying => '正在套用';

  @override
  String get uiDownloading => '正在下載';

  @override
  String get uiSyncNow => '立即同步';

  @override
  String get uiCompareRemoteRevision => '比較遠端版本';

  @override
  String get uiCancelTransfer => '取消傳輸';

  @override
  String get uiBasicInformation => '基本資訊';

  @override
  String get uiBookTitle => '書名';

  @override
  String get uiEnterTheBookTitle => '輸入書名';

  @override
  String get uiAuthor => '作者';

  @override
  String get uiEnterTheAuthorSName => '輸入作者名';

  @override
  String get uiTheme2 => '主旨';

  @override
  String get uiEnterTheStorySTheme => '輸入故事主旨';

  @override
  String get uiOneLineSummary => '一句話簡介';

  @override
  String get uiEnterAOneLineSummary => '輸入一句話簡介';

  @override
  String get uiEnterTheGenre => '輸入作品類型';

  @override
  String get uiSynopsis => '簡介';

  @override
  String get uiEnterASynopsis => '輸入作品簡介';

  @override
  String get uiStatistics => '統計資訊';

  @override
  String get uiLastSaved => '最後儲存時間';

  @override
  String get uiTotalCount => '總字數';

  @override
  String uiCharacters2(String p1) {
    return '$p1 字';
  }

  @override
  String get uiChapterCount => '本章字數';

  @override
  String uiFolder(String p1) {
    return '資料夾 $p1';
  }

  @override
  String get uiChapters => '章節選擇';

  @override
  String uiTotalCharacters(String p1) {
    return '全書共 $p1 字';
  }

  @override
  String get uiFoldersAndChaptersShareOneListDeletingA =>
      '資料夾與章節位於同一清單；移除資料夾會一併移除其中章節。';

  @override
  String get uiLongPressAndDragToReorderDragChapters =>
      '長按拖曳排序；章節可拖入其他資料夾。根目錄固定隱藏。';

  @override
  String get uiSearchFolderOrChapterNames => '搜尋資料夾或章節名稱';

  @override
  String get uiClearSearch => '清除搜尋';

  @override
  String get uiChapterTree => '章節樹';

  @override
  String get uiNoChapters => '尚無章節';

  @override
  String get uiAddYourFirstFolder => '請新增第一個資料夾';

  @override
  String get uiChapterName => '章節名稱';

  @override
  String get uiSelectAFolderFirst => '請先選擇資料夾';

  @override
  String get uiSubfolder => '子資料夾';

  @override
  String get uiSelectAParentFolderFirst => '請先選擇父資料夾';

  @override
  String get uiRootFolder => '根資料夾';

  @override
  String get uiAddChapter => '新增章節';

  @override
  String get uiAddSubfolder => '新增子資料夾';

  @override
  String get uiAddRootFolder => '新增根資料夾';

  @override
  String get uiUnnamedFolder => '（未命名資料夾）';

  @override
  String uiChaptersSubfoldersCount(String p1, String p2, String p3) {
    return '$p1 章 • $p2 個子資料夾 • $p3 字';
  }

  @override
  String get uiCollapseFolder => '收合資料夾';

  @override
  String get uiExpandFolder => '展開資料夾';

  @override
  String get uiDeleteThisFolderAndItsChapters => '刪除此資料夾與其中章節';

  @override
  String get uiAtLeastOneChapterIsRequired => '至少須保留一章';

  @override
  String uiChapterMovedTo(String p1) {
    return '章節已移動到「$p1」';
  }

  @override
  String get uiDeleteThisChapter => '刪除此章節';

  @override
  String get uiSourceCharacter => '來源人物';

  @override
  String get uiTargetCharacter => '目標人物';

  @override
  String get uiSelectAnExistingCharacterOrEnterANew => '選擇現有人物或輸入新人物名稱';

  @override
  String get uiExternalRelationship => '外在關係';

  @override
  String get uiForExampleFriendFamilyRival => '例如：朋友、家人、競爭對手';

  @override
  String get uiInternalRelationship => '內在關係';

  @override
  String get uiForExampleTrustAdmirationEnvy => '例如：信任、崇拜、嫉妒';

  @override
  String get uiBidirectionalRelationship => '雙向關係';

  @override
  String get uiAlsoCreateARelationshipFromTheTargetBack => '同時建立目標人物指回來源人物的關係';

  @override
  String get uiNoCharactersYet => '尚無人物資料';

  @override
  String get uiAddCharactersInCharacterSettingsBeforeCreatingAnd =>
      '請先到角色設定新增人物，再回來建立與查看關係。';

  @override
  String get uiMinimizeTimelineAndSnapshots => '最小化時間軸與快照';

  @override
  String get uiHistoricalPreviewsAreReadOnlyEachCharacterUses =>
      '歷史預覽唯讀；每位角色採用此 Tick 前的有效變更。切回預設資料可編輯。';

  @override
  String get uiCharacterRelationships => '關係設定';

  @override
  String get uiCollapseToolbar => '收合工具列';

  @override
  String get uiExpandToolbar => '展開工具列';

  @override
  String get uiEnableSnapshots => '啟用快照';

  @override
  String get uiShowSnapshotCards => '顯示快照 Card';

  @override
  String get uiCloseSnapshots => '關閉快照';

  @override
  String get uiShowRelationships => '顯示關係';

  @override
  String get uiArrangeCharacters => '角色排列';

  @override
  String get uiLocateCharacter => '角色定位';

  @override
  String get uiRelationshipClusters => '關係群集';

  @override
  String get uiExternalInternalDragCharactersToReposition =>
      '外在 ━   內在 ┄   拖曳角色可調整位置';

  @override
  String get uiSearchOrSelectCharacter => '搜尋或選擇人物';

  @override
  String get uiSearchAndFocus => '搜尋並聚焦';

  @override
  String get uiShowDirectNeighborsOnly => '只顯示一階鄰居';

  @override
  String get uiSelectACharacterFirst => '先選擇角色';

  @override
  String get uiOverview => '全局預覽';

  @override
  String get uiAddRelationship => '新增關係';

  @override
  String get uiHistoricalPreviewIsReadOnly => '歷史預覽唯讀';

  @override
  String get uiRearrangeAutomatically => '自動重新排列';

  @override
  String get uiResetZoom => '重設縮放';

  @override
  String get uiZoomOut => '縮小';

  @override
  String get uiZoomIn => '放大';

  @override
  String get uiMergeIdenticalBidirectionalRelationships => '合併相同的雙向關係';

  @override
  String get uiNoMatchingCharacters => '找不到符合的人物';

  @override
  String get uiNoRelationshipsYetAddOneHereOrEdit => '目前沒有關係；可在此新增，或回到角色設定編輯。';

  @override
  String get commonAdd => '新增';

  @override
  String uiAnd(String p1, String p2) {
    return '$p1 與 $p2';
  }

  @override
  String get uiOpenCharacterEditor => '開啟人物編輯';

  @override
  String get uiCollapseDetails => '收合詳細資料';

  @override
  String get uiExpandDetails => '展開詳細資料';

  @override
  String get uiThisNameDoesNotUniquelyIdentifyACharacter =>
      '此名稱目前無法唯一對應到人物資料。請選取連線進行修正。';

  @override
  String uiOccupation(String p1) {
    return '職業：$p1';
  }

  @override
  String uiAge(String p1) {
    return '年齡：$p1';
  }

  @override
  String uiGender2(String p1) {
    return '性別：$p1';
  }

  @override
  String get uiOrganizations => '所屬組織';

  @override
  String uiAdjacentRelationships(String p1) {
    return '相鄰關係：$p1';
  }

  @override
  String get uiUnpin => '解除釘選';

  @override
  String get uiPinPosition => '釘選位置';

  @override
  String get uiThisPinnedPositionOverlapsAnotherPinnedCharacterDrag =>
      '釘選位置與其他釘選角色重疊，可拖曳調整。';

  @override
  String get uiCreateTargetCharacter => '建立目標人物';

  @override
  String uiShowing(String p1) {
    return '目前顯示：$p1';
  }

  @override
  String get uiExternal => '外在';

  @override
  String get uiInternal => '內在';

  @override
  String get uiShowAllRelationships => '顯示全部關係';

  @override
  String get uiSeveralCharactersShareThisNameEditAndSelect =>
      '有多位同名人物，請編輯並選擇含 NanoID 的人物。';

  @override
  String get uiNoMatchingCharacterCorrectTheNameOrCreate =>
      '找不到對應人物，可修正名稱或建立新人物。';

  @override
  String get uiCreateCharacter => '建立人物';

  @override
  String get uiEdit => '編輯';

  @override
  String get uiCorrectTargetCharacter => '修正目標人物';

  @override
  String uiDelete(String p1) {
    return '刪除$p1';
  }

  @override
  String get uiDeleteAllRelationshipsInThisDirection => '刪除此方向全部關係';

  @override
  String get uiTheRelationshipChangedSelectItAgainBeforeContinuing =>
      '關係已變更，請重新選取後再操作。';

  @override
  String uiEditRelationship(String p1, String p2, String p3) {
    return '$p1 → $p2 · 編輯$p3關係';
  }

  @override
  String uiRelationship(String p1) {
    return '$p1關係';
  }

  @override
  String get uiDeleteCharacterRelationship => '刪除人物關係';

  @override
  String get uiDeleteBothExternalAndInternalRelationshipsInThis =>
      '確定刪除此方向的外在與內在關係？反向關係會保留。';

  @override
  String uiDeleteTheRelationshipInThisDirectionOtherTypes(
    String p1,
    String p2,
  ) {
    return '確定刪除此方向的$p1關係「$p2」？另一類型與反向關係會保留。';
  }

  @override
  String get uiSelectAnExistingCharacterThatCanBeUniquely =>
      '請從清單選擇能唯一對應的現有人物。';

  @override
  String get uiSeveralCharactersShareThisNameSelectOneWith =>
      '有多位同名人物，請從清單選擇含 NanoID 的人物';

  @override
  String get uiAfterCreationThisRelationshipWillLinkAutomaticallyBy =>
      '建立後，這筆關係會依人物名稱自動連結。';

  @override
  String get uiCharacterName => '人物名稱';

  @override
  String get uiCreatingTheCharacterAlsoAddsARelationshipFrom =>
      '新人物建立後，會同時新增由目前人物指向他的關係。';

  @override
  String get uiNext2 => '下一步';

  @override
  String get uiSetUpNewCharacterRelationship => '設定新人物關係';

  @override
  String get uiCorrectTheTargetInThisDirection => '修正此方向的目標人物';

  @override
  String get uiSelectAnExistingCharacterBothRelationshipTypesMove =>
      '選擇現有人物；內外關係將一起移至該人物';

  @override
  String get uiCharacterEditor => '角色編輯';

  @override
  String get uiCharacterList => '角色列表';

  @override
  String get uiCharacterName2 => '角色名稱';

  @override
  String get uiNoCharacters => '尚無角色';

  @override
  String get uiAddYourFirstCharacter => '請新增第一個角色';

  @override
  String uiCharacterType(String p1) {
    return '角色類型：$p1';
  }

  @override
  String get uiSelectACharacter => '請選取一個角色';

  @override
  String get uiSelectACharacterFromTheListOnThe => '從左側列表選擇要編輯的角色';

  @override
  String get uiCharacterCard => '角色卡';

  @override
  String get uiCustomData => '自訂資料';

  @override
  String get uiAdvancedSettings => '進階設定';

  @override
  String get uiAddSnapshot => '新增快照';

  @override
  String get uiDuplicateSnapshot => '複製快照';

  @override
  String get uiDefault => '預設';

  @override
  String get uiDeleteSnapshot => '刪除快照';

  @override
  String get uiTheDefaultSnapshotCannotBeDeleted => '預設快照不可刪除';

  @override
  String get uiBasicIdentity => '基本識別';

  @override
  String get uiNameRequired => '姓名（必填）：';

  @override
  String get uiRoleOccupation => '身份／職業：';

  @override
  String get uiAge2 => '年齡：';

  @override
  String get uiGender3 => '性別：';

  @override
  String get uiBirthday => '生日：';

  @override
  String get uiCharacterType2 => '角色類型';

  @override
  String get uiAppearanceSummary => '外觀摘要';

  @override
  String get uiDescribeTheCharacterSGeneralAppearance => '紀錄角色大致外觀。';

  @override
  String get uiHeight => '身高：';

  @override
  String get uiWeight => '體重：';

  @override
  String get uiHairColor => '髮色：';

  @override
  String get uiEyeColor => '瞳色：';

  @override
  String get uiAppearanceSummary2 => '外觀摘要：';

  @override
  String get uiPersonalityAndStoryCore => '性格與故事核心';

  @override
  String get uiDescribeTheCharacterSPersonalityAndTheChallenges =>
      '紀錄角色個性，以及在故事中遇到的困難。';

  @override
  String get uiPersonality => '個性：';

  @override
  String get uiSpeechStyle => '說話風格：';

  @override
  String get uiMotivation => '動機：';

  @override
  String get uiGoal => '目標：';

  @override
  String get uiValuesAndBeliefs => '價值觀與信念：';

  @override
  String get uiFear => '恐懼：';

  @override
  String get uiObstaclesAndResolutions => '阻礙與解決方式';

  @override
  String get uiObstacle => '阻礙事件';

  @override
  String get uiResolution => '解決方式';

  @override
  String get uiEnterAnObstacleAndResolutionBelowThenAdd => '在下方輸入事件與解決方式後新增';

  @override
  String get uiCharacterRelationships2 => '人物關係描述';

  @override
  String get uiDescribeTheCharacterSConnectionsWithOthers => '描述角色與其他人的連結。';

  @override
  String get uiRelationshipSummary => '人物關係簡述：';

  @override
  String get uiOrganization => '組織';

  @override
  String get uiPositionTitle => '身分／職位';

  @override
  String get uiEnterAnOrganizationAndPositionBelowThenAdd => '在下方輸入組織與身分或職位後新增';

  @override
  String get uiSelectALocationOrOrganizationOrEnterYour => '選擇地點或組織，或自行輸入';

  @override
  String get uiCharacterStatus => '角色狀態';

  @override
  String get uiDescribeTheCharacterSGeneralState => '角色的大致狀態。';

  @override
  String get uiEnterAStatusAndDescriptionBelowThenAdd => '在下方輸入狀態與說明後新增';

  @override
  String get uiNotes2 => '備註：';

  @override
  String get uiSelectACharacterFirst2 => '請先選取角色';

  @override
  String get uiSelectACharacterToPreviewTheTimelineAnd => '選取角色後即可預覽時間軸與管理快照';

  @override
  String get uiStoryStateEditingDefaultData => '故事狀態 · 編輯中：預設資料';

  @override
  String uiStoryStateTick(String p1, String p2) {
    return '故事狀態 · Tick $p1 · $p2';
  }

  @override
  String get uiReadOnlyPreviewFollowingTheTimeline => '唯讀預覽；已開啟跟隨時間軸。';

  @override
  String uiEditing(String p1) {
    return '編輯中：$p1';
  }

  @override
  String get uiEditingASceneSnapshotObstaclesRelationshipsOrganizationsStatus =>
      '正在編輯 Scene 快照：阻礙、人物關係、組織、角色狀態、擁有物品與自訂欄位可修改；其餘固定資料已鎖定。';

  @override
  String get uiDefaultData => '預設資料';

  @override
  String get uiStateAtPlayhead => '目前播放頭狀態';

  @override
  String uiCurrentTick(String p1) {
    return '目前 Tick $p1';
  }

  @override
  String get uiCopyCurrentState => '複製目前狀態';

  @override
  String get uiDefaultItemAssignments => '預設物品配置';

  @override
  String uiItemAssignmentsAtTick(String p1) {
    return 'Tick $p1 的物品配置';
  }

  @override
  String get uiAllSnapshots => '所有快照';

  @override
  String uiTotalIncludingDefault(String p1) {
    return '共 $p1 筆（含預設）';
  }

  @override
  String get uiSnapshotHistoryAndEditing => '快照歷程與編輯';

  @override
  String get uiDefaultSnapshotBeforeTheStory => '預設快照（故事開始前）';

  @override
  String get uiTheSceneIsUnscheduledOrItsPrimaryPlacement =>
      'Scene 尚未排定或主要 placement 已失效';

  @override
  String get uiFallbackTick => 'Fallback Tick';

  @override
  String uiChanges2(String p1) {
    return '變更：$p1';
  }

  @override
  String uiNotes3(String p1) {
    return '備註：$p1';
  }

  @override
  String get uiDefaultSnapshot => '預設快照';

  @override
  String get uiLocateSnapshot => '定位快照';

  @override
  String get uiEditSnapshot => '編輯快照';

  @override
  String get uiDeleteSnapshot2 => '刪除快照？';

  @override
  String get uiDeletingThisSnapshotRecalculatesTheCharacterSState =>
      '刪除後，這個 Scene 之後的角色狀態會重新推導。';

  @override
  String uiIsLocked(String p1) {
    return '$p1已鎖定';
  }

  @override
  String get uiSceneSnapshotsAllowChangesOnlyToTheFive =>
      'Scene 快照只允許修改五組角色 Table 與自訂欄位；切回「預設」即可編輯固定資料。';

  @override
  String uiEvent2(String p1) {
    return '中箱：$p1';
  }

  @override
  String get uiThisEventHasNoScenesYetANew => '此中箱尚無小箱；新 Scene 會建立在這個中箱中。';

  @override
  String uiStoryline(String p1) {
    return '大箱：$p1';
  }

  @override
  String get uiTheSpecifiedEventWasNotFoundANew => '找不到指定中箱；新中箱會建立在這個大箱中。';

  @override
  String get uiGlobalPreview => '全域預覽';

  @override
  String get uiTheSpecifiedStorylineWasNotFoundANew =>
      '找不到指定大箱；將建立新的大箱、中箱與 Scene。';

  @override
  String get uiCharacterSnapshot => '角色快照';

  @override
  String get uiCharacterSnapshotScene => '角色快照 Scene';

  @override
  String get uiNewScene => '新 Scene';

  @override
  String get uiAddSceneSnapshot => '新增 Scene 快照';

  @override
  String uiDuplicate(String p1) {
    return '複製 $p1';
  }

  @override
  String get uiLinkToScene => '綁定 Scene';

  @override
  String get uiQuickCreateScene => '＋ 快速建立新 Scene';

  @override
  String get uiSceneHierarchy => 'Scene 階層';

  @override
  String get uiStorylineSelectExistingOrEnterAName => '大箱（可選既有或輸入新名稱）';

  @override
  String get uiForExampleActOne => '例如：第一幕';

  @override
  String get uiEventSelectExistingOrEnterAName => '中箱（可選既有或輸入新名稱）';

  @override
  String get uiForExampleConflictAtTheGate => '例如：城門衝突';

  @override
  String get uiSceneName => '小箱（Scene 名稱）';

  @override
  String get uiForExampleArrivingAtTheGate => '例如：抵達城門';

  @override
  String get uiTimelineTick => '時間軸 Tick';

  @override
  String uiEnterToOrClickOrDragTheScrubber(String p1, String p2) {
    return '可輸入 $p1～+$p2，或在上方時間軸點擊／拖動 Scrubber。';
  }

  @override
  String uiTickMustBeBetweenAnd(String p1, String p2) {
    return 'Tick 必須介於 $p1～+$p2。';
  }

  @override
  String get uiInitialContent => '初始內容';

  @override
  String get uiEmptyState => '空白狀態';

  @override
  String uiCopyFrom(String p1) {
    return '複製來源：$p1';
  }

  @override
  String get uiSpecificSnapshot => '指定快照';

  @override
  String get uiCopiesTheCompleteDerivedStateAtTheSource => '會複製來源當下的完整推導狀態。';

  @override
  String get uiEnterNamesForTheStorylineEventAndScene => '請填寫大箱、中箱與小箱名稱。';

  @override
  String get uiCreateSnapshot => '建立快照';

  @override
  String uiCopiedFrom(String p1) {
    return '複製自 $p1';
  }

  @override
  String get uiSceneSnapshotAdded => '已新增 Scene 快照';

  @override
  String uiMovedToTick(String p1) {
    return '已定位至 Tick $p1';
  }

  @override
  String get uiIdentitySettings => '識別設定';

  @override
  String get uiAnCharacterNanoIDDistinguishesCharactersWithTheSame =>
      '供角色重名時辨識用的 8 位 NanoID';

  @override
  String get uiDetailedProfileAndAppearance => '詳細基本資料與外觀';

  @override
  String get uiResidenceFeaturesAndClothing => '居住地、五官與服裝';

  @override
  String get uiPersonalityTools => '性格工具';

  @override
  String get uiHabitsAlignmentAndPersonalityScales => '習慣、陣營與性格量表';

  @override
  String get uiPreferencesAndAbilities => '喜好與能力';

  @override
  String get uiAbilityListsAndEverydaySkillScales => '能力清單與生活技能量表';

  @override
  String get uiSocialQuestionnaire => '社交問卷';

  @override
  String get uiSocialBehaviorTendenciesAndRomance => '社交行為、傾向與戀愛概況';

  @override
  String get uiOtherLegacyFields => '其他舊欄位';

  @override
  String get uiOriginalLanguageNamePreferencesAndExtraNotes => '原文姓名、喜惡與其他補充';

  @override
  String get uiText => '文字';

  @override
  String get uiSlider => '滑桿';

  @override
  String get uiCheckbox => '核取方塊';

  @override
  String get uiList => '清單';

  @override
  String get uiFieldName => '欄位名稱';

  @override
  String get uiDataType => '型別';

  @override
  String get uiNoCustomData => '尚無自訂資料';

  @override
  String get uiEnterAFieldNameSelectItsTypeAnd => '輸入欄位名稱並選擇型別後新增';

  @override
  String uiRemove(String p1) {
    return '移除$p1';
  }

  @override
  String get uiBirthplace => '出生地：';

  @override
  String get uiResidence => '居住地：';

  @override
  String get uiAddress => '住址：';

  @override
  String get uiAppearance => '外觀';

  @override
  String get uiBloodType => '血型：';

  @override
  String get uiSkinColor => '膚色：';

  @override
  String get uiFaceShape => '臉型：';

  @override
  String get uiEyeShape => '眼型：';

  @override
  String get uiEarShape => '耳型：';

  @override
  String get uiNoseShape => '鼻型：';

  @override
  String get uiMouthShape => '嘴型：';

  @override
  String get uiEyebrowShape => '眉型：';

  @override
  String get uiBuild => '體格：';

  @override
  String get uiClothing => '服裝：';

  @override
  String get uiCatchphrasesAndExpressions => '口頭禪、慣用語：';

  @override
  String get uiInterests => '興趣：';

  @override
  String get uiHabitsAndQuirks => '習慣、癖好：';

  @override
  String get uiFaith => '信仰：';

  @override
  String get uiBoundaries => '底線';

  @override
  String get uiWhatDoTheyWantToBecome => '將來想變得如何？';

  @override
  String get uiWhatDoTheyValueMost => '最珍視的事物？';

  @override
  String get uiWhatDoTheyDespiseMost => '最厭惡的事物？';

  @override
  String get uiWhatDoTheyFearMost => '最害怕的事物？';

  @override
  String get uiWhatIntriguesThemMost => '最好奇的事物？';

  @override
  String get uiWhatDoTheyLookForwardToMost => '最期待的事物？';

  @override
  String get uiAlignment => '陣營';

  @override
  String get uiPersonalityTraits => '性格特質';

  @override
  String get uiApproachToLife => '行事作風';

  @override
  String get uiAdditionalNotes => '其他補充：';

  @override
  String get uiThingsTheyLoveDoing => '熱愛做的事情';

  @override
  String get uiThingsTheyWantToTry => '想要做還沒做的事情';

  @override
  String get uiThingsTheyDislikeDoing => '討厭做的事情';

  @override
  String get uiThingsTheyFearDoing => '害怕做的事情';

  @override
  String get uiThingsTheyDoWell => '擅長做的事情';

  @override
  String get uiThingsTheyStruggleWith => '不擅長做的事情';

  @override
  String get uiEverydaySkills => '生活常用技能';

  @override
  String get uiOthersImpressions => '來自他人的印象';

  @override
  String get uiMostAdmiredOrLovedQualities => '最受他人欣賞/喜愛的特點';

  @override
  String get uiFamilyBackground => '簡述原生家庭';

  @override
  String get uiHowTheyExpressAffection => '如何表達「喜歡」';

  @override
  String get uiOther => '其他';

  @override
  String get uiHowTheyShowKindness => '如何表達好意';

  @override
  String get uiHowDoTheyHandlePeopleTheyDislike => '如何應對討厭的人？';

  @override
  String get uiRomanticRelationships => '戀愛關係';

  @override
  String get uiSocialTendencies => '社交相關項目';

  @override
  String get uiOriginalLanguageName => '原文姓名';

  @override
  String get uiForExample2 => '例如：桜田如羽';

  @override
  String get uiThingsTheyLike => '喜歡的事物';

  @override
  String get uiThingsTheyAdmire => '憧憬的事物';

  @override
  String get uiThingsTheyDislike => '討厭的事物';

  @override
  String get uiThingsTheyFear => '害怕的事物';

  @override
  String get uiFamiliarThings => '習慣的事物';

  @override
  String get uiAdditionalNotes2 => '其他補充';

  @override
  String get uiCharacterRelationships3 => '人物關係';

  @override
  String get uiNoCharacterRelationships => '尚無人物關係';

  @override
  String get uiEnterACharacterAndExternalInternalRelationshipsBelow =>
      '在下方輸入人物、外在關係與內在關係後新增';

  @override
  String get uiSelectACharacterOrEnterAName => '選擇角色或自行輸入';

  @override
  String get uiExternalRelationshipOptional => '外在關係（可留空）';

  @override
  String get uiInternalRelationshipOptional => '內在關係（可留空）';

  @override
  String get uiUpdate => '更新';

  @override
  String uiNoYet(String p1) {
    return '尚無$p1';
  }

  @override
  String uiOptional(String p1) {
    return '$p1（可留空）';
  }

  @override
  String get uiPossessions => '擁有物品';

  @override
  String get uiQuantity => '數量';

  @override
  String get uiNoPossessions => '尚無擁有物品';

  @override
  String get uiEnterAnItemQuantityAndDescriptionBelowThen => '在下方輸入物品、數量與說明後新增';

  @override
  String get uiDescriptionOptional => '說明（可留空）';

  @override
  String get uiConvertToManagedItem => '轉換為正式物品';

  @override
  String get uiTheseAreLegacyPossessionsConvertEachEntryTo =>
      '以下是舊版擁有物品資料。請逐筆轉換為正式物品；此頁已不再新增舊格式資料。';

  @override
  String uiQuantity2(String p1) {
    return '數量：$p1';
  }

  @override
  String get uiLiteral => '・';

  @override
  String get uiDeleteLegacyEntry => '刪除舊資料';

  @override
  String get uiUnknown => '未知';

  @override
  String get uiRelatedItems => '一般關聯物品';

  @override
  String get uiLinkItem => '連結物品';

  @override
  String get uiNoRelatedItemsAreConfigured => '尚未設定一般物品關聯。';

  @override
  String get uiOpenItems => '開啟物品頁';

  @override
  String get uiUnlink => '解除關聯';

  @override
  String get uiCurrentlyHeldItems => '目前持有物品';

  @override
  String get uiAssignItem => '分配物品';

  @override
  String get uiNoLinkedItems => '目前沒有已連結物品';

  @override
  String get uiSelectAssignItemToSetTheHolderOr => '按「分配物品」即可在此頁設定持有人或聚合數量';

  @override
  String get uiStatusNotes => '狀態／備註';

  @override
  String get uiActions => '操作';

  @override
  String get uiClearDefaultAssignment => '清除預設分配';

  @override
  String get uiSelectAnItemToAssignToTheCharacter => '選擇要分配給角色的物品';

  @override
  String uiAssign(String p1) {
    return '分配「$p1」';
  }

  @override
  String get uiLeaveBlankIfTheQuantityIsUnknown => '留空代表數量未知';

  @override
  String get uiAssign2 => '分配';

  @override
  String get uiQuantityMustBeZeroOrAPositiveInteger => '數量必須是零或正整數。';

  @override
  String uiCouldNotAssignTheItem(String p1) {
    return '無法分配物品：$p1';
  }

  @override
  String uiConvert(String p1) {
    return '轉換「$p1」';
  }

  @override
  String get uiRemovesMatchingLegacyEntriesFromTheDefaultCharacter =>
      '會移除角色預設與可定位 Scene 快照中的同名舊資料，並建立正式物品狀態。';

  @override
  String get uiLinkExisting => '連結既有';

  @override
  String get uiCreateAndConvert => '建立並轉換';

  @override
  String uiSelectTheManagedItemFor(String p1) {
    return '選擇「$p1」對應的正式物品';
  }

  @override
  String get uiConfirmPossessionConversion => '確認持有物轉換';

  @override
  String uiDefaultBaselineEntries(String p1) {
    return '預設／baseline：$p1 筆';
  }

  @override
  String uiSceneSnapshotEntries(String p1) {
    return 'Scene 快照：$p1 筆';
  }

  @override
  String uiLegacyCharacterStateEntriesWithoutReliableSceneLinksTheir(
    String p1,
  ) {
    return '另有 $p1 筆舊 CharacterState 無法可靠連結 Scene，將保留原文字。';
  }

  @override
  String get uiApplyConversion => '套用轉換';

  @override
  String uiPossessionConversionFailed(String p1) {
    return '持有物轉換失敗：$p1';
  }

  @override
  String get uiCreateManagedItem => '建立正式物品';

  @override
  String get uiItemName => '物品名稱';

  @override
  String get uiItemMode => '物品模式';

  @override
  String get uiDedicatedIndependentID => '專用（建立獨立 ID）';

  @override
  String get uiSemiDedicatedOneInstanceInADefinition => '半專用（Class 內建立一件）';

  @override
  String get uiNonDedicatedKeepQuantity => '非專用（保留數量）';

  @override
  String get uiSelectACharacterRelatedItemToLink => '選擇要連結的人物物品';

  @override
  String get uiRelated => '相關';

  @override
  String get uiOther2 => '其他：';

  @override
  String get uiOther3 => '其他……';

  @override
  String get uiLookingForNewLove => '另尋新歡？';

  @override
  String get uiHaremStory => '后宮型作品？';

  @override
  String get uiCompactTimeline => '簡易時間軸';

  @override
  String get uiClickOrDragToSelectTimeDiamondsMark => '點擊或拖曳選擇時間 · 菱形表示既有快照';

  @override
  String get uiCouldNotLoadSecureCopilotSettingsTheAPI =>
      'Copilot 安全設定無法載入；API Key 未載入。';

  @override
  String uiModelsRetrieved(String p1) {
    return '已抓取 $p1 個模型。';
  }

  @override
  String uiAlongWith(String p1) {
    return '，以及$p1';
  }

  @override
  String get uiSendYourWorkSContent => '傳送作品內容？';

  @override
  String uiThisModeSendsTheCurrentChapterToData(
    String p1,
    String p2,
    String p3,
    String p4,
  ) {
    return '此模式會將目前章節「$p1」$p2傳送到 $p3。資料會直接送往你選擇的模型服務。另會附帶 App 內建的 .mnproj 結構說明（不含作品內容）。$p4';
  }

  @override
  String get uiYourConfiguredAPIKeyWillAlsoBeSent => '已設定的 API Key 也會一併傳送。';

  @override
  String get uiAllowThisConnection => '允許本次連線';

  @override
  String get uiSendAPIKey => '傳送 API Key？';

  @override
  String uiTheAPIKeyWillBeSentDirectlyTo(String p1) {
    return 'API Key 將直接傳送到 $p1。請確認這是你信任的模型服務。';
  }

  @override
  String get uiRequestCancelled => '已取消請求。';

  @override
  String get uiSelectOrEnterAModelFirst => '請先選擇或輸入使用模型。';

  @override
  String get uiSettingsChangedThePreviousRequestWasCancelled => '設定已變更，已取消舊請求。';

  @override
  String get uiSettingsChangedThePreviousRequestResultWasDiscarded =>
      '設定已變更，已取消舊請求結果。';

  @override
  String get uiNoAPIKeyIsSaved => '目前沒有已儲存的 API Key。';

  @override
  String get uiClearAPIKey => '清除 API Key？';

  @override
  String get uiThisRemovesTheAPIKeyFromThisDevice =>
      '這會從此裝置的安全儲存空間移除 API Key。作品與對話內容不會受影響。';

  @override
  String get uiClearKey => '清除 Key';

  @override
  String get uiAPIKeyRemovedFromThisDevice => 'API Key 已從此裝置移除。';

  @override
  String get uiCouldNotRemoveTheAPIKeyTryAgain => '無法從此裝置移除 API Key，請稍後再試。';

  @override
  String get uiAskPlanBetaAreControlledByFeatureFlags =>
      'Ask／Plan Beta 會讀取目前章節，不會修改專案；Agent 模式暫不可用。';

  @override
  String get uiModelSelection => '模型選擇';

  @override
  String get uiCustom => '自訂';

  @override
  String get uiProvider => '供應商';

  @override
  String get uiModel => '使用模型';

  @override
  String get uiSelectOrEnterAModelID => '選擇或輸入模型 ID';

  @override
  String get uiFetch => '抓取';

  @override
  String get uiHideAPIKey => '隱藏 API Key';

  @override
  String get uiShowAPIKey => '顯示 API Key';

  @override
  String get uiClearSavedKey => '清除已儲存 Key';

  @override
  String get uiPrivacyThirdPartyServicesAndLimitations => '隱私、第三方服務與已知限制';

  @override
  String get uiChatSendsYourMessagesAskPlanAlsoSend =>
      'Chat 會傳送你輸入的訊息；Ask／Plan 另會傳送畫面標示的作品上下文。資料直接送往你設定的 provider 與 API URL，不經 Monogatari Assistant 伺服器。';

  @override
  String get uiWhetherAProviderStoresOrUsesDataDepends =>
      '第三方 provider 是否保存或使用資料，依該服務的條款與帳號設定決定。localhost Ollama 可留在本機，但其他自訂 URL 不一定私密。';

  @override
  String get uiConversationsAndPlansExistOnlyForThisScreen =>
      '對話與 Plan 目前只保留在本次畫面工作階段，不會寫入專案，也不會跨啟動還原。';

  @override
  String get uiAIResponsesMayBeIncorrectPlansAreFor =>
      'AI 回覆可能不正確。Plan 僅供檢視與匯出，不會自動修改作品；Agent 模式目前停用。';

  @override
  String get uiConversationHistory => '對話紀錄';

  @override
  String get uiClearAll => '清空';

  @override
  String get uiNoConversations => '尚無對話紀錄';

  @override
  String get uiMessagesWillAppearHereAfterYouSendThem => '送出訊息後會顯示在這裡';

  @override
  String get uiYou => '你';

  @override
  String get uiTheModelSuppliedNoVerifiableStructuredSources =>
      '模型未提供可驗證的結構化來源。';

  @override
  String uiCouldNotValidateThePlanTheOriginalResponse(String p1) {
    return '無法驗證 Plan：$p1\n已保留模型原始回覆，未套用任何變更。';
  }

  @override
  String get uiTheModelSuppliedNoVerifiableSources => '模型未提供可驗證來源。';

  @override
  String get uiSources => '來源';

  @override
  String uiUncertain(String p1) {
    return '不確定：$p1';
  }

  @override
  String get uiInvalidSourcesSuppliedByTheModelWereIgnored => '已忽略模型提供的無效來源。';

  @override
  String uiOpenSource(String p1) {
    return '開啟來源：$p1';
  }

  @override
  String get uiPlanJSONCopied => '已複製 Plan JSON。';

  @override
  String get uiPlanJSONExported => 'Plan JSON 匯出完成。';

  @override
  String get uiCouldNotExportThePlanJSONCheckThe =>
      'Plan JSON 匯出失敗，請確認儲存位置與檔案權限。';

  @override
  String get uiCopyPlanJSON => '複製 Plan JSON';

  @override
  String get uiExportPlanJSON => '匯出 Plan JSON';

  @override
  String get uiTheCurrentChapterChangedThisPlanMayBe => '目前章節已變更，這份計畫可能已過期。';

  @override
  String uiRisk(String p1) {
    return '風險：$p1';
  }

  @override
  String uiToConfirm(String p1) {
    return '待確認：$p1';
  }

  @override
  String get uiReadOnlyPlanNoChangesApplied => '唯讀計畫・尚未套用任何變更';

  @override
  String get uiCurrentChapter => '目前章節';

  @override
  String get uiCurrentChapterAndProjectIndexSummary => '目前章節與專案索引摘要';

  @override
  String get uiCurrentChapterAndSelectedSupplementalResources => '目前章節與勾選的補充資源';

  @override
  String uiSendsDirectlyToYourConfiguredModelServiceWithout(
    String p1,
    String p2,
  ) {
    return '$p1 會把$p2直接傳送到你設定的模型服務；不會修改專案。';
  }

  @override
  String uiSelectSupplementalResources(String p1, String p2) {
    return '選擇補充資源（$p1/$p2）';
  }

  @override
  String get uiEnterAMessageShiftEnterForANew => '輸入訊息，Shift+Enter 換行，Enter 發送';

  @override
  String get uiAskAboutTheCurrentChapter => '詢問目前章節內容';

  @override
  String get uiDescribeTheChangesYouWantToPlan => '描述希望規劃的修改目標';

  @override
  String get uiAgentIsUnavailable => 'Agent 模式暫不可用';

  @override
  String get uiCancelRequest => '取消請求';

  @override
  String get uiSend => '發送';

  @override
  String get uiShiftEnterNewLineEnterSend => 'Shift+Enter 換行、Enter 發送';

  @override
  String get uiModeSelection => '模式選擇';

  @override
  String get uiAgentUnavailable => 'Agent (暫不可用)';

  @override
  String get uiAskContext => 'Ask 上下文';

  @override
  String get uiCurrentChapterProjectSummary => '目前章節＋專案摘要';

  @override
  String get uiCurrentChapterSelectedResources => '目前章節＋選取資源';

  @override
  String get uiSelectAskSupplementalResources => '選擇 Ask 補充資源';

  @override
  String get uiSearchCharactersWorldbuildingOutlinesOrWords => '搜尋角色、世界觀、大綱或詞語';

  @override
  String uiSelectedOnlySelectedResourcesAreSent(String p1, String p2) {
    return '已選 $p1/$p2；只會傳送勾選項目的內容。';
  }

  @override
  String get uiNoMatchingResources => '沒有符合的資源。';

  @override
  String get uiClear => '清除';

  @override
  String get uiUseSelection => '使用選取項目';

  @override
  String get uiTruncated => '，已截斷';

  @override
  String get uiProjectIndexSummaryUpToKiB => '＋專案索引摘要（上限 24 KiB）';

  @override
  String uiSelectedResourcesUpToKiB(String p1) {
    return '＋已選 $p1 個補充資源（上限 32 KiB）';
  }

  @override
  String uiContextBytes(String p1, String p2, String p3, String p4) {
    return '上下文：$p1（$p2 bytes$p3）$p4';
  }

  @override
  String get uiContextNoChapterSelected => '上下文：尚未選擇章節';

  @override
  String get uiUnknownCategory => '未知類別';

  @override
  String get uiExportWordReference => '匯出詞語';

  @override
  String get uiExportFailedCouldNotWriteTheFile => '匯出失敗：無法寫入檔案';

  @override
  String uiExportComplete2(String p1, String p2) {
    return '匯出完成：$p1\n$p2';
  }

  @override
  String get uiEmptyEntry => '(空白詞條)';

  @override
  String get uiUnnamedCategory => '(未命名分類)';

  @override
  String get uiImportPreview => '匯入預覽';

  @override
  String uiCategoriesToAdd(String p1) {
    return '將新增分類：$p1';
  }

  @override
  String uiCategoriesToMerge(String p1) {
    return '將合併到既有分類：$p1';
  }

  @override
  String uiNewEntriesToImport(String p1) {
    return '將匯入新詞條：$p1';
  }

  @override
  String uiExistingEntriesToReuse(String p1) {
    return '將重用既有詞條：$p1';
  }

  @override
  String uiCategoryEntryLinksToAdd(String p1) {
    return '將新增分類條目連結：$p1';
  }

  @override
  String get uiNewCategoriesUpToShown => '新增分類（最多顯示 6 筆）';

  @override
  String get uiNewEntriesUpToShown => '新增詞條（最多顯示 6 筆）';

  @override
  String get uiConfirmImport => '確認匯入';

  @override
  String get uiInvalidImportFileFormat => '匯入檔案格式錯誤';

  @override
  String uiImportCompleteNewCategoriesNewEntriesReusedEntries(
    String p1,
    String p2,
    String p3,
    String p4,
  ) {
    return '匯入完成：新增類別 $p1、匯入新詞條 $p2、重用既有詞條 $p3、連結詞條 $p4';
  }

  @override
  String get uiAddCategory => '新增分類';

  @override
  String get uiAddSubcategory => '新增子分類';

  @override
  String get uiEnterACategoryName => '輸入分類名稱';

  @override
  String get uiDeleteCategory => '刪除分類';

  @override
  String uiDeleteAndItsSubcategories(String p1) {
    return '確定要刪除「$p1」及其子分類嗎？';
  }

  @override
  String get uiRemoveEntry => '移除詞條';

  @override
  String uiRemoveFrom(String p1, String p2) {
    return '確定要從「$p1」移除「$p2」嗎？';
  }

  @override
  String uiGroup(String p1) {
    return '第 $p1 組';
  }

  @override
  String get uiDeleteThisGroup => '刪除此組';

  @override
  String get uiMeaning => '意義';

  @override
  String get uiExample => '例句';

  @override
  String get uiThisFeatureIsInDevelopmentAndMayContain => '本功能正在開發中，使用時可能出現錯誤。';

  @override
  String get uiWordCategories => '詞語類別';

  @override
  String get uiAddRootCategory => '新增根分類';

  @override
  String get uiImportExport => '匯入匯出';

  @override
  String get uiImport2 => '匯入…';

  @override
  String get uiExportDisabled => '匯出……（已禁用）';

  @override
  String get uiExportSelectedCategory => '匯出選取類別';

  @override
  String get uiExportAll => '匯出全部';

  @override
  String get uiLongPressCardsToDragReorderOrMove => '長按卡片可拖曳，支援排序與改為子目錄。';

  @override
  String get uiNoWordCategories => '尚無詞語類別';

  @override
  String get uiAddYourFirstCategory => '請新增第一個分類';

  @override
  String get uiUnnamedCategory2 => '（未命名分類）';

  @override
  String uiEntries(String p1) {
    return '共 $p1 條';
  }

  @override
  String get uiCategoryActions => '分類操作';

  @override
  String get uiCollapseSubcategories => '收合子分類';

  @override
  String get uiExpandSubcategories => '展開子分類';

  @override
  String get uiRename => '重命名';

  @override
  String get uiMoveBefore => '移動到前方';

  @override
  String get uiMoveToSubcategory => '移動到子目錄';

  @override
  String get uiMoveAfter => '移動到後方';

  @override
  String uiLiteral2(String p1, String p2) {
    return '「$p1」已$p2';
  }

  @override
  String uiMovedInto(String p1, String p2) {
    return '「$p1」已移到「$p2」';
  }

  @override
  String get uiWordEntries => '詞語條目';

  @override
  String get uiSelectAWordCategoryFirst => '請先選擇詞語類別';

  @override
  String get uiLongPressEntriesToDragReorderOrMove => '詞條可長按拖曳，支援排序與移動到其他分類。';

  @override
  String get uiThisCategoryHasNoEntries => '此類別目前沒有詞條';

  @override
  String get uiAddYourFirstEntry => '請新增第一個詞條';

  @override
  String get uiEntryName => '詞條名稱';

  @override
  String get uiNoMeaningEnteredYet => '尚未填寫意義';

  @override
  String uiPartOfSpeech(String p1) {
    return '詞性：$p1';
  }

  @override
  String get uiSourceThisCategory => '來源：本目錄';

  @override
  String uiSourceSubcategory(String p1) {
    return '來源：子目錄 $p1';
  }

  @override
  String get uiRemoveFromThisCategory => '從此分類移除';

  @override
  String uiMovedTo(String p1, String p2) {
    return '「$p1」已移動到「$p2」';
  }

  @override
  String get uiMeaningsAndExamples => '詞語解釋、例句';

  @override
  String get uiSelectAnEntryAbove => '請從上方選擇一個詞條。';

  @override
  String get uiPartOfSpeech2 => '詞性';

  @override
  String get uiCustomPartOfSpeech => '自訂詞性';

  @override
  String get uiSentiment => '情感傾向';

  @override
  String get uiMeaningAndExampleGroups => '意義 + 例句組';

  @override
  String get uiAddGroup => '新增一組';

  @override
  String get uiCouldNotLoadWordData => '讀取詞語資料失敗';

  @override
  String get uiWordReference => '詞語參考';

  @override
  String get uiNewItem => '新物品';

  @override
  String get uiArchiveItem => '封存物品';

  @override
  String uiArchiveExistingLinksAndHistoricalSnapshotsWillBe(
    String p1,
    String p2,
  ) {
    return '要封存「$p1」嗎？現有關聯與歷史快照會保留，$p2 件單件物品會一併封存。';
  }

  @override
  String get uiUnnamedItem => '未命名物品';

  @override
  String get uiArchive => '封存';

  @override
  String uiIndividual(String p1) {
    return '$p1（單件）';
  }

  @override
  String get uiTheItemOrSceneChangedReopenThePreview =>
      '物品或 Scene 已更新，請重新開啟預覽後再提交。';

  @override
  String get uiCreateACharacterLocationOrEventBeforeAdding =>
      '請先建立人物、地點或事件，再新增物品關聯。';

  @override
  String get uiAddItemLink => '新增物品關聯';

  @override
  String uiIndividual2(String p1) {
    return '單件：$p1';
  }

  @override
  String get uiChooseLinkTarget => '選擇連結目標';

  @override
  String get uiRelationshipPurpose => '關係／用途';

  @override
  String get uiAddLink => '新增關聯';

  @override
  String get uiCreateACharacterOrLocationBeforeAddingA => '請先建立人物或地點，再新增數量分配。';

  @override
  String get uiAddQuantityAllocation => '新增數量分配';

  @override
  String get uiAllocateTo => '分配對象';

  @override
  String get uiAddAllocation => '新增分配';

  @override
  String get uiQuantityMustBeZeroOrAPositiveInteger2 => '數量必須是零或正整數，也可以留空表示未知。';

  @override
  String get uiATransferRequiresAtLeastOneSceneAnd => '轉移前需要至少一個場景及另一個人物或地點。';

  @override
  String get uiTransferAggregateQuantity => '轉移聚合數量';

  @override
  String get uiTransferTo => '轉移至';

  @override
  String get uiQuantityToTransfer => '轉移數量';

  @override
  String get uiSourceQuantityAfterTransfer => '轉移後來源數量';

  @override
  String get uiSourceQuantityIsUnknownSetItExplicitly => '來源數量未知，必須明確設定';

  @override
  String get uiDestinationQuantityAfterTransfer => '轉移後目的數量';

  @override
  String get uiDestinationQuantityIsUnknownSetItExplicitly => '目的數量未知，必須明確設定';

  @override
  String get uiCreateTransferSnapshot => '建立轉移快照';

  @override
  String get uiAddTheSceneToTheTimelineBeforeSeparating =>
      '請先將 Scene 放入時間軸，再拆出單件物品。';

  @override
  String get uiCreateDedicatedItem => '建立專用單件';

  @override
  String get uiSeparateItemFromAggregateQuantity => '從聚合數量拆出單件';

  @override
  String get uiCreatedInScene => '建立於 Scene';

  @override
  String get uiThisAggregateAllocationDoesNotExistInThe => '所選 Scene 尚無這筆聚合分配。';

  @override
  String get uiSourceQuantityIsUnknownInTheSelectedScene => '所選 Scene 的來源數量未知。';

  @override
  String uiSourceQuantityInSelectedScene(String p1) {
    return '所選 Scene 的來源數量：$p1';
  }

  @override
  String get uiIndividualItemName => '單件名稱';

  @override
  String get uiSourceQuantityAfterSeparation => '拆出後來源數量';

  @override
  String get uiConversionNotes => '轉換備註';

  @override
  String get uiCreateIndividualItem => '建立單件';

  @override
  String get uiCreatedAnIndividualItemFromTheAggregateQuantity =>
      '已從聚合數量建立單件物品。';

  @override
  String get uiAddTheSceneToTheTimelineBeforeConverting =>
      '請先將 Scene 放入時間軸，再轉為非專用。';

  @override
  String get uiSafelyConvertToNonDedicated => '安全轉為非專用';

  @override
  String get uiConversionScene => '轉換 Scene';

  @override
  String uiAggregateExistingIndividualItemsIntoQuantityAllocations(
    String p1,
    String p2,
  ) {
    return '將彙總 $p1 件當時存在的單件，建立 $p2 筆聚合分配。';
  }

  @override
  String get uiTheOriginalClassInstanceIDsSnapshotsAndGeneral =>
      '原 Class、instance ID、快照與一般關聯會保留為封存歷史。';

  @override
  String get uiCreateAggregateClass => '建立聚合 Class';

  @override
  String get uiCreatedANewNonDedicatedAggregateClass => '已建立新的非專用聚合 Class。';

  @override
  String get uiConvertingToDedicatedModeRequiresOneAllocationWith =>
      '轉為專用前只能剩下一筆、數量為 1 的聚合分配；可先轉為半專用逐件拆分。';

  @override
  String get uiMultipleFixedIDsCannotBeMergedDirectlyInto =>
      '目前有多個固定 ID，不能直接合併為一件專用物品。';

  @override
  String get uiSeparateAllRemainingAggregateQuantitiesBeforeConvertingTo =>
      '仍有未拆分的聚合數量，請先逐件拆分後再轉為專用。';

  @override
  String get uiMoveWorldbuildingItems => '搬移世界設定物品';

  @override
  String uiMoveWorldbuildingItemsToTheItemsPageIDs(String p1) {
    return '將 $p1 筆世界設定物品搬到獨立物品頁。原物品 ID、內容與來源路徑會保留。';
  }

  @override
  String get uiMove => '搬移';

  @override
  String uiMovedItems(String p1, String p2) {
    return '已搬移 $p1 筆物品$p2';
  }

  @override
  String uiNeedAttention(String p1) {
    return '，$p1 筆需留意';
  }

  @override
  String get uiAddTheSceneToTheTimelineBeforeAdding =>
      '請先將 Scene 放入時間軸，再新增物品快照。';

  @override
  String get uiAddItemSceneSnapshot => '新增物品場景快照';

  @override
  String get uiDuplicateItemSceneSnapshot => '複製物品場景快照';

  @override
  String get uiExistsAtThisPoint => '此時已存在';

  @override
  String get uiHolder => '持有人';

  @override
  String uiNotFound(String p1) {
    return '找不到：$p1';
  }

  @override
  String get uiLocation2 => '所在地';

  @override
  String get uiAddTheSceneToTheTimelineBeforeAdding2 =>
      '請先將 Scene 放入時間軸，再新增單件物品快照。';

  @override
  String uiSceneSnapshot(String p1, String p2) {
    return '$p1「$p2」場景快照';
  }

  @override
  String get uiItemSettings => '物品設定';

  @override
  String uiMoveItemsFromWorldbuilding(String p1) {
    return '搬移世界設定中的 $p1 筆物品';
  }

  @override
  String get uiAddItem => '新增物品';

  @override
  String get uiSelectAnItemFirst => '請先選取物品';

  @override
  String get uiSelectAnItemToPreviewItsTimelineAnd => '選取物品後即可預覽時間軸與管理快照';

  @override
  String get uiItemList => '物品清單';

  @override
  String get uiSearchItems => '搜尋物品';

  @override
  String get uiManagementMode => '管理模式';

  @override
  String get uiOwnership => '歸屬';

  @override
  String get uiAssigned => '已有歸屬';

  @override
  String get uiUnassigned => '尚無歸屬';

  @override
  String get uiCategory => '分類';

  @override
  String get uiAllCategories => '全部分類';

  @override
  String get uiNoItemsYet => '尚無物品';

  @override
  String get uiAddYourFirstItem => '新增第一個物品';

  @override
  String uiIndividualItemsLinks(String p1, String p2, String p3, String p4) {
    return '$p1 · $p2 件單件 · $p3 個關聯$p4';
  }

  @override
  String get uiAssigned2 => ' · 已有歸屬';

  @override
  String get uiEditItem => '編輯物品';

  @override
  String get uiItemDetails => '物品詳情';

  @override
  String get uiSelectOrAddAnItem => '選擇或新增物品';

  @override
  String get uiItemModeSnapshotsOwnershipAndLinksAppearHere =>
      '物品的模式、快照、歸屬與關聯會顯示在這裡';

  @override
  String get uiDeleteCurrentSnapshot => '刪除目前快照';

  @override
  String get uiNoSnapshotSelected => '尚未選取快照';

  @override
  String get uiCurrentStoryState => '目前故事狀態';

  @override
  String get uiNoSnapshots => '無快照';

  @override
  String get uiExists => '存在';

  @override
  String get uiDoesNotExistYet => '尚未存在';

  @override
  String get uiStateNotSet => '未設定狀態';

  @override
  String uiHolder2(String p1) {
    return '持有人：$p1';
  }

  @override
  String uiLocation3(String p1) {
    return '所在地：$p1';
  }

  @override
  String uiSnapshotHistory(String p1) {
    return '快照歷程（$p1）';
  }

  @override
  String get uiLinkThisScene => '連結此 Scene';

  @override
  String get uiRemoveSnapshot => '移除快照';

  @override
  String get uiDoesNotExistInThisScene => '此場景尚未存在';

  @override
  String get uiExistsInThisScene => '此場景存在';

  @override
  String get uiName2 => '名稱';

  @override
  String get uiQuantityUnit => '數量單位';

  @override
  String get uiDescription => '設定說明';

  @override
  String get uiIndividualItems => '單件物品';

  @override
  String get uiAddIndividualItem => '新增單件';

  @override
  String get uiNoIndividualItemsCreatedYet => '尚未建立單件物品。';

  @override
  String get uiLinks => '關聯';

  @override
  String get uiNoCharactersLocationsOrEventsLinkedYet => '尚未連結人物、地點或事件。';

  @override
  String get uiRemoveLink => '移除關聯';

  @override
  String get uiNonDedicatedModeUsesClassesAndAggregateAllocations =>
      '非專用模式以 Class 與聚合分配管理，不建立單件 ID。';

  @override
  String get uiSemiDedicatedModeKeepsUnidentifiedAggregateQuantitiesAnd =>
      '半專用模式保留尚未識別的聚合數量，並可在 Scene 中逐件拆出固定 ID。';

  @override
  String get uiThisSectionShowsHistoricalAggregateQuantitiesFromBefore =>
      '此區顯示轉為專用前的歷史聚合數量。';

  @override
  String uiAllocatedQuantity(String p1, String p2, String p3) {
    return '數量分配：$p1$p2$p3';
  }

  @override
  String get uiPlusAnUnknownQuantity => '，另有未知數量';

  @override
  String get uiNoQuantityAllocatedYet => '尚未分配數量。';

  @override
  String get uiAllocationTargetNotFound => '找不到分配對象';

  @override
  String get uiUnallocated => '未分配';

  @override
  String get uiUnknownQuantity => '數量未知';

  @override
  String get uiSeparateIndividualItem => '拆出單件物品';

  @override
  String get uiRemoveDefaultAllocation => '移除預設分配';

  @override
  String get uiOutline => '大綱調整';

  @override
  String get uiStorylines => '大箱（故事線）';

  @override
  String get uiNoStorylinesYet => '暫無故事線';

  @override
  String get uiStorylineName => '故事線名稱';

  @override
  String get uiStorylineTheBroadDirectionOfYourStoryUse =>
      '大箱：故事的大致走向。標記可以使用「三幕劇」、「起承轉合」、「故事七步驟」等結構';

  @override
  String get uiUntitledStoryline => '(未命名故事線)';

  @override
  String get uiUntitledEvent => '(未命名事件)';

  @override
  String get uiUntitledScene => '(未命名場景)';

  @override
  String get uiStorylineDetails => '大箱內容（故事線細節）';

  @override
  String get uiTypeEGOpeningMiddleClimaxEnding => '類型 (如：開頭、中段、高潮、結尾)';

  @override
  String get uiMainConflict => '主要衝突';

  @override
  String get uiEnterNotes => '輸入備註...';

  @override
  String get uiEvents => '中箱（事件）';

  @override
  String get uiNoEventsInThisStorylineYet => '此故事線暫無事件';

  @override
  String get uiEventName => '事件名稱';

  @override
  String get uiSelectAStorylineFirst => '請先選擇故事線';

  @override
  String get uiSelectAStorylineToAddAndEditEvents => '選擇故事線後即可新增與編輯事件';

  @override
  String get uiEventASpecificOccurrenceInTheStory => '中箱：具體發生的事件。';

  @override
  String get uiTypeNotSet => '未設定類型';

  @override
  String get uiDeleteStoryline => '刪除故事線';

  @override
  String uiEventMovedTo(String p1) {
    return '事件已移動到「$p1」';
  }

  @override
  String uiScenes(String p1) {
    return '$p1 個場景';
  }

  @override
  String get uiDeleteEvent => '刪除事件';

  @override
  String get uiEventDetails => '中箱內容（事件細節）';

  @override
  String get uiPointOfConflict => '衝突點';

  @override
  String get uiDefaultCharacters => '預設人物';

  @override
  String get uiItemAllocations => '物品分配';

  @override
  String get uiNoTrackedItemsAllocatedYet => '尚未分配正式物品。';

  @override
  String get uiItemClass => '物品 Class';

  @override
  String get uiChooseAnEventItemToLink => '選擇要連結的事件物品';

  @override
  String get uiOutlineObjects => '大綱物件';

  @override
  String get uiTheseAreLegacyTextObjectsConvertThemTo =>
      '以下是舊版文字物件。請轉換為正式物品；大綱已不再新增舊格式物件。';

  @override
  String get uiRemoveAllocation => '移除分配';

  @override
  String get uiChooseAnItemToAllocateToTheScene => '選擇要分配給場景的物品';

  @override
  String get uiAfterConversionThisLegacyTextIsReplacedWith =>
      '轉換成功後會移除這筆舊文字，改用可追蹤的正式物品 ID 關聯。';

  @override
  String get uiCreateAndLink => '建立並連結';

  @override
  String uiChooseTheItemFor(String p1) {
    return '選擇「$p1」對應的物品';
  }

  @override
  String get uiConvertedToATrackedItemLink => '已轉為正式物品關聯。';

  @override
  String get uiNonDedicatedClassOnly => '非專用（只建立 Class）';

  @override
  String uiConvertedFromLegacyText(String p1) {
    return '由舊文字「$p1」轉換';
  }

  @override
  String get uiScenes2 => '小箱（場景）';

  @override
  String get uiNoScenesYet => '暫無場景';

  @override
  String get uiSceneName2 => '場景名稱';

  @override
  String get uiSelectAnEventFirst => '請先選擇一個事件';

  @override
  String get uiSelectAnEventToAddAndEditScenes => '選擇事件後即可新增與編輯場景';

  @override
  String get uiSceneADetailedSceneWithinAnEvent => '小箱：事件的詳細場景。';

  @override
  String get uiDeleteScene => '刪除場景';

  @override
  String get uiSceneDetails => '小箱內容（場景細節）';

  @override
  String get uiTime => '時間';

  @override
  String get uiFocus => '聚焦點';

  @override
  String get uiAction => '行動';

  @override
  String uiStoryline2(String p1) {
    return '故事線 $p1';
  }

  @override
  String uiEvent3(String p1) {
    return '事件 $p1';
  }

  @override
  String uiScene(String p1) {
    return '場景 $p1';
  }

  @override
  String uiSkippedOrRepairedPaletteDataIssues(String p1) {
    return '已略過或修復 $p1 項調色盤資料問題。';
  }

  @override
  String uiCouldNotReadPaletteData(String p1) {
    return '調色盤資料無法讀取：$p1';
  }

  @override
  String uiDeleted(String p1) {
    return '已刪除「$p1」';
  }

  @override
  String get uiExportTextPalette => '匯出文字色票';

  @override
  String uiPaletteExported(String p1) {
    return '色票匯出完成：$p1';
  }

  @override
  String uiPaletteExportFailed(String p1) {
    return '色票匯出失敗：$p1';
  }

  @override
  String get uiImportTextPalette => '匯入文字色票';

  @override
  String uiWithFormatIssuesSkipped(String p1) {
    return '，另略過 $p1 項格式問題';
  }

  @override
  String uiImportedPaletteEntriesSkippedDuplicates(
    String p1,
    String p2,
    String p3,
  ) {
    return '匯入完成：新增 $p1 個色票詞條、略過 $p2 個重複詞條$p3';
  }

  @override
  String get uiPaletteImportFailedInvalidFormatOrUnreadableFile =>
      '色票匯入失敗：檔案格式錯誤或無法讀取';

  @override
  String get uiCouldNotLoadPalettes => '調色盤載入失敗';

  @override
  String get uiNotSavedToDiskYet => '尚未寫入磁碟';

  @override
  String get uiTextPalettes => '文字色票';

  @override
  String get uiSearchEntries => '搜尋詞條……';

  @override
  String get uiImportOrExportPalettes => '匯入或匯出色票';

  @override
  String get uiImportPalette => '匯入色票……';

  @override
  String get uiExportPalette => '匯出色票……';

  @override
  String get uiGrayscale => '灰階';

  @override
  String uiHueSaturationBrightness(String p1) {
    return '色相 $p1°，飽和度 80%，明度 100%';
  }

  @override
  String uiEntries2(String p1, String p2) {
    return '$p1，$p2 個詞條';
  }

  @override
  String uiEntries3(String p1) {
    return '$p1 個詞條';
  }

  @override
  String get uiColorCellActions => '色格操作';

  @override
  String get uiSortByText => '依文字排序';

  @override
  String uiEdit2(String p1) {
    return '編輯「$p1」';
  }

  @override
  String get uiAddEntry => '新增詞條';

  @override
  String get uiEnterATerm => '輸入詞條';

  @override
  String uiNoEntriesContaining(String p1) {
    return '找不到包含「$p1」的詞條';
  }

  @override
  String get uiForeshadowingList => '伏筆列表';

  @override
  String get uiNoForeshadowingYet => '尚無伏筆';

  @override
  String get uiAddYourFirstEntry2 => '請新增第一個項目';

  @override
  String get uiAddForeshadowing => '新增伏筆';

  @override
  String get uiSelectAForeshadowingEntry => '請選擇一個伏筆';

  @override
  String get uiSelectAnEntryToEditItsContent => '選取後即可編輯內容';

  @override
  String get uiForeshadowingName => '伏筆名稱';

  @override
  String get uiRevealed => '已揭露';

  @override
  String get uiReleasePlans => '更新計畫';

  @override
  String get uiNoReleasePlansYet => '尚無更新計畫';

  @override
  String get uiAddReleasePlan => '新增更新計畫';

  @override
  String get uiSelectAReleasePlan => '請選擇一個更新計畫';

  @override
  String get uiPlanName => '計畫名稱';

  @override
  String get uiCompleted => '已完成';

  @override
  String get uiIdeaList => '靈感列表';

  @override
  String get uiNoIdeasYet => '尚無靈感';

  @override
  String get uiAddAFolderOrIdea => '請新增資料夾或靈感';

  @override
  String get uiExpand => '展開';

  @override
  String get uiFolder2 => '資料夾';

  @override
  String get uiIdea => '靈感';

  @override
  String get uiSelectAnIdea => '請選擇一則靈感';

  @override
  String get uiIdeaTitle => '靈感標題';

  @override
  String get uiIdeaNotes => '靈感筆記';

  @override
  String get uiPlanning => '計畫規劃';

  @override
  String uiCouldNotLoadTheFillerWordDictionary(String p1) {
    return '無法載入贅字詞庫：$p1';
  }

  @override
  String get uiProofreading => '文本校正';

  @override
  String get uiCheckYourTextHere => '此處可協助執行文本檢查。';

  @override
  String uiCurrentTextLengthCharacters(String p1) {
    return '當前文本長度：$p1 字元';
  }

  @override
  String get uiLoadingFillerWordDictionary => '載入贅字詞庫中';

  @override
  String uiFillerWordDictionaryLoadedEntries(String p1) {
    return '贅字詞庫已載入 $p1 筆';
  }

  @override
  String get uiQuoteAndBracketMatching => '引號、括號閉合檢查';

  @override
  String uiTooManyResultsOnlyInitialSamplesAreShown(String p1) {
    return '結果數量過多，目前只保留各檢測的前段樣本；完整統計共 $p1 筆。';
  }

  @override
  String get uiPunctuationAnomalies => '標點異常檢測';

  @override
  String get uiLineEndingCheck => '行尾辨識';

  @override
  String get uiPunctuationConsistency => '標點符號格式統一';

  @override
  String get uiFillerWordCheck => '贅字檢查';

  @override
  String get uiFillerWordRatio => '贅字率計算';

  @override
  String get uiCheckSettings => '檢測設定';

  @override
  String uiShowMoreRemaining(String p1) {
    return '顯示更多（剩餘 $p1）';
  }

  @override
  String get uiCheckPairedAndUnclosedDelimiters => '檢查配對與閉合狀態';

  @override
  String get uiCheckRepeatedPunctuationAndQuoteNesting => '檢查連續標點與引號層級';

  @override
  String get uiFindPunctuationThatCanBeStandardized => '檢查可統一的標點替換';

  @override
  String get uiFindFillerWordsListedInTheDictionary => '檢查詞庫中的贅字出現位置';

  @override
  String get uiCheckLineEndingsAgainstTheRules => '檢查行尾符號是否符合規則';

  @override
  String get uiLineEndingOptions => '行尾辨識細項';

  @override
  String get uiIgnoreCommasAtLineEnd => '行尾逗號不提示';

  @override
  String get uiDoNotFlagLinesEndingInOr => '行尾為 , 或 ，時不顯示提示';

  @override
  String get uiIgnoreDashesAtLineEnd => '行尾破折號不提示';

  @override
  String get uiDoNotFlagLinesEndingInOr2 => '行尾為 — 或 - 時不顯示提示';

  @override
  String get uiIgnoreEllipsesAtLineEnd => '行尾刪節號不提示';

  @override
  String get uiDoNotFlagLinesEndingInOr3 => '行尾為 … / …… 時不顯示提示';

  @override
  String get uiIgnoreColonsAtLineEnd => '行尾冒號不提示';

  @override
  String get uiDoNotFlagLinesEndingInOr4 => '行尾為 : 或 ：時不顯示提示';

  @override
  String get uiIgnoreSemicolonsAtLineEnd => '行尾分號不提示';

  @override
  String get uiDoNotFlagLinesEndingIn => '行尾為；時不顯示提示';

  @override
  String get uiFormatOptions => '格式選項';

  @override
  String get uiPunctuationStyle => '標點符號檢查格式';

  @override
  String get uiChooseAStyle => '請選擇格式';

  @override
  String uiCurrentStyle(String p1) {
    return '目前格式：$p1';
  }

  @override
  String get uiDetectLatinScriptSentences => '拉丁文句檢測';

  @override
  String get uiAutomaticallyUseLatinPunctuationWhenLatinTextIs =>
      '偵測到拉丁文字時，自動套用拉丁標點';

  @override
  String get uiLatinScriptDetectionOptions => '拉丁字母辨識細項';

  @override
  String get uiAllowCJKQuotesBracketsAtWordEnd => '允許字尾使用 CJK 引號/括號';

  @override
  String get uiAllowCJKQuotesAndBracketsAfterLatinText => '拉丁字尾可接受 CJK 引號與括號';

  @override
  String get uiAllowCJKExclamationQuestionMarksAtWordEnd => '允許字尾使用 CJK 驚嘆號/問號';

  @override
  String get uiAllowAndAfterLatinText => '拉丁字尾可接受 ！與 ？';

  @override
  String get uiAllowCJKPunctuationAroundCJKText => '允許在 CJK 文字前後加入 CJK 標點';

  @override
  String get uiDoNotTreatCJKPunctuationAsLatinContinuation =>
      '若任一側語境為行首/CJK/行尾，CJK 標點不視為拉丁延伸';

  @override
  String get uiThisCheckIsDisabled => '此檢測已關閉。';

  @override
  String get uiEnterSomeTextFirst => '請先輸入文本。';

  @override
  String get uiNoUnclosedDelimitersFound => '未發現閉合問題。';

  @override
  String get uiNoCheckRunYet => '尚未執行檢查。';

  @override
  String get uiPunctuationIsConsistentNoChangesNeeded => '格式已一致，無需調整。';

  @override
  String uiFoundPunctuationMarksThatCanBeStandardized(String p1) {
    return '共偵測到 $p1 處可統一的標點。';
  }

  @override
  String get uiResolveAll => '全部解決';

  @override
  String get uiNoPunctuationAnomaliesFound => '未發現標點符號異常。';

  @override
  String uiSuggestion(String p1) {
    return '建議：$p1';
  }

  @override
  String get uiNoLineEndingIssuesFound => '未發現行尾異常。';

  @override
  String get uiNoDictionaryFillerWordsFound => '未偵測到詞庫中的贅字。';

  @override
  String get uiClickAFillerWordBelowToExpandIts => '點擊下列贅字展開位置列表。';

  @override
  String uiOccurrences(String p1) {
    return '出現 $p1 次';
  }

  @override
  String uiShowingOnlyTheFirstLocations(String p1) {
    return '僅顯示前 $p1 個位置。';
  }

  @override
  String uiTotalFillerWordOccurrences(String p1) {
    return '贅字總次數：$p1';
  }

  @override
  String uiEffectiveWordCount(String p1) {
    return '有效字數：$p1';
  }

  @override
  String uiFillerWordRatio2(String p1) {
    return '贅字率：$p1%';
  }

  @override
  String get uiAllowUnrestrictedBatteryUsageInTheSystemPrompt =>
      '請在系統提示中允許不受電池最佳化限制。';

  @override
  String get uiCouldNotOpenBackgroundExecutionPermissions => '無法開啟背景執行權限。';

  @override
  String get uiMCPHostConfigurationCopiedPasteItIntoYour =>
      '已複製 MCP Host 設定。請貼到 Host 的 MCP 設定中。';

  @override
  String get uiAppearanceAndInterface => '外觀與介面';

  @override
  String get uiThemeNavigationToolbarAndFonts => '主題、導覽、工具列與字體';

  @override
  String get uiCustomizeToolbarItems => '工具列項目編輯';

  @override
  String get uiEditingAndInput => '編輯與輸入';

  @override
  String get uiSmartSuggestionsOverwriteIndentationAndWordCount =>
      '智慧候選、覆寫、縮排與字數統計';

  @override
  String get uiWritingGoals => '寫作目標';

  @override
  String get uiDailyProgressAndDefaultChapterAndProjectGoals =>
      '每日進度與每章、全文預設目標';

  @override
  String get uiSavingAndBackups => '儲存與備份';

  @override
  String get uiAutosaveBackupScheduleAndStorageLimits => '自動儲存、備份排程與容量';

  @override
  String get uiSyncAndConnections => '同步與連線';

  @override
  String get uiDevicePairingPersistentAuthenticationAndBackgroundExecution =>
      '裝置配對、持久驗證與背景執行';

  @override
  String get uiExternalIntegrations => '外部整合';

  @override
  String get uiReadOnlyMCPProjectAccessAndAuthorization => 'MCP 專案唯讀存取與授權';

  @override
  String get uiEnablePoppinIntelliSense => '啟用 Poppin IntelliSense';

  @override
  String get uiShowSuggestionsNearTheCursorWhenEnteringA =>
      '輸入標記類型、/ 或 \\ 時顯示游標旁候選清單';

  @override
  String get uiEnableOverwriteMode => '啟用覆寫模式';

  @override
  String get uiUseInsOrTheStatusBarToToggle => '允許使用 Ins 或狀態列切換覆寫模式；關閉時使用插入模式';

  @override
  String get uiSpacesAndIndentation => '空格與縮排';

  @override
  String get uiSpacesPerTab => 'Tab 空格數量';

  @override
  String get uiNumberOfSpacesInsertedByTabOrAutomatic => '按 Tab 或自動留空時插入的空格數';

  @override
  String get uiUseFullWidthSpaces => '使用全形空格';

  @override
  String get uiUseHalfWidthSpacesWhenDisabled => '關閉時使用半形空格';

  @override
  String get uiAutomaticallyIndentNewLines => '行首自動留空';

  @override
  String get uiInsertConfiguredSpacesAfterEnterShiftEnterInserts =>
      'Enter 換行後插入設定的空格；Shift+Enter 僅換行';

  @override
  String get uiUpdateManuscriptMentionsWhenAliasesChange => '修改別名時更新正文 Mention';

  @override
  String get uiUpdateMarkersForTheSameCharacterWhoseDisplay =>
      '更新同角色且顯示文字等於原別名的標記';

  @override
  String get uiDisabled2 => '未啟用';

  @override
  String get uiCreatingLocalAuthorization => '正在建立本機授權…';

  @override
  String uiAuthorizedLocalReadOnly(String p1) {
    return '已授權：$p1（僅本機、唯讀）';
  }

  @override
  String get uiAuthorizationExpired => '授權已到期';

  @override
  String get uiCouldNotEnable => '啟用失敗';

  @override
  String get uiReadOnlyMCPIntegration => 'MCP 唯讀整合';

  @override
  String uiExposeOnlyTheAuthorizedProjectSSummaryChapters(String p1) {
    return '只公開目前授權專案的摘要、章節、角色、世界觀、大綱與詞語；不提供修改工具。$p1';
  }

  @override
  String get uiTheMCPSidecarSupportsWindowsMacOSAndLinux =>
      'MCP sidecar 僅支援 Windows、macOS 與 Linux。';

  @override
  String uiConnectionConfiguration(String p1) {
    return '連線設定檔：$p1';
  }

  @override
  String get uiAnMCPHostHasClaimedTheOneTime =>
      'MCP Host 已取得一次性授權；如要改連其他 Host，請停止後重新啟用。';

  @override
  String get uiCopyMCPHostConfiguration => '複製 MCP Host 設定';

  @override
  String get uiStopCurrentAuthorization => '停止目前授權';

  @override
  String get uiAllowOneSidedPairingConfirmation => '允許單端確認配對碼';

  @override
  String get uiRequiresBothDevicesToEnableThisOptionAfter =>
      '僅在兩台裝置都開啟時生效；任一台確認後，另一台會驗證簽章並自動回簽';

  @override
  String get uiPersistentAuthenticationDays => '持久驗證（14 天）';

  @override
  String get uiRequiresBothDevicesToEnableThisOptionAuthenticate =>
      '僅在兩台裝置都開啟時生效；期限內可自動驗證，每次成功連線會重新續簽 14 天';

  @override
  String get uiAllowBackgroundExecution => '允許背景常駐';

  @override
  String get uiUnrestrictedBatteryUsageIsAllowed => '已允許不受電池最佳化限制';

  @override
  String get uiReduceTheChanceOfTheSystemSuspendingActive =>
      '讓已啟用的背景工作較不易被系統暫停';

  @override
  String get uiAllowed => '已允許';

  @override
  String get uiAllow => '允許';

  @override
  String get uiFontSize => '字體大小調整';

  @override
  String get uiIconsOnly => '僅圖示';

  @override
  String get uiIconsAndLabels => '圖示與名稱';

  @override
  String get uiExpandOnClick => '點擊展開';

  @override
  String get uiExpandOnHover => '懸停展開';

  @override
  String get uiNavigationStyle => '導覽模式';

  @override
  String get uiHomeStaysAtTheTopSettingsAndAbout =>
      '首頁固定頂端；設定、關於固定底端。窄視窗使用按鈕開啟導覽。';

  @override
  String get uiLight => '淺色';

  @override
  String get uiDark => '深色';

  @override
  String get uiThemeMode => '主題模式';

  @override
  String get uiFollowTheSystemSLightOrDarkAppearance => '跟隨系統的淺色或深色外觀。';

  @override
  String uiUseAppearance(String p1) {
    return '使用$p1外觀。';
  }

  @override
  String uiCurrentlyUsingMode(String p1) {
    return '目前使用：$p1模式';
  }

  @override
  String get uiWordCountMode => '字數統計模式';

  @override
  String get uiCharacterCountNotRecommended => '純字元數 (不建議)';

  @override
  String get uiFullWidthCharactersHalfWidthWords => '全形字元 + 半形單字';

  @override
  String get uiCharactersNotRecommended => '字元數 (不建議)';

  @override
  String get uiMixedMode => '混合模式';

  @override
  String get uiSaveOnAScheduleRequiresAnExistingFile => '依排程儲存檔案（需要檔案存在）';

  @override
  String get uiCreateScheduledProjectBackupsWithoutOverwritingTheOriginal =>
      '依排程建立專案備份，不覆蓋原檔案';

  @override
  String get uiMaximumBackupStorage => '備份最高上限';

  @override
  String get uiOpen => '開啟';

  @override
  String get uiChooseAgain => '重新選擇';

  @override
  String get uiChoose => '選擇';

  @override
  String get uiAutoBackupFolderOptions => 'AutoBackup 目錄選項';

  @override
  String get uiReset => '重設';

  @override
  String uiMBBackups(String p1, String p2, String p3) {
    return '$p1 / $p2 MB ・ $p3 份';
  }

  @override
  String get uiDeleteAllBackups => '清理全部備份';

  @override
  String uiDeletedBackupsFreeing(String p1, String p2) {
    return '已清理 $p1 份備份，釋放 $p2。';
  }

  @override
  String uiOpenedAutoBackupFolder(String p1) {
    return '已開啟 AutoBackup 目錄：$p1';
  }

  @override
  String uiAutoBackupFolderSet(String p1) {
    return 'AutoBackup 目錄已設定：$p1';
  }

  @override
  String uiAutoBackupFolderReset(String p1) {
    return 'AutoBackup 目錄已重設：$p1';
  }

  @override
  String get uiComingSoon => '即將推出';

  @override
  String get uiTimeline => '時間軸';

  @override
  String uiFoundMissingReferencesDataHasBeenPreservedRelink(String p1) {
    return '偵測到 $p1 筆缺失引用；資料已保留，請重新連結或移除對應節點。';
  }

  @override
  String get uiSearchTimeline => '搜尋時間軸';

  @override
  String get uiAllStateChanges => '全部狀態變更';

  @override
  String get uiCharacters3 => '角色';

  @override
  String get uiMainTimeline => '主時間軸';

  @override
  String get uiAddStoryline => '新增大箱';

  @override
  String get uiAddEvent => '新增中箱';

  @override
  String get uiAddScene => '新增小箱';

  @override
  String get uiScenesAreLeafNodes => '小箱是最末層節點';

  @override
  String get uiCurrentChapterOnly => '只看目前章節';

  @override
  String get uiNoChapterLinked => '未連結章節';

  @override
  String get uiAutomaticallySortOutlineSortByStartTickAnd =>
      '自動排序大綱\n依起始 Tick、時間軌順序排列大綱；大綱順序變更時同步調整時間軸。';

  @override
  String get uiShowEmptyTimelineRanges => '顯示時間軸空白區段';

  @override
  String get uiSkipEmptyTimelineRanges => '省略時間軸空白區段';

  @override
  String get uiReturnToCurrentTimeline => '返回目前時間軸';

  @override
  String get uiVisibleTickWidth => '畫面 Tick 寬度';

  @override
  String get uiCurrentTick2 => '目前 Tick';

  @override
  String get uiUnscheduledStorylines => '未排定大箱';

  @override
  String get uiAllOutlineStorylinesAreSynced => '所有大綱大箱皆已同步';

  @override
  String get uiSyncCreatesOrCompletesTheEntireStorylineEvent =>
      '同步時會建立或補齊整個大箱、中箱與小箱階層，不會把單一場景放進目前中箱。';

  @override
  String get uiUntitledStoryline2 => '未命名大箱';

  @override
  String uiTimelineStorylineMissingContainsEventsAndScenes(
    String p1,
    String p2,
  ) {
    return '時間軸大箱不存在；包含 $p1 個中箱、$p2 個小箱';
  }

  @override
  String uiMissingEventsAndScenes(String p1, String p2) {
    return '待補齊 $p1 個中箱、$p2 個小箱';
  }

  @override
  String get uiSyncEntireStoryline => '同步整個大箱';

  @override
  String get uiStoryTimeScale => '故事刻度設定';

  @override
  String get uiTickUnit => 'Tick 單位';

  @override
  String get uiUnitsPerTick => 'Tick 對應單位數';

  @override
  String get uiTicksPerScene => '每小箱 Tick 數';

  @override
  String get uiScenesPerEvent => '每中箱的小箱數';

  @override
  String get uiEventsPerStoryline => '每大箱的中箱數';

  @override
  String uiTickSceneTicksEventTicksStorylineTicks(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  ) {
    return '1 Tick = $p1 $p2；1 小箱 = $p3 Tick；1 中箱 = $p4 Tick；1 大箱 = $p5 Tick。';
  }

  @override
  String get uiNodeName => '節點名稱';

  @override
  String get uiRequiredWhenNoSceneIsSelected => '未選場景時必填';

  @override
  String get uiAddingAnEventAlsoCreatesItsCorrespondingOutline =>
      '新增中箱時會同步建立對應的大綱事件。';

  @override
  String get uiOutlineSceneOptional => '大綱場景（可選）';

  @override
  String get uiCreateNewOutlineScene => '建立新的大綱場景';

  @override
  String get uiUntitledScene2 => '未命名場景';

  @override
  String get uiAddTrack => '新增軌道';

  @override
  String get uiTrackName => '軌道名稱';

  @override
  String get uiRenameTrack => '重新命名軌道';

  @override
  String get uiDeleteTrack => '刪除軌道';

  @override
  String get uiNodesMoveToAnotherTrackOutlineScenesWill =>
      '軌道上的節點會移到其他軌道，不會刪除大綱場景。';

  @override
  String get uiChooseAChapterToOpen => '選擇要開啟的章節';

  @override
  String get uiDeleteTimelineNode => '刪除時間軸節點';

  @override
  String get uiThisDeletesTheNodeAndItsChildrenOutline =>
      '將刪除此節點與其子節點；大綱場景和章節內容不會被刪除。';

  @override
  String get uiLinkChaptersAndApplyToAllChildren => '連結章節並套用到所有子節點';

  @override
  String get uiChooseLinkedChapters => '選擇關聯章節';

  @override
  String uiAllChildScenesWillUseTheSameChapter(String p1) {
    return '套用後，$p1 個子場景會使用完全相同的章節選擇。';
  }

  @override
  String get uiNoChaptersYet => '目前沒有章節';

  @override
  String uiCurrentlyChildScenes(String p1, String p2, String p3) {
    return '$p1 · 目前 $p2/$p3 個子場景';
  }

  @override
  String uiTimeScrubberCurrentlyTicks(String p1) {
    return '時間 Scrubber，目前 $p1 Tick';
  }

  @override
  String uiDragCurrentTimeTicks(String p1) {
    return '拖動目前時間：$p1 Tick';
  }

  @override
  String get uiTrack => '軌道';

  @override
  String get uiTrackOptions => '軌道選項';

  @override
  String get commonRename => '重新命名';

  @override
  String get uiExpandTrack => '展開軌道';

  @override
  String get uiCollapseTrack => '收合軌道';

  @override
  String get uiMoveUp => '上移';

  @override
  String get uiMoveDown => '下移';

  @override
  String get uiDragToAdjustStartTick => '拖曳調整頭端 Tick';

  @override
  String get uiDragToAdjustEndTick => '拖曳調整尾端 Tick';

  @override
  String get uiAdjustStartTick => '調整頭端 Tick';

  @override
  String get uiAdjustEndTick => '調整尾端 Tick';

  @override
  String get uiDragToAdjustTime => '拖曳以調整時間';

  @override
  String uiStateChangesCharactersItemsLocations(
    String p1,
    String p2,
    String p3,
  ) {
    return '狀態變更：角色 $p1、物品 $p2、地點 $p3';
  }

  @override
  String get uiNodeProperties => '節點屬性';

  @override
  String get uiNoNodeSelected => '尚未選取節點';

  @override
  String get uiSelectATimelineNodeToViewAndAdjust =>
      '點一下時間軸節點即可檢視與調整 Tick、軌道及章節關聯。';

  @override
  String get uiDeleteNode => '刪除節點';

  @override
  String get uiCustomName => '自訂名稱';

  @override
  String get uiAssignedTrack => '所在軌道';

  @override
  String get uiStartTick => '頭端 Tick';

  @override
  String get uiTickCount => 'Tick 數';

  @override
  String get uiEndTick => '尾端 Tick';

  @override
  String get uiOpenInOutline => '在大綱中開啟';

  @override
  String uiChaptersBelowAreCollectedFromChildScenes(String p1) {
    return '以下章節彙整自 $p1 個子場景。';
  }

  @override
  String get uiSceneStateChanges => '場景狀態變更';

  @override
  String uiCharactersItemsLocations(String p1, String p2, String p3) {
    return '角色 $p1・物品 $p2・地點 $p3';
  }

  @override
  String get uiNoCharacterItemOrLocationSnapshotChangesIn =>
      '此場景沒有角色、物品或地點快照變更。';

  @override
  String get uiLinkedChapters => '關聯章節';

  @override
  String get uiChooseChapters => '選擇章節';

  @override
  String get uiChildScenesHaveNoLinkedChaptersYet => '子場景尚未連結章節';

  @override
  String get uiThisSceneHasNoLinkedChaptersYet => '此場景尚未連結章節';

  @override
  String get uiChooseChaptersAndApplyThemToAllChild => '可選擇章節並一次套用到所有子節點。';

  @override
  String get uiTheFirstChapterWillNotOpenAutomatically => '不會自動切換到第一章。';

  @override
  String get uiMissingChapter => '缺失章節';

  @override
  String get uiThisContainerHasNoChildScenesThatCan =>
      '此容器目前沒有可連結章節的子場景；請先新增小箱。';

  @override
  String get uiThisSceneHasNoOutlineSceneLinkedSo => '此小箱尚未連結大綱場景，無法建立章節關聯。';

  @override
  String uiOpen2(String p1) {
    return '開啟$p1';
  }

  @override
  String get uiDecrease => '減少';

  @override
  String get uiIncrease => '增加';

  @override
  String get uiAddTheSceneToTheTimelineBeforeAdding3 =>
      '請先將 Scene 放入時間軸，再新增地點快照。';

  @override
  String uiExistence(String p1, String p2) {
    return '存在 $p1 → $p2';
  }

  @override
  String uiAccess(String p1, String p2) {
    return '可進入 $p1 → $p2';
  }

  @override
  String uiState(String p1, String p2) {
    return '狀態「$p1」 → 「$p2」';
  }

  @override
  String uiController(String p1, String p2) {
    return '控制者 $p1 → $p2';
  }

  @override
  String get uiNoChanges => '無變更';

  @override
  String get uiApplyToAllChildLocations => '套用至所有子地點';

  @override
  String uiCreatesIndependentSnapshots(String p1) {
    return '將建立 $p1 筆獨立快照';
  }

  @override
  String uiOnlyWillBeModified(String p1) {
    return '目前只會修改「$p1」';
  }

  @override
  String get uiNameAtThisPoint => '當時名稱';

  @override
  String get uiDescriptionAtThisPoint => '當時描述';

  @override
  String get uiCustomPropertiesAtThisPoint => '當時自訂屬性';

  @override
  String get uiValue => '鍵值';

  @override
  String get uiRemoveProperty => '移除屬性';

  @override
  String get uiAddProperty => '新增屬性';

  @override
  String get uiBatchApplicationPreservesEachChildLocationSExisting =>
      '批次套用會保留各子地點原有的名稱、描述與自訂屬性。';

  @override
  String get uiAccessibleAtThisPoint => '此時可進入';

  @override
  String get uiController2 => '控制者';

  @override
  String get uiBatchChangesPreview => '批次差異預覽';

  @override
  String get uiPropertiesWithAValueMustHaveAName => '屬性有鍵值時必須填寫設定名稱。';

  @override
  String get uiCustomPropertyNamesMustBeUnique => '自訂屬性的設定名稱不可重複。';

  @override
  String get uiLocationSnapshotAdded => '已新增地點快照';

  @override
  String uiAddedLocationSnapshots(String p1) {
    return '已新增 $p1 筆地點快照';
  }

  @override
  String get uiDeleteAllSnapshotsInThisBatch => '刪除整批地點快照？';

  @override
  String uiThisSnapshotBelongsToTheSameBatchAs(String p1) {
    return '這筆快照與其他子地點屬於同一次批次操作，將一併刪除 $p1 筆快照。';
  }

  @override
  String get uiDeleteBatch => '整批刪除';

  @override
  String uiDeletedLocationSnapshots(String p1) {
    return '已刪除 $p1 筆地點快照';
  }

  @override
  String get uiLocationSnapshotDeleted => '已刪除地點快照';

  @override
  String get uiItemsCurrentlyAtThisLocation => '目前位於本地點的物品';

  @override
  String get uiNoItemsHere => '目前沒有物品';

  @override
  String get uiUseAllocateItemsToSetLocationsOrAggregate =>
      '按「分配物品」即可在此頁設定所在地或聚合數量';

  @override
  String get uiChooseALocationItemToLink => '選擇要連結的地點物品';

  @override
  String get uiChooseAnItemToPlaceHere => '選擇要放在本地點的物品';

  @override
  String get uiMoveLegacyWorldbuildingItems => '搬移舊版世界物品';

  @override
  String uiMoveItemNodesToTheNewItemManager(String p1) {
    return '將 $p1 筆物品子節點搬到新版物品管理；原 ID、內容與來源路徑會保留。';
  }

  @override
  String uiMovedItemsToTheNewItemManager(String p1) {
    return '已搬移 $p1 筆物品到新版物品管理。';
  }

  @override
  String get uiWorldbuilding2 => '世界設定';

  @override
  String get uiManageTemplates => '模板管理';

  @override
  String get uiImportTemplateFile => '匯入模板檔案…';

  @override
  String get uiExportSelectedTemplate => '匯出選取模板…';

  @override
  String get uiExportAllTemplates => '匯出全部模板…';

  @override
  String get uiSaveTemplatePreset => '儲存預設模板…';

  @override
  String get uiRenamePreset => '更改預設名稱…';

  @override
  String get uiDeleteSelectedPreset => '刪除選取預設';

  @override
  String get uiWorldStructure => '世界結構';

  @override
  String get uiNoLocationsYet => '尚無地點';

  @override
  String get uiAddYourFirstLocation => '請新增第一個地點';

  @override
  String get uiChildLocation => '子地點';

  @override
  String get uiTopLevelLocation => '頂層地點';

  @override
  String get uiNodeDetails => '節點詳情';

  @override
  String get uiDoesNotExistAtThisTick => '此 Tick 尚未存在';

  @override
  String get uiTreeShellRetainedExistingChildLocationsRemain => '保留樹殼：仍有存在的子地點';

  @override
  String get uiParentDoesNotExistAtThisTickThis => '父層在此 Tick 不存在；此節點仍獨立存在';

  @override
  String uiNameAtThisPoint2(String p1) {
    return '當時名稱：$p1';
  }

  @override
  String get uiDeleteLocation => '刪除地點';

  @override
  String get uiBefore => '之前';

  @override
  String get uiAsAChildLocation => '的子地點';

  @override
  String get uiAfter => '之後';

  @override
  String uiIsNowPlaced(String p1, String p2, String p3) {
    return '「$p1」已成為「$p2」$p3';
  }

  @override
  String uiMoved(String p1, String p2, String p3) {
    return '「$p1」已移動到「$p2」$p3';
  }

  @override
  String get uiSelectALocationFirst => '請先選取地點';

  @override
  String get uiSelectALocationToPreviewItsTimelineAnd => '選取地點後即可預覽時間軸與管理快照';

  @override
  String uiDescription2(String p1) {
    return '描述：$p1';
  }

  @override
  String uiProperties(String p1) {
    return '屬性：$p1';
  }

  @override
  String get uiAccessible => '可進入';

  @override
  String get uiInaccessible => '不可進入';

  @override
  String uiController3(String p1) {
    return '控制者：$p1';
  }

  @override
  String get uiRemoveLocationSnapshot => '移除地點快照';

  @override
  String get uiChooseALocation => '請選擇一個地點';

  @override
  String get uiSelectALocationToEditItsDetails => '選取地點後即可編輯詳細資料';

  @override
  String get uiLocationNotFound => '找不到該地點';

  @override
  String get uiApplyTemplate => '應用模板: ';

  @override
  String get uiChooseTemplate => '選擇模板';

  @override
  String get uiBlank => '空白';

  @override
  String get commonConfirm => '確定';

  @override
  String get uiThisIsALegacyItemNodeItemsAre =>
      '這是舊版物品子節點。新版物品不再存放於世界設定樹，請搬移後在本頁地點區直接管理分配。';

  @override
  String get uiMoveAllItems => '搬移全部物品';

  @override
  String get uiNodeType => '節點類別';

  @override
  String get uiCustomProperties => '自訂值表:';

  @override
  String get uiNoCustomProperties => '尚無自訂值';

  @override
  String get uiEnterAPropertyNameAndValueBelowTo => '在下方輸入設定與鍵值後新增';

  @override
  String get uiNotes4 => '備註:';

  @override
  String get uiSaveTemplatePreset2 => '儲存預設模板';

  @override
  String get uiATemplateWithThisNameExistsOverwriteIt => '同名模板已存在，是否要覆蓋？';

  @override
  String get uiRenamePreset2 => '更改預設名稱';

  @override
  String get uiNewTemplateName => '新模板名稱';

  @override
  String get uiImportFailedNoTypeNodesFoundInThe => '匯入失敗：檔案中沒有找到任何 <Type> 節點。';

  @override
  String uiCouldNotReadFile(String p1) {
    return '讀取檔案失敗：$p1';
  }

  @override
  String get uiExportFile => '匯出檔案';

  @override
  String uiFileExportedTo(String p1) {
    return '檔案已匯出至：$p1';
  }

  @override
  String uiPermanentlyDelete(String p1) {
    return '永久刪除「$p1」？';
  }

  @override
  String get uiToMakeALocationDisappearOnlyWithinThe =>
      '若只是讓地點在故事中消失，請新增 Scene 快照並關閉「此時已存在」。';

  @override
  String uiPermanentlyDeleteLocationNodes(String p1) {
    return '將永久刪除 $p1 個地點節點';
  }

  @override
  String uiRemoveLocationSnapshots(String p1) {
    return '移除 $p1 筆地點快照';
  }

  @override
  String uiRemoveItemLinks(String p1) {
    return '移除 $p1 筆物品關聯';
  }

  @override
  String uiClearItemLocationRecords(String p1) {
    return '清除 $p1 筆物品地點記錄';
  }

  @override
  String get uiDeletePermanently => '永久刪除';

  @override
  String get uiError => '錯誤';

  @override
  String get uiSuccess => '成功';

  @override
  String get uiSwitchModule => '切換模組';

  @override
  String get uiSearchModules => '搜尋模組';

  @override
  String get uiNoMatchingModules => '找不到符合的模組';

  @override
  String get uiCurrentModule => '目前模組';

  @override
  String get uiSyncConflictsChooseAVersionForEachField => '同步衝突：選擇各欄位使用版本';

  @override
  String uiAllConflictingFieldsResolved(String p1) {
    return '所有 $p1 個衝突欄位皆已決定';
  }

  @override
  String uiUnresolvedFields(String p1) {
    return '尚有 $p1 個衝突欄位未決定';
  }

  @override
  String get uiDefaultAllFieldsToLocal => '全部欄位預設本機';

  @override
  String get uiDefaultAllFieldsToRemote => '全部欄位預設對方';

  @override
  String get uiCancelAndKeepBothVersions => '取消並保留兩個版本';

  @override
  String uiApplyFieldChoicesAndFinishSync(String p1) {
    return '套用 $p1 個欄位選擇並完成同步';
  }

  @override
  String uiConflictingFields(String p1, String p2) {
    return '$p1 個衝突欄位 · $p2';
  }

  @override
  String get uiDefaultVersion => '預設使用：';

  @override
  String get uiLocalVersion => '本機版本';

  @override
  String get uiRemoteVersion => '對方版本';

  @override
  String get uiInheritLocalVersion => '同上（本機版本）';

  @override
  String get uiInheritRemoteVersion => '同上（對方版本）';

  @override
  String get uiInheritNotSet => '同上（尚未設定）';

  @override
  String uiConflictingField(String p1) {
    return '衝突欄位：$p1';
  }

  @override
  String get uiUnresolved => '尚未決定';

  @override
  String get uiResolved => '已決定';

  @override
  String get uiCommonAncestor => '共同祖先';

  @override
  String get uiMissingDeleted => '（不存在／已刪除）';

  @override
  String get uiWork => '作品';

  @override
  String get uiProjectSections => '專案區段';

  @override
  String get uiPreparingContentAndPackage => '準備內容與封裝…';

  @override
  String uiCouldNotPrepareExport(String p1) {
    return '無法準備匯出：$p1';
  }

  @override
  String get uiChooseALocationAndSave => '選擇位置並儲存…';

  @override
  String get uiSaveCancelledYouCanChooseAnotherLocation => '已取消儲存，可重新選擇位置。';

  @override
  String uiSourceSnapshotTakenWhenExportOpened(String p1) {
    return '來源：$p1（開啟匯出時的內容快照）';
  }

  @override
  String get uiCurrentWork => '目前作品';

  @override
  String get uiPurpose => '用途';

  @override
  String get uiManuscriptDelivery => '正文交稿';

  @override
  String get uiReferenceMaterial => '設定資料閱讀稿';

  @override
  String get uiPartialProjectExchange => '局部專案交換';

  @override
  String get uiContentFormat => '內容格式';

  @override
  String get uiFileOrganization => '檔案組織';

  @override
  String get uiCombineIntoOneDocument => '合併為單一文件';

  @override
  String get uiSeparateDocumentsZIP => '分散文件（ZIP）';

  @override
  String get uiIncludeWorkInformation => '包含作品資訊';

  @override
  String get uiIncludeFolderManuscriptTitles => '包含資料夾／文稿標題';

  @override
  String get uiCurrentManuscriptOnly => '僅目前文稿';

  @override
  String uiPreviewDocumentsBytes(String p1, String p2, String p3) {
    return '預覽：$p1 份文件 · $p2 bytes · .$p3';
  }

  @override
  String get uiGeneratePreview => '產生預覽';

  @override
  String get uiBackToOptions => '返回選項';

  @override
  String get uiThisModuleIsExportedInFull => '此模組以完整內容匯出。';

  @override
  String get uiZIPFileTree => 'ZIP 檔案樹';

  @override
  String get uiExportNotes => '匯出說明';

  @override
  String get uiFileAndHierarchyIndex => '檔案與階層索引';

  @override
  String get uiSearchNamesKeepSelection => '搜尋名稱（保留原選取）';

  @override
  String get uiSelectEntireList => '全選清單';

  @override
  String get uiClearListSelection => '清除清單';

  @override
  String get uiExpandAll => '全部展開';

  @override
  String get uiCollapseAll => '全部收合';

  @override
  String uiSelectedOf(String p1, String p2) {
    return '已選 $p1／$p2 項';
  }

  @override
  String get uiNoMatchingEntries => '沒有符合的項目';

  @override
  String uiCollapse3(String p1) {
    return '收合 $p1';
  }

  @override
  String uiExpand2(String p1) {
    return '展開 $p1';
  }

  @override
  String uiSelectedOf2(String p1, String p2, String p3, String p4) {
    return '$p1，$p2，已選 $p3／$p4';
  }

  @override
  String uiOnlyThisItem(String p1) {
    return '僅此項：$p1';
  }

  @override
  String get uiSearchNameTypeOrAffiliation => '搜尋名稱、類型或所屬資訊';

  @override
  String get uiShowArchivedItems => '顯示封存物品';

  @override
  String get uiNoMatchingObjects => '沒有符合條件的物件。';

  @override
  String get uiUntitledLocation => '未命名地點';

  @override
  String get uiUnnamedCharacter => '未命名人物';

  @override
  String uiCharacter2(String p1) {
    return '人物$p1';
  }

  @override
  String uiLiteral3(String p1) {
    return '・$p1';
  }

  @override
  String get uiUntitledEvent2 => '未命名事件';

  @override
  String uiEvent4(String p1) {
    return '事件・$p1';
  }

  @override
  String uiScene2(String p1) {
    return '場景・$p1';
  }

  @override
  String get uiUntitledItemClass => '未命名物品 Class';

  @override
  String uiAllocations(String p1) {
    return '$p1 筆分配';
  }

  @override
  String uiItemClass2(String p1, String p2, String p3) {
    return '物品 Class・$p1・$p2$p3';
  }

  @override
  String get uiArchived => '・已封存';

  @override
  String uiIndividualItem(String p1, String p2, String p3) {
    return '單件物品・$p1・$p2$p3';
  }

  @override
  String get uiUnassigned2 => '未指派';

  @override
  String get uiAddAGaugeToViewYourWritingProgress => '新增儀表，查看寫作進度。';

  @override
  String get uiAddGauge => '新增儀表';

  @override
  String get uiAllGaugesAreAlreadyShown => '已顯示全部儀表';

  @override
  String get uiWords => ' 字';

  @override
  String get uiEntries4 => ' 項';

  @override
  String get uiStatisticsTemporarilyUnavailable => '統計暫時無法使用';

  @override
  String get uiChooseAChapter => '請選擇章節';

  @override
  String get uiNoProgressYet => '尚無進度';

  @override
  String get uiWords2 => '字';

  @override
  String get uiEntries5 => '項';

  @override
  String uiInformation(String p1) {
    return '$p1資訊';
  }

  @override
  String uiCurrent(String p1, String p2) {
    return '目前：$p1 $p2';
  }

  @override
  String get uiGoal2 => '目標';

  @override
  String get uiTotal => '總計';

  @override
  String uiAllLocalWorks(String p1) {
    return '$p1 · 本機所有作品合計';
  }

  @override
  String get uiFullWidthCharactersHalfWidthWordsAdditionsMinus =>
      '全形字元＋半形單字；新增減去刪除';

  @override
  String uiNetDecreaseTodayWords(String p1) {
    return '今日淨減 $p1 字';
  }

  @override
  String get uiProcessingStatistics => '統計處理中…';

  @override
  String get uiCouldNotSaveStatisticsClickToRetry => '統計無法保存，點此重試';

  @override
  String get uiThisFileOnly => '僅限本檔案';

  @override
  String get uiSetWordCountGoal => '設定字數目標';

  @override
  String get uiRemoveGauge => '刪除儀表';

  @override
  String get uiTrackingNotStarted => '尚未開始追蹤';

  @override
  String get uiCalculating => '計算中';

  @override
  String get uiCalculationFailed => '計算失敗';

  @override
  String get uiNoRevisionsYet => '尚無校訂';

  @override
  String get uiComparisonComplete => '比較完成';

  @override
  String uiOuterRingAdditionsInnerRingRevisions(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  ) {
    return '外環新增：$p1 筆（$p2%）\n內環校訂：$p3 筆（$p4%）\n$p5';
  }

  @override
  String get uiRevisionTrackingInformation => '追蹤校訂資訊';

  @override
  String uiOuterRingAdditions(String p1) {
    return '外環新增：$p1 筆';
  }

  @override
  String uiInnerRingRevisions(String p1) {
    return '內環校訂：$p1 筆';
  }

  @override
  String uiComparisonBaseline(String p1) {
    return '比較基準：$p1';
  }

  @override
  String get uiManuscriptChangesAreCountedByChangedLinesSettings =>
      '正文按變動行、設定按資料筆數統計。修改會在新增與校訂各計一筆。';

  @override
  String get uiEachRingShowsItsCountAsAShare => '兩環顯示各類計數占合計的比例。';

  @override
  String get uiViewRevisionDetails => '查看校訂明細';

  @override
  String get uiTrackRevisions => '追蹤校訂';

  @override
  String uiIsEditingThisChapter(String p1) {
    return '$p1 正在編輯此章節';
  }

  @override
  String get uiStoryRange => '場次範圍';

  @override
  String get uiByStorylineTypeAndOrderWeightEventsScenes =>
      '依大箱類型與順序 · 權重＝1＋中箱數＋小箱數';

  @override
  String get uiAddStorylinesToDisplayTheStoryRangeHere => '新增大箱後，會在這裡顯示場次範圍。';

  @override
  String uiStorylinesWeight(String p1, String p2, String p3, String p4) {
    return '$p1，第 $p2 至 $p3 個大箱，權重 $p4';
  }

  @override
  String uiSnapshotBoundToStartTick(String p1, String p2) {
    return '快照綁定：$p1 · 起點 Tick $p2';
  }

  @override
  String get uiNoSceneSelected => '未選擇 Scene';

  @override
  String get uiDragOntoASingleSceneToSelectIt =>
      '拖曳至單一 Scene 可選取；空白或重疊區域請使用 Scene 選單。';

  @override
  String get uiLiteral4 => '繁體中文';

  @override
  String get uiLiteral5 => '日本語';

  @override
  String get uiBeyondUsingThisThemeWhatElseCanYou => '除了使用這個主題外，你還可以做什麼……';

  @override
  String get uiRespectPeopleSNamesAndPronounsJoinEvents =>
      '尊重每個人的名字與代名詞、參加「同志遊行」等活動、傾聽 LGBTQ+ 的故事，並在日常生活中支持平等、制止歧視。';

  @override
  String get uiTimelineAndSnapshots => '時間軸與快照';

  @override
  String uiEventsAtTick(String p1) {
    return 'Tick $p1 的事件';
  }

  @override
  String get uiEditingDefaultDataEnableFollowTimelineToPreview =>
      '目前編輯預設資料；開啟「跟隨時間軸」可預覽指定 Tick。';

  @override
  String get uiNoSnapshotAtThisTickPreviewOnlyAdd =>
      '此 Tick 無快照，僅供預覽；新增快照後即可編輯。若要編輯預設資料，請關閉「跟隨時間軸」。';

  @override
  String get uiOnlyAnInheritedClassStateExistsAtThis =>
      '此 Tick 僅有 Class 繼承狀態，僅供預覽；新增單件快照後即可編輯。';

  @override
  String get uiEditingThisTickSSnapshotChangesAreSaved =>
      '目前編輯此 Tick 的快照，變更只會儲存至此事件。';

  @override
  String get uiIndependentPreview => '獨立預覽';

  @override
  String get uiHistoricalPreview => '歷史預覽';

  @override
  String get uiFollowTimeline => '跟隨時間軸';

  @override
  String get uiPreviousEvent => '上一事件';

  @override
  String get uiNextEvent => '下一事件';

  @override
  String get uiLocateOnMainTimeline => '定位主時間軸';

  @override
  String get uiSceneDisplayRange => 'Scene 顯示範圍';

  @override
  String get uiRelatedScenes => '相關 Scene';

  @override
  String get uiAllScenes => '完整 Scene';

  @override
  String get uiNoSnapshotEventsPreviewAnyTick => '尚無快照事件，可在任意 Tick 預覽';

  @override
  String get uiSceneNotScheduledUsingFallbackTime => 'Scene 尚未排定，使用回退時間';

  @override
  String uiCouldNotLoadWritingGoals(String p1) {
    return '無法載入寫作目標：$p1';
  }

  @override
  String get uiDailyNetWordGainAcrossAllLocalWorks => '本機所有作品合計的每日淨增字數';

  @override
  String get uiSavedWithTheCurrentWorkAndAppliedTo => '隨目前作品保存，套用至本檔案。';

  @override
  String get uiApplyToWorksWithoutAFileSpecificGoal => '套用至所有未設定檔案專屬目標的作品。';

  @override
  String uiThisFileStillUsesItsOwnGoalOf(String p1) {
    return '本檔案仍使用專屬目標 $p1 字。';
  }

  @override
  String get uiWordCountGoal => '目標字數';

  @override
  String get uiRestoreDefault => '恢復使用預設';

  @override
  String get uiSaving => '保存中…';

  @override
  String get uiCouldNotReadWritingGoalsClickToRetry => '無法讀取寫作目標，點此重試';

  @override
  String get uiAllLocalWorksCombined => '本機所有作品合計';

  @override
  String get uiDefaultFileSpecificValuesCanBeSetFrom => '預設；檔案專屬值可從對應儀表設定';

  @override
  String get uiEnterAnAlias => '請輸入別名';

  @override
  String get uiAliasAlreadyExists => '別名已存在';

  @override
  String get uiThisAliasWasRemovedCancelAndTryAgain => '此別名已移除，請取消後重試';

  @override
  String get uiAlias => '別名';

  @override
  String get uiEnterAlias => '輸入別名';

  @override
  String get uiTimeMarker => '時間標記';

  @override
  String get uiUntitledNode => '未命名節點';

  @override
  String get uiEnabled => '已啟用';

  @override
  String get uiStandby => '待命';

  @override
  String get uiAttentionRequired => '異常需要處理';

  @override
  String get uiAwaitingConfirmation => '待確認';

  @override
  String get uiActive => '持續生效';

  @override
  String get uiLinked => '已連結';

  @override
  String get uiInformation2 => '資訊';

  @override
  String get uiProcessing => '處理中';

  @override
  String get uiSaveProjectFile => '儲存專案檔案';

  @override
  String get uiExportTextFile => '匯出文字檔案';

  @override
  String get uiSomeWordCountGoalsCouldNotBeParsed =>
      '字數目標含無法解析的資料，已保留原始區塊；目前使用可讀目標或預設值。';

  @override
  String get uiXmlVersionEncodingUTF =>
      '<?xml version=\"1.0\" encoding=\"UTF-8\"?>';

  @override
  String get uiChooseAutoBackupFolder => '選擇 AutoBackup 目錄';

  @override
  String get uiStartWriting => '開始撰寫正文…';

  @override
  String get uiResolved2 => '已回收';

  @override
  String get uiUnresolved2 => '未回收';

  @override
  String get uiInProgress => '進行中';

  @override
  String get uiDedicated => '專用';

  @override
  String get uiSemiDedicated => '半專用';

  @override
  String get uiNonDedicated => '非專用';

  @override
  String get uiArchived2 => '已封存';

  @override
  String get uiHome2 => '首頁';

  @override
  String get uiStorySettings => '故事設定';

  @override
  String get uiCharacters4 => '角色設定';

  @override
  String get uiManuscriptEditor => '正文編輯';

  @override
  String get uiAbout => '關於';

  @override
  String get uiGray => '灰色';

  @override
  String get uiRed => '紅色';

  @override
  String get uiOrange => '橘色';

  @override
  String get uiYellow => '黃色';

  @override
  String get uiGreen => '綠色';

  @override
  String get uiCyan => '青色';

  @override
  String get uiBlue => '藍色';

  @override
  String get uiPurple => '紫色';

  @override
  String get uiPink => '粉紅色';

  @override
  String get uiIconsAndText => '圖示與文字';

  @override
  String get uiExpandWithButton => '按鈕展開';

  @override
  String get uiFollowSystem => '跟隨系統';

  @override
  String get uiMonoAshi => 'MonoAshi';

  @override
  String get uiMosaicMarkerIsIncompleteOrInvalid => 'Mosaic 標記未完成或無效';

  @override
  String get uiExportPhraseLibrary => '匯出短語庫';

  @override
  String get uiPink2 => '粉色';

  @override
  String get uiCharacterSuggestions => '人物候選';

  @override
  String get uiSearchAndInsertProjectPhrases => '搜尋並插入專案短語';

  @override
  String get uiLocationSuggestions => '地點候選';

  @override
  String get uiEventSuggestions => '事件候選';

  @override
  String get uiForeshadowingSuggestions => '伏筆候選';

  @override
  String get uiPlanSuggestions => '計畫候選';

  @override
  String get uiItemSuggestions => '物品候選';

  @override
  String get uiHighlightColorSuggestions => '高亮色彩候選';

  @override
  String get uiCharacterMarkerTemplate => '人物標記骨架';

  @override
  String get uiLocationMarkerTemplate => '地點標記骨架';

  @override
  String get uiEventMarkerTemplate => '事件標記骨架';

  @override
  String get uiForeshadowingMarkerTemplate => '伏筆標記骨架';

  @override
  String get uiPlanMarkerTemplate => '計畫標記骨架';

  @override
  String get uiItemMarkerTemplate => '物品標記骨架';

  @override
  String get uiHighlightMarkerTemplate => '高亮標記骨架';

  @override
  String get uiInsertLiteral => '插入字面 /';

  @override
  String get uiWriteAsToPreventParsingAsASyntax => '以 \\/ 寫入，避免被解析為語法界線';

  @override
  String get uiInsertLiteral2 => '插入字面 \\';

  @override
  String get uiWriteAs => '以 \\\\ 寫入';

  @override
  String get uiCharacterPrimaryName => '人物 · 主名稱';

  @override
  String get uiAddAlias2 => '新增別名…';

  @override
  String get uiEnterOtherDisplayText => '輸入其他顯示文字…';

  @override
  String get uiUseOnlyForThisMentionDoNotAdd => '僅用於此 Mention，不加入別名';

  @override
  String get uiAddChildLocation => '新增子地點…';

  @override
  String get uiAddEvent2 => '新增事件…';

  @override
  String get uiAddScene2 => '新增場景…';

  @override
  String get uiStoryline3 => '大箱';

  @override
  String get uiEvent5 => '中箱';

  @override
  String get uiScene3 => '小箱';

  @override
  String get uiInsertMarkerImmediatelyAfterCreation => '建立後立即插入標記';

  @override
  String get uiHighlightBackgroundAutomaticTextColor => '高亮背景色 · 文字色自動';

  @override
  String get uiOnlyForThisAnnotation => '僅用於此標註';

  @override
  String get uiAnnotation3 => '標註';

  @override
  String get uiMarkerBackgroundColorCodeAutomaticTextColor => '標記背景色碼 · 文字色自動';

  @override
  String get uiWorkInformation => '作品資訊';

  @override
  String get uiChapters2 => '章節';

  @override
  String get uiCreativePurpose => '創作目的';

  @override
  String get uiSynopsis2 => '摘要';

  @override
  String get uiGenre => '故事類型';

  @override
  String get uiAge3 => '年齡';

  @override
  String get uiRoleOccupation2 => '角色／職業';

  @override
  String get uiPersonality2 => '性格';

  @override
  String get uiSpeechStyle2 => '說話方式';

  @override
  String get uiMotivation2 => '動機';

  @override
  String get uiCustomField => '自訂欄位';

  @override
  String get uiFieldValue => '欄位值';

  @override
  String get uiLocationType => '地點類型';

  @override
  String get uiNodeType2 => '節點類型';

  @override
  String get uiConflict => '衝突';

  @override
  String get uiDefaultState => '預設狀態';

  @override
  String get uiStateChanges => '狀態變更';

  @override
  String get uiAffiliation => '所屬';

  @override
  String get uiOrder => '排序';

  @override
  String get uiChinaSGreatestAndMostEnduringArtIs => '中國最偉大、最永久的藝術，就是男人扮女人';

  @override
  String get uiLuXun => '—— 魯迅（1881-1936）';

  @override
  String get uiYyyyMMDdHHMmSs => 'yyyy.MM.dd HH:mm:ss';

  @override
  String get uiAddCharacterRelationship => '新增人物關係';

  @override
  String get uiProtagonist => '主角';

  @override
  String get uiMajorSupportingCharacter => '重要配角';

  @override
  String get uiMainAntagonist => '主要反派';

  @override
  String get uiSecondaryAntagonist => '次要反派';

  @override
  String get uiUntitled2 => '未命名';

  @override
  String get uiCooking => '料理';

  @override
  String get uiUnskilled => '不擅長';

  @override
  String get uiSkilled => '擅長';

  @override
  String get uiCleaning => '清潔';

  @override
  String get uiMoneyManagement => '理財';

  @override
  String get uiFitness => '體能';

  @override
  String get uiArt => '藝術';

  @override
  String get uiMusic => '音樂';

  @override
  String get uiDance => '舞蹈';

  @override
  String get uiCrafts => '手工';

  @override
  String get uiSocialSkills => '社交';

  @override
  String get uiLeadership => '領導';

  @override
  String get uiAnalysis => '分析';

  @override
  String get uiCreativity => '創意';

  @override
  String get uiMemory => '記憶';

  @override
  String get uiObservation => '觀察';

  @override
  String get uiAdaptability => '應變';

  @override
  String get uiLearning => '學習';

  @override
  String get uiIntroverted => '內向';

  @override
  String get uiExtroverted => '外向';

  @override
  String get uiEmotional => '感性';

  @override
  String get uiRational => '理性';

  @override
  String get uiPassive => '被動';

  @override
  String get uiProactive => '主動';

  @override
  String get uiConservative => '保守';

  @override
  String get uiOpenMinded => '開放';

  @override
  String get uiCautious => '謹慎';

  @override
  String get uiAdventurous => '冒險';

  @override
  String get uiDependent => '依賴';

  @override
  String get uiIndependent => '獨立';

  @override
  String get uiGentle => '柔順';

  @override
  String get uiStubborn => '固執';

  @override
  String get uiPessimistic => '悲觀';

  @override
  String get uiOptimistic => '樂觀';

  @override
  String get uiSerious => '嚴肅';

  @override
  String get uiHumorous => '幽默';

  @override
  String get uiShy => '害羞';

  @override
  String get uiOutgoing => '大方';

  @override
  String get uiLowKey => '低調';

  @override
  String get uiShowy => '高調';

  @override
  String get uiNegative => '消極';

  @override
  String get uiPositive => '積極';

  @override
  String get uiCunning => '狡猾';

  @override
  String get uiHonest => '老實';

  @override
  String get uiChildish => '幼稚';

  @override
  String get uiMature => '成熟';

  @override
  String get uiCalm => '冷靜';

  @override
  String get uiImpulsive => '衝動';

  @override
  String get uiQuiet => '寡言';

  @override
  String get uiTalkative => '多話';

  @override
  String get uiObstinate => '執拗';

  @override
  String get uiCompliant => '順從';

  @override
  String get uiUnrestrained => '奔放';

  @override
  String get uiSelfDisciplined => '自律';

  @override
  String get uiFrivolous => '輕浮';

  @override
  String get uiAwkward => '彆扭';

  @override
  String get uiFrank => '坦率';

  @override
  String get uiIndifferent => '淡漠';

  @override
  String get uiCurious => '好奇';

  @override
  String get uiSlowToNotice => '遲鈍';

  @override
  String get uiPerceptive => '敏銳';

  @override
  String get uiExpressionless => '面癱';

  @override
  String get uiExpressive => '生動';

  @override
  String get uiFoolish => '笨蛋';

  @override
  String get uiGenius => '天才';

  @override
  String get uiSimple => '單純';

  @override
  String get uiComplex => '複雜';

  @override
  String get uiEasilyEmbarrassed => '臉薄';

  @override
  String get uiShameless => '厚顏';

  @override
  String get uiMild => '溫和';

  @override
  String get uiHotTempered => '火爆';

  @override
  String get uiRough => '粗魯';

  @override
  String get uiRefined => '斯文';

  @override
  String get uiWeakWilled => '軟弱';

  @override
  String get uiDetermined => '堅定';

  @override
  String get uiWithoutDesire => '無慾';

  @override
  String get uiIntense => '強烈';

  @override
  String get uiTimid => '膽小';

  @override
  String get uiBrave => '勇敢';

  @override
  String get uiInarticulate => '木訥';

  @override
  String get uiWitty => '風趣';

  @override
  String get uiTrusting => '輕信';

  @override
  String get uiSuspicious => '多疑';

  @override
  String get uiInsecure => '自卑';

  @override
  String get uiConfident => '自信';

  @override
  String get uiWithdrawn => '退縮';

  @override
  String get uiDecisive => '果敢';

  @override
  String get uiSociallyReserved => '陰角';

  @override
  String get uiSociallyOutgoing => '陽角';

  @override
  String get uiConfessDirectly => '直接告白';

  @override
  String get uiGiveGifts => '送禮物';

  @override
  String get uiTalkToThemOften => '常常找對方講話';

  @override
  String get uiDoLittleThingsToGetAttention => '做些小動作引起注意';

  @override
  String get uiQuietlyPayAttention => '默默關注對方';

  @override
  String get uiSmile => '微笑';

  @override
  String get uiGreetThemFirst => '主動打招呼';

  @override
  String get uiOfferHelp => '主動幫忙';

  @override
  String get uiGiveSmallGifts => '送小禮物';

  @override
  String get uiInviteThem => '邀請對方';

  @override
  String get uiSharePersonalStories => '分享自己的事';

  @override
  String get uiIgnoreThem => '直接無視';

  @override
  String get uiKeepADistance => '保持距離';

  @override
  String get uiRespondPolitely => '禮貌應對';

  @override
  String get uiUseSarcasm => '冷嘲熱諷';

  @override
  String get uiConfrontThem => '正面衝突';

  @override
  String get uiAskOthersForHelp => '找人幫忙';

  @override
  String get uiLawfulGood => '守序\n善良';

  @override
  String get uiNeutralGood => '中立\n善良';

  @override
  String get uiChaoticGood => '混亂\n善良';

  @override
  String get uiLawfulNeutral => '守序\n中立';

  @override
  String get uiTrueNeutral => '絕對\n中立';

  @override
  String get uiChaoticNeutral => '混亂\n中立';

  @override
  String get uiLawfulEvil => '守序\n邪惡';

  @override
  String get uiNeutralEvil => '中立\n邪惡';

  @override
  String get uiAbsoluteEvil => '絕對\n邪惡';

  @override
  String get uiSingle => '單身';

  @override
  String get uiMarriedEngaged => '已婚/準備結婚';

  @override
  String get uiDatingStartingARelationship => '戀愛中/準備戀愛';

  @override
  String get uiWidowed => '喪偶';

  @override
  String get uiScene4 => '場景';

  @override
  String get uiComma => '逗號';

  @override
  String get uiPeriod => '句號';

  @override
  String get uiEnumerationComma => '頓號';

  @override
  String get uiEllipsis => '刪節號';

  @override
  String get uiSameTypeQuotes => '同類引號';

  @override
  String get uiResolveThisIssue => '解決單項';

  @override
  String get uiProofreadingWorkerHasBeenDisposed =>
      'Proofreading worker has been disposed.';

  @override
  String get uiQuotesShouldStartWithNot => '引號結構應以\" \"開頭，不應以\' \'開頭。';

  @override
  String get uiQuoteLevelsShouldAlternateBetweenAnd =>
      '偵測到引號層級未交錯，建議以\" \"與\' \'交替。';

  @override
  String get uiQuotesShouldStartWithNot2 => '引號結構應以「」開頭，不應以『』開頭。';

  @override
  String get uiQuoteLevelsShouldAlternateInACycle =>
      '偵測到引號層級未交錯，建議以「『』」為一循環交替。';

  @override
  String get uiSeconds => '秒';

  @override
  String get uiMinutes2 => '分鐘';

  @override
  String get uiHours => '小時';

  @override
  String get uiDays => '天';

  @override
  String get uiWeeks => '週';

  @override
  String get uiMonths => '月';

  @override
  String get uiSeasons => '季節';

  @override
  String get uiYears => '年';

  @override
  String get uiDecades => '十年';

  @override
  String get uiCenturies => '世紀';

  @override
  String get uiCustomUnit => '自訂單位';

  @override
  String get uiChooseObject => '選擇物件';

  @override
  String get uiDailyGoal => '每日目標';

  @override
  String get uiBookWordCount => '全書字數';

  @override
  String get uiForeshadowingResolution => '伏筆回收';

  @override
  String get uiOrange2 => '橙色';

  @override
  String get uiNoTimelineNodesYet => '尚無時間軸節點';

  @override
  String get uiMiniTimeline => '微型時間軸';

  @override
  String get uiDefaultChapterWordCountGoal => '每章字數目標';

  @override
  String get uiDefaultProjectWordCountGoal => '全文字數目標';

  @override
  String get uiNoDataYet => '尚無資料';

  @override
  String get uiUseEitherTitleOrTitleWidgetNotBoth =>
      'Use either title or titleWidget, not both.';

  @override
  String get uiControllerAndInitialValueCannotBothBeSupplied =>
      'controller and initialValue cannot both be supplied.';

  @override
  String get uiMinLinesAndMaxLinesMustBeNullWhenExpands =>
      'minLines and maxLines must be null when expands is true.';

  @override
  String get uiUseEitherTitleOrACustomHeaderNot =>
      'Use either title or a custom header, not both.';

  @override
  String get uiUseEitherBackgroundColorOrColorNotBoth =>
      'Use either backgroundColor or color, not both.';

  @override
  String get uiUseEitherActionOrActionLabelOnAction =>
      'Use either action or actionLabel/onAction.';

  @override
  String get uiActionLabelAndOnActionMustBeProvidedTogether =>
      'actionLabel and onAction must be provided together.';

  @override
  String get uiAControllerIsRequiredWhenShowScrollbarIsTrue =>
      'A controller is required when showScrollbar is true.';

  @override
  String get uiBlank2 => '（空白）';

  @override
  String get uiStandard => '一般配色';

  @override
  String get uiHighContrast => '高對比';

  @override
  String get uiShowYourPrideRainbow => 'Show Your Pride/彩虹旗';

  @override
  String get uiShowYourPrideLesbian => 'Show Your Pride/女同志';

  @override
  String get uiShowYourPrideBisexual => 'Show Your Pride/雙性戀';

  @override
  String get uiShowYourPrideTransgender => 'Show Your Pride/跨性別';

  @override
  String get navigationTooltipDescription => '僅顯示圖示，停留或聚焦時顯示名稱。';

  @override
  String get navigationLabelDescription => '圖示下方常駐顯示名稱。';

  @override
  String get navigationDrawerDescription => '使用底部按鈕展開導覽，並推開內容側欄。';

  @override
  String get navigationHoverDescription => '游標停留時預覽，移開後收合；固定開啟時推開內容側欄。';

  @override
  String get toolbarFullDescription => '完整功能區，顯示頁籤、群組與指令名稱。';

  @override
  String get toolbarModerateDescription => '保留功能區頁籤，該頁指令以單行圖示與文字顯示，可橫向捲動。';

  @override
  String get toolbarConciseDescription => '保留功能區頁籤，該頁指令以純圖示單行排列，可橫向捲動。';

  @override
  String get exportWordUnavailable => 'Word（尚未開放）';

  @override
  String get exportPdfUnavailable => 'PDF（尚未開放）';

  @override
  String get exchangeChapters => '章節內容';

  @override
  String get exchangeOutline => '大綱與時間軸';

  @override
  String get exchangePlans => '更新計畫與伏筆';

  @override
  String get exchangeWorld => '世界設定與地點快照';

  @override
  String get exchangeCharacters => '角色設定與快照';

  @override
  String get exchangeItems => '物品設定與快照';

  @override
  String get characterMinorSupporting => '次要配角';

  @override
  String untitledTimelineNode(String label) {
    return '未命名$label';
  }

  @override
  String welcomeMorning(String name) {
    return '早安，\n$name！';
  }

  @override
  String welcomeAfternoon(String name) {
    return '午安，\n$name！';
  }

  @override
  String welcomeEvening(String name) {
    return '晚安，\n$name！';
  }

  @override
  String welcomeNight(String name) {
    return '夜深了，\n$name！';
  }

  @override
  String get welcomeUser => '使用者';

  @override
  String get ribbonMoreOptions => '更多選項';

  @override
  String get ribbonCustomize => '自訂功能區';

  @override
  String get ribbonQuickAccess => '快速存取工具列';

  @override
  String get ribbonTabs => '功能區索引標籤';

  @override
  String get ribbonExpandQuickAccess => '展開快速存取工具列';

  @override
  String get ribbonCollapseQuickAccess => '收合快速存取工具列';

  @override
  String get ribbonCustomizeQuickAccess => '自訂快速存取工具列';

  @override
  String get ribbonMoreQuickAccess => '更多快速存取命令';

  @override
  String ribbonExpand(String shortcut) {
    return '展開功能區（$shortcut）';
  }

  @override
  String ribbonCollapse(String shortcut) {
    return '收合功能區（$shortcut）';
  }

  @override
  String get ribbonSearch => '搜尋命令';

  @override
  String get ribbonTextColor => '文字色彩';

  @override
  String get ribbonColor => '色彩';

  @override
  String get ribbonFont => '字型';

  @override
  String ribbonTabSemantics(String label) {
    return '$label 索引標籤';
  }

  @override
  String ribbonMoveTabUp(String label) {
    return '上移 $label';
  }

  @override
  String ribbonMoveTabDown(String label) {
    return '下移 $label';
  }

  @override
  String ribbonCommandsSemantics(String label) {
    return '$label 命令';
  }

  @override
  String ribbonGroupSemantics(String label) {
    return '$label 群組';
  }

  @override
  String get ribbonTabNavigation => '使用左右方向鍵、Home 或 End 切換。';

  @override
  String get ribbonReset => '重設為預設值';

  @override
  String get ribbonDone => '完成';

  @override
  String completionBrowseTargets(String p1) {
    return '瀏覽$p1對象';
  }

  @override
  String completionPendingLink(String p1) {
    return '待連結 $p1';
  }

  @override
  String completionAlias(String p1, String p2) {
    return '$p1 · $p2的別名';
  }

  @override
  String completionCharacterAlias(String p1) {
    return '人物 · $p1的別名';
  }

  @override
  String completionAddAlias(String p1) {
    return '為 $p1 新增別名';
  }

  @override
  String completionCreateTarget(String p1) {
    return '新增$p1…';
  }

  @override
  String completionHighlightForeground(String p1) {
    return '高亮文字色 · 背景 $p1';
  }

  @override
  String completionMarkerForeground(String p1) {
    return '標記文字色碼 · 背景 $p1';
  }

  @override
  String relationshipAmbiguousName(String p1) {
    return '名稱不明確：$p1';
  }

  @override
  String relationshipUnlinked(String p1) {
    return '未連結：$p1';
  }

  @override
  String snapshotConflictsCount(String p1) {
    return '阻礙 $p1';
  }

  @override
  String snapshotRelationshipsCount(String p1) {
    return '人物關係 $p1';
  }

  @override
  String snapshotOrganizationsCount(String p1) {
    return '組織 $p1';
  }

  @override
  String snapshotStatusesCount(String p1) {
    return '角色狀態 $p1';
  }

  @override
  String snapshotPossessionsCount(String p1) {
    return '擁有物品 $p1';
  }

  @override
  String snapshotCustomFieldsCount(String p1) {
    return '自訂欄位 $p1';
  }

  @override
  String inspirationNoteCount(String p1) {
    return '$p1 則靈感';
  }

  @override
  String proofUnmatchedClosing(String p1) {
    return '出現未配對的右符號「$p1」。';
  }

  @override
  String proofMismatchedPair(String p1, String p2, String p3) {
    return '右符號「$p1」與左符號「$p2」不匹配，預期為「$p3」。';
  }

  @override
  String proofUnclosedPair(String p1, String p2) {
    return '左符號「$p1」未閉合，缺少「$p2」。';
  }

  @override
  String proofEllipsisSuggestion(String p1) {
    return '刪節號建議使用「……」，目前為「$p1」。';
  }

  @override
  String proofConsecutiveSymbols(String p1, String p2, String p3) {
    return '連續$p1個$p2「$p3」。';
  }

  @override
  String proofInvalidLineEnding(String p1, String p2) {
    return '[$p1] 行尾未符合結尾規則，目前為「$p2」。';
  }

  @override
  String timelineUnnamedLevel(String p1) {
    return '未命名$p1';
  }

  @override
  String worldChildNodeCount(String p1, String p2) {
    return '$p1 • $p2 個子節點';
  }

  @override
  String get revisionUnaccept => '取消接受';

  @override
  String get revisionAccept => '接受';

  @override
  String get revisionReject => '拒絕';

  @override
  String get relationshipExternal => '外在';

  @override
  String get relationshipInternal => '內在';

  @override
  String get writingGoalInvalid => '請輸入 1 到 999,999,999 的整數';

  @override
  String get worldRule => '規則';

  @override
  String get worldOrganization => '組織';

  @override
  String get glossaryPositive => '正面';

  @override
  String get glossaryNegative => '負面';

  @override
  String get glossaryNeutral => '中性';

  @override
  String get glossaryNoun => '名詞';

  @override
  String get glossaryVerb => '動詞';

  @override
  String get glossaryAdjective => '形容詞';

  @override
  String get glossaryAdverb => '副詞';

  @override
  String get glossaryPronoun => '代詞';

  @override
  String get glossaryUnspecified => '未指定';

  @override
  String get conflictUnskilledActivities => '不擅長做';

  @override
  String get conflictPersonalityTraits => '人格特質';

  @override
  String get conflictValue => '值';

  @override
  String get conflictValuesAndBeliefs => '價值觀';

  @override
  String get conflictInternalConflict => '內在衝突';

  @override
  String get conflictAllocatedQuantity => '分配數量';

  @override
  String get conflictFavoriteActivities => '喜歡做';

  @override
  String get conflictLikes => '喜歡項目';

  @override
  String get conflictSynopsis => '回顧';

  @override
  String get conflictName => '姓名';

  @override
  String get conflictFearedActivities => '害怕做';

  @override
  String get conflictFears => '害怕項目';

  @override
  String get conflictSeekingANewRelationship => '尋找新戀情';

  @override
  String get conflictAdmiredThings => '崇拜項目';

  @override
  String get conflictCommonAbilities => '常用能力';

  @override
  String get conflictCommonAbilityValues => '常用能力值';

  @override
  String get conflictHarem => '後宮';

  @override
  String get conflictFear => '恐懼';

  @override
  String get conflictDesiredActivities => '想做';

  @override
  String get conflictDescription => '描述';

  @override
  String get conflictSkilledActivities => '擅長做';

  @override
  String get conflictTextFields => '文字欄位';

  @override
  String get conflictFamiliarThings => '熟悉項目';

  @override
  String get conflictItemData => '物品資料';

  @override
  String get conflictTraitValues => '特質值';

  @override
  String get conflictSocialValues => '社交值';

  @override
  String get conflictSocialTraits => '社交特質';

  @override
  String get conflictOccupationOrRole => '職業或角色';

  @override
  String get conflictLegacyFields => '舊版欄位';

  @override
  String get conflictApproachValues => '處事值';

  @override
  String get conflictApproaches => '處事方式';

  @override
  String get conflictHandlingDislike => '處理厭惡';

  @override
  String get conflictShowingGoodwill => '表達好感';

  @override
  String get conflictShowingLove => '表達愛';

  @override
  String get conflictResolution => '解決';

  @override
  String get conflictResolutionMethod => '解法';

  @override
  String get conflictDislikedActivities => '討厭做';

  @override
  String get conflictDislikes => '討厭項目';

  @override
  String get conflictAdvancedAbilities => '進階能力';

  @override
  String get conflictRelationship => '關係';

  @override
  String get conflictRelationshipSummary => '關係摘要';

  @override
  String get conflictObstacle => '阻礙';

  @override
  String get conflictGoalRecoveryData => '目標復原資料';

  @override
  String get conflictWholeVersion => '整體版本';

  @override
  String p2pConnectedAndVerifiedThisEndpointTCPWorks(String p1) {
    return '$p1 已連入並驗證本機端點；TCP 可雙向通訊，不需要再從本機反向連線。';
  }

  @override
  String p2pSentASecurePairingRequestThisDevice(String p1) {
    return '$p1 已送達安全配對要求；本機正在自動回應。';
  }

  @override
  String p2pCouldNotProcessTheRemotePairingEvent(String p1) {
    return '處理遠端安全配對事件失敗：$p1';
  }

  @override
  String p2pRejectedAnInvalidRemoteRevisionGraph(String p1) {
    return '已拒絕無效的遠端 revision graph：$p1';
  }

  @override
  String get p2pIgnoredAnExpiredPairingChallengeFromThe =>
      '已忽略對方上一輪過期的配對 challenge，等待自動更新。';

  @override
  String get p2pThePeerSPairingChallengeIsInvalid =>
      '對方的配對 challenge 無效、遭竄改或已過期。';

  @override
  String get p2pTheTrustedDeviceSPublicKeyChanged => '已信任裝置的公開金鑰發生變更；已拒絕配對。';

  @override
  String get p2pThePeerRequestedSecurePairingButThis =>
      '對方要求安全配對，但本機暫時無法建立 challenge；正在等待重試。';

  @override
  String get p2pCompareTheSixDigitPairingCodeOn => '請在兩台裝置上比較六位數配對碼；完全相同才可確認。';

  @override
  String get p2pBothDevicesDayAuthenticationIsValidThis =>
      '雙端 14 天持久驗證仍有效；已自動回簽本次短期 session。';

  @override
  String p2pPersistentAuthenticationCouldNotSignAutomatically(String p1) {
    return '持久驗證自動回簽失敗：$p1';
  }

  @override
  String get p2pIgnoredAPreviousPairingConfirmationWaitingFor =>
      '已忽略上一輪的 pairing confirmation，等待目前 challenge 的回簽。';

  @override
  String get p2pThePeerSPairingConfirmationSignatureOr =>
      '對方的 pairing confirmation 簽章或 transcript 不一致。';

  @override
  String get p2pThePeerConfirmedTheCodeBothDevices =>
      '對方已確認配對碼；雙方皆允許單端確認，本機驗證簽章後已自動回簽。';

  @override
  String p2pCouldNotCompleteSecurePairingAutomatically(String p1) {
    return '無法自動完成安全配對：$p1';
  }

  @override
  String get p2pBothDevicesSignedTheSamePairingTranscript =>
      '雙方已簽署確認同一份配對 transcript；正在建立 authenticated encrypted transport。';

  @override
  String get p2pThePeerConfirmedTheCodeYourSettings =>
      '對方已確認配對碼；目前設定要求本機也必須確認。';

  @override
  String get p2pAuthenticatedEncryptedTransportIsReadyRevisionSummaries =>
      'authenticated encrypted transport 已建立；revision summary 與 snapshot chunks 僅透過此通道交換。';

  @override
  String p2pCouldNotVerifyTheEncryptedChannelS(String p1) {
    return '無法驗證加密通道的裝置身分或 transcript：$p1';
  }

  @override
  String p2pCouldNotEstablishAnEncryptedChannel(String p1) {
    return '無法建立加密通道：$p1';
  }

  @override
  String p2pEncryptedRevisionSummariesAreTemporarilyUnavailable(String p1) {
    return '加密 revision summary 暫時無法交換：$p1';
  }

  @override
  String p2pRejectedAnInvalidEncryptedRevisionSummary(String p1) {
    return '已拒絕無效的加密 revision summary：$p1';
  }

  @override
  String p2pTheEncryptedChannelIsCurrentlyUnavailable(String p1) {
    return '加密通道目前不可用：$p1';
  }

  @override
  String p2pRejectedAnInvalidEncryptedRevisionGraph(String p1) {
    return '已拒絕無效的加密 revision graph：$p1';
  }

  @override
  String p2pRevisionGraphTransferWasInterruptedReconnectTo(String p1) {
    return 'revision graph 傳輸暫時中斷，可重新連線續傳：$p1';
  }

  @override
  String p2pTheRevisionGraphIsCurrentlyUnavailable(String p1) {
    return 'revision graph 目前不可用：$p1';
  }

  @override
  String get p2pNoVerifiedPeerEndpointYetWaitFor =>
      '尚未取得已驗證的對方服務端點；請等待加密 revision summary 交換完成。';

  @override
  String get p2pNoSnapshotIsCurrentlyAvailableToSend =>
      '目前沒有可透過已驗證連線提供給對方的 snapshot。';

  @override
  String get p2pSyncRequestedThroughTheEncryptedChannelWaiting =>
      '已透過加密通道送出同步要求；等待接收端下載並選擇儲存位置。';

  @override
  String p2pCouldNotSendASyncRequest(String p1) {
    return '無法送出同步要求：$p1';
  }

  @override
  String get p2pThePeerRequestedSyncThroughTheEncrypted =>
      '對方已透過加密通道要求同步；正在準備下載 snapshot。';

  @override
  String get p2pRejectedARemoteAcknowledgementWithAMismatched =>
      '已拒絕身分或 project session 不一致的遠端 ACK。';

  @override
  String get p2pReceivedThePeerSResolutionAcknowledgementWaiting =>
      '已收到對方 resolve ACK；等待已驗證 revision graph 完成後確認。';

  @override
  String get p2pRejectedAnAcknowledgementWhoseContentOrParent =>
      '已拒絕內容或 parent 與本機 resolve revision 不一致的遠端 ACK。';

  @override
  String get p2pThePeerAcknowledgedTheResolutionRevisionBoth =>
      '對方已 ACK resolve revision；雙方 revision DAG 已收斂。';

  @override
  String get p2pRejectedAnAcknowledgementAbsentFromThePeer =>
      '已拒絕未包含於對方已驗證 revision graph 的遠端 ACK。';

  @override
  String get p2pThePeerAcknowledgedTheRemoteResolutionRevision =>
      '對方已 ACK 遠端 resolve revision；等待下載並安裝該 revision。';

  @override
  String get p2pCreatedAPairingChallengeValidForTen =>
      '已建立十分鐘有效的配對 challenge，等待對方開始配對。';

  @override
  String p2pCouldNotStartSecurePairing(String p1) {
    return '無法開始安全配對：$p1';
  }

  @override
  String get p2pThisDeviceSignedItsConfirmationWaitingFor =>
      '本機已簽署確認；等待對方驗證後自動回簽。';

  @override
  String get p2pThisDeviceSignedAndTrustedThePeer =>
      '本機已簽署確認並加入信任清單；等待對方手動確認同一配對 transcript。';

  @override
  String p2pCouldNotSaveTheTrustedDevice(String p1) {
    return '儲存信任裝置失敗：$p1';
  }

  @override
  String get p2pPairingCancelled => '已取消本次配對。';

  @override
  String get p2pPairingConfirmationSettingsChangedStartPairingAgain =>
      '配對確認設定已變更；請重新開始配對。';

  @override
  String p2pCouldNotLoadRevisionMetadata(String p1) {
    return '無法載入 revision metadata：$p1';
  }

  @override
  String get p2pCouldNotCreateARevisionInvalidProject =>
      '無法建立 revision：project UUID 無效。';

  @override
  String get p2pNewRevisionSavedNotifyingThePeerThrough =>
      '已儲存新 revision；正在透過加密通道即時通知對方同步。';

  @override
  String p2pCouldNotCreateRevisionMetadata(String p1) {
    return '無法建立 revision metadata：$p1';
  }

  @override
  String get p2pDraftRevisionCreatedSendingItsSummaryThrough =>
      'draft revision 已建立；正在透過加密通道傳送 summary。';

  @override
  String get p2pDraftRevisionCreatedSendingItsSummaryAnd =>
      'draft revision 已建立；正在透過加密通道傳送 summary/delta。';

  @override
  String p2pCouldNotCreateADraftRevision(String p1) {
    return '無法建立 draft revision：$p1';
  }

  @override
  String p2pRejectedAnInvalidRevisionDeltaFallingBack(String p1) {
    return '已拒絕無效的 revision delta，將改用完整 snapshot：$p1';
  }

  @override
  String p2pCouldNotSaveRemoteHistory(String p1) {
    return '無法保存遠端歷史：$p1。';
  }

  @override
  String p2pRemoteSnapshotOpenedButItsRevisionGraph(String p1) {
    return '遠端 snapshot 已開啟，但保存 revision DAG 失敗：$p1';
  }

  @override
  String get p2pCouldNotStageTheRemoteConflictSnapshot =>
      '無法暫存遠端 conflict snapshot：session 或 DAG 已失效。';

  @override
  String p2pCouldNotStageTheRemoteConflictSnapshot2(String p1) {
    return '無法暫存遠端 conflict snapshot：$p1';
  }

  @override
  String get p2pMultipleMaximalCommonAncestorsFoundARecursive =>
      '偵測到多個 maximal common ancestors；必須先取得 recursive merge base，未進行猜測式合併。';

  @override
  String get p2pCouldNotPrepareFieldMergingTheAuthenticated =>
      '無法建立欄位合併：authenticated session 或 concurrent heads 已失效。';

  @override
  String p2pCouldNotPrepareProjectFieldMerging(String p1) {
    return '無法建立 ProjectData 欄位合併：$p1';
  }

  @override
  String get p2pCreatedAResolutionRevisionWithTwoParents =>
      '已建立雙 parent resolve revision；等待透過加密通道傳播。';

  @override
  String p2pCouldNotCreateAResolutionRevision(String p1) {
    return '無法建立 resolve revision：$p1';
  }

  @override
  String get p2pRespondedAutomaticallyToThePeerSSecure =>
      '已自動回應對方的安全配對要求，正在建立比較碼。';

  @override
  String p2pCouldNotAutomaticallyCreateALocalPairing(String p1) {
    return '無法自動建立本機 pairing challenge：$p1';
  }

  @override
  String get p2pPairingChallengeRefreshedAutomaticallyWaitingForThe =>
      '配對 challenge 已自動更新；等待對方取得新比較碼。';

  @override
  String p2pCouldNotRefreshThePairingChallenge(String p1) {
    return '無法更新配對 challenge：$p1';
  }

  @override
  String get p2pThePeerChangedItsSyncDocumentDisconnected => '對方已更換同步文件，連線已中斷。';

  @override
  String get p2pThisDeviceChangedItsSyncDocumentDisconnected =>
      '本機已更換同步文件，連線已中斷。';

  @override
  String p2pCouldNotInitializeTheDeviceSSecure(String p1) {
    return '無法初始化裝置安全身分：$p1';
  }

  @override
  String p2pCouldNotObtainALocalLANIP(String p1) {
    return '無法取得本機 LAN IP：$p1';
  }

  @override
  String get p2pStartingLocalService => '正在開啟本機服務…';

  @override
  String get p2pLocalEndpointReadySecurePairingEnablesEncrypted =>
      '本機端點已開啟；完成安全配對後可交換加密 revision 與 snapshot chunks。';

  @override
  String p2pCouldNotOpenPort(String p1, String p2) {
    return '無法開啟 Port $p1：$p2';
  }

  @override
  String get p2pStoppingLocalService => '正在停止本機服務…';

  @override
  String get p2pLocalServiceStopped => '本機服務已停止。';

  @override
  String p2pCouldNotStopLocalService(String p1) {
    return '停止本機服務失敗：$p1';
  }

  @override
  String p2pTesting(String p1, String p2) {
    return '正在測試 $p1:$p2…';
  }

  @override
  String get p2pEndpointReachableSecurePairingIsRequiredTo =>
      '端點可達；完成安全配對後才會啟用加密內容通道。';

  @override
  String p2pCouldNotConnectTo(String p1, String p2) {
    return '無法連線至 $p1：$p2';
  }

  @override
  String p2pConnectingAndNegotiatingTheSyncDocumentAt(String p1, String p2) {
    return '正在連線並協商同步文件 $p1:$p2…';
  }

  @override
  String get p2pThisDeviceWillProvideTheSyncDocument => '已選擇由本機提供同步文件。';

  @override
  String get p2pThePeerWillProvideTheSyncDocument => '已選擇由對方提供同步文件。';

  @override
  String get p2pPeerDisconnectedTheLocalServiceIsStill =>
      '已中斷目前 peer；本機服務仍在監聽。';

  @override
  String get p2pPeerDisconnected => '已中斷目前 peer。';

  @override
  String get p2pNoRemoteSnapshotIsAvailableForDownload =>
      '目前沒有可在已驗證連線中下載的遠端 snapshot。';

  @override
  String get p2pReconstructingOrDownloadingAndVerifyingTheSnapshot =>
      '正在透過 authenticated encrypted transport 重建或下載並驗證 snapshot…';

  @override
  String get p2pSnapshotChunksSHAXMLUUIDAndVersion =>
      'snapshot 已完成 chunk、SHA-256、XML、UUID 與版本驗證；尚未寫入專案。';

  @override
  String get p2pSnapshotReconstructedFromAnEncryptedDeltaSHA =>
      'snapshot 已由加密 delta 重建，並完成 SHA-256、XML、UUID 與版本驗證；尚未寫入專案。';

  @override
  String get p2pSnapshotDownloadCancelled => 'snapshot 下載已取消。';

  @override
  String p2pSnapshotDownloadOrVerificationFailed(String p1) {
    return 'snapshot 下載或驗證失敗：$p1';
  }

  @override
  String get p2pRevisionsDivergedResolveConflictsFieldByField =>
      '雙方 revisions concurrent；必須完成逐欄 conflict resolution，不能直接覆寫本機文件。';

  @override
  String get p2pTheVerifiedSnapshotIsNoLongerValid =>
      '已驗證 snapshot 已失效；請重新建立安全連線後下載。';

  @override
  String get p2pNoVerifiedRevisionGraphContainingThisSnapshot =>
      '尚未取得包含此 snapshot 的已驗證 revision graph；未寫入專案。';

  @override
  String get p2pAuthenticatedSnapshotSessionCapabilityIsMissingThe =>
      'authenticated snapshot session capability 不存在；未寫入專案。';

  @override
  String get p2pWaitingToConfirmTheSaveLocationAnd => '等待確認儲存位置並安全開啟 snapshot…';

  @override
  String get p2pTheSyncSessionChangedSnapshotApplicationTo =>
      '同步 session 已變更；已停止將 snapshot 套用至編輯器。';

  @override
  String get p2pSnapshotSavedAndOpenedButRemoteRevision =>
      'snapshot 已另存並開啟，但遠端 revision 歷史尚未保存；請勿繼續編輯並重試同步。';

  @override
  String get p2pRemoteSnapshotSavedAndOpened => '遠端 snapshot 已另存並開啟。';

  @override
  String get p2pApplicationCancelledVerificationResultsRemainInMemory =>
      '已取消套用；驗證結果仍保留在記憶體中。';

  @override
  String p2pCouldNotSaveOrOpenTheSnapshot(String p1) {
    return '無法儲存或開啟 snapshot：$p1';
  }

  @override
  String get p2pConcurrentSnapshotsMergedFieldByFieldAnd =>
      'concurrent snapshot 已完成逐欄合併並建立 resolve revision。';

  @override
  String get p2pSnapshotTransferCancelled => 'snapshot 傳輸已取消。';

  @override
  String get p2pConnectionDocumentOrRevisionChangedThePrevious =>
      '連線、文件或 revision 已變更；舊 snapshot 已失效。';

  @override
  String get p2pBothUUIDsMatchTheSameSyncDocument => '雙方 UUID 相同，已選定同一份同步文件。';

  @override
  String get p2pThePeerHasNoTargetDocumentThis => '對方沒有目標文件，將由本機提供文件。';

  @override
  String get p2pThisDeviceHasNoTargetDocumentThe => '本機沒有目標文件，將由對方提供文件。';

  @override
  String get p2pNeitherDeviceHasASyncDocumentChoose => '雙方都沒有可同步文件，需要先決定文件。';

  @override
  String get p2pTheDocumentUUIDsDifferChooseWhichDocument =>
      '雙方文件 UUID 不同，需要選擇同步文件。';

  @override
  String paletteGraySemantics(String value) {
    return '灰階，明度 $value%';
  }

  @override
  String paletteColorSemantics(String hue, String saturation, String value) {
    return '色相 $hue 度，飽和度 $saturation%，明度 $value%';
  }

  @override
  String revisionCheckpointLabel(String timestamp) {
    return '檢查點 $timestamp';
  }

  @override
  String get projectErrorAccessDenied => '無法存取檔案。請重新選取原檔案以恢復授權，或使用「另存新檔」保留變更。';

  @override
  String get projectErrorFileMissing => '找不到檔案。請確認檔案是否已移動或刪除。';

  @override
  String get projectErrorInvalidPath => '檔案路徑無效，請重新選取檔案或儲存位置。';

  @override
  String get projectErrorInvalidData => '專案資料格式無效，請檢查檔案或從備份還原。';

  @override
  String get projectErrorCancelled => '已取消檔案操作，尚未儲存變更。';

  @override
  String get projectErrorNoSaveLocation => '專案尚未指定儲存位置，請先儲存或另存新檔。';

  @override
  String get projectErrorNoSpace => '儲存空間不足，請釋放空間或選擇其他儲存位置。';

  @override
  String get projectErrorBackupLimit => '專案超過備份容量上限，請到設定提高上限。';

  @override
  String get projectErrorUnsupported => '此平台不支援這項檔案操作。';

  @override
  String get projectErrorDuplicateIdentity => '資料包含空白或重複的識別碼，請重新開啟專案以修復章節樹。';

  @override
  String get projectErrorTreeTooDeep => '樹狀結構超過 256 層，請減少巢狀深度後重試。';

  @override
  String get projectErrorExportFormat => '匯出用途、格式或範圍不相容，或此格式尚未支援。';

  @override
  String get projectErrorExportSelection => '匯出選取範圍無效，請重新選取至少一個項目。';

  @override
  String get projectErrorExportEmpty => '所選範圍沒有可匯出的內容，請重新選取。';

  @override
  String get projectErrorMissingItemDefinition => '物品缺少定義，請修復物品資料後再匯出。';

  @override
  String get projectErrorProjectChanged => '來源專案已切換，請重新開啟匯出視窗。';

  @override
  String get projectErrorUnknown => '操作未完成。變更仍保留在編輯器中，請重試或另存新檔。';

  @override
  String get copilotErrorInvalidConfiguration => '模型服務不接受此請求的格式或參數，請檢查設定。';

  @override
  String get copilotErrorAuthenticationFailed => 'API Key 無效或已失效，請檢查憑證設定。';

  @override
  String get copilotErrorPermissionDenied => '模型服務拒絕此憑證或模型的存取權限。';

  @override
  String get copilotErrorRateLimited => '模型服務目前請求過多或額度不足，請稍後重試。';

  @override
  String get copilotErrorModelUnavailable => '找不到指定模型或 API endpoint，請重新選擇模型。';

  @override
  String get copilotErrorContextTooLarge => '傳送內容超過模型服務限制，請縮小上下文範圍。';

  @override
  String get copilotErrorResponseTooLarge => '模型回覆超過允許的大小上限。';

  @override
  String get copilotErrorRequestTimedOut => 'Copilot 請求逾時，請稍後重試。';

  @override
  String get copilotErrorInvalidResponse => '模型回覆格式無法解析，請重試或更換模型。';

  @override
  String get copilotErrorNetworkUnavailable =>
      'Copilot 請求失敗，請檢查網路、API URL、模型與憑證設定。';

  @override
  String get copilotErrorServiceUnavailable => '模型服務暫時無法使用，請稍後重試。';

  @override
  String get copilotErrorValidation => '請確認目前章節、所選資源及 API URL 設定後重試。';

  @override
  String get uiImplicitMention => '隱式提及';

  @override
  String get paletteSearchRange => '搜尋範圍';

  @override
  String get paletteRangePrecise => '較精確';

  @override
  String get paletteRangeDefault => '適中';

  @override
  String get paletteRangeBroad => '較寬鬆';

  @override
  String get paletteNoNearbyEntries => '範圍內沒有相近詞條';

  @override
  String get paletteOutsideRange => '最近的詞條（超出範圍）';

  @override
  String get paletteInvalidHex => '請輸入六位 HEX 色碼';

  @override
  String get projectDefaultStorylineName => '序章';

  @override
  String get projectDefaultStorylineType => '開場';

  @override
  String get projectDefaultLocationName => '主要場景';

  @override
  String get projectDefaultTimelineTrackName => '時間軸 1';

  @override
  String get projectDefaultTimelineOriginLabel => '故事開始';

  @override
  String get projectDefaultUntitledTrackName => '未命名軌道';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');
}
