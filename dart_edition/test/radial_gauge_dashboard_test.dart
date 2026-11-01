import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monogatari_assistant/bin/ui_library.dart';
import 'package:monogatari_assistant/models/plan_data.dart';
import 'package:monogatari_assistant/presentation/providers/gauge_dashboard_provider.dart';
import 'package:monogatari_assistant/presentation/providers/project_state_providers.dart';
import 'package:monogatari_assistant/presentation/providers/word_count_providers.dart';
import 'package:monogatari_assistant/presentation/widgets/radial_gauge_dashboard.dart';

Future<void> mountDashboard(
  WidgetTester tester,
  ProviderContainer container, {
  double height = 800,
  double textScale = 1,
  bool dark = false,
}) => tester.pumpWidget(
  UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: dark
          ? AppTheme.getDarkTheme(14, Colors.teal)
          : AppTheme.getLightTheme(14, Colors.teal),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: Scaffold(
        body: Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            width: RadialGaugeDashboard.panelWidth,
            height: height,
            child: RadialGaugeDashboard(onClose: () {}),
          ),
        ),
      ),
    ),
  ),
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('gauges follow chapter counts and project plan changes', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(editorSelectionProvider.notifier)
        .setSelection(selectedSegID: 'folder', selectedChapID: 'chapter');
    container.read(updatePlanDataProvider.notifier).setUpdatePlanData([
      UpdatePlanItem(id: 'one', isDone: true),
      UpdatePlanItem(id: 'two'),
    ]);
    container.read(foreshadowDataProvider.notifier).setForeshadowData([
      ForeshadowItem(id: 'one', isRevealed: true),
    ]);
    await mountDashboard(tester, container);
    container
        .read(activeChapterWordCountProvider.notifier)
        .refreshFromCount(chapterId: 'chapter', count: 1145);
    await tester.pumpAndSettle();
    final chapterGauge = find.descendant(
      of: find.byKey(const ValueKey('gauge-chapterWords')),
      matching: find.byType(CompactRadialGauge),
    );
    expect(
      find.descendant(of: chapterGauge, matching: find.text('1,145')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: chapterGauge, matching: find.text('/ 2,000 字')),
      findsOneWidget,
    );
    expect(find.text('57%'), findsNothing);
    expect(find.byIcon(Icons.more_horiz_rounded), findsNothing);
    expect(find.byTooltip('本章字數：57%\n1,145 / 2,000 字'), findsOneWidget);
    final planGauge = find.descendant(
      of: find.byKey(const ValueKey('gauge-updatePlans')),
      matching: find.byType(CompactRadialGauge),
    );
    expect(
      find.descendant(of: planGauge, matching: find.text('1')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: planGauge, matching: find.text('/ 2 項')),
      findsOneWidget,
    );
    expect(find.text('50%'), findsNothing);
    expect(find.text('100%'), findsNothing);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(
      tester.getCenter(find.byKey(const ValueKey('gauge-open-chapterWords'))),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('本章字數：57%\n1,145 / 2,000 字'), findsOneWidget);
    await mouse.removePointer();
    await tester.pumpAndSettle();

    container
        .read(activeChapterWordCountProvider.notifier)
        .refreshFromCount(chapterId: 'chapter', count: 2100);
    container.read(updatePlanDataProvider.notifier).setUpdatePlanData([]);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: chapterGauge, matching: find.text('2,100')),
      findsOneWidget,
    );
    expect(find.byTooltip('更新計畫：尚無進度\n尚無計畫'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('word goal validates input and updates the gauge', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(editorSelectionProvider.notifier)
        .setSelection(selectedSegID: 'folder', selectedChapID: 'chapter');
    await mountDashboard(tester, container);
    container
        .read(activeChapterWordCountProvider.notifier)
        .refreshFromCount(chapterId: 'chapter', count: 400);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('gauge-open-chapterWords')));
    await tester.pumpAndSettle();
    expect(find.text('本章字數資訊'), findsOneWidget);
    expect(find.text('目前：400 字'), findsOneWidget);
    container
        .read(activeChapterWordCountProvider.notifier)
        .refreshFromCount(chapterId: 'chapter', count: 800);
    await tester.pumpAndSettle();
    expect(find.text('目前：800 字'), findsOneWidget);
    await tester.tap(find.text('設定字數目標'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '0');
    await tester.tap(find.text('套用'));
    await tester.pumpAndSettle();
    expect(find.text('請輸入 1 到 999,999,999 的整數'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '1919');
    await tester.tap(find.text('套用'));
    await tester.pumpAndSettle();
    expect(container.read(gaugeDashboardProvider).chapterWordGoal, 1919);
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('add and remove controls survive panel remounting', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(updatePlanDataProvider.notifier).setUpdatePlanData([
      UpdatePlanItem(id: 'keep', isDone: true),
    ]);
    await mountDashboard(tester, container);
    await tester.tap(find.byKey(const ValueKey('gauge-open-updatePlans')));
    await tester.pumpAndSettle();
    expect(find.text('更新計畫資訊'), findsOneWidget);
    final delete = find.byKey(const ValueKey('gauge-delete-updatePlans'));
    expect(tester.getSize(delete).width, greaterThanOrEqualTo(200));
    expect(
      tester.getTopLeft(delete).dy,
      greaterThan(tester.getBottomLeft(find.text('總計：1 項')).dy),
    );
    await tester.tap(delete);
    await tester.pumpAndSettle();
    expect(find.text('更新計畫'), findsNothing);
    expect(find.text('更新計畫資訊'), findsNothing);
    expect(container.read(updatePlanDataProvider).single.id, 'keep');
    await tester.ensureVisible(find.byTooltip('新增儀表'));
    await tester.tap(find.byTooltip('新增儀表'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('全書字數'));
    await tester.pumpAndSettle();
    container.read(totalWordsProvider.notifier).setTotalWords(25000);
    await tester.pumpAndSettle();
    final totalGauge = find.descendant(
      of: find.byKey(const ValueKey('gauge-totalWords')),
      matching: find.byType(CompactRadialGauge),
    );
    expect(
      find.descendant(of: totalGauge, matching: find.text('25,000')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: totalGauge, matching: find.text('/ 100,000 字')),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
    await mountDashboard(tester, container);
    expect(find.text('更新計畫'), findsNothing);
    expect(find.text('全書字數'), findsOneWidget);
  });

  for (final dark in [false, true]) {
    testWidgets(
      'short ${dark ? 'dark' : 'light'} panel scrolls with large text',
      (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        await mountDashboard(
          tester,
          container,
          height: 240,
          textScale: 2,
          dark: dark,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.drag(
          find.byKey(const ValueKey('gauge-dashboard-scroll-area')),
          const Offset(0, -1500),
        );
        await tester.pumpAndSettle();
        expect(find.byTooltip('新增儀表').hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
        for (final gauge in find.byType(CompactRadialGauge).evaluate()) {
          expect(gauge.size, const Size(64, 64));
        }
        await tester.ensureVisible(
          find.byKey(const ValueKey('gauge-open-foreshadows')),
        );
        await tester.tap(find.byKey(const ValueKey('gauge-open-foreshadows')));
        await tester.pumpAndSettle();
        expect(find.text('伏筆回收資訊'), findsOneWidget);
        final delete = find.byKey(const ValueKey('gauge-delete-foreshadows'));
        await tester.ensureVisible(delete);
        expect(delete.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.text('伏筆回收資訊'), findsNothing);
      },
    );
  }
}
