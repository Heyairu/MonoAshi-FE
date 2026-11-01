import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ribbon/material_ribbon.dart';
import 'package:monogatari_assistant/bin/appbar.dart';
import 'package:monogatari_assistant/models/toolbar_mode.dart';

void main() {
  for (final mode in ToolbarMode.values) {
    testWidgets('${mode.name} home display block toggles reflect visibility', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var navigation = true;
      var sidebar = true;
      var dashboard = true;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, update) => Scaffold(
              appBar: MonogatariTopAppBar(
                iconSize: 22,
                mode: mode,
                modePreference: mode,
                onModeChanged: (_) {},
                showPunctuationPanel: false,
                showFindReplaceWindow: false,
                onFileAction: (_) async {},
                onEditorAction: (_) async {},
                onEditorActionPointerDown: () {},
                onEditorActionInteractionEnd: () {},
                onTogglePunctuationPanel: () {},
                onToggleFindReplaceWindow: () {},
                showNavigation: navigation,
                showSidebar: sidebar,
                showDashboard: dashboard,
                onToggleNavigation: () =>
                    update(() => navigation = !navigation),
                onToggleSidebar: () => update(() => sidebar = !sidebar),
                onToggleDashboard: () => update(() => dashboard = !dashboard),
              ),
            ),
          ),
        ),
      );
      final ribbon = tester.widget<MaterialRibbon>(find.byType(MaterialRibbon));
      final group = ribbon.tabs
          .firstWhere((tab) => tab.id == 'home')
          .groups
          .singleWhere((group) => group.id == 'display-blocks');
      expect(group.label, '顯示區塊');
      expect(group.commands.map((c) => c.label), ['導覽列', '側邊欄', '儀表板']);
      for (final label in ['導覽列', '側邊欄', '儀表板']) {
        for (final expected in [
          RibbonCheckState.unchecked,
          RibbonCheckState.checked,
        ]) {
          await tester.ensureVisible(find.byTooltip(label));
          await tester.tap(find.byTooltip(label));
          await tester.pumpAndSettle();
          final current = tester.widget<MaterialRibbon>(
            find.byType(MaterialRibbon),
          );
          final command = current.tabs
              .firstWhere((tab) => tab.id == 'home')
              .groups
              .expand((group) => group.commands)
              .singleWhere((command) => command.label == label);
          expect(command.stateFor(const RibbonContext()), expected);
          expect(tester.takeException(), isNull);
        }
      }
    });
  }
}
