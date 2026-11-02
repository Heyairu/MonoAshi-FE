import 'app_locale.dart';
import 'generated/app_localizations.dart';

/// A presentation message whose parameters are captured when the event occurs,
/// and whose language is resolved when a widget displays it. Never persisted
/// in project files, operation logs, or protocol payloads.
final class LocalizedUiText {
  LocalizedUiText(this._resolve, [List<String> arguments = const []])
    : _arguments = List.unmodifiable(arguments);

  final String Function(AppLocalizations, List<String>) _resolve;
  final List<String> _arguments;

  String localize(AppLocalizations l10n) => _resolve(l10n, _arguments);

  // Preserve the legacy diagnostic/test representation without storing a
  // locale-dependent string in state.
  @override
  String toString() => localize(lookupAppLocalizations(defaultAppLocale));
}

String? localizeUiText(Object? text, AppLocalizations l10n) => switch (text) {
  LocalizedUiText() => text.localize(l10n),
  String() => text,
  null => null,
  _ => throw ArgumentError.value(text, 'text', 'Expected UI text'),
};
