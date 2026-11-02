import 'package:monogatari_assistant/l10n/app_localization.dart';
import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../models/writing_goal_data.dart";
import "../providers/writing_progress_provider.dart";
import "writing_goal_dialog.dart";
import "../../ui_library/spacing.dart";
import "../../features/revision_tracking/application/revision_gauge_summary.dart";
import "../../features/revision_tracking/domain/revision_models.dart";
import "../providers/gauge_dashboard_provider.dart";
import "../providers/revision_tracking_provider.dart";
import "../providers/project_state_providers.dart";
import "../providers/word_count_providers.dart";

extension on DashboardMetric {
  String get label => switch (this) {
    DashboardMetric.dailyWords => "每日目標",
    DashboardMetric.chapterWords => "本章字數",
    DashboardMetric.totalWords => "全書字數",
    DashboardMetric.updatePlans => "更新計畫",
    DashboardMetric.foreshadows => "伏筆回收",
    DashboardMetric.revisionTracking => "追蹤校訂",
  };

  bool get hasWordGoal =>
      this == DashboardMetric.dailyWords ||
      this == DashboardMetric.chapterWords ||
      this == DashboardMetric.totalWords;
}

/// A compact, independently scrolling dashboard at the editor's trailing edge.
class RadialGaugeDashboard extends ConsumerStatefulWidget {
  // A compact rail around a fixed 64dp dial.
  static const panelWidth = 96.0;
  static const collapsedWidth = 48.0;

  final VoidCallback onClose;
  final bool capsule;
  final bool reverseOrder;
  final VoidCallback? onStartRevision;
  final VoidCallback? onOpenRevision;

  const RadialGaugeDashboard({
    super.key,
    required this.onClose,
    this.onStartRevision,
    this.onOpenRevision,
    this.capsule = false,
    this.reverseOrder = false,
  });

  @override
  ConsumerState<RadialGaugeDashboard> createState() =>
      _RadialGaugeDashboardState();

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onStartRevision,
    VoidCallback? onOpenRevision,
  }) => showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      constraints: const BoxConstraints(
        minWidth: panelWidth,
        maxWidth: panelWidth,
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: panelWidth,
        height: 560,
        child: RadialGaugeDashboard(
          onClose: () => Navigator.of(context).pop(),
          onStartRevision: onStartRevision,
          onOpenRevision: onOpenRevision == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  onOpenRevision();
                },
        ),
      ),
    ),
  );
}

class _RadialGaugeDashboardState extends ConsumerState<RadialGaugeDashboard> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(gaugeDashboardProvider);
    final colors = Theme.of(context).colorScheme;
    final canAdd = settings.metrics.length < DashboardMetric.values.length;
    final metrics = widget.reverseOrder
        ? settings.metrics.reversed
        : settings.metrics;
    final addGauge = PopupMenuButton<DashboardMetric>(
      tooltip: canAdd
          ? context.l10n.uiAddGauge
          : context.l10n.uiAllGaugesAreAlreadyShown,
      enabled: canAdd,
      onSelected: (metric) =>
          ref.read(gaugeDashboardProvider.notifier).setVisible(metric, true),
      itemBuilder: (context) => [
        for (final metric in DashboardMetric.values)
          if (!settings.metrics.contains(metric))
            PopupMenuItem(
              value: metric,
              child: Text(context.l10n.legacyLabel(metric.label)),
            ),
      ],
      icon: Icon(
        Icons.add_rounded,
        color: canAdd ? colors.primary : colors.onSurfaceVariant,
      ),
    );
    return Material(
      key: const ValueKey("radial-gauge-dashboard"),
      color: colors.surfaceContainerLow,
      elevation: widget.capsule ? 6 : 0,
      shape: widget.capsule ? const StadiumBorder() : null,
      clipBehavior: widget.capsule ? Clip.antiAlias : Clip.none,
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                key: const ValueKey("gauge-dashboard-scroll-area"),
                controller: _scrollController,
                primary: false,
                reverse: widget.reverseOrder,
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.sm),
                    if (widget.reverseOrder) addGauge,
                    for (final metric in metrics) ...[
                      _DashboardGauge(
                        metric: metric,
                        settings: settings,
                        onStartRevision: widget.onStartRevision,
                        onOpenRevision: widget.onOpenRevision,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    if (settings.metrics.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        child: Text(
                          context.l10n.uiAddAGaugeToViewYourWritingProgress,
                        ),
                      ),
                    if (!widget.reverseOrder) addGauge,
                  ],
                ),
              ),
            ),
          ),
          if (widget.capsule)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: IconButton(
                key: const ValueKey("mobile-dashboard-close"),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: widget.onClose,
                icon: const Icon(Icons.close_rounded, size: 24),
              ),
            ),
        ],
      ),
    );
  }
}

/// The first visible metric also serves as the mobile dashboard launcher.
class RadialGaugePreview extends ConsumerWidget {
  const RadialGaugePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(gaugeDashboardProvider);
    if (settings.metrics.isEmpty) {
      return const Icon(Icons.speed_rounded, size: 24);
    }
    return _DashboardGauge(
      metric: settings.metrics.first,
      settings: settings,
      previewOnly: true,
    );
  }
}

class _DashboardGauge extends ConsumerWidget {
  const _DashboardGauge({
    required this.metric,
    required this.settings,
    this.previewOnly = false,
    this.onStartRevision,
    this.onOpenRevision,
  });

  final DashboardMetric metric;
  final GaugeDashboardSettings settings;
  final bool previewOnly;
  final VoidCallback? onStartRevision;
  final VoidCallback? onOpenRevision;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final values = switch (metric) {
      DashboardMetric.dailyWords => (
        ref.watch(dailyWritingProgressProvider).todayTotal,
        settings.dailyWordGoal,
        colors.primary,
      ),
      DashboardMetric.chapterWords => (
        ref.watch(
          activeChapterWordCountProvider.select((state) => state.count),
        ),
        settings.chapterWordGoal,
        colors.primary,
      ),
      DashboardMetric.totalWords => (
        ref.watch(totalWordsProvider),
        settings.totalWordGoal,
        colors.primary,
      ),
      DashboardMetric.updatePlans => (
        ref.watch(
          updatePlanDataProvider.select(
            (items) => items.where((item) => item.isDone).length,
          ),
        ),
        ref.watch(updatePlanDataProvider.select((items) => items.length)),
        colors.secondary,
      ),
      DashboardMetric.foreshadows => (
        ref.watch(
          foreshadowDataProvider.select(
            (items) => items.where((item) => item.isRevealed).length,
          ),
        ),
        ref.watch(foreshadowDataProvider.select((items) => items.length)),
        colors.tertiary,
      ),
      DashboardMetric.revisionTracking => null,
    };
    if (values == null) return _buildRevisionGauge(context, ref);
    final (value, maximum, color) = values;
    final format = context.formats.integer;
    final detail = maximum == 0
        ? context.l10n.uiNoYet(
            (metric == DashboardMetric.updatePlans
                    ? context.l10n.uiPlan
                    : context.l10n.uiForeshadowing)
                .toString(),
          )
        : "${format(value)} / ${format(maximum)}${metric.hasWordGoal ? context.l10n.uiWords : context.l10n.uiEntries4}";
    final hasChapter =
        metric != DashboardMetric.chapterWords ||
        ref.watch(editorSelectionProvider.select((s) => s.selectedChapID)) !=
            null;
    final dailyUnavailable =
        metric == DashboardMetric.dailyWords &&
        (ref.watch(dailyWritingProgressProvider).isLoading ||
            ref.watch(dailyWritingProgressProvider).error != null);
    final progress = maximum > 0 && hasChapter && !dailyUnavailable
        ? (value / maximum).clamp(0.0, 1.0)
        : 0.0;
    final status = dailyUnavailable
        ? context.l10n.uiStatisticsTemporarilyUnavailable
        : !hasChapter
        ? context.l10n.uiChooseAChapter
        : detail;
    final percentage = maximum == 0 || !hasChapter || dailyUnavailable
        ? context.l10n.uiNoProgressYet
        : context.formats.percent(progress, fractionDigits: 0);
    final unit = metric.hasWordGoal
        ? context.l10n.uiWords2
        : context.l10n.uiEntries5;

    final dial = CompactRadialGauge(
      progress: progress,
      currentValue: hasChapter && !dailyUnavailable ? format(value) : "—",
      targetValue: "/ ${format(maximum)} $unit",
      color: color,
    );
    if (previewOnly) return dial;

    return MenuAnchor(
      key: ValueKey("gauge-${metric.name}"),
      crossAxisUnconstrained: false,
      style: const MenuStyle(
        minimumSize: WidgetStatePropertyAll(Size(240, 0)),
        maximumSize: WidgetStatePropertyAll(Size(320, double.infinity)),
      ),
      menuChildren: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.uiInformation(
                      (context.l10n.legacyLabel(metric.label)).toString(),
                    ),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    context.l10n.uiCurrent(
                      (hasChapter && !dailyUnavailable ? format(value) : "—")
                          .toString(),
                      (unit).toString(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    "${metric.hasWordGoal ? context.l10n.uiGoal2 : context.l10n.uiTotal}：${format(maximum)} $unit",
                  ),
                  if (metric == DashboardMetric.dailyWords) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n.uiAllLocalWorks(
                        (ref.watch(dailyWritingProgressProvider).day)
                            .toString(),
                      ),
                    ),
                    Text(
                      context
                          .l10n
                          .uiFullWidthCharactersHalfWidthWordsAdditionsMinus,
                    ),
                    if (value < 0)
                      Text(
                        context.l10n.uiNetDecreaseTodayWords(
                          (format(-value)).toString(),
                        ),
                      ),
                    if (ref.watch(dailyWritingProgressProvider).isPending)
                      Text(context.l10n.uiProcessingStatistics),
                    if (ref.watch(dailyWritingProgressProvider).ledger.warning
                        case final warning?)
                      Text(warning),
                    if (ref.watch(dailyWritingProgressProvider).error != null)
                      TextButton(
                        onPressed: () async {
                          try {
                            await ref
                                .read(dailyWritingProgressProvider)
                                .retry();
                          } catch (_) {}
                        },
                        child: Text(
                          context.l10n.uiCouldNotSaveStatisticsClickToRetry,
                        ),
                      ),
                  ] else if (metric.hasWordGoal) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n.uiSource(
                        (ref
                                        .watch(projectWritingGoalsProvider)
                                        .overrideFor(
                                          metric == DashboardMetric.chapterWords
                                              ? WritingGoalKind.chapter
                                              : WritingGoalKind.total,
                                        ) ==
                                    null
                                ? context.l10n.uiDefault
                                : context.l10n.uiThisFileOnly)
                            .toString(),
                      ),
                    ),
                  ],
                  if (maximum == 0 || !hasChapter || dailyUnavailable) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(status),
                  ],
                ],
              ),
            ),
            if (metric.hasWordGoal)
              MenuItemButton(
                autofocus: true,
                onPressed: () => _editGoal(context, ref, metric, maximum),
                leadingIcon: const Icon(Icons.flag_outlined, size: 20),
                child: Text(context.l10n.uiSetWordCountGoal),
              ),
            const Divider(height: 1),
            MenuItemButton(
              key: ValueKey("gauge-delete-${metric.name}"),
              autofocus: !metric.hasWordGoal,
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(colors.error),
              ),
              onPressed: () => ref
                  .read(gaugeDashboardProvider.notifier)
                  .setVisible(metric, false),
              leadingIcon: const Icon(Icons.delete_outline_rounded, size: 20),
              child: Text(context.l10n.uiRemoveGauge),
            ),
          ],
        ),
      ],
      builder: (context, controller, child) => Semantics(
        button: true,
        label: context.l10n.legacyLabel(metric.label),
        value: "$status，$percentage",
        child: Tooltip(
          message:
              "${context.l10n.legacyLabel(metric.label)}：$percentage\n$status",
          excludeFromSemantics: true,
          child: InkWell(
            key: ValueKey("gauge-open-${metric.name}"),
            borderRadius: BorderRadius.circular(AppSpacing.md),
            onTap: () {
              Tooltip.dismissAllToolTips();
              controller.isOpen ? controller.close() : controller.open();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: ExcludeSemantics(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    dial,
                    Text(
                      context.l10n.legacyLabel(metric.label),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRevisionGauge(BuildContext context, WidgetRef ref) {
    final tracking = ref.watch(revisionTrackingProvider);
    final summary = RevisionGaugeSummary.fromComparison(tracking.comparison);
    final colors = Theme.of(context).colorScheme;
    final format = context.formats.integer;
    final status = switch (tracking.status) {
      RevisionComparisonStatus.notStarted => context.l10n.uiTrackingNotStarted,
      RevisionComparisonStatus.computing => context.l10n.uiCalculating,
      RevisionComparisonStatus.failed =>
        tracking.error ?? context.l10n.uiCalculationFailed,
      RevisionComparisonStatus.unavailable =>
        tracking.error ?? context.l10n.uiComparisonSourceIsNotAvailableYet,
      RevisionComparisonStatus.complete =>
        summary.total == 0
            ? context.l10n.uiNoRevisionsYet
            : context.l10n.uiComparisonComplete,
    };
    final additions = format(summary.additions);
    final revisions = format(summary.revisions);
    final description = context.l10n.uiOuterRingAdditionsInnerRingRevisions(
      (additions).toString(),
      context.formats.integer((summary.additionsFraction * 100).round()),
      (revisions).toString(),
      context.formats.integer((summary.revisionsFraction * 100).round()),
      (status).toString(),
    );
    final dial = CompactRadialGauge(
      progress: summary.additionsFraction,
      secondaryProgress: summary.revisionsFraction,
      currentValue: "+$additions",
      targetValue: "−$revisions",
      color: colors.primary,
      secondaryColor: colors.tertiary,
    );
    if (previewOnly) return dial;

    return MenuAnchor(
      key: const ValueKey("gauge-revisionTracking"),
      crossAxisUnconstrained: false,
      style: const MenuStyle(
        minimumSize: WidgetStatePropertyAll(Size(240, 0)),
        maximumSize: WidgetStatePropertyAll(Size(320, double.infinity)),
      ),
      menuChildren: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.uiRevisionTrackingInformation,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    context.l10n.uiOuterRingAdditions((additions).toString()),
                    style: TextStyle(color: colors.primary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.l10n.uiInnerRingRevisions((revisions).toString()),
                    style: TextStyle(color: colors.tertiary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(status),
                  if (tracking.baseline != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.l10n.uiComparisonBaseline(
                        (tracking.baseline!.label).toString(),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    context
                        .l10n
                        .uiManuscriptChangesAreCountedByChangedLinesSettings,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(context.l10n.uiEachRingShowsItsCountAsAShare),
                ],
              ),
            ),
            if (tracking.baseline == null)
              MenuItemButton(
                autofocus: true,
                onPressed:
                    onStartRevision ??
                    () => ref.read(revisionTrackingProvider.notifier).start(),
                leadingIcon: const Icon(Icons.play_arrow_rounded, size: 20),
                child: Text(context.l10n.uiStartTracking),
              ),
            if (onOpenRevision != null)
              MenuItemButton(
                autofocus: tracking.baseline != null,
                onPressed: onOpenRevision,
                leadingIcon: const Icon(Icons.rate_review_outlined, size: 20),
                child: Text(context.l10n.uiViewRevisionDetails),
              ),
            const Divider(height: 1),
            MenuItemButton(
              key: const ValueKey("gauge-delete-revisionTracking"),
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(colors.error),
              ),
              onPressed: () => ref
                  .read(gaugeDashboardProvider.notifier)
                  .setVisible(DashboardMetric.revisionTracking, false),
              leadingIcon: const Icon(Icons.delete_outline_rounded, size: 20),
              child: Text(context.l10n.uiRemoveGauge),
            ),
          ],
        ),
      ],
      builder: (context, controller, child) => Semantics(
        button: true,
        label: context.l10n.uiTrackRevisions,
        value: description,
        child: Tooltip(
          message: description,
          excludeFromSemantics: true,
          child: InkWell(
            key: const ValueKey("gauge-open-revisionTracking"),
            borderRadius: BorderRadius.circular(AppSpacing.md),
            onTap: () {
              Tooltip.dismissAllToolTips();
              controller.isOpen ? controller.close() : controller.open();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: ExcludeSemantics(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    dial,
                    Text(
                      context.l10n.uiTrackRevisions,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editGoal(
    BuildContext context,
    WidgetRef ref,
    DashboardMetric metric,
    int current,
  ) => showWritingGoalDialog(context, ref, switch (metric) {
    DashboardMetric.dailyWords => WritingGoalKind.daily,
    DashboardMetric.chapterWords => WritingGoalKind.chapter,
    _ => WritingGoalKind.total,
  });
}

/// Status-icon proportions: a 64dp dial and a 4dp rounded arc.
/// Values fit inside the dial without changing the arc's size or stroke.
class CompactRadialGauge extends StatelessWidget {
  static const diameter = 64.0;
  static const strokeWidth = 4.0;

  final double progress;
  final String currentValue;
  final String targetValue;
  final Color color;
  final double? secondaryProgress;
  final Color? secondaryColor;

  const CompactRadialGauge({
    super.key,
    required this.progress,
    required this.currentValue,
    required this.targetValue,
    required this.color,
    this.secondaryProgress,
    this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = progress.isFinite ? progress.clamp(0.0, 1.0) : 0.0;
    final theme = Theme.of(context);
    final trackColor =
        theme.progressIndicatorTheme.circularTrackColor ??
        theme.colorScheme.outlineVariant;
    final inner = secondaryProgress;
    final normalizedInner = inner != null && inner.isFinite
        ? inner.clamp(0.0, 1.0)
        : 0.0;
    return SizedBox.square(
      dimension: diameter,
      child: TweenAnimationBuilder<({double outer, double inner})>(
        tween: _GaugeProgressTween(
          begin: (outer: 0, inner: 0),
          end: (outer: normalized, inner: normalizedInner),
        ),
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => CustomPaint(
          painter: _GaugePainter(
            value.outer,
            color,
            trackColor,
            secondaryProgress: inner == null ? null : value.inner,
            secondaryColor: secondaryColor ?? theme.colorScheme.tertiary,
          ),
          child: child,
        ),
        child: Padding(
          padding: EdgeInsets.all(
            inner == null ? AppSpacing.md : AppSpacing.lg,
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentValue,
                    style:
                        (inner == null
                                ? theme.textTheme.titleLarge
                                : theme.textTheme.titleSmall)
                            ?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                              height: 1.1,
                            ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    targetValue,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color:
                          secondaryColor ?? theme.colorScheme.onSurfaceVariant,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugeProgressTween extends Tween<({double outer, double inner})> {
  _GaugeProgressTween({required super.begin, required super.end});

  @override
  ({double outer, double inner}) lerp(double t) => (
    outer: begin!.outer + (end!.outer - begin!.outer) * t,
    inner: begin!.inner + (end!.inner - begin!.inner) * t,
  );
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double? secondaryProgress;
  final Color? secondaryColor;

  const _GaugePainter(
    this.progress,
    this.color,
    this.trackColor, {
    this.secondaryProgress,
    this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - CompactRadialGauge.strokeWidth) / 2;
    final bounds = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = CompactRadialGauge.strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    const start = math.pi * 0.75;
    const sweep = math.pi * 1.5;
    canvas.drawArc(bounds, start, sweep, false, paint);
    if (progress > 0) {
      paint.color = color;
      canvas.drawArc(bounds, start, sweep * progress, false, paint);
    }
    final inner = secondaryProgress;
    if (inner != null) {
      final innerBounds = Rect.fromCircle(center: center, radius: radius - 8);
      paint.color = trackColor;
      canvas.drawArc(innerBounds, start, sweep, false, paint);
      if (inner > 0) {
        paint.color = secondaryColor ?? color;
        canvas.drawArc(innerBounds, start, sweep * inner, false, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.secondaryProgress != secondaryProgress ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.trackColor != trackColor;
}
