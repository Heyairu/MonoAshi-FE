import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/writing_goal_data.dart';
import 'writing_goal_providers.dart';

enum DashboardMetric {
  dailyWords,
  chapterWords,
  totalWords,
  updatePlans,
  foreshadows,
  revisionTracking,
}

/// Visibility is workspace UI state; goal values are derived from their owners.
class GaugeDashboardSettings {
  final List<DashboardMetric> metrics;
  final int dailyWordGoal;
  final int chapterWordGoal;
  final int totalWordGoal;
  const GaugeDashboardSettings({
    this.metrics = const [
      DashboardMetric.dailyWords,
      DashboardMetric.chapterWords,
      DashboardMetric.updatePlans,
      DashboardMetric.foreshadows,
      DashboardMetric.revisionTracking,
    ],
    this.dailyWordGoal = 1000,
    this.chapterWordGoal = 2000,
    this.totalWordGoal = 100000,
  });
}

final gaugeDashboardProvider =
    NotifierProvider<GaugeDashboardNotifier, GaugeDashboardSettings>(
      GaugeDashboardNotifier.new,
    );

class GaugeDashboardNotifier extends Notifier<GaugeDashboardSettings> {
  List<DashboardMetric> _metrics = const GaugeDashboardSettings().metrics;
  @override
  GaugeDashboardSettings build() => GaugeDashboardSettings(
    metrics: _metrics,
    dailyWordGoal: ref
        .watch(effectiveWritingGoalDefaultsProvider)
        .dailyWordGoal,
    chapterWordGoal: ref.watch(effectiveChapterWordGoalProvider),
    totalWordGoal: ref.watch(effectiveTotalWordGoalProvider),
  );
  void setVisible(DashboardMetric metric, bool visible) {
    _metrics = List.unmodifiable(
      visible ? {..._metrics, metric} : _metrics.where((m) => m != metric),
    );
    state = GaugeDashboardSettings(
      metrics: _metrics,
      dailyWordGoal: state.dailyWordGoal,
      chapterWordGoal: state.chapterWordGoal,
      totalWordGoal: state.totalWordGoal,
    );
  }

  Future<void> setWordGoal(DashboardMetric metric, int goal) async {
    final kind = switch (metric) {
      DashboardMetric.dailyWords => WritingGoalKind.daily,
      DashboardMetric.chapterWords => WritingGoalKind.chapter,
      DashboardMetric.totalWords => WritingGoalKind.total,
      _ => null,
    };
    if (kind == null || !isValidWritingGoal(goal)) return;
    await ref.read(writingGoalDefaultsProvider.notifier).setGoal(kind, goal);
  }
}
