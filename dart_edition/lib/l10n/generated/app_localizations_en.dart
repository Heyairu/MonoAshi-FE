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
      'Applies immediately and is saved automatically. Some features are still in Traditional Chinese.';

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
}
