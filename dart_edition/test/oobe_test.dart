import "dart:async";
import "package:monogatari_assistant/data/repositories/user_profile_repository.dart";

import "package:monogatari_assistant/data/repositories/storage_preferences_repository.dart";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:monogatari_assistant/bin/ui_library.dart";
import "package:monogatari_assistant/features/oobe/oobe_gate.dart";
import "package:monogatari_assistant/features/oobe/oobe_intro.dart";
import "package:monogatari_assistant/features/oobe/oobe_screen.dart";
import "package:monogatari_assistant/features/oobe/oobe_state.dart";
import "package:monogatari_assistant/models/navigation_style.dart";
import "package:monogatari_assistant/presentation/providers/global_state_providers.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:video_player/video_player.dart";
import "package:monogatari_assistant/l10n/app_locale.dart";

import "helpers/fake_intro_controller.dart";

final _next = find.byKey(const Key("oobe-next"));
final _back = find.byKey(const Key("oobe-back"));
final _workspace = find.byKey(const Key("workspace"));

Finder slider(String key) =>
    find.descendant(of: find.byKey(Key(key)), matching: find.byType(Slider));

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _changeSlider(
  WidgetTester tester,
  String key,
  double value,
) async {
  final finder = slider(key);
  await tester.ensureVisible(finder);
  tester.widget<Slider>(finder).onChanged!(value);
  await tester.pumpAndSettle();
}

Future<void> _advance(WidgetTester tester, [int count = 1]) async {
  for (var i = 0; i < count; i++) {
    await tester.tap(_next);
    await tester.pumpAndSettle();
  }
}

Future<void> _mountGate(
  WidgetTester tester, {
  OobeLaunchOptions options = const OobeLaunchOptions(),
  OobeRepository? repository,
  StoragePreferencesRepository? storage,
  VideoPlayerController Function()? introFactory,
}) async {
  final container = ProviderContainer(
    overrides: [
      oobeIntroControllerFactoryProvider.overrideWithValue(
        introFactory ?? () => FakeIntroController(failInitialization: true),
      ),
      if (storage != null)
        storagePreferencesRepositoryProvider.overrideWithValue(storage),
      if (repository != null)
        oobeRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  await container.read(appInitializationProvider.future);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: OobeGate(
          options: options,
          builder: (_) => const Scaffold(key: Key("workspace")),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _FailOnceRepository extends OobeRepository {
  var attempts = 0;

  @override
  Future<void> complete() async {
    if (++attempts == 1) throw StateError("storage unavailable");
    await super.complete();
  }
}

class _DirectoryRepository extends StoragePreferencesRepository {
  String? next = "/tmp/backups";

  @override
  bool get supportsDirectorySelection => true;

  @override
  Future<String?> pickDirectory({
    required String title,
    String? initialDirectory,
  }) async => next;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets(
    "first use plays the intro before revealing setup without completing it",
    (tester) async {
      final player = FakeIntroController();
      await _mountGate(tester, introFactory: () => player);
      expect(find.byKey(const Key("oobe-intro-white-fill")), findsOneWidget);
      expect(player.playCount, 1);
      player.advance(const Duration(milliseconds: 2550));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byKey(const Key("oobe-intro-white-fill")), findsNothing);
      expect(find.byType(OobeScreen), findsOneWidget);
      expect(
        (await SharedPreferences.getInstance()).getBool(
          OobeRepository.completionKey,
        ),
        isNull,
      );
    },
  );

  test("startup flags, existing completion and bypass precedence", () {
    for (final completed in [false, true]) {
      for (final force in [false, true]) {
        for (final bypass in [false, true]) {
          final options = OobeLaunchOptions.parse([
            if (force) "--oobe/force",
            if (bypass) "--oobe/bypass",
            "/tmp/story.mnproj",
          ]);
          expect(
            options.shouldShow(completed: completed),
            !bypass && (force || !completed),
          );
        }
      }
    }
    expect(OobeLaunchOptions.parse(["--oobe=no"]).force, isFalse);
  });

  testWidgets("first launch waits for setup and persists settings at finish", (
    tester,
  ) async {
    await _mountGate(tester);
    expect(_workspace, findsNothing);
    expect(find.text("ヤッホー！歡迎使用 MonoAshi"), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(OobeRepository.completionKey), isNull);

    await _advance(tester);
    await tester.tap(find.byKey(const Key("settings-mode-oobe-theme-dark")));
    await _changeSlider(tester, "oobe-font-size", 18);
    await _tapVisible(tester, find.byKey(const Key("oobe-color-Purple")));
    await _tapVisible(
      tester,
      find.byKey(const Key("oobe-color-preset-bisexual")),
    );
    expect(find.text("除了使用這個主題外，你還可以做什麼……"), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const Key("settings-mode-oobe-navigation-railTooltip")),
    );
    await tester.tap(
      find.byKey(const Key("settings-mode-oobe-navigation-railTooltip")),
    );
    await _tapVisible(
      tester,
      find.byKey(const Key("settings-mode-oobe-toolbar-concise")),
    );
    await _advance(tester);
    await _tapVisible(tester, find.byKey(const Key("oobe-auto-save-switch")));
    await _changeSlider(tester, "oobe-auto-save-interval", 12);
    await _tapVisible(tester, find.byKey(const Key("oobe-auto-backup-switch")));
    await _changeSlider(tester, "oobe-auto-backup-interval", 23);

    await tester.tap(_back);
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(slider("oobe-font-size")).value, 18);
    expect(prefs.getBool("auto_save_enabled"), isNull);
    expect(prefs.getInt("app_theme_mode"), isNull);
    expect(prefs.getString("toolbar_mode"), isNull);
    await _advance(tester, 4);
    expect(find.text("主題：深色"), findsOneWidget);
    expect(find.text("自動備份：每 23 分鐘"), findsOneWidget);
    expect(find.text("Ribbon 模式：Concise"), findsOneWidget);
    await _advance(tester);

    expect(_workspace, findsOneWidget);
    expect(prefs.getBool(OobeRepository.completionKey), isTrue);
    expect(prefs.getInt("app_theme_mode"), AppThemeMode.dark.index);
    expect(prefs.getDouble("app_font_size"), 18);
    expect(prefs.getInt("app_theme_color"), Colors.purple.toARGB32());
    expect(prefs.getString("app_theme_preset"), "bisexual");
    expect(prefs.getInt("auto_save_interval_minutes"), 12);
    expect(prefs.getInt("auto_backup_interval_minutes"), 23);
    expect(
      prefs.getString("navigation_style"),
      NavigationStyle.railTooltip.name,
    );
    expect(prefs.getBool("auto_save_enabled"), isTrue);
    expect(prefs.getBool("auto_backup_enabled"), isTrue);
    expect(prefs.getString("toolbar_mode"), "concise");
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    "completed setup enters workspace; --oobe/force reopens with saved preferences",
    (tester) async {
      SharedPreferences.setMockInitialValues({
        OobeRepository.completionKey: true,
        "app_font_size": 20.0,
        "auto_save_interval_minutes": 13,
        "auto_backup_interval_minutes": 17,
        "toolbar_mode": "moderate",
      });
      await _mountGate(tester);
      expect(_workspace, findsOneWidget);
      expect(find.byType(OobeIntro), findsNothing);
      await tester.pumpWidget(const SizedBox());
      await _mountGate(
        tester,
        options: OobeLaunchOptions.parse(["--oobe/force"]),
      );
      expect(_workspace, findsNothing);
      await _advance(tester);
      expect(tester.widget<Slider>(slider("oobe-font-size")).value, 20);
      await _advance(tester);
      expect(find.textContaining("每 13 分鐘"), findsOneWidget);
      expect(find.textContaining("每 17 分鐘"), findsOneWidget);
      await _advance(tester, 3);
      expect(find.text("Ribbon 模式：Moderate"), findsOneWidget);
      await _advance(tester);
      expect(_workspace, findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt("auto_save_interval_minutes"), 13);
      expect(prefs.getInt("auto_backup_interval_minutes"), 17);
      expect(prefs.getString("toolbar_mode"), "moderate");
    },
  );

  testWidgets(
    "Ribbon can return to automatic and retain the choice through other edits",
    (tester) async {
      SharedPreferences.setMockInitialValues({"toolbar_mode": "full"});
      await _mountGate(tester);
      await _advance(tester);
      for (final mode in ["moderate", "concise", "automatic"]) {
        await _tapVisible(
          tester,
          find.byKey(Key("settings-mode-oobe-toolbar-$mode")),
        );
      }
      await _changeSlider(tester, "oobe-font-size", 18);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString("toolbar_mode"), "full");
      await _advance(tester, 4);
      expect(find.textContaining("Ribbon 模式：自動"), findsOneWidget);
      await _advance(tester);
      expect(_workspace, findsOneWidget);
      expect(prefs.getString("toolbar_mode"), isNull);
    },
  );

  testWidgets(
    "--oobe/bypass enters workspace without marking first use complete",
    (tester) async {
      await _mountGate(
        tester,
        options: OobeLaunchOptions.parse(["--oobe/force", "--oobe/bypass"]),
      );
      expect(_workspace, findsOneWidget);
      expect(find.byType(OobeIntro), findsNothing);
      expect(
        (await SharedPreferences.getInstance()).getBool(
          OobeRepository.completionKey,
        ),
        isNull,
      );
      await tester.pumpWidget(const SizedBox());
      await _mountGate(tester);
      expect(find.byType(OobeScreen), findsOneWidget);
      expect(_workspace, findsNothing);
    },
  );

  testWidgets("failed completion keeps setup open and permits retry", (
    tester,
  ) async {
    final repository = _FailOnceRepository();
    await _mountGate(tester, repository: repository);
    await _advance(tester, 6);
    expect(_workspace, findsNothing);
    expect(find.text("設定尚未儲存完成。請再試一次。"), findsOneWidget);
    expect(
      (await SharedPreferences.getInstance()).getBool(
        OobeRepository.completionKey,
      ),
      isNull,
    );
    await _advance(tester);
    expect(_workspace, findsOneWidget);
    expect(repository.attempts, 2);
  });

  testWidgets("saving disables navigation and duplicate completion", (
    tester,
  ) async {
    final completer = Completer<void>();
    var calls = 0;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: OobeScreen(
            initialPreferences: const OobePreferences(),
            onComplete: (_) {
              calls++;
              return completer.future;
            },
          ),
        ),
      ),
    );
    await _advance(tester, 5);
    await tester.tap(_next);
    await tester.pump();
    expect(tester.widget<FilledButton>(_next).onPressed, isNull);
    expect(tester.widget<TextButton>(_back).onPressed, isNull);
    expect(calls, 1);
    completer.complete();
    await tester.pumpAndSettle();
  });

  testWidgets("logo and active language menu are present on welcome", (
    tester,
  ) async {
    await _mountGate(tester);
    final image = tester.widget<Image>(
      find.byKey(const Key("oobe-title-image")),
    );
    expect((image.image as AssetImage).assetName, "assets/icon/Title.png");
    expect(
      tester
          .widget<DropdownButtonFormField<AppLocalePreference>>(
            find.byKey(const Key("oobe-language")),
          )
          .onChanged,
      isNotNull,
    );
    expect(find.text('立即套用並自動儲存。部分功能仍顯示繁體中文。'), findsOneWidget);
  });

  testWidgets("switches disable sliders while retaining intervals", (
    tester,
  ) async {
    await _mountGate(tester);
    await _advance(tester, 2);
    for (final (switchKey, sliderKey) in [
      ("oobe-auto-save-switch", "oobe-auto-save-interval"),
      ("oobe-auto-backup-switch", "oobe-auto-backup-interval"),
    ]) {
      expect(tester.widget<Slider>(slider(sliderKey)).onChanged, isNull);
      await _tapVisible(tester, find.byKey(Key(switchKey)));
      await _changeSlider(tester, sliderKey, 21);
      await _tapVisible(tester, find.byKey(Key(switchKey)));
      expect(tester.widget<Slider>(slider(sliderKey)).onChanged, isNull);
      expect(tester.widget<Slider>(slider(sliderKey)).value, 21);
      await _tapVisible(tester, find.byKey(Key(switchKey)));
      expect(tester.widget<Slider>(slider(sliderKey)).value, 21);
    }
  });

  testWidgets(
    "theme, color and font changes apply immediately without persisting",
    (tester) async {
      await _mountGate(tester);
      ThemeData currentTheme() =>
          Theme.of(tester.element(find.byKey(const Key("oobe-screen"))));
      await _advance(tester);
      await _tapVisible(
        tester,
        find.byKey(const Key("settings-mode-oobe-theme-dark")),
      );
      expect(currentTheme().brightness, Brightness.dark);
      await _tapVisible(tester, find.byKey(const Key("oobe-color-Green")));
      expect(
        currentTheme().colorScheme.primary,
        AppTheme.getDarkTheme(14, Colors.green).colorScheme.primary,
      );
      await _changeSlider(tester, "oobe-font-size", 20);
      expect(
        currentTheme().textTheme.bodyMedium!.fontSize,
        AppTheme.getDarkTheme(20, Colors.green).textTheme.bodyMedium!.fontSize,
      );
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt("app_theme_mode"), isNull);
      expect(prefs.getInt("app_theme_color"), isNull);
      await _tapVisible(
        tester,
        find.byKey(const Key("settings-mode-oobe-theme-light")),
      );
      expect(currentTheme().brightness, Brightness.light);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    "system theme follows platform brightness while OOBE remains open",
    (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await _mountGate(tester);
      expect(
        Theme.of(
          tester.element(find.byKey(const Key("oobe-screen"))),
        ).brightness,
        Brightness.dark,
      );
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pumpAndSettle();
      expect(
        Theme.of(
          tester.element(find.byKey(const Key("oobe-screen"))),
        ).brightness,
        Brightness.light,
      );
    },
  );

  testWidgets(
    "one backup directory choice supports selection, cancellation and reset before finishing",
    (tester) async {
      final storage = _DirectoryRepository();
      await _mountGate(tester, storage: storage);
      await _advance(tester, 2);
      final select = find.byKey(const Key("oobe-select-backup-directory"));
      expect(select, findsOneWidget);
      expect(find.byKey(const Key("oobe-backup-directory")), findsOneWidget);
      await _tapVisible(tester, select);
      expect(find.text("/tmp/backups"), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(StoragePreferencesRepository.backupDirectoryKey),
        isNull,
      );
      storage.next = null;
      await _tapVisible(tester, select);
      expect(find.text("/tmp/backups"), findsOneWidget);
      await _tapVisible(
        tester,
        find.byKey(const Key("oobe-reset-backup-directory")),
      );
      expect(find.text("/tmp/backups"), findsNothing);
      expect(find.text("使用預設備份資料夾"), findsOneWidget);
      storage.next = "/tmp/new-backups";
      await _tapVisible(tester, select);
      await _advance(tester, 4);
      expect(_workspace, findsOneWidget);
      expect(
        prefs.getString(StoragePreferencesRepository.backupDirectoryKey),
        "/tmp/new-backups",
      );
    },
  );

  testWidgets(
    "name and default pen name are optional drafts until setup finishes",
    (tester) async {
      await _mountGate(tester);
      await _advance(tester, 3);
      expect(find.text("名稱設定"), findsWidgets);
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const Key("oobe-default-pen-name")),
            )
            .onChanged,
        isNull,
      );
      await tester.enterText(
        find.byKey(const Key("oobe-display-name")),
        "  Heyairu  ",
      );
      await _tapVisible(tester, find.byKey(const Key("oobe-default-pen-name")));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(UserProfileRepository.displayNameKey), isNull);
      await _advance(tester, 2);
      expect(find.text("名稱：Heyairu"), findsOneWidget);
      expect(find.text("作為預設筆名：是"), findsOneWidget);
      await _advance(tester);
      expect(_workspace, findsOneWidget);
      expect(prefs.getString(UserProfileRepository.displayNameKey), "Heyairu");
      expect(prefs.getBool(UserProfileRepository.defaultPenNameKey), isTrue);
    },
  );

  testWidgets(
    "skipping name settings keeps the saved profile and discards draft edits",
    (tester) async {
      SharedPreferences.setMockInitialValues({
        UserProfileRepository.displayNameKey: "Saved Name",
        UserProfileRepository.defaultPenNameKey: true,
      });
      await _mountGate(tester);
      await _advance(tester, 3);
      expect(find.text("Saved Name"), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key("oobe-display-name")),
        "Draft Name",
      );
      await _tapVisible(tester, find.byKey(const Key("oobe-default-pen-name")));
      await tester.tap(find.byKey(const Key("oobe-skip-name")));
      await tester.pumpAndSettle();
      await tester.tap(_back);
      await tester.pumpAndSettle();
      expect(find.text("Saved Name"), findsOneWidget);
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const Key("oobe-default-pen-name")),
            )
            .value,
        isTrue,
      );
      await _advance(tester, 3);
      expect(_workspace, findsOneWidget);
      final profile = await UserProfileRepository().load();
      expect(profile.displayName, "Saved Name");
      expect(profile.defaultPenName, "Saved Name");
    },
  );

  testWidgets("first use can skip name settings without a default pen name", (
    tester,
  ) async {
    await _mountGate(tester);
    await _advance(tester, 3);
    await tester.tap(find.byKey(const Key("oobe-skip-name")));
    await tester.pumpAndSettle();
    await _advance(tester, 2);
    expect(_workspace, findsOneWidget);
    final profile = await UserProfileRepository().load();
    expect(profile.displayName, isEmpty);
    expect(profile.defaultPenName, isEmpty);
    expect(profile.useAsDefaultPenName, isFalse);
  });

  testWidgets("name entry keeps actions visible above the landscape keyboard", (
    tester,
  ) async {
    tester.view.physicalSize = const Size(568, 320);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await _mountGate(tester);
    await _advance(tester, 3);
    await _tapVisible(tester, find.byKey(const Key("oobe-display-name")));
    tester.view.viewInsets = const FakeViewPadding(bottom: 160);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.getBottomRight(_next).dy, lessThanOrEqualTo(160));
    expect(find.byKey(const Key("oobe-skip-name")), findsOneWidget);
  });

  for (final (size, scale, fontSize) in [
    (const Size(1092, 818), 1.0, 14.0),
    (const Size(800, 600), 1.0, 14.0),
    (const Size(390, 844), 1.0, 14.0),
    (const Size(568, 320), 1.0, 14.0),
    (const Size(390, 844), 2.0, 14.0),
    (const Size(390, 844), 2.0, 20.0),
    (const Size(800, 600), 2.0, 20.0),
  ]) {
    testWidgets("all steps fit $size at text scale $scale and font $fontSize", (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: OobeScreen(
              initialPreferences: OobePreferences(
                fontSize: fontSize,
                themeMode: AppThemeMode.dark,
              ),
              onComplete: (_) async {},
            ),
          ),
        ),
      );
      for (var i = 0; i < 6; i++) {
        expect(tester.takeException(), isNull);
        expect(tester.getBottomRight(_next).dy, lessThanOrEqualTo(size.height));
        if (i < 5) await _advance(tester);
      }
    });
  }
}
