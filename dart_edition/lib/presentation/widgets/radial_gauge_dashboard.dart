import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";

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
  final VoidCallback? onStartRevision;
  final VoidCallback? onOpenRevision;

  const RadialGaugeDashboard({
    super.key,
    required this.onClose,
    this.onStartRevision,
    this.onOpenRevision,
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
    return Material(
      key: const ValueKey("radial-gauge-dashboard"),
      color: colors.surfaceContainerLow,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          key: const ValueKey("gauge-dashboard-scroll-area"),
          controller: _scrollController,
          primary: false,
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.sm),
              for (final metric in settings.metrics) ...[
                _buildGauge(metric, settings),
                const SizedBox(height: AppSpacing.md),
              ],
              if (settings.metrics.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Text("新增儀表，查看寫作進度。"),
                ),
              PopupMenuButton<DashboardMetric>(
                tooltip: canAdd ? "新增儀表" : "已顯示全部儀表",
                enabled: canAdd,
                onSelected: (metric) => ref
                    .read(gaugeDashboardProvider.notifier)
                    .setVisible(metric, true),
                itemBuilder: (context) => [
                  for (final metric in DashboardMetric.values)
                    if (!settings.metrics.contains(metric))
                      PopupMenuItem(value: metric, child: Text(metric.label)),
                ],
                icon: Icon(
                  Icons.add_rounded,
                  color: canAdd ? colors.primary : colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGauge(DashboardMetric metric, GaugeDashboardSettings settings) {
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
    if (values == null) return _buildRevisionGauge();
    final (value, maximum, color) = values;
    final format = NumberFormat.decimalPattern();
    final detail = maximum == 0
        ? "尚無${metric == DashboardMetric.updatePlans ? "計畫" : "伏筆"}"
        : "${format.format(value)} / ${format.format(maximum)}${metric.hasWordGoal ? " 字" : " 項"}";
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
        ? "統計暫時無法使用"
        : !hasChapter
        ? "請選擇章節"
        : detail;
    final percentage = maximum == 0 || !hasChapter || dailyUnavailable
        ? "尚無進度"
        : "${(progress * 100).round()}%";
    final unit = metric.hasWordGoal ? "字" : "項";

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
                    "${metric.label}資訊",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    "目前：${hasChapter && !dailyUnavailable ? format.format(value) : "—"} $unit",
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    "${metric.hasWordGoal ? "目標" : "總計"}：${format.format(maximum)} $unit",
                  ),
                  if (metric == DashboardMetric.dailyWords) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${ref.watch(dailyWritingProgressProvider).day} · 本機所有作品合計',
                    ),
                    const Text('全形字元＋半形單字；新增減去刪除'),
                    if (value < 0) Text('今日淨減 ${format.format(-value)} 字'),
                    if (ref.watch(dailyWritingProgressProvider).isPending)
                      const Text('統計處理中…'),
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
                        child: const Text('統計無法保存，點此重試'),
                      ),
                  ] else if (metric.hasWordGoal) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '來源：${ref.watch(projectWritingGoalsProvider).overrideFor(metric == DashboardMetric.chapterWords ? WritingGoalKind.chapter : WritingGoalKind.total) == null ? "預設" : "僅限本檔案"}',
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
                onPressed: () => _editGoal(metric, maximum),
                leadingIcon: const Icon(Icons.flag_outlined, size: 20),
                child: const Text("設定字數目標"),
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
              child: const Text("刪除儀表"),
            ),
          ],
        ),
      ],
      builder: (context, controller, child) => Semantics(
        button: true,
        label: metric.label,
        value: "$status，$percentage",
        child: Tooltip(
          message: "${metric.label}：$percentage\n$status",
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
                    CompactRadialGauge(
                      progress: progress,
                      currentValue: hasChapter && !dailyUnavailable
                          ? format.format(value)
                          : "—",
                      targetValue: "/ ${format.format(maximum)} $unit",
                      color: color,
                    ),
                    Text(
                      metric.label,
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

  Widget _buildRevisionGauge() {
    final tracking = ref.watch(revisionTrackingProvider);
    final summary = RevisionGaugeSummary.fromComparison(tracking.comparison);
    final colors = Theme.of(context).colorScheme;
    final format = NumberFormat.decimalPattern();
    final status = switch (tracking.status) {
      RevisionComparisonStatus.notStarted => "尚未開始追蹤",
      RevisionComparisonStatus.computing => "計算中",
      RevisionComparisonStatus.failed => tracking.error ?? "計算失敗",
      RevisionComparisonStatus.unavailable => tracking.error ?? "比較來源尚未取得",
      RevisionComparisonStatus.complete => summary.total == 0 ? "尚無校訂" : "比較完成",
    };
    final additions = format.format(summary.additions);
    final revisions = format.format(summary.revisions);
    final description =
        "外環新增：$additions 筆（${(summary.additionsFraction * 100).round()}%）\n"
        "內環校訂：$revisions 筆（${(summary.revisionsFraction * 100).round()}%）\n$status";
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
                  Text("追蹤校訂資訊", style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    "外環新增：$additions 筆",
                    style: TextStyle(color: colors.primary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    "內環校訂：$revisions 筆",
                    style: TextStyle(color: colors.tertiary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(status),
                  if (tracking.baseline != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text("比較基準：${tracking.baseline!.label}"),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  const Text("正文按變動行、設定按資料筆數統計。修改會在新增與校訂各計一筆。"),
                  const SizedBox(height: AppSpacing.sm),
                  const Text("兩環顯示各類計數占合計的比例。"),
                ],
              ),
            ),
            if (tracking.baseline == null)
              MenuItemButton(
                autofocus: true,
                onPressed:
                    widget.onStartRevision ??
                    () => ref.read(revisionTrackingProvider.notifier).start(),
                leadingIcon: const Icon(Icons.play_arrow_rounded, size: 20),
                child: const Text("開始追蹤"),
              ),
            if (widget.onOpenRevision != null)
              MenuItemButton(
                autofocus: tracking.baseline != null,
                onPressed: widget.onOpenRevision,
                leadingIcon: const Icon(Icons.rate_review_outlined, size: 20),
                child: const Text("查看校訂明細"),
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
              child: const Text("刪除儀表"),
            ),
          ],
        ),
      ],
      builder: (context, controller, child) => Semantics(
        button: true,
        label: "追蹤校訂",
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
                    CompactRadialGauge(
                      progress: summary.additionsFraction,
                      secondaryProgress: summary.revisionsFraction,
                      currentValue: "+$additions",
                      targetValue: "−$revisions",
                      color: colors.primary,
                      secondaryColor: colors.tertiary,
                    ),
                    Text("追蹤校訂", style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editGoal(DashboardMetric metric, int current) =>
      showWritingGoalDialog(context, ref, switch (metric) {
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
