import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ribbon/material_ribbon.dart';

void main() {
  for (final type in [
    RibbonCommandType.action,
    RibbonCommandType.menu,
    RibbonCommandType.split,
    RibbonCommandType.gallery,
  ]) {
    for (final scale in [1.0, 1.5, 2.0]) {
      testWidgets('large ${type.name} wraps at text scale $scale', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        var invocations = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Material(
                child: MaterialRibbon(
                  compact: false,
                  context: const RibbonContext(),
                  tabs: [
                    RibbonTab(
                      id: 'file',
                      label: 'File',
                      groups: [
                        RibbonGroup(
                          id: 'project',
                          label: 'Project',
                          commands: [
                            RibbonCommand(
                              id: 'save',
                              label: 'ファイルを保存',
                              icon: Icons.save,
                              type: type,
                              size: RibbonCommandSize.large,
                              onInvoke: () => invocations++,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final labelFinder = find.text('ファイルを保存');
        final label = tester.widget<Text>(labelFinder);
        expect(label.maxLines, 2);
        expect(label.softWrap, isTrue);
        expect(label.textAlign, TextAlign.center);
        expect(tester.takeException(), isNull);
        if (type == RibbonCommandType.action ||
            type == RibbonCommandType.split) {
          await tester.tap(labelFinder);
          await tester.pumpAndSettle();
          expect(invocations, 1);
        }
      });
    }
  }
}
