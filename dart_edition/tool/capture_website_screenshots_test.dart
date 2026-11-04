// Render the production workspace with an isolated, fictional showcase project.
// Run from dart_edition:
// flutter test tool/capture_website_screenshots_test.dart --reporter expanded
// No desktop window, user preferences, or personal manuscript is accessed.
import "dart:io";
import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:monogatari_assistant/bin/content.dart";
import "package:monogatari_assistant/bin/settings_manager.dart";
import "package:monogatari_assistant/bin/slidebar.dart";
import "package:monogatari_assistant/bin/ui_library.dart";
import "package:monogatari_assistant/features/help/help_controller.dart";
import "package:monogatari_assistant/l10n/app_localization.dart";
import "package:monogatari_assistant/l10n/app_locale.dart";
import "package:monogatari_assistant/main.dart";
import "package:monogatari_assistant/models/base_info_data.dart";
import "package:monogatari_assistant/models/chapter_selection_data.dart";
import "package:monogatari_assistant/models/character_data.dart";
import "package:monogatari_assistant/models/outline_data.dart";
import "package:monogatari_assistant/models/project_data.dart";
import "package:monogatari_assistant/models/project_file.dart";
import "package:monogatari_assistant/models/timeline_data.dart";
import "package:monogatari_assistant/models/world_settings_data.dart";
import "package:monogatari_assistant/presentation/providers/editor_coordinator_provider.dart";
import "package:monogatari_assistant/presentation/providers/global_state_providers.dart";
import "package:monogatari_assistant/presentation/providers/project_state_providers.dart";

const _boundary = ValueKey("website-capture");
const _story = """第一章　風的名字

海風越過山丘，把遠方的消息帶進了小鎮。

朝霧澪站在燈塔下，攤開那封沒有署名的信。信紙的邊角微微泛黃，像一片被秋天遺忘的葉子。她認得信封上的星紋，卻想不起曾在哪裡見過。

「如果你也聽見了，」她輕聲讀著，「就沿著星光，來找我吧。」

遠處，漁船的燈火一盞接著一盞亮起。澪把信紙折好，收進外套的口袋。她知道，從明天開始，日子會和從前不一樣。

「又在等風？」

結城律沿著石階走上來，手裡拿著一本攤開的航海筆記。筆記的最後一頁，畫著一座不在任何地圖上的島。

澪沒有回答。她只是指向天邊，那顆比往常更亮的星。

他們曾經約定，有一天要離開星見町，去看看海的另一邊。如今，那封來信替這個約定寫下了日期。

那是故事開始的地方。""";

ProjectData showcaseProject() {
  final events = <StoryEventData>[
    for (final (index, name) in ["燈塔下的來信", "沿著星光啟程", "抵達星之島", "群星的回音"].indexed)
      StoryEventData(
        storyEventUUID: "event-$index",
        storyEvent: name,
        scenes: [
          SceneData(
            sceneUUID: "scene-$index",
            sceneName: name,
            location: index < 2 ? "town" : "island",
            people: ["mio", "ritsu"],
            memo: [
              "沒有署名的信，讓平靜的日常起了波瀾。",
              "澪與律踏上尋找星光的旅途。",
              "一座不在地圖上的島。",
              "所有故事線在燈塔下再次相遇。",
            ][index],
          ),
        ],
      ),
  ];
  return ProjectData.empty(projectUUID: "5cf4ef2a-0800-4000-8000-000000000001")
    ..baseInfoData = const BaseInfoData(
      bookName: "星海之間",
      author: "Monogatari Assistant",
      storyType: "奇幻・成長",
      intro: "一封沒有署名的信，與一場沿著星光前進的旅程。",
      tags: ["海邊小鎮", "少年少女", "星光", "成長"],
    )
    ..segmentsData = [
      SegmentData(
        segmentUUID: "volume-one",
        segmentName: "第一卷・潮汐的來信",
        chapters: [
          ChapterData(
            chapterUUID: "chapter-one",
            chapterName: "第一章　風的名字",
            chapterContent: _story,
          ),
          ChapterData(
            chapterUUID: "chapter-two",
            chapterName: "第二章　未寄出的信",
            chapterContent: "律在航海筆記裡，找到那枚熟悉的星紋。",
          ),
          ChapterData(
            chapterUUID: "chapter-three",
            chapterName: "第三章　沿著星光",
            chapterContent: "天亮以前，他們已經來到港口。",
          ),
        ],
      ),
      SegmentData(
        segmentUUID: "volume-two",
        segmentName: "第二卷・群星的回音",
        chapters: [
          ChapterData(
            chapterUUID: "chapter-four",
            chapterName: "第四章　星之島",
            chapterContent: "島嶼的北岸，矗立著另一座燈塔。",
          ),
        ],
      ),
    ]
    ..characterData = {
      "mio": const CharacterEntryData(
        characterId: "mio",
        legacyFields: {"nanoId": "ShowMio1"},
        displayName: "朝霧 澪",
        characterType: "protagonist",
        roleOrOccupation: "燈塔的守望者",
        appearanceSummary: "深色短髮，總是穿著一件舊外套。",
        personalitySummary: "好奇、溫柔，對未知的世界抱著期待。",
        goal: "找出來信的人，看看海的另一邊。",
        motivation: "她相信風裡的聲音，來自遠方的某個人。",
        speechStyle: "輕聲說話，總是認真聽完別人的故事。",
        notes: "「總有一束光，會為你亮著。」",
        relationships: [
          CharacterRelationship(person: "ritsu", relationship: "童年好友"),
        ],
      ),
      "ritsu": const CharacterEntryData(
        characterId: "ritsu",
        legacyFields: {"nanoId": "ShowRit1"},
        displayName: "結城 律",
        characterType: "majorSupporting",
        roleOrOccupation: "追逐星光的旅人",
        personalitySummary: "沉著、細心，隨身攜帶航海筆記。",
        goal: "找到星之島，補完父親的航海地圖。",
        relationships: [
          CharacterRelationship(person: "mio", relationship: "童年好友"),
        ],
      ),
    }
    ..worldSettingsData = [
      LocationData(
        id: "town",
        localName: "星見町",
        localType: "海邊小鎮",
        note: "每當夜幕降臨，港口就會亮起與星光相連的燈火。",
        child: [
          LocationData(
            id: "lighthouse",
            localName: "舊燈塔",
            localType: "建築",
            note: "澪守望海面的地方，也是那封來信抵達的地方。",
          ),
        ],
      ),
      LocationData(
        id: "island",
        localName: "星之島",
        localType: "島嶼",
        note: "一座不在任何航海地圖上的島。",
      ),
    ]
    ..outlineData = [
      StorylineData(
        chapterUUID: "main-story",
        storylineName: "潮汐的來信",
        storylineType: "主線",
        scenes: events,
        memo: "從第一封信，到燈塔下的重逢。",
      ),
    ]
    ..timelineDocument = TimelineDocumentData(
      tracks: const [
        TimelineTrackData(trackUUID: "mio-track", name: "澪的旅程"),
        TimelineTrackData(trackUUID: "ritsu-track", name: "律的航海筆記", order: 1),
      ],
      placements: [
        for (var index = 0; index < events.length; index++)
          TimelinePlacementData(
            placementUUID: "place-$index",
            trackUUID: "mio-track",
            storylineUUID: "main-story",
            eventUUID: "event-$index",
            sceneUUID: "scene-$index",
            startTick: index * 3,
            durationTicks: 2,
            label: events[index].storyEvent,
          ),
        const TimelinePlacementData(
          placementUUID: "ritsu-place",
          trackUUID: "ritsu-track",
          startTick: 2,
          durationTicks: 7,
          label: "尋找星紋的線索",
        ),
      ],
    );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final family in ["NotoSans", "NotoSansTC"]) {
      final loader = FontLoader(family)
        ..addFont(
          Future.value(
            ByteData.sublistView(
              File("assets/fonts/$family-Variable.ttf").readAsBytesSync(),
            ),
          ),
        );
      await loader.load();
    }
    final icons = FontLoader("MaterialIcons")
      ..addFont(
        Future.value(
          ByteData.sublistView(
            File(
              Platform.environment["FLUTTER_ROOT"] != null
                  ? "${Platform.environment["FLUTTER_ROOT"]}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf"
                  : "${File(Platform.resolvedExecutable).parent.parent.parent.parent.path}/artifacts/material_fonts/MaterialIcons-Regular.otf",
            ).readAsBytesSync(),
          ),
        ),
      );
    await icons.load();
  });

  testWidgets("capture actual workspace for the product website", (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      "toolbar_mode": "full",
      "app_locale": "zh-Hant",
      "auto_save_enabled": false,
      "auto_backup_enabled": false,
    });
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel(
        "com.heyairu.monogatari_assistant/background_execution",
      ),
      (call) async => true,
    );
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel("plugins.it_nomads.com/flutter_secure_storage"),
      (call) async => null,
    );
    await tester.binding.setSurfaceSize(const Size(1600, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = ProviderContainer(
      overrides: [
        appThemeSettingsProvider.overrideWithValue(
          const AppThemeSettings(
            color: Color(0xFF009688),
            mode: AppThemeMode.light,
            fontSize: 16,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigator,
          locale: defaultAppLocale,
          supportedLocales: supportedAppLocales,
          localizationsDelegates: AppLocalization.delegates,
          theme: AppTheme.getLightTheme(
            16,
            const Color(0xFF009688),
            locale: defaultAppLocale,
          ),
          builder: (_, child) => RepaintBoundary(
            key: _boundary,
            child: AppHelpHost(navigatorKey: navigator, child: child!),
          ),
          home: const ContentView(),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 400)),
    );
    await tester.pump(const Duration(seconds: 1));
    final project = showcaseProject();
    final coordinator = container.read(editorCoordinatorProvider.notifier);
    coordinator.applyProjectData(
      data: project,
      initialState: coordinator.calculateInitialState(
        project,
        WordCountMode.characters,
      ),
    );
    container
        .read(currentProjectFileProvider.notifier)
        .setCurrentProjectFile(
          ProjectFile(fileName: "星海之間.mnproj", filePath: null, content: ""),
        );
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.text("儀表板").first);
    await tester.pump();
    final editor = tester.widget<EditorTextBox>(find.byType(EditorTextBox));
    editor.controller.text = _story;
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump(const Duration(seconds: 1));

    Future<void> chord(LogicalKeyboardKey key, {bool alt = false}) async {
      final modifier = alt
          ? LogicalKeyboardKey.altLeft
          : LogicalKeyboardKey.controlLeft;
      await tester.sendKeyDownEvent(modifier);
      await tester.sendKeyEvent(key);
      await tester.sendKeyUpEvent(modifier);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
    }

    Future<void> capture(String name) async {
      await tester.pump(const Duration(milliseconds: 500));
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(_boundary),
      );
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 1.5);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final output = File("../AppPreview/website/$name.png");
        await output.parent.create(recursive: true);
        await output.writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
      expect(
        tester.takeException(),
        isNull,
        reason: "A screenshot must contain a valid production layout.",
      );
    }

    await chord(LogicalKeyboardKey.digit2);
    await capture("writing");
    await tester.drag(
      find.byType(MonogatariResizeDivider),
      const Offset(320, 0),
    );
    await tester.pump();
    await chord(LogicalKeyboardKey.digit4);
    await tester.tap(find.text("朝霧 澪").first);
    await tester.pump(const Duration(milliseconds: 500));
    await capture("characters");
    await chord(LogicalKeyboardKey.digit5);
    await capture("world");
    await chord(LogicalKeyboardKey.digit6);
    await capture("timeline");
    // Timeline → characters → relationships → world → items → plans → glossary
    // → palettes → proofreading. Use the same module shortcut as the App.
    for (var step = 0; step < 8; step++) {
      await chord(LogicalKeyboardKey.arrowDown, alt: true);
    }
    await capture("proofreading");
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
