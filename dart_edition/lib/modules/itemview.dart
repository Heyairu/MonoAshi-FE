import 'package:monogatari_assistant/l10n/app_localization.dart';
import "../ui_library/mobile_editor_insets.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:uuid/uuid.dart";

import "../bin/ui_library.dart";
import "../domain/collaboration/collaboration_operation.dart";
import "../domain/collaboration/typed_operation_log.dart";
import "../features/revision_tracking/presentation/revision_field_marker.dart";
import "../application/items/world_item_migration.dart";
import "../application/items/item_operations.dart";
import "../models/item_data.dart";
import "../models/item_snapshot_data.dart";
import "../models/timeline_data.dart";
import "../models/world_settings_data.dart";
import "../presentation/providers/snapshot_timeline_providers.dart";
import "../presentation/widgets/snapshot_timeline_preview.dart";
import "../presentation/widgets/snapshot_panel_card.dart";
import "../presentation/widgets/snapshot_state_editor.dart";
import "../presentation/widgets/scene_snapshot_timeline_preview.dart";
import "../presentation/providers/project_state_providers.dart";
import "../presentation/providers/timeline_providers.dart";
import "../presentation/providers/scene_selection_providers.dart";
import "../presentation/widgets/project_object_selector.dart";

class ItemView extends ConsumerStatefulWidget {
  final String? initialClassId;
  final int selectionRequestId;

  const ItemView({super.key, this.initialClassId, this.selectionRequestId = 0});

  @override
  ConsumerState<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends ConsumerState<ItemView> {
  static const _uuid = Uuid();

  static const _allFilter = "__all__";
  String? _selectedClassId;
  String? _selectedClassSnapshotId;
  final Map<String, SnapshotPreviewMode> _classPreviewModes = {};
  final Map<String, SnapshotPreviewMode> _instancePreviewModes = {};
  final Map<String, String?> _selectedInstanceSnapshotIds = {};
  final _searchController = TextEditingController();
  final _pageScrollController = ScrollController();
  final _classListScrollController = ScrollController();
  String _modeFilter = _allFilter;
  String _categoryFilter = _allFilter;
  String _assignmentFilter = _allFilter;

  @override
  void initState() {
    super.initState();
    _selectedClassId = widget.initialClassId;
  }

  @override
  void didUpdateWidget(covariant ItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectionRequestId != oldWidget.selectionRequestId) {
      _selectedClassId = widget.initialClassId;
      _selectedClassSnapshotId = null;
      _selectedInstanceSnapshotIds.clear();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageScrollController.dispose();
    _classListScrollController.dispose();
    super.dispose();
  }

  void _createClass([String? requestedName]) {
    final name = requestedName?.trim().isNotEmpty == true
        ? requestedName!.trim()
        : context.l10n.uiNewItem;
    final creation = createDedicatedItem(
      request: DedicatedItemCreationRequest(
        classId: _uuid.v4(),
        instanceId: _uuid.v4(),
        name: name,
      ),
    );
    final workspace = ref.read(itemWorkspaceProvider.notifier);
    workspace.putClass(creation.itemClass);
    workspace.putInstance(creation.instance);
    setState(() {
      _selectedClassId = creation.itemClass.classId;
      _classPreviewModes[creation.itemClass.classId] =
          SnapshotPreviewMode.baseline;
      _selectedClassSnapshotId = null;
      _selectedInstanceSnapshotIds.clear();
    });
  }

  Future<void> _archiveClass(
    ItemClassData itemClass,
    ItemWorkspaceData workspace,
  ) async {
    final activeInstances = workspace.itemInstances.values
        .where(
          (instance) =>
              instance.classId == itemClass.classId && !instance.archived,
        )
        .toList(growable: false);
    final confirmed = await AppDialog.confirm(
      context: context,
      title: context.l10n.uiArchiveItem,
      message: context.l10n.uiArchiveExistingLinksAndHistoricalSnapshotsWillBe(
        (itemClass.name.trim().isEmpty
                ? context.l10n.uiUnnamedItem
                : itemClass.name)
            .toString(),
        context.formats.integer(activeInstances.length),
      ),
      confirmLabel: context.l10n.uiArchive,
    );
    if (!confirmed || !mounted) return;

    final notifier = ref.read(itemWorkspaceProvider.notifier);
    for (final instance in activeInstances) {
      notifier.putInstance(instance.copyWith(archived: true));
    }
    notifier.putClass(itemClass.copyWith(archived: true));
    setState(() {
      if (_selectedClassId == itemClass.classId) {
        _selectedClassId = null;
        _selectedClassSnapshotId = null;
        _selectedInstanceSnapshotIds.clear();
      }
    });
  }

  void _updateClass(ItemClassData value) {
    ref.read(itemWorkspaceProvider.notifier).putClass(value);
  }

  void _updateClassSnapshot(String id, ItemStatePatch patch) {
    final change = ref
        .read(itemWorkspaceProvider)
        .itemClassStateChanges
        .where((change) => change.stateChangeId == id)
        .firstOrNull;
    if (change == null ||
        change.classId != _selectedClassId ||
        _classPreviewModes[change.classId] == SnapshotPreviewMode.baseline ||
        resolveItemClassStateChangeTime(
              change,
              ref.read(timelineDocumentProvider),
            ).resolvedTick !=
            ref.read(timelineViewProvider).currentTick) {
      return;
    }
    ref
        .read(itemWorkspaceProvider.notifier)
        .putClassStateChange(change.copyWith(patch: change.patch.merge(patch)));
  }

  void _updateInstanceSnapshot(String id, ItemStatePatch patch) {
    final workspace = ref.read(itemWorkspaceProvider);
    final change = workspace.itemInstanceStateChanges
        .where((change) => change.stateChangeId == id)
        .firstOrNull;
    if (change == null ||
        workspace.itemInstances[change.instanceId]?.classId !=
            _selectedClassId ||
        _instancePreviewModes[change.instanceId] ==
            SnapshotPreviewMode.baseline ||
        resolveItemInstanceStateChangeTime(
              change,
              ref.read(timelineDocumentProvider),
            ).resolvedTick !=
            ref.read(timelineViewProvider).currentTick) {
      return;
    }
    ref
        .read(itemWorkspaceProvider.notifier)
        .putInstanceStateChange(
          change.copyWith(patch: change.patch.merge(patch)),
        );
  }

  void _createInstance(ItemClassData itemClass) {
    final instance = ItemInstanceData(
      instanceId: _uuid.v4(),
      classId: itemClass.classId,
      name: context.l10n.uiIndividual((itemClass.name).toString()),
    );
    ref.read(itemWorkspaceProvider.notifier).putInstance(instance);
  }

  List<_RelationTarget> _relationTargets() {
    final targets = <_RelationTarget>[];
    for (final entry in ref.read(characterDataProvider).entries) {
      targets.add(
        _RelationTarget(
          id: entry.key,
          kind: ItemRelationTargetKind.character,
          label: entry.value.displayName,
        ),
      );
    }
    void addLocations(List<LocationData> nodes, [String path = ""]) {
      for (final node in nodes) {
        final label = path.isEmpty
            ? node.localName
            : "$path / ${node.localName}";
        targets.add(
          _RelationTarget(
            id: node.id,
            kind: ItemRelationTargetKind.location,
            label: label,
          ),
        );
        addLocations(node.child, label);
      }
    }

    addLocations(ref.read(worldSettingsDataProvider));
    for (final storyline in ref.read(outlineDataProvider)) {
      for (final event in storyline.scenes) {
        targets.add(
          _RelationTarget(
            id: event.storyEventUUID,
            kind: ItemRelationTargetKind.event,
            label: event.storyEvent,
          ),
        );
        for (final scene in event.scenes) {
          targets.add(
            _RelationTarget(
              id: scene.sceneUUID,
              kind: ItemRelationTargetKind.scene,
              label: "${event.storyEvent} / ${scene.sceneName}",
            ),
          );
        }
      }
    }
    return targets;
  }

  List<({String sceneId, String placementId, int startTick, String label})>
  _placedScenes() {
    final sceneIndex = ref.read(timelineSceneIndexProvider);
    final scenes = ref
        .read(placedSceneChoicesProvider)
        .map((placement) {
          final reference = sceneIndex[placement.sceneUUID]!;
          return (
            sceneId: placement.sceneUUID!,
            placementId: placement.placementUUID,
            startTick: placement.startTick,
            label:
                "${reference.storyline.storylineName} / ${reference.event.storyEvent} / ${reference.scene.sceneName}",
          );
        })
        .toList(growable: false);
    return scenes;
  }

  bool _previewIsCurrent({
    required ItemWorkspaceData workspace,
    required TimelineDocumentData timeline,
    required String sceneId,
    required String placementId,
    required int startTick,
  }) {
    if (!identical(ref.read(itemWorkspaceProvider), workspace) ||
        !identical(ref.read(timelineDocumentProvider), timeline)) {
      return false;
    }
    return _placedScenes().any(
      (scene) =>
          scene.sceneId == sceneId &&
          scene.placementId == placementId &&
          scene.startTick == startTick,
    );
  }

  void _showStalePreviewMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.uiTheItemOrSceneChangedReopenThePreview),
      ),
    );
  }

  Map<String, String> _sceneLabels() {
    final labels = <String, String>{};
    for (final storyline in ref.read(outlineDataProvider)) {
      for (final event in storyline.scenes) {
        for (final scene in event.scenes) {
          labels[scene.sceneUUID] = "${event.storyEvent} / ${scene.sceneName}";
        }
      }
    }
    return labels;
  }

  bool _isAssignedAtTick({
    required ItemClassData itemClass,
    required ItemWorkspaceData workspace,
    required int tick,
  }) {
    final timeline = ref.read(timelineDocumentProvider);
    final classState = resolveItemClassSnapshot(
      itemClass: itemClass,
      changes: workspace.itemClassStateChanges,
      timeline: timeline,
      atTick: tick,
    );
    if (classState.exists &&
        classState.allocations.any(
          (allocation) =>
              allocation.holderCharacterId != null ||
              allocation.locationId != null,
        )) {
      return true;
    }
    if (itemClass.mode == ItemMode.generic) return false;
    for (final instance in workspace.itemInstances.values.where(
      (value) => value.classId == itemClass.classId && !value.archived,
    )) {
      final state = resolveItemInstanceSnapshot(
        itemClass: itemClass,
        instance: instance,
        classChanges: workspace.itemClassStateChanges,
        instanceChanges: workspace.itemInstanceStateChanges,
        timeline: timeline,
        atTick: tick,
      );
      if (state.exists &&
          (state.holderCharacterId != null || state.locationId != null)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _addRelation(
    ItemClassData itemClass,
    List<ItemInstanceData> instances,
  ) async {
    final targets = _relationTargets();
    if (targets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.uiCreateACharacterLocationOrEventBeforeAdding,
          ),
        ),
      );
      return;
    }
    var itemKind = ItemReferenceKind.itemClass;
    var itemId = itemClass.classId;
    var target = targets.first;
    var role = "";
    var note = "";
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.uiAddItemLink),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  style: appDropdownTextStyle(context),
                  isDense: true,
                  isExpanded: true,
                  iconSize: AppControlSize.smallIcon,
                  itemHeight: appDropdownItemHeight(context),
                  menuMaxHeight: AppControlSize.menuMaxHeight,
                  key: const Key("item-relation-subject"),
                  initialValue: "${itemKind.name}:$itemId",
                  decoration: appDropdownFieldDecoration(
                    context,
                    decoration: InputDecoration(labelText: context.l10n.uiItem),
                  ),
                  items: [
                    DropdownMenuItem(
                      value:
                          "${ItemReferenceKind.itemClass.name}:${itemClass.classId}",
                      child: Text("Class：${itemClass.name}"),
                    ),
                    for (final instance in instances)
                      DropdownMenuItem(
                        value:
                            "${ItemReferenceKind.instance.name}:${instance.instanceId}",
                        child: Text(
                          context.l10n.uiIndividual2(
                            (instance.name).toString(),
                          ),
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    final separator = value.indexOf(":");
                    itemKind = ItemReferenceKind.values.byName(
                      value.substring(0, separator),
                    );
                    itemId = value.substring(separator + 1);
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  key: const Key("item-relation-target"),
                  icon: const Icon(Icons.manage_search),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${_targetKindLabel(context.l10n, target.kind)}：${target.label}",
                    ),
                  ),
                  onPressed: () async {
                    final selected = await showProjectObjectSelector(
                      context: context,
                      title: context.l10n.uiChooseLinkTarget,
                      allowedKinds: const {
                        ProjectObjectKind.character,
                        ProjectObjectKind.location,
                        ProjectObjectKind.event,
                        ProjectObjectKind.scene,
                      },
                    );
                    final kind = selected?.relationTargetKind;
                    if (selected == null || kind == null) return;
                    setDialogState(() {
                      target = _RelationTarget(
                        id: selected.id,
                        kind: kind,
                        label: selected.label,
                      );
                    });
                  },
                ),
                TextField(
                  onChanged: (value) => role = value,
                  decoration: appFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiRelationshipPurpose,
                    ),
                  ),
                ),
                TextField(
                  onChanged: (value) => note = value,
                  decoration: appFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiNotes,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              key: const Key("item-relation-confirm"),
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.uiAddLink),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    ref
        .read(itemWorkspaceProvider.notifier)
        .putRelation(
          ItemRelationData(
            relationId: _uuid.v4(),
            itemId: itemId,
            itemKind: itemKind,
            targetId: target.id,
            targetKind: target.kind,
            role: role.trim(),
            note: note.trim(),
          ),
        );
  }

  Future<void> _addAllocation(ItemClassData itemClass) async {
    final targets = _relationTargets()
        .where(
          (value) =>
              value.kind == ItemRelationTargetKind.character ||
              value.kind == ItemRelationTargetKind.location,
        )
        .toList(growable: false);
    if (targets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.uiCreateACharacterOrLocationBeforeAddingA),
        ),
      );
      return;
    }
    var target = targets.first;
    var quantityText = "";
    var note = "";
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.uiAddQuantityAllocation),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  style: appDropdownTextStyle(context),
                  isDense: true,
                  isExpanded: true,
                  iconSize: AppControlSize.smallIcon,
                  itemHeight: appDropdownItemHeight(context),
                  menuMaxHeight: AppControlSize.menuMaxHeight,
                  key: const Key("item-allocation-target"),
                  initialValue: "${target.kind.name}:${target.id}",
                  decoration: appDropdownFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiAllocateTo,
                    ),
                  ),
                  items: targets
                      .map(
                        (value) => DropdownMenuItem(
                          value: "${value.kind.name}:${value.id}",
                          child: Text(
                            "${_targetKindLabel(context.l10n, value.kind)}：${value.label}",
                          ),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() {
                      target = targets.firstWhere(
                        (candidate) =>
                            "${candidate.kind.name}:${candidate.id}" == value,
                      );
                    });
                  },
                ),
                TextField(
                  key: const Key("item-allocation-quantity"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => quantityText = value,
                  decoration: appFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiQuantity,
                      helperText:
                          context.l10n.uiLeaveBlankIfTheQuantityIsUnknown,
                    ),
                  ),
                ),
                TextField(
                  onChanged: (value) => note = value,
                  decoration: appFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiNotes,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              key: const Key("item-allocation-confirm"),
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.uiAddAllocation),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    final normalizedQuantity = quantityText.trim();
    final quantity = normalizedQuantity.isEmpty
        ? null
        : int.tryParse(normalizedQuantity);
    if (normalizedQuantity.isNotEmpty && (quantity == null || quantity < 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.uiQuantityMustBeZeroOrAPositiveInteger2),
        ),
      );
      return;
    }
    final allocation = ItemAllocationData(
      allocationId: _uuid.v4(),
      holderCharacterId: target.kind == ItemRelationTargetKind.character
          ? target.id
          : null,
      locationId: target.kind == ItemRelationTargetKind.location
          ? target.id
          : null,
      quantity: quantity,
      note: note.trim(),
    );
    _updateClass(
      itemClass.copyWith(
        defaultState: itemClass.defaultState.copyWith(
          allocations: [...itemClass.defaultState.allocations, allocation],
        ),
      ),
    );
  }

  void _removeAllocation(ItemClassData itemClass, String allocationId) {
    _updateClass(
      itemClass.copyWith(
        defaultState: itemClass.defaultState.copyWith(
          allocations: itemClass.defaultState.allocations
              .where((value) => value.allocationId != allocationId)
              .toList(growable: false),
        ),
      ),
    );
  }

  Future<void> _transferAllocation(
    ItemClassData itemClass,
    ItemSnapshotState currentState,
    ItemAllocationData source,
  ) async {
    final scenes = _placedScenes();
    final targets = _relationTargets()
        .where(
          (value) =>
              (value.kind == ItemRelationTargetKind.character ||
                  value.kind == ItemRelationTargetKind.location) &&
              value.id != source.holderCharacterId &&
              value.id != source.locationId,
        )
        .toList(growable: false);
    if (scenes.isEmpty || targets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.uiATransferRequiresAtLeastOneSceneAnd),
        ),
      );
      return;
    }
    var placementId = scenes.first.placementId;
    var target = targets.first;
    var quantityText = "";
    var sourceAfterText = "";
    var destinationAfterText = "";
    var note = "";
    final previewWorkspace = ref.read(itemWorkspaceProvider);
    final previewTimeline = ref.read(timelineDocumentProvider);
    ItemSnapshotState stateAt(int tick) => resolveItemClassSnapshot(
      itemClass: itemClass,
      changes: previewWorkspace.itemClassStateChanges,
      timeline: previewTimeline,
      atTick: tick,
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.uiTransferAggregateQuantity),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SceneSnapshotTimelinePreview(
                  subject: (
                    kind: SnapshotSubjectKind.itemClass,
                    id: itemClass.classId,
                  ),
                  placementUUID: placementId,
                  onPlacementSelected: (value) =>
                      setDialogState(() => placementId = value),
                ),
                AppDropdownField<String>(
                  value: placementId,
                  labelText: context.l10n.uiLinkToScene,
                  options: scenes
                      .map(
                        (scene) => DropdownOption(
                          value: scene.placementId,
                          label: scene.label,
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => placementId = value);
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  style: appDropdownTextStyle(context),
                  isDense: true,
                  isExpanded: true,
                  iconSize: AppControlSize.smallIcon,
                  itemHeight: appDropdownItemHeight(context),
                  menuMaxHeight: AppControlSize.menuMaxHeight,
                  key: const Key("item-transfer-target"),
                  initialValue: "${target.kind.name}:${target.id}",
                  decoration: appDropdownFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiTransferTo,
                    ),
                  ),
                  items: targets
                      .map(
                        (value) => DropdownMenuItem(
                          value: "${value.kind.name}:${value.id}",
                          child: Text(
                            "${_targetKindLabel(context.l10n, value.kind)}：${value.label}",
                          ),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() {
                      target = targets.firstWhere(
                        (candidate) =>
                            "${candidate.kind.name}:${candidate.id}" == value,
                      );
                    });
                  },
                ),
                TextField(
                  key: const Key("item-transfer-quantity"),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => quantityText = value,
                  decoration: appFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiQuantityToTransfer,
                    ),
                  ),
                ),
                if (source.quantity == null)
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) => sourceAfterText = value,
                    decoration: appFieldDecoration(
                      context,
                      decoration: InputDecoration(
                        labelText: context.l10n.uiSourceQuantityAfterTransfer,
                        helperText: context
                            .l10n
                            .uiSourceQuantityIsUnknownSetItExplicitly,
                      ),
                    ),
                  ),
                if (currentState.allocations.any(
                  (value) =>
                      value.quantity == null &&
                      ((target.kind == ItemRelationTargetKind.character &&
                              value.holderCharacterId == target.id) ||
                          (target.kind == ItemRelationTargetKind.location &&
                              value.locationId == target.id)),
                ))
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) => destinationAfterText = value,
                    decoration: appFieldDecoration(
                      context,
                      decoration: InputDecoration(
                        labelText:
                            context.l10n.uiDestinationQuantityAfterTransfer,
                        helperText: context
                            .l10n
                            .uiDestinationQuantityIsUnknownSetItExplicitly,
                      ),
                    ),
                  ),
                TextField(
                  onChanged: (value) => note = value,
                  decoration: appFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiNotes,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              key: const Key("item-transfer-confirm"),
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.uiCreateTransferSnapshot),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final selectedScene = scenes.firstWhere(
        (scene) => scene.placementId == placementId,
      );
      if (!_previewIsCurrent(
        workspace: previewWorkspace,
        timeline: previewTimeline,
        sceneId: selectedScene.sceneId,
        placementId: selectedScene.placementId,
        startTick: selectedScene.startTick,
      )) {
        _showStalePreviewMessage();
        return;
      }
      final result = transferAggregateItem(
        itemClass: itemClass,
        currentState: stateAt(selectedScene.startTick),
        request: AggregateItemTransferRequest(
          sourceAllocationId: source.allocationId,
          destinationCharacterId:
              target.kind == ItemRelationTargetKind.character
              ? target.id
              : null,
          destinationLocationId: target.kind == ItemRelationTargetKind.location
              ? target.id
              : null,
          quantity: int.tryParse(quantityText.trim()) ?? 0,
          sourceQuantityAfter: int.tryParse(sourceAfterText.trim()),
          destinationQuantityAfter: int.tryParse(destinationAfterText.trim()),
          destinationAllocationId: _uuid.v4(),
          sceneUUID: selectedScene.sceneId,
          sourcePlacementUUID: selectedScene.placementId,
          fallbackTick: selectedScene.startTick,
          note: note.trim(),
        ),
      );
      ref
          .read(itemWorkspaceProvider.notifier)
          .putClassStateChange(result.change);
      ref
          .read(timelineViewProvider.notifier)
          .setCurrentTick(selectedScene.startTick);
    } on ArgumentError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message?.toString() ?? "$error")),
      );
    } on StateError catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  Future<void> _materializeAllocation(
    ItemClassData itemClass,
    ItemAllocationData source, {
    ItemMode targetMode = ItemMode.semiDedicated,
  }) async {
    final scenes = _placedScenes();
    if (scenes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.uiAddTheSceneToTheTimelineBeforeSeparating,
          ),
        ),
      );
      return;
    }
    var placementId = scenes.first.placementId;
    var instanceName = itemClass.name;
    var sourceAfterText = "";
    var note = "";
    final previewWorkspace = ref.read(itemWorkspaceProvider);
    final previewTimeline = ref.read(timelineDocumentProvider);
    ItemSnapshotState stateAt(int tick) => resolveItemClassSnapshot(
      itemClass: itemClass,
      changes: previewWorkspace.itemClassStateChanges,
      timeline: previewTimeline,
      atTick: tick,
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final selectedScene = scenes.firstWhere(
            (scene) => scene.placementId == placementId,
          );
          final sceneState = stateAt(selectedScene.startTick);
          final sceneSource = sceneState.allocations
              .where((value) => value.allocationId == source.allocationId)
              .firstOrNull;
          return AlertDialog(
            title: Text(
              targetMode == ItemMode.dedicated
                  ? context.l10n.uiCreateDedicatedItem
                  : context.l10n.uiSeparateItemFromAggregateQuantity,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SceneSnapshotTimelinePreview(
                    subject: (
                      kind: SnapshotSubjectKind.itemClass,
                      id: itemClass.classId,
                    ),
                    placementUUID: placementId,
                    onPlacementSelected: (value) =>
                        setDialogState(() => placementId = value),
                  ),
                  AppDropdownField<String>(
                    value: placementId,
                    labelText: context.l10n.uiCreatedInScene,
                    options: scenes
                        .map(
                          (scene) => DropdownOption(
                            value: scene.placementId,
                            label: scene.label,
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => placementId = value);
                      }
                    },
                  ),
                  Text(
                    sceneSource == null
                        ? context
                              .l10n
                              .uiThisAggregateAllocationDoesNotExistInThe
                        : sceneSource.quantity == null
                        ? context
                              .l10n
                              .uiSourceQuantityIsUnknownInTheSelectedScene
                        : context.l10n.uiSourceQuantityInSelectedScene(
                            (sceneSource.quantity).toString(),
                          ),
                    key: const Key("item-materialize-preview"),
                  ),
                  TextFormField(
                    key: const Key("item-materialize-name"),
                    initialValue: instanceName,
                    onChanged: (value) => instanceName = value,
                    decoration: appFieldDecoration(
                      context,
                      decoration: InputDecoration(
                        labelText: context.l10n.uiIndividualItemName,
                      ),
                    ),
                  ),
                  if (sceneSource?.quantity == null && sceneSource != null)
                    TextField(
                      key: const Key("item-materialize-source-after"),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => sourceAfterText = value,
                      decoration: appFieldDecoration(
                        context,
                        decoration: InputDecoration(
                          labelText:
                              context.l10n.uiSourceQuantityAfterSeparation,
                          helperText: context
                              .l10n
                              .uiSourceQuantityIsUnknownSetItExplicitly,
                        ),
                      ),
                    ),
                  TextField(
                    key: const Key("item-materialize-note"),
                    onChanged: (value) => note = value,
                    decoration: appFieldDecoration(
                      context,
                      decoration: InputDecoration(
                        labelText: context.l10n.uiConversionNotes,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.commonCancel),
              ),
              FilledButton(
                key: const Key("item-materialize-confirm"),
                onPressed: sceneSource == null
                    ? null
                    : () => Navigator.pop(context, true),
                child: Text(context.l10n.uiCreateIndividualItem),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final selectedScene = scenes.firstWhere(
        (scene) => scene.placementId == placementId,
      );
      if (!_previewIsCurrent(
        workspace: previewWorkspace,
        timeline: previewTimeline,
        sceneId: selectedScene.sceneId,
        placementId: selectedScene.placementId,
        startTick: selectedScene.startTick,
      )) {
        _showStalePreviewMessage();
        return;
      }
      final conversionId = _uuid.v4();
      final result = materializeAggregateItem(
        itemClass: itemClass,
        currentState: stateAt(selectedScene.startTick),
        request: AggregateItemMaterializationRequest(
          sourceAllocationId: source.allocationId,
          sourceQuantityAfter: int.tryParse(sourceAfterText.trim()),
          instanceId: _uuid.v4(),
          instanceName: instanceName,
          sceneUUID: selectedScene.sceneId,
          sourcePlacementUUID: selectedScene.placementId,
          fallbackTick: selectedScene.startTick,
          conversionId: conversionId,
          note: note.trim(),
          targetMode: targetMode,
        ),
      );
      ref
          .read(itemWorkspaceProvider.notifier)
          .materializeAggregateInstance(
            itemClass: result.itemClass,
            instance: result.instance,
            classChange: result.classChange,
            instanceChange: result.instanceChange,
          );
      ref
          .read(timelineViewProvider.notifier)
          .setCurrentTick(selectedScene.startTick);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.uiCreatedAnIndividualItemFromTheAggregateQuantity,
          ),
        ),
      );
    } on ArgumentError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message?.toString() ?? "$error")),
      );
    } on StateError catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  Future<void> _demoteToGeneric(
    ItemClassData itemClass,
    List<ItemInstanceData> instances,
  ) async {
    final scenes = _placedScenes();
    if (scenes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.uiAddTheSceneToTheTimelineBeforeConverting,
          ),
        ),
      );
      return;
    }
    var placementId = scenes.first.placementId;
    var note = "";
    final workspace = ref.read(itemWorkspaceProvider);
    final timeline = ref.read(timelineDocumentProvider);
    List<ItemSnapshotState> statesAt(int tick) => instances
        .map(
          (instance) => resolveItemInstanceSnapshot(
            itemClass: itemClass,
            instance: instance,
            classChanges: workspace.itemClassStateChanges,
            instanceChanges: workspace.itemInstanceStateChanges,
            timeline: timeline,
            atTick: tick,
          ),
        )
        .toList(growable: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final selectedScene = scenes.firstWhere(
            (scene) => scene.placementId == placementId,
          );
          final activeStates = statesAt(
            selectedScene.startTick,
          ).where((state) => state.exists).toList(growable: false);
          final groupedTargets = activeStates
              .map(
                (state) =>
                    "${state.holderCharacterId ?? ""}|${state.locationId ?? ""}",
              )
              .toSet();
          return AlertDialog(
            title: Text(context.l10n.uiSafelyConvertToNonDedicated),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SceneSnapshotTimelinePreview(
                    subject: (
                      kind: SnapshotSubjectKind.itemClass,
                      id: itemClass.classId,
                    ),
                    placementUUID: placementId,
                    onPlacementSelected: (value) =>
                        setDialogState(() => placementId = value),
                  ),
                  AppDropdownField<String>(
                    value: placementId,
                    labelText: context.l10n.uiConversionScene,
                    options: scenes
                        .map(
                          (scene) => DropdownOption(
                            value: scene.placementId,
                            label: scene.label,
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => placementId = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n
                        .uiAggregateExistingIndividualItemsIntoQuantityAllocations(
                          context.formats.integer(activeStates.length),
                          context.formats.integer(groupedTargets.length),
                        ),
                    key: const Key("item-demotion-preview"),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context
                        .l10n
                        .uiTheOriginalClassInstanceIDsSnapshotsAndGeneral,
                  ),
                  TextField(
                    key: const Key("item-demotion-note"),
                    onChanged: (value) => note = value,
                    decoration: appFieldDecoration(
                      context,
                      decoration: InputDecoration(
                        labelText: context.l10n.uiConversionNotes,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.commonCancel),
              ),
              FilledButton(
                key: const Key("item-demotion-confirm"),
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.l10n.uiCreateAggregateClass),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed != true || !mounted) return;
    final selectedScene = scenes.firstWhere(
      (scene) => scene.placementId == placementId,
    );
    if (!_previewIsCurrent(
      workspace: workspace,
      timeline: timeline,
      sceneId: selectedScene.sceneId,
      placementId: selectedScene.placementId,
      startTick: selectedScene.startTick,
    )) {
      _showStalePreviewMessage();
      return;
    }
    final currentStates = <String, ItemSnapshotState>{};
    final states = statesAt(selectedScene.startTick);
    for (var index = 0; index < instances.length; index++) {
      currentStates[instances[index].instanceId] = states[index];
    }
    try {
      final currentClassState = resolveItemClassSnapshot(
        itemClass: itemClass,
        changes: workspace.itemClassStateChanges,
        timeline: timeline,
        atTick: selectedScene.startTick,
      );
      final result = demoteIdentifiedItems(
        itemClass: itemClass,
        instances: instances,
        currentClassState: currentClassState,
        currentStates: currentStates,
        request: IdentifiedItemDemotionRequest(
          targetClassId: _uuid.v4(),
          sceneUUID: selectedScene.sceneId,
          sourcePlacementUUID: selectedScene.placementId,
          fallbackTick: selectedScene.startTick,
          conversionId: _uuid.v4(),
          note: note.trim(),
        ),
      );
      ref
          .read(itemWorkspaceProvider.notifier)
          .demoteIdentifiedClass(
            sourceClass: result.sourceClass,
            sourceInstances: result.sourceInstances,
            targetClass: result.targetClass,
            sourceClassChange: result.sourceClassChange,
            targetClassChange: result.targetClassChange,
            sourceInstanceChanges: result.sourceInstanceChanges,
          );
      ref
          .read(timelineViewProvider.notifier)
          .setCurrentTick(selectedScene.startTick);
      setState(() {
        _selectedClassId = result.targetClass.classId;
        _selectedClassSnapshotId = result.targetClassChange.stateChangeId;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.uiCreatedANewNonDedicatedAggregateClass),
        ),
      );
    } on ArgumentError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message?.toString() ?? "$error")),
      );
    } on StateError catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  Future<void> _changeMode(
    ItemClassData itemClass,
    ItemMode mode,
    List<ItemInstanceData> instances,
  ) async {
    if (mode == ItemMode.generic && itemClass.mode != ItemMode.generic) {
      final notifier = ref.read(itemWorkspaceProvider.notifier);
      if (notifier.canChangeToGenericDirectly(itemClass.classId)) {
        notifier.changeClassMode(classId: itemClass.classId, mode: mode);
        return;
      }
      await _demoteToGeneric(itemClass, instances);
      return;
    }
    if (itemClass.mode == ItemMode.generic &&
        mode == ItemMode.dedicated &&
        instances.isEmpty) {
      final tick = ref.read(timelineViewProvider).currentTick;
      final currentState = ref.read(
        itemClassSnapshotProvider((id: itemClass.classId, tick: tick)),
      );
      final sources =
          currentState?.allocations
              .where(
                (allocation) =>
                    allocation.quantity == null || allocation.quantity! > 0,
              )
              .toList(growable: false) ??
          const <ItemAllocationData>[];
      if (sources.isNotEmpty) {
        if (sources.length != 1 ||
            (sources.single.quantity != null && sources.single.quantity != 1)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context
                    .l10n
                    .uiConvertingToDedicatedModeRequiresOneAllocationWith,
              ),
            ),
          );
          return;
        }
        await _materializeAllocation(
          itemClass,
          sources.single,
          targetMode: ItemMode.dedicated,
        );
        return;
      }
    }
    if (itemClass.mode == ItemMode.semiDedicated &&
        mode == ItemMode.dedicated) {
      if (instances.length > 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.uiMultipleFixedIDsCannotBeMergedDirectlyInto,
            ),
          ),
        );
        return;
      }
      final tick = ref.read(timelineViewProvider).currentTick;
      final currentState = ref.read(
        itemClassSnapshotProvider((id: itemClass.classId, tick: tick)),
      );
      final remainingStock =
          currentState?.allocations.any(
            (allocation) =>
                allocation.quantity == null || allocation.quantity! > 0,
          ) ??
          false;
      if (remainingStock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context
                  .l10n
                  .uiSeparateAllRemainingAggregateQuantitiesBeforeConvertingTo,
            ),
          ),
        );
        return;
      }
    }
    try {
      ref
          .read(itemWorkspaceProvider.notifier)
          .changeClassMode(
            classId: itemClass.classId,
            mode: mode,
            dedicatedInstanceId: _uuid.v4(),
          );
    } on ArgumentError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message?.toString() ?? "$error")),
      );
    } on StateError catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  Future<void> _migrateWorldItems() async {
    final worldNodes = ref.read(worldSettingsDataProvider);
    final count = countWorldItemNodes(worldNodes);
    if (count == 0) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.uiMoveWorldbuildingItems),
        content: Text(
          context.l10n.uiMoveWorldbuildingItemsToTheItemsPageIDs(
            (count).toString(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.uiMove),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final workspace = ref.read(itemWorkspaceProvider);
    final result = migrateWorldItems(
      worldNodes: worldNodes,
      existingClasses: workspace.itemClasses,
      existingInstances: workspace.itemInstances,
    );
    ref
        .read(worldSettingsDataProvider.notifier)
        .setWorldSettingsData(result.worldNodes);
    ref
        .read(itemWorkspaceProvider.notifier)
        .setWorkspace(
          workspace.copyWith(
            itemClasses: result.itemClasses,
            itemInstances: result.itemInstances,
          ),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.uiMovedItems(
            (result.migratedCount).toString(),
            (result.warnings.isEmpty
                    ? ""
                    : context.l10n.uiNeedAttention(
                        context.formats.integer(result.warnings.length),
                      ))
                .toString(),
          ),
        ),
      ),
    );
  }

  Future<void> _addClassSnapshot(
    ItemClassData itemClass, {
    ItemSnapshotState? sourceState,
  }) async {
    final scenes = _placedScenes();
    if (scenes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.uiAddTheSceneToTheTimelineBeforeAdding),
        ),
      );
      return;
    }
    var placementId = nearestSceneChoice(
      scenes,
      ref.read(timelineViewProvider).currentTick,
      (scene) => scene.startTick,
    )!.placementId;
    var exists = sourceState?.exists ?? true;
    var status = sourceState?.status ?? "";
    String? holderCharacterId = sourceState?.holderCharacterId;
    String? locationId = sourceState?.locationId;
    final characters = _relationTargets()
        .where((value) => value.kind == ItemRelationTargetKind.character)
        .toList(growable: false);
    final locations = _relationTargets()
        .where((value) => value.kind == ItemRelationTargetKind.location)
        .toList(growable: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            sourceState == null
                ? context.l10n.uiAddItemSceneSnapshot
                : context.l10n.uiDuplicateItemSceneSnapshot,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SceneSnapshotTimelinePreview(
                  subject: (
                    kind: SnapshotSubjectKind.itemClass,
                    id: itemClass.classId,
                  ),
                  placementUUID: placementId,
                  onPlacementSelected: (value) =>
                      setDialogState(() => placementId = value),
                ),
                AppDropdownField<String>(
                  value: placementId,
                  labelText: context.l10n.uiLinkToScene,
                  options: scenes
                      .map(
                        (scene) => DropdownOption(
                          value: scene.placementId,
                          label: scene.label,
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => placementId = value);
                    }
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.l10n.uiExistsAtThisPoint),
                  value: exists,
                  onChanged: (value) => setDialogState(() => exists = value),
                ),
                TextFormField(
                  initialValue: status,
                  onChanged: (value) => status = value,
                  decoration: appFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiStatus,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  style: appDropdownTextStyle(context),
                  isDense: true,
                  isExpanded: true,
                  iconSize: AppControlSize.smallIcon,
                  itemHeight: appDropdownItemHeight(context),
                  menuMaxHeight: AppControlSize.menuMaxHeight,
                  key: const Key("item-class-snapshot-holder"),
                  initialValue: holderCharacterId ?? "",
                  decoration: appDropdownFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiHolder,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "",
                      child: Text(context.l10n.uiNotSet),
                    ),
                    if (holderCharacterId != null &&
                        !characters.any(
                          (value) => value.id == holderCharacterId,
                        ))
                      DropdownMenuItem(
                        value: holderCharacterId,
                        child: Text(
                          context.l10n.uiNotFound(
                            (holderCharacterId).toString(),
                          ),
                        ),
                      ),
                    for (final character in characters)
                      DropdownMenuItem(
                        value: character.id,
                        child: Text(character.label),
                      ),
                  ],
                  onChanged: (value) =>
                      holderCharacterId = value?.isEmpty == true ? null : value,
                ),
                DropdownButtonFormField<String>(
                  style: appDropdownTextStyle(context),
                  isDense: true,
                  isExpanded: true,
                  iconSize: AppControlSize.smallIcon,
                  itemHeight: appDropdownItemHeight(context),
                  menuMaxHeight: AppControlSize.menuMaxHeight,
                  key: const Key("item-class-snapshot-location"),
                  initialValue: locationId ?? "",
                  decoration: appDropdownFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiLocation2,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "",
                      child: Text(context.l10n.uiNotSet),
                    ),
                    if (locationId != null &&
                        !locations.any((value) => value.id == locationId))
                      DropdownMenuItem(
                        value: locationId,
                        child: Text(
                          context.l10n.uiNotFound((locationId).toString()),
                        ),
                      ),
                    for (final location in locations)
                      DropdownMenuItem(
                        value: location.id,
                        child: Text(location.label),
                      ),
                  ],
                  onChanged: (value) =>
                      locationId = value?.isEmpty == true ? null : value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                sourceState == null
                    ? context.l10n.uiAddSnapshot
                    : context.l10n.uiDuplicateSnapshot,
              ),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    final selectedScene = scenes.firstWhere(
      (scene) => scene.placementId == placementId,
    );
    final change = ItemClassStateChange(
      classId: itemClass.classId,
      sequence: ref
          .read(itemWorkspaceProvider)
          .itemClassStateChanges
          .where((change) => change.classId == itemClass.classId)
          .fold<int>(
            0,
            (next, change) =>
                change.sequence >= next ? change.sequence + 1 : next,
          ),
      sceneUUID: selectedScene.sceneId,
      sourcePlacementUUID: selectedScene.placementId,
      fallbackTick: selectedScene.startTick,
      patch: sourceState == null
          ? ItemStatePatch(
              exists: StateValue.set(exists),
              status: StateValue.set(status),
              holderCharacterId: StateValue<String?>.set(holderCharacterId),
              locationId: StateValue<String?>.set(locationId),
            )
          : ItemStatePatch.fromState(
              sourceState.copyWith(
                exists: exists,
                status: status,
                holderCharacterId: holderCharacterId,
                locationId: locationId,
              ),
            ),
    );
    ref.read(itemWorkspaceProvider.notifier).putClassStateChange(change);
    setState(() {
      _classPreviewModes[itemClass.classId] =
          SnapshotPreviewMode.followTimeline;
      _selectedClassSnapshotId = change.stateChangeId;
    });
    ref
        .read(timelineViewProvider.notifier)
        .setCurrentTick(selectedScene.startTick);
  }

  Future<void> _addInstanceSnapshot(
    ItemInstanceData instance, {
    ItemSnapshotState? sourceState,
  }) async {
    final scenes = _placedScenes();
    if (scenes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.uiAddTheSceneToTheTimelineBeforeAdding2),
        ),
      );
      return;
    }
    var placementId = nearestSceneChoice(
      scenes,
      ref.read(timelineViewProvider).currentTick,
      (scene) => scene.startTick,
    )!.placementId;
    var exists = sourceState?.exists ?? true;
    var status = sourceState?.status ?? "";
    String? holderCharacterId = sourceState?.holderCharacterId;
    String? locationId = sourceState?.locationId;
    final characters = _relationTargets()
        .where((value) => value.kind == ItemRelationTargetKind.character)
        .toList(growable: false);
    final locations = _relationTargets()
        .where((value) => value.kind == ItemRelationTargetKind.location)
        .toList(growable: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            context.l10n.uiSceneSnapshot(
              (sourceState == null
                      ? context.l10n.commonAdd
                      : context.l10n.commonCopy)
                  .toString(),
              (instance.name).toString(),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SceneSnapshotTimelinePreview(
                  subject: (
                    kind: SnapshotSubjectKind.itemInstance,
                    id: instance.instanceId,
                  ),
                  placementUUID: placementId,
                  onPlacementSelected: (value) =>
                      setDialogState(() => placementId = value),
                ),
                AppDropdownField<String>(
                  value: placementId,
                  labelText: context.l10n.uiLinkToScene,
                  options: scenes
                      .map(
                        (scene) => DropdownOption(
                          value: scene.placementId,
                          label: scene.label,
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => placementId = value);
                    }
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.l10n.uiExistsAtThisPoint),
                  value: exists,
                  onChanged: (value) => setDialogState(() => exists = value),
                ),
                TextFormField(
                  initialValue: status,
                  onChanged: (value) => status = value,
                  decoration: appFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiStatus,
                    ),
                  ),
                ),
                DropdownButtonFormField<String>(
                  style: appDropdownTextStyle(context),
                  isDense: true,
                  isExpanded: true,
                  iconSize: AppControlSize.smallIcon,
                  itemHeight: appDropdownItemHeight(context),
                  menuMaxHeight: AppControlSize.menuMaxHeight,
                  key: const Key("item-instance-snapshot-holder"),
                  initialValue: holderCharacterId ?? "",
                  decoration: appDropdownFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiHolder,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "",
                      child: Text(context.l10n.uiNotSet),
                    ),
                    if (holderCharacterId != null &&
                        !characters.any(
                          (value) => value.id == holderCharacterId,
                        ))
                      DropdownMenuItem(
                        value: holderCharacterId,
                        child: Text(
                          context.l10n.uiNotFound(
                            (holderCharacterId).toString(),
                          ),
                        ),
                      ),
                    for (final character in characters)
                      DropdownMenuItem(
                        value: character.id,
                        child: Text(character.label),
                      ),
                  ],
                  onChanged: (value) =>
                      holderCharacterId = value?.isEmpty == true ? null : value,
                ),
                DropdownButtonFormField<String>(
                  style: appDropdownTextStyle(context),
                  isDense: true,
                  isExpanded: true,
                  iconSize: AppControlSize.smallIcon,
                  itemHeight: appDropdownItemHeight(context),
                  menuMaxHeight: AppControlSize.menuMaxHeight,
                  key: const Key("item-instance-snapshot-location"),
                  initialValue: locationId ?? "",
                  decoration: appDropdownFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiLocation2,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "",
                      child: Text(context.l10n.uiNotSet),
                    ),
                    if (locationId != null &&
                        !locations.any((value) => value.id == locationId))
                      DropdownMenuItem(
                        value: locationId,
                        child: Text(
                          context.l10n.uiNotFound((locationId).toString()),
                        ),
                      ),
                    for (final location in locations)
                      DropdownMenuItem(
                        value: location.id,
                        child: Text(location.label),
                      ),
                  ],
                  onChanged: (value) =>
                      locationId = value?.isEmpty == true ? null : value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              key: const Key("item-instance-snapshot-confirm"),
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                sourceState == null
                    ? context.l10n.uiAddSnapshot
                    : context.l10n.uiDuplicateSnapshot,
              ),
            ),
          ],
        ),
      ),
    );
    if (confirmed != true || !mounted) return;
    final selectedScene = scenes.firstWhere(
      (scene) => scene.placementId == placementId,
    );
    final change = ItemInstanceStateChange(
      instanceId: instance.instanceId,
      sequence: ref
          .read(itemWorkspaceProvider)
          .itemInstanceStateChanges
          .where((change) => change.instanceId == instance.instanceId)
          .fold<int>(
            0,
            (next, change) =>
                change.sequence >= next ? change.sequence + 1 : next,
          ),
      sceneUUID: selectedScene.sceneId,
      sourcePlacementUUID: selectedScene.placementId,
      fallbackTick: selectedScene.startTick,
      patch: sourceState == null
          ? ItemStatePatch(
              exists: StateValue.set(exists),
              status: StateValue.set(status.trim()),
              holderCharacterId: StateValue<String?>.set(holderCharacterId),
              locationId: StateValue<String?>.set(locationId),
            )
          : ItemStatePatch.fromState(
              sourceState.copyWith(
                exists: exists,
                status: status.trim(),
                holderCharacterId: holderCharacterId,
                locationId: locationId,
              ),
            ),
    );
    ref.read(itemWorkspaceProvider.notifier).putInstanceStateChange(change);
    setState(() {
      _selectedInstanceSnapshotIds[instance.instanceId] = change.stateChangeId;
      _instancePreviewModes[instance.instanceId] =
          SnapshotPreviewMode.followTimeline;
    });
    ref
        .read(timelineViewProvider.notifier)
        .setCurrentTick(selectedScene.startTick);
  }

  @override
  Widget build(BuildContext context) {
    final workspace = ref.watch(itemWorkspaceProvider);
    final query = _searchController.text.trim().toLowerCase();
    final tick = ref.watch(
      timelineViewProvider.select((state) => state.currentTick),
    );
    final categories =
        workspace.itemClasses.values
            .where(
              (value) => !value.archived && value.category.trim().isNotEmpty,
            )
            .map((value) => value.category.trim())
            .toSet()
            .toList()
          ..sort();
    final classes =
        workspace.itemClasses.values
            .where((value) => !value.archived)
            .where(
              (value) =>
                  query.isEmpty ||
                  value.name.toLowerCase().contains(query) ||
                  value.category.toLowerCase().contains(query),
            )
            .where(
              (value) =>
                  _modeFilter == _allFilter || value.mode.name == _modeFilter,
            )
            .where(
              (value) =>
                  _categoryFilter == _allFilter ||
                  value.category.trim() == _categoryFilter,
            )
            .where((value) {
              if (_assignmentFilter == _allFilter) return true;
              final assigned = _isAssignedAtTick(
                itemClass: value,
                workspace: workspace,
                tick: tick,
              );
              return _assignmentFilter == "assigned" ? assigned : !assigned;
            })
            .toList(growable: false)
          ..sort((a, b) => a.name.compareTo(b.name));
    final selected = workspace.itemClasses[_selectedClassId];
    final worldItemCount = countWorldItemNodes(
      ref.watch(worldSettingsDataProvider),
    );

    return Scaffold(
      body: AppPagePadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                LargeTitle(
                  icon: Icons.inventory_2_outlined,
                  text: context.l10n.uiItemSettings,
                ),
                const Spacer(),
                if (worldItemCount > 0)
                  NeonIconButton(
                    key: const Key("item-migrate-world"),
                    label: context.l10n.uiMoveItemsFromWorldbuilding(
                      (worldItemCount).toString(),
                    ),
                    onPressed: _migrateWorldItems,
                    icon: Icons.move_down_outlined,
                  ),
                NeonIconButton(
                  key: const Key("item-add-class"),
                  label: context.l10n.uiAddItem,
                  onPressed: _createClass,
                  icon: Icons.add_circle_outline,
                  accent: NeonAccent.green,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final listHeight = (constraints.maxHeight * 0.62)
                      .clamp(420.0, 560.0)
                      .toDouble();
                  return Scrollbar(
                    controller: _pageScrollController,
                    child: SingleChildScrollView(
                      key: const Key("item-narrow-sections"),
                      padding: MobileModuleInsets.scrollPaddingOf(context),
                      controller: _pageScrollController,
                      primary: false,
                      child: SnapshotWorkspaceLayout(
                        collection: SizedBox(
                          height: listHeight,
                          child: _buildClassList(
                            classes,
                            categories,
                            workspace,
                            tick,
                          ),
                        ),
                        timeline: selected == null
                            ? SnapshotPanelCard(
                                key: ValueKey("item-snapshot-card"),
                                child: AppEmptyState(
                                  title: context.l10n.uiSelectAnItemFirst,
                                  description: context
                                      .l10n
                                      .uiSelectAnItemToPreviewItsTimelineAnd,
                                  icon: Icons.inventory_2_outlined,
                                  compact: true,
                                ),
                              )
                            : _buildItemSnapshotCard(selected, workspace),
                        details: SizedBox(
                          height: constraints.maxHeight,
                          child: selected == null
                              ? _buildEmptyDetails()
                              : _buildDetailsSection(selected, workspace),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassList(
    List<ItemClassData> classes,
    List<String> categories,
    ItemWorkspaceData workspace,
    int tick,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MediumTitle(
          icon: Icons.inventory_2_outlined,
          text: context.l10n.uiItemList,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: appFieldDecoration(
            context,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: context.l10n.uiSearchItems,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppDropdownField<String>(
                      key: const Key("item-mode-filter"),
                      value: _modeFilter,
                      labelText: context.l10n.uiManagementMode,
                      options: [
                        DropdownOption(
                          value: _allFilter,
                          label: context.l10n.uiAll,
                        ),
                        for (final mode in ItemMode.values)
                          DropdownOption(
                            value: mode.name,
                            label: _modeLabel(context.l10n, mode),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => _modeFilter = value ?? _allFilter),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppDropdownField<String>(
                      key: const Key("item-assignment-filter"),
                      value: _assignmentFilter,
                      labelText: context.l10n.uiOwnership,
                      options: [
                        DropdownOption(
                          value: _allFilter,
                          label: context.l10n.uiAll,
                        ),
                        DropdownOption(
                          value: "assigned",
                          label: context.l10n.uiAssigned,
                        ),
                        DropdownOption(
                          value: "unassigned",
                          label: context.l10n.uiUnassigned,
                        ),
                      ],
                      onChanged: (value) => setState(
                        () => _assignmentFilter = value ?? _allFilter,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppDropdownField<String>(
                key: const Key("item-category-filter"),
                value: _categoryFilter,
                labelText: context.l10n.uiCategory,
                options: [
                  DropdownOption(
                    value: _allFilter,
                    label: context.l10n.uiAllCategories,
                  ),
                  for (final category in categories)
                    DropdownOption(value: category, label: category),
                ],
                onChanged: (value) =>
                    setState(() => _categoryFilter = value ?? _allFilter),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => CollectionPanel.builder(
              key: const Key("item-class-collection"),
              title: context.l10n.uiItemList,
              showSectionCard: false,
              minHeight: constraints.maxHeight,
              maxHeight: constraints.maxHeight,
              controller: _classListScrollController,
              showScrollbar: true,
              itemCount: classes.length,
              emptyTitle: context.l10n.uiNoItemsYet,
              emptyDescription: context.l10n.uiAddYourFirstItem,
              emptyIcon: Icons.inventory_2_outlined,
              itemBuilder: (context, index) {
                final itemClass = classes[index];
                final instanceCount = workspace.itemInstances.values
                    .where(
                      (instance) =>
                          instance.classId == itemClass.classId &&
                          !instance.archived,
                    )
                    .length;
                final relationCount = workspace.itemRelations
                    .where(
                      (relation) =>
                          relation.itemKind == ItemReferenceKind.itemClass &&
                          relation.itemId == itemClass.classId,
                    )
                    .length;
                final assigned = _isAssignedAtTick(
                  itemClass: itemClass,
                  workspace: workspace,
                  tick: tick,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppListStyle.cardGap),
                  child: AppListCard(
                    key: ValueKey("item-class-row-${itemClass.classId}"),
                    selected: itemClass.classId == _selectedClassId,
                    leading: Icon(
                      _modeIcon(itemClass.mode),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      itemClass.name.trim().isEmpty
                          ? context.l10n.uiUnnamedItem
                          : itemClass.name,
                    ),
                    subtitle: Text(
                      context.l10n.uiIndividualItemsLinks(
                        (_modeLabel(context.l10n, itemClass.mode)).toString(),
                        (instanceCount).toString(),
                        (relationCount).toString(),
                        (assigned ? context.l10n.uiAssigned2 : "").toString(),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RevisionRecordMarker(
                          recordKey: ProjectRecordKey(
                            kind: ProjectRecordKind.itemClass,
                            recordId: itemClass.classId,
                          ),
                        ),
                        ItemActionBar.editDelete(
                          useNeonStyle: true,
                          editTooltip: context.l10n.uiEditItem,
                          deleteTooltip: context.l10n.uiArchiveItem,
                          onEdit: () => _selectClass(itemClass.classId),
                          onDelete: () => _archiveClass(itemClass, workspace),
                        ),
                      ],
                    ),
                    onTap: () => _selectClass(itemClass.classId),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        AddItemInput(
          useNeonStyle: true,
          title: context.l10n.uiItem,
          onAdd: _createClass,
        ),
      ],
    );
  }

  void _selectClass(String classId) {
    setState(() {
      _selectedClassId = classId;
      _selectedClassSnapshotId = null;
      _selectedInstanceSnapshotIds.clear();
    });
  }

  Widget _buildEmptyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MediumTitle(icon: Icons.info_outline, text: context.l10n.uiItemDetails),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: _detailPanelDecoration(context),
            child: Material(
              type: MaterialType.transparency,
              child: AppEmptyState(
                title: context.l10n.uiSelectOrAddAnItem,
                description:
                    context.l10n.uiItemModeSnapshotsOwnershipAndLinksAppearHere,
                icon: Icons.inventory_2_outlined,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(
    ItemClassData itemClass,
    ItemWorkspaceData workspace,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MediumTitle(icon: Icons.info_outline, text: context.l10n.uiItemDetails),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            decoration: _detailPanelDecoration(context),
            child: Material(
              type: MaterialType.transparency,
              child: _buildDetails(itemClass, workspace),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _detailPanelDecoration(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return BoxDecoration(
      border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
      borderRadius: AppSurfaceShape.borderRadius,
      color: scheme.surfaceContainerLowest,
    );
  }

  Widget _markedItemClassField(String classId, String field, Widget input) =>
      Row(
        children: [
          Expanded(child: input),
          RevisionFieldMarker(
            recordKey: ProjectRecordKey(
              kind: ProjectRecordKind.itemClass,
              recordId: classId,
            ),
            field: field,
          ),
        ],
      );

  Widget _buildItemSnapshotCard(
    ItemClassData itemClass,
    ItemWorkspaceData workspace,
  ) {
    final instances = workspace.itemInstances.values
        .where((value) => value.classId == itemClass.classId && !value.archived)
        .toList(growable: false);
    final tick = ref.watch(timelineViewProvider).currentTick;
    final previewMode =
        _classPreviewModes[itemClass.classId] ?? SnapshotPreviewMode.baseline;
    final snapshot = previewMode == SnapshotPreviewMode.baseline
        ? itemClass.defaultState
        : ref.watch(
            itemClassSnapshotProvider((id: itemClass.classId, tick: tick)),
          );
    final targetLabels = {
      for (final target in _relationTargets())
        "${target.kind.name}:${target.id}": target.label,
    };
    final sceneLabels = _sceneLabels();
    final classChanges = orderedItemClassStateChanges(
      classId: itemClass.classId,
      changes: workspace.itemClassStateChanges,
      timeline: ref.watch(timelineDocumentProvider),
    ).reversed.map((entry) => entry.change).toList(growable: false);
    final selectedSnapshotChange = classChanges
        .where((change) => change.stateChangeId == _selectedClassSnapshotId)
        .firstOrNull;

    return SnapshotPanelCard(
      key: const ValueKey("item-snapshot-card"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SnapshotTimelinePreview(
            key: ValueKey("item-class-snapshot-preview-${itemClass.classId}"),
            subject: (
              kind: SnapshotSubjectKind.itemClass,
              id: itemClass.classId,
            ),
            mode: previewMode,
            autoSelectAtTick: true,
            selectedEventId: _selectedClassSnapshotId == null
                ? null
                : "itemClass:$_selectedClassSnapshotId",
            onModeChanged: (value) =>
                setState(() => _classPreviewModes[itemClass.classId] = value),
            onEventSelected: (event) =>
                setState(() => _selectedClassSnapshotId = event?.sourceId),
            snapshotActionsBuilder: (event) => [
              NeonIconButton(
                key: const Key("item-add-snapshot"),
                label: context.l10n.uiAddSceneSnapshot,
                onPressed: () => _addClassSnapshot(itemClass),
                icon: Icons.add_photo_alternate_outlined,
                accent: NeonAccent.green,
              ),
              NeonIconButton(
                key: const Key("item-copy-snapshot"),
                label: context.l10n.uiDuplicateSnapshot,
                icon: Icons.copy_all_outlined,
                onPressed: () => _addClassSnapshot(
                  itemClass,
                  sourceState: event == null
                      ? snapshot ?? itemClass.defaultState
                      : resolveItemClassSnapshot(
                          itemClass: itemClass,
                          changes: workspace.itemClassStateChanges,
                          timeline: ref.read(timelineDocumentProvider),
                          atTick: event.tick,
                          throughStateChangeId: event.sourceId,
                        ),
                ),
              ),
              NeonIconButton(
                key: const Key("item-delete-selected-snapshot"),
                label: context.l10n.uiDeleteCurrentSnapshot,
                onPressed: selectedSnapshotChange == null
                    ? null
                    : () {
                        ref
                            .read(itemWorkspaceProvider.notifier)
                            .removeClassStateChange(
                              selectedSnapshotChange.stateChangeId,
                            );
                        setState(() => _selectedClassSnapshotId = null);
                      },
                icon: Icons.delete_outline,
                destructive: true,
                statusLabel: selectedSnapshotChange == null
                    ? context.l10n.uiNoSnapshotSelected
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.movie_outlined),
              title: Text(context.l10n.uiCurrentStoryState),
              subtitle: Text(
                snapshot == null
                    ? context.l10n.uiNoSnapshots
                    : [
                        snapshot.exists
                            ? context.l10n.uiExists
                            : context.l10n.uiDoesNotExistYet,
                        snapshot.status.isEmpty
                            ? context.l10n.uiStateNotSet
                            : snapshot.status,
                        if (snapshot.holderCharacterId != null)
                          context.l10n.uiHolder2(
                            (targetLabels["${ItemRelationTargetKind.character.name}:${snapshot.holderCharacterId}"] ??
                                    snapshot.holderCharacterId)
                                .toString(),
                          ),
                        if (snapshot.locationId != null)
                          context.l10n.uiLocation3(
                            (targetLabels["${ItemRelationTargetKind.location.name}:${snapshot.locationId}"] ??
                                    snapshot.locationId)
                                .toString(),
                          ),
                      ].join(context.l10n.uiLiteral),
              ),
            ),
          ),
          if (classChanges.isNotEmpty)
            ExpansionTile(
              key: const Key("item-class-snapshot-history"),
              leading: const Icon(Icons.history),
              title: Text(
                context.l10n.uiSnapshotHistory(
                  context.formats.integer(classChanges.length),
                ),
              ),
              children: classChanges
                  .map(
                    (change) => ListTile(
                      key: ValueKey(
                        "item-class-snapshot-${change.stateChangeId}",
                      ),
                      title: Text(
                        sceneLabels[change.sceneUUID] ?? change.sceneUUID,
                      ),
                      subtitle: Text(
                        change.patch.status?.value?.isNotEmpty == true
                            ? change.patch.status!.value!
                            : context.l10n.uiLinkThisScene,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RevisionRecordMarker(
                            recordKey: ProjectRecordKey(
                              kind: ProjectRecordKind.itemClassStateChange,
                              recordId: change.stateChangeId,
                            ),
                          ),
                          NeonIconButton(
                            label: context.l10n.uiRemoveSnapshot,
                            onPressed: () => ref
                                .read(itemWorkspaceProvider.notifier)
                                .removeClassStateChange(change.stateChangeId),
                            icon: Icons.delete_outline,
                            destructive: true,
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          const SizedBox(height: AppSpacing.md),
          if (itemClass.mode != ItemMode.generic)
            ...instances.map((instance) {
              final instanceMode =
                  _instancePreviewModes[instance.instanceId] ??
                  SnapshotPreviewMode.baseline;
              final changes = orderedItemInstanceStateChanges(
                instanceId: instance.instanceId,
                changes: workspace.itemInstanceStateChanges,
                timeline: ref.watch(timelineDocumentProvider),
              ).reversed.map((entry) => entry.change).toList(growable: false);
              final selectedChange = changes
                  .where(
                    (change) =>
                        change.stateChangeId ==
                        _selectedInstanceSnapshotIds[instance.instanceId],
                  )
                  .firstOrNull;

              return ExpansionTile(
                key: ValueKey("item-instance-${instance.instanceId}"),
                leading: const Icon(Icons.inventory_2_outlined),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        instance.name.isEmpty ? itemClass.name : instance.name,
                      ),
                    ),
                    RevisionRecordMarker(
                      recordKey: ProjectRecordKey(
                        kind: ProjectRecordKind.itemInstance,
                        recordId: instance.instanceId,
                      ),
                    ),
                  ],
                ),
                subtitle: Text("ID：${instance.instanceId}"),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SnapshotTimelinePreview(
                          key: ValueKey(
                            "item-instance-snapshot-preview-${instance.instanceId}",
                          ),
                          subject: (
                            kind: SnapshotSubjectKind.itemInstance,
                            id: instance.instanceId,
                          ),
                          mode: instanceMode,
                          autoSelectAtTick: true,
                          selectedEventId:
                              _selectedInstanceSnapshotIds[instance
                                      .instanceId] ==
                                  null
                              ? null
                              : "itemInstance:${_selectedInstanceSnapshotIds[instance.instanceId]}",
                          onModeChanged: (value) => setState(
                            () => _instancePreviewModes[instance.instanceId] =
                                value,
                          ),
                          onEventSelected: (event) => setState(
                            () =>
                                _selectedInstanceSnapshotIds[instance
                                        .instanceId] =
                                    event == null || event.inherited
                                    ? null
                                    : event.sourceId,
                          ),
                          snapshotActionsBuilder: (event) => [
                            NeonIconButton(
                              key: ValueKey(
                                "item-instance-add-snapshot-${instance.instanceId}",
                              ),
                              label: context.l10n.uiAddSceneSnapshot,
                              onPressed: () => _addInstanceSnapshot(instance),
                              icon: Icons.add_photo_alternate_outlined,
                              accent: NeonAccent.green,
                            ),
                            NeonIconButton(
                              key: ValueKey(
                                "item-instance-copy-snapshot-${instance.instanceId}",
                              ),
                              label: context.l10n.uiDuplicateSnapshot,
                              icon: Icons.copy_all_outlined,
                              onPressed: () => _addInstanceSnapshot(
                                instance,
                                sourceState: resolveItemInstanceSnapshot(
                                  itemClass: itemClass,
                                  instance: instance,
                                  classChanges:
                                      instanceMode ==
                                          SnapshotPreviewMode.baseline
                                      ? const []
                                      : workspace.itemClassStateChanges,
                                  instanceChanges:
                                      instanceMode ==
                                          SnapshotPreviewMode.baseline
                                      ? const []
                                      : workspace.itemInstanceStateChanges,
                                  timeline: ref.read(timelineDocumentProvider),
                                  atTick: event?.tick ?? tick,
                                  throughStateChangeId:
                                      event?.inherited == false
                                      ? event?.sourceId
                                      : null,
                                  throughClassStateChangeId:
                                      event?.inherited == true
                                      ? event?.sourceId
                                      : null,
                                ),
                              ),
                            ),
                            NeonIconButton(
                              key: ValueKey(
                                "item-instance-delete-selected-snapshot-${instance.instanceId}",
                              ),
                              label: context.l10n.uiDeleteCurrentSnapshot,
                              onPressed: selectedChange == null
                                  ? null
                                  : () {
                                      ref
                                          .read(itemWorkspaceProvider.notifier)
                                          .removeInstanceStateChange(
                                            selectedChange.stateChangeId,
                                          );
                                      setState(() {
                                        _selectedInstanceSnapshotIds.remove(
                                          instance.instanceId,
                                        );
                                      });
                                    },
                              icon: Icons.delete_outline,
                              destructive: true,
                              statusLabel: selectedChange == null
                                  ? context.l10n.uiNoSnapshotSelected
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (instanceMode == SnapshotPreviewMode.followTimeline)
                          Builder(
                            builder: (context) {
                              final event = snapshotEventAtTick(
                                ref.watch(
                                  snapshotTimelineEventsProvider((
                                    kind: SnapshotSubjectKind.itemInstance,
                                    id: instance.instanceId,
                                  )),
                                ),
                                tick,
                                selectedId:
                                    _selectedInstanceSnapshotIds[instance
                                            .instanceId] ==
                                        null
                                    ? null
                                    : "itemInstance:${_selectedInstanceSnapshotIds[instance.instanceId]}",
                              );
                              final change = event == null || event.inherited
                                  ? null
                                  : workspace.itemInstanceStateChanges
                                        .where(
                                          (change) =>
                                              change.stateChangeId ==
                                              event.sourceId,
                                        )
                                        .firstOrNull;
                              final state = resolveItemInstanceSnapshot(
                                itemClass: itemClass,
                                instance: instance,
                                classChanges: workspace.itemClassStateChanges,
                                instanceChanges:
                                    workspace.itemInstanceStateChanges,
                                timeline: ref.watch(timelineDocumentProvider),
                                atTick: tick,
                                throughStateChangeId: change?.stateChangeId,
                              );
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (change != null) ...[
                                    Text(
                                      context.l10n.uiEditing(
                                        (event!.label).toString(),
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                  ],
                                  ItemSnapshotStateEditor(
                                    key: ValueKey(
                                      "item-instance-editor-${instance.instanceId}-${change?.stateChangeId ?? 'preview-$tick'}",
                                    ),
                                    state: state,
                                    characters: _relationTargets()
                                        .where(
                                          (target) =>
                                              target.kind ==
                                              ItemRelationTargetKind.character,
                                        )
                                        .map(
                                          (target) => DropdownOption(
                                            value: target.id,
                                            label: target.label,
                                          ),
                                        )
                                        .toList(),
                                    locations: _relationTargets()
                                        .where(
                                          (target) =>
                                              target.kind ==
                                              ItemRelationTargetKind.location,
                                        )
                                        .map(
                                          (target) => DropdownOption(
                                            value: target.id,
                                            label: target.label,
                                          ),
                                        )
                                        .toList(),
                                    onChanged: change == null
                                        ? null
                                        : (patch) => _updateInstanceSnapshot(
                                            change.stateChangeId,
                                            patch,
                                          ),
                                  ),
                                ],
                              );
                            },
                          ),
                        Builder(
                          builder: (context) {
                            final state =
                                instanceMode == SnapshotPreviewMode.baseline
                                ? resolveItemInstanceSnapshot(
                                    itemClass: itemClass,
                                    instance: instance,
                                    timeline: ref.watch(
                                      timelineDocumentProvider,
                                    ),
                                    atTick: 0,
                                  )
                                : ref.watch(
                                    itemInstanceSnapshotProvider((
                                      id: instance.instanceId,
                                      tick: tick,
                                    )),
                                  );
                            return Text(
                              [
                                state?.exists == false
                                    ? context.l10n.uiDoesNotExistInThisScene
                                    : context.l10n.uiExistsInThisScene,
                                if (state?.status.isNotEmpty == true)
                                  state!.status,
                                if (state?.holderCharacterId != null)
                                  context.l10n.uiHolder2(
                                    (targetLabels["${ItemRelationTargetKind.character.name}:${state!.holderCharacterId}"] ??
                                            state.holderCharacterId)
                                        .toString(),
                                  ),
                                if (state?.locationId != null)
                                  context.l10n.uiLocation3(
                                    (targetLabels["${ItemRelationTargetKind.location.name}:${state!.locationId}"] ??
                                            state.locationId)
                                        .toString(),
                                  ),
                              ].join(context.l10n.uiLiteral),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (changes.isNotEmpty)
                    ...changes.map(
                      (change) => ListTile(
                        dense: true,
                        key: ValueKey(
                          "item-instance-snapshot-${change.stateChangeId}",
                        ),
                        leading: const Icon(Icons.history, size: 20),
                        title: Text(
                          sceneLabels[change.sceneUUID] ?? change.sceneUUID,
                        ),
                        subtitle: Text(
                          change.patch.status?.value?.isNotEmpty == true
                              ? change.patch.status!.value!
                              : context.l10n.uiLinkThisScene,
                        ),
                        trailing: RevisionRecordMarker(
                          recordKey: ProjectRecordKey(
                            kind: ProjectRecordKind.itemInstanceStateChange,
                            recordId: change.stateChangeId,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildDetails(ItemClassData itemClass, ItemWorkspaceData workspace) {
    final instances = workspace.itemInstances.values
        .where((value) => value.classId == itemClass.classId && !value.archived)
        .toList(growable: false);
    final tick = ref.watch(timelineViewProvider).currentTick;
    final previewMode =
        _classPreviewModes[itemClass.classId] ?? SnapshotPreviewMode.baseline;
    final snapshot = previewMode == SnapshotPreviewMode.baseline
        ? itemClass.defaultState
        : ref.watch(
            itemClassSnapshotProvider((id: itemClass.classId, tick: tick)),
          );
    final instanceIds = instances.map((value) => value.instanceId).toSet();
    final relations = workspace.itemRelations
        .where(
          (value) =>
              (value.itemKind == ItemReferenceKind.itemClass &&
                  value.itemId == itemClass.classId) ||
              (value.itemKind == ItemReferenceKind.instance &&
                  instanceIds.contains(value.itemId)),
        )
        .toList(growable: false);
    final targetLabels = {
      for (final target in _relationTargets())
        "${target.kind.name}:${target.id}": target.label,
    };
    if (previewMode == SnapshotPreviewMode.followTimeline) {
      final event = snapshotEventAtTick(
        ref.watch(
          snapshotTimelineEventsProvider((
            kind: SnapshotSubjectKind.itemClass,
            id: itemClass.classId,
          )),
        ),
        tick,
        selectedId: _selectedClassSnapshotId == null
            ? null
            : "itemClass:$_selectedClassSnapshotId",
      );
      final change = workspace.itemClassStateChanges
          .where((change) => change.stateChangeId == event?.sourceId)
          .firstOrNull;
      final state = resolveItemClassSnapshot(
        itemClass: itemClass,
        changes: workspace.itemClassStateChanges,
        timeline: ref.watch(timelineDocumentProvider),
        atTick: tick,
        throughStateChangeId: change?.stateChangeId,
      );
      return ListView(
        key: ValueKey("item-details-${itemClass.classId}"),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (change != null) ...[
            Text(context.l10n.uiEditing((event!.label).toString())),
            const SizedBox(height: AppSpacing.md),
          ],
          ItemSnapshotStateEditor(
            key: ValueKey(
              "item-class-editor-${itemClass.classId}-${change?.stateChangeId ?? 'preview-$tick'}",
            ),
            state: state,
            characters: _relationTargets()
                .where(
                  (target) => target.kind == ItemRelationTargetKind.character,
                )
                .map(
                  (target) =>
                      DropdownOption(value: target.id, label: target.label),
                )
                .toList(),
            locations: _relationTargets()
                .where(
                  (target) => target.kind == ItemRelationTargetKind.location,
                )
                .map(
                  (target) =>
                      DropdownOption(value: target.id, label: target.label),
                )
                .toList(),
            onChanged: change == null
                ? null
                : (patch) => _updateClassSnapshot(change.stateChangeId, patch),
          ),
          if (itemClass.mode != ItemMode.dedicated ||
              state.allocations.isNotEmpty)
            _buildAllocations(
              itemClass,
              state,
              targetLabels,
              tick,
              editDefaults: false,
              allowSceneActions: change != null,
            ),
        ],
      );
    }
    return ListView(
      key: ValueKey("item-details-${itemClass.classId}"),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _markedItemClassField(
          itemClass.classId,
          'name',
          TextFormField(
            key: ValueKey("item-name-${itemClass.classId}"),
            initialValue: itemClass.name,
            decoration: appFieldDecoration(
              context,
              decoration: InputDecoration(
                labelText: context.l10n.uiName2,
                isDense: true,
              ),
            ),
            onChanged: (value) => _updateClass(
              itemClass.copyWith(
                name: value,
                defaultState: itemClass.defaultState.copyWith(name: value),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _markedItemClassField(
          itemClass.classId,
          'unit',
          TextFormField(
            key: ValueKey("item-unit-${itemClass.classId}"),
            initialValue: itemClass.unit,
            decoration: appFieldDecoration(
              context,
              decoration: InputDecoration(
                labelText: context.l10n.uiQuantityUnit,
                isDense: true,
              ),
            ),
            onChanged: (value) => _updateClass(itemClass.copyWith(unit: value)),
          ),
        ),
        const SizedBox(height: 12),
        _markedItemClassField(
          itemClass.classId,
          'category',
          TextFormField(
            key: ValueKey("item-category-${itemClass.classId}"),
            initialValue: itemClass.category,
            decoration: appFieldDecoration(
              context,
              decoration: InputDecoration(
                labelText: context.l10n.uiCategory,
                isDense: true,
              ),
            ),
            onChanged: (value) =>
                _updateClass(itemClass.copyWith(category: value)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              context.l10n.uiManagementMode,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            RevisionFieldMarker(
              recordKey: ProjectRecordKey(
                kind: ProjectRecordKind.itemClass,
                recordId: itemClass.classId,
              ),
              field: 'mode',
            ),
          ],
        ),
        const SizedBox(height: 8),
        SegmentedButton<ItemMode>(
          key: const Key("item-mode-switch"),
          segments: ItemMode.values
              .map(
                (mode) => ButtonSegment(
                  value: mode,
                  icon: Icon(_modeIcon(mode)),
                  label: Text(_modeLabel(context.l10n, mode)),
                ),
              )
              .toList(growable: false),
          selected: {itemClass.mode},
          onSelectionChanged: (selection) {
            _changeMode(itemClass, selection.single, instances);
          },
        ),
        const SizedBox(height: 16),
        _markedItemClassField(
          itemClass.classId,
          'description',
          TextFormField(
            key: ValueKey("item-description-${itemClass.classId}"),
            initialValue: itemClass.description,
            minLines: 3,
            maxLines: 8,
            decoration: appFieldDecoration(
              context,
              decoration: InputDecoration(
                labelText: context.l10n.uiDescription,
                alignLabelWithHint: true,
                isDense: true,
              ),
            ),
            onChanged: (value) => _updateClass(
              itemClass.copyWith(
                description: value,
                defaultState: itemClass.defaultState.copyWith(
                  description: value,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.uiIndividualItems,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (itemClass.mode == ItemMode.semiDedicated ||
                (itemClass.mode == ItemMode.dedicated && instances.isEmpty))
              FilledButton.tonalIcon(
                key: const Key("item-add-instance"),
                onPressed: () => _createInstance(itemClass),
                icon: const Icon(Icons.add),
                label: Text(context.l10n.uiAddIndividualItem),
              ),
          ],
        ),
        if (itemClass.mode != ItemMode.dedicated ||
            (snapshot?.allocations.isNotEmpty ??
                itemClass.defaultState.allocations.isNotEmpty))
          _buildAllocations(
            itemClass,
            snapshot ?? itemClass.defaultState,
            targetLabels,
            tick,
          )
        else
          const SizedBox.shrink(),
        if (itemClass.mode != ItemMode.generic && instances.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(context.l10n.uiNoIndividualItemsCreatedYet),
          )
        else if (itemClass.mode != ItemMode.generic)
          ...instances.map(
            (instance) => ListTile(
              key: ValueKey("item-instance-details-${instance.instanceId}"),
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text(
                instance.name.isEmpty ? itemClass.name : instance.name,
              ),
              subtitle: Text("ID：${instance.instanceId}"),
              trailing: RevisionRecordMarker(
                recordKey: ProjectRecordKey(
                  kind: ProjectRecordKind.itemInstance,
                  recordId: instance.instanceId,
                ),
              ),
            ),
          ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.uiLinks,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            FilledButton.tonalIcon(
              key: const Key("item-add-relation"),
              onPressed: () => _addRelation(itemClass, instances),
              icon: const Icon(Icons.add_link),
              label: Text(context.l10n.uiAddLink),
            ),
          ],
        ),
        if (relations.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(context.l10n.uiNoCharactersLocationsOrEventsLinkedYet),
          )
        else
          ...relations.map(
            (relation) => ListTile(
              key: ValueKey("item-relation-${relation.relationId}"),
              leading: const Icon(Icons.link),
              title: Text(
                targetLabels["${relation.targetKind.name}:${relation.targetId}"] ??
                    relation.targetId,
              ),
              subtitle: Text(
                [
                  _targetKindLabel(context.l10n, relation.targetKind),
                  if (relation.role.isNotEmpty) relation.role,
                  if (relation.note.isNotEmpty) relation.note,
                ].join(context.l10n.uiLiteral),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RevisionRecordMarker(
                    recordKey: ProjectRecordKey(
                      kind: ProjectRecordKind.itemRelation,
                      recordId: relation.relationId,
                    ),
                  ),
                  NeonIconButton(
                    label: context.l10n.uiRemoveLink,
                    onPressed: () => ref
                        .read(itemWorkspaceProvider.notifier)
                        .removeRelation(relation.relationId),
                    icon: Icons.delete_outline,
                    destructive: true,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAllocations(
    ItemClassData itemClass,
    ItemSnapshotState currentState,
    Map<String, String> targetLabels,
    int tick, {
    bool editDefaults = true,
    bool allowSceneActions = true,
  }) {
    final allocations = currentState.allocations;
    final knownTotal = allocations
        .where((value) => value.quantity != null)
        .fold<int>(0, (sum, value) => sum + value.quantity!);
    final hasUnknown = allocations.any((value) => value.quantity == null);
    final unit = itemClass.unit.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(switch (itemClass.mode) {
            ItemMode.generic =>
              context.l10n.uiNonDedicatedModeUsesClassesAndAggregateAllocations,
            ItemMode.semiDedicated =>
              context
                  .l10n
                  .uiSemiDedicatedModeKeepsUnidentifiedAggregateQuantitiesAnd,
            ItemMode.dedicated =>
              context
                  .l10n
                  .uiThisSectionShowsHistoricalAggregateQuantitiesFromBefore,
          }),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.uiAllocatedQuantity(
                  (knownTotal).toString(),
                  (unit.isEmpty ? "" : " $unit").toString(),
                  (hasUnknown ? context.l10n.uiPlusAnUnknownQuantity : "")
                      .toString(),
                ),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            if (editDefaults)
              FilledButton.tonalIcon(
                key: const Key("item-add-allocation"),
                onPressed: () => _addAllocation(itemClass),
                icon: const Icon(Icons.add),
                label: Text(context.l10n.uiAddAllocation),
              ),
          ],
        ),
        if (allocations.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(context.l10n.uiNoQuantityAllocatedYet),
          )
        else
          ...allocations.map((allocation) {
            final hasTarget =
                allocation.holderCharacterId != null ||
                allocation.locationId != null;
            final targetKey = allocation.holderCharacterId != null
                ? "${ItemRelationTargetKind.character.name}:${allocation.holderCharacterId}"
                : "${ItemRelationTargetKind.location.name}:${allocation.locationId}";
            return ListTile(
              key: ValueKey("item-allocation-${allocation.allocationId}"),
              leading: Icon(
                allocation.holderCharacterId != null
                    ? Icons.person_outline
                    : allocation.locationId != null
                    ? Icons.place_outlined
                    : Icons.inventory_2_outlined,
              ),
              title: Text(
                hasTarget
                    ? targetLabels[targetKey] ??
                          context.l10n.uiAllocationTargetNotFound
                    : context.l10n.uiUnallocated,
              ),
              subtitle: Text(
                [
                  allocation.quantity == null
                      ? context.l10n.uiUnknownQuantity
                      : "${allocation.quantity}${unit.isEmpty ? "" : " $unit"}",
                  if (allocation.note.isNotEmpty) allocation.note,
                ].join(context.l10n.uiLiteral),
              ),
              trailing: Wrap(
                children: [
                  if (itemClass.mode != ItemMode.dedicated)
                    NeonIconButton(
                      key: ValueKey("item-transfer-${allocation.allocationId}"),
                      label: context.l10n.uiQuantityToTransfer,
                      onPressed: !allowSceneActions
                          ? null
                          : () => _transferAllocation(
                              itemClass,
                              currentState,
                              allocation,
                            ),
                      icon: Icons.swap_horiz,
                    ),
                  if (itemClass.mode == ItemMode.semiDedicated)
                    NeonIconButton(
                      key: ValueKey(
                        "item-materialize-${allocation.allocationId}",
                      ),
                      label: context.l10n.uiSeparateIndividualItem,
                      onPressed: !allowSceneActions
                          ? null
                          : () => _materializeAllocation(itemClass, allocation),
                      icon: Icons.call_split_outlined,
                    ),
                  if (editDefaults && itemClass.mode != ItemMode.dedicated)
                    NeonIconButton(
                      label: context.l10n.uiRemoveDefaultAllocation,
                      onPressed:
                          itemClass.defaultState.allocations.any(
                            (value) =>
                                value.allocationId == allocation.allocationId,
                          )
                          ? () => _removeAllocation(
                              itemClass,
                              allocation.allocationId,
                            )
                          : null,
                      icon: Icons.delete_outline,
                      destructive: true,
                    ),
                ],
              ),
            );
          }),
      ],
    );
  }
}

String _modeLabel(AppLocalizations l10n, ItemMode mode) => switch (mode) {
  ItemMode.dedicated => l10n.uiDedicated,
  ItemMode.semiDedicated => l10n.uiSemiDedicated,
  ItemMode.generic => l10n.uiNonDedicated,
};

String _targetKindLabel(AppLocalizations l10n, ItemRelationTargetKind kind) =>
    switch (kind) {
      ItemRelationTargetKind.character => l10n.uiCharacter,
      ItemRelationTargetKind.location => l10n.uiLocation,
      ItemRelationTargetKind.event => l10n.uiEvent,
      ItemRelationTargetKind.scene => l10n.uiScene4,
    };

class _RelationTarget {
  final String id;
  final ItemRelationTargetKind kind;
  final String label;

  const _RelationTarget({
    required this.id,
    required this.kind,
    required this.label,
  });
}

IconData _modeIcon(ItemMode mode) => switch (mode) {
  ItemMode.dedicated => Icons.fingerprint,
  ItemMode.semiDedicated => Icons.account_tree_outlined,
  ItemMode.generic => Icons.category_outlined,
};
