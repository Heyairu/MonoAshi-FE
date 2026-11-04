// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Monogatari Assistant';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDescription => 'Make your writing workspace your own';

  @override
  String get generalSettingsTitle => 'General';

  @override
  String get generalSettingsDescription => 'Exit confirmation and language';

  @override
  String get exitWarningTitle => 'Confirm before exiting';

  @override
  String get exitWarningDescription =>
      'Ask to save unsaved changes before closing the app';

  @override
  String get languageTitle => 'Display language';

  @override
  String get languageSystem => 'Follow system';

  @override
  String get languageHelp =>
      'Changes apply immediately and are saved automatically. Project content keeps its original language.';

  @override
  String get languageSaveFailed =>
      'Could not save the language. Your last saved choice has been restored. Please try again.';

  @override
  String initializationFailed(String error) {
    return 'Initialization failed: $error';
  }

  @override
  String get oobeStepWelcome => 'Welcome';

  @override
  String get oobeStepAppearance => 'Appearance';

  @override
  String get oobeStepStorage => 'Storage and backup';

  @override
  String get oobeStepName => 'Your name';

  @override
  String get oobeStepWorkspace => 'Getting started';

  @override
  String get oobeStepComplete => 'All set!';

  @override
  String get oobeTitleWelcome => 'Hello! Welcome to MonoAshi';

  @override
  String get oobeTitleAppearance => 'Appearance and controls';

  @override
  String get oobeTitleStorage => 'Files and automatic backups';

  @override
  String get oobeTitleName => 'Your name';

  @override
  String get oobeTitleWorkspace => 'Start your first story';

  @override
  String get oobeTitleComplete => 'Thank you!';

  @override
  String get oobeWelcomeThanks => 'Thank you for choosing MonoAshi.';

  @override
  String get oobeWelcomeTime => 'Take a few minutes to set up your app.';

  @override
  String get oobeWelcomeDescription =>
      'The next steps will help you adjust the interface, choose storage preferences, and explore your writing workspace.';

  @override
  String get oobeNext => 'Next  ›';

  @override
  String get oobeBack => 'Back';

  @override
  String get oobeSkip => 'Skip';

  @override
  String get oobeStart => 'Start writing';

  @override
  String get oobeContinueHint => 'Select Next to continue.';

  @override
  String get oobeCompleteHint => 'Setup complete!';

  @override
  String get oobeSaveFailed =>
      'Your settings could not be saved. Please try again.';

  @override
  String oobeProgressSemantics(int step, String title) {
    return 'Step $step, $title';
  }

  @override
  String get uiSaveFile => 'Save File';

  @override
  String get uiNewFile => 'New File';

  @override
  String get uiOpenFile => 'Open File';

  @override
  String get uiSaveAs => 'Save As';

  @override
  String get uiImport => 'Import';

  @override
  String get uiExport => 'Export';

  @override
  String get editorSelectAll => 'Select All';

  @override
  String get editorCut => 'Cut';

  @override
  String get commonCopy => 'Copy';

  @override
  String get editorPaste => 'Paste';

  @override
  String get editorUndo => 'Undo';

  @override
  String get editorRedo => 'Redo';

  @override
  String get uiPhraseLibrary => 'Phrase Library';

  @override
  String get uiInsertPhrase => 'Insert Phrase';

  @override
  String get uiOpenTheManuscriptEditorFirst =>
      'Open the manuscript editor first.';

  @override
  String get uiSaveSelectionAsPhrase => 'Save Selection as Phrase';

  @override
  String get uiPunctuation => 'Punctuation';

  @override
  String get uiSearch => 'Search';

  @override
  String get uiNavigation => 'Navigation';

  @override
  String get uiSidebar => 'Sidebar';

  @override
  String get uiDashboard => 'Dashboard';

  @override
  String get uiMatchCase => 'Match case';

  @override
  String get uiWholeWords => 'Whole words';

  @override
  String get uiRegularExpression => 'Regular expression';

  @override
  String get uiMatchCharacterWidth => 'Match character width';

  @override
  String get uiIgnorePunctuation => 'Ignore punctuation';

  @override
  String get uiIgnoreWhitespace => 'Ignore whitespace';

  @override
  String get uiRegularExpressionsAlwaysMatchCaseAndCharacterWidth =>
      'Regular expressions always match case and character width; whole-word matching is disabled.';

  @override
  String get uiWholeWordMatchingIsUnavailableWhenTheQuery =>
      'Whole-word matching is unavailable when the query contains full-width characters, punctuation, or whitespace.';

  @override
  String uiCouldNotCompletePleaseTryAgain(String p1) {
    return 'Could not complete “$p1”. Please try again.';
  }

  @override
  String get uiFile => 'File';

  @override
  String get uiProject => 'Project';

  @override
  String get uiDataExchange => 'Data Exchange';

  @override
  String get uiHome => 'Home';

  @override
  String get uiClipboard => 'Clipboard';

  @override
  String get uiHistory => 'History';

  @override
  String get uiWritingTools => 'Writing Tools';

  @override
  String get uiPhrases => 'Phrases';

  @override
  String get uiWorkspacePanels => 'Workspace Panels';

  @override
  String get uiFindAndReplace => 'Find and Replace';

  @override
  String get uiMatchOptions => 'Match Options';

  @override
  String get uiSearchMethod => 'Search Method';

  @override
  String get uiOn => 'On';

  @override
  String get uiOff => 'Off';

  @override
  String get uiToolbarMode => 'Toolbar Mode';

  @override
  String get uiAutomaticFullOnDesktopModerateOnMobile =>
      'Automatic (Full on desktop, Moderate on mobile)';

  @override
  String get uiHelp => 'Help';

  @override
  String get uiHelpHome => 'Help Home';

  @override
  String get uiHelpForThisFeatureF1 => 'Help for This Feature (F1)';

  @override
  String get uiWhatSThisShiftF1 => 'What’s This? (Shift+F1)';

  @override
  String get uiEnterAlternativeDisplayTextNotAddedAsAn =>
      'Enter alternative display text (not added as an alias)';

  @override
  String get uiInsert => 'Insert';

  @override
  String get uiDisplayText => 'Display Text';

  @override
  String get uiAddAlias => 'Add Alias';

  @override
  String get uiCharacter => 'Character';

  @override
  String get uiLocation => 'Location';

  @override
  String get uiEvent => 'Event';

  @override
  String get uiForeshadowing => 'Foreshadowing';

  @override
  String get uiPlan => 'Plan';

  @override
  String get uiItem => 'Item';

  @override
  String get uiKeyPoint => 'Key Point';

  @override
  String uiAdd(String p1) {
    return 'Add $p1';
  }

  @override
  String get commonCancel => 'Cancel';

  @override
  String get uiTheManuscriptHasChangedSelectThePhraseAgain =>
      'The manuscript has changed. Select the phrase again.';

  @override
  String uiCouldNotInsertThePhrase(String p1) {
    return 'Could not insert the phrase: $p1';
  }

  @override
  String uiRelink(String p1) {
    return 'Relink “$p1”';
  }

  @override
  String get uiSearchTargets => 'Search Targets';

  @override
  String get uiCancelInsertion => 'Cancel Insertion';

  @override
  String get uiConvertToPlainText => 'Convert to Plain Text';

  @override
  String get uiSelectManuscriptTextToSaveAsAPhrase =>
      'Select manuscript text to save as a phrase first.';

  @override
  String get uiNoPhrasesAreAvailableAddAPhraseIn =>
      'No phrases are available. Add a phrase in the phrase library first.';

  @override
  String get uiMissingTarget => 'Missing Target';

  @override
  String uiOriginalNameNotes(String p1, String p2) {
    return 'Original name: $p1\nNotes: $p2';
  }

  @override
  String get uiNone => 'None';

  @override
  String get uiAddMention => 'Add Mention';

  @override
  String get uiSaveAsPhrase => 'Save as Phrase';

  @override
  String get uiDonTAskAgain => 'Don’t ask again';

  @override
  String get uiDonTSave => 'Don’t Save';

  @override
  String get commonSave => 'Save';

  @override
  String get uiUnsavedChanges => 'Unsaved Changes';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeExiting =>
      'You have unsaved changes. Save before exiting?';

  @override
  String get uiVersionCompatibilityWarning => 'Version Compatibility Warning';

  @override
  String uiThisFileSVersionIsNewerThanThe(String p1, String p2) {
    return 'This file’s version ($p1) is newer than the supported version ($p2).\nOpening and saving it may lose some data.\n\nOpen it anyway?';
  }

  @override
  String get uiOpenAnyway => 'Open Anyway';

  @override
  String get uiCreateProject => 'Create Project';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeCreatingA =>
      'You have unsaved changes. Save before creating a new project?';

  @override
  String get uiProjectCreated => 'Project created.';

  @override
  String uiCouldNotCreateTheProject(String p1) {
    return 'Could not create the project: $p1';
  }

  @override
  String get uiOpenProject => 'Open Project';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeOpeningAnother =>
      'You have unsaved changes. Save before opening another project?';

  @override
  String get uiOpeningTheNewerFileWasCancelled =>
      'Opening the newer file was cancelled.';

  @override
  String uiProjectOpened(String p1) {
    return 'Project opened: $p1';
  }

  @override
  String uiCouldNotOpenTheProject(String p1) {
    return 'Could not open the project: $p1';
  }

  @override
  String get uiOpenRecentProject => 'Open Recent Project';

  @override
  String get uiYouHaveUnsavedChangesSaveBeforeOpeningA =>
      'You have unsaved changes. Save before opening a recent project?';

  @override
  String uiCouldNotOpenTheRecentProject(String p1) {
    return 'Could not open the recent project: $p1';
  }

  @override
  String get uiProjectSaved => 'Project saved.';

  @override
  String uiCouldNotSaveTheProject(String p1) {
    return 'Could not save the project: $p1';
  }

  @override
  String uiProjectSavedAs(String p1) {
    return 'Project saved as: $p1';
  }

  @override
  String uiCouldNotSaveTheProjectAsANew(String p1) {
    return 'Could not save the project as a new file: $p1';
  }

  @override
  String uiInvalidRegularExpression(String p1) {
    return 'Invalid regular expression: $p1';
  }

  @override
  String uiReplaceAllFailed(String p1) {
    return 'Replace All failed: $p1';
  }

  @override
  String get uiInvalidFormat => 'Invalid format';

  @override
  String uiInvalidRegularExpression2(String p1) {
    return 'Invalid regular expression: $p1';
  }

  @override
  String uiReplaceAllCancelledMoreThanMatchesNarrowYour(String p1) {
    return 'Replace All cancelled: more than $p1 matches. Narrow your search.';
  }

  @override
  String get uiReplaceAllCancelledTheResultingTextIsToo =>
      'Replace All cancelled: the resulting text is too large. Process smaller sections.';

  @override
  String get uiReplaceAllCancelledTheTimeLimitWasExceeded =>
      'Replace All cancelled: the time limit was exceeded. Narrow your search.';

  @override
  String get uiConfirmLargeReplacement => 'Confirm Large Replacement';

  @override
  String uiMatchesToReplaceEstimatedResultMiBContinue(String p1, String p2) {
    return 'Matches to replace: $p1. Estimated result: $p2 MiB. Continue?';
  }

  @override
  String get uiContinueReplacing => 'Continue Replacing';

  @override
  String get uiReplaceAllCancelledAnnotationRangesCouldNotBe =>
      'Replace All cancelled: annotation ranges could not be mapped safely.';

  @override
  String get uiReplaceAllCancelledRegularExpressionAnnotationRangesCould =>
      'Replace All cancelled: regular-expression annotation ranges could not be mapped safely.';

  @override
  String get uiReplaceAllCancelledAnnotationProjectionValidationFailed =>
      'Replace All cancelled: annotation projection validation failed.';

  @override
  String get uiSearch2 => 'Search…';

  @override
  String get uiPrevious => 'Previous';

  @override
  String get uiNext => 'Next';

  @override
  String get uiCollapse => 'Collapse';

  @override
  String get uiExpandReplace => 'Expand Replace';

  @override
  String get uiSearchOptions => 'Search Options';

  @override
  String get uiReplaceWith => 'Replace with…';

  @override
  String get uiReplace => 'Replace';

  @override
  String get uiAll => 'All';

  @override
  String get uiFind => 'Find:';

  @override
  String get uiCollapse2 => 'Collapse';

  @override
  String get uiReplaceWith2 => 'Replace with:';

  @override
  String get uiReplaceAll => 'Replace All';

  @override
  String get uiFullWidth => 'Full-width';

  @override
  String get uiHalfWidth => 'Half-width';

  @override
  String get uiFeatures => 'Features';

  @override
  String get uiEditor => 'Editor';

  @override
  String get uiFull => 'Full';

  @override
  String get uiHalf => 'Half';

  @override
  String get uiExpandNavigation => 'Expand Navigation';

  @override
  String get uiCloseNavigation => 'Close Navigation';

  @override
  String get uiHelpModule => 'Help Module';

  @override
  String get uiCollapseNavigation => 'Collapse Navigation';

  @override
  String get uiPinNavigation => 'Pin Navigation';

  @override
  String get uiOvertypeModeIns => 'Overtype Mode (Ins)';

  @override
  String get uiInsertModeIns => 'Insert Mode (Ins)';

  @override
  String uiCharacters(String p1, String p2) {
    return '$p1 / $p2 characters';
  }

  @override
  String get uiIndentLineStart => 'Indent Line Start';

  @override
  String get uiInsertSpacesWithTab => 'Insert Spaces with Tab';

  @override
  String uiEnterFirst(String p1) {
    return 'Enter $p1 first.';
  }

  @override
  String get uiCannotAddRightNow => 'Cannot add right now';

  @override
  String get uiConvertToItemLink => 'Convert to Item Link';

  @override
  String get uiQuillPlainTextManuscriptPreview =>
      'Quill Plain-Text Manuscript Preview';

  @override
  String uiAnnotation(String p1, String p2) {
    return '$p1 annotation: $p2';
  }

  @override
  String uiSCursor(String p1) {
    return '$p1’s cursor';
  }

  @override
  String get uiSelectAControlToViewHelpEscCancels =>
      'Select a control to view help; Esc cancels';

  @override
  String get uiHelpCenter => 'Help Center';

  @override
  String get uiCloseHelpEsc => 'Close Help (Esc)';

  @override
  String get uiPreviousPage => 'Previous Page';

  @override
  String get uiNextPage => 'Next Page';

  @override
  String get uiReadArticle => 'Read Article';

  @override
  String get uiContentsAndSearch => 'Contents and Search';

  @override
  String get uiSearchHelp => 'Search Help';

  @override
  String get uiCouldNotLoadOfflineHelpPleaseTryAgain =>
      'Could not load offline help. Please try again.';

  @override
  String get commonRetry => 'Retry';

  @override
  String get uiNoMatchingHelpTopics => 'No matching help topics';

  @override
  String get uiBackToContents => 'Back to Contents';

  @override
  String get uiRelatedTopics => 'Related Topics';

  @override
  String get uiInvalidAnnotationSyntaxCorrectItBeforeApplying =>
      'Invalid annotation syntax. Correct it before applying.';

  @override
  String get commonClose => 'Close';

  @override
  String get uiNotes => 'Notes';

  @override
  String get uiType => 'Type';

  @override
  String get uiTarget => 'Target';

  @override
  String get uiStatus => 'Status';

  @override
  String get uiColor => 'Color';

  @override
  String get uiOpenNode => 'Open Node';

  @override
  String get uiEditAnnotation => 'Edit Annotation';

  @override
  String get uiApply => 'Apply';

  @override
  String get uiMoreAnnotationActions => 'More Annotation Actions';

  @override
  String get uiUpdateToCurrentName => 'Update to Current Name';

  @override
  String get uiRelinkMissingTarget => 'Relink Missing Target';

  @override
  String get uiRemoveAnnotationKeepText => 'Remove Annotation, Keep Text';

  @override
  String get uiHighlight => 'Highlight';

  @override
  String get uiFullSyntax => 'Full Syntax';

  @override
  String get uiCopySyntax => 'Copy Syntax';

  @override
  String get uiGeneral => 'General';

  @override
  String get uiStart => 'Start';

  @override
  String get uiEnd => 'End';

  @override
  String get uiThisAnnotationTypeRequiresAUUID =>
      'This annotation type requires a UUID.';

  @override
  String uiInvalidAnnotationData(String p1) {
    return 'Invalid annotation data: $p1';
  }

  @override
  String get uiBackgroundColorCode => 'Background Color Code';

  @override
  String get uiTextColorCode => 'Text Color Code';

  @override
  String get uiNotesOptional => 'Notes (optional)';

  @override
  String get uiEditingThisFieldAppliesTheFullSyntaxIn =>
      'Editing this field applies the full syntax in preference to other fields.';

  @override
  String get uiAutomatic => '0 (automatic)';

  @override
  String get uiSearchNamePathOrUUID => 'Search name, path, or UUID';

  @override
  String get uiNoMatchingLinkTargets => 'No matching link targets';

  @override
  String get uiUntitled => '(Untitled)';

  @override
  String uiShowingTheFirstResultsEnterKeywordsToNarrow(String p1) {
    return 'Showing the first $p1 results. Enter keywords to narrow the list.';
  }

  @override
  String get uiCouldNotReadInitialSetupPleaseTryAgain =>
      'Could not read initial setup. Please try again.';

  @override
  String get uiCouldNotReadTheBackupLocationSelectTo =>
      'Could not read the backup location. Select to retry.';

  @override
  String get uiChooseAutomaticBackupFolder => 'Choose Automatic Backup Folder';

  @override
  String get uiCouldNotSelectAFolderPleaseTryAgain =>
      'Could not select a folder. Please try again.';

  @override
  String get uiChooseHowYouPreferToReadAndWork =>
      'Choose how you prefer to read and work. You can change these options later in Settings.';

  @override
  String get uiInterfaceTheme => 'Interface Theme';

  @override
  String uiUseTheTheme(String p1) {
    return 'Use the $p1 theme';
  }

  @override
  String get uiSideNavigation => 'Side Navigation';

  @override
  String get uiYourWorkIsSavedAsAMnprojProject =>
      'Your work is saved as a .mnproj project file at the location you choose. Enable the following features to suit your writing habits.';

  @override
  String get uiAutoSave => 'Auto Save';

  @override
  String uiSaveToTheCurrentProjectFileEveryMinutes(String p1) {
    return 'Save to the current project file every $p1 minutes. Save manually once to choose its location first.';
  }

  @override
  String get uiSaveInterval => 'Save Interval';

  @override
  String uiMinutes(String p1) {
    return '$p1 minutes';
  }

  @override
  String get uiAutomaticBackup => 'Automatic Backup';

  @override
  String uiCreateASeparateBackupEveryMinutesWithoutChanging(String p1) {
    return 'Create a separate backup every $p1 minutes without changing the project location. Manage backups in Settings.';
  }

  @override
  String get uiBackupInterval => 'Backup Interval';

  @override
  String get uiManageTheAutomaticBackupFolderInSettingsOn =>
      'Manage the automatic backup folder in Settings on this platform.';

  @override
  String get uiThisAppWorksOfflineRememberToSaveNew =>
      'This app works offline. Remember to save new projects using Save.';

  @override
  String get uiYourNameAppearsInTheWelcomeMessageOn =>
      'Your name appears in the welcome message on the home page. Enter the name you would like to use, or skip this step.';

  @override
  String get uiNameOptional => 'Name (optional)';

  @override
  String get uiEnterYourNameOrPenName => 'Enter your name or pen name';

  @override
  String get uiExampleAzusaNakano => 'Example: Azu-nyan';

  @override
  String get uiUseAsDefaultPenName => 'Use as Default Pen Name';

  @override
  String get uiFillInTheAuthorAutomaticallyWhenCreatingA =>
      'Fill in the author automatically when creating a project.';

  @override
  String get uiFromTheWorkspaceHomePageCreateAProject =>
      'From the workspace home page, create a project or open an existing .mnproj file.';

  @override
  String get uiCreateYourWork => '01  Create Your Work';

  @override
  String get uiCreateAProjectAndEnterItsTitleAnd =>
      'Create a project and enter its title and basic story information.';

  @override
  String get uiWriteYourFirstChapter => '02  Write Your First Chapter';

  @override
  String get uiAddFoldersAndChaptersInChaptersThenSelect =>
      'Add folders and chapters in Chapters, then select a chapter to start writing.';

  @override
  String get uiBuildYourStoryWorld => '03  Build Your Story World';

  @override
  String get uiOrganizeYourStoryWithOutlinesCharactersWorldbuildingAnd =>
      'Organize your story with outlines, characters, worldbuilding, and timelines. Open the guide from Help when you need it.';

  @override
  String get uiYouReReadyToBeginHereIsA =>
      'You’re ready to begin! Here is a summary of your setup:';

  @override
  String uiName(String p1) {
    return 'Name: $p1';
  }

  @override
  String get uiNotSet => 'Not Set';

  @override
  String uiDefaultPenName(String p1) {
    return 'Default pen name: $p1';
  }

  @override
  String get uiYes => 'Yes';

  @override
  String get uiNo => 'No';

  @override
  String uiTheme(String p1) {
    return 'Theme: $p1';
  }

  @override
  String uiThemeColor(String p1) {
    return 'Theme color: $p1';
  }

  @override
  String uiTextSize(String p1) {
    return 'Text size: $p1';
  }

  @override
  String uiNavigation2(String p1) {
    return 'Navigation: $p1';
  }

  @override
  String uiRibbonMode(String p1) {
    return 'Ribbon mode: $p1';
  }

  @override
  String uiAutomatic2(String p1) {
    return 'Automatic ($p1)';
  }

  @override
  String uiAutoSave2(String p1) {
    return 'Auto save: $p1';
  }

  @override
  String uiEveryMinutes(String p1) {
    return 'Every $p1 minutes';
  }

  @override
  String uiAutomaticBackup2(String p1) {
    return 'Automatic backup: $p1';
  }

  @override
  String uiAutomaticBackupFolder(String p1) {
    return 'Automatic backup folder: $p1';
  }

  @override
  String get uiUseDefaultBackupFolder => 'Use Default Backup Folder';

  @override
  String get uiChangeAppearanceAndStorageOptionsInSettingsReopen =>
      'Change appearance and storage options in Settings. Reopen initial setup to change your name.';

  @override
  String get uiRibbonMode2 => 'Ribbon Mode';

  @override
  String get uiAutomatic3 => 'Automatic';

  @override
  String get uiChooseByDeviceFullOnDesktopModerateOn =>
      'Choose by device: Full on desktop, Moderate on mobile.';

  @override
  String uiAutomaticallyUsing(String p1, String p2) {
    return 'Automatically using $p1: $p2';
  }

  @override
  String get uiThemeColor2 => 'Theme Color';

  @override
  String uiTextSizeSp(String p1) {
    return 'Text Size  ${p1}sp';
  }

  @override
  String get uiAutomaticBackupFolder2 => 'Automatic Backup Folder';

  @override
  String get uiChooseFolder => 'Choose Folder';

  @override
  String get uiResetToDefault => 'Reset to Default';

  @override
  String get uiMonogatariAssistant => 'Monogatari Assistant';

  @override
  String get uiDeletePhrase => 'Delete Phrase?';

  @override
  String uiRemoveShortcutFromThePhraseLibrary(String p1) {
    return 'Remove shortcut “$p1” from the phrase library.';
  }

  @override
  String get commonDelete => 'Delete';

  @override
  String get uiPhraseLibraryExported => 'Phrase library exported.';

  @override
  String uiShortcutConflicts(String p1) {
    return 'Shortcut “$p1” conflicts';
  }

  @override
  String uiTheImportedPhraseHasTheSameIDOr(String p1, String p2) {
    return 'The imported phrase has the same ID or shortcut as an existing phrase:\n$p1\n\nKeep the existing phrase, overwrite it, or save a copy as “$p2”.';
  }

  @override
  String get uiAllProjects => 'All Projects';

  @override
  String get uiCurrentProject => 'Current Project';

  @override
  String get uiCancelImport => 'Cancel Import';

  @override
  String get uiKeepExisting => 'Keep Existing';

  @override
  String get uiSaveACopy => 'Save a Copy';

  @override
  String get uiOverwrite => 'Overwrite';

  @override
  String uiImportedExistingPhrasesKept(String p1, String p2, String p3) {
    return 'Imported: $p1. Existing phrases kept: $p2. $p3';
  }

  @override
  String get uiPhrasesWithMentionsAreLimitedToThisProject =>
      'Phrases with Mentions are limited to this project and must be relinked before insertion.';

  @override
  String get uiAddPhrase => 'Add Phrase';

  @override
  String uiCouldNotLoadTheGlobalPhraseLibrary(String p1) {
    return 'Could not load the global phrase library: $p1';
  }

  @override
  String get uiSearchContentShortcutsOrTags =>
      'Search content, shortcuts, or tags';

  @override
  String get uiDisabled => 'Disabled';

  @override
  String get uiDuplicatePhrase => 'Duplicate Phrase';

  @override
  String get uiDisable => 'Disable';

  @override
  String get uiEnable => 'Enable';

  @override
  String get uiEditPhrase => 'Edit Phrase';

  @override
  String get uiShortcutLettersDigitsOr =>
      'Shortcut (1–32 letters, digits, _ or -)';

  @override
  String get uiAvailableInAllProjects => 'Available in All Projects';

  @override
  String get uiContainsMentionsCurrentProjectOnly =>
      'Contains Mentions; current project only';

  @override
  String get uiTags => 'Tags';

  @override
  String get uiAddTag => 'Add Tag';

  @override
  String get uiContent => 'Content';

  @override
  String get uiMentionsAreProjectSpecificTextAnnotationsCanBe =>
      'Mentions are project-specific; text annotations can be shared across projects.';

  @override
  String get uiAnnotation2 => 'Annotation';

  @override
  String get uiIncompleteMosaicSyntax => 'Incomplete Mosaic syntax';

  @override
  String get uiBack => 'Back';

  @override
  String get uiNoMatchingSuggestions => 'No matching suggestions';

  @override
  String uiBackTo(String p1) {
    return 'Back to $p1';
  }

  @override
  String get uiEnterSelectsRightArrowOpensTheNextLevel =>
      'Enter selects; Right Arrow opens the next level';

  @override
  String get uiEnterOrTabSelects => 'Enter or Tab selects';

  @override
  String uiExpandTheNextLevelOf(String p1) {
    return 'Expand the next level of $p1';
  }

  @override
  String uiChanges(String p1, String p2) {
    return '$p1 changes: $p2';
  }

  @override
  String uiItemChanges(String p1) {
    return 'Item changes: $p1';
  }

  @override
  String get uiTrackChanges => 'Track Changes';

  @override
  String get uiCollapseChangesPane => 'Collapse Changes Pane';

  @override
  String get uiCouldNotReadChangeTrackingData =>
      'Could not read change-tracking data';

  @override
  String get uiCreateABaselineFromTheCurrentContentTo =>
      'Create a baseline from the current content to view changes.';

  @override
  String get uiStartTracking => 'Start Tracking';

  @override
  String uiBaseline(String p1) {
    return 'Baseline: $p1';
  }

  @override
  String uiComparingToCurrentContent(String p1, String p2) {
    return '$p1: $p2 · Comparing to current content';
  }

  @override
  String get uiReadOnlyVersion => 'Read-only Version';

  @override
  String get commonCreate => 'Create';

  @override
  String get uiSaveCurrentContentAsCheckpointAndApply =>
      'Save Current Content as Checkpoint and Apply';

  @override
  String get uiShowAcceptedChanges => 'Show Accepted Changes';

  @override
  String get uiStopTracking => 'Stop Tracking';

  @override
  String get uiManuscript => 'Manuscript';

  @override
  String get uiSettings => 'Settings';

  @override
  String get uiScope => 'Scope:';

  @override
  String get uiCurrentChapterPage => 'Current Chapter / Page';

  @override
  String get uiEntireProject => 'Entire Project';

  @override
  String uiManuscriptLinesSettingsM(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  ) {
    return 'Manuscript +$p1 / −$p2 lines · Settings +$p3 / −$p4 / M$p5';
  }

  @override
  String uiAcceptChangesInScope(String p1) {
    return 'Accept Changes in Scope ($p1)';
  }

  @override
  String get uiRejectManuscriptChangesInScope =>
      'Reject Manuscript Changes in Scope';

  @override
  String get uiLargeDifferencesAreSimplifiedLineCountsMayNot =>
      'Large differences are simplified; line counts may not be minimal.';

  @override
  String get uiSomeDataTypesAreNotYetIncludedIn =>
      'Some data types are not yet included in comparisons.';

  @override
  String get uiPreviousChange => 'Previous Change';

  @override
  String get uiNextChange => 'Next Change';

  @override
  String uiCouldNotCalculateChanges(String p1) {
    return 'Could not calculate changes: $p1';
  }

  @override
  String get uiUnknownError => 'Unknown error';

  @override
  String get uiComparisonSourceIsNotAvailableYet =>
      'Comparison source is not available yet';

  @override
  String get uiNoChangesInThisScope => 'No changes in this scope';

  @override
  String uiManuscriptBeforeAfter(String p1, String p2, String p3) {
    return 'Manuscript / $p1 · Before $p2 → After $p3';
  }

  @override
  String uiAdditionalLines(String p1) {
    return 'Additional lines: $p1…';
  }

  @override
  String uiTrailingNewline(String p1, String p2) {
    return 'Trailing newline: $p1 → $p2';
  }

  @override
  String get uiPresent => 'Present';

  @override
  String get uiLargeDifferencesOverview => 'Large Differences Overview';

  @override
  String get uiFullAnnotation => 'Full Annotation';

  @override
  String get uiUndoAcceptance => 'Undo Acceptance';

  @override
  String get uiAccept => 'Accept';

  @override
  String get uiReject => 'Reject';

  @override
  String uiFullAnnotation2(String p1) {
    return '$p1 · Full annotation';
  }

  @override
  String get uiProjectInformation => 'Project Information';

  @override
  String get uiAddedItem => 'Added Item';

  @override
  String get uiDeletedItem => 'Deleted Item';

  @override
  String uiSwitchModuleCurrent(String p1) {
    return 'Switch Module; Current: $p1';
  }

  @override
  String get uiNoTargetsAvailable => 'No Targets Available';

  @override
  String get uiCreateATargetOfTheSameTypeBefore =>
      'Create a target of the same type before relinking this annotation.';

  @override
  String get uiFullAnnotationSyntaxCopied => 'Full annotation syntax copied.';

  @override
  String get uiOpenDashboard => 'Open Dashboard';

  @override
  String get uiTheManuscriptChangedWaitForChangesToBe =>
      'The manuscript changed. Wait for changes to be recalculated before rejecting this batch.';

  @override
  String get uiTheBatchRejectionSourceHasChangedRecalculateThe =>
      'The batch-rejection source has changed. Recalculate the differences.';

  @override
  String get uiTheManuscriptChangedWaitForChangesToBe2 =>
      'The manuscript changed. Wait for changes to be recalculated before rejecting.';

  @override
  String get uiThisBlockSPositionIsNoLongerValid =>
      'This block’s position is no longer valid. Recalculate the differences.';

  @override
  String get uiTheFieldChangedWaitForChangesToBe =>
      'The field changed. Wait for changes to be recalculated.';

  @override
  String get uiThisChapterWasDeletedViewItsPreviousContent =>
      'This chapter was deleted. View its previous content in the changes pane.';

  @override
  String get uiCouldNotPrepareTheThreeWayMerge =>
      'Could not prepare the three-way merge.';

  @override
  String get uiRevisionHeadsChangedDuringMergingOutdatedConflictChoices =>
      'Revision heads changed during merging. Outdated conflict choices were not applied.';

  @override
  String uiCouldNotApplyConflictChoices(String p1) {
    return 'Could not apply conflict choices: $p1';
  }

  @override
  String get uiTheMergedFileWasSavedButCreatingThe =>
      'The merged file was saved, but creating the resolution revision failed. Retry syncing now to recover its metadata.';

  @override
  String get uiFieldConflictsResolvedAndARevisionWithTwo =>
      'Field conflicts resolved and a revision with two parents created. Waiting for the peer’s ACK.';

  @override
  String uiCouldNotSaveTheResolutionRevision(String p1) {
    return 'Could not save the resolution revision: $p1';
  }

  @override
  String get uiTheRemoteRevisionIsNoLongerValidDownload =>
      'The remote revision is no longer valid. Download a complete snapshot again.';

  @override
  String get uiTheRemoteProjectFormatIsNewerAndCannot =>
      'The remote project format is newer and cannot be compared safely.';

  @override
  String get uiTheRemoteRevisionBelongsToAnotherProjectAnd =>
      'The remote revision belongs to another project and was not added to the comparison.';

  @override
  String get uiTheCompleteRemoteRevisionIsAvailableForRead =>
      'The complete remote revision is available for read-only comparison.';

  @override
  String uiCouldNotCompareTheRemoteRevision(String p1) {
    return 'Could not compare the remote revision: $p1';
  }

  @override
  String get uiTheSyncSessionOrRemoteRevisionChangedDownload =>
      'The sync session or remote revision changed. Download the snapshot again.';

  @override
  String get uiTheWorkingCopyHasLiveOperationsSnapshotsAre =>
      'The working copy has live operations. Snapshots are only for initialization or checkpoints and cannot overwrite an active project.';

  @override
  String get uiSaveAndOpenRemoteRevision => 'Save and Open Remote Revision?';

  @override
  String get uiTheRemoteSnapshotIsFullyVerifiedChooseWhere =>
      'The remote snapshot is fully verified. Choose where to save it. Selecting an existing file will overwrite it after confirmation. Cancelling leaves the editor unchanged.';

  @override
  String get uiTheRemoteSnapshotIsVerifiedButItCannot =>
      'The remote snapshot is verified, but it cannot safely replace the current file. Save a copy instead.';

  @override
  String get uiChooseSaveLocation => 'Choose Save Location';

  @override
  String get uiTheSyncSessionChangedDuringConfirmationNoProject =>
      'The sync session changed during confirmation. No project was written.';

  @override
  String get uiTheSnapshotWasSavedButTheSyncSession =>
      'The snapshot was saved, but the sync session expired. The current editor was not switched.';

  @override
  String uiRemoteSnapshotOverwrittenAndOpened(String p1) {
    return 'Remote snapshot overwritten and opened: $p1';
  }

  @override
  String uiRemoteSnapshotSavedAsACopyAndOpened(String p1) {
    return 'Remote snapshot saved as a copy and opened: $p1';
  }

  @override
  String uiCouldNotSaveOrOpenTheRemoteSnapshot(String p1) {
    return 'Could not save or open the remote snapshot: $p1';
  }

  @override
  String get uiAllowAutomaticSyncForThisSession =>
      'Allow Automatic Sync for This Session?';

  @override
  String get uiTheRemoteDraftIsFullyVerifiedIfAllowed =>
      'The remote draft is fully verified. If allowed, later drafts in this secure session will update the editor whenever there are no local edits. The .mnproj file is written only when you save manually.';

  @override
  String uiTheRemoteRevisionIsFullyVerifiedIfAllowed(String p1) {
    return 'The remote revision is fully verified. If allowed, later revisions in this secure session will apply automatically when the local project is unchanged, without repeated overwrite prompts. Target project: $p1.';
  }

  @override
  String get uiNotNow => 'Not Now';

  @override
  String get uiAllowThisSession => 'Allow This Session';

  @override
  String get uiRemoteDraftAppliedInNearRealTimeThe =>
      'Remote draft applied in near real time. The .mnproj file will be updated when you save manually.';

  @override
  String uiCouldNotApplyTheRemoteDraftInMemory(String p1) {
    return 'Could not apply the remote draft in memory: $p1';
  }

  @override
  String get uiImportModules => 'Import Modules';

  @override
  String uiSource(String p1) {
    return 'Source: $p1';
  }

  @override
  String get uiSelectedModulesReplaceTheCorrespondingDataInThis =>
      'Selected modules replace the corresponding data in this project.';

  @override
  String get uiThisIsASelectiveExportImportingReplacesWhole =>
      'This is a selective export. Importing replaces whole modules, rather than merging individual items; omitted data may be removed. Back up first, then explicitly select modules to replace.';

  @override
  String uiIncludesRequiredAncestorsOrDependenciesImportIntoAn(String p1) {
    return '$p1 includes required ancestors or dependencies. Import into an empty project instead of the populated project.';
  }

  @override
  String get uiSelectiveContentReplacesTheEntireModule =>
      ' (selective content; replaces the entire module)';

  @override
  String uiCurrentAfterImportIncludingStructuralNodes(String p1, String p2) {
    return 'Current: $p1 → After import: $p2 (including structural nodes)';
  }

  @override
  String uiReferencesRequiringRepair(String p1) {
    return 'References requiring repair: $p1';
  }

  @override
  String get uiApplyImport => 'Apply Import';

  @override
  String get uiTheWorkChangedDuringConfirmationStartTheImport =>
      'The work changed during confirmation. Start the import again.';

  @override
  String uiReferencesRequiringRepair2(String p1) {
    return '; references requiring repair: $p1';
  }

  @override
  String uiModulesImported(String p1, String p2) {
    return 'Modules imported: $p1$p2.';
  }

  @override
  String uiImportFailed(String p1) {
    return 'Import failed: $p1';
  }

  @override
  String uiExportComplete(String p1) {
    return 'Export complete: $p1';
  }

  @override
  String uiExportFailed(String p1) {
    return 'Export failed: $p1';
  }

  @override
  String uiUpgradedToInMemoryWarnings(String p1, String p2) {
    return ' (upgraded to $p1 in memory; warnings: $p2)';
  }

  @override
  String uiProjectOpened2(String p1, String p2) {
    return 'Project opened: $p1$p2';
  }

  @override
  String get uiUntitledMnproj => 'Untitled.mnproj';

  @override
  String get uiExternalProjectMnproj => 'External Project.mnproj';

  @override
  String get uiThisRecentFileHasNoUsableLocalPath =>
      'This recent file has no usable local path. Use Open File instead.';

  @override
  String uiFailed(String p1, String p2) {
    return '$p1 failed: $p2';
  }

  @override
  String uiRemovedFromRecentProjects(String p1) {
    return 'Removed from recent projects: $p1';
  }

  @override
  String get uiCodenameHana => 'Codename Hana';

  @override
  String get uiMonoAshiIsAWritingAssistantForAuthorsAnd =>
      'MonoAshi is a writing assistant for authors and creators. Manage chapters, characters, and worldbuilding in one place to organize and create your stories more easily.';

  @override
  String get uiKeyFeatures => 'Key Features';

  @override
  String get uiStorySettingsManagement => 'Story Settings Management';

  @override
  String get uiChapterAndParagraphEditing => 'Chapter and Paragraph Editing';

  @override
  String get uiOutlinePlanning => 'Outline Planning';

  @override
  String get uiWorldbuilding => 'Worldbuilding';

  @override
  String get uiCharacterDatabase => 'Character Database';

  @override
  String get uiHeyairu => '© 2025–2026 Heyairu (部屋伊琉).';

  @override
  String get uiCouldNotLoadTheNameDataTryAgain =>
      'Could not load the name data. Try again later.';

  @override
  String get uiNameResultsCopied => 'Name results copied.';

  @override
  String get uiCreatingAProjectIsNotConnectedYet =>
      'Creating a project is not connected yet.';

  @override
  String get uiOpeningFilesIsNotConnectedYet =>
      'Opening files is not connected yet.';

  @override
  String get uiRecentProjectsAreNotConnectedYet =>
      'Recent projects are not connected yet.';

  @override
  String get uiRemovingRecentProjectsIsNotConnectedYet =>
      'Removing recent projects is not connected yet.';

  @override
  String get uiPortMustBeAnIntegerFromTo =>
      'Port must be an integer from 1 to 65535.';

  @override
  String get uiEnterAValidLocalNetworkIPv4Address =>
      'Enter a valid local-network IPv4 address.';

  @override
  String get uiNeitherDeviceHasASyncProject =>
      'Neither Device Has a Sync Project';

  @override
  String get uiDifferentSyncProjects => 'Different Sync Projects';

  @override
  String get uiNeitherDeviceHasTheTargetProjectInMemory =>
      'Neither device has the target project in memory. Create a project to collaborate immediately; saving a file first is not required.';

  @override
  String get uiTheDevicesHaveDifferentProjectUUIDsChooseWhich =>
      'The devices have different project UUIDs. Choose which file to use for this sync.';

  @override
  String get uiThisDevice => 'This Device';

  @override
  String get uiPeer => 'Peer';

  @override
  String get uiCreateLocalProject => 'Create Local Project';

  @override
  String get uiOpenAnotherFile => 'Open Another File';

  @override
  String get uiUsePeerSFile => 'Use Peer’s File';

  @override
  String get uiUseLocalFile => 'Use Local File';

  @override
  String get uiNoProjectToSync => 'No Project to Sync';

  @override
  String get uiTheInMemoryProjectIsReadyForLive =>
      'The in-memory project is ready for live sync. Saving only creates an XML checkpoint.';

  @override
  String get uiTheProjectIsSavedWithAValidUUID =>
      'The project is saved with a valid UUID and is waiting for secure pairing.';

  @override
  String get uiPrepareProjectForSync => 'Prepare Project for Sync';

  @override
  String get uiLiveCollaborationRequiresAValidProjectUUIDIn =>
      'Live collaboration requires a valid project UUID in memory, not a saved file.';

  @override
  String get uiCreateInMemoryProject => 'Create In-Memory Project';

  @override
  String get uiOpenSavedFile => 'Open Saved File';

  @override
  String get uiSaveAsNewWork => 'Save as New Work';

  @override
  String get uiNoProjectIsOpen => 'No project is open.';

  @override
  String get uiTheCurrentProjectHasNotBeenSavedTo =>
      'The current project has not been saved to a reopenable location.';

  @override
  String get uiTheCurrentProjectHasUnsavedChanges =>
      'The current project has unsaved changes.';

  @override
  String get uiTheCurrentProjectHasNoValidProjectUUID =>
      'The current project has no valid project UUID.';

  @override
  String get uiThisProjectFormatDoesNotSupportP2PSync =>
      'This project format does not support P2P sync.';

  @override
  String get uiTheCurrentProjectHasUnresolvedSyncConflicts =>
      'The current project has unresolved sync conflicts.';

  @override
  String get uiServiceOff => 'Service Off';

  @override
  String get uiStartingService => 'Starting Service';

  @override
  String get uiServiceRunning => 'Service Running';

  @override
  String get uiStoppingService => 'Stopping Service';

  @override
  String get uiServiceError => 'Service Error';

  @override
  String get uiThePeerWillProvideAnInMemoryProject =>
      'The peer will provide an in-memory project; no save location is needed first.';

  @override
  String get uiInMemoryProjectReadyForLiveSyncNo =>
      'In-memory project ready for live sync; no XML checkpoint yet';

  @override
  String get uiCreateOrOpenAProjectFirst => 'Create or open a project first';

  @override
  String get uiUnresolvedSyncConflicts => 'Unresolved sync conflicts';

  @override
  String get uiSavedRevisionsSynchronized => 'Saved; revisions synchronized';

  @override
  String get uiSavedReadyToNotifyThePeer => 'Saved; ready to notify the peer';

  @override
  String get uiSavedReadyToDownloadAndApplyThePeer =>
      'Saved; ready to download and apply the peer’s revision';

  @override
  String get uiSavedFieldLevelConflictMergingAvailable =>
      'Saved; field-level conflict merging available';

  @override
  String get uiSavedWaitingForRevisionNegotiation =>
      'Saved; waiting for revision negotiation';

  @override
  String get uiSavedWaitingForConnectionNegotiationAndSecurePairing =>
      'Saved; waiting for connection negotiation and secure pairing';

  @override
  String get uiSyncProjectIsNotReady => 'Sync project is not ready';

  @override
  String get uiNotPaired => 'Not Paired';

  @override
  String get uiWaitingForThePeerSPairingChallenge =>
      'Waiting for the peer’s pairing challenge';

  @override
  String get uiWaitingForManualPairingCodeComparison =>
      'Waiting for manual pairing-code comparison';

  @override
  String get uiAddedToThisDeviceSTrustList =>
      'Added to this device’s trust list';

  @override
  String get uiConfirmedLocallyWaitingForThePeerSSignature =>
      'Confirmed locally; waiting for the peer’s signature';

  @override
  String get uiBothDevicesConfirmedTheSamePairingTranscript =>
      'Both devices confirmed the same pairing transcript';

  @override
  String get uiPairingError => 'Pairing Error';

  @override
  String get uiPersistentVerificationEnabledOnBothDevicesValidFor =>
      'Persistent verification enabled on both devices; valid for 14 days after pairing';

  @override
  String uiPersistentVerificationExpiresEachSuccessfulConnectionRenewsIt(
    String p1,
  ) {
    return 'Persistent verification expires $p1; each successful connection renews it for 14 days';
  }

  @override
  String get uiPersistentVerificationExpiredConfirmThePairingCodeAgain =>
      'Persistent verification expired. Confirm the pairing code again.';

  @override
  String get uiLocalRevisionLoading => 'Local revision: loading…';

  @override
  String get uiLocalRevisionMetadataError => 'Local revision: metadata error';

  @override
  String get uiLocalRevisionNotCreatedYetCreatedAfterA =>
      'Local revision: not created yet (created after a successful save)';

  @override
  String uiLocalRevisionConcurrentHeads(String p1) {
    return 'Local revision: concurrent heads: $p1';
  }

  @override
  String uiLocalRevision(String p1, String p2) {
    return 'Local revision: $p1  ·  $p2';
  }

  @override
  String get uiEncryptedChannelNotEstablished =>
      'Encrypted channel: not established';

  @override
  String get uiEncryptedChannelVerifyingIdentityAndDerivingASession =>
      'Encrypted channel: verifying identity and deriving a session key…';

  @override
  String get uiEncryptedChannelAuthenticatedAndEncrypted =>
      'Encrypted channel: authenticated and encrypted';

  @override
  String get uiEncryptedChannelConnectionFailed =>
      'Encrypted channel: connection failed';

  @override
  String get uiRevisionHeadsMatch => '; revision heads match';

  @override
  String get uiLocalRevisionIsNewer => '; local revision is newer';

  @override
  String get uiPeerRevisionIsNewer => '; peer revision is newer';

  @override
  String get uiConcurrentRevisionsDetected => '; concurrent revisions detected';

  @override
  String get uiSnapshotChunkValidationEnabled =>
      '; snapshot chunk validation enabled';

  @override
  String get uiLocalManifestNotCreated => 'Local manifest: not created';

  @override
  String uiLocalManifestBytesChunks(String p1, String p2) {
    return 'Local manifest: $p1 bytes / $p2 chunks';
  }

  @override
  String get uiPeerManifestNotNegotiated => 'Peer manifest: not negotiated';

  @override
  String get uiPeerManifestRequesting => 'Peer manifest: requesting…';

  @override
  String uiPeerManifestVerifiedBytes(String p1) {
    return 'Peer manifest: verified ($p1 bytes)';
  }

  @override
  String get uiPeerManifestCurrentlyUnavailable =>
      'Peer manifest: currently unavailable';

  @override
  String get uiPeerManifestVerificationFailed =>
      'Peer manifest: verification failed';

  @override
  String get uiRevisionDAGExchangingGraphPages =>
      'Revision DAG: exchanging graph pages…';

  @override
  String get uiRevisionDAGFullHistoryNotYetExchanged =>
      'Revision DAG: full history not yet exchanged';

  @override
  String uiRevisionDAGRemoteRevisionsMaximalCommonAncestorsWaiting(
    String p1,
    String p2,
  ) {
    return 'Revision DAG: remote revisions: $p1; maximal common ancestors: $p2; waiting for resolution/ACK';
  }

  @override
  String uiRevisionDAGPeerAcknowledgedResolution(String p1) {
    return 'Revision DAG: peer acknowledged resolution $p1';
  }

  @override
  String get uiCouldNotOpenTheLinkItHasBeen =>
      'Could not open the link. It has been copied to the clipboard.';

  @override
  String get uiNewProject => 'New Project';

  @override
  String get uiOpenFile2 => 'Open File';

  @override
  String get uiOpenThisProjectOnGitHub => 'Open This Project on GitHub';

  @override
  String get uiHeyairuSKadoKadoProfile => 'Heyairu’s KadoKado Profile';

  @override
  String get uiSendFeedbackGoogleForms => 'Send Feedback (Google Forms)';

  @override
  String get uiSendFeedbackGitHubIssues => 'Send Feedback (GitHub Issues)';

  @override
  String get uiNoRecentFiles => 'No Recent Files';

  @override
  String get uiProjectsYouOpenWillAppearHere =>
      'Projects you open will appear here.';

  @override
  String get uiNoUsablePath => 'No Usable Path';

  @override
  String get uiRemoveFromRecentProjects => 'Remove from Recent Projects';

  @override
  String get uiNameGenerator => 'Name Generator';

  @override
  String get uiLanguage => 'Language';

  @override
  String get uiEnglish => 'English';

  @override
  String get uiNameUnitedKingdom => 'United Kingdom';

  @override
  String get uiNameUnitedStates => 'United States';

  @override
  String get uiNameCanada => 'Canada';

  @override
  String get uiNameAustralia => 'Australia';

  @override
  String get uiJapanese => 'Japanese';

  @override
  String get uiChinese => 'Chinese';

  @override
  String get uiKorean => 'Korean';

  @override
  String get uiGender => 'Gender';

  @override
  String get uiMale => 'Male';

  @override
  String get uiNeutral => 'Neutral';

  @override
  String get uiFemale => 'Female';

  @override
  String get uiNumberToGenerate => 'Number to Generate';

  @override
  String get uiGenerate => 'Generate';

  @override
  String get uiResults => 'Results';

  @override
  String get uiCopyResults => 'Copy Results';

  @override
  String get uiSelectGenerateToCreateNames =>
      'Select Generate to create names.';

  @override
  String get uiContentSync => 'Content Sync';

  @override
  String get uiAfterSignedPairingAndAnAuthenticatedConnectionDevices =>
      'After signed pairing and an authenticated connection, devices can exchange encrypted revisions, manifests, and snapshot chunks. Received content enters quarantine for validation only.';

  @override
  String get uiLocalService => 'Local Service';

  @override
  String get uiNoUsableLANIPv4AddressFound =>
      'No usable LAN IPv4 address found';

  @override
  String get uiDetectLocalIPAgain => 'Detect Local IP Again';

  @override
  String get uiLocalPort => 'Local Port';

  @override
  String get uiStopService => 'Stop Service';

  @override
  String get uiStartService => 'Start Service';

  @override
  String get uiConnectToDevice => 'Connect to Device';

  @override
  String get uiPeerIP => 'Peer IP';

  @override
  String get uiForExample => 'For example, 192.168.1.23';

  @override
  String get uiPeerPort => 'Peer Port';

  @override
  String get uiEndpointVerified => 'Endpoint Verified';

  @override
  String get uiConnecting => 'Connecting…';

  @override
  String get uiConnect => 'Connect';

  @override
  String get uiDisconnect => 'Disconnect';

  @override
  String get uiDeviceIdentityAndPairing => 'Device Identity and Pairing';

  @override
  String uiLocalFingerprint(String p1) {
    return 'Local fingerprint: $p1';
  }

  @override
  String get uiInitializing => 'Initializing…';

  @override
  String get uiConfirmationOneDeviceEnabledOnBothDevices =>
      'Confirmation: one device (enabled on both devices)';

  @override
  String get uiConfirmationBothDevicesOneOrBothDisabledSingle =>
      'Confirmation: both devices (one or both disabled single-device confirmation)';

  @override
  String get uiConfirmBothDevicesDisplayExactlyTheSamePairing =>
      'Confirm both devices display exactly the same pairing code:';

  @override
  String get uiCancelIfTheCodesDifferAfterEitherDevice =>
      'Cancel if the codes differ. After either device confirms, the peer verifies the signature and signs automatically.';

  @override
  String get uiCancelIfTheCodesDifferBothDevicesMust =>
      'Cancel if the codes differ. Both devices must confirm before the encrypted content channel opens.';

  @override
  String get uiStartSecurePairing => 'Start Secure Pairing';

  @override
  String get uiConfirmCodesMatch => 'Confirm Codes Match';

  @override
  String get uiCancelPairing => 'Cancel Pairing';

  @override
  String get uiBothIdentitiesAndTemporaryECDHKeysAreBound =>
      'Both identities and temporary ECDH keys are bound to the same transcript. The same project session can exchange encrypted snapshot chunks; all received content still requires quarantine validation.';

  @override
  String get uiBothDevicesSignedTheSameChallengeEstablishingAuthenticated =>
      'Both devices signed the same challenge. Establishing authenticated encrypted transport; revisions and content are not exchanged until it is ready.';

  @override
  String get uiSyncProject => 'Sync Project';

  @override
  String get uiNoProjectOpen => 'No Project Open';

  @override
  String uiPeerFile(String p1) {
    return 'Peer file: $p1';
  }

  @override
  String uiPeerUUID(String p1) {
    return 'Peer UUID: $p1';
  }

  @override
  String get uiChangeSyncProject => 'Change Sync Project';

  @override
  String get uiPrepareSyncProject => 'Prepare Sync Project';

  @override
  String get uiRevisionsDivergedResolveFieldLevelConflictsFirst =>
      'Revisions diverged. Resolve field-level conflicts first.';

  @override
  String get uiAskTheReceiverToDownloadTheCurrentSnapshot =>
      'Ask the receiver to download the current snapshot over the authenticated connection.';

  @override
  String get uiOnlyAcceptARemoteSnapshotThatExactlyMatches =>
      'Only accept a remote snapshot that exactly matches the current authenticated session.';

  @override
  String get uiApplying => 'Applying';

  @override
  String get uiDownloading => 'Downloading';

  @override
  String get uiSyncNow => 'Sync Now';

  @override
  String get uiCompareRemoteRevision => 'Compare Remote Revision';

  @override
  String get uiCancelTransfer => 'Cancel Transfer';

  @override
  String get uiBasicInformation => 'Basic Information';

  @override
  String get uiBookTitle => 'Book Title';

  @override
  String get uiEnterTheBookTitle => 'Enter the book title';

  @override
  String get uiAuthor => 'Author';

  @override
  String get uiEnterTheAuthorSName => 'Enter the author’s name';

  @override
  String get uiTheme2 => 'Theme';

  @override
  String get uiEnterTheStorySTheme => 'Enter the story’s theme';

  @override
  String get uiOneLineSummary => 'One-Line Summary';

  @override
  String get uiEnterAOneLineSummary => 'Enter a one-line summary';

  @override
  String get uiEnterTheGenre => 'Enter the genre';

  @override
  String get uiSynopsis => 'Synopsis';

  @override
  String get uiEnterASynopsis => 'Enter a synopsis';

  @override
  String get uiStatistics => 'Statistics';

  @override
  String get uiLastSaved => 'Last Saved';

  @override
  String get uiTotalCount => 'Total Count';

  @override
  String uiCharacters2(String p1) {
    return '$p1 characters';
  }

  @override
  String get uiChapterCount => 'Chapter Count';

  @override
  String uiFolder(String p1) {
    return 'Folder $p1';
  }

  @override
  String get uiChapters => 'Chapters';

  @override
  String uiTotalCharacters(String p1) {
    return 'Total: $p1 characters';
  }

  @override
  String get uiFoldersAndChaptersShareOneListDeletingA =>
      'Folders and chapters share one list. Deleting a folder also deletes its chapters.';

  @override
  String get uiLongPressAndDragToReorderDragChapters =>
      'Long-press and drag to reorder; drag chapters into other folders. The root folder is always hidden.';

  @override
  String get uiSearchFolderOrChapterNames => 'Search folder or chapter names';

  @override
  String get uiClearSearch => 'Clear Search';

  @override
  String get uiChapterTree => 'Chapter Tree';

  @override
  String get uiNoChapters => 'No Chapters';

  @override
  String get uiAddYourFirstFolder => 'Add your first folder.';

  @override
  String get uiChapterName => 'Chapter Name';

  @override
  String get uiSelectAFolderFirst => 'Select a folder first.';

  @override
  String get uiSubfolder => 'Subfolder';

  @override
  String get uiSelectAParentFolderFirst => 'Select a parent folder first.';

  @override
  String get uiRootFolder => 'Root Folder';

  @override
  String get uiAddChapter => 'Add Chapter';

  @override
  String get uiAddSubfolder => 'Add Subfolder';

  @override
  String get uiAddRootFolder => 'Add Root Folder';

  @override
  String get uiUnnamedFolder => '(Unnamed Folder)';

  @override
  String uiChaptersSubfoldersCount(String p1, String p2, String p3) {
    return 'Chapters: $p1 • Subfolders: $p2 • Count: $p3';
  }

  @override
  String get uiCollapseFolder => 'Collapse Folder';

  @override
  String get uiExpandFolder => 'Expand Folder';

  @override
  String get uiDeleteThisFolderAndItsChapters =>
      'Delete This Folder and Its Chapters';

  @override
  String get uiAtLeastOneChapterIsRequired =>
      'At least one chapter is required.';

  @override
  String uiChapterMovedTo(String p1) {
    return 'Chapter moved to “$p1”.';
  }

  @override
  String get uiDeleteThisChapter => 'Delete This Chapter';

  @override
  String get uiSourceCharacter => 'Source Character';

  @override
  String get uiTargetCharacter => 'Target Character';

  @override
  String get uiSelectAnExistingCharacterOrEnterANew =>
      'Select an existing character or enter a new name';

  @override
  String get uiExternalRelationship => 'External Relationship';

  @override
  String get uiForExampleFriendFamilyRival =>
      'For example: friend, family, rival';

  @override
  String get uiInternalRelationship => 'Internal Relationship';

  @override
  String get uiForExampleTrustAdmirationEnvy =>
      'For example: trust, admiration, envy';

  @override
  String get uiBidirectionalRelationship => 'Bidirectional Relationship';

  @override
  String get uiAlsoCreateARelationshipFromTheTargetBack =>
      'Also create a relationship from the target back to the source.';

  @override
  String get uiNoCharactersYet => 'No Characters Yet';

  @override
  String get uiAddCharactersInCharacterSettingsBeforeCreatingAnd =>
      'Add characters in Character Settings before creating and viewing relationships.';

  @override
  String get uiMinimizeTimelineAndSnapshots =>
      'Minimize Timeline and Snapshots';

  @override
  String get uiHistoricalPreviewsAreReadOnlyEachCharacterUses =>
      'Historical previews are read-only. Each character uses the last effective change before this tick. Return to default data to edit.';

  @override
  String get uiCharacterRelationships => 'Character Relationships';

  @override
  String get uiCollapseToolbar => 'Collapse Toolbar';

  @override
  String get uiExpandToolbar => 'Expand Toolbar';

  @override
  String get uiEnableSnapshots => 'Enable Snapshots';

  @override
  String get uiShowSnapshotCards => 'Show Snapshot Cards';

  @override
  String get uiCloseSnapshots => 'Close Snapshots';

  @override
  String get uiShowRelationships => 'Show Relationships';

  @override
  String get uiArrangeCharacters => 'Arrange Characters';

  @override
  String get uiLocateCharacter => 'Locate Character';

  @override
  String get uiRelationshipClusters => 'Relationship Clusters';

  @override
  String get uiExternalInternalDragCharactersToReposition =>
      'External ━   Internal ┄   Drag characters to reposition';

  @override
  String get uiSearchOrSelectCharacter => 'Search or Select Character';

  @override
  String get uiSearchAndFocus => 'Search and Focus';

  @override
  String get uiShowDirectNeighborsOnly => 'Show Direct Neighbors Only';

  @override
  String get uiSelectACharacterFirst => 'Select a character first.';

  @override
  String get uiOverview => 'Overview';

  @override
  String get uiAddRelationship => 'Add Relationship';

  @override
  String get uiHistoricalPreviewIsReadOnly => 'Historical Preview Is Read-only';

  @override
  String get uiRearrangeAutomatically => 'Rearrange Automatically';

  @override
  String get uiResetZoom => 'Reset Zoom';

  @override
  String get uiZoomOut => 'Zoom Out';

  @override
  String get uiZoomIn => 'Zoom In';

  @override
  String get uiMergeIdenticalBidirectionalRelationships =>
      'Merge Identical Bidirectional Relationships';

  @override
  String get uiNoMatchingCharacters => 'No matching characters';

  @override
  String get uiNoRelationshipsYetAddOneHereOrEdit =>
      'No relationships yet. Add one here or edit it in Character Settings.';

  @override
  String get commonAdd => 'Add';

  @override
  String uiAnd(String p1, String p2) {
    return '$p1 and $p2';
  }

  @override
  String get uiOpenCharacterEditor => 'Open Character Editor';

  @override
  String get uiCollapseDetails => 'Collapse Details';

  @override
  String get uiExpandDetails => 'Expand Details';

  @override
  String get uiThisNameDoesNotUniquelyIdentifyACharacter =>
      'This name does not uniquely identify a character. Select the connection to correct it.';

  @override
  String uiOccupation(String p1) {
    return 'Occupation: $p1';
  }

  @override
  String uiAge(String p1) {
    return 'Age: $p1';
  }

  @override
  String uiGender2(String p1) {
    return 'Gender: $p1';
  }

  @override
  String get uiOrganizations => 'Organizations';

  @override
  String uiAdjacentRelationships(String p1) {
    return 'Adjacent Relationships: $p1';
  }

  @override
  String get uiUnpin => 'Unpin';

  @override
  String get uiPinPosition => 'Pin Position';

  @override
  String get uiThisPinnedPositionOverlapsAnotherPinnedCharacterDrag =>
      'This pinned position overlaps another pinned character. Drag to adjust it.';

  @override
  String get uiCreateTargetCharacter => 'Create Target Character';

  @override
  String uiShowing(String p1) {
    return 'Showing: $p1';
  }

  @override
  String get uiExternal => 'External';

  @override
  String get uiInternal => 'Internal';

  @override
  String get uiShowAllRelationships => 'Show All Relationships';

  @override
  String get uiSeveralCharactersShareThisNameEditAndSelect =>
      'Several characters share this name. Edit and select one with a NanoID.';

  @override
  String get uiNoMatchingCharacterCorrectTheNameOrCreate =>
      'No matching character. Correct the name or create a character.';

  @override
  String get uiCreateCharacter => 'Create Character';

  @override
  String get uiEdit => 'Edit';

  @override
  String get uiCorrectTargetCharacter => 'Correct Target Character';

  @override
  String uiDelete(String p1) {
    return 'Delete $p1';
  }

  @override
  String get uiDeleteAllRelationshipsInThisDirection =>
      'Delete All Relationships in This Direction';

  @override
  String get uiTheRelationshipChangedSelectItAgainBeforeContinuing =>
      'The relationship changed. Select it again before continuing.';

  @override
  String uiEditRelationship(String p1, String p2, String p3) {
    return '$p1 → $p2 · Edit $p3 relationship';
  }

  @override
  String uiRelationship(String p1) {
    return '$p1 Relationship';
  }

  @override
  String get uiDeleteCharacterRelationship => 'Delete Character Relationship';

  @override
  String get uiDeleteBothExternalAndInternalRelationshipsInThis =>
      'Delete both external and internal relationships in this direction? Reverse relationships will be kept.';

  @override
  String uiDeleteTheRelationshipInThisDirectionOtherTypes(
    String p1,
    String p2,
  ) {
    return 'Delete the $p1 relationship “$p2” in this direction? Other types and reverse relationships will be kept.';
  }

  @override
  String get uiSelectAnExistingCharacterThatCanBeUniquely =>
      'Select an existing character that can be uniquely identified.';

  @override
  String get uiSeveralCharactersShareThisNameSelectOneWith =>
      'Several characters share this name. Select one with a NanoID.';

  @override
  String get uiAfterCreationThisRelationshipWillLinkAutomaticallyBy =>
      'After creation, this relationship will link automatically by character name.';

  @override
  String get uiCharacterName => 'Character Name';

  @override
  String get uiCreatingTheCharacterAlsoAddsARelationshipFrom =>
      'Creating the character also adds a relationship from the current character to them.';

  @override
  String get uiNext2 => 'Next';

  @override
  String get uiSetUpNewCharacterRelationship =>
      'Set Up New Character Relationship';

  @override
  String get uiCorrectTheTargetInThisDirection =>
      'Correct the Target in This Direction';

  @override
  String get uiSelectAnExistingCharacterBothRelationshipTypesMove =>
      'Select an existing character; both relationship types move together.';

  @override
  String get uiCharacterEditor => 'Character Editor';

  @override
  String get uiCharacterList => 'Character List';

  @override
  String get uiCharacterName2 => 'Character Name';

  @override
  String get uiNoCharacters => 'No Characters';

  @override
  String get uiAddYourFirstCharacter => 'Add your first character.';

  @override
  String uiCharacterType(String p1) {
    return 'Character type: $p1';
  }

  @override
  String get uiSelectACharacter => 'Select a Character';

  @override
  String get uiSelectACharacterFromTheListOnThe =>
      'Select a character from the list on the left to edit.';

  @override
  String get uiCharacterCard => 'Character Card';

  @override
  String get uiCustomData => 'Custom Data';

  @override
  String get uiAdvancedSettings => 'Advanced Settings';

  @override
  String get uiAddSnapshot => 'Add Snapshot';

  @override
  String get uiDuplicateSnapshot => 'Duplicate Snapshot';

  @override
  String get uiDefault => 'Default';

  @override
  String get uiDeleteSnapshot => 'Delete Snapshot';

  @override
  String get uiTheDefaultSnapshotCannotBeDeleted =>
      'The default snapshot cannot be deleted.';

  @override
  String get uiBasicIdentity => 'Basic Identity';

  @override
  String get uiNameRequired => 'Name (required):';

  @override
  String get uiRoleOccupation => 'Role / Occupation:';

  @override
  String get uiAge2 => 'Age:';

  @override
  String get uiGender3 => 'Gender:';

  @override
  String get uiBirthday => 'Birthday:';

  @override
  String get uiCharacterType2 => 'Character Type';

  @override
  String get uiAppearanceSummary => 'Appearance Summary';

  @override
  String get uiDescribeTheCharacterSGeneralAppearance =>
      'Describe the character’s general appearance.';

  @override
  String get uiHeight => 'Height:';

  @override
  String get uiWeight => 'Weight:';

  @override
  String get uiHairColor => 'Hair Color:';

  @override
  String get uiEyeColor => 'Eye Color:';

  @override
  String get uiAppearanceSummary2 => 'Appearance Summary:';

  @override
  String get uiPersonalityAndStoryCore => 'Personality and Story Core';

  @override
  String get uiDescribeTheCharacterSPersonalityAndTheChallenges =>
      'Describe the character’s personality and the challenges they face.';

  @override
  String get uiPersonality => 'Personality:';

  @override
  String get uiSpeechStyle => 'Speech Style:';

  @override
  String get uiMotivation => 'Motivation:';

  @override
  String get uiGoal => 'Goal:';

  @override
  String get uiValuesAndBeliefs => 'Values and Beliefs:';

  @override
  String get uiFear => 'Fear:';

  @override
  String get uiObstaclesAndResolutions => 'Obstacles and Resolutions';

  @override
  String get uiObstacle => 'Obstacle';

  @override
  String get uiResolution => 'Resolution';

  @override
  String get uiEnterAnObstacleAndResolutionBelowThenAdd =>
      'Enter an obstacle and resolution below, then add them.';

  @override
  String get uiCharacterRelationships2 => 'Character Relationships';

  @override
  String get uiDescribeTheCharacterSConnectionsWithOthers =>
      'Describe the character’s connections with others.';

  @override
  String get uiRelationshipSummary => 'Relationship Summary:';

  @override
  String get uiOrganization => 'Organization';

  @override
  String get uiPositionTitle => 'Position / Title';

  @override
  String get uiEnterAnOrganizationAndPositionBelowThenAdd =>
      'Enter an organization and position below, then add them.';

  @override
  String get uiSelectALocationOrOrganizationOrEnterYour =>
      'Select a location or organization, or enter your own';

  @override
  String get uiCharacterStatus => 'Character Status';

  @override
  String get uiDescribeTheCharacterSGeneralState =>
      'Describe the character’s general state.';

  @override
  String get uiEnterAStatusAndDescriptionBelowThenAdd =>
      'Enter a status and description below, then add them.';

  @override
  String get uiNotes2 => 'Notes:';

  @override
  String get uiSelectACharacterFirst2 => 'Select a character first.';

  @override
  String get uiSelectACharacterToPreviewTheTimelineAnd =>
      'Select a character to preview the timeline and manage snapshots.';

  @override
  String get uiStoryStateEditingDefaultData =>
      'Story State · Editing Default Data';

  @override
  String uiStoryStateTick(String p1, String p2) {
    return 'Story State · Tick $p1 · $p2';
  }

  @override
  String get uiReadOnlyPreviewFollowingTheTimeline =>
      'Read-only preview; following the timeline.';

  @override
  String uiEditing(String p1) {
    return 'Editing: $p1';
  }

  @override
  String get uiEditingASceneSnapshotObstaclesRelationshipsOrganizationsStatus =>
      'Editing a scene snapshot: obstacles, relationships, organizations, status, possessions, and custom fields can change. Other fixed data is locked.';

  @override
  String get uiDefaultData => 'Default Data';

  @override
  String get uiStateAtPlayhead => 'State at Playhead';

  @override
  String uiCurrentTick(String p1) {
    return 'Current Tick $p1';
  }

  @override
  String get uiCopyCurrentState => 'Copy Current State';

  @override
  String get uiDefaultItemAssignments => 'Default Item Assignments';

  @override
  String uiItemAssignmentsAtTick(String p1) {
    return 'Item Assignments at Tick $p1';
  }

  @override
  String get uiAllSnapshots => 'All Snapshots';

  @override
  String uiTotalIncludingDefault(String p1) {
    return 'Total: $p1 (including default)';
  }

  @override
  String get uiSnapshotHistoryAndEditing => 'Snapshot History and Editing';

  @override
  String get uiDefaultSnapshotBeforeTheStory =>
      'Default Snapshot (Before the Story)';

  @override
  String get uiTheSceneIsUnscheduledOrItsPrimaryPlacement =>
      'The scene is unscheduled or its primary placement is invalid.';

  @override
  String get uiFallbackTick => 'Fallback Tick';

  @override
  String uiChanges2(String p1) {
    return 'Changes: $p1';
  }

  @override
  String uiNotes3(String p1) {
    return 'Notes: $p1';
  }

  @override
  String get uiDefaultSnapshot => 'Default Snapshot';

  @override
  String get uiLocateSnapshot => 'Locate Snapshot';

  @override
  String get uiEditSnapshot => 'Edit Snapshot';

  @override
  String get uiDeleteSnapshot2 => 'Delete Snapshot?';

  @override
  String get uiDeletingThisSnapshotRecalculatesTheCharacterSState =>
      'Deleting this snapshot recalculates the character’s state after this scene.';

  @override
  String uiIsLocked(String p1) {
    return '$p1 Is Locked';
  }

  @override
  String get uiSceneSnapshotsAllowChangesOnlyToTheFive =>
      'Scene snapshots allow changes only to the five character tables and custom fields. Return to Default to edit fixed data.';

  @override
  String uiEvent2(String p1) {
    return 'Event: $p1';
  }

  @override
  String get uiThisEventHasNoScenesYetANew =>
      'This event has no scenes yet. A new scene will be created within it.';

  @override
  String uiStoryline(String p1) {
    return 'Storyline: $p1';
  }

  @override
  String get uiTheSpecifiedEventWasNotFoundANew =>
      'The specified event was not found. A new event will be created in this storyline.';

  @override
  String get uiGlobalPreview => 'Global Preview';

  @override
  String get uiTheSpecifiedStorylineWasNotFoundANew =>
      'The specified storyline was not found. A new storyline, event, and scene will be created.';

  @override
  String get uiCharacterSnapshot => 'Character Snapshot';

  @override
  String get uiCharacterSnapshotScene => 'Character Snapshot Scene';

  @override
  String get uiNewScene => 'New Scene';

  @override
  String get uiAddSceneSnapshot => 'Add Scene Snapshot';

  @override
  String uiDuplicate(String p1) {
    return 'Duplicate $p1';
  }

  @override
  String get uiLinkToScene => 'Link to Scene';

  @override
  String get uiQuickCreateScene => '＋ Quick-Create Scene';

  @override
  String get uiSceneHierarchy => 'Scene Hierarchy';

  @override
  String get uiStorylineSelectExistingOrEnterAName =>
      'Storyline (select existing or enter a name)';

  @override
  String get uiForExampleActOne => 'For example: Act One';

  @override
  String get uiEventSelectExistingOrEnterAName =>
      'Event (select existing or enter a name)';

  @override
  String get uiForExampleConflictAtTheGate =>
      'For example: Conflict at the Gate';

  @override
  String get uiSceneName => 'Scene Name';

  @override
  String get uiForExampleArrivingAtTheGate =>
      'For example: Arriving at the Gate';

  @override
  String get uiTimelineTick => 'Timeline Tick';

  @override
  String uiEnterToOrClickOrDragTheScrubber(String p1, String p2) {
    return 'Enter $p1 to +$p2, or click or drag the scrubber above.';
  }

  @override
  String uiTickMustBeBetweenAnd(String p1, String p2) {
    return 'Tick must be between $p1 and +$p2.';
  }

  @override
  String get uiInitialContent => 'Initial Content';

  @override
  String get uiEmptyState => 'Empty State';

  @override
  String uiCopyFrom(String p1) {
    return 'Copy from: $p1';
  }

  @override
  String get uiSpecificSnapshot => 'Specific Snapshot';

  @override
  String get uiCopiesTheCompleteDerivedStateAtTheSource =>
      'Copies the complete derived state at the source snapshot.';

  @override
  String get uiEnterNamesForTheStorylineEventAndScene =>
      'Enter names for the storyline, event, and scene.';

  @override
  String get uiCreateSnapshot => 'Create Snapshot';

  @override
  String uiCopiedFrom(String p1) {
    return 'Copied from $p1';
  }

  @override
  String get uiSceneSnapshotAdded => 'Scene snapshot added.';

  @override
  String uiMovedToTick(String p1) {
    return 'Moved to Tick $p1';
  }

  @override
  String get uiIdentitySettings => 'Identity Settings';

  @override
  String get uiAnCharacterNanoIDDistinguishesCharactersWithTheSame =>
      'An 8-character NanoID distinguishes characters with the same name.';

  @override
  String get uiDetailedProfileAndAppearance =>
      'Detailed Profile and Appearance';

  @override
  String get uiResidenceFeaturesAndClothing =>
      'Residence, features, and clothing';

  @override
  String get uiPersonalityTools => 'Personality Tools';

  @override
  String get uiHabitsAlignmentAndPersonalityScales =>
      'Habits, alignment, and personality scales';

  @override
  String get uiPreferencesAndAbilities => 'Preferences and Abilities';

  @override
  String get uiAbilityListsAndEverydaySkillScales =>
      'Ability lists and everyday skill scales';

  @override
  String get uiSocialQuestionnaire => 'Social Questionnaire';

  @override
  String get uiSocialBehaviorTendenciesAndRomance =>
      'Social behavior, tendencies, and romance';

  @override
  String get uiOtherLegacyFields => 'Other Legacy Fields';

  @override
  String get uiOriginalLanguageNamePreferencesAndExtraNotes =>
      'Original-language name, preferences, and extra notes';

  @override
  String get uiText => 'Text';

  @override
  String get uiSlider => 'Slider';

  @override
  String get uiCheckbox => 'Checkbox';

  @override
  String get uiList => 'List';

  @override
  String get uiFieldName => 'Field Name';

  @override
  String get uiDataType => 'Data Type';

  @override
  String get uiNoCustomData => 'No Custom Data';

  @override
  String get uiEnterAFieldNameSelectItsTypeAnd =>
      'Enter a field name, select its type, and add it.';

  @override
  String uiRemove(String p1) {
    return 'Remove $p1';
  }

  @override
  String get uiBirthplace => 'Birthplace:';

  @override
  String get uiResidence => 'Residence:';

  @override
  String get uiAddress => 'Address:';

  @override
  String get uiAppearance => 'Appearance';

  @override
  String get uiBloodType => 'Blood Type:';

  @override
  String get uiSkinColor => 'Skin Color:';

  @override
  String get uiFaceShape => 'Face Shape:';

  @override
  String get uiEyeShape => 'Eye Shape:';

  @override
  String get uiEarShape => 'Ear Shape:';

  @override
  String get uiNoseShape => 'Nose Shape:';

  @override
  String get uiMouthShape => 'Mouth Shape:';

  @override
  String get uiEyebrowShape => 'Eyebrow Shape:';

  @override
  String get uiBuild => 'Build:';

  @override
  String get uiClothing => 'Clothing:';

  @override
  String get uiCatchphrasesAndExpressions => 'Catchphrases and Expressions:';

  @override
  String get uiInterests => 'Interests:';

  @override
  String get uiHabitsAndQuirks => 'Habits and Quirks:';

  @override
  String get uiFaith => 'Faith:';

  @override
  String get uiBoundaries => 'Boundaries';

  @override
  String get uiWhatDoTheyWantToBecome => 'What do they want to become?';

  @override
  String get uiWhatDoTheyValueMost => 'What do they value most?';

  @override
  String get uiWhatDoTheyDespiseMost => 'What do they despise most?';

  @override
  String get uiWhatDoTheyFearMost => 'What do they fear most?';

  @override
  String get uiWhatIntriguesThemMost => 'What intrigues them most?';

  @override
  String get uiWhatDoTheyLookForwardToMost =>
      'What do they look forward to most?';

  @override
  String get uiAlignment => 'Alignment';

  @override
  String get uiPersonalityTraits => 'Personality Traits';

  @override
  String get uiApproachToLife => 'Approach to Life';

  @override
  String get uiAdditionalNotes => 'Additional Notes:';

  @override
  String get uiThingsTheyLoveDoing => 'Things They Love Doing';

  @override
  String get uiThingsTheyWantToTry => 'Things They Want to Try';

  @override
  String get uiThingsTheyDislikeDoing => 'Things They Dislike Doing';

  @override
  String get uiThingsTheyFearDoing => 'Things They Fear Doing';

  @override
  String get uiThingsTheyDoWell => 'Things They Do Well';

  @override
  String get uiThingsTheyStruggleWith => 'Things They Struggle With';

  @override
  String get uiEverydaySkills => 'Everyday Skills';

  @override
  String get uiOthersImpressions => 'Others’ Impressions';

  @override
  String get uiMostAdmiredOrLovedQualities => 'Most Admired or Loved Qualities';

  @override
  String get uiFamilyBackground => 'Family Background';

  @override
  String get uiHowTheyExpressAffection => 'How They Express Affection';

  @override
  String get uiOther => 'Other';

  @override
  String get uiHowTheyShowKindness => 'How They Show Kindness';

  @override
  String get uiHowDoTheyHandlePeopleTheyDislike =>
      'How Do They Handle People They Dislike?';

  @override
  String get uiRomanticRelationships => 'Romantic Relationships';

  @override
  String get uiSocialTendencies => 'Social Tendencies';

  @override
  String get uiOriginalLanguageName => 'Original-Language Name';

  @override
  String get uiForExample2 => 'For example: 桜田如羽';

  @override
  String get uiThingsTheyLike => 'Things They Like';

  @override
  String get uiThingsTheyAdmire => 'Things They Admire';

  @override
  String get uiThingsTheyDislike => 'Things They Dislike';

  @override
  String get uiThingsTheyFear => 'Things They Fear';

  @override
  String get uiFamiliarThings => 'Familiar Things';

  @override
  String get uiAdditionalNotes2 => 'Additional Notes';

  @override
  String get uiCharacterRelationships3 => 'Character Relationships';

  @override
  String get uiNoCharacterRelationships => 'No Character Relationships';

  @override
  String get uiEnterACharacterAndExternalInternalRelationshipsBelow =>
      'Enter a character and external/internal relationships below, then add them.';

  @override
  String get uiSelectACharacterOrEnterAName =>
      'Select a character or enter a name';

  @override
  String get uiExternalRelationshipOptional =>
      'External Relationship (optional)';

  @override
  String get uiInternalRelationshipOptional =>
      'Internal Relationship (optional)';

  @override
  String get uiUpdate => 'Update';

  @override
  String uiNoYet(String p1) {
    return 'No $p1 Yet';
  }

  @override
  String uiOptional(String p1) {
    return '$p1 (optional)';
  }

  @override
  String get uiPossessions => 'Possessions';

  @override
  String get uiQuantity => 'Quantity';

  @override
  String get uiNoPossessions => 'No Possessions';

  @override
  String get uiEnterAnItemQuantityAndDescriptionBelowThen =>
      'Enter an item, quantity, and description below, then add them.';

  @override
  String get uiDescriptionOptional => 'Description (optional)';

  @override
  String get uiConvertToManagedItem => 'Convert to Managed Item';

  @override
  String get uiTheseAreLegacyPossessionsConvertEachEntryTo =>
      'These are legacy possessions. Convert each entry to a managed item; new entries in the old format cannot be added here.';

  @override
  String uiQuantity2(String p1) {
    return 'Quantity: $p1';
  }

  @override
  String get uiLiteral => '・';

  @override
  String get uiDeleteLegacyEntry => 'Delete Legacy Entry';

  @override
  String get uiUnknown => 'Unknown';

  @override
  String get uiRelatedItems => 'Related Items';

  @override
  String get uiLinkItem => 'Link Item';

  @override
  String get uiNoRelatedItemsAreConfigured =>
      'No related items are configured.';

  @override
  String get uiOpenItems => 'Open Items';

  @override
  String get uiUnlink => 'Unlink';

  @override
  String get uiCurrentlyHeldItems => 'Currently Held Items';

  @override
  String get uiAssignItem => 'Assign Item';

  @override
  String get uiNoLinkedItems => 'No Linked Items';

  @override
  String get uiSelectAssignItemToSetTheHolderOr =>
      'Select Assign Item to set the holder or aggregate quantity here.';

  @override
  String get uiStatusNotes => 'Status / Notes';

  @override
  String get uiActions => 'Actions';

  @override
  String get uiClearDefaultAssignment => 'Clear Default Assignment';

  @override
  String get uiSelectAnItemToAssignToTheCharacter =>
      'Select an Item to Assign to the Character';

  @override
  String uiAssign(String p1) {
    return 'Assign “$p1”';
  }

  @override
  String get uiLeaveBlankIfTheQuantityIsUnknown =>
      'Leave blank if the quantity is unknown.';

  @override
  String get uiAssign2 => 'Assign';

  @override
  String get uiQuantityMustBeZeroOrAPositiveInteger =>
      'Quantity must be zero or a positive integer.';

  @override
  String uiCouldNotAssignTheItem(String p1) {
    return 'Could not assign the item: $p1';
  }

  @override
  String uiConvert(String p1) {
    return 'Convert “$p1”';
  }

  @override
  String get uiRemovesMatchingLegacyEntriesFromTheDefaultCharacter =>
      'Removes matching legacy entries from the default character data and locatable scene snapshots, then creates managed item states.';

  @override
  String get uiLinkExisting => 'Link Existing';

  @override
  String get uiCreateAndConvert => 'Create and Convert';

  @override
  String uiSelectTheManagedItemFor(String p1) {
    return 'Select the Managed Item for “$p1”';
  }

  @override
  String get uiConfirmPossessionConversion => 'Confirm Possession Conversion';

  @override
  String uiDefaultBaselineEntries(String p1) {
    return 'Default / baseline entries: $p1';
  }

  @override
  String uiSceneSnapshotEntries(String p1) {
    return 'Scene snapshot entries: $p1';
  }

  @override
  String uiLegacyCharacterStateEntriesWithoutReliableSceneLinksTheir(
    String p1,
  ) {
    return 'Legacy CharacterState entries without reliable scene links: $p1. Their original text will be kept.';
  }

  @override
  String get uiApplyConversion => 'Apply Conversion';

  @override
  String uiPossessionConversionFailed(String p1) {
    return 'Possession conversion failed: $p1';
  }

  @override
  String get uiCreateManagedItem => 'Create Managed Item';

  @override
  String get uiItemName => 'Item Name';

  @override
  String get uiItemMode => 'Item Mode';

  @override
  String get uiDedicatedIndependentID => 'Dedicated (independent ID)';

  @override
  String get uiSemiDedicatedOneInstanceInADefinition =>
      'Semi-dedicated (one instance in a definition)';

  @override
  String get uiNonDedicatedKeepQuantity => 'Non-dedicated (keep quantity)';

  @override
  String get uiSelectACharacterRelatedItemToLink =>
      'Select a Character-Related Item to Link';

  @override
  String get uiRelated => 'Related';

  @override
  String get uiOther2 => 'Other:';

  @override
  String get uiOther3 => 'Other…';

  @override
  String get uiLookingForNewLove => 'Looking for New Love?';

  @override
  String get uiHaremStory => 'Harem Story?';

  @override
  String get uiCompactTimeline => 'Compact Timeline';

  @override
  String get uiClickOrDragToSelectTimeDiamondsMark =>
      'Click or drag to select time · Diamonds mark existing snapshots';

  @override
  String get uiCouldNotLoadSecureCopilotSettingsTheAPI =>
      'Could not load secure Copilot settings; the API key was not loaded.';

  @override
  String uiModelsRetrieved(String p1) {
    return 'Models retrieved: $p1.';
  }

  @override
  String uiAlongWith(String p1) {
    return ', along with $p1';
  }

  @override
  String get uiSendYourWorkSContent => 'Send Your Work’s Content?';

  @override
  String uiThisModeSendsTheCurrentChapterToData(
    String p1,
    String p2,
    String p3,
    String p4,
  ) {
    return 'This mode sends the current chapter “$p1”$p2 to $p3. Data goes directly to your selected model service. The app’s built-in .mnproj format reference is also included, without story content. $p4';
  }

  @override
  String get uiYourConfiguredAPIKeyWillAlsoBeSent =>
      'Your configured API key will also be sent.';

  @override
  String get uiAllowThisConnection => 'Allow This Connection';

  @override
  String get uiSendAPIKey => 'Send API Key?';

  @override
  String uiTheAPIKeyWillBeSentDirectlyTo(String p1) {
    return 'The API key will be sent directly to $p1. Make sure you trust this model service.';
  }

  @override
  String get uiRequestCancelled => 'Request cancelled.';

  @override
  String get uiSelectOrEnterAModelFirst => 'Select or enter a model first.';

  @override
  String get uiSettingsChangedThePreviousRequestWasCancelled =>
      'Settings changed. The previous request was cancelled.';

  @override
  String get uiSettingsChangedThePreviousRequestResultWasDiscarded =>
      'Settings changed. The previous request result was discarded.';

  @override
  String get uiNoAPIKeyIsSaved => 'No API key is saved.';

  @override
  String get uiClearAPIKey => 'Clear API Key?';

  @override
  String get uiThisRemovesTheAPIKeyFromThisDevice =>
      'This removes the API key from this device’s secure storage. Your work and conversations are unchanged.';

  @override
  String get uiClearKey => 'Clear Key';

  @override
  String get uiAPIKeyRemovedFromThisDevice =>
      'API key removed from this device.';

  @override
  String get uiCouldNotRemoveTheAPIKeyTryAgain =>
      'Could not remove the API key. Try again later.';

  @override
  String get uiAskPlanBetaAreControlledByFeatureFlags =>
      'Ask/Plan Beta are controlled by feature flags and read the current chapter without modifying the project. Agent is unavailable.';

  @override
  String get uiModelSelection => 'Model Selection';

  @override
  String get uiCustom => 'Custom';

  @override
  String get uiProvider => 'Provider';

  @override
  String get uiModel => 'Model';

  @override
  String get uiSelectOrEnterAModelID => 'Select or enter a model ID';

  @override
  String get uiFetch => 'Fetch';

  @override
  String get uiHideAPIKey => 'Hide API Key';

  @override
  String get uiShowAPIKey => 'Show API Key';

  @override
  String get uiClearSavedKey => 'Clear Saved Key';

  @override
  String get uiPrivacyThirdPartyServicesAndLimitations =>
      'Privacy, Third-Party Services, and Limitations';

  @override
  String get uiChatSendsYourMessagesAskPlanAlsoSend =>
      'Chat sends your messages. Ask/Plan also send the story context shown on screen. Data goes directly to your configured provider and API URL, not through Monogatari Assistant servers.';

  @override
  String get uiWhetherAProviderStoresOrUsesDataDepends =>
      'Whether a provider stores or uses data depends on its terms and your account settings. Localhost Ollama can stay on this device; other custom URLs are not necessarily private.';

  @override
  String get uiConversationsAndPlansExistOnlyForThisScreen =>
      'Conversations and plans exist only for this screen session. They are not saved in the project or restored after restart.';

  @override
  String get uiAIResponsesMayBeIncorrectPlansAreFor =>
      'AI responses may be incorrect. Plans are for review and export only and never change your work automatically. Agent is disabled.';

  @override
  String get uiConversationHistory => 'Conversation History';

  @override
  String get uiClearAll => 'Clear All';

  @override
  String get uiNoConversations => 'No Conversations';

  @override
  String get uiMessagesWillAppearHereAfterYouSendThem =>
      'Messages will appear here after you send them.';

  @override
  String get uiYou => 'You';

  @override
  String get uiTheModelSuppliedNoVerifiableStructuredSources =>
      'The model supplied no verifiable structured sources.';

  @override
  String uiCouldNotValidateThePlanTheOriginalResponse(String p1) {
    return 'Could not validate the plan: $p1\nThe original response was kept; no changes were applied.';
  }

  @override
  String get uiTheModelSuppliedNoVerifiableSources =>
      'The model supplied no verifiable sources.';

  @override
  String get uiSources => 'Sources';

  @override
  String uiUncertain(String p1) {
    return 'Uncertain: $p1';
  }

  @override
  String get uiInvalidSourcesSuppliedByTheModelWereIgnored =>
      'Invalid sources supplied by the model were ignored.';

  @override
  String uiOpenSource(String p1) {
    return 'Open Source: $p1';
  }

  @override
  String get uiPlanJSONCopied => 'Plan JSON copied.';

  @override
  String get uiPlanJSONExported => 'Plan JSON exported.';

  @override
  String get uiCouldNotExportThePlanJSONCheckThe =>
      'Could not export the plan JSON. Check the location and file permissions.';

  @override
  String get uiCopyPlanJSON => 'Copy Plan JSON';

  @override
  String get uiExportPlanJSON => 'Export Plan JSON';

  @override
  String get uiTheCurrentChapterChangedThisPlanMayBe =>
      'The current chapter changed. This plan may be outdated.';

  @override
  String uiRisk(String p1) {
    return 'Risk: $p1';
  }

  @override
  String uiToConfirm(String p1) {
    return 'To Confirm: $p1';
  }

  @override
  String get uiReadOnlyPlanNoChangesApplied =>
      'Read-only plan · No changes applied';

  @override
  String get uiCurrentChapter => 'Current Chapter';

  @override
  String get uiCurrentChapterAndProjectIndexSummary =>
      'Current chapter and project index summary';

  @override
  String get uiCurrentChapterAndSelectedSupplementalResources =>
      'Current chapter and selected supplemental resources';

  @override
  String uiSendsDirectlyToYourConfiguredModelServiceWithout(
    String p1,
    String p2,
  ) {
    return '$p1 sends $p2 directly to your configured model service without modifying the project.';
  }

  @override
  String uiSelectSupplementalResources(String p1, String p2) {
    return 'Select Supplemental Resources ($p1/$p2)';
  }

  @override
  String get uiEnterAMessageShiftEnterForANew =>
      'Enter a message; Shift+Enter for a new line, Enter to send';

  @override
  String get uiAskAboutTheCurrentChapter => 'Ask about the current chapter';

  @override
  String get uiDescribeTheChangesYouWantToPlan =>
      'Describe the changes you want to plan';

  @override
  String get uiAgentIsUnavailable => 'Agent is unavailable';

  @override
  String get uiCancelRequest => 'Cancel Request';

  @override
  String get uiSend => 'Send';

  @override
  String get uiShiftEnterNewLineEnterSend =>
      'Shift+Enter: new line · Enter: send';

  @override
  String get uiModeSelection => 'Mode Selection';

  @override
  String get uiAgentUnavailable => 'Agent (unavailable)';

  @override
  String get uiAskContext => 'Ask Context';

  @override
  String get uiCurrentChapterProjectSummary =>
      'Current Chapter + Project Summary';

  @override
  String get uiCurrentChapterSelectedResources =>
      'Current Chapter + Selected Resources';

  @override
  String get uiSelectAskSupplementalResources =>
      'Select Ask Supplemental Resources';

  @override
  String get uiSearchCharactersWorldbuildingOutlinesOrWords =>
      'Search characters, worldbuilding, outlines, or words';

  @override
  String uiSelectedOnlySelectedResourcesAreSent(String p1, String p2) {
    return 'Selected $p1/$p2; only selected resources are sent.';
  }

  @override
  String get uiNoMatchingResources => 'No matching resources.';

  @override
  String get uiClear => 'Clear';

  @override
  String get uiUseSelection => 'Use Selection';

  @override
  String get uiTruncated => ', truncated';

  @override
  String get uiProjectIndexSummaryUpToKiB =>
      ' + project index summary (up to 24 KiB)';

  @override
  String uiSelectedResourcesUpToKiB(String p1) {
    return ' + selected resources: $p1 (up to 32 KiB)';
  }

  @override
  String uiContextBytes(String p1, String p2, String p3, String p4) {
    return 'Context: $p1 ($p2 bytes$p3)$p4';
  }

  @override
  String get uiContextNoChapterSelected => 'Context: no chapter selected';

  @override
  String get uiUnknownCategory => 'Unknown Category';

  @override
  String get uiExportWordReference => 'Export Word Reference';

  @override
  String get uiExportFailedCouldNotWriteTheFile =>
      'Export failed: could not write the file.';

  @override
  String uiExportComplete2(String p1, String p2) {
    return 'Export complete: $p1\n$p2';
  }

  @override
  String get uiEmptyEntry => '(Empty Entry)';

  @override
  String get uiUnnamedCategory => '(Unnamed Category)';

  @override
  String get uiImportPreview => 'Import Preview';

  @override
  String uiCategoriesToAdd(String p1) {
    return 'Categories to add: $p1';
  }

  @override
  String uiCategoriesToMerge(String p1) {
    return 'Categories to merge: $p1';
  }

  @override
  String uiNewEntriesToImport(String p1) {
    return 'New entries to import: $p1';
  }

  @override
  String uiExistingEntriesToReuse(String p1) {
    return 'Existing entries to reuse: $p1';
  }

  @override
  String uiCategoryEntryLinksToAdd(String p1) {
    return 'Category-entry links to add: $p1';
  }

  @override
  String get uiNewCategoriesUpToShown => 'New Categories (up to 6 shown)';

  @override
  String get uiNewEntriesUpToShown => 'New Entries (up to 6 shown)';

  @override
  String get uiConfirmImport => 'Confirm Import';

  @override
  String get uiInvalidImportFileFormat => 'Invalid import file format';

  @override
  String uiImportCompleteNewCategoriesNewEntriesReusedEntries(
    String p1,
    String p2,
    String p3,
    String p4,
  ) {
    return 'Import complete. New categories: $p1; new entries: $p2; reused entries: $p3; links: $p4.';
  }

  @override
  String get uiAddCategory => 'Add Category';

  @override
  String get uiAddSubcategory => 'Add Subcategory';

  @override
  String get uiEnterACategoryName => 'Enter a category name';

  @override
  String get uiDeleteCategory => 'Delete Category';

  @override
  String uiDeleteAndItsSubcategories(String p1) {
    return 'Delete “$p1” and its subcategories?';
  }

  @override
  String get uiRemoveEntry => 'Remove Entry';

  @override
  String uiRemoveFrom(String p1, String p2) {
    return 'Remove “$p2” from “$p1”?';
  }

  @override
  String uiGroup(String p1) {
    return 'Group $p1';
  }

  @override
  String get uiDeleteThisGroup => 'Delete This Group';

  @override
  String get uiMeaning => 'Meaning';

  @override
  String get uiExample => 'Example';

  @override
  String get uiThisFeatureIsInDevelopmentAndMayContain =>
      'This feature is in development and may contain errors.';

  @override
  String get uiWordCategories => 'Word Categories';

  @override
  String get uiAddRootCategory => 'Add Root Category';

  @override
  String get uiImportExport => 'Import / Export';

  @override
  String get uiImport2 => 'Import…';

  @override
  String get uiExportDisabled => 'Export… (disabled)';

  @override
  String get uiExportSelectedCategory => 'Export Selected Category';

  @override
  String get uiExportAll => 'Export All';

  @override
  String get uiLongPressCardsToDragReorderOrMove =>
      'Long-press cards to drag, reorder, or move them into a subcategory.';

  @override
  String get uiNoWordCategories => 'No Word Categories';

  @override
  String get uiAddYourFirstCategory => 'Add your first category.';

  @override
  String get uiUnnamedCategory2 => '(Unnamed Category)';

  @override
  String uiEntries(String p1) {
    return 'Entries: $p1';
  }

  @override
  String get uiCategoryActions => 'Category Actions';

  @override
  String get uiCollapseSubcategories => 'Collapse Subcategories';

  @override
  String get uiExpandSubcategories => 'Expand Subcategories';

  @override
  String get uiRename => 'Rename';

  @override
  String get uiMoveBefore => 'Move Before';

  @override
  String get uiMoveToSubcategory => 'Move to Subcategory';

  @override
  String get uiMoveAfter => 'Move After';

  @override
  String uiLiteral2(String p1, String p2) {
    return '“$p1” $p2';
  }

  @override
  String uiMovedInto(String p1, String p2) {
    return 'Moved “$p1” into “$p2”.';
  }

  @override
  String get uiWordEntries => 'Word Entries';

  @override
  String get uiSelectAWordCategoryFirst => 'Select a Word Category First';

  @override
  String get uiLongPressEntriesToDragReorderOrMove =>
      'Long-press entries to drag, reorder, or move them to another category.';

  @override
  String get uiThisCategoryHasNoEntries => 'This category has no entries.';

  @override
  String get uiAddYourFirstEntry => 'Add your first entry.';

  @override
  String get uiEntryName => 'Entry Name';

  @override
  String get uiNoMeaningEnteredYet => 'No meaning entered yet';

  @override
  String uiPartOfSpeech(String p1) {
    return 'Part of speech: $p1';
  }

  @override
  String get uiSourceThisCategory => 'Source: this category';

  @override
  String uiSourceSubcategory(String p1) {
    return 'Source: subcategory $p1';
  }

  @override
  String get uiRemoveFromThisCategory => 'Remove from This Category';

  @override
  String uiMovedTo(String p1, String p2) {
    return 'Moved “$p1” to “$p2”.';
  }

  @override
  String get uiMeaningsAndExamples => 'Meanings and Examples';

  @override
  String get uiSelectAnEntryAbove => 'Select an entry above.';

  @override
  String get uiPartOfSpeech2 => 'Part of Speech';

  @override
  String get uiCustomPartOfSpeech => 'Custom Part of Speech';

  @override
  String get uiSentiment => 'Sentiment';

  @override
  String get uiMeaningAndExampleGroups => 'Meaning and Example Groups';

  @override
  String get uiAddGroup => 'Add Group';

  @override
  String get uiCouldNotLoadWordData => 'Could Not Load Word Data';

  @override
  String get uiWordReference => 'Word Reference';

  @override
  String get uiNewItem => 'New Item';

  @override
  String get uiArchiveItem => 'Archive Item';

  @override
  String uiArchiveExistingLinksAndHistoricalSnapshotsWillBe(
    String p1,
    String p2,
  ) {
    return 'Archive “$p1”? Existing links and historical snapshots will be kept; individual instances archived: $p2.';
  }

  @override
  String get uiUnnamedItem => 'Unnamed Item';

  @override
  String get uiArchive => 'Archive';

  @override
  String uiIndividual(String p1) {
    return '$p1 (individual)';
  }

  @override
  String get uiTheItemOrSceneChangedReopenThePreview =>
      'The item or scene changed. Reopen the preview before submitting.';

  @override
  String get uiCreateACharacterLocationOrEventBeforeAdding =>
      'Create a character, location, or event before adding an item link.';

  @override
  String get uiAddItemLink => 'Add Item Link';

  @override
  String uiIndividual2(String p1) {
    return 'Individual: $p1';
  }

  @override
  String get uiChooseLinkTarget => 'Choose Link Target';

  @override
  String get uiRelationshipPurpose => 'Relationship / Purpose';

  @override
  String get uiAddLink => 'Add Link';

  @override
  String get uiCreateACharacterOrLocationBeforeAddingA =>
      'Create a character or location before adding a quantity allocation.';

  @override
  String get uiAddQuantityAllocation => 'Add Quantity Allocation';

  @override
  String get uiAllocateTo => 'Allocate To';

  @override
  String get uiAddAllocation => 'Add Allocation';

  @override
  String get uiQuantityMustBeZeroOrAPositiveInteger2 =>
      'Quantity must be zero or a positive integer. Leave blank if unknown.';

  @override
  String get uiATransferRequiresAtLeastOneSceneAnd =>
      'A transfer requires at least one scene and another character or location.';

  @override
  String get uiTransferAggregateQuantity => 'Transfer Aggregate Quantity';

  @override
  String get uiTransferTo => 'Transfer To';

  @override
  String get uiQuantityToTransfer => 'Quantity to Transfer';

  @override
  String get uiSourceQuantityAfterTransfer => 'Source Quantity After Transfer';

  @override
  String get uiSourceQuantityIsUnknownSetItExplicitly =>
      'Source quantity is unknown; set it explicitly.';

  @override
  String get uiDestinationQuantityAfterTransfer =>
      'Destination Quantity After Transfer';

  @override
  String get uiDestinationQuantityIsUnknownSetItExplicitly =>
      'Destination quantity is unknown; set it explicitly.';

  @override
  String get uiCreateTransferSnapshot => 'Create Transfer Snapshot';

  @override
  String get uiAddTheSceneToTheTimelineBeforeSeparating =>
      'Add the scene to the timeline before separating an individual item.';

  @override
  String get uiCreateDedicatedItem => 'Create Dedicated Item';

  @override
  String get uiSeparateItemFromAggregateQuantity =>
      'Separate Item from Aggregate Quantity';

  @override
  String get uiCreatedInScene => 'Created in Scene';

  @override
  String get uiThisAggregateAllocationDoesNotExistInThe =>
      'This aggregate allocation does not exist in the selected scene.';

  @override
  String get uiSourceQuantityIsUnknownInTheSelectedScene =>
      'Source quantity is unknown in the selected scene.';

  @override
  String uiSourceQuantityInSelectedScene(String p1) {
    return 'Source quantity in selected scene: $p1';
  }

  @override
  String get uiIndividualItemName => 'Individual Item Name';

  @override
  String get uiSourceQuantityAfterSeparation =>
      'Source Quantity After Separation';

  @override
  String get uiConversionNotes => 'Conversion Notes';

  @override
  String get uiCreateIndividualItem => 'Create Individual Item';

  @override
  String get uiCreatedAnIndividualItemFromTheAggregateQuantity =>
      'Created an individual item from the aggregate quantity.';

  @override
  String get uiAddTheSceneToTheTimelineBeforeConverting =>
      'Add the scene to the timeline before converting to non-dedicated mode.';

  @override
  String get uiSafelyConvertToNonDedicated => 'Safely Convert to Non-dedicated';

  @override
  String get uiConversionScene => 'Conversion Scene';

  @override
  String uiAggregateExistingIndividualItemsIntoQuantityAllocations(
    String p1,
    String p2,
  ) {
    return 'Aggregate $p1 existing individual items into $p2 quantity allocations.';
  }

  @override
  String get uiTheOriginalClassInstanceIDsSnapshotsAndGeneral =>
      'The original class, instance IDs, snapshots, and general links remain as archived history.';

  @override
  String get uiCreateAggregateClass => 'Create Aggregate Class';

  @override
  String get uiCreatedANewNonDedicatedAggregateClass =>
      'Created a new non-dedicated aggregate class.';

  @override
  String get uiConvertingToDedicatedModeRequiresOneAllocationWith =>
      'Converting to dedicated mode requires one allocation with a quantity of 1. Switch to semi-dedicated mode first to separate items.';

  @override
  String get uiMultipleFixedIDsCannotBeMergedDirectlyInto =>
      'Multiple fixed IDs cannot be merged directly into a single dedicated item.';

  @override
  String get uiSeparateAllRemainingAggregateQuantitiesBeforeConvertingTo =>
      'Separate all remaining aggregate quantities before converting to dedicated mode.';

  @override
  String get uiMoveWorldbuildingItems => 'Move Worldbuilding Items';

  @override
  String uiMoveWorldbuildingItemsToTheItemsPageIDs(String p1) {
    return 'Move $p1 worldbuilding items to the Items page. IDs, content, and source paths will be preserved.';
  }

  @override
  String get uiMove => 'Move';

  @override
  String uiMovedItems(String p1, String p2) {
    return 'Moved $p1 items$p2';
  }

  @override
  String uiNeedAttention(String p1) {
    return ', $p1 need attention';
  }

  @override
  String get uiAddTheSceneToTheTimelineBeforeAdding =>
      'Add the scene to the timeline before adding an item snapshot.';

  @override
  String get uiAddItemSceneSnapshot => 'Add Item Scene Snapshot';

  @override
  String get uiDuplicateItemSceneSnapshot => 'Duplicate Item Scene Snapshot';

  @override
  String get uiExistsAtThisPoint => 'Exists at This Point';

  @override
  String get uiHolder => 'Holder';

  @override
  String uiNotFound(String p1) {
    return 'Not found: $p1';
  }

  @override
  String get uiLocation2 => 'Location';

  @override
  String get uiAddTheSceneToTheTimelineBeforeAdding2 =>
      'Add the scene to the timeline before adding an individual item snapshot.';

  @override
  String uiSceneSnapshot(String p1, String p2) {
    return '$p1 “$p2” Scene Snapshot';
  }

  @override
  String get uiItemSettings => 'Item Settings';

  @override
  String uiMoveItemsFromWorldbuilding(String p1) {
    return 'Move $p1 Items from Worldbuilding';
  }

  @override
  String get uiAddItem => 'Add Item';

  @override
  String get uiSelectAnItemFirst => 'Select an item first';

  @override
  String get uiSelectAnItemToPreviewItsTimelineAnd =>
      'Select an item to preview its timeline and manage snapshots';

  @override
  String get uiItemList => 'Item List';

  @override
  String get uiSearchItems => 'Search Items';

  @override
  String get uiManagementMode => 'Management Mode';

  @override
  String get uiOwnership => 'Ownership';

  @override
  String get uiAssigned => 'Assigned';

  @override
  String get uiUnassigned => 'Unassigned';

  @override
  String get uiCategory => 'Category';

  @override
  String get uiAllCategories => 'All Categories';

  @override
  String get uiNoItemsYet => 'No items yet';

  @override
  String get uiAddYourFirstItem => 'Add Your First Item';

  @override
  String uiIndividualItemsLinks(String p1, String p2, String p3, String p4) {
    return '$p1 · $p2 individual items · $p3 links$p4';
  }

  @override
  String get uiAssigned2 => ' · Assigned';

  @override
  String get uiEditItem => 'Edit Item';

  @override
  String get uiItemDetails => 'Item Details';

  @override
  String get uiSelectOrAddAnItem => 'Select or Add an Item';

  @override
  String get uiItemModeSnapshotsOwnershipAndLinksAppearHere =>
      'Item mode, snapshots, ownership, and links appear here';

  @override
  String get uiDeleteCurrentSnapshot => 'Delete Current Snapshot';

  @override
  String get uiNoSnapshotSelected => 'No snapshot selected';

  @override
  String get uiCurrentStoryState => 'Current Story State';

  @override
  String get uiNoSnapshots => 'No Snapshots';

  @override
  String get uiExists => 'Exists';

  @override
  String get uiDoesNotExistYet => 'Does Not Exist Yet';

  @override
  String get uiStateNotSet => 'State Not Set';

  @override
  String uiHolder2(String p1) {
    return 'Holder: $p1';
  }

  @override
  String uiLocation3(String p1) {
    return 'Location: $p1';
  }

  @override
  String uiSnapshotHistory(String p1) {
    return 'Snapshot History ($p1)';
  }

  @override
  String get uiLinkThisScene => 'Link This Scene';

  @override
  String get uiRemoveSnapshot => 'Remove Snapshot';

  @override
  String get uiDoesNotExistInThisScene => 'Does Not Exist in This Scene';

  @override
  String get uiExistsInThisScene => 'Exists in This Scene';

  @override
  String get uiName2 => 'Name';

  @override
  String get uiQuantityUnit => 'Quantity Unit';

  @override
  String get uiDescription => 'Description';

  @override
  String get uiIndividualItems => 'Individual Items';

  @override
  String get uiAddIndividualItem => 'Add Individual Item';

  @override
  String get uiNoIndividualItemsCreatedYet =>
      'No individual items created yet.';

  @override
  String get uiLinks => 'Links';

  @override
  String get uiNoCharactersLocationsOrEventsLinkedYet =>
      'No characters, locations, or events linked yet.';

  @override
  String get uiRemoveLink => 'Remove Link';

  @override
  String get uiNonDedicatedModeUsesClassesAndAggregateAllocations =>
      'Non-dedicated mode uses classes and aggregate allocations without individual IDs.';

  @override
  String get uiSemiDedicatedModeKeepsUnidentifiedAggregateQuantitiesAnd =>
      'Semi-dedicated mode keeps unidentified aggregate quantities and lets you separate fixed IDs in a scene.';

  @override
  String get uiThisSectionShowsHistoricalAggregateQuantitiesFromBefore =>
      'This section shows historical aggregate quantities from before conversion to dedicated mode.';

  @override
  String uiAllocatedQuantity(String p1, String p2, String p3) {
    return 'Allocated quantity: $p1$p2$p3';
  }

  @override
  String get uiPlusAnUnknownQuantity => ', plus an unknown quantity';

  @override
  String get uiNoQuantityAllocatedYet => 'No quantity allocated yet.';

  @override
  String get uiAllocationTargetNotFound => 'Allocation target not found';

  @override
  String get uiUnallocated => 'Unallocated';

  @override
  String get uiUnknownQuantity => 'Unknown Quantity';

  @override
  String get uiSeparateIndividualItem => 'Separate Individual Item';

  @override
  String get uiRemoveDefaultAllocation => 'Remove Default Allocation';

  @override
  String get uiOutline => 'Outline';

  @override
  String get uiStorylines => 'Storylines';

  @override
  String get uiNoStorylinesYet => 'No storylines yet';

  @override
  String get uiStorylineName => 'Storyline Name';

  @override
  String get uiStorylineTheBroadDirectionOfYourStoryUse =>
      'Storyline: the broad direction of your story. Use structures such as three acts, introduction–development–turn–conclusion, or seven story steps.';

  @override
  String get uiUntitledStoryline => '(Untitled Storyline)';

  @override
  String get uiUntitledEvent => '(Untitled Event)';

  @override
  String get uiUntitledScene => '(Untitled Scene)';

  @override
  String get uiStorylineDetails => 'Storyline Details';

  @override
  String get uiTypeEGOpeningMiddleClimaxEnding =>
      'Type (e.g. opening, middle, climax, ending)';

  @override
  String get uiMainConflict => 'Main Conflict';

  @override
  String get uiEnterNotes => 'Enter notes…';

  @override
  String get uiEvents => 'Events';

  @override
  String get uiNoEventsInThisStorylineYet => 'No events in this storyline yet';

  @override
  String get uiEventName => 'Event Name';

  @override
  String get uiSelectAStorylineFirst => 'Select a storyline first';

  @override
  String get uiSelectAStorylineToAddAndEditEvents =>
      'Select a storyline to add and edit events';

  @override
  String get uiEventASpecificOccurrenceInTheStory =>
      'Event: a specific occurrence in the story.';

  @override
  String get uiTypeNotSet => 'Type Not Set';

  @override
  String get uiDeleteStoryline => 'Delete Storyline';

  @override
  String uiEventMovedTo(String p1) {
    return 'Event moved to “$p1”';
  }

  @override
  String uiScenes(String p1) {
    return 'Scenes: $p1';
  }

  @override
  String get uiDeleteEvent => 'Delete Event';

  @override
  String get uiEventDetails => 'Event Details';

  @override
  String get uiPointOfConflict => 'Point of Conflict';

  @override
  String get uiDefaultCharacters => 'Default Characters';

  @override
  String get uiItemAllocations => 'Item Allocations';

  @override
  String get uiNoTrackedItemsAllocatedYet => 'No tracked items allocated yet.';

  @override
  String get uiItemClass => 'Item Class';

  @override
  String get uiChooseAnEventItemToLink => 'Choose an event item to link';

  @override
  String get uiOutlineObjects => 'Outline Objects';

  @override
  String get uiTheseAreLegacyTextObjectsConvertThemTo =>
      'These are legacy text objects. Convert them to tracked items; new objects no longer use the legacy format.';

  @override
  String get uiRemoveAllocation => 'Remove Allocation';

  @override
  String get uiChooseAnItemToAllocateToTheScene =>
      'Choose an item to allocate to the scene';

  @override
  String get uiAfterConversionThisLegacyTextIsReplacedWith =>
      'After conversion, this legacy text is replaced with a link to a trackable item ID.';

  @override
  String get uiCreateAndLink => 'Create and Link';

  @override
  String uiChooseTheItemFor(String p1) {
    return 'Choose the item for “$p1”';
  }

  @override
  String get uiConvertedToATrackedItemLink =>
      'Converted to a tracked item link.';

  @override
  String get uiNonDedicatedClassOnly => 'Non-dedicated (Class Only)';

  @override
  String uiConvertedFromLegacyText(String p1) {
    return 'Converted from legacy text “$p1”';
  }

  @override
  String get uiScenes2 => 'Scenes';

  @override
  String get uiNoScenesYet => 'No scenes yet';

  @override
  String get uiSceneName2 => 'Scene Name';

  @override
  String get uiSelectAnEventFirst => 'Select an event first';

  @override
  String get uiSelectAnEventToAddAndEditScenes =>
      'Select an event to add and edit scenes';

  @override
  String get uiSceneADetailedSceneWithinAnEvent =>
      'Scene: a detailed scene within an event.';

  @override
  String get uiDeleteScene => 'Delete Scene';

  @override
  String get uiSceneDetails => 'Scene Details';

  @override
  String get uiTime => 'Time';

  @override
  String get uiFocus => 'Focus';

  @override
  String get uiAction => 'Action';

  @override
  String uiStoryline2(String p1) {
    return 'Storyline $p1';
  }

  @override
  String uiEvent3(String p1) {
    return 'Event $p1';
  }

  @override
  String uiScene(String p1) {
    return 'Scene $p1';
  }

  @override
  String uiSkippedOrRepairedPaletteDataIssues(String p1) {
    return 'Skipped or repaired $p1 palette data issues.';
  }

  @override
  String uiCouldNotReadPaletteData(String p1) {
    return 'Could not read palette data: $p1';
  }

  @override
  String uiDeleted(String p1) {
    return 'Deleted “$p1”';
  }

  @override
  String get uiExportTextPalette => 'Export Text Palette';

  @override
  String uiPaletteExported(String p1) {
    return 'Palette exported: $p1';
  }

  @override
  String uiPaletteExportFailed(String p1) {
    return 'Palette export failed: $p1';
  }

  @override
  String get uiImportTextPalette => 'Import Text Palette';

  @override
  String uiWithFormatIssuesSkipped(String p1) {
    return ', with $p1 format issues skipped';
  }

  @override
  String uiImportedPaletteEntriesSkippedDuplicates(
    String p1,
    String p2,
    String p3,
  ) {
    return 'Imported $p1 palette entries; skipped $p2 duplicates$p3';
  }

  @override
  String get uiPaletteImportFailedInvalidFormatOrUnreadableFile =>
      'Palette import failed: invalid format or unreadable file';

  @override
  String get uiCouldNotLoadPalettes => 'Could Not Load Palettes';

  @override
  String get uiNotSavedToDiskYet => 'Not saved to disk yet';

  @override
  String get uiTextPalettes => 'Text Palettes';

  @override
  String get uiSearchEntries => 'Search entries…';

  @override
  String get uiImportOrExportPalettes => 'Import or Export Palettes';

  @override
  String get uiImportPalette => 'Import Palette…';

  @override
  String get uiExportPalette => 'Export Palette…';

  @override
  String get uiGrayscale => 'Grayscale';

  @override
  String uiHueSaturationBrightness(String p1) {
    return 'Hue $p1°, saturation 80%, brightness 100%';
  }

  @override
  String uiEntries2(String p1, String p2) {
    return '$p1, $p2 entries';
  }

  @override
  String uiEntries3(String p1) {
    return 'Entries: $p1';
  }

  @override
  String get uiColorCellActions => 'Color Cell Actions';

  @override
  String get uiSortByText => 'Sort by Text';

  @override
  String uiEdit2(String p1) {
    return 'Edit “$p1”';
  }

  @override
  String get uiAddEntry => 'Add Entry';

  @override
  String get uiEnterATerm => 'Enter a term';

  @override
  String uiNoEntriesContaining(String p1) {
    return 'No entries containing “$p1”';
  }

  @override
  String get uiForeshadowingList => 'Foreshadowing List';

  @override
  String get uiNoForeshadowingYet => 'No foreshadowing yet';

  @override
  String get uiAddYourFirstEntry2 => 'Add your first entry';

  @override
  String get uiAddForeshadowing => 'Add Foreshadowing';

  @override
  String get uiSelectAForeshadowingEntry => 'Select a foreshadowing entry';

  @override
  String get uiSelectAnEntryToEditItsContent =>
      'Select an entry to edit its content';

  @override
  String get uiForeshadowingName => 'Foreshadowing Name';

  @override
  String get uiRevealed => 'Revealed';

  @override
  String get uiReleasePlans => 'Release Plans';

  @override
  String get uiNoReleasePlansYet => 'No release plans yet';

  @override
  String get uiAddReleasePlan => 'Add Release Plan';

  @override
  String get uiSelectAReleasePlan => 'Select a release plan';

  @override
  String get uiPlanName => 'Plan Name';

  @override
  String get uiCompleted => 'Completed';

  @override
  String get uiIdeaList => 'Idea List';

  @override
  String get uiNoIdeasYet => 'No ideas yet';

  @override
  String get uiAddAFolderOrIdea => 'Add a folder or idea';

  @override
  String get uiExpand => 'Expand';

  @override
  String get uiFolder2 => 'Folder';

  @override
  String get uiIdea => 'Idea';

  @override
  String get uiSelectAnIdea => 'Select an idea';

  @override
  String get uiIdeaTitle => 'Idea Title';

  @override
  String get uiIdeaNotes => 'Idea Notes';

  @override
  String get uiPlanning => 'Planning';

  @override
  String uiCouldNotLoadTheFillerWordDictionary(String p1) {
    return 'Could not load the filler word dictionary: $p1';
  }

  @override
  String get uiProofreading => 'Proofreading';

  @override
  String get uiCheckYourTextHere => 'Check your text here.';

  @override
  String uiCurrentTextLengthCharacters(String p1) {
    return 'Current text length: $p1 characters';
  }

  @override
  String get uiLoadingFillerWordDictionary => 'Loading filler word dictionary';

  @override
  String uiFillerWordDictionaryLoadedEntries(String p1) {
    return 'Filler word dictionary loaded: $p1 entries';
  }

  @override
  String get uiQuoteAndBracketMatching => 'Quote and Bracket Matching';

  @override
  String uiTooManyResultsOnlyInitialSamplesAreShown(String p1) {
    return 'Too many results; only initial samples are shown for each check. Total: $p1.';
  }

  @override
  String get uiPunctuationAnomalies => 'Punctuation Anomalies';

  @override
  String get uiLineEndingCheck => 'Line Ending Check';

  @override
  String get uiPunctuationConsistency => 'Punctuation Consistency';

  @override
  String get uiFillerWordCheck => 'Filler Word Check';

  @override
  String get uiFillerWordRatio => 'Filler Word Ratio';

  @override
  String get uiCheckSettings => 'Check Settings';

  @override
  String uiShowMoreRemaining(String p1) {
    return 'Show More ($p1 Remaining)';
  }

  @override
  String get uiCheckPairedAndUnclosedDelimiters =>
      'Check paired and unclosed delimiters';

  @override
  String get uiCheckRepeatedPunctuationAndQuoteNesting =>
      'Check repeated punctuation and quote nesting';

  @override
  String get uiFindPunctuationThatCanBeStandardized =>
      'Find punctuation that can be standardized';

  @override
  String get uiFindFillerWordsListedInTheDictionary =>
      'Find filler words listed in the dictionary';

  @override
  String get uiCheckLineEndingsAgainstTheRules =>
      'Check line endings against the rules';

  @override
  String get uiLineEndingOptions => 'Line Ending Options';

  @override
  String get uiIgnoreCommasAtLineEnd => 'Ignore Commas at Line End';

  @override
  String get uiDoNotFlagLinesEndingInOr => 'Do not flag lines ending in , or ，';

  @override
  String get uiIgnoreDashesAtLineEnd => 'Ignore Dashes at Line End';

  @override
  String get uiDoNotFlagLinesEndingInOr2 =>
      'Do not flag lines ending in — or -';

  @override
  String get uiIgnoreEllipsesAtLineEnd => 'Ignore Ellipses at Line End';

  @override
  String get uiDoNotFlagLinesEndingInOr3 =>
      'Do not flag lines ending in … or ……';

  @override
  String get uiIgnoreColonsAtLineEnd => 'Ignore Colons at Line End';

  @override
  String get uiDoNotFlagLinesEndingInOr4 =>
      'Do not flag lines ending in : or ：';

  @override
  String get uiIgnoreSemicolonsAtLineEnd => 'Ignore Semicolons at Line End';

  @override
  String get uiDoNotFlagLinesEndingIn => 'Do not flag lines ending in ；';

  @override
  String get uiFormatOptions => 'Format Options';

  @override
  String get uiPunctuationStyle => 'Punctuation Style';

  @override
  String get uiChooseAStyle => 'Choose a style';

  @override
  String uiCurrentStyle(String p1) {
    return 'Current style: $p1';
  }

  @override
  String get uiDetectLatinScriptSentences => 'Detect Latin-script Sentences';

  @override
  String get uiAutomaticallyUseLatinPunctuationWhenLatinTextIs =>
      'Automatically use Latin punctuation when Latin text is detected';

  @override
  String get uiLatinScriptDetectionOptions => 'Latin-script Detection Options';

  @override
  String get uiAllowCJKQuotesBracketsAtWordEnd =>
      'Allow CJK Quotes / Brackets at Word End';

  @override
  String get uiAllowCJKQuotesAndBracketsAfterLatinText =>
      'Allow CJK quotes and brackets after Latin text';

  @override
  String get uiAllowCJKExclamationQuestionMarksAtWordEnd =>
      'Allow CJK Exclamation / Question Marks at Word End';

  @override
  String get uiAllowAndAfterLatinText => 'Allow ！ and ？ after Latin text';

  @override
  String get uiAllowCJKPunctuationAroundCJKText =>
      'Allow CJK Punctuation Around CJK Text';

  @override
  String get uiDoNotTreatCJKPunctuationAsLatinContinuation =>
      'Do not treat CJK punctuation as Latin continuation when either side is a line boundary or CJK text';

  @override
  String get uiThisCheckIsDisabled => 'This check is disabled.';

  @override
  String get uiEnterSomeTextFirst => 'Enter some text first.';

  @override
  String get uiNoUnclosedDelimitersFound => 'No unclosed delimiters found.';

  @override
  String get uiNoCheckRunYet => 'No check run yet.';

  @override
  String get uiPunctuationIsConsistentNoChangesNeeded =>
      'Punctuation is consistent; no changes needed.';

  @override
  String uiFoundPunctuationMarksThatCanBeStandardized(String p1) {
    return 'Found $p1 punctuation marks that can be standardized.';
  }

  @override
  String get uiResolveAll => 'Resolve All';

  @override
  String get uiNoPunctuationAnomaliesFound => 'No punctuation anomalies found.';

  @override
  String uiSuggestion(String p1) {
    return 'Suggestion: $p1';
  }

  @override
  String get uiNoLineEndingIssuesFound => 'No line ending issues found.';

  @override
  String get uiNoDictionaryFillerWordsFound =>
      'No dictionary filler words found.';

  @override
  String get uiClickAFillerWordBelowToExpandIts =>
      'Click a filler word below to expand its locations.';

  @override
  String uiOccurrences(String p1) {
    return 'Occurrences: $p1';
  }

  @override
  String uiShowingOnlyTheFirstLocations(String p1) {
    return 'Showing only the first $p1 locations.';
  }

  @override
  String uiTotalFillerWordOccurrences(String p1) {
    return 'Total filler word occurrences: $p1';
  }

  @override
  String uiEffectiveWordCount(String p1) {
    return 'Effective word count: $p1';
  }

  @override
  String uiFillerWordRatio2(String p1) {
    return 'Filler word ratio: $p1%';
  }

  @override
  String get uiAllowUnrestrictedBatteryUsageInTheSystemPrompt =>
      'Allow unrestricted battery usage in the system prompt.';

  @override
  String get uiCouldNotOpenBackgroundExecutionPermissions =>
      'Could not open background execution permissions.';

  @override
  String get uiMCPHostConfigurationCopiedPasteItIntoYour =>
      'MCP Host configuration copied. Paste it into your Host\'s MCP settings.';

  @override
  String get uiAppearanceAndInterface => 'Appearance and Interface';

  @override
  String get uiThemeNavigationToolbarAndFonts =>
      'Theme, navigation, toolbar, and fonts';

  @override
  String get uiCustomizeToolbarItems => 'Customize Toolbar Items';

  @override
  String get uiEditingAndInput => 'Editing and Input';

  @override
  String get uiSmartSuggestionsOverwriteIndentationAndWordCount =>
      'Smart suggestions, overwrite, indentation, and word count';

  @override
  String get uiWritingGoals => 'Writing Goals';

  @override
  String get uiDailyProgressAndDefaultChapterAndProjectGoals =>
      'Daily progress and default chapter and project goals';

  @override
  String get uiSavingAndBackups => 'Saving and Backups';

  @override
  String get uiAutosaveBackupScheduleAndStorageLimits =>
      'Autosave, backup schedule, and storage limits';

  @override
  String get uiSyncAndConnections => 'Sync and Connections';

  @override
  String get uiDevicePairingPersistentAuthenticationAndBackgroundExecution =>
      'Device pairing, persistent authentication, and background execution';

  @override
  String get uiExternalIntegrations => 'External Integrations';

  @override
  String get uiReadOnlyMCPProjectAccessAndAuthorization =>
      'Read-only MCP project access and authorization';

  @override
  String get uiEnablePoppinIntelliSense => 'Enable Poppin IntelliSense';

  @override
  String get uiShowSuggestionsNearTheCursorWhenEnteringA =>
      'Show suggestions near the cursor when entering a marker type, /, or \\';

  @override
  String get uiEnableOverwriteMode => 'Enable Overwrite Mode';

  @override
  String get uiUseInsOrTheStatusBarToToggle =>
      'Use Ins or the status bar to toggle overwrite mode. When disabled, use insert mode.';

  @override
  String get uiSpacesAndIndentation => 'Spaces and Indentation';

  @override
  String get uiSpacesPerTab => 'Spaces per Tab';

  @override
  String get uiNumberOfSpacesInsertedByTabOrAutomatic =>
      'Number of spaces inserted by Tab or automatic indentation';

  @override
  String get uiUseFullWidthSpaces => 'Use Full-width Spaces';

  @override
  String get uiUseHalfWidthSpacesWhenDisabled =>
      'Use half-width spaces when disabled';

  @override
  String get uiAutomaticallyIndentNewLines => 'Automatically Indent New Lines';

  @override
  String get uiInsertConfiguredSpacesAfterEnterShiftEnterInserts =>
      'Insert configured spaces after Enter; Shift+Enter inserts only a line break';

  @override
  String get uiUpdateManuscriptMentionsWhenAliasesChange =>
      'Update Manuscript Mentions When Aliases Change';

  @override
  String get uiUpdateMarkersForTheSameCharacterWhoseDisplay =>
      'Update markers for the same character whose display text matches the previous alias';

  @override
  String get uiDisabled2 => 'Disabled';

  @override
  String get uiCreatingLocalAuthorization => 'Creating local authorization…';

  @override
  String uiAuthorizedLocalReadOnly(String p1) {
    return 'Authorized: $p1 (local, read-only)';
  }

  @override
  String get uiAuthorizationExpired => 'Authorization Expired';

  @override
  String get uiCouldNotEnable => 'Could Not Enable';

  @override
  String get uiReadOnlyMCPIntegration => 'Read-only MCP Integration';

  @override
  String uiExposeOnlyTheAuthorizedProjectSSummaryChapters(String p1) {
    return 'Expose only the authorized project\'s summary, chapters, characters, worldbuilding, outline, and terms. No editing tools are provided.$p1';
  }

  @override
  String get uiTheMCPSidecarSupportsWindowsMacOSAndLinux =>
      'The MCP sidecar supports Windows, macOS, and Linux only.';

  @override
  String uiConnectionConfiguration(String p1) {
    return 'Connection configuration: $p1';
  }

  @override
  String get uiAnMCPHostHasClaimedTheOneTime =>
      'An MCP Host has claimed the one-time authorization. Stop and enable again to connect another Host.';

  @override
  String get uiCopyMCPHostConfiguration => 'Copy MCP Host Configuration';

  @override
  String get uiStopCurrentAuthorization => 'Stop Current Authorization';

  @override
  String get uiAllowOneSidedPairingConfirmation =>
      'Allow One-sided Pairing Confirmation';

  @override
  String get uiRequiresBothDevicesToEnableThisOptionAfter =>
      'Requires both devices to enable this option. After one confirms, the other verifies the signature and automatically signs back.';

  @override
  String get uiPersistentAuthenticationDays =>
      'Persistent Authentication (14 Days)';

  @override
  String get uiRequiresBothDevicesToEnableThisOptionAuthenticate =>
      'Requires both devices to enable this option. Authenticate automatically within the period; each successful connection renews it for 14 days.';

  @override
  String get uiAllowBackgroundExecution => 'Allow Background Execution';

  @override
  String get uiUnrestrictedBatteryUsageIsAllowed =>
      'Unrestricted battery usage is allowed';

  @override
  String get uiReduceTheChanceOfTheSystemSuspendingActive =>
      'Reduce the chance of the system suspending active background tasks';

  @override
  String get uiAllowed => 'Allowed';

  @override
  String get uiAllow => 'Allow';

  @override
  String get uiFontSize => 'Font Size';

  @override
  String get uiIconsOnly => 'Icons Only';

  @override
  String get uiIconsAndLabels => 'Icons and Labels';

  @override
  String get uiExpandOnClick => 'Expand on Click';

  @override
  String get uiExpandOnHover => 'Expand on Hover';

  @override
  String get uiNavigationStyle => 'Navigation Style';

  @override
  String get uiHomeStaysAtTheTopSettingsAndAbout =>
      'Home stays at the top; Settings and About stay at the bottom. Narrow windows use a button to open navigation.';

  @override
  String get uiLight => 'Light';

  @override
  String get uiDark => 'Dark';

  @override
  String get uiThemeMode => 'Theme Mode';

  @override
  String get uiFollowTheSystemSLightOrDarkAppearance =>
      'Follow the system\'s light or dark appearance.';

  @override
  String uiUseAppearance(String p1) {
    return 'Use $p1 appearance.';
  }

  @override
  String uiCurrentlyUsingMode(String p1) {
    return 'Currently using: $p1 mode';
  }

  @override
  String get uiWordCountMode => 'Word Count Mode';

  @override
  String get uiCharacterCountNotRecommended =>
      'Character Count (Not Recommended)';

  @override
  String get uiFullWidthCharactersHalfWidthWords =>
      'Full-width Characters + Half-width Words';

  @override
  String get uiCharactersNotRecommended => 'Characters (Not Recommended)';

  @override
  String get uiMixedMode => 'Mixed Mode';

  @override
  String get uiSaveOnAScheduleRequiresAnExistingFile =>
      'Save on a schedule (requires an existing file)';

  @override
  String get uiCreateScheduledProjectBackupsWithoutOverwritingTheOriginal =>
      'Create scheduled project backups without overwriting the original';

  @override
  String get uiMaximumBackupStorage => 'Maximum Backup Storage';

  @override
  String get uiOpen => 'Open';

  @override
  String get uiChooseAgain => 'Choose Again';

  @override
  String get uiChoose => 'Choose';

  @override
  String get uiAutoBackupFolderOptions => 'AutoBackup Folder Options';

  @override
  String get uiReset => 'Reset';

  @override
  String uiMBBackups(String p1, String p2, String p3) {
    return '$p1 / $p2 MB · $p3 backups';
  }

  @override
  String get uiDeleteAllBackups => 'Delete All Backups';

  @override
  String uiDeletedBackupsFreeing(String p1, String p2) {
    return 'Deleted $p1 backups, freeing $p2.';
  }

  @override
  String uiOpenedAutoBackupFolder(String p1) {
    return 'Opened AutoBackup folder: $p1';
  }

  @override
  String uiAutoBackupFolderSet(String p1) {
    return 'AutoBackup folder set: $p1';
  }

  @override
  String uiAutoBackupFolderReset(String p1) {
    return 'AutoBackup folder reset: $p1';
  }

  @override
  String get uiComingSoon => 'Coming Soon';

  @override
  String get uiTimeline => 'Timeline';

  @override
  String uiFoundMissingReferencesDataHasBeenPreservedRelink(String p1) {
    return 'Found $p1 missing references. Data has been preserved; relink or remove the affected nodes.';
  }

  @override
  String get uiSearchTimeline => 'Search Timeline';

  @override
  String get uiAllStateChanges => 'All State Changes';

  @override
  String get uiCharacters3 => 'Characters';

  @override
  String get uiMainTimeline => 'Main Timeline';

  @override
  String get uiAddStoryline => 'Add Storyline';

  @override
  String get uiAddEvent => 'Add Event';

  @override
  String get uiAddScene => 'Add Scene';

  @override
  String get uiScenesAreLeafNodes => 'Scenes are leaf nodes';

  @override
  String get uiCurrentChapterOnly => 'Current Chapter Only';

  @override
  String get uiNoChapterLinked => 'No Chapter Linked';

  @override
  String get uiAutomaticallySortOutlineSortByStartTickAnd =>
      'Automatically Sort Outline\nSort by start tick and track order; changes to outline order also update the timeline.';

  @override
  String get uiShowEmptyTimelineRanges => 'Show Empty Timeline Ranges';

  @override
  String get uiSkipEmptyTimelineRanges => 'Skip Empty Timeline Ranges';

  @override
  String get uiReturnToCurrentTimeline => 'Return to Current Timeline';

  @override
  String get uiVisibleTickWidth => 'Visible Tick Width';

  @override
  String get uiCurrentTick2 => 'Current Tick';

  @override
  String get uiUnscheduledStorylines => 'Unscheduled Storylines';

  @override
  String get uiAllOutlineStorylinesAreSynced =>
      'All outline storylines are synced';

  @override
  String get uiSyncCreatesOrCompletesTheEntireStorylineEvent =>
      'Sync creates or completes the entire storyline, event, and scene hierarchy. It does not add a single scene to the current event.';

  @override
  String get uiUntitledStoryline2 => 'Untitled Storyline';

  @override
  String uiTimelineStorylineMissingContainsEventsAndScenes(
    String p1,
    String p2,
  ) {
    return 'Timeline storyline missing; contains $p1 events and $p2 scenes';
  }

  @override
  String uiMissingEventsAndScenes(String p1, String p2) {
    return 'Missing $p1 events and $p2 scenes';
  }

  @override
  String get uiSyncEntireStoryline => 'Sync Entire Storyline';

  @override
  String get uiStoryTimeScale => 'Story Time Scale';

  @override
  String get uiTickUnit => 'Tick Unit';

  @override
  String get uiUnitsPerTick => 'Units per Tick';

  @override
  String get uiTicksPerScene => 'Ticks per Scene';

  @override
  String get uiScenesPerEvent => 'Scenes per Event';

  @override
  String get uiEventsPerStoryline => 'Events per Storyline';

  @override
  String uiTickSceneTicksEventTicksStorylineTicks(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  ) {
    return '1 tick = $p1 $p2; 1 scene = $p3 ticks; 1 event = $p4 ticks; 1 storyline = $p5 ticks.';
  }

  @override
  String get uiNodeName => 'Node Name';

  @override
  String get uiRequiredWhenNoSceneIsSelected =>
      'Required when no scene is selected';

  @override
  String get uiAddingAnEventAlsoCreatesItsCorrespondingOutline =>
      'Adding an event also creates its corresponding outline event.';

  @override
  String get uiOutlineSceneOptional => 'Outline Scene (Optional)';

  @override
  String get uiCreateNewOutlineScene => 'Create New Outline Scene';

  @override
  String get uiUntitledScene2 => 'Untitled Scene';

  @override
  String get uiAddTrack => 'Add Track';

  @override
  String get uiTrackName => 'Track Name';

  @override
  String get uiRenameTrack => 'Rename Track';

  @override
  String get uiDeleteTrack => 'Delete Track';

  @override
  String get uiNodesMoveToAnotherTrackOutlineScenesWill =>
      'Nodes move to another track. Outline scenes will not be deleted.';

  @override
  String get uiChooseAChapterToOpen => 'Choose a Chapter to Open';

  @override
  String get uiDeleteTimelineNode => 'Delete Timeline Node';

  @override
  String get uiThisDeletesTheNodeAndItsChildrenOutline =>
      'This deletes the node and its children. Outline scenes and chapter content will be preserved.';

  @override
  String get uiLinkChaptersAndApplyToAllChildren =>
      'Link Chapters and Apply to All Children';

  @override
  String get uiChooseLinkedChapters => 'Choose Linked Chapters';

  @override
  String uiAllChildScenesWillUseTheSameChapter(String p1) {
    return 'All $p1 child scenes will use the same chapter selection.';
  }

  @override
  String get uiNoChaptersYet => 'No chapters yet';

  @override
  String uiCurrentlyChildScenes(String p1, String p2, String p3) {
    return '$p1 · Currently $p2/$p3 child scenes';
  }

  @override
  String uiTimeScrubberCurrentlyTicks(String p1) {
    return 'Time scrubber, currently $p1 ticks';
  }

  @override
  String uiDragCurrentTimeTicks(String p1) {
    return 'Drag current time: $p1 ticks';
  }

  @override
  String get uiTrack => 'Track';

  @override
  String get uiTrackOptions => 'Track Options';

  @override
  String get commonRename => 'Rename';

  @override
  String get uiExpandTrack => 'Expand Track';

  @override
  String get uiCollapseTrack => 'Collapse Track';

  @override
  String get uiMoveUp => 'Move Up';

  @override
  String get uiMoveDown => 'Move Down';

  @override
  String get uiDragToAdjustStartTick => 'Drag to Adjust Start Tick';

  @override
  String get uiDragToAdjustEndTick => 'Drag to Adjust End Tick';

  @override
  String get uiAdjustStartTick => 'Adjust Start Tick';

  @override
  String get uiAdjustEndTick => 'Adjust End Tick';

  @override
  String get uiDragToAdjustTime => 'Drag to Adjust Time';

  @override
  String uiStateChangesCharactersItemsLocations(
    String p1,
    String p2,
    String p3,
  ) {
    return 'State changes: $p1 characters, $p2 items, $p3 locations';
  }

  @override
  String get uiNodeProperties => 'Node Properties';

  @override
  String get uiNoNodeSelected => 'No node selected';

  @override
  String get uiSelectATimelineNodeToViewAndAdjust =>
      'Select a timeline node to view and adjust ticks, track, and chapter links.';

  @override
  String get uiDeleteNode => 'Delete Node';

  @override
  String get uiCustomName => 'Custom Name';

  @override
  String get uiAssignedTrack => 'Assigned Track';

  @override
  String get uiStartTick => 'Start Tick';

  @override
  String get uiTickCount => 'Tick Count';

  @override
  String get uiEndTick => 'End Tick';

  @override
  String get uiOpenInOutline => 'Open in Outline';

  @override
  String uiChaptersBelowAreCollectedFromChildScenes(String p1) {
    return 'Chapters below are collected from $p1 child scenes.';
  }

  @override
  String get uiSceneStateChanges => 'Scene State Changes';

  @override
  String uiCharactersItemsLocations(String p1, String p2, String p3) {
    return 'Characters $p1 · Items $p2 · Locations $p3';
  }

  @override
  String get uiNoCharacterItemOrLocationSnapshotChangesIn =>
      'No character, item, or location snapshot changes in this scene.';

  @override
  String get uiLinkedChapters => 'Linked Chapters';

  @override
  String get uiChooseChapters => 'Choose Chapters';

  @override
  String get uiChildScenesHaveNoLinkedChaptersYet =>
      'Child scenes have no linked chapters yet';

  @override
  String get uiThisSceneHasNoLinkedChaptersYet =>
      'This scene has no linked chapters yet';

  @override
  String get uiChooseChaptersAndApplyThemToAllChild =>
      'Choose chapters and apply them to all child nodes at once.';

  @override
  String get uiTheFirstChapterWillNotOpenAutomatically =>
      'The first chapter will not open automatically.';

  @override
  String get uiMissingChapter => 'Missing Chapter';

  @override
  String get uiThisContainerHasNoChildScenesThatCan =>
      'This container has no child scenes that can link to chapters. Add a scene first.';

  @override
  String get uiThisSceneHasNoOutlineSceneLinkedSo =>
      'This scene has no outline scene linked, so chapter links cannot be created.';

  @override
  String uiOpen2(String p1) {
    return 'Open $p1';
  }

  @override
  String get uiDecrease => 'Decrease';

  @override
  String get uiIncrease => 'Increase';

  @override
  String get uiAddTheSceneToTheTimelineBeforeAdding3 =>
      'Add the scene to the timeline before adding a location snapshot.';

  @override
  String uiExistence(String p1, String p2) {
    return 'Existence $p1 → $p2';
  }

  @override
  String uiAccess(String p1, String p2) {
    return 'Access $p1 → $p2';
  }

  @override
  String uiState(String p1, String p2) {
    return 'State “$p1” → “$p2”';
  }

  @override
  String uiController(String p1, String p2) {
    return 'Controller $p1 → $p2';
  }

  @override
  String get uiNoChanges => 'No Changes';

  @override
  String get uiApplyToAllChildLocations => 'Apply to All Child Locations';

  @override
  String uiCreatesIndependentSnapshots(String p1) {
    return 'Creates $p1 independent snapshots';
  }

  @override
  String uiOnlyWillBeModified(String p1) {
    return 'Only “$p1” will be modified';
  }

  @override
  String get uiNameAtThisPoint => 'Name at This Point';

  @override
  String get uiDescriptionAtThisPoint => 'Description at This Point';

  @override
  String get uiCustomPropertiesAtThisPoint => 'Custom Properties at This Point';

  @override
  String get uiValue => 'Value';

  @override
  String get uiRemoveProperty => 'Remove Property';

  @override
  String get uiAddProperty => 'Add Property';

  @override
  String get uiBatchApplicationPreservesEachChildLocationSExisting =>
      'Batch application preserves each child location\'s existing name, description, and custom properties.';

  @override
  String get uiAccessibleAtThisPoint => 'Accessible at This Point';

  @override
  String get uiController2 => 'Controller';

  @override
  String get uiBatchChangesPreview => 'Batch Changes Preview';

  @override
  String get uiPropertiesWithAValueMustHaveAName =>
      'Properties with a value must have a name.';

  @override
  String get uiCustomPropertyNamesMustBeUnique =>
      'Custom property names must be unique.';

  @override
  String get uiLocationSnapshotAdded => 'Location snapshot added';

  @override
  String uiAddedLocationSnapshots(String p1) {
    return 'Added $p1 location snapshots';
  }

  @override
  String get uiDeleteAllSnapshotsInThisBatch =>
      'Delete All Snapshots in This Batch?';

  @override
  String uiThisSnapshotBelongsToTheSameBatchAs(String p1) {
    return 'This snapshot belongs to the same batch as other child locations. All $p1 snapshots will be deleted.';
  }

  @override
  String get uiDeleteBatch => 'Delete Batch';

  @override
  String uiDeletedLocationSnapshots(String p1) {
    return 'Deleted $p1 location snapshots';
  }

  @override
  String get uiLocationSnapshotDeleted => 'Location snapshot deleted';

  @override
  String get uiItemsCurrentlyAtThisLocation =>
      'Items Currently at This Location';

  @override
  String get uiNoItemsHere => 'No items here';

  @override
  String get uiUseAllocateItemsToSetLocationsOrAggregate =>
      'Use “Allocate Items” to set locations or aggregate quantities here';

  @override
  String get uiChooseALocationItemToLink => 'Choose a location item to link';

  @override
  String get uiChooseAnItemToPlaceHere => 'Choose an item to place here';

  @override
  String get uiMoveLegacyWorldbuildingItems =>
      'Move Legacy Worldbuilding Items';

  @override
  String uiMoveItemNodesToTheNewItemManager(String p1) {
    return 'Move $p1 item nodes to the new item manager. IDs, content, and source paths will be preserved.';
  }

  @override
  String uiMovedItemsToTheNewItemManager(String p1) {
    return 'Moved $p1 items to the new item manager.';
  }

  @override
  String get uiWorldbuilding2 => 'Worldbuilding';

  @override
  String get uiManageTemplates => 'Manage Templates';

  @override
  String get uiImportTemplateFile => 'Import Template File…';

  @override
  String get uiExportSelectedTemplate => 'Export Selected Template…';

  @override
  String get uiExportAllTemplates => 'Export All Templates…';

  @override
  String get uiSaveTemplatePreset => 'Save Template Preset…';

  @override
  String get uiRenamePreset => 'Rename Preset…';

  @override
  String get uiDeleteSelectedPreset => 'Delete Selected Preset';

  @override
  String get uiWorldStructure => 'World Structure';

  @override
  String get uiNoLocationsYet => 'No locations yet';

  @override
  String get uiAddYourFirstLocation => 'Add your first location';

  @override
  String get uiChildLocation => 'Child Location';

  @override
  String get uiTopLevelLocation => 'Top-level Location';

  @override
  String get uiNodeDetails => 'Node Details';

  @override
  String get uiDoesNotExistAtThisTick => 'Does not exist at this tick';

  @override
  String get uiTreeShellRetainedExistingChildLocationsRemain =>
      'Tree shell retained: existing child locations remain';

  @override
  String get uiParentDoesNotExistAtThisTickThis =>
      'Parent does not exist at this tick; this node exists independently';

  @override
  String uiNameAtThisPoint2(String p1) {
    return 'Name at this point: $p1';
  }

  @override
  String get uiDeleteLocation => 'Delete Location';

  @override
  String get uiBefore => 'before';

  @override
  String get uiAsAChildLocation => 'as a child location';

  @override
  String get uiAfter => 'after';

  @override
  String uiIsNowPlaced(String p1, String p2, String p3) {
    return '“$p1” is now placed $p3 “$p2”';
  }

  @override
  String uiMoved(String p1, String p2, String p3) {
    return '“$p1” moved $p3 “$p2”';
  }

  @override
  String get uiSelectALocationFirst => 'Select a location first';

  @override
  String get uiSelectALocationToPreviewItsTimelineAnd =>
      'Select a location to preview its timeline and manage snapshots';

  @override
  String uiDescription2(String p1) {
    return 'Description: $p1';
  }

  @override
  String uiProperties(String p1) {
    return 'Properties: $p1';
  }

  @override
  String get uiAccessible => 'Accessible';

  @override
  String get uiInaccessible => 'Inaccessible';

  @override
  String uiController3(String p1) {
    return 'Controller: $p1';
  }

  @override
  String get uiRemoveLocationSnapshot => 'Remove Location Snapshot';

  @override
  String get uiChooseALocation => 'Choose a Location';

  @override
  String get uiSelectALocationToEditItsDetails =>
      'Select a location to edit its details';

  @override
  String get uiLocationNotFound => 'Location not found';

  @override
  String get uiApplyTemplate => 'Apply Template: ';

  @override
  String get uiChooseTemplate => 'Choose Template';

  @override
  String get uiBlank => 'Blank';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get uiThisIsALegacyItemNodeItemsAre =>
      'This is a legacy item node. Items are no longer stored in the worldbuilding tree. Move them to manage allocations directly from the location page.';

  @override
  String get uiMoveAllItems => 'Move All Items';

  @override
  String get uiNodeType => 'Node Type';

  @override
  String get uiCustomProperties => 'Custom Properties:';

  @override
  String get uiNoCustomProperties => 'No custom properties';

  @override
  String get uiEnterAPropertyNameAndValueBelowTo =>
      'Enter a property name and value below to add it';

  @override
  String get uiNotes4 => 'Notes:';

  @override
  String get uiSaveTemplatePreset2 => 'Save Template Preset';

  @override
  String get uiATemplateWithThisNameExistsOverwriteIt =>
      'A template with this name exists. Overwrite it?';

  @override
  String get uiRenamePreset2 => 'Rename Preset';

  @override
  String get uiNewTemplateName => 'New Template Name';

  @override
  String get uiImportFailedNoTypeNodesFoundInThe =>
      'Import failed: no <Type> nodes found in the file.';

  @override
  String uiCouldNotReadFile(String p1) {
    return 'Could not read file: $p1';
  }

  @override
  String get uiExportFile => 'Export File';

  @override
  String uiFileExportedTo(String p1) {
    return 'File exported to: $p1';
  }

  @override
  String uiPermanentlyDelete(String p1) {
    return 'Permanently delete “$p1”?';
  }

  @override
  String get uiToMakeALocationDisappearOnlyWithinThe =>
      'To make a location disappear only within the story, add a scene snapshot and turn off “Exists at This Point”.';

  @override
  String uiPermanentlyDeleteLocationNodes(String p1) {
    return 'Permanently delete $p1 location nodes';
  }

  @override
  String uiRemoveLocationSnapshots(String p1) {
    return 'Remove $p1 location snapshots';
  }

  @override
  String uiRemoveItemLinks(String p1) {
    return 'Remove $p1 item links';
  }

  @override
  String uiClearItemLocationRecords(String p1) {
    return 'Clear $p1 item location records';
  }

  @override
  String get uiDeletePermanently => 'Delete Permanently';

  @override
  String get uiError => 'Error';

  @override
  String get uiSuccess => 'Success';

  @override
  String get uiSwitchModule => 'Switch Module';

  @override
  String get uiSearchModules => 'Search Modules';

  @override
  String get uiNoMatchingModules => 'No matching modules';

  @override
  String get uiCurrentModule => 'Current Module';

  @override
  String get uiSyncConflictsChooseAVersionForEachField =>
      'Sync Conflicts: Choose a Version for Each Field';

  @override
  String uiAllConflictingFieldsResolved(String p1) {
    return 'All $p1 conflicting fields resolved';
  }

  @override
  String uiUnresolvedFields(String p1) {
    return 'Unresolved fields: $p1';
  }

  @override
  String get uiDefaultAllFieldsToLocal => 'Default All Fields to Local';

  @override
  String get uiDefaultAllFieldsToRemote => 'Default All Fields to Remote';

  @override
  String get uiCancelAndKeepBothVersions => 'Cancel and Keep Both Versions';

  @override
  String uiApplyFieldChoicesAndFinishSync(String p1) {
    return 'Apply $p1 Field Choices and Finish Sync';
  }

  @override
  String uiConflictingFields(String p1, String p2) {
    return '$p1 conflicting fields · $p2';
  }

  @override
  String get uiDefaultVersion => 'Default version:';

  @override
  String get uiLocalVersion => 'Local Version';

  @override
  String get uiRemoteVersion => 'Remote Version';

  @override
  String get uiInheritLocalVersion => 'Inherit (Local Version)';

  @override
  String get uiInheritRemoteVersion => 'Inherit (Remote Version)';

  @override
  String get uiInheritNotSet => 'Inherit (Not Set)';

  @override
  String uiConflictingField(String p1) {
    return 'Conflicting field: $p1';
  }

  @override
  String get uiUnresolved => 'Unresolved';

  @override
  String get uiResolved => 'Resolved';

  @override
  String get uiCommonAncestor => 'Common Ancestor';

  @override
  String get uiMissingDeleted => '(Missing / Deleted)';

  @override
  String get uiWork => 'Work';

  @override
  String get uiProjectSections => 'Project Sections';

  @override
  String get uiPreparingContentAndPackage => 'Preparing content and package…';

  @override
  String uiCouldNotPrepareExport(String p1) {
    return 'Could not prepare export: $p1';
  }

  @override
  String get uiChooseALocationAndSave => 'Choose a location and save…';

  @override
  String get uiSaveCancelledYouCanChooseAnotherLocation =>
      'Save cancelled. You can choose another location.';

  @override
  String uiSourceSnapshotTakenWhenExportOpened(String p1) {
    return 'Source: $p1 (snapshot taken when export opened)';
  }

  @override
  String get uiCurrentWork => 'Current Work';

  @override
  String get uiPurpose => 'Purpose';

  @override
  String get uiManuscriptDelivery => 'Manuscript Delivery';

  @override
  String get uiReferenceMaterial => 'Reference Material';

  @override
  String get uiPartialProjectExchange => 'Partial Project Exchange';

  @override
  String get uiContentFormat => 'Content Format';

  @override
  String get uiFileOrganization => 'File Organization';

  @override
  String get uiCombineIntoOneDocument => 'Combine into One Document';

  @override
  String get uiSeparateDocumentsZIP => 'Separate Documents (ZIP)';

  @override
  String get uiIncludeWorkInformation => 'Include Work Information';

  @override
  String get uiIncludeFolderManuscriptTitles =>
      'Include Folder / Manuscript Titles';

  @override
  String get uiCurrentManuscriptOnly => 'Current Manuscript Only';

  @override
  String uiPreviewDocumentsBytes(String p1, String p2, String p3) {
    return 'Preview: $p1 documents · $p2 bytes · .$p3';
  }

  @override
  String get uiGeneratePreview => 'Generate Preview';

  @override
  String get uiBackToOptions => 'Back to Options';

  @override
  String get uiThisModuleIsExportedInFull => 'This module is exported in full.';

  @override
  String get uiZIPFileTree => 'ZIP File Tree';

  @override
  String get uiExportNotes => 'Export Notes';

  @override
  String get uiFileAndHierarchyIndex => 'File and Hierarchy Index';

  @override
  String get uiSearchNamesKeepSelection => 'Search names (keep selection)';

  @override
  String get uiSelectEntireList => 'Select Entire List';

  @override
  String get uiClearListSelection => 'Clear List Selection';

  @override
  String get uiExpandAll => 'Expand All';

  @override
  String get uiCollapseAll => 'Collapse All';

  @override
  String uiSelectedOf(String p1, String p2) {
    return 'Selected $p1 of $p2';
  }

  @override
  String get uiNoMatchingEntries => 'No matching entries';

  @override
  String uiCollapse3(String p1) {
    return 'Collapse $p1';
  }

  @override
  String uiExpand2(String p1) {
    return 'Expand $p1';
  }

  @override
  String uiSelectedOf2(String p1, String p2, String p3, String p4) {
    return '$p1, $p2, selected $p3 of $p4';
  }

  @override
  String uiOnlyThisItem(String p1) {
    return 'Only This Item: $p1';
  }

  @override
  String get uiSearchNameTypeOrAffiliation =>
      'Search name, type, or affiliation';

  @override
  String get uiShowArchivedItems => 'Show Archived Items';

  @override
  String get uiNoMatchingObjects => 'No matching objects.';

  @override
  String get uiUntitledLocation => 'Untitled Location';

  @override
  String get uiUnnamedCharacter => 'Unnamed Character';

  @override
  String uiCharacter2(String p1) {
    return 'Character$p1';
  }

  @override
  String uiLiteral3(String p1) {
    return ' · $p1';
  }

  @override
  String get uiUntitledEvent2 => 'Untitled Event';

  @override
  String uiEvent4(String p1) {
    return 'Event · $p1';
  }

  @override
  String uiScene2(String p1) {
    return 'Scene · $p1';
  }

  @override
  String get uiUntitledItemClass => 'Untitled Item Class';

  @override
  String uiAllocations(String p1) {
    return 'Allocations: $p1';
  }

  @override
  String uiItemClass2(String p1, String p2, String p3) {
    return 'Item Class · $p1 · $p2$p3';
  }

  @override
  String get uiArchived => ' · Archived';

  @override
  String uiIndividualItem(String p1, String p2, String p3) {
    return 'Individual Item · $p1 · $p2$p3';
  }

  @override
  String get uiUnassigned2 => 'Unassigned';

  @override
  String get uiAddAGaugeToViewYourWritingProgress =>
      'Add a gauge to view your writing progress.';

  @override
  String get uiAddGauge => 'Add Gauge';

  @override
  String get uiAllGaugesAreAlreadyShown => 'All gauges are already shown';

  @override
  String get uiWords => ' words';

  @override
  String get uiEntries4 => ' entries';

  @override
  String get uiStatisticsTemporarilyUnavailable =>
      'Statistics Temporarily Unavailable';

  @override
  String get uiChooseAChapter => 'Choose a Chapter';

  @override
  String get uiNoProgressYet => 'No Progress Yet';

  @override
  String get uiWords2 => 'words';

  @override
  String get uiEntries5 => 'entries';

  @override
  String uiInformation(String p1) {
    return '$p1 Information';
  }

  @override
  String uiCurrent(String p1, String p2) {
    return 'Current: $p1 $p2';
  }

  @override
  String get uiGoal2 => 'Goal';

  @override
  String get uiTotal => 'Total';

  @override
  String uiAllLocalWorks(String p1) {
    return '$p1 · All Local Works';
  }

  @override
  String get uiFullWidthCharactersHalfWidthWordsAdditionsMinus =>
      'Full-width characters + half-width words; additions minus deletions';

  @override
  String uiNetDecreaseTodayWords(String p1) {
    return 'Net decrease today: $p1 words';
  }

  @override
  String get uiProcessingStatistics => 'Processing statistics…';

  @override
  String get uiCouldNotSaveStatisticsClickToRetry =>
      'Could not save statistics. Click to retry.';

  @override
  String get uiThisFileOnly => 'This File Only';

  @override
  String get uiSetWordCountGoal => 'Set Word Count Goal';

  @override
  String get uiRemoveGauge => 'Remove Gauge';

  @override
  String get uiTrackingNotStarted => 'Tracking Not Started';

  @override
  String get uiCalculating => 'Calculating';

  @override
  String get uiCalculationFailed => 'Calculation Failed';

  @override
  String get uiNoRevisionsYet => 'No Revisions Yet';

  @override
  String get uiComparisonComplete => 'Comparison Complete';

  @override
  String uiOuterRingAdditionsInnerRingRevisions(
    String p1,
    String p2,
    String p3,
    String p4,
    String p5,
  ) {
    return 'Outer ring additions: $p1 ($p2%)\nInner ring revisions: $p3 ($p4%)\n$p5';
  }

  @override
  String get uiRevisionTrackingInformation => 'Revision Tracking Information';

  @override
  String uiOuterRingAdditions(String p1) {
    return 'Outer ring additions: $p1';
  }

  @override
  String uiInnerRingRevisions(String p1) {
    return 'Inner ring revisions: $p1';
  }

  @override
  String uiComparisonBaseline(String p1) {
    return 'Comparison baseline: $p1';
  }

  @override
  String get uiManuscriptChangesAreCountedByChangedLinesSettings =>
      'Manuscript changes are counted by changed lines, settings by records. Modifications count once each as an addition and a revision.';

  @override
  String get uiEachRingShowsItsCountAsAShare =>
      'Each ring shows its count as a share of the total.';

  @override
  String get uiViewRevisionDetails => 'View Revision Details';

  @override
  String get uiTrackRevisions => 'Track Revisions';

  @override
  String uiIsEditingThisChapter(String p1) {
    return '$p1 is editing this chapter';
  }

  @override
  String get uiStoryRange => 'Story Range';

  @override
  String get uiByStorylineTypeAndOrderWeightEventsScenes =>
      'By storyline type and order · weight = 1 + events + scenes';

  @override
  String get uiAddStorylinesToDisplayTheStoryRangeHere =>
      'Add storylines to display the story range here.';

  @override
  String uiStorylinesWeight(String p1, String p2, String p3, String p4) {
    return '$p1, storylines $p2–$p3, weight $p4';
  }

  @override
  String uiSnapshotBoundToStartTick(String p1, String p2) {
    return 'Snapshot bound to: $p1 · Start tick $p2';
  }

  @override
  String get uiNoSceneSelected => 'No Scene Selected';

  @override
  String get uiDragOntoASingleSceneToSelectIt =>
      'Drag onto a single scene to select it. Use the scene menu for empty or overlapping areas.';

  @override
  String get uiLiteral4 => '繁體中文';

  @override
  String get uiLiteral5 => '日本語';

  @override
  String get uiBeyondUsingThisThemeWhatElseCanYou =>
      'Beyond using this theme, what else can you do?';

  @override
  String get uiRespectPeopleSNamesAndPronounsJoinEvents =>
      'Respect people\'s names and pronouns, join events such as Pride, listen to LGBTQ+ stories, and support equality and challenge discrimination in everyday life.';

  @override
  String get uiTimelineAndSnapshots => 'Timeline and Snapshots';

  @override
  String uiEventsAtTick(String p1) {
    return 'Events at Tick $p1';
  }

  @override
  String get uiEditingDefaultDataEnableFollowTimelineToPreview =>
      'Editing default data. Enable “Follow Timeline” to preview a specific tick.';

  @override
  String get uiNoSnapshotAtThisTickPreviewOnlyAdd =>
      'No snapshot at this tick; preview only. Add a snapshot to edit, or disable “Follow Timeline” to edit default data.';

  @override
  String get uiOnlyAnInheritedClassStateExistsAtThis =>
      'Only an inherited class state exists at this tick; preview only. Add an individual snapshot to edit.';

  @override
  String get uiEditingThisTickSSnapshotChangesAreSaved =>
      'Editing this tick\'s snapshot. Changes are saved only to this event.';

  @override
  String get uiIndependentPreview => 'Independent Preview';

  @override
  String get uiHistoricalPreview => 'Historical Preview';

  @override
  String get uiFollowTimeline => 'Follow Timeline';

  @override
  String get uiPreviousEvent => 'Previous Event';

  @override
  String get uiNextEvent => 'Next Event';

  @override
  String get uiLocateOnMainTimeline => 'Locate on Main Timeline';

  @override
  String get uiSceneDisplayRange => 'Scene Display Range';

  @override
  String get uiRelatedScenes => 'Related Scenes';

  @override
  String get uiAllScenes => 'All Scenes';

  @override
  String get uiNoSnapshotEventsPreviewAnyTick =>
      'No snapshot events; preview any tick';

  @override
  String get uiSceneNotScheduledUsingFallbackTime =>
      'Scene not scheduled; using fallback time';

  @override
  String uiCouldNotLoadWritingGoals(String p1) {
    return 'Could not load writing goals: $p1';
  }

  @override
  String get uiDailyNetWordGainAcrossAllLocalWorks =>
      'Daily net word gain across all local works';

  @override
  String get uiSavedWithTheCurrentWorkAndAppliedTo =>
      'Saved with the current work and applied to this file.';

  @override
  String get uiApplyToWorksWithoutAFileSpecificGoal =>
      'Apply to works without a file-specific goal.';

  @override
  String uiThisFileStillUsesItsOwnGoalOf(String p1) {
    return 'This file still uses its own goal of $p1 words.';
  }

  @override
  String get uiWordCountGoal => 'Word Count Goal';

  @override
  String get uiRestoreDefault => 'Restore Default';

  @override
  String get uiSaving => 'Saving…';

  @override
  String get uiCouldNotReadWritingGoalsClickToRetry =>
      'Could not read writing goals. Click to retry.';

  @override
  String get uiAllLocalWorksCombined => 'All Local Works Combined';

  @override
  String get uiDefaultFileSpecificValuesCanBeSetFrom =>
      'Default; file-specific values can be set from each gauge';

  @override
  String get uiEnterAnAlias => 'Enter an alias';

  @override
  String get uiAliasAlreadyExists => 'Alias already exists';

  @override
  String get uiThisAliasWasRemovedCancelAndTryAgain =>
      'This alias was removed. Cancel and try again.';

  @override
  String get uiAlias => 'Alias';

  @override
  String get uiEnterAlias => 'Enter alias';

  @override
  String get uiTimeMarker => 'Time Marker';

  @override
  String get uiUntitledNode => 'Untitled Node';

  @override
  String get uiEnabled => 'Enabled';

  @override
  String get uiStandby => 'Standby';

  @override
  String get uiAttentionRequired => 'Attention Required';

  @override
  String get uiAwaitingConfirmation => 'Awaiting Confirmation';

  @override
  String get uiActive => 'Active';

  @override
  String get uiLinked => 'Linked';

  @override
  String get uiInformation2 => 'Information';

  @override
  String get uiProcessing => 'Processing';

  @override
  String get uiSaveProjectFile => 'Save Project File';

  @override
  String get uiExportTextFile => 'Export Text File';

  @override
  String get uiSomeWordCountGoalsCouldNotBeParsed =>
      'Some word count goals could not be parsed. Original data has been preserved; readable goals or defaults are in use.';

  @override
  String get uiXmlVersionEncodingUTF =>
      '<?xml version=\"1.0\" encoding=\"UTF-8\"?>';

  @override
  String get uiChooseAutoBackupFolder => 'Choose AutoBackup Folder';

  @override
  String get uiStartWriting => 'Start writing…';

  @override
  String get uiResolved2 => 'Resolved';

  @override
  String get uiUnresolved2 => 'Unresolved';

  @override
  String get uiInProgress => 'In Progress';

  @override
  String get uiDedicated => 'Dedicated';

  @override
  String get uiSemiDedicated => 'Semi-dedicated';

  @override
  String get uiNonDedicated => 'Non-dedicated';

  @override
  String get uiArchived2 => 'Archived';

  @override
  String get uiHome2 => 'Home';

  @override
  String get uiStorySettings => 'Story Settings';

  @override
  String get uiCharacters4 => 'Characters';

  @override
  String get uiManuscriptEditor => 'Manuscript Editor';

  @override
  String get uiAbout => 'About';

  @override
  String get uiGray => 'Gray';

  @override
  String get uiRed => 'Red';

  @override
  String get uiOrange => 'Orange';

  @override
  String get uiYellow => 'Yellow';

  @override
  String get uiGreen => 'Green';

  @override
  String get uiCyan => 'Cyan';

  @override
  String get uiBlue => 'Blue';

  @override
  String get uiPurple => 'Purple';

  @override
  String get uiPink => 'Pink';

  @override
  String get uiIconsAndText => 'Icons and Text';

  @override
  String get uiExpandWithButton => 'Expand with Button';

  @override
  String get uiFollowSystem => 'Follow System';

  @override
  String get uiMonoAshi => 'MonoAshi';

  @override
  String get uiMosaicMarkerIsIncompleteOrInvalid =>
      'Mosaic marker is incomplete or invalid';

  @override
  String get uiExportPhraseLibrary => 'Export Phrase Library';

  @override
  String get uiPink2 => 'Pink';

  @override
  String get uiCharacterSuggestions => 'Character Suggestions';

  @override
  String get uiSearchAndInsertProjectPhrases =>
      'Search and Insert Project Phrases';

  @override
  String get uiLocationSuggestions => 'Location Suggestions';

  @override
  String get uiEventSuggestions => 'Event Suggestions';

  @override
  String get uiForeshadowingSuggestions => 'Foreshadowing Suggestions';

  @override
  String get uiPlanSuggestions => 'Plan Suggestions';

  @override
  String get uiItemSuggestions => 'Item Suggestions';

  @override
  String get uiHighlightColorSuggestions => 'Highlight Color Suggestions';

  @override
  String get uiCharacterMarkerTemplate => 'Character Marker Template';

  @override
  String get uiLocationMarkerTemplate => 'Location Marker Template';

  @override
  String get uiEventMarkerTemplate => 'Event Marker Template';

  @override
  String get uiForeshadowingMarkerTemplate => 'Foreshadowing Marker Template';

  @override
  String get uiPlanMarkerTemplate => 'Plan Marker Template';

  @override
  String get uiItemMarkerTemplate => 'Item Marker Template';

  @override
  String get uiHighlightMarkerTemplate => 'Highlight Marker Template';

  @override
  String get uiInsertLiteral => 'Insert Literal /';

  @override
  String get uiWriteAsToPreventParsingAsASyntax =>
      'Write as \\/ to prevent parsing as a syntax boundary';

  @override
  String get uiInsertLiteral2 => 'Insert Literal \\';

  @override
  String get uiWriteAs => 'Write as \\\\';

  @override
  String get uiCharacterPrimaryName => 'Character · Primary Name';

  @override
  String get uiAddAlias2 => 'Add Alias…';

  @override
  String get uiEnterOtherDisplayText => 'Enter Other Display Text…';

  @override
  String get uiUseOnlyForThisMentionDoNotAdd =>
      'Use only for this mention; do not add an alias';

  @override
  String get uiAddChildLocation => 'Add Child Location…';

  @override
  String get uiAddEvent2 => 'Add Event…';

  @override
  String get uiAddScene2 => 'Add Scene…';

  @override
  String get uiStoryline3 => 'Storyline';

  @override
  String get uiEvent5 => 'Event';

  @override
  String get uiScene3 => 'Scene';

  @override
  String get uiInsertMarkerImmediatelyAfterCreation =>
      'Insert Marker Immediately After Creation';

  @override
  String get uiHighlightBackgroundAutomaticTextColor =>
      'Highlight Background · Automatic Text Color';

  @override
  String get uiOnlyForThisAnnotation => 'Only for This Annotation';

  @override
  String get uiAnnotation3 => 'Annotation';

  @override
  String get uiMarkerBackgroundColorCodeAutomaticTextColor =>
      'Marker Background Color Code · Automatic Text Color';

  @override
  String get uiWorkInformation => 'Work Information';

  @override
  String get uiChapters2 => 'Chapters';

  @override
  String get uiCreativePurpose => 'Creative Purpose';

  @override
  String get uiSynopsis2 => 'Synopsis';

  @override
  String get uiGenre => 'Genre';

  @override
  String get uiAge3 => 'Age';

  @override
  String get uiRoleOccupation2 => 'Role / Occupation';

  @override
  String get uiPersonality2 => 'Personality';

  @override
  String get uiSpeechStyle2 => 'Speech Style';

  @override
  String get uiMotivation2 => 'Motivation';

  @override
  String get uiCustomField => 'Custom Field';

  @override
  String get uiFieldValue => 'Field Value';

  @override
  String get uiLocationType => 'Location Type';

  @override
  String get uiNodeType2 => 'Node Type';

  @override
  String get uiConflict => 'Conflict';

  @override
  String get uiDefaultState => 'Default State';

  @override
  String get uiStateChanges => 'State Changes';

  @override
  String get uiAffiliation => 'Affiliation';

  @override
  String get uiOrder => 'Order';

  @override
  String get uiChinaSGreatestAndMostEnduringArtIs =>
      'China\'s greatest and most enduring art is men playing women';

  @override
  String get uiLuXun => '— Lu Xun (1881–1936)';

  @override
  String get uiYyyyMMDdHHMmSs => 'yyyy.MM.dd HH:mm:ss';

  @override
  String get uiAddCharacterRelationship => 'Add Character Relationship';

  @override
  String get uiProtagonist => 'Protagonist';

  @override
  String get uiMajorSupportingCharacter => 'Major Supporting Character';

  @override
  String get uiMainAntagonist => 'Main Antagonist';

  @override
  String get uiSecondaryAntagonist => 'Secondary Antagonist';

  @override
  String get uiUntitled2 => 'Untitled';

  @override
  String get uiCooking => 'Cooking';

  @override
  String get uiUnskilled => 'Unskilled';

  @override
  String get uiSkilled => 'Skilled';

  @override
  String get uiCleaning => 'Cleaning';

  @override
  String get uiMoneyManagement => 'Money Management';

  @override
  String get uiFitness => 'Fitness';

  @override
  String get uiArt => 'Art';

  @override
  String get uiMusic => 'Music';

  @override
  String get uiDance => 'Dance';

  @override
  String get uiCrafts => 'Crafts';

  @override
  String get uiSocialSkills => 'Social Skills';

  @override
  String get uiLeadership => 'Leadership';

  @override
  String get uiAnalysis => 'Analysis';

  @override
  String get uiCreativity => 'Creativity';

  @override
  String get uiMemory => 'Memory';

  @override
  String get uiObservation => 'Observation';

  @override
  String get uiAdaptability => 'Adaptability';

  @override
  String get uiLearning => 'Learning';

  @override
  String get uiIntroverted => 'Introverted';

  @override
  String get uiExtroverted => 'Extroverted';

  @override
  String get uiEmotional => 'Emotional';

  @override
  String get uiRational => 'Rational';

  @override
  String get uiPassive => 'Passive';

  @override
  String get uiProactive => 'Proactive';

  @override
  String get uiConservative => 'Conservative';

  @override
  String get uiOpenMinded => 'Open-minded';

  @override
  String get uiCautious => 'Cautious';

  @override
  String get uiAdventurous => 'Adventurous';

  @override
  String get uiDependent => 'Dependent';

  @override
  String get uiIndependent => 'Independent';

  @override
  String get uiGentle => 'Gentle';

  @override
  String get uiStubborn => 'Stubborn';

  @override
  String get uiPessimistic => 'Pessimistic';

  @override
  String get uiOptimistic => 'Optimistic';

  @override
  String get uiSerious => 'Serious';

  @override
  String get uiHumorous => 'Humorous';

  @override
  String get uiShy => 'Shy';

  @override
  String get uiOutgoing => 'Outgoing';

  @override
  String get uiLowKey => 'Low-key';

  @override
  String get uiShowy => 'Showy';

  @override
  String get uiNegative => 'Negative';

  @override
  String get uiPositive => 'Positive';

  @override
  String get uiCunning => 'Cunning';

  @override
  String get uiHonest => 'Honest';

  @override
  String get uiChildish => 'Childish';

  @override
  String get uiMature => 'Mature';

  @override
  String get uiCalm => 'Calm';

  @override
  String get uiImpulsive => 'Impulsive';

  @override
  String get uiQuiet => 'Quiet';

  @override
  String get uiTalkative => 'Talkative';

  @override
  String get uiObstinate => 'Obstinate';

  @override
  String get uiCompliant => 'Compliant';

  @override
  String get uiUnrestrained => 'Unrestrained';

  @override
  String get uiSelfDisciplined => 'Self-disciplined';

  @override
  String get uiFrivolous => 'Frivolous';

  @override
  String get uiAwkward => 'Awkward';

  @override
  String get uiFrank => 'Frank';

  @override
  String get uiIndifferent => 'Indifferent';

  @override
  String get uiCurious => 'Curious';

  @override
  String get uiSlowToNotice => 'Slow to Notice';

  @override
  String get uiPerceptive => 'Perceptive';

  @override
  String get uiExpressionless => 'Expressionless';

  @override
  String get uiExpressive => 'Expressive';

  @override
  String get uiFoolish => 'Foolish';

  @override
  String get uiGenius => 'Genius';

  @override
  String get uiSimple => 'Simple';

  @override
  String get uiComplex => 'Complex';

  @override
  String get uiEasilyEmbarrassed => 'Easily Embarrassed';

  @override
  String get uiShameless => 'Shameless';

  @override
  String get uiMild => 'Mild';

  @override
  String get uiHotTempered => 'Hot-tempered';

  @override
  String get uiRough => 'Rough';

  @override
  String get uiRefined => 'Refined';

  @override
  String get uiWeakWilled => 'Weak-willed';

  @override
  String get uiDetermined => 'Determined';

  @override
  String get uiWithoutDesire => 'Without Desire';

  @override
  String get uiIntense => 'Intense';

  @override
  String get uiTimid => 'Timid';

  @override
  String get uiBrave => 'Brave';

  @override
  String get uiInarticulate => 'Inarticulate';

  @override
  String get uiWitty => 'Witty';

  @override
  String get uiTrusting => 'Trusting';

  @override
  String get uiSuspicious => 'Suspicious';

  @override
  String get uiInsecure => 'Insecure';

  @override
  String get uiConfident => 'Confident';

  @override
  String get uiWithdrawn => 'Withdrawn';

  @override
  String get uiDecisive => 'Decisive';

  @override
  String get uiSociallyReserved => 'Socially Reserved';

  @override
  String get uiSociallyOutgoing => 'Socially Outgoing';

  @override
  String get uiConfessDirectly => 'Confess Directly';

  @override
  String get uiGiveGifts => 'Give Gifts';

  @override
  String get uiTalkToThemOften => 'Talk to Them Often';

  @override
  String get uiDoLittleThingsToGetAttention =>
      'Do Little Things to Get Attention';

  @override
  String get uiQuietlyPayAttention => 'Quietly Pay Attention';

  @override
  String get uiSmile => 'Smile';

  @override
  String get uiGreetThemFirst => 'Greet Them First';

  @override
  String get uiOfferHelp => 'Offer Help';

  @override
  String get uiGiveSmallGifts => 'Give Small Gifts';

  @override
  String get uiInviteThem => 'Invite Them';

  @override
  String get uiSharePersonalStories => 'Share Personal Stories';

  @override
  String get uiIgnoreThem => 'Ignore Them';

  @override
  String get uiKeepADistance => 'Keep a Distance';

  @override
  String get uiRespondPolitely => 'Respond Politely';

  @override
  String get uiUseSarcasm => 'Use Sarcasm';

  @override
  String get uiConfrontThem => 'Confront Them';

  @override
  String get uiAskOthersForHelp => 'Ask Others for Help';

  @override
  String get uiLawfulGood => 'Lawful\nGood';

  @override
  String get uiNeutralGood => 'Neutral\nGood';

  @override
  String get uiChaoticGood => 'Chaotic\nGood';

  @override
  String get uiLawfulNeutral => 'Lawful\nNeutral';

  @override
  String get uiTrueNeutral => 'True\nNeutral';

  @override
  String get uiChaoticNeutral => 'Chaotic\nNeutral';

  @override
  String get uiLawfulEvil => 'Lawful\nEvil';

  @override
  String get uiNeutralEvil => 'Neutral\nEvil';

  @override
  String get uiAbsoluteEvil => 'Absolute\nEvil';

  @override
  String get uiSingle => 'Single';

  @override
  String get uiMarriedEngaged => 'Married / Engaged';

  @override
  String get uiDatingStartingARelationship =>
      'Dating / Starting a Relationship';

  @override
  String get uiWidowed => 'Widowed';

  @override
  String get uiScene4 => 'Scene';

  @override
  String get uiComma => 'Comma';

  @override
  String get uiPeriod => 'Period';

  @override
  String get uiEnumerationComma => 'Enumeration Comma';

  @override
  String get uiEllipsis => 'Ellipsis';

  @override
  String get uiSameTypeQuotes => 'Same-type Quotes';

  @override
  String get uiResolveThisIssue => 'Resolve This Issue';

  @override
  String get uiProofreadingWorkerHasBeenDisposed =>
      'Proofreading worker has been disposed.';

  @override
  String get uiQuotesShouldStartWithNot =>
      'Quotes should start with \" \", not \' \'.';

  @override
  String get uiQuoteLevelsShouldAlternateBetweenAnd =>
      'Quote levels should alternate between \" \" and \' \'.';

  @override
  String get uiQuotesShouldStartWithNot2 =>
      'Quotes should start with 「」, not 『』.';

  @override
  String get uiQuoteLevelsShouldAlternateInACycle =>
      'Quote levels should alternate in a 「『』」 cycle.';

  @override
  String get uiSeconds => 'seconds';

  @override
  String get uiMinutes2 => 'minutes';

  @override
  String get uiHours => 'hours';

  @override
  String get uiDays => 'days';

  @override
  String get uiWeeks => 'weeks';

  @override
  String get uiMonths => 'months';

  @override
  String get uiSeasons => 'seasons';

  @override
  String get uiYears => 'years';

  @override
  String get uiDecades => 'decades';

  @override
  String get uiCenturies => 'centuries';

  @override
  String get uiCustomUnit => 'Custom Unit';

  @override
  String get uiChooseObject => 'Choose Object';

  @override
  String get uiDailyGoal => 'Daily Goal';

  @override
  String get uiBookWordCount => 'Book Word Count';

  @override
  String get uiForeshadowingResolution => 'Prefigure Resolution';

  @override
  String get uiOrange2 => 'Orange';

  @override
  String get uiNoTimelineNodesYet => 'No timeline nodes yet';

  @override
  String get uiMiniTimeline => 'Mini Timeline';

  @override
  String get uiDefaultChapterWordCountGoal => 'Default Chapter Word Count Goal';

  @override
  String get uiDefaultProjectWordCountGoal => 'Default Project Word Count Goal';

  @override
  String get uiNoDataYet => 'No data yet';

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
  String get uiBlank2 => '(Blank)';

  @override
  String get uiStandard => 'Standard';

  @override
  String get uiHighContrast => 'High Contrast';

  @override
  String get uiShowYourPrideRainbow => 'Show Your Pride / Rainbow';

  @override
  String get uiShowYourPrideLesbian => 'Show Your Pride / Lesbian';

  @override
  String get uiShowYourPrideBisexual => 'Show Your Pride / Bisexual';

  @override
  String get uiShowYourPrideTransgender => 'Show Your Pride / Transgender';

  @override
  String get navigationTooltipDescription =>
      'Show icons only; reveal labels on hover or focus.';

  @override
  String get navigationLabelDescription => 'Always show labels below icons.';

  @override
  String get navigationDrawerDescription =>
      'Use the bottom button to expand navigation and move the content sidebar.';

  @override
  String get navigationHoverDescription =>
      'Preview on hover and collapse when the pointer leaves. Pin to keep navigation open.';

  @override
  String get toolbarFullDescription =>
      'Show the full ribbon with tabs, groups, and command names.';

  @override
  String get toolbarModerateDescription =>
      'Keep ribbon tabs and show commands in a horizontally scrolling row of icons and labels.';

  @override
  String get toolbarConciseDescription =>
      'Keep ribbon tabs and show commands in a horizontally scrolling row of icons.';

  @override
  String get exportWordUnavailable => 'Word (Coming Soon)';

  @override
  String get exportPdfUnavailable => 'PDF (Coming Soon)';

  @override
  String get exchangeChapters => 'Chapter Content';

  @override
  String get exchangeOutline => 'Outline and Timeline';

  @override
  String get exchangePlans => 'Release Plans and Foreshadowing';

  @override
  String get exchangeWorld => 'Worldbuilding and Location Snapshots';

  @override
  String get exchangeCharacters => 'Characters and Snapshots';

  @override
  String get exchangeItems => 'Items and Snapshots';

  @override
  String get characterMinorSupporting => 'Minor Supporting Character';

  @override
  String untitledTimelineNode(String label) {
    return 'Untitled $label';
  }

  @override
  String welcomeMorning(String name) {
    return 'Good Morning,\n$name!';
  }

  @override
  String welcomeAfternoon(String name) {
    return 'Good Afternoon,\n$name!';
  }

  @override
  String welcomeEvening(String name) {
    return 'Good Evening,\n$name!';
  }

  @override
  String welcomeNight(String name) {
    return 'Good Night,\n$name!';
  }

  @override
  String get welcomeUser => 'User';

  @override
  String get ribbonMoreOptions => 'More Options';

  @override
  String get ribbonCustomize => 'Customize Ribbon';

  @override
  String get ribbonQuickAccess => 'Quick Access Toolbar';

  @override
  String get ribbonTabs => 'Ribbon Tabs';

  @override
  String get ribbonExpandQuickAccess => 'Expand Quick Access Toolbar';

  @override
  String get ribbonCollapseQuickAccess => 'Collapse Quick Access Toolbar';

  @override
  String get ribbonCustomizeQuickAccess => 'Customize Quick Access Toolbar';

  @override
  String get ribbonMoreQuickAccess => 'More Quick Access Commands';

  @override
  String ribbonExpand(String shortcut) {
    return 'Expand Ribbon ($shortcut)';
  }

  @override
  String ribbonCollapse(String shortcut) {
    return 'Collapse Ribbon ($shortcut)';
  }

  @override
  String get ribbonSearch => 'Search Commands';

  @override
  String get ribbonTextColor => 'Text Color';

  @override
  String get ribbonColor => 'Color';

  @override
  String get ribbonFont => 'Font';

  @override
  String ribbonTabSemantics(String label) {
    return '$label tab';
  }

  @override
  String ribbonMoveTabUp(String label) {
    return 'Move $label up';
  }

  @override
  String ribbonMoveTabDown(String label) {
    return 'Move $label down';
  }

  @override
  String ribbonCommandsSemantics(String label) {
    return '$label commands';
  }

  @override
  String ribbonGroupSemantics(String label) {
    return '$label group';
  }

  @override
  String get ribbonTabNavigation =>
      'Use Left, Right, Home, or End to switch tabs.';

  @override
  String get ribbonReset => 'Reset to Defaults';

  @override
  String get ribbonDone => 'Done';

  @override
  String completionBrowseTargets(String p1) {
    return 'Browse $p1 targets';
  }

  @override
  String completionPendingLink(String p1) {
    return 'Pending link: $p1';
  }

  @override
  String completionAlias(String p1, String p2) {
    return '$p1 · Alias of $p2';
  }

  @override
  String completionCharacterAlias(String p1) {
    return 'Character · Alias of $p1';
  }

  @override
  String completionAddAlias(String p1) {
    return 'Add an alias for $p1';
  }

  @override
  String completionCreateTarget(String p1) {
    return 'Add $p1…';
  }

  @override
  String completionHighlightForeground(String p1) {
    return 'Highlight Text Color · Background $p1';
  }

  @override
  String completionMarkerForeground(String p1) {
    return 'Marker Text Color Code · Background $p1';
  }

  @override
  String relationshipAmbiguousName(String p1) {
    return 'Ambiguous name: $p1';
  }

  @override
  String relationshipUnlinked(String p1) {
    return 'Not linked: $p1';
  }

  @override
  String snapshotConflictsCount(String p1) {
    return 'Obstacles $p1';
  }

  @override
  String snapshotRelationshipsCount(String p1) {
    return 'Relationships $p1';
  }

  @override
  String snapshotOrganizationsCount(String p1) {
    return 'Organizations $p1';
  }

  @override
  String snapshotStatusesCount(String p1) {
    return 'Character States $p1';
  }

  @override
  String snapshotPossessionsCount(String p1) {
    return 'Possessions $p1';
  }

  @override
  String snapshotCustomFieldsCount(String p1) {
    return 'Custom Fields $p1';
  }

  @override
  String inspirationNoteCount(String p1) {
    return 'Ideas: $p1';
  }

  @override
  String proofUnmatchedClosing(String p1) {
    return 'Unmatched closing delimiter “$p1”.';
  }

  @override
  String proofMismatchedPair(String p1, String p2, String p3) {
    return 'Closing delimiter “$p1” does not match “$p2”; expected “$p3”.';
  }

  @override
  String proofUnclosedPair(String p1, String p2) {
    return 'Opening delimiter “$p1” is not closed; missing “$p2”.';
  }

  @override
  String proofEllipsisSuggestion(String p1) {
    return 'Use “……” for an ellipsis; found “$p1”.';
  }

  @override
  String proofConsecutiveSymbols(String p1, String p2, String p3) {
    return '$p1 consecutive $p2 marks: “$p3”.';
  }

  @override
  String proofInvalidLineEnding(String p1, String p2) {
    return '[$p1] Line ending does not follow the rules; found “$p2”.';
  }

  @override
  String timelineUnnamedLevel(String p1) {
    return 'Untitled $p1';
  }

  @override
  String worldChildNodeCount(String p1, String p2) {
    return '$p1 · Child nodes: $p2';
  }

  @override
  String get revisionUnaccept => 'Undo Acceptance';

  @override
  String get revisionAccept => 'Accept';

  @override
  String get revisionReject => 'Reject';

  @override
  String get relationshipExternal => 'External';

  @override
  String get relationshipInternal => 'Internal';

  @override
  String get writingGoalInvalid => 'Enter an integer from 1 to 999,999,999.';

  @override
  String get worldRule => 'Rule';

  @override
  String get worldOrganization => 'Organization';

  @override
  String get glossaryPositive => 'Positive';

  @override
  String get glossaryNegative => 'Negative';

  @override
  String get glossaryNeutral => 'Neutral';

  @override
  String get glossaryNoun => 'Noun';

  @override
  String get glossaryVerb => 'Verb';

  @override
  String get glossaryAdjective => 'Adjective';

  @override
  String get glossaryAdverb => 'Adverb';

  @override
  String get glossaryPronoun => 'Pronoun';

  @override
  String get glossaryUnspecified => 'Unspecified';

  @override
  String get conflictUnskilledActivities => 'Unskilled Activities';

  @override
  String get conflictPersonalityTraits => 'Personality Traits';

  @override
  String get conflictValue => 'Value';

  @override
  String get conflictValuesAndBeliefs => 'Values and Beliefs';

  @override
  String get conflictInternalConflict => 'Internal Conflict';

  @override
  String get conflictAllocatedQuantity => 'Allocated Quantity';

  @override
  String get conflictFavoriteActivities => 'Favorite Activities';

  @override
  String get conflictLikes => 'Likes';

  @override
  String get conflictSynopsis => 'Synopsis';

  @override
  String get conflictName => 'Name';

  @override
  String get conflictFearedActivities => 'Feared Activities';

  @override
  String get conflictFears => 'Fears';

  @override
  String get conflictSeekingANewRelationship => 'Seeking a New Relationship';

  @override
  String get conflictAdmiredThings => 'Admired Things';

  @override
  String get conflictCommonAbilities => 'Common Abilities';

  @override
  String get conflictCommonAbilityValues => 'Common Ability Values';

  @override
  String get conflictHarem => 'Harem';

  @override
  String get conflictFear => 'Fear';

  @override
  String get conflictDesiredActivities => 'Desired Activities';

  @override
  String get conflictDescription => 'Description';

  @override
  String get conflictSkilledActivities => 'Skilled Activities';

  @override
  String get conflictTextFields => 'Text Fields';

  @override
  String get conflictFamiliarThings => 'Familiar Things';

  @override
  String get conflictItemData => 'Item Data';

  @override
  String get conflictTraitValues => 'Trait Values';

  @override
  String get conflictSocialValues => 'Social Values';

  @override
  String get conflictSocialTraits => 'Social Traits';

  @override
  String get conflictOccupationOrRole => 'Occupation or Role';

  @override
  String get conflictLegacyFields => 'Legacy Fields';

  @override
  String get conflictApproachValues => 'Approach Values';

  @override
  String get conflictApproaches => 'Approaches';

  @override
  String get conflictHandlingDislike => 'Handling Dislike';

  @override
  String get conflictShowingGoodwill => 'Showing Goodwill';

  @override
  String get conflictShowingLove => 'Showing Love';

  @override
  String get conflictResolution => 'Resolution';

  @override
  String get conflictResolutionMethod => 'Resolution Method';

  @override
  String get conflictDislikedActivities => 'Disliked Activities';

  @override
  String get conflictDislikes => 'Dislikes';

  @override
  String get conflictAdvancedAbilities => 'Advanced Abilities';

  @override
  String get conflictRelationship => 'Relationship';

  @override
  String get conflictRelationshipSummary => 'Relationship Summary';

  @override
  String get conflictObstacle => 'Obstacle';

  @override
  String get conflictGoalRecoveryData => 'Goal Recovery Data';

  @override
  String get conflictWholeVersion => 'Whole Version';

  @override
  String p2pConnectedAndVerifiedThisEndpointTCPWorks(String p1) {
    return '$p1 connected and verified this endpoint. TCP works in both directions; no reverse connection is needed.';
  }

  @override
  String p2pSentASecurePairingRequestThisDevice(String p1) {
    return '$p1 sent a secure pairing request. This device is responding automatically.';
  }

  @override
  String p2pCouldNotProcessTheRemotePairingEvent(String p1) {
    return 'Could not process the remote pairing event: $p1';
  }

  @override
  String p2pRejectedAnInvalidRemoteRevisionGraph(String p1) {
    return 'Rejected an invalid remote revision graph: $p1';
  }

  @override
  String get p2pIgnoredAnExpiredPairingChallengeFromThe =>
      'Ignored an expired pairing challenge from the previous attempt. Waiting for an automatic refresh.';

  @override
  String get p2pThePeerSPairingChallengeIsInvalid =>
      'The peer\'s pairing challenge is invalid, altered, or expired.';

  @override
  String get p2pTheTrustedDeviceSPublicKeyChanged =>
      'The trusted device\'s public key changed. Pairing was rejected.';

  @override
  String get p2pThePeerRequestedSecurePairingButThis =>
      'The peer requested secure pairing, but this device cannot create a challenge yet. Waiting to retry.';

  @override
  String get p2pCompareTheSixDigitPairingCodeOn =>
      'Compare the six-digit pairing code on both devices. Confirm only if they match exactly.';

  @override
  String get p2pBothDevicesDayAuthenticationIsValidThis =>
      'Both devices\' 14-day authentication is valid. This short-term session was signed automatically.';

  @override
  String p2pPersistentAuthenticationCouldNotSignAutomatically(String p1) {
    return 'Persistent authentication could not sign automatically: $p1';
  }

  @override
  String get p2pIgnoredAPreviousPairingConfirmationWaitingFor =>
      'Ignored a previous pairing confirmation. Waiting for a signature for the current challenge.';

  @override
  String get p2pThePeerSPairingConfirmationSignatureOr =>
      'The peer\'s pairing confirmation signature or transcript does not match.';

  @override
  String get p2pThePeerConfirmedTheCodeBothDevices =>
      'The peer confirmed the code. Both devices allow one-sided confirmation, so this device verified and signed automatically.';

  @override
  String p2pCouldNotCompleteSecurePairingAutomatically(String p1) {
    return 'Could not complete secure pairing automatically: $p1';
  }

  @override
  String get p2pBothDevicesSignedTheSamePairingTranscript =>
      'Both devices signed the same pairing transcript. Establishing authenticated encrypted transport.';

  @override
  String get p2pThePeerConfirmedTheCodeYourSettings =>
      'The peer confirmed the code. Your settings also require confirmation on this device.';

  @override
  String get p2pAuthenticatedEncryptedTransportIsReadyRevisionSummaries =>
      'Authenticated encrypted transport is ready. Revision summaries and snapshot chunks are exchanged only through this channel.';

  @override
  String p2pCouldNotVerifyTheEncryptedChannelS(String p1) {
    return 'Could not verify the encrypted channel\'s device identity or transcript: $p1';
  }

  @override
  String p2pCouldNotEstablishAnEncryptedChannel(String p1) {
    return 'Could not establish an encrypted channel: $p1';
  }

  @override
  String p2pEncryptedRevisionSummariesAreTemporarilyUnavailable(String p1) {
    return 'Encrypted revision summaries are temporarily unavailable: $p1';
  }

  @override
  String p2pRejectedAnInvalidEncryptedRevisionSummary(String p1) {
    return 'Rejected an invalid encrypted revision summary: $p1';
  }

  @override
  String p2pTheEncryptedChannelIsCurrentlyUnavailable(String p1) {
    return 'The encrypted channel is currently unavailable: $p1';
  }

  @override
  String p2pRejectedAnInvalidEncryptedRevisionGraph(String p1) {
    return 'Rejected an invalid encrypted revision graph: $p1';
  }

  @override
  String p2pRevisionGraphTransferWasInterruptedReconnectTo(String p1) {
    return 'Revision graph transfer was interrupted. Reconnect to resume: $p1';
  }

  @override
  String p2pTheRevisionGraphIsCurrentlyUnavailable(String p1) {
    return 'The revision graph is currently unavailable: $p1';
  }

  @override
  String get p2pNoVerifiedPeerEndpointYetWaitFor =>
      'No verified peer endpoint yet. Wait for the encrypted revision summary exchange.';

  @override
  String get p2pNoSnapshotIsCurrentlyAvailableToSend =>
      'No snapshot is currently available to send through the verified connection.';

  @override
  String get p2pSyncRequestedThroughTheEncryptedChannelWaiting =>
      'Sync requested through the encrypted channel. Waiting for the receiver to download and choose a save location.';

  @override
  String p2pCouldNotSendASyncRequest(String p1) {
    return 'Could not send a sync request: $p1';
  }

  @override
  String get p2pThePeerRequestedSyncThroughTheEncrypted =>
      'The peer requested sync through the encrypted channel. Preparing the snapshot download.';

  @override
  String get p2pRejectedARemoteAcknowledgementWithAMismatched =>
      'Rejected a remote acknowledgement with a mismatched identity or project session.';

  @override
  String get p2pReceivedThePeerSResolutionAcknowledgementWaiting =>
      'Received the peer\'s resolution acknowledgement. Waiting for the verified revision graph.';

  @override
  String get p2pRejectedAnAcknowledgementWhoseContentOrParent =>
      'Rejected an acknowledgement whose content or parent differs from the local resolution revision.';

  @override
  String get p2pThePeerAcknowledgedTheResolutionRevisionBoth =>
      'The peer acknowledged the resolution revision. Both revision graphs have converged.';

  @override
  String get p2pRejectedAnAcknowledgementAbsentFromThePeer =>
      'Rejected an acknowledgement absent from the peer\'s verified revision graph.';

  @override
  String get p2pThePeerAcknowledgedTheRemoteResolutionRevision =>
      'The peer acknowledged the remote resolution revision. Waiting to download and install it.';

  @override
  String get p2pCreatedAPairingChallengeValidForTen =>
      'Created a pairing challenge valid for ten minutes. Waiting for the peer to start pairing.';

  @override
  String p2pCouldNotStartSecurePairing(String p1) {
    return 'Could not start secure pairing: $p1';
  }

  @override
  String get p2pThisDeviceSignedItsConfirmationWaitingFor =>
      'This device signed its confirmation. Waiting for the peer to verify and sign automatically.';

  @override
  String get p2pThisDeviceSignedAndTrustedThePeer =>
      'This device signed and trusted the peer. Waiting for manual confirmation of the same transcript on the peer.';

  @override
  String p2pCouldNotSaveTheTrustedDevice(String p1) {
    return 'Could not save the trusted device: $p1';
  }

  @override
  String get p2pPairingCancelled => 'Pairing cancelled.';

  @override
  String get p2pPairingConfirmationSettingsChangedStartPairingAgain =>
      'Pairing confirmation settings changed. Start pairing again.';

  @override
  String p2pCouldNotLoadRevisionMetadata(String p1) {
    return 'Could not load revision metadata: $p1';
  }

  @override
  String get p2pCouldNotCreateARevisionInvalidProject =>
      'Could not create a revision: invalid project UUID.';

  @override
  String get p2pNewRevisionSavedNotifyingThePeerThrough =>
      'New revision saved. Notifying the peer through the encrypted channel.';

  @override
  String p2pCouldNotCreateRevisionMetadata(String p1) {
    return 'Could not create revision metadata: $p1';
  }

  @override
  String get p2pDraftRevisionCreatedSendingItsSummaryThrough =>
      'Draft revision created. Sending its summary through the encrypted channel.';

  @override
  String get p2pDraftRevisionCreatedSendingItsSummaryAnd =>
      'Draft revision created. Sending its summary and delta through the encrypted channel.';

  @override
  String p2pCouldNotCreateADraftRevision(String p1) {
    return 'Could not create a draft revision: $p1';
  }

  @override
  String p2pRejectedAnInvalidRevisionDeltaFallingBack(String p1) {
    return 'Rejected an invalid revision delta. Falling back to a full snapshot: $p1';
  }

  @override
  String p2pCouldNotSaveRemoteHistory(String p1) {
    return 'Could not save remote history: $p1.';
  }

  @override
  String p2pRemoteSnapshotOpenedButItsRevisionGraph(String p1) {
    return 'Remote snapshot opened, but its revision graph could not be saved: $p1';
  }

  @override
  String get p2pCouldNotStageTheRemoteConflictSnapshot =>
      'Could not stage the remote conflict snapshot: the session or graph is no longer valid.';

  @override
  String p2pCouldNotStageTheRemoteConflictSnapshot2(String p1) {
    return 'Could not stage the remote conflict snapshot: $p1';
  }

  @override
  String get p2pMultipleMaximalCommonAncestorsFoundARecursive =>
      'Multiple maximal common ancestors found. A recursive merge base is required before merging.';

  @override
  String get p2pCouldNotPrepareFieldMergingTheAuthenticated =>
      'Could not prepare field merging: the authenticated session or concurrent heads are no longer valid.';

  @override
  String p2pCouldNotPrepareProjectFieldMerging(String p1) {
    return 'Could not prepare project field merging: $p1';
  }

  @override
  String get p2pCreatedAResolutionRevisionWithTwoParents =>
      'Created a resolution revision with two parents. Waiting to transmit it through the encrypted channel.';

  @override
  String p2pCouldNotCreateAResolutionRevision(String p1) {
    return 'Could not create a resolution revision: $p1';
  }

  @override
  String get p2pRespondedAutomaticallyToThePeerSSecure =>
      'Responded automatically to the peer\'s secure pairing request. Creating the comparison code.';

  @override
  String p2pCouldNotAutomaticallyCreateALocalPairing(String p1) {
    return 'Could not automatically create a local pairing challenge: $p1';
  }

  @override
  String get p2pPairingChallengeRefreshedAutomaticallyWaitingForThe =>
      'Pairing challenge refreshed automatically. Waiting for the peer to obtain the new code.';

  @override
  String p2pCouldNotRefreshThePairingChallenge(String p1) {
    return 'Could not refresh the pairing challenge: $p1';
  }

  @override
  String get p2pThePeerChangedItsSyncDocumentDisconnected =>
      'The peer changed its sync document. Disconnected.';

  @override
  String get p2pThisDeviceChangedItsSyncDocumentDisconnected =>
      'This device changed its sync document. Disconnected.';

  @override
  String p2pCouldNotInitializeTheDeviceSSecure(String p1) {
    return 'Could not initialize the device\'s secure identity: $p1';
  }

  @override
  String p2pCouldNotObtainALocalLANIP(String p1) {
    return 'Could not obtain a local LAN IP address: $p1';
  }

  @override
  String get p2pStartingLocalService => 'Starting local service…';

  @override
  String get p2pLocalEndpointReadySecurePairingEnablesEncrypted =>
      'Local endpoint ready. Secure pairing enables encrypted revision and snapshot exchange.';

  @override
  String p2pCouldNotOpenPort(String p1, String p2) {
    return 'Could not open port $p1: $p2';
  }

  @override
  String get p2pStoppingLocalService => 'Stopping local service…';

  @override
  String get p2pLocalServiceStopped => 'Local service stopped.';

  @override
  String p2pCouldNotStopLocalService(String p1) {
    return 'Could not stop local service: $p1';
  }

  @override
  String p2pTesting(String p1, String p2) {
    return 'Testing $p1:$p2…';
  }

  @override
  String get p2pEndpointReachableSecurePairingIsRequiredTo =>
      'Endpoint reachable. Secure pairing is required to enable encrypted content transport.';

  @override
  String p2pCouldNotConnectTo(String p1, String p2) {
    return 'Could not connect to $p1: $p2';
  }

  @override
  String p2pConnectingAndNegotiatingTheSyncDocumentAt(String p1, String p2) {
    return 'Connecting and negotiating the sync document at $p1:$p2…';
  }

  @override
  String get p2pThisDeviceWillProvideTheSyncDocument =>
      'This device will provide the sync document.';

  @override
  String get p2pThePeerWillProvideTheSyncDocument =>
      'The peer will provide the sync document.';

  @override
  String get p2pPeerDisconnectedTheLocalServiceIsStill =>
      'Peer disconnected. The local service is still listening.';

  @override
  String get p2pPeerDisconnected => 'Peer disconnected.';

  @override
  String get p2pNoRemoteSnapshotIsAvailableForDownload =>
      'No remote snapshot is available for download through a verified connection.';

  @override
  String get p2pReconstructingOrDownloadingAndVerifyingTheSnapshot =>
      'Reconstructing or downloading and verifying the snapshot through authenticated encrypted transport…';

  @override
  String get p2pSnapshotChunksSHAXMLUUIDAndVersion =>
      'Snapshot chunks, SHA-256, XML, UUID, and version verified. Not yet written to the project.';

  @override
  String get p2pSnapshotReconstructedFromAnEncryptedDeltaSHA =>
      'Snapshot reconstructed from an encrypted delta. SHA-256, XML, UUID, and version verified. Not yet written to the project.';

  @override
  String get p2pSnapshotDownloadCancelled => 'Snapshot download cancelled.';

  @override
  String p2pSnapshotDownloadOrVerificationFailed(String p1) {
    return 'Snapshot download or verification failed: $p1';
  }

  @override
  String get p2pRevisionsDivergedResolveConflictsFieldByField =>
      'Revisions diverged. Resolve conflicts field by field before replacing the local document.';

  @override
  String get p2pTheVerifiedSnapshotIsNoLongerValid =>
      'The verified snapshot is no longer valid. Reconnect securely and download it again.';

  @override
  String get p2pNoVerifiedRevisionGraphContainingThisSnapshot =>
      'No verified revision graph containing this snapshot is available. The project was not modified.';

  @override
  String get p2pAuthenticatedSnapshotSessionCapabilityIsMissingThe =>
      'Authenticated snapshot session capability is missing. The project was not modified.';

  @override
  String get p2pWaitingToConfirmTheSaveLocationAnd =>
      'Waiting to confirm the save location and safely open the snapshot…';

  @override
  String get p2pTheSyncSessionChangedSnapshotApplicationTo =>
      'The sync session changed. Snapshot application to the editor was stopped.';

  @override
  String get p2pSnapshotSavedAndOpenedButRemoteRevision =>
      'Snapshot saved and opened, but remote revision history could not be saved. Stop editing and retry sync.';

  @override
  String get p2pRemoteSnapshotSavedAndOpened =>
      'Remote snapshot saved and opened.';

  @override
  String get p2pApplicationCancelledVerificationResultsRemainInMemory =>
      'Application cancelled. Verification results remain in memory.';

  @override
  String p2pCouldNotSaveOrOpenTheSnapshot(String p1) {
    return 'Could not save or open the snapshot: $p1';
  }

  @override
  String get p2pConcurrentSnapshotsMergedFieldByFieldAnd =>
      'Concurrent snapshots merged field by field and a resolution revision created.';

  @override
  String get p2pSnapshotTransferCancelled => 'Snapshot transfer cancelled.';

  @override
  String get p2pConnectionDocumentOrRevisionChangedThePrevious =>
      'Connection, document, or revision changed. The previous snapshot is no longer valid.';

  @override
  String get p2pBothUUIDsMatchTheSameSyncDocument =>
      'Both UUIDs match. The same sync document is selected.';

  @override
  String get p2pThePeerHasNoTargetDocumentThis =>
      'The peer has no target document. This device will provide it.';

  @override
  String get p2pThisDeviceHasNoTargetDocumentThe =>
      'This device has no target document. The peer will provide it.';

  @override
  String get p2pNeitherDeviceHasASyncDocumentChoose =>
      'Neither device has a sync document. Choose one first.';

  @override
  String get p2pTheDocumentUUIDsDifferChooseWhichDocument =>
      'The document UUIDs differ. Choose which document to sync.';

  @override
  String paletteGraySemantics(String value) {
    return 'Grayscale, brightness $value%';
  }

  @override
  String paletteColorSemantics(String hue, String saturation, String value) {
    return 'Hue $hue degrees, saturation $saturation%, brightness $value%';
  }

  @override
  String revisionCheckpointLabel(String timestamp) {
    return 'Checkpoint $timestamp';
  }

  @override
  String get projectErrorAccessDenied =>
      'File access was denied. Select the original file again to restore access, or use Save As to keep your changes.';

  @override
  String get projectErrorFileMissing =>
      'The file could not be found. Check whether it was moved or deleted.';

  @override
  String get projectErrorInvalidPath =>
      'The file path is invalid. Select the file or save location again.';

  @override
  String get projectErrorInvalidData =>
      'The project data is invalid. Check the file or restore a backup.';

  @override
  String get projectErrorCancelled =>
      'The file operation was cancelled. Changes have not been saved.';

  @override
  String get projectErrorNoSaveLocation =>
      'The project has no save location. Save it or use Save As first.';

  @override
  String get projectErrorNoSpace =>
      'There is not enough storage space. Free some space or choose another location.';

  @override
  String get projectErrorBackupLimit =>
      'The project exceeds the backup storage limit. Increase the limit in Settings.';

  @override
  String get projectErrorUnsupported =>
      'This file operation is not supported on this platform.';

  @override
  String get projectErrorDuplicateIdentity =>
      'The data contains blank or duplicate IDs. Reopen the project to repair the chapter tree.';

  @override
  String get projectErrorTreeTooDeep =>
      'The tree exceeds 256 levels. Reduce its nesting depth and try again.';

  @override
  String get projectErrorExportFormat =>
      'The export purpose, format, or scope is incompatible, or the format is not supported yet.';

  @override
  String get projectErrorExportSelection =>
      'The export selection is invalid. Select at least one item again.';

  @override
  String get projectErrorExportEmpty =>
      'The selection has no content to export. Choose another selection.';

  @override
  String get projectErrorMissingItemDefinition =>
      'An item is missing its definition. Repair the item data before exporting.';

  @override
  String get projectErrorProjectChanged =>
      'The source project has changed. Reopen the export dialog.';

  @override
  String get projectErrorUnknown =>
      'The operation could not be completed. Your changes remain in the editor. Try again or use Save As.';

  @override
  String get copilotErrorInvalidConfiguration =>
      'The model service rejected the request format or parameters. Check your settings.';

  @override
  String get copilotErrorAuthenticationFailed =>
      'The API key is invalid or expired. Check your credentials.';

  @override
  String get copilotErrorPermissionDenied =>
      'The model service denied access to these credentials or this model.';

  @override
  String get copilotErrorRateLimited =>
      'The model service is rate limited or out of quota. Try again later.';

  @override
  String get copilotErrorModelUnavailable =>
      'The selected model or API endpoint was not found. Select another model.';

  @override
  String get copilotErrorContextTooLarge =>
      'The request exceeds the size limit. Shorten the message or reduce the context.';

  @override
  String get copilotErrorResponseTooLarge =>
      'The model response exceeds the allowed size limit.';

  @override
  String get copilotErrorRequestTimedOut =>
      'The Copilot request timed out. Try again later.';

  @override
  String get copilotErrorInvalidResponse =>
      'The model response could not be parsed. Try again or select another model.';

  @override
  String get copilotErrorNetworkUnavailable =>
      'The Copilot request failed. Check the network, API URL, model, and credentials.';

  @override
  String get copilotErrorServiceUnavailable =>
      'The model service is temporarily unavailable. Try again later.';

  @override
  String get copilotErrorValidation =>
      'Check the current chapter, selected resources, and API URL before trying again.';

  @override
  String get uiImplicitMention => 'Implicit mention';

  @override
  String get paletteSearchRange => 'Search range';

  @override
  String get paletteRangePrecise => 'Precise';

  @override
  String get paletteRangeDefault => 'Moderate';

  @override
  String get paletteRangeBroad => 'Broad';

  @override
  String get paletteNoNearbyEntries => 'No entries within this range';

  @override
  String get paletteOutsideRange => 'Nearest entries (outside range)';

  @override
  String get paletteInvalidHex => 'Enter a six-digit HEX color';
}
