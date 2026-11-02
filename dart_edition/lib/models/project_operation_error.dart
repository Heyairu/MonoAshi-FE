import 'dart:io';

import 'package:flutter/services.dart';

enum ProjectErrorCode {
  unknown,
  accessDenied,
  fileMissing,
  invalidPath,
  invalidData,
  cancelled,
  noSaveLocation,
  noSpace,
  backupLimit,
  unsupported,
  duplicateIdentity,
  treeTooDeep,
  exportFormat,
  exportSelection,
  exportEmpty,
  missingItemDefinition,
  projectChanged,
}

/// Machine-readable validation failures; diagnostic text never serves as a
/// translation key. Remains a FormatException for existing codec consumers.
class ProjectValidationException extends FormatException {
  final ProjectErrorCode code;
  const ProjectValidationException(this.code, String diagnostic)
    : super(diagnostic);
}

ProjectErrorCode classifyProjectError(Object error) {
  if (error is ProjectValidationException) return error.code;
  if (error is FileSystemException) {
    return switch (error.osError?.errorCode) {
      1 || 5 || 13 => ProjectErrorCode.accessDenied,
      2 || 3 => ProjectErrorCode.fileMissing,
      28 || 112 => ProjectErrorCode.noSpace,
      _ => ProjectErrorCode.unknown,
    };
  }
  if (error is PlatformException) {
    return switch (error.code) {
      'BOOKMARK_ACCESS_FAILED' ||
      'BOOKMARK_OPEN_FAILED' ||
      'PERMISSION_DENIED' => ProjectErrorCode.accessDenied,
      'INVALID_ARGS' => ProjectErrorCode.invalidPath,
      'BOOKMARK_INVALID' || 'INVALID_DATA' => ProjectErrorCode.invalidData,
      'FILE_MISSING' => ProjectErrorCode.fileMissing,
      'NO_SPACE' => ProjectErrorCode.noSpace,
      _ => ProjectErrorCode.unknown,
    };
  }
  if (error is FormatException) return ProjectErrorCode.invalidData;
  return ProjectErrorCode.unknown;
}
