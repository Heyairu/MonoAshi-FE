import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localization.dart';
import '../../providers/global_state_providers.dart';

/// Shared by Settings and OOBE. Language persists independently of OOBE drafts.
class AppLanguageSelector extends ConsumerStatefulWidget {
  const AppLanguageSelector({
    super.key,
    this.fieldKey = const Key('settings-language'),
  });

  final Key fieldKey;

  @override
  ConsumerState<AppLanguageSelector> createState() =>
      _AppLanguageSelectorState();
}

class _AppLanguageSelectorState extends ConsumerState<AppLanguageSelector> {
  int _requestId = 0;
  bool _saveFailed = false;

  Future<void> _select(AppLocalePreference preference) async {
    final requestId = ++_requestId;
    setState(() => _saveFailed = false);
    try {
      await ref.read(settingsStateProvider.notifier).setAppLocale(preference);
    } catch (_) {
      if (mounted && requestId == _requestId) {
        setState(() => _saveFailed = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsStateProvider);
    final l10n = context.l10n;
    return DropdownButtonFormField<AppLocalePreference>(
      key: widget.fieldKey,
      initialValue:
          settings.valueOrNull?.appLocale ?? AppLocalePreference.system,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: l10n.languageTitle,
        prefixIcon: const Icon(Icons.language),
        helperText: l10n.languageHelp,
        helperMaxLines: 5,
        errorText: _saveFailed ? l10n.languageSaveFailed : null,
        errorMaxLines: 5,
      ),
      items: [
        DropdownMenuItem(
          value: AppLocalePreference.system,
          child: Text(l10n.languageSystem),
        ),
        DropdownMenuItem(
          value: AppLocalePreference.traditionalChinese,
          child: Text(context.l10n.uiLiteral4),
        ),
        const DropdownMenuItem(
          value: AppLocalePreference.english,
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: AppLocalePreference.japanese,
          child: Text(context.l10n.uiLiteral5),
        ),
      ],
      onChanged: settings.hasValue
          ? (value) {
              if (value != null) unawaited(_select(value));
            }
          : null,
    );
  }
}
