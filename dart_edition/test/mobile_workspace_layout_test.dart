import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_quill/flutter_quill.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:monogatari_assistant/bin/content.dart";
import "package:monogatari_assistant/bin/slidebar.dart";
import "package:monogatari_assistant/bin/statusbar.dart";
import "package:monogatari_assistant/bin/ui_library.dart";
import "package:monogatari_assistant/main.dart";
import "package:monogatari_assistant/presentation/widgets/radial_gauge_dashboard.dart";
import "package:monogatari_assistant/presentation/providers/gauge_dashboard_provider.dart";
import "package:monogatari_assistant/ui_library/mobile_editor_insets.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  testWidgets(
    "mobile floating navigation and dashboard preserve the manuscript",
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel(
          "com.heyairu.monogatari_assistant/background_execution",
        ),
        (_) async => true,
      );
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.getLightTheme(12, Colors.lightBlue),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
            home: const ContentView(),
          ),
        ),
      );
      Future<void> settle() async {
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await tester.pump();
      }

      await settle();
      expect(find.byType(NavigationBar), findsNothing);
      final navigation = find.byKey(const Key("mobile-navigation-button"));
      final dashboard = find.byKey(const Key("mobile-dashboard-button"));
      expect(tester.getSize(navigation), const Size(64, 64));
      expect(tester.getRect(navigation).left, 32);
      expect(tester.getRect(dashboard).right, 358);
      expect(tester.getRect(navigation).top, tester.getRect(dashboard).top);
      expect(
        tester.getRect(find.byKey(const Key("mobile-module-pages"))).bottom,
        tester.getRect(find.byType(MonogatariStatusBar)).top,
      );

      expect(
        tester.getRect(find.byKey(const Key('mobile-module-pages'))).top,
        tester.getRect(find.byType(MonogatariNavigationLayout)).top,
      );
      final homeScroll = find
          .descendant(
            of: find.byType(AppPageScrollView),
            matching: find.byType(SingleChildScrollView),
          )
          .first;
      final homeContent = tester
          .widget<SingleChildScrollView>(homeScroll)
          .child!;
      final homePosition = tester
          .state<ScrollableState>(
            find
                .descendant(of: homeScroll, matching: find.byType(Scrollable))
                .first,
          )
          .position;
      expect(homePosition.maxScrollExtent, greaterThan(0));
      homePosition.jumpTo(homePosition.maxScrollExtent);
      await settle();
      expect(
        tester.getRect(find.byWidget(homeContent)).bottom,
        lessThan(tester.getRect(navigation).top),
      );
      expect(
        tester.getRect(homeScroll).bottom,
        tester.getRect(find.byKey(const Key('mobile-module-pages'))).bottom,
      );

      final preview = find.descendant(
        of: dashboard,
        matching: find.byType(CompactRadialGauge),
      );
      expect(preview, findsOneWidget);
      expect(
        tester.widget<FloatingActionButton>(navigation).backgroundColor,
        Theme.of(
          tester.element(navigation),
        ).colorScheme.surfaceContainerHighest,
      );
      expect(
        tester.widget<FloatingActionButton>(dashboard).backgroundColor,
        Theme.of(
          tester.element(navigation),
        ).colorScheme.surfaceContainerHighest,
      );
      expect(tester.widget<FloatingActionButton>(navigation).elevation, 0);
      expect(tester.widget<FloatingActionButton>(dashboard).elevation, 0);
      expect(
        tester
            .widget<Icon>(
              find.descendant(of: navigation, matching: find.byType(Icon)),
            )
            .size,
        24,
      );
      expect(find.text("每日目標"), findsNothing);
      final dashboardSettings = container.read(gaugeDashboardProvider.notifier);
      dashboardSettings.setVisible(DashboardMetric.dailyWords, false);
      await settle();
      expect(
        tester.widget<CompactRadialGauge>(preview).targetValue,
        contains("2,000"),
      );
      dashboardSettings.setVisible(DashboardMetric.dailyWords, true);
      await settle();

      await tester.tap(navigation);
      await settle();
      final editorDestination = find.byKey(
        const Key("navigation-destination-17"),
      );
      expect(
        find.descendant(
          of: find.byKey(const Key("navigation-scroll-area")),
          matching: editorDestination,
        ),
        findsNothing,
      );
      expect(
        tester.getRect(editorDestination).top,
        greaterThan(
          tester.getRect(find.byKey(const Key("navigation-destination-0"))).top,
        ),
      );
      await tester.tap(editorDestination);
      await settle();
      expect(find.byType(EditorTextBox), findsOneWidget);
      final editorState = tester.state(find.byType(EditorTextBox));
      final quill = tester.widget<QuillEditor>(find.byType(QuillEditor));
      expect(
        quill.config.padding.resolve(TextDirection.ltr).bottom,
        MobileEditorInsets.bottomClearance,
      );
      final manuscript =
          "${List.filled(60, "這是用來檢查浮動按鈕留白的正文。").join("\n")}\n最後一行";
      quill.controller.replaceText(0, 0, manuscript, null);
      await settle();

      await tester.tap(dashboard);
      await settle();
      final capsule = find.byKey(const Key("mobile-dashboard-capsule"));
      expect(capsule, findsOneWidget);
      expect(find.byType(RadialGaugeDashboard), findsOneWidget);
      expect(
        tester
            .widget<Material>(
              find.byKey(const ValueKey("radial-gauge-dashboard")),
            )
            .shape,
        isA<StadiumBorder>(),
      );
      expect(dashboard, findsNothing);
      expect(find.byType(RadialGaugePreview), findsNothing);
      expect(tester.getRect(capsule).bottom, tester.getRect(navigation).bottom);
      final visibleMetrics = container.read(gaugeDashboardProvider).metrics;
      final renderedMetrics = find
          .byType(MenuAnchor)
          .evaluate()
          .map((element) => element.widget.key)
          .whereType<ValueKey<String>>()
          .map((key) => key.value)
          .where((key) => key.startsWith("gauge-"))
          .toList();
      expect(renderedMetrics, [
        for (final metric in visibleMetrics.reversed) "gauge-${metric.name}",
      ]);
      final close = find.byKey(const ValueKey("mobile-dashboard-close"));
      expect(close, findsOneWidget);
      final closeRect = tester.getRect(close);
      final scrollArea = find.byKey(const Key("gauge-dashboard-scroll-area"));
      final scrollView = tester.widget<SingleChildScrollView>(scrollArea);
      expect(scrollView.reverse, isTrue);
      final scroll = scrollView.controller!;
      final firstGauge = find.byKey(
        ValueKey("gauge-${visibleMetrics.first.name}"),
      );
      final lastGauge = find.byKey(
        ValueKey("gauge-${visibleMetrics.last.name}"),
      );
      expect(
        tester.getRect(firstGauge).top,
        greaterThan(tester.getRect(lastGauge).top),
      );
      expect(
        tester.getRect(firstGauge).bottom,
        lessThanOrEqualTo(closeRect.top),
      );
      await tester.drag(scrollArea, const Offset(0, 300));
      await settle();
      expect(scroll.offset, greaterThan(0));
      expect(tester.state(find.byType(EditorTextBox)), same(editorState));
      expect(tester.getRect(close), closeRect);
      await tester.tap(close);
      await settle();
      expect(capsule, findsNothing);
      expect(dashboard, findsOneWidget);

      // Expanding status controls also moves both FABs above the taller bar.
      final originalTop = tester.getRect(dashboard).top;
      await tester.tap(find.byKey(const Key("statusbar-expand")));
      await settle();
      expect(tester.getRect(dashboard).top, lessThan(originalTop));
      quill.scrollController.jumpTo(
        quill.scrollController.position.maxScrollExtent,
      );
      await settle();
      final renderEditor = quill.config.editorKey!.currentState!.renderEditor;
      final lastLine = renderEditor.getLocalRectForCaret(
        TextPosition(offset: manuscript.length),
      );
      final lastLineBottom = renderEditor.localToGlobal(lastLine.bottomLeft).dy;
      expect(lastLineBottom, lessThan(tester.getRect(dashboard).top));

      // The keyboard is already handled by the outer workspace Scaffold.
      tester.view.viewInsets = const FakeViewPadding(bottom: 384);
      await settle();
      await tester.tap(dashboard);
      await settle();
      expect(dashboard, findsNothing);
      expect(tester.getRect(capsule).bottom, lessThan(844 - 384));
      expect(tester.getRect(capsule).top, greaterThanOrEqualTo(0));
      expect(tester.getRect(capsule).bottom, tester.getRect(navigation).bottom);
      await tester.tap(navigation);
      await settle();
      expect(capsule, findsNothing);
      expect(find.byKey(const Key("navigation-surface")), findsOneWidget);
      await tester.tap(find.byKey(const Key("navigation-destination-0")));
      await settle();
      expect(
        tester.getRect(find.byKey(const Key("mobile-module-pages"))).bottom,
        tester.getRect(find.byType(MonogatariStatusBar)).top,
      );
      await tester.tap(navigation);
      await settle();
      await tester.ensureVisible(editorDestination);
      await tester.tap(editorDestination);
      await settle();
      expect(tester.state(find.byType(EditorTextBox)), same(editorState));
      expect(quill.controller.document.toPlainText(), contains(manuscript));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 3));
    },
  );

  for (final scale in [1.0, 2.0]) {
    testWidgets("compact status rows remain usable at 320dp, scale $scale", (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var overwritten = false;
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: Scaffold(
            bottomNavigationBar: MonogatariStatusBar(
              compact: true,
              displayText: "文件",
              saveTimeText: "12:00",
              cursorLine: 12,
              cursorColumn: 23,
              currentWords: 446,
              totalWords: 1234567,
              iconSize: 14,
              onToggleOverwrite: () => overwritten = true,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text("文件"), findsOneWidget);
      expect(find.text("12:23"), findsOneWidget);
      expect(find.textContaining("446"), findsOneWidget);
      expect(find.text("12:00"), findsNothing);
      expect(find.byKey(const Key("statusbar-tab-spaces")), findsNothing);
      await tester.tap(find.byKey(const Key("statusbar-expand")));
      await tester.pump();
      expect(find.text("12:00"), findsOneWidget);
      expect(find.byKey(const Key("statusbar-tab-spaces")), findsOneWidget);
      final summaryRow = tester.getRect(
        find.byKey(const Key("statusbar-summary-row")),
      );
      final secondaryRow = tester.getRect(
        find.byKey(const Key("statusbar-secondary-row")),
      );
      expect(summaryRow.height, secondaryRow.height);
      expect(secondaryRow.width, 320);
      expect(
        tester.getRect(find.text("12:23")).left,
        lessThan(tester.getRect(find.textContaining("446")).left),
      );
      final overwriteButton = find.widgetWithText(TextButton, "[DEF]");
      await tester.ensureVisible(overwriteButton);
      await tester.pump();
      expect(tester.getRect(overwriteButton).right, closeTo(312, .1));
      expect(
        tester.getRect(find.text("12:00")).left,
        lessThan(
          tester.getRect(find.byKey(const Key("statusbar-tab-spaces"))).left,
        ),
      );
      expect(
        tester.getRect(find.byKey(const Key("statusbar-tab-spaces"))).left,
        lessThan(tester.getRect(overwriteButton).left),
      );
      await tester.tap(overwriteButton);
      expect(overwritten, isTrue);
      await tester.tap(find.byKey(const Key("statusbar-expand")));
      await tester.pump();
      expect(find.byKey(const Key("statusbar-secondary-row")), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 3));
    });
  }
}
