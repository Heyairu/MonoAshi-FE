import 'package:monogatari_assistant/l10n/app_localization.dart';
import "package:flutter/material.dart";
import "package:flutter/foundation.dart" show listEquals;
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../ui_library/spacing.dart";
import "../../../presentation/providers/revision_tracking_provider.dart";
import "../../../presentation/providers/project_state_providers.dart";
import "../../../models/chapter_selection_data.dart";
import "../application/revision_field_registry.dart";
import "../application/revision_review_service.dart";
import "../domain/revision_models.dart";
import "../domain/revision_target.dart";

class RevisionTrackingPanel extends ConsumerWidget {
  final VoidCallback onStart;
  final VoidCallback onClose;
  final void Function(RevisionTextDiff, RevisionTextHunk, int) onNavigateText;
  final void Function(RevisionRecordChange, RevisionFieldChange?)
  onNavigateRecord;
  final int sidebarPageIndex;
  final void Function(RevisionTextDiff, RevisionTextHunk)? onRejectText;
  final void Function(Map<RevisionTextDiff, List<RevisionTextHunk>>)?
  onRejectTextScope;
  final void Function(RevisionRecordChange, RevisionFieldChange?)?
  onRejectRecord;
  const RevisionTrackingPanel({
    super.key,
    required this.onStart,
    required this.onClose,
    required this.onNavigateText,
    required this.onNavigateRecord,
    required this.sidebarPageIndex,
    this.onRejectText,
    this.onRejectTextScope,
    this.onRejectRecord,
  });

  static RevisionSidebarPage? _page(int index) => switch (index) {
    1 => RevisionSidebarPage.baseInfo,
    2 => RevisionSidebarPage.chapters,
    3 => RevisionSidebarPage.outline,
    5 => RevisionSidebarPage.characters,
    7 => RevisionSidebarPage.world,
    8 => RevisionSidebarPage.items,
    _ => null,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(revisionTrackingProvider);
    final notifier = ref.read(revisionTrackingProvider.notifier);
    final selectedChapter = ref.watch(editorSelectionProvider).selectedChapID;
    final chapterNames = {
      for (final location in ChapterTree.chaptersDepthFirst(
        ref.watch(segmentsDataProvider),
      ))
        location.chapter.chapterUUID: location.chapter.chapterName,
    };
    final result = state.comparison;
    final currentOnly = state.scope == RevisionViewScope.current;
    final texts =
        result?.texts
            .where(
              (text) =>
                  state.filter != RevisionViewFilter.settings &&
                  (!currentOnly || text.chapterId == selectedChapter),
            )
            .toList() ??
        [];
    final records =
        result?.records
            .where(
              (record) =>
                  state.filter != RevisionViewFilter.text &&
                  (!currentOnly ||
                      RevisionFieldRegistry.pageFor(record.key.kind) ==
                          _page(sidebarPageIndex)),
            )
            .toList() ??
        [];
    final visibleHunks =
        <({RevisionTextDiff text, RevisionTextHunk hunk, int index})>[];
    for (final text in texts) {
      for (var index = 0; index < text.hunks.length; index++) {
        final hunk = text.hunks[index];
        if (state.showAccepted ||
            !state.acceptedEvents.contains(
              RevisionReviewService.textKey(state.baseline!, text, hunk),
            )) {
          visibleHunks.add((text: text, hunk: hunk, index: index));
        }
      }
    }
    final visibleRecords = records.where((record) {
      if (state.showAccepted) return true;
      if (record.fields.isEmpty) {
        return !state.acceptedEvents.contains(
          RevisionReviewService.recordKey(state.baseline!, record, null),
        );
      }
      return record.fields.any(
        (field) => !state.acceptedEvents.contains(
          RevisionReviewService.recordKey(state.baseline!, record, field),
        ),
      );
    }).toList();
    final pendingKeys = <String>{
      for (final entry in visibleHunks)
        RevisionReviewService.textKey(state.baseline!, entry.text, entry.hunk),
      for (final record in visibleRecords)
        if (record.fields.isEmpty)
          RevisionReviewService.recordKey(state.baseline!, record, null)
        else
          for (final field in record.fields)
            RevisionReviewService.recordKey(state.baseline!, record, field),
    }.difference(state.acceptedEvents);
    final pendingText = <RevisionTextDiff, List<RevisionTextHunk>>{};
    for (final entry in visibleHunks) {
      final key = RevisionReviewService.textKey(
        state.baseline!,
        entry.text,
        entry.hunk,
      );
      if (!state.acceptedEvents.contains(key)) {
        pendingText.putIfAbsent(entry.text, () => []).add(entry.hunk);
      }
    }
    final navigation = <({RevisionTarget target, VoidCallback run})>[];
    for (final entry in visibleHunks) {
      final text = entry.text;
      final hunk = entry.hunk;
      final index = entry.index;
      navigation.add((
        target: RevisionTarget.chapter(text.chapterId, hunkIndex: index),
        run: () => _selectText(ref, text, hunk, index),
      ));
    }
    for (final record in visibleRecords) {
      if (record.fields.isEmpty) {
        navigation.add((
          target: RevisionTarget.field(record.key, const []),
          run: () => _selectRecord(ref, record, null),
        ));
      } else {
        for (final field in record.fields) {
          if (!state.showAccepted &&
              state.acceptedEvents.contains(
                RevisionReviewService.recordKey(state.baseline!, record, field),
              )) {
            continue;
          }
          navigation.add((
            target: RevisionTarget.field(record.key, field.target.fieldPath),
            run: () => _selectRecord(ref, record, field),
          ));
        }
      }
    }
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surfaceContainerLow,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                const Icon(Icons.rate_review_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.uiTrackChanges,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.uiCollapseChangesPane,
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          if (state.baseline == null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.space20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.status == RevisionComparisonStatus.unavailable
                            ? (state.error ??
                                  context.l10n.uiCouldNotReadChangeTrackingData)
                            : context
                                  .l10n
                                  .uiCreateABaselineFromTheCurrentContentTo,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: onStart,
                        icon: const Icon(Icons.play_arrow),
                        label: Text(context.l10n.uiStartTracking),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.uiBaseline((state.baseline!.label).toString()),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    context.l10n.uiComparingToCurrentContent(
                      (state.baseline!.readOnly
                              ? context.l10n.uiReadOnlyVersion
                              : context.l10n.commonCreate)
                          .toString(),
                      context.formats.dateTime(
                        state.baseline!.createdAt,
                        seconds: false,
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (state.baseline!.sourceRevisionId case final revisionId?)
                    Text(
                      "P2P revision：$revisionId",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: state.baseline!.id,
                          items: [
                            for (final baseline in state.baselines)
                              DropdownMenuItem(
                                value: baseline.id,
                                child: Text(
                                  baseline.label,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                          onChanged: (id) {
                            if (id != null) notifier.selectBaseline(id);
                          },
                        ),
                      ),
                      IconButton(
                        tooltip: context
                            .l10n
                            .uiSaveCurrentContentAsCheckpointAndApply,
                        onPressed: () => notifier.saveCheckpoint(
                          label: context.l10n.revisionCheckpointLabel(
                            context.formats.dateTime(
                              DateTime.now(),
                              seconds: false,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.bookmark_add_outlined),
                      ),
                    ],
                  ),
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.l10n.uiShowAcceptedChanges),
                    value: state.showAccepted,
                    onChanged: (value) =>
                        notifier.setShowAccepted(value ?? false),
                  ),
                  TextButton.icon(
                    onPressed: notifier.stop,
                    icon: const Icon(Icons.stop_circle_outlined, size: 18),
                    label: Text(context.l10n.uiStopTracking),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Wrap(
                spacing: 3,
                children: [
                  for (final (label, filter) in [
                    (context.l10n.uiAll, RevisionViewFilter.all),
                    (context.l10n.uiManuscript, RevisionViewFilter.text),
                    (context.l10n.uiSettings, RevisionViewFilter.settings),
                  ])
                    ChoiceChip(
                      label: Text(label),
                      selected: state.filter == filter,
                      onSelected: (_) => notifier.setFilter(filter),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Row(
                children: [
                  Text(context.l10n.uiScope),
                  Expanded(
                    child: DropdownButton<RevisionViewScope>(
                      isExpanded: true,
                      value: state.scope,
                      items: [
                        DropdownMenuItem(
                          value: RevisionViewScope.current,
                          child: Text(context.l10n.uiCurrentChapterPage),
                        ),
                        DropdownMenuItem(
                          value: RevisionViewScope.allProject,
                          child: Text(context.l10n.uiEntireProject),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) notifier.setScope(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (result != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  context.l10n.uiManuscriptLinesSettingsM(
                    context.formats.integer(result.addedLines),
                    context.formats.integer(result.removedLines),
                    context.formats.integer(
                      result.recordCount(RevisionChangeKind.added),
                    ),
                    context.formats.integer(
                      result.recordCount(RevisionChangeKind.removed),
                    ),
                    context.formats.integer(
                      result.recordCount(RevisionChangeKind.modified),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            if (pendingKeys.isNotEmpty && !state.baseline!.readOnly)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => notifier.acceptEvents(pendingKeys),
                  icon: const Icon(Icons.done_all, size: 16),
                  label: Text(
                    context.l10n.uiAcceptChangesInScope(
                      context.formats.integer(pendingKeys.length),
                    ),
                  ),
                ),
              ),
            if (pendingText.values.fold<int>(
                      0,
                      (sum, hunks) => sum + hunks.length,
                    ) >
                    1 &&
                !state.baseline!.readOnly &&
                onRejectTextScope != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => onRejectTextScope!(pendingText),
                  icon: const Icon(Icons.undo, size: 16),
                  label: Text(context.l10n.uiRejectManuscriptChangesInScope),
                ),
              ),
            if (result != null && result.texts.any((text) => text.isCoarse))
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  context.l10n.uiLargeDifferencesAreSimplifiedLineCountsMayNot,
                ),
              ),
            if (result != null && result.unsupportedKinds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  context.l10n.uiSomeDataTypesAreNotYetIncludedIn,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: context.l10n.uiPreviousChange,
                  onPressed: navigation.isEmpty
                      ? null
                      : () => _step(ref, navigation, -1),
                  icon: const Icon(Icons.keyboard_arrow_up),
                ),
                IconButton(
                  tooltip: context.l10n.uiNextChange,
                  onPressed: navigation.isEmpty
                      ? null
                      : () => _step(ref, navigation, 1),
                  icon: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
            const Divider(height: 1),
            Expanded(
              child: switch (state.status) {
                RevisionComparisonStatus.computing => const Center(
                  child: CircularProgressIndicator(),
                ),
                RevisionComparisonStatus.failed => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      context.l10n.uiCouldNotCalculateChanges(
                        (state.error ?? context.l10n.uiUnknownError).toString(),
                      ),
                    ),
                  ),
                ),
                RevisionComparisonStatus.unavailable => Center(
                  child: Text(context.l10n.uiComparisonSourceIsNotAvailableYet),
                ),
                _ when visibleHunks.isEmpty && visibleRecords.isEmpty => Center(
                  child: Text(context.l10n.uiNoChangesInThisScope),
                ),
                _ => ListView.builder(
                  itemCount: visibleHunks.length + visibleRecords.length,
                  itemBuilder: (context, index) {
                    if (index < visibleHunks.length) {
                      final entry = visibleHunks[index];
                      final text = entry.text;
                      final hunk = entry.hunk;
                      final key = RevisionReviewService.textKey(
                        state.baseline!,
                        text,
                        hunk,
                      );
                      return _TextHunkCard(
                        text: text,
                        chapterName:
                            chapterNames[text.chapterId] ?? text.chapterId,
                        hunk: hunk,
                        index: entry.index,
                        onTap: () => _selectText(ref, text, hunk, entry.index),
                        accepted: state.acceptedEvents.contains(key),
                        onAccept: state.baseline!.readOnly
                            ? null
                            : () => notifier.acceptEvent(key),
                        onUnaccept: state.baseline!.readOnly
                            ? null
                            : () => notifier.unacceptEvent(key),
                        onReject:
                            state.baseline!.readOnly || onRejectText == null
                            ? null
                            : () => onRejectText!(text, hunk),
                      );
                    }
                    final record = visibleRecords[index - visibleHunks.length];
                    return _RecordCard(
                      record: record,
                      onTap: (field) => _selectRecord(ref, record, field),
                      baseline: state.baseline!,
                      acceptedEvents: state.acceptedEvents,
                      showAccepted: state.showAccepted,
                      onAccept: state.baseline!.readOnly
                          ? null
                          : notifier.acceptEvent,
                      onUnaccept: state.baseline!.readOnly
                          ? null
                          : notifier.unacceptEvent,
                      onReject:
                          state.baseline!.readOnly || onRejectRecord == null
                          ? null
                          : (field) => onRejectRecord!(record, field),
                    );
                  },
                ),
              },
            ),
          ],
        ],
      ),
    );
  }

  void _selectText(
    WidgetRef ref,
    RevisionTextDiff text,
    RevisionTextHunk hunk,
    int index,
  ) {
    ref
        .read(revisionTrackingProvider.notifier)
        .select(RevisionTarget.chapter(text.chapterId, hunkIndex: index));
    onNavigateText(text, hunk, index);
  }

  void _selectRecord(
    WidgetRef ref,
    RevisionRecordChange record,
    RevisionFieldChange? field,
  ) {
    ref
        .read(revisionTrackingProvider.notifier)
        .select(
          RevisionTarget.field(record.key, field?.target.fieldPath ?? const []),
        );
    onNavigateRecord(record, field);
  }

  void _step(
    WidgetRef ref,
    List<({RevisionTarget target, VoidCallback run})> actions,
    int direction,
  ) {
    final selected = ref.read(revisionTrackingProvider).selectedTarget;
    final index = selected == null
        ? -1
        : actions.indexWhere(
            (entry) =>
                entry.target.chapterId == selected.chapterId &&
                entry.target.hunkIndex == selected.hunkIndex &&
                entry.target.recordKey == selected.recordKey &&
                listEquals(entry.target.fieldPath, selected.fieldPath),
          );
    final next = index < 0
        ? (direction > 0 ? 0 : actions.length - 1)
        : (index + direction + actions.length) % actions.length;
    actions[next].run();
  }
}

class _TextHunkCard extends StatelessWidget {
  final RevisionTextDiff text;
  final String chapterName;
  final RevisionTextHunk hunk;
  final int index;
  final VoidCallback onTap;
  final bool accepted;
  final VoidCallback? onAccept;
  final VoidCallback? onUnaccept;
  final VoidCallback? onReject;
  const _TextHunkCard({
    required this.text,
    required this.chapterName,
    required this.hunk,
    required this.index,
    required this.onTap,
    required this.accepted,
    required this.onAccept,
    required this.onUnaccept,
    required this.onReject,
  });
  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.fromLTRB(8, 5, 8, 2),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.uiManuscriptBeforeAfter(
                (chapterName).toString(),
                context.formats.integer(hunk.oldStart + 1),
                context.formats.integer(hunk.newStart + 1),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            for (final line in hunk.lines.take(12))
              Text(
                "${line.kind == RevisionLineKind.added ? "+" : "-"} ${line.after?.text ?? line.before?.text ?? ""}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: line.kind == RevisionLineKind.added
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            if (hunk.lines.length > 12)
              Text(
                context.l10n.uiAdditionalLines(
                  context.formats.integer(hunk.lines.length - 12),
                ),
              ),
            if (hunk.lines.isEmpty && text.trailingNewlineChanged)
              Text(
                context.l10n.uiTrailingNewline(
                  (text.oldTrailingNewline
                          ? context.l10n.uiPresent
                          : context.l10n.uiNone)
                      .toString(),
                  (text.newTrailingNewline
                          ? context.l10n.uiPresent
                          : context.l10n.uiNone)
                      .toString(),
                ),
              ),
            if (text.isCoarse)
              Text(
                context.l10n.uiLargeDifferencesOverview,
                style: TextStyle(fontSize: 11),
              ),
            Wrap(
              spacing: 4,
              children: [
                TextButton(
                  onPressed: () => _showFullDiff(context),
                  child: Text(context.l10n.uiFullAnnotation),
                ),
                if (onAccept != null)
                  TextButton(
                    onPressed: accepted ? onUnaccept : onAccept,
                    child: Text(
                      accepted
                          ? context.l10n.uiUndoAcceptance
                          : context.l10n.uiAccept,
                    ),
                  ),
                if (!accepted && onReject != null)
                  TextButton(
                    onPressed: onReject,
                    child: Text(context.l10n.uiReject),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  void _showFullDiff(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.uiFullAnnotation2((chapterName).toString())),
        content: SizedBox(
          width: (MediaQuery.sizeOf(context).width - 80).clamp(200.0, 640.0),
          height: (MediaQuery.sizeOf(context).height - 180).clamp(200.0, 500.0),
          child: ListView.builder(
            itemCount: text.lines.length,
            itemBuilder: (context, index) {
              final line = text.lines[index];
              final sign = switch (line.kind) {
                RevisionLineKind.added => "+",
                RevisionLineKind.removed => "−",
                RevisionLineKind.equal => " ",
              };
              final value = line.after?.text ?? line.before?.text ?? "";
              return SelectableText(
                "$sign $value",
                style: TextStyle(
                  color: line.kind == RevisionLineKind.added
                      ? Colors.green.shade700
                      : line.kind == RevisionLineKind.removed
                      ? Colors.red.shade700
                      : null,
                  decoration: line.kind == RevisionLineKind.removed
                      ? TextDecoration.lineThrough
                      : null,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.commonClose),
          ),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final RevisionRecordChange record;
  final void Function(RevisionFieldChange?) onTap;
  final RevisionBaseline baseline;
  final Set<String> acceptedEvents;
  final bool showAccepted;
  final void Function(String)? onAccept;
  final void Function(String)? onUnaccept;
  final void Function(RevisionFieldChange?)? onReject;
  const _RecordCard({
    required this.record,
    required this.onTap,
    required this.baseline,
    required this.acceptedEvents,
    required this.showAccepted,
    required this.onAccept,
    required this.onUnaccept,
    required this.onReject,
  });
  String _display(Object? value) => value == null ? "null" : value.toString();
  @override
  Widget build(BuildContext context) {
    final badge = switch (record.kind) {
      RevisionChangeKind.added => "+",
      RevisionChangeKind.removed => "-",
      RevisionChangeKind.modified => "Modified",
    };
    final page = RevisionFieldRegistry.pageFor(record.key.kind);
    final label = page == null
        ? record.key.kind.name
        : context.l10n.legacyLabel(RevisionFieldRegistry.pageLabel(page));
    final name =
        record.after?.fields["displayName"] ??
        record.after?.fields["name"] ??
        record.after?.fields["event"] ??
        record.before?.fields["displayName"] ??
        record.before?.fields["name"] ??
        record.before?.fields["event"] ??
        (record.key.kind.name == "baseInfo"
            ? context.l10n.uiProjectInformation
            : record.key.recordId);
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 5, 8, 2),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text("$label／$name"),
              trailing: Text(badge),
              onTap: () => onTap(null),
            ),
            if (record.fields.isEmpty)
              Text(
                record.kind == RevisionChangeKind.added
                    ? context.l10n.uiAddedItem
                    : context.l10n.uiDeletedItem,
              ),
            if (record.fields.isEmpty) _reviewActions(context, null),
            if (record.fields.isEmpty)
              for (final entry
                  in (record.after ?? record.before)!.fields.entries
                      .where(
                        (entry) => !RevisionFieldRegistry.excluded(entry.key),
                      )
                      .take(8))
                Text(
                  "${context.l10n.revisionFieldLabel([entry.key])}：${_display(entry.value)}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            for (final field in record.fields)
              if (showAccepted ||
                  !acceptedEvents.contains(
                    RevisionReviewService.recordKey(baseline, record, field),
                  ))
                InkWell(
                  onTap: () => onTap(field),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${context.l10n.revisionFieldLabel(field.target.fieldPath)}  "
                          "${switch (field.kind) {
                            RevisionChangeKind.added => "+",
                            RevisionChangeKind.removed => "-",
                            RevisionChangeKind.modified => "Modified",
                          }}",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        if (field.oldExists)
                          Text(
                            "- ${_display(field.oldValue)}",
                            style: TextStyle(color: Colors.red.shade700),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (field.newExists)
                          Text(
                            "+ ${_display(field.newValue)}",
                            style: TextStyle(color: Colors.green.shade700),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        _reviewActions(context, field),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _reviewActions(BuildContext context, RevisionFieldChange? field) {
    if (onAccept == null) return const SizedBox.shrink();
    final key = RevisionReviewService.recordKey(baseline, record, field);
    final accepted = acceptedEvents.contains(key);
    return Wrap(
      spacing: 4,
      children: [
        TextButton(
          onPressed: () =>
              accepted ? onUnaccept?.call(key) : onAccept?.call(key),
          child: Text(
            accepted
                ? context.l10n.revisionUnaccept
                : context.l10n.revisionAccept,
          ),
        ),
        if (!accepted &&
            onReject != null &&
            field != null &&
            RevisionReviewService.canRejectField(record, field))
          TextButton(
            onPressed: () => onReject!(field),
            child: Text(context.l10n.revisionReject),
          ),
      ],
    );
  }
}
