import 'package:monogatari_assistant/l10n/app_localization.dart';
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../models/timeline_data.dart";
import "../providers/project_state_providers.dart";
import "../providers/snapshot_timeline_providers.dart";
import "snapshot_timeline_preview.dart";

/// Local navigation for operations anchored to an existing Scene placement.
/// Empty or overlapping ranges never guess a new operation anchor.
class SceneSnapshotTimelinePreview extends ConsumerStatefulWidget {
  final SnapshotTimelineSubject subject;
  final String placementUUID;
  final ValueChanged<String> onPlacementSelected;

  const SceneSnapshotTimelinePreview({
    super.key,
    required this.subject,
    required this.placementUUID,
    required this.onPlacementSelected,
  });

  @override
  ConsumerState<SceneSnapshotTimelinePreview> createState() =>
      _SceneSnapshotTimelinePreviewState();
}

class _SceneSnapshotTimelinePreviewState
    extends ConsumerState<SceneSnapshotTimelinePreview> {
  int? _tick;
  String? _pickedPlacement;

  @override
  void didUpdateWidget(covariant SceneSnapshotTimelinePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.placementUUID != widget.placementUUID &&
        _pickedPlacement != widget.placementUUID) {
      _tick = null;
    }
    _pickedPlacement = widget.placementUUID;
  }

  @override
  Widget build(BuildContext context) {
    final placements = ref
        .watch(timelineDocumentProvider)
        .placements
        .where(
          (p) => p.sceneUUID != null && p.level == TimelineElementLevel.small,
        )
        .toList();
    final anchor = placements
        .where((p) => p.placementUUID == widget.placementUUID)
        .firstOrNull;
    _tick ??= anchor?.startTick ?? 0;
    return SizedBox(
      width: 480,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SnapshotTimelinePreview(
            subject: widget.subject,
            mode: SnapshotPreviewMode.localTick,
            localTick: _tick,
            allowBaseline: false,
            allowLocateMainTimeline: false,
            placementsOverride: placements,
            onTickChanged: (tick) {
              setState(() => _tick = tick);
              final matches = placements
                  .where((p) => p.startTick <= tick && tick < p.endTick)
                  .toList();
              if (matches.length == 1 &&
                  matches.single.placementUUID != widget.placementUUID) {
                _pickedPlacement = matches.single.placementUUID;
                widget.onPlacementSelected(_pickedPlacement!);
              }
            },
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.uiSnapshotBoundToStartTick(
              (anchor?.label ?? context.l10n.uiNoSceneSelected).toString(),
              anchor == null ? '—' : context.formats.integer(anchor.startTick),
            ),
          ),
          Text(context.l10n.uiDragOntoASingleSceneToSelectIt),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
