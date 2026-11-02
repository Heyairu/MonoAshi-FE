import 'package:flutter/foundation.dart';

import '../models/project_file.dart';
import '../models/project_operation_error.dart';
import 'generated/app_localizations.dart';

extension ProjectErrorLocalizations on AppLocalizations {
  String projectError(Object error) {
    debugPrint('Project operation failed: $error');
    final code = error is FileException
        ? error.code
        : classifyProjectError(error);
    return switch (code) {
      ProjectErrorCode.accessDenied => projectErrorAccessDenied,
      ProjectErrorCode.fileMissing => projectErrorFileMissing,
      ProjectErrorCode.invalidPath => projectErrorInvalidPath,
      ProjectErrorCode.invalidData => projectErrorInvalidData,
      ProjectErrorCode.cancelled => projectErrorCancelled,
      ProjectErrorCode.noSaveLocation => projectErrorNoSaveLocation,
      ProjectErrorCode.noSpace => projectErrorNoSpace,
      ProjectErrorCode.backupLimit => projectErrorBackupLimit,
      ProjectErrorCode.unsupported => projectErrorUnsupported,
      ProjectErrorCode.duplicateIdentity => projectErrorDuplicateIdentity,
      ProjectErrorCode.treeTooDeep => projectErrorTreeTooDeep,
      ProjectErrorCode.exportFormat => projectErrorExportFormat,
      ProjectErrorCode.exportSelection => projectErrorExportSelection,
      ProjectErrorCode.exportEmpty => projectErrorExportEmpty,
      ProjectErrorCode.missingItemDefinition =>
        projectErrorMissingItemDefinition,
      ProjectErrorCode.projectChanged => projectErrorProjectChanged,
      ProjectErrorCode.unknown => projectErrorUnknown,
    };
  }
}
