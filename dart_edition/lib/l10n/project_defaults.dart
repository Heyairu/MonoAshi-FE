import '../models/project_defaults.dart';
import 'generated/app_localizations.dart';

extension ProjectDefaultLocalizations on AppLocalizations {
  ProjectDefaults get projectDefaults => ProjectDefaults(
    folderName: uiFolder('1'),
    storylineName: projectDefaultStorylineName,
    storylineType: projectDefaultStorylineType,
    locationName: projectDefaultLocationName,
    timelineTrackName: projectDefaultTimelineTrackName,
    timelineOriginLabel: projectDefaultTimelineOriginLabel,
    untitledTrackName: projectDefaultUntitledTrackName,
  );
}

final supportedProjectDefaults = [
  for (final locale in AppLocalizations.supportedLocales)
    lookupAppLocalizations(locale).projectDefaults,
];
