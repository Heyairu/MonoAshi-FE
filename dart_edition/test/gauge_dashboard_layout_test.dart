import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_quill/flutter_quill.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:monogatari_assistant/bin/content.dart";
import "package:monogatari_assistant/bin/appbar.dart";
import "package:monogatari_assistant/bin/slidebar.dart";
import "package:monogatari_assistant/features/revision_tracking/presentation/revision_tracking_panel.dart";
import "package:monogatari_assistant/bin/ui_library.dart";
import "package:monogatari_assistant/main.dart";
import "package:monogatari_assistant/presentation/widgets/radial_gauge_dashboard.dart";
import "package:monogatari_assistant/presentation/providers/project_state_providers.dart";
import "package:monogatari_assistant/presentation/providers/revision_tracking_provider.dart";
import "package:monogatari_assistant/features/revision_tracking/domain/revision_models.dart";
import "package:shared_preferences/shared_preferences.dart";

Future<void> waitForRevision(
  WidgetTester tester,
  ProviderContainer container,
) async {
  // Pump the widget-test zone as well as the real isolate response queue.
  for (var attempt = 0; attempt < 100; attempt++) {
    await tester.pump(const Duration(milliseconds: 100));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    final state = container.read(revisionTrackingProvider);
    if (state.status == RevisionComparisonStatus.complete) {
      return;
    }
    if (state.status == RevisionComparisonStatus.failed) {
      fail(state.error ?? 'Comparison failed');
    }
  }
  fail('Revision comparison did not complete');
}

void main() {
  testWidgets(
    "trailing dashboard collapses and opens at narrow desktop widths",
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel(
          'com.heyairu.monogatari_assistant/background_execution',
        ),
        (_) async => true,
      );
      await tester.binding.setSurfaceSize(const Size(1600, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
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
      Future<void> settleLayout() async {
        // Project I/O can animate continuously, so use bounded frame advances.
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
      }

      await settleLayout();
      final editor = tester.state(find.byType(EditorTextBox));
      Future<void> toggle(String label) async {
        await tester.ensureVisible(find.byTooltip(label));
        await tester.tap(find.byTooltip(label));
        await settleLayout();
        expect(tester.state(find.byType(EditorTextBox)), same(editor));
        expect(tester.takeException(), isNull);
      }

      expect(find.byType(RadialGaugeDashboard), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(RadialGaugeDashboard)).dy,
        tester.getTopLeft(find.byType(MonogatariNavigationLayout)).dy,
      );
      expect(
        tester.getTopLeft(find.byType(RadialGaugeDashboard)).dx,
        greaterThan(tester.getTopLeft(find.byType(EditorTextBox)).dx),
      );
      expect(tester.takeException(), isNull);

      expect(
        tester.getSize(find.byType(RadialGaugeDashboard)).width,
        RadialGaugeDashboard.panelWidth,
      );
      await toggle("儀表板");
      expect(find.byType(RadialGaugeDashboard), findsNothing);
      expect(
        tester
            .widget<MonogatariTopAppBar>(find.byType(MonogatariTopAppBar))
            .showDashboard,
        isFalse,
      );
      await toggle("儀表板");
      expect(find.byType(RadialGaugeDashboard), findsOneWidget);
      expect(
        tester.getSize(find.byType(RadialGaugeDashboard)).width,
        RadialGaugeDashboard.panelWidth,
      );

      await toggle("導覽列");
      expect(
        find.byKey(const ValueKey("navigation-destination-0")).hitTestable(),
        findsNothing,
      );
      await toggle("導覽列");
      final width = tester.getSize(find.byType(EditorTextBox)).width;
      await toggle("側邊欄");
      expect(
        tester.getSize(find.byType(EditorTextBox)).width,
        greaterThan(width),
      );
      await toggle("側邊欄");
      expect(find.byTooltip("開啟修訂追蹤"), findsNothing);
      await tester.ensureVisible(
        find.byKey(const ValueKey("gauge-open-revisionTracking")),
      );
      await tester.tap(
        find.byKey(const ValueKey("gauge-open-revisionTracking")),
      );
      await settleLayout();
      await tester.tap(find.text("查看校訂明細"));
      await settleLayout();
      expect(find.byType(RevisionTrackingPanel), findsOneWidget);
      expect(find.byType(Dialog), findsNothing);
      expect(
        find.byKey(const ValueKey('revision-sidebar-inline')),
        findsOneWidget,
      );
      expect(tester.state(find.byType(EditorTextBox)), same(editor));
      final panel = tester.getRect(find.byType(RevisionTrackingPanel));
      final dashboard = tester.getRect(find.byType(RadialGaugeDashboard));
      expect(panel.right, closeTo(dashboard.left - 1, .1));
      expect(panel.width, 320);
      await tester.tap(find.text('開始追蹤'));
      await settleLayout();
      await waitForRevision(tester, container);
      container
          .read(revisionTrackingProvider.notifier)
          .setScope(RevisionViewScope.allProject);
      container.read(baseInfoDataProvider.notifier).setBookName('校訂側欄驗證');
      await waitForRevision(tester, container);
      await settleLayout();
      await tester.tap(find.byTooltip('下一筆'));
      await settleLayout();
      expect(find.byType(RevisionTrackingPanel), findsOneWidget);
      expect(
        container.read(revisionTrackingProvider).selectedTarget,
        isNotNull,
      );
      expect(tester.state(find.byType(EditorTextBox)), same(editor));
      await tester.tap(find.byTooltip("收合修訂窗格"));
      await settleLayout();
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(const Size(900, 800));
      await settleLayout();
      expect(find.byType(RadialGaugeDashboard), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip("開啟儀表板"));
      await settleLayout();
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(RadialGaugeDashboard), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(
        find.byKey(const ValueKey('gauge-open-revisionTracking')),
      );
      await tester.tap(
        find.byKey(const ValueKey('gauge-open-revisionTracking')),
      );
      await settleLayout();
      await tester.tap(find.text('查看校訂明細'));
      await settleLayout();
      expect(find.byType(Dialog), findsNothing);
      expect(
        find.byKey(const ValueKey('revision-sidebar-overlay')),
        findsOneWidget,
      );
      expect(find.byType(RevisionTrackingPanel), findsOneWidget);
      expect(
        tester.getRect(find.byType(RevisionTrackingPanel)).right,
        closeTo(
          tester.getRect(find.byKey(const ValueKey('dashboard-column'))).left -
              1,
          .1,
        ),
      );
      await tester.tap(find.byTooltip('收合修訂窗格'));
      await settleLayout();
      expect(find.byType(Dialog), findsNothing);
      expect(find.byType(RevisionTrackingPanel), findsNothing);

      await tester.binding.setSurfaceSize(const Size(2400, 1200));
      await settleLayout();
      expect(find.byType(RadialGaugeDashboard), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
