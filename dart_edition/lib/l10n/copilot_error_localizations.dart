import '../features/copilot/domain/copilot_errors.dart';
import 'generated/app_localizations.dart';

extension CopilotErrorLocalizations on AppLocalizations {
  String copilotError(Object error) {
    final failure = CopilotErrorPolicy.fromError(error);
    // Local validation is distinct from an unreadable remote response.
    if (error is FormatException &&
        failure.code == CopilotFailureCode.invalidResponse &&
        failure.userMessage == error.message) {
      return copilotErrorValidation;
    }
    return switch (failure.code) {
      CopilotFailureCode.invalidConfiguration =>
        copilotErrorInvalidConfiguration,
      CopilotFailureCode.authenticationFailed =>
        copilotErrorAuthenticationFailed,
      CopilotFailureCode.permissionDenied => copilotErrorPermissionDenied,
      CopilotFailureCode.rateLimited => copilotErrorRateLimited,
      CopilotFailureCode.modelUnavailable => copilotErrorModelUnavailable,
      CopilotFailureCode.contextTooLarge => copilotErrorContextTooLarge,
      CopilotFailureCode.responseTooLarge => copilotErrorResponseTooLarge,
      CopilotFailureCode.requestTimedOut => copilotErrorRequestTimedOut,
      CopilotFailureCode.invalidResponse => copilotErrorInvalidResponse,
      CopilotFailureCode.networkUnavailable ||
      CopilotFailureCode.unknown => copilotErrorNetworkUnavailable,
      CopilotFailureCode.serviceUnavailable => copilotErrorServiceUnavailable,
      CopilotFailureCode.cancelled => uiRequestCancelled,
    };
  }
}
