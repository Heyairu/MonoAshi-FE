import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_locale.dart';
import '../../l10n/locale_resolution.dart';
import 'global_state_providers.dart';

class SystemLocalesNotifier extends StateNotifier<List<Locale>>
    with WidgetsBindingObserver {
  SystemLocalesNotifier(this._binding)
    : super(List.unmodifiable(_binding.platformDispatcher.locales)) {
    _binding.addObserver(this);
  }

  final WidgetsBinding _binding;

  @override
  void didChangeLocales(List<Locale>? locales) {
    state = List.unmodifiable(locales ?? const <Locale>[]);
  }

  @override
  void dispose() {
    _binding.removeObserver(this);
    super.dispose();
  }
}

final systemLocalesProvider =
    StateNotifierProvider<SystemLocalesNotifier, List<Locale>>(
      (ref) => SystemLocalesNotifier(WidgetsBinding.instance),
    );

final appLocalePreferenceProvider = Provider<AppLocalePreference>((ref) {
  return ref.watch(
    settingsStateProvider.select(
      (state) => state.valueOrNull?.appLocale ?? AppLocalePreference.system,
    ),
  );
});

/// Shared resolved locale for fonts and future non-widget locale consumers.
/// Manual selection is independent of subsequent OS locale changes.
final resolvedAppLocaleProvider = Provider<Locale>((ref) {
  return resolveAppLocale(
    ref.watch(systemLocalesProvider),
    preference: ref.watch(appLocalePreferenceProvider),
  );
});
