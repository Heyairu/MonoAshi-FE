import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/l10n/app_localization.dart';
import 'package:monogatari_assistant/l10n/localized_ui_text.dart';
import 'package:monogatari_assistant/presentation/providers/p2p_sync_providers.dart';

void main() {
  test('event parameters are captured once and never translated', () {
    final arguments = ['主角の原文'];
    final message = LocalizedUiText(
      (l10n, args) => l10n.initializationFailed(args.single),
      arguments,
    );
    arguments[0] = 'changed later';
    for (final locale in supportedAppLocales) {
      expect(
        message.localize(lookupAppLocalizations(locale)),
        contains('主角の原文'),
      );
      expect(
        message.localize(lookupAppLocalizations(locale)),
        isNot(contains('changed later')),
      );
    }
  });

  test(
    'P2P state copies retain the message descriptor and explicit null clears it',
    () {
      final text = LocalizedUiText((l10n, _) => l10n.p2pStartingLocalService);
      final state = P2pSyncState(message: text).copyWith(configuredPort: 45000);
      expect(state.message, '正在開啟本機服務…');
      expect(
        state.messageFor(lookupAppLocalizations(const Locale('en'))),
        'Starting local service…',
      );
      expect(
        state.messageFor(lookupAppLocalizations(const Locale('ja'))),
        'ローカルサービスを起動中…',
      );
      expect(
        state
            .copyWith(message: null)
            .messageFor(lookupAppLocalizations(defaultAppLocale)),
        isNull,
      );
      final transfer = P2pSnapshotTransferState(errorMessage: text);
      expect(
        transfer.errorMessageFor(lookupAppLocalizations(const Locale('en'))),
        'Starting local service…',
      );
    },
  );

  testWidgets(
    'an existing connection status changes language without a new event',
    (tester) async {
      final state = P2pSyncState(
        message: LocalizedUiText((l10n, _) => l10n.p2pStartingLocalService),
      );
      final locale = ValueNotifier(defaultAppLocale);
      addTearDown(locale.dispose);
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, value, __) => MaterialApp(
            locale: value,
            supportedLocales: supportedAppLocales,
            localizationsDelegates: AppLocalization.delegates,
            home: Builder(
              builder: (context) => Text(state.messageFor(context.l10n)!),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('正在開啟本機服務…'), findsOneWidget);
      locale.value = const Locale('en');
      await tester.pumpAndSettle();
      expect(find.text('Starting local service…'), findsOneWidget);
      locale.value = const Locale('ja');
      await tester.pumpAndSettle();
      expect(find.text('ローカルサービスを起動中…'), findsOneWidget);
    },
  );
}
