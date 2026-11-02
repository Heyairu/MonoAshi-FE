import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/content.dart';
import 'package:monogatari_assistant/bin/findreplace.dart';
import 'package:monogatari_assistant/bin/ui_library.dart';
import 'package:monogatari_assistant/data/repositories/settings_repository.dart';
import 'package:monogatari_assistant/features/oobe/oobe_screen.dart';
import 'package:monogatari_assistant/features/oobe/oobe_state.dart';
import 'package:monogatari_assistant/features/oobe/oobe_intro.dart';
import 'package:monogatari_assistant/l10n/app_localization.dart';
import 'package:monogatari_assistant/main.dart';
import 'package:monogatari_assistant/presentation/providers/global_state_providers.dart';
import 'package:monogatari_assistant/presentation/providers/locale_providers.dart';
import 'package:monogatari_assistant/presentation/providers/repository_providers.dart';
import 'package:monogatari_assistant/presentation/widgets/settings/app_language_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fake_intro_controller.dart';

class _LocaleHost extends ConsumerWidget {
  const _LocaleHost({required this.home});
  final Widget home;

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
    locale: ref.watch(appLocalePreferenceProvider).locale,
    supportedLocales: supportedAppLocales,
    localeListResolutionCallback: AppLocalization.resolve,
    localizationsDelegates: AppLocalization.delegates,
    theme: AppTheme.getLightTheme(
      14,
      Colors.blue,
      locale: ref.watch(resolvedAppLocaleProvider),
    ),
    home: home,
  );
}

class _FailOnceLocaleRepository extends SharedPreferencesSettingsRepository {
  bool fail = true;
  @override
  Future<void> saveAppLocale(AppLocalePreference value) async {
    if (fail) {
      fail = false;
      throw StateError('storage unavailable');
    }
    await super.saveAppLocale(value);
  }
}

Future<void> _mount(
  WidgetTester tester,
  ProviderContainer container,
  Widget home,
) async {
  await container.read(settingsStateProvider.future);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: _LocaleHost(home: home),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _chooseLanguage(
  WidgetTester tester,
  AppLocalePreference value, {
  String key = 'settings-language',
}) async {
  final field = find.byKey(Key(key));
  await tester.ensureVisible(field);
  await tester.tap(field);
  await tester.pumpAndSettle();
  final label = switch (value) {
    AppLocalePreference.traditionalChinese => '繁體中文',
    AppLocalePreference.english => 'English',
    AppLocalePreference.japanese => '日本語',
    AppLocalePreference.system => 'Follow system',
  };
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final locale in supportedAppLocales) {
    testWidgets(
      'localized OOBE welcome fits a narrow screen at 200% text scale: $locale',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        tester.binding.platformDispatcher.localesTestValue = [locale];
        addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
        final container = ProviderContainer();
        addTearDown(container.dispose);
        await _mount(
          tester,
          container,
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(2)),
              child: OobeScreen(
                initialPreferences: const OobePreferences(fontSize: 20),
                onComplete: (_) async {},
              ),
            ),
          ),
        );
        expect(find.byKey(const Key('oobe-language')), findsOneWidget);
        expect(tester.takeException(), isNull);
        expect(
          tester.getBottomRight(find.byKey(const Key('oobe-next'))).dy,
          lessThanOrEqualTo(844),
        );
      },
    );
  }

  testWidgets(
    'production MainApp switches OOBE without replacing the session',
    (tester) async {
      SharedPreferences.setMockInitialValues({'app_locale': 'en'});
      final container = ProviderContainer(
        overrides: [
          oobeIntroControllerFactoryProvider.overrideWithValue(
            () => FakeIntroController(failInitialization: true),
          ),
        ],
      );
      addTearDown(container.dispose);
      await container.read(appInitializationProvider.future);
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const MainApp()),
      );
      await tester.pumpAndSettle();
      final appState = tester.state(find.byType(MainApp));
      final setupState = tester.state(find.byType(OobeScreen));
      expect(find.text('Hello! Welcome to MonoAshi'), findsOneWidget);
      await _chooseLanguage(
        tester,
        AppLocalePreference.japanese,
        key: 'oobe-language',
      );
      expect(find.text('ヤッホー！ものアシへようこそ'), findsOneWidget);
      expect(tester.state(find.byType(MainApp)), same(appState));
      expect(tester.state(find.byType(OobeScreen)), same(setupState));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'production startup and failure branches install the same locale',
    (tester) async {
      SharedPreferences.setMockInitialValues({'app_locale': 'ja'});
      final pending = Completer<void>();
      final container = ProviderContainer(
        overrides: [
          appInitializationProvider.overrideWith((ref) => pending.future),
        ],
      );
      addTearDown(container.dispose);
      await container.read(settingsStateProvider.future);
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const MainApp()),
      );
      await tester.pump();
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.locale, const Locale('ja'));
      expect(app.theme!.textTheme.bodyMedium!.fontFamily, 'NotoSansJP');
      expect(
        app.theme!.textTheme.bodyMedium!.fontFamilyFallback,
        AppFonts.fallbacks(const Locale('ja')),
      );
      expect(app.localizationsDelegates, AppLocalization.delegates);
      pending.completeError(StateError('setup unavailable'));
      await tester.pumpAndSettle();
      expect(find.textContaining('初期化に失敗しました：'), findsOneWidget);
      final failureTheme = tester
          .widget<MaterialApp>(find.byType(MaterialApp))
          .theme!;
      expect(failureTheme.textTheme.bodyMedium!.fontFamily, 'NotoSansJP');
      expect(
        failureTheme.textTheme.bodyMedium!.fontFamilyFallback,
        AppFonts.fallbacks(const Locale('ja')),
      );
      expect(
        tester
            .widget<MaterialApp>(find.byType(MaterialApp))
            .localizationsDelegates,
        AppLocalization.delegates,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'system changes update both Flutter and provider locales; manual choice wins',
    (tester) async {
      tester.binding.platformDispatcher.localesTestValue = [
        const Locale('fr'),
        const Locale('ja', 'JP'),
      ];
      addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await _mount(
        tester,
        container,
        Builder(
          builder: (context) => Scaffold(
            body: Text(
              '${context.l10n.languageTitle}|${FlutterQuillLocalizations.of(context)!.copy}',
            ),
          ),
        ),
      );
      expect(find.text('表示言語|コピー'), findsOneWidget);
      expect(container.read(resolvedAppLocaleProvider), const Locale('ja'));
      tester.binding.platformDispatcher.localesTestValue = [
        const Locale('en', 'GB'),
      ];
      await tester.pumpAndSettle();
      expect(find.text('Display language|Copy'), findsOneWidget);
      await container
          .read(settingsStateProvider.notifier)
          .setAppLocale(AppLocalePreference.traditionalChinese);
      await tester.pumpAndSettle();
      expect(find.text('顯示語言|複製'), findsOneWidget);
      tester.binding.platformDispatcher.localesTestValue = [const Locale('ja')];
      await tester.pumpAndSettle();
      expect(find.text('顯示語言|複製'), findsOneWidget);
      expect(container.read(resolvedAppLocaleProvider), defaultAppLocale);
      await container
          .read(settingsStateProvider.notifier)
          .setAppLocale(AppLocalePreference.system);
      await tester.pumpAndSettle();
      expect(find.text('表示言語|コピー'), findsOneWidget);
    },
  );

  testWidgets(
    'language menu persists, rolls back with localized error, and can retry',
    (tester) async {
      SharedPreferences.setMockInitialValues({'app_locale': 'en'});
      final container = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            _FailOnceLocaleRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);
      await _mount(
        tester,
        container,
        const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(24),
            child: AppLanguageSelector(),
          ),
        ),
      );
      await _chooseLanguage(tester, AppLocalePreference.japanese);
      expect(
        container.read(settingsStateProvider).requireValue.appLocale,
        AppLocalePreference.english,
      );
      expect(
        find.textContaining('Could not save the language.'),
        findsOneWidget,
      );
      expect(
        (await SharedPreferences.getInstance()).getString('app_locale'),
        'en',
      );
      await _chooseLanguage(tester, AppLocalePreference.japanese);
      expect(find.text('表示言語'), findsOneWidget);
      expect(
        (await SharedPreferences.getInstance()).getString('app_locale'),
        'ja',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'OOBE language saves before completion and preserves the in-progress step',
    (tester) async {
      SharedPreferences.setMockInitialValues({'app_locale': 'zh-Hant'});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      var completed = false;
      await _mount(
        tester,
        container,
        OobeScreen(
          initialPreferences: const OobePreferences(),
          onComplete: (_) async {
            completed = true;
          },
        ),
      );
      final originalState = tester.state(find.byType(OobeScreen));
      await _chooseLanguage(
        tester,
        AppLocalePreference.english,
        key: 'oobe-language',
      );
      expect(find.text('Hello! Welcome to MonoAshi'), findsOneWidget);
      expect(tester.state(find.byType(OobeScreen)), same(originalState));
      expect(
        (await SharedPreferences.getInstance()).getString('app_locale'),
        'en',
      );
      expect(
        (await SharedPreferences.getInstance()).getBool('oobe_completed'),
        isNull,
      );
      expect(completed, false);
      await tester.tap(find.byKey(const Key('oobe-next')));
      await tester.pumpAndSettle();
      await container
          .read(settingsStateProvider.notifier)
          .setAppLocale(AppLocalePreference.japanese);
      await tester.pumpAndSettle();
      expect(find.text('テーマと操作の設定'), findsOneWidget);
      expect(tester.state(find.byType(OobeScreen)), same(originalState));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'switching locale preserves the live Quill controller, draft, focus, selection and undo',
    (tester) async {
      SharedPreferences.setMockInitialValues({'app_locale': 'zh-Hant'});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final source = HighlightTextEditingController(text: '未儲存草稿');
      final focus = FocusNode();
      addTearDown(source.dispose);
      addTearDown(focus.dispose);
      await _mount(
        tester,
        container,
        Scaffold(
          body: EditorTextBox(controller: source, focusNode: focus),
        ),
      );
      final editorFinder = find.byKey(
        const ValueKey<String>('plain-text-quill-editor'),
      );
      final editorState = tester.state(editorFinder);
      final quill = tester.widget<QuillEditor>(editorFinder).controller;
      focus.requestFocus();
      quill.replaceText(0, 0, '追加', const TextSelection.collapsed(offset: 2));
      await tester.pump();
      final before = source.value;
      final selection = quill.selection;
      expect(quill.hasUndo, isTrue);
      for (final preference in [
        AppLocalePreference.english,
        AppLocalePreference.japanese,
      ]) {
        await container
            .read(settingsStateProvider.notifier)
            .setAppLocale(preference);
        await tester.pumpAndSettle();
        expect(tester.state(editorFinder), same(editorState));
        expect(
          tester.widget<QuillEditor>(editorFinder).controller,
          same(quill),
        );
        expect(source.value, before);
        expect(quill.selection, selection);
        expect(quill.hasUndo, isTrue);
        expect(focus.hasFocus, isTrue);
      }
      quill.undo();
      await tester.pump();
      expect(source.text, '未儲存草稿');
      expect(quill.hasRedo, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'an open dialog keeps its draft and navigator while its text changes',
    (tester) async {
      SharedPreferences.setMockInitialValues({'app_locale': 'en'});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final draft = TextEditingController(text: 'dialog draft');
      addTearDown(draft.dispose);
      await _mount(
        tester,
        container,
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(context.l10n.languageTitle),
                    content: TextField(
                      key: const Key('dialog-draft'),
                      controller: draft,
                    ),
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      await container
          .read(settingsStateProvider.notifier)
          .setAppLocale(AppLocalePreference.japanese);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('dialog-draft')), findsOneWidget);
      expect(find.text('表示言語'), findsOneWidget);
      expect(draft.text, 'dialog draft');
      expect(
        tester.state<NavigatorState>(find.byType(Navigator).first),
        same(navigator),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('active IME composing range survives a locale switch', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'app_locale': 'zh-Hant'});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final source = HighlightTextEditingController(text: '草稿');
    final focus = FocusNode();
    addTearDown(source.dispose);
    addTearDown(focus.dispose);
    await _mount(
      tester,
      container,
      Scaffold(
        body: EditorTextBox(controller: source, focusNode: focus),
      ),
    );
    focus.requestFocus();
    await tester.pump();
    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '草稿かな\n',
        selection: TextSelection.collapsed(offset: 4),
        composing: TextRange(start: 2, end: 4),
      ),
    );
    await tester.pump();
    // Quill deliberately sends (-1, -1) back to the platform even while it
    // retains an active composing range. Assert its actual input-client state.
    final input = tester.state<QuillRawEditorState>(
      find.byType(QuillRawEditor),
    );
    expect(input.composingRange.value, const TextRange(start: 2, end: 4));
    final sourceBefore = source.value;
    await container
        .read(settingsStateProvider.notifier)
        .setAppLocale(AppLocalePreference.japanese);
    await tester.pumpAndSettle();
    expect(source.value, sourceBefore);
    expect(
      tester.state<QuillRawEditorState>(find.byType(QuillRawEditor)),
      same(input),
    );
    expect(input.composingRange.value, const TextRange(start: 2, end: 4));
    expect(focus.hasFocus, isTrue);
    expect(tester.takeException(), isNull);
    // Commit the composition before disposing the fixture: Quill's teardown
    // otherwise notifies its composing listener after the element is defunct.
    tester.testTextInput.updateEditingValue(
      const TextEditingValue(
        text: '草稿かな\n',
        selection: TextSelection.collapsed(offset: 4),
      ),
    );
    await tester.pump();
    focus.unfocus();
    await tester.pump();
  });
}
