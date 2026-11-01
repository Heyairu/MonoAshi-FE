import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/domain/collaboration/collaboration_operation.dart';
import 'package:monogatari_assistant/domain/collaboration/typed_operation_log.dart';
import 'package:monogatari_assistant/features/revision_tracking/domain/revision_models.dart';
import 'package:monogatari_assistant/presentation/providers/revision_tracking_provider.dart';
import 'package:monogatari_assistant/presentation/widgets/radial_gauge_dashboard.dart';

class _RevisionFixture extends RevisionTrackingNotifier {
  @override
  RevisionTrackingState build() => const RevisionTrackingState();

  void emit(RevisionTrackingState value) => state = value;
}

RevisionComparison changes(List<RevisionChangeKind> kinds) =>
    RevisionComparison(
      baselineVersion: 'base',
      targetVersion: 'now',
      texts: [],
      unsupportedKinds: {},
      records: [
        for (var i = 0; i < kinds.length; i++)
          RevisionRecordChange(
            key: ProjectRecordKey(
              kind: ProjectRecordKind.character,
              recordId: '$i',
            ),
            kind: kinds[i],
          ),
      ],
    );

void main() {
  testWidgets(
    'revision gauge shows two live rings and retains tracking when hidden',
    (tester) async {
      final container = ProviderContainer(
        overrides: [
          revisionTrackingProvider.overrideWith(_RevisionFixture.new),
        ],
      );
      addTearDown(container.dispose);
      final notifier =
          container.read(revisionTrackingProvider.notifier) as _RevisionFixture;
      notifier.emit(
        RevisionTrackingState(
          status: RevisionComparisonStatus.complete,
          comparison: changes([RevisionChangeKind.modified]),
        ),
      );
      var opened = 0;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: RadialGaugeDashboard.panelWidth,
                  child: RadialGaugeDashboard(
                    onClose: () {},
                    onOpenRevision: () => opened++,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final dial = find.descendant(
        of: find.byKey(const ValueKey('gauge-revisionTracking')),
        matching: find.byType(CompactRadialGauge),
      );
      expect(tester.widget<CompactRadialGauge>(dial).progress, .5);
      expect(tester.widget<CompactRadialGauge>(dial).secondaryProgress, .5);
      expect(
        find.descendant(of: dial, matching: find.text('+1')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: dial, matching: find.text('−1')),
        findsOneWidget,
      );
      notifier.emit(
        RevisionTrackingState(
          status: RevisionComparisonStatus.complete,
          comparison: changes([
            RevisionChangeKind.modified,
            RevisionChangeKind.added,
          ]),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<CompactRadialGauge>(dial).progress,
        closeTo(2 / 3, .0001),
      );
      expect(
        tester.widget<CompactRadialGauge>(dial).secondaryProgress,
        closeTo(1 / 3, .0001),
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey('gauge-open-revisionTracking')),
      );
      await tester.tap(
        find.byKey(const ValueKey('gauge-open-revisionTracking')),
      );
      await tester.pumpAndSettle();
      expect(find.text('外環新增：2 筆'), findsOneWidget);
      expect(find.text('內環校訂：1 筆'), findsOneWidget);
      await tester.tap(find.text('查看校訂明細'));
      await tester.pumpAndSettle();
      expect(opened, 1);
      await tester.tap(
        find.byKey(const ValueKey('gauge-open-revisionTracking')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('gauge-delete-revisionTracking')),
      );
      await tester.pumpAndSettle();
      expect(dial, findsNothing);
      expect(
        container.read(revisionTrackingProvider).comparison!.records,
        hasLength(2),
      );
    },
  );
}
