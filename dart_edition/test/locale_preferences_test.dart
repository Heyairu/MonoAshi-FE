import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/data/repositories/settings_repository.dart';
import 'package:monogatari_assistant/l10n/app_locale.dart';
import 'package:monogatari_assistant/presentation/providers/global_state_providers.dart';
import 'package:monogatari_assistant/presentation/providers/repository_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Use the existing shared_preferences platform testing seam without changing
// the application's dependency versions.
// ignore: depend_on_referenced_packages
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

class _RejectingPreferenceStore extends InMemorySharedPreferencesStore {
  _RejectingPreferenceStore({required this.throwOnWrite})
    : super.withData({'flutter.app_locale': 'en'});
  final bool throwOnWrite;

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    if (throwOnWrite) throw StateError('disk unavailable');
    return false;
  }
}

class _ControlledLocaleRepository extends SharedPreferencesSettingsRepository {
  final writes = <AppLocalePreference>[];
  final started = List.generate(4, (_) => Completer<void>());
  final gates = List.generate(4, (_) => Completer<void>());

  @override
  Future<void> saveAppLocale(AppLocalePreference value) async {
    final index = writes.length;
    writes.add(value);
    started[index].complete();
    await gates[index].future;
    await super.saveAppLocale(value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final throwOnWrite in [false, true]) {
    test(
      'rejected native write refreshes the optimistic preference cache (throw=$throwOnWrite)',
      () async {
        final previous = SharedPreferencesStorePlatform.instance;
        SharedPreferencesStorePlatform.instance = _RejectingPreferenceStore(
          throwOnWrite: throwOnWrite,
        );
        SharedPreferences.resetStatic();
        addTearDown(() {
          SharedPreferencesStorePlatform.instance = previous;
          SharedPreferences.resetStatic();
        });
        final repository = SharedPreferencesSettingsRepository();
        expect(
          (await repository.load()).appLocale,
          AppLocalePreference.english,
        );
        await expectLater(
          repository.saveAppLocale(AppLocalePreference.japanese),
          throwsStateError,
        );
        expect(
          (await SharedPreferences.getInstance()).getString('app_locale'),
          'en',
        );
        expect(
          (await SharedPreferencesSettingsRepository().load()).appLocale,
          AppLocalePreference.english,
        );
      },
    );
  }

  test(
    'repository loads old spellings and saves only canonical stable values',
    () async {
      final repository = SharedPreferencesSettingsRepository();
      for (final value in ['zh_TW', 'zh-TW', 'zh-Hant']) {
        SharedPreferences.setMockInitialValues({'app_locale': value});
        expect(
          (await repository.load()).appLocale,
          AppLocalePreference.traditionalChinese,
        );
      }
      for (final value in [null, 'future-locale', 42]) {
        SharedPreferences.setMockInitialValues({
          if (value != null) 'app_locale': value,
        });
        expect((await repository.load()).appLocale, AppLocalePreference.system);
      }
      for (final preference in AppLocalePreference.values) {
        await repository.saveAppLocale(preference);
        expect(
          (await SharedPreferences.getInstance()).getString('app_locale'),
          preference.preferenceValue,
        );
        expect(
          (await SharedPreferencesSettingsRepository().load()).appLocale,
          preference,
        );
      }
    },
  );

  test(
    'preference survives a fresh container without restarting bootstrap',
    () async {
      final first = ProviderContainer();
      addTearDown(first.dispose);
      await first.read(appInitializationProvider.future);
      final initialization = first.read(appInitializationProvider);
      await first
          .read(settingsStateProvider.notifier)
          .setAppLocale(AppLocalePreference.japanese);
      expect(first.read(appInitializationProvider), same(initialization));
      expect(
        first.read(settingsStateProvider).requireValue.appLocale,
        AppLocalePreference.japanese,
      );
      final fresh = ProviderContainer();
      addTearDown(fresh.dispose);
      expect(
        (await fresh.read(settingsStateProvider.future)).appLocale,
        AppLocalePreference.japanese,
      );
      await first
          .read(settingsStateProvider.notifier)
          .setAppLocale(AppLocalePreference.system);
      expect(
        (await SharedPreferences.getInstance()).getString('app_locale'),
        'system',
      );
    },
  );

  test(
    'writes are serialized and latest failure restores the last successful save',
    () async {
      final repository = _ControlledLocaleRepository();
      final container = ProviderContainer(
        overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(settingsStateProvider.future);
      final notifier = container.read(settingsStateProvider.notifier);
      final first = notifier.setAppLocale(AppLocalePreference.english);
      await repository.started[0].future;
      final second = notifier.setAppLocale(AppLocalePreference.japanese);
      final secondFailure = expectLater(second, throwsStateError);
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(settingsStateProvider).requireValue.appLocale,
        AppLocalePreference.japanese,
      );
      expect(repository.writes, [AppLocalePreference.english]);
      await notifier.setFontSize(18);
      repository.gates[0].complete();
      await first;
      await repository.started[1].future;
      repository.gates[1].completeError(StateError('disk unavailable'));
      await secondFailure;
      final rolledBack = container.read(settingsStateProvider).requireValue;
      expect(rolledBack.appLocale, AppLocalePreference.english);
      expect(rolledBack.fontSize, 18);
      expect(
        (await SharedPreferences.getInstance()).getString('app_locale'),
        'en',
      );
      final retry = notifier.setAppLocale(AppLocalePreference.japanese);
      await repository.started[2].future;
      repository.gates[2].complete();
      await retry;
      expect(
        (await SharedPreferences.getInstance()).getString('app_locale'),
        'ja',
      );
    },
  );

  test(
    'an older failed request cannot overwrite a newer optimistic choice',
    () async {
      final repository = _ControlledLocaleRepository();
      final container = ProviderContainer(
        overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(settingsStateProvider.future);
      final notifier = container.read(settingsStateProvider.notifier);
      final first = notifier.setAppLocale(AppLocalePreference.english);
      final firstFailure = expectLater(first, throwsStateError);
      await repository.started[0].future;
      final second = notifier.setAppLocale(AppLocalePreference.japanese);
      await Future<void>.delayed(Duration.zero);
      repository.gates[0].completeError(StateError('first failed'));
      await firstFailure;
      await repository.started[1].future;
      expect(
        container.read(settingsStateProvider).requireValue.appLocale,
        AppLocalePreference.japanese,
      );
      repository.gates[1].complete();
      await second;
      expect(
        (await SharedPreferences.getInstance()).getString('app_locale'),
        'ja',
      );
    },
  );
}
