import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/l10n/app_localization.dart';
import 'package:monogatari_assistant/models/project_file.dart';
import 'package:monogatari_assistant/models/project_operation_error.dart';
import 'package:monogatari_assistant/features/copilot/domain/copilot_errors.dart';

void main() {
  test('Copilot HTTP failures use the current interface language', () {
    final failure = CopilotErrorPolicy.fromHttpStatus(
      429,
      operation: CopilotOperation.conversation,
    );
    for (final locale in [
      const Locale('zh', 'TW'),
      const Locale('en'),
      const Locale('ja'),
    ]) {
      final l10n = lookupAppLocalizations(locale);
      expect(l10n.copilotError(failure), l10n.copilotErrorRateLimited);
      expect(
        l10n.copilotError(const FormatException('請先選擇章節')),
        l10n.copilotErrorValidation,
      );
    }
  });
  test('nested file errors retain their actionable cause', () {
    final error = FileException(
      '儲存失敗',
      cause: FileException(
        '寫入失敗',
        cause: const FileSystemException(
          'Operation not permitted',
          '/private/file',
          OSError('denied', 1),
        ),
      ),
    );
    expect(error.code, ProjectErrorCode.accessDenied);
    for (final locale in [
      const Locale('zh', 'TW'),
      const Locale('en'),
      const Locale('ja'),
    ]) {
      final l10n = lookupAppLocalizations(locale);
      expect(l10n.projectError(error), l10n.projectErrorAccessDenied);
      expect(l10n.projectError(error), isNot(contains('FileException')));
      expect(l10n.projectError(error), isNot(contains('/private/file')));
    }
  });

  test('every validation code has a distinct localized message', () {
    for (final locale in [
      const Locale('zh', 'TW'),
      const Locale('en'),
      const Locale('ja'),
    ]) {
      final l10n = lookupAppLocalizations(locale);
      final messages = {
        for (final code in ProjectErrorCode.values)
          l10n.projectError(ProjectValidationException(code, '診斷訊息')),
      };
      expect(messages.length, ProjectErrorCode.values.length);
      expect(messages.every((m) => !m.contains('診斷訊息')), isTrue);
    }
    expect(
      classifyProjectError(PlatformException(code: 'BOOKMARK_ACCESS_FAILED')),
      ProjectErrorCode.accessDenied,
    );
  });
}
