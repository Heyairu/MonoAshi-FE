/************************************************************
 * 
 * Copyright 2025-2026 Heyairu（部屋伊琉）
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 ************************************************************/

import 'package:monogatari_assistant/l10n/app_localization.dart';
import "package:flutter/material.dart";
import "package:file_picker/file_picker.dart";
import "dart:io";
import "dart:async";
import "dart:math" as math;
import "package:path_provider/path_provider.dart";
import "package:uuid/uuid.dart";
import "package:xml/xml.dart" as xml;
import "../models/codecs/xml_text_codec.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../bin/ui_library.dart";
import "package:logging/logging.dart";
import "../models/world_settings_data.dart";
import "../models/location_snapshot_data.dart";
import "../models/item_snapshot_data.dart";
import "../models/item_data.dart";
import "../application/locations/location_deletion.dart";
import "../application/items/item_assignment_operations.dart";
import "../application/items/world_item_migration.dart";
import "../application/collaboration/project_collaborative_text_codec.dart";
import "../domain/collaboration/collaboration_operation.dart"
    show ProjectRecordKind;
import "../domain/collaboration/typed_operation_log.dart" show ProjectRecordKey;
import "../features/revision_tracking/presentation/revision_field_marker.dart";
import "../presentation/providers/snapshot_timeline_providers.dart";
import "../presentation/widgets/snapshot_timeline_preview.dart";
import "../presentation/widgets/snapshot_panel_card.dart";
import "../presentation/widgets/snapshot_state_editor.dart";
import "../presentation/widgets/scene_snapshot_timeline_preview.dart";
import "../presentation/providers/project_state_providers.dart";
import "../presentation/providers/timeline_providers.dart";
import "../presentation/providers/scene_selection_providers.dart";
import "../presentation/widgets/remote_text_cursor_overlay.dart";
import "../presentation/widgets/project_object_selector.dart";

export "../models/world_settings_data.dart";

final _log = Logger("WorldSettingsView");

class _LocationItemProjectionEntry {
  final String id;
  final String classId;
  final String itemId;
  final ItemReferenceKind itemKind;
  final String name;
  final String quantity;
  final String description;

  const _LocationItemProjectionEntry({
    required this.id,
    required this.classId,
    required this.itemId,
    required this.itemKind,
    required this.name,
    required this.quantity,
    required this.description,
  });
}

// MARK: - 拖放數據類型

class LocationDragData {
  final String locationId;
  final String locationName;

  LocationDragData({required this.locationId, required this.locationName});
}

extension WorldNodeTypeUiX on WorldNodeType {
  IconData get icon {
    switch (this) {
      case WorldNodeType.location:
        return Icons.location_on_outlined;
      case WorldNodeType.organization:
        return Icons.groups_outlined;
      case WorldNodeType.rule:
        return Icons.gavel_outlined;
      case WorldNodeType.item:
        return Icons.inventory_2_outlined;
    }
  }
}

class TemplatePreset {
  String id;
  String name; // == WorldType
  String type; // == WorldType
  List<String> keys;

  TemplatePreset({
    String? id,
    required this.name,
    required this.type,
    List<String>? keys,
  }) : id = id ?? Uuid().v4(),
       keys = keys ?? [];

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "type": type, "keys": keys};
  }

  factory TemplatePreset.fromJson(Map<String, dynamic> json) {
    return TemplatePreset(
      id: json["id"] as String?,
      name: json["name"] as String? ?? "",
      type: json["type"] as String? ?? "",
      keys: (json["keys"] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TemplatePreset &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        _listEquals(other.keys, keys);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ type.hashCode ^ keys.hashCode;
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// MARK: - XML Codec（WorldSettings）
class WorldSettingsCodec {
  static void _writeTextElement(
    xml.XmlBuilder builder,
    String name,
    String value,
  ) {
    XmlTextCodec.writeTextElement(builder, name, value);
  }

  static String _readElementText(xml.XmlElement? element) {
    return XmlTextCodec.readElementText(element);
  }

  static String? saveXML(List<LocationData> locations) {
    if (locations.isEmpty) return null;

    final builder = xml.XmlBuilder();
    builder.element(
      "Type",
      nest: () {
        builder.element("Name", nest: "WorldSettings");
        for (final loc in locations) {
          _buildLocation(builder, loc);
        }
      },
    );

    return builder.buildDocument().toXmlString(pretty: true, indent: "  ");
  }

  static void _buildLocation(xml.XmlBuilder builder, LocationData loc) {
    builder.element(
      "Location",
      nest: () {
        _writeTextElement(builder, "LocalName", loc.localName);
        _writeTextElement(builder, "NodeType", loc.nodeType.xmlValue);
        if (loc.localType.isNotEmpty) {
          _writeTextElement(builder, "LocalType", loc.localType);
        }
        if (loc.customVal.isNotEmpty) {
          for (final kv in loc.customVal) {
            builder.element(
              "Key",
              attributes: {"Name": kv.key},
              nest: () {
                builder.text(XmlTextCodec.encodeNewlines(kv.val));
              },
            );
          }
        }
        if (loc.note.isNotEmpty) {
          _writeTextElement(builder, "Memo", loc.note);
        }
        if (loc.child.isNotEmpty) {
          for (final child in loc.child) {
            _buildLocation(builder, child);
          }
        }
      },
    );
  }

  static List<LocationData>? loadXML(String content) {
    try {
      final document = xml.XmlDocument.parse(content);
      final typeElement = document.findAllElements("Type").firstOrNull;
      return typeElement == null ? null : loadElement(typeElement);
    } catch (e) {
      _log.severe("Error parsing WorldSettings XML: $e");
      return null;
    }
  }

  // 自已解析的 Type 區塊載入，避免專案載入時重複序列化與解析。
  static List<LocationData>? loadElement(xml.XmlElement typeElement) {
    try {
      final nameElement = typeElement.findAllElements("Name").firstOrNull;
      if (nameElement?.innerText != "WorldSettings") return null;

      final roots = <LocationData>[];

      // Type"s direct children that are 'Location" are roots
      // Using findElements to get only direct children, avoiding infinite recursion issues
      // if we were to use findAllElements on the root
      for (final locationNode in typeElement.findElements("Location")) {
        roots.add(_parseLocation(locationNode));
      }

      return roots;
    } catch (e) {
      _log.severe("Error parsing WorldSettings XML element: $e");
      return null;
    }
  }

  static LocationData _parseLocation(xml.XmlElement node) {
    final localName = _readElementText(
      node.findAllElements("LocalName").firstOrNull,
    );
    final nodeType = parseWorldNodeType(
      _readElementText(node.findAllElements("NodeType").firstOrNull),
    );
    final localType = _readElementText(
      node.findAllElements("LocalType").firstOrNull,
    );
    final note = _readElementText(node.findAllElements("Memo").firstOrNull);
    final customVal = <LocationCustomize>[];
    final child = <LocationData>[];

    // Parse custom values (Key)
    // Keys are direct children of Location
    for (final keyNode in node.findElements("Key")) {
      final key = keyNode.getAttribute("Name") ?? "";
      final val = _readElementText(keyNode);
      customVal.add(LocationCustomize(key: key, val: val));
    }

    // Parse children locations
    // We must use findElements to only get direct children, otherwise we might grab grandchildren
    for (final childNode in node.findElements("Location")) {
      child.add(_parseLocation(childNode));
    }

    return LocationData(
      localName: localName,
      localType: localType,
      nodeType: nodeType,
      customVal: customVal,
      note: note,
      child: child,
    );
  }
}

// MARK: - 主視圖

class WorldSettingsView extends ConsumerStatefulWidget {
  final String? initialLocationId;
  final int selectionRequestId;
  final ValueChanged<String>? onOpenItem;

  const WorldSettingsView({
    super.key,
    this.initialLocationId,
    this.selectionRequestId = 0,
    this.onOpenItem,
  });

  @override
  ConsumerState<WorldSettingsView> createState() => _WorldSettingsViewState();
}

class _WorldSettingsViewState extends ConsumerState<WorldSettingsView> {
  List<LocationData> get _locations => ref.read(worldSettingsDataProvider);
  String? selectedNodeId;
  String? lastSelectedNodeId; // 記錄上次選取的節點
  String? editingNodeId;
  String? selectedCustomValueId;
  String? _customValueEditorLocationId;
  String? _selectedLocationSnapshotId;
  final Map<String, SnapshotPreviewMode> _locationPreviewModes = {};
  List<TemplatePreset> templatePresets = [];
  String selectedPresetName = "空白";
  Map<String, LocationData> _locationIndex = const <String, LocationData>{};
  Map<String, int> _locationDfsEntry = const <String, int>{};
  Map<String, int> _locationDfsExit = const <String, int>{};

  // 拖動狀態與游標資訊
  bool _isDragging = false;
  String? _draggingLocationId;

  // 控制器
  final TextEditingController tempKeyController = TextEditingController();
  final TextEditingController tempValController = TextEditingController();
  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController locationTypeController = TextEditingController();
  final TextEditingController locationNoteController = TextEditingController();
  final FocusNode _locationNameFocusNode = FocusNode();
  final FocusNode _locationTypeFocusNode = FocusNode();
  final FocusNode _locationNoteFocusNode = FocusNode();
  final ScrollController _pageScrollController = ScrollController();
  final ScrollController _treeScrollController = ScrollController();
  final ScrollController _detailScrollController = ScrollController();
  Timer? _detailDraftTimer;
  VoidCallback? _pendingDetailCommit;
  bool _isSyncingDetailControllers = false;
  int _templateLoadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _loadTemplatesFromDisk();

    locationNameController.addListener(_onNameChanged);
    locationTypeController.addListener(_onTypeChanged);
    locationNoteController.addListener(_onNoteChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _applyRequestedLocation();
    });
  }

  @override
  void didUpdateWidget(covariant WorldSettingsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectionRequestId != widget.selectionRequestId ||
        oldWidget.initialLocationId != widget.initialLocationId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _applyRequestedLocation();
      });
    }
  }

  void _applyRequestedLocation() {
    final id = widget.initialLocationId;
    if (id == null) return;
    _refreshLocationIndex();
    if (!_locationIndex.containsKey(id)) return;
    _flushDetailDraft();
    setState(() {
      selectedNodeId = id;
      lastSelectedNodeId = id;
      _selectedLocationSnapshotId = null;
      _syncDetailControllers();
    });
  }

  List<_FlatNode> _buildFlatList(
    List<LocationData> locations, {
    required int tick,
  }) {
    final flatList = <_FlatNode>[];
    final locationIndex = <String, LocationData>{};
    final dfsEntry = <String, int>{};
    final dfsExit = <String, int>{};
    final workspace = ref.watch(itemWorkspaceProvider);
    final timeline = ref.watch(timelineDocumentProvider);
    final changesByLocation = <String, List<LocationStateChange>>{};
    for (final change in workspace.locationStateChanges) {
      changesByLocation.putIfAbsent(change.locationId, () => []).add(change);
    }
    final states = <String, LocationSnapshotState>{};
    int dfsClock = 0;

    bool resolveSubtree(LocationData node) {
      var containsExistingLocation = false;
      if (node.nodeType == WorldNodeType.location) {
        final state = resolveLocationSnapshot(
          locationId: node.id,
          defaultState: LocationSnapshotState(
            name: node.localName,
            description: node.note,
            properties: {
              for (final value in node.customVal) value.key: value.val,
            },
          ),
          changes: changesByLocation[node.id] ?? const [],
          timeline: timeline,
          atTick: tick,
        );
        states[node.id] = state;
        containsExistingLocation = state.exists;
      }
      for (final child in node.child) {
        containsExistingLocation =
            resolveSubtree(child) || containsExistingLocation;
      }
      return containsExistingLocation;
    }

    bool subtreeContainsExistingLocation(LocationData node) {
      if (states[node.id]?.exists == true) return true;
      return node.child.any(subtreeContainsExistingLocation);
    }

    void flatten(LocationData node, int depth, bool unavailableAncestor) {
      dfsEntry[node.id] = dfsClock++;
      final state = states[node.id];
      final nodeUnavailable = state?.exists == false;
      final retainedShell =
          nodeUnavailable && node.child.any(subtreeContainsExistingLocation);
      flatList.add(
        _FlatNode(
          node,
          depth,
          snapshot: state,
          unavailableAncestor: unavailableAncestor,
          retainedShell: retainedShell,
        ),
      );
      locationIndex[node.id] = node;

      for (final child in node.child) {
        flatten(child, depth + 1, unavailableAncestor || nodeUnavailable);
      }
      dfsExit[node.id] = dfsClock++;
    }

    for (final location in locations) {
      resolveSubtree(location);
    }
    for (final location in locations) {
      flatten(location, 0, false);
    }

    _locationIndex = locationIndex;
    _locationDfsEntry = dfsEntry;
    _locationDfsExit = dfsExit;
    return flatList;
  }

  @override
  void dispose() {
    _templateLoadGeneration++;
    _detailDraftTimer?.cancel();
    _pendingDetailCommit?.call();
    locationNameController.removeListener(_onNameChanged);
    locationTypeController.removeListener(_onTypeChanged);
    locationNoteController.removeListener(_onNoteChanged);
    tempKeyController.dispose();
    tempValController.dispose();
    locationNameController.dispose();
    locationTypeController.dispose();
    locationNoteController.dispose();
    _locationNameFocusNode.dispose();
    _locationTypeFocusNode.dispose();
    _locationNoteFocusNode.dispose();
    _pageScrollController.dispose();
    _treeScrollController.dispose();
    _detailScrollController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    _scheduleDetailDraft();
  }

  void _onTypeChanged() {
    _scheduleDetailDraft();
  }

  void _onNoteChanged() {
    _scheduleDetailDraft();
  }

  void _scheduleDetailDraft() {
    if (_isSyncingDetailControllers) return;
    if (_hasActiveDetailComposition) {
      _detailDraftTimer?.cancel();
      _detailDraftTimer = null;
      _pendingDetailCommit = null;
      return;
    }
    final nodeId = selectedNodeId ?? lastSelectedNodeId;
    if (nodeId == null) return;
    final name = locationNameController.text;
    final type = locationTypeController.text;
    final note = locationNoteController.text;
    _pendingDetailCommit = () {
      _updateLocationById(
        nodeId,
        (current) =>
            current.copyWith(localName: name, localType: type, note: note),
      );
    };
    _detailDraftTimer?.cancel();
    _detailDraftTimer = Timer(const Duration(milliseconds: 300), () {
      _detailDraftTimer = null;
      final commit = _pendingDetailCommit;
      _pendingDetailCommit = null;
      commit?.call();
    });
  }

  bool get _hasActiveDetailComposition =>
      _isComposing(locationNameController) ||
      _isComposing(locationTypeController) ||
      _isComposing(locationNoteController);

  bool _isComposing(TextEditingController controller) {
    final composing = controller.value.composing;
    return composing.isValid && !composing.isCollapsed;
  }

  void _flushDetailDraft() {
    _detailDraftTimer?.cancel();
    _detailDraftTimer = null;
    final commit = _pendingDetailCommit;
    _pendingDetailCommit = null;
    commit?.call();
  }

  void _notifyChange() {
    // Dirty tracking is driven by provider listeners in coordinator.
  }

  void _updateLocationSnapshot(String id, LocationStatePatch patch) {
    final change = ref
        .read(itemWorkspaceProvider)
        .locationStateChanges
        .where((change) => change.stateChangeId == id)
        .firstOrNull;
    if (change == null ||
        change.locationId != (selectedNodeId ?? lastSelectedNodeId) ||
        _locationPreviewModes[change.locationId] ==
            SnapshotPreviewMode.baseline ||
        resolveLocationStateChangeTime(
              change,
              ref.read(timelineDocumentProvider),
            ).resolvedTick !=
            ref.read(timelineViewProvider).currentTick) {
      return;
    }
    ref.read(itemWorkspaceProvider.notifier).putLocationStateChanges([
      change.copyWith(patch: change.patch.merge(patch)),
    ]);
  }

  void _updateLocationById(
    String id,
    LocationData Function(LocationData current) update,
  ) {
    final changed = ref
        .read(worldSettingsDataProvider.notifier)
        .updateLocationById(id, update);

    if (!changed) {
      return;
    }

    if (selectedNodeId == id || lastSelectedNodeId == id) {
      _syncDetailControllers();
    }
    _notifyChange();
  }

  void _refreshLocationIndex() {
    final locationIndex = <String, LocationData>{};
    final dfsEntry = <String, int>{};
    final dfsExit = <String, int>{};
    var dfsClock = 0;
    void visit(LocationData node) {
      dfsEntry[node.id] = dfsClock++;
      locationIndex[node.id] = node;
      for (final child in node.child) {
        visit(child);
      }
      dfsExit[node.id] = dfsClock++;
    }

    for (final location in ref.read(worldSettingsDataProvider)) {
      visit(location);
    }
    _locationIndex = locationIndex;
    _locationDfsEntry = dfsEntry;
    _locationDfsExit = dfsExit;
  }

  void _selectCustomValueForEditing(String locationId, LocationCustomize item) {
    setState(() {
      selectedCustomValueId = item.id;
      _customValueEditorLocationId = locationId;
      tempKeyController.text = item.key;
      tempValController.text = item.val;
    });
  }

  void _clearCustomValueEditor() {
    selectedCustomValueId = null;
    tempKeyController.clear();
    tempValController.clear();
  }

  void _clearCustomValueSelection() {
    if (selectedCustomValueId == null) return;
    setState(_clearCustomValueEditor);
  }

  void _saveCustomValue(String locationId) {
    final key = tempKeyController.text.trim();
    if (key.isEmpty) return;
    final value = tempValController.text;
    final selectedId = selectedCustomValueId;

    _updateLocationById(locationId, (current) {
      final nextCustomValues = [...current.customVal];
      final selectedIndex = selectedId == null
          ? -1
          : nextCustomValues.indexWhere((item) => item.id == selectedId);

      if (selectedIndex >= 0) {
        nextCustomValues[selectedIndex] = nextCustomValues[selectedIndex]
            .copyWith(key: key, val: value);
      } else {
        nextCustomValues.add(LocationCustomize(key: key, val: value));
      }
      return current.copyWith(customVal: nextCustomValues);
    });

    setState(_clearCustomValueEditor);
  }

  void _updateCustomValueCell(
    String locationId,
    String itemId, {
    String? key,
    String? value,
  }) {
    final nextKey = key?.trim();
    if (nextKey != null && nextKey.isEmpty) return;
    _updateLocationById(locationId, (current) {
      final nextCustomValues = current.customVal
          .map((item) {
            if (item.id != itemId) return item;
            return item.copyWith(
              key: nextKey ?? item.key,
              val: value ?? item.val,
            );
          })
          .toList(growable: false);
      return current.copyWith(customVal: nextCustomValues);
    });

    if (selectedCustomValueId == itemId) {
      setState(() {
        if (nextKey != null) tempKeyController.text = nextKey;
        if (value != null) tempValController.text = value;
      });
    }
  }

  void _deleteSelectedCustomValue(String locationId) {
    final selectedId = selectedCustomValueId;
    if (selectedId == null) return;

    _updateLocationById(locationId, (current) {
      final nextCustomValues = [...current.customVal]
        ..removeWhere((item) => item.id == selectedId);
      return current.copyWith(customVal: nextCustomValues);
    });

    setState(_clearCustomValueEditor);
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

  Future<void> _addLocationSnapshot(
    LocationData location, {
    LocationSnapshotState? sourceState,
  }) async {
    final scenes = _placedScenes();
    if (scenes.isEmpty) {
      AppFeedback.error(
        context,
        context.l10n.uiAddTheSceneToTheTimelineBeforeAdding3,
      );
      return;
    }
    final currentTick = ref.read(timelineViewProvider).currentTick;
    final currentState =
        sourceState ??
        ref.read(
          locationSnapshotProvider((id: location.id, tick: currentTick)),
        );
    var placementId = nearestSceneChoice(
      scenes,
      currentTick,
      (scene) => scene.startTick,
    )!.placementId;
    var exists = currentState?.exists ?? true;
    var accessible = currentState?.accessible ?? true;
    var includeDescendants = false;
    var snapshotName =
        sourceState?.name ??
        (currentState?.name.isNotEmpty == true
            ? currentState!.name
            : location.localName);
    var snapshotDescription = currentState?.description ?? location.note;
    var snapshotStatus = currentState?.status ?? "";
    String? propertyValidationError;
    var snapshotProperties =
        (currentState?.properties ?? const <String, String>{}).entries
            .map((entry) => (key: entry.key, value: entry.value))
            .toList();
    final characters = ref.read(characterDataProvider).entries.toList();
    var controllerCharacterId = currentState?.controllerCharacterId;
    final subtreeLocations = <LocationData>[];
    void collectLocations(LocationData node) {
      if (node.nodeType == WorldNodeType.location) subtreeLocations.add(node);
      for (final child in node.child) {
        collectLocations(child);
      }
    }

    collectLocations(location);
    List<String> batchPreviewLines() {
      final selectedScene = scenes.firstWhere(
        (scene) => scene.placementId == placementId,
      );
      String controllerLabel(String? id) {
        if (id == null || id.isEmpty) return context.l10n.uiNotSet;
        return characters
                .where((entry) => entry.key == id)
                .firstOrNull
                ?.value
                .displayName ??
            context.l10n.uiNotFound((id).toString());
      }

      return subtreeLocations
          .map((target) {
            final before = ref.read(
              locationSnapshotProvider((
                id: target.id,
                tick: selectedScene.startTick,
              )),
            );
            final differences = <String>[];
            if (before?.exists != exists) {
              differences.add(
                context.l10n.uiExistence(
                  ((before?.exists ?? true)
                          ? context.l10n.uiYes
                          : context.l10n.uiNo)
                      .toString(),
                  (exists ? context.l10n.uiYes : context.l10n.uiNo).toString(),
                ),
              );
            }
            if (before?.accessible != accessible) {
              differences.add(
                context.l10n.uiAccess(
                  ((before?.accessible ?? true)
                          ? context.l10n.uiYes
                          : context.l10n.uiNo)
                      .toString(),
                  (accessible ? context.l10n.uiYes : context.l10n.uiNo)
                      .toString(),
                ),
              );
            }
            if ((before?.status ?? "") != snapshotStatus.trim()) {
              differences.add(
                context.l10n.uiState(
                  (before?.status.isNotEmpty == true
                          ? before!.status
                          : context.l10n.uiNotSet)
                      .toString(),
                  (snapshotStatus.trim().isEmpty
                          ? context.l10n.uiNotSet
                          : snapshotStatus.trim())
                      .toString(),
                ),
              );
            }
            if (before?.controllerCharacterId != controllerCharacterId) {
              differences.add(
                context.l10n.uiController(
                  (controllerLabel(before?.controllerCharacterId)).toString(),
                  (controllerLabel(controllerCharacterId)).toString(),
                ),
              );
            }
            return "${target.localName}：${differences.isEmpty ? context.l10n.uiNoChanges : differences.join('；')}";
          })
          .toList(growable: false);
    }

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
              (location.localName).toString(),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SceneSnapshotTimelinePreview(
                  subject: (
                    kind: SnapshotSubjectKind.location,
                    id: location.id,
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
                if (subtreeLocations.length > 1)
                  SwitchListTile(
                    key: const Key("location-snapshot-include-descendants"),
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.l10n.uiApplyToAllChildLocations),
                    subtitle: Text(
                      includeDescendants
                          ? context.l10n.uiCreatesIndependentSnapshots(
                              context.formats.integer(subtreeLocations.length),
                            )
                          : context.l10n.uiOnlyWillBeModified(
                              (location.localName).toString(),
                            ),
                      style: Theme.of(context).textTheme.labelTiny,
                    ),
                    value: includeDescendants,
                    onChanged: (value) =>
                        setDialogState(() => includeDescendants = value),
                  ),
                if (!includeDescendants) ...[
                  TextFormField(
                    key: const Key("location-snapshot-name"),
                    initialValue: snapshotName,
                    onChanged: (value) => snapshotName = value,
                    decoration: appFieldDecoration(
                      context,
                      decoration: InputDecoration(
                        labelText: context.l10n.uiNameAtThisPoint,
                      ),
                    ),
                  ),
                  TextFormField(
                    key: const Key("location-snapshot-description"),
                    initialValue: snapshotDescription,
                    onChanged: (value) => snapshotDescription = value,
                    decoration: appFieldDecoration(
                      context,
                      decoration: InputDecoration(
                        labelText: context.l10n.uiDescriptionAtThisPoint,
                      ),
                    ),
                    minLines: 2,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(context.l10n.uiCustomPropertiesAtThisPoint),
                  ),
                  for (final entry in snapshotProperties.indexed)
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: ValueKey(
                              "location-snapshot-property-key-${entry.$1}",
                            ),
                            initialValue: entry.$2.key,
                            decoration: appFieldDecoration(
                              context,
                              decoration: InputDecoration(
                                labelText: context.l10n.uiSettings,
                              ),
                            ),
                            onChanged: (value) {
                              snapshotProperties[entry.$1] = (
                                key: value,
                                value: snapshotProperties[entry.$1].value,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            key: ValueKey(
                              "location-snapshot-property-value-${entry.$1}",
                            ),
                            initialValue: entry.$2.value,
                            decoration: appFieldDecoration(
                              context,
                              decoration: InputDecoration(
                                labelText: context.l10n.uiValue,
                              ),
                            ),
                            onChanged: (value) {
                              snapshotProperties[entry.$1] = (
                                key: snapshotProperties[entry.$1].key,
                                value: value,
                              );
                            },
                          ),
                        ),
                        NeonIconButton(
                          key: ValueKey(
                            "location-snapshot-property-remove-${entry.$1}",
                          ),
                          label: context.l10n.uiRemoveProperty,
                          onPressed: () => setDialogState(
                            () => snapshotProperties.removeAt(entry.$1),
                          ),
                          icon: Icons.remove_circle_outline,
                          destructive: true,
                        ),
                      ],
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      key: const Key("location-snapshot-property-add"),
                      onPressed: () => setDialogState(
                        () => snapshotProperties = [
                          ...snapshotProperties,
                          (key: "", value: ""),
                        ],
                      ),
                      icon: const Icon(Icons.add),
                      label: Text(context.l10n.uiAddProperty),
                    ),
                  ),
                  if (propertyValidationError != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        propertyValidationError!,
                        key: const Key("location-snapshot-property-error"),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ] else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context
                          .l10n
                          .uiBatchApplicationPreservesEachChildLocationSExisting,
                    ),
                  ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.l10n.uiExistsAtThisPoint),
                  value: exists,
                  onChanged: (value) => setDialogState(() => exists = value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.l10n.uiAccessibleAtThisPoint),
                  value: accessible,
                  onChanged: (value) =>
                      setDialogState(() => accessible = value),
                ),
                TextFormField(
                  key: const Key("location-snapshot-status"),
                  initialValue: snapshotStatus,
                  onChanged: (value) =>
                      setDialogState(() => snapshotStatus = value),
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
                  key: const Key("location-snapshot-controller"),
                  initialValue: controllerCharacterId ?? "",
                  decoration: appDropdownFieldDecoration(
                    context,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiController2,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: "",
                      child: Text(context.l10n.uiNotSet),
                    ),
                    if (controllerCharacterId != null &&
                        !characters.any(
                          (entry) => entry.key == controllerCharacterId,
                        ))
                      DropdownMenuItem(
                        value: controllerCharacterId,
                        child: Text(
                          context.l10n.uiNotFound(
                            (controllerCharacterId).toString(),
                          ),
                        ),
                      ),
                    for (final entry in characters)
                      DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value.displayName),
                      ),
                  ],
                  onChanged: (value) => setDialogState(
                    () => controllerCharacterId = value?.isEmpty == true
                        ? null
                        : value,
                  ),
                ),
                if (includeDescendants) ...[
                  const SizedBox(height: 12),
                  Container(
                    key: const Key("location-snapshot-batch-preview"),
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: AppSurfaceShape.borderRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.uiBatchChangesPreview,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 6),
                        for (final line in batchPreviewLines()) Text(line),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              key: const Key("location-snapshot-confirm"),
              onPressed: () {
                if (!includeDescendants) {
                  final keys = snapshotProperties
                      .map((entry) => entry.key.trim())
                      .where((key) => key.isNotEmpty)
                      .toList(growable: false);
                  final hasValueWithoutKey = snapshotProperties.any(
                    (entry) =>
                        entry.key.trim().isEmpty &&
                        entry.value.trim().isNotEmpty,
                  );
                  if (hasValueWithoutKey ||
                      keys.toSet().length != keys.length) {
                    setDialogState(
                      () => propertyValidationError = hasValueWithoutKey
                          ? context.l10n.uiPropertiesWithAValueMustHaveAName
                          : context.l10n.uiCustomPropertyNamesMustBeUnique,
                    );
                    return;
                  }
                }
                Navigator.pop(context, true);
              },
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
    snapshotName = snapshotName.trim();
    snapshotDescription = snapshotDescription.trim();
    snapshotStatus = snapshotStatus.trim();
    final properties = <String, String>{};
    for (final entry in snapshotProperties) {
      final key = entry.key.trim();
      if (key.isNotEmpty) properties[key] = entry.value.trim();
    }
    final selectedScene = scenes.firstWhere(
      (scene) => scene.placementId == placementId,
    );
    final targets = includeDescendants ? subtreeLocations : [location];
    final transactionId = targets.length > 1 ? const Uuid().v4() : null;
    final changes = targets
        .map(
          (target) => LocationStateChange(
            locationId: target.id,
            sequence: ref
                .read(itemWorkspaceProvider)
                .locationStateChanges
                .where((change) => change.locationId == target.id)
                .fold<int>(
                  0,
                  (next, change) =>
                      change.sequence >= next ? change.sequence + 1 : next,
                ),
            sceneUUID: selectedScene.sceneId,
            sourcePlacementUUID: selectedScene.placementId,
            fallbackTick: selectedScene.startTick,
            transactionId: transactionId,
            patch: LocationStatePatch(
              exists: StateValue.set(exists),
              name: includeDescendants ? null : StateValue.set(snapshotName),
              description: includeDescendants
                  ? null
                  : StateValue.set(snapshotDescription),
              properties: includeDescendants
                  ? null
                  : StateValue.set(properties),
              accessible: StateValue.set(accessible),
              status: StateValue.set(snapshotStatus),
              controllerCharacterId: StateValue<String?>.set(
                controllerCharacterId,
              ),
            ),
          ),
        )
        .toList(growable: false);
    ref.read(itemWorkspaceProvider.notifier).putLocationStateChanges(changes);
    final selectedChange = changes.firstWhere(
      (change) => change.locationId == location.id,
    );
    setState(() {
      _locationPreviewModes[location.id] = SnapshotPreviewMode.followTimeline;
      _selectedLocationSnapshotId = selectedChange.stateChangeId;
    });
    ref
        .read(timelineViewProvider.notifier)
        .setCurrentTick(selectedScene.startTick);
    AppFeedback.success(
      context,
      targets.length == 1
          ? context.l10n.uiLocationSnapshotAdded
          : context.l10n.uiAddedLocationSnapshots(
              context.formats.integer(targets.length),
            ),
    );
  }

  Future<void> _removeLocationSnapshot(LocationStateChange change) async {
    final workspace = ref.read(itemWorkspaceProvider);
    final transactionId = change.transactionId;
    final removedIds = workspace.locationStateChanges
        .where(
          (candidate) => transactionId == null
              ? candidate.stateChangeId == change.stateChangeId
              : candidate.transactionId == transactionId,
        )
        .map((candidate) => candidate.stateChangeId)
        .toSet();
    if (removedIds.length > 1) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.uiDeleteAllSnapshotsInThisBatch),
          content: Text(
            context.l10n.uiThisSnapshotBelongsToTheSameBatchAs(
              context.formats.integer(removedIds.length),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              key: const Key("location-snapshot-delete-batch-confirm"),
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.uiDeleteBatch),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    ref
        .read(itemWorkspaceProvider.notifier)
        .removeLocationStateChange(change.stateChangeId);
    if (removedIds.contains(_selectedLocationSnapshotId) && mounted) {
      setState(() => _selectedLocationSnapshotId = null);
    }
    AppFeedback.success(
      context,
      removedIds.length > 1
          ? context.l10n.uiDeletedLocationSnapshots(
              context.formats.integer(removedIds.length),
            )
          : context.l10n.uiLocationSnapshotDeleted,
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

  Widget _buildLocationItemProjection(
    String locationId,
    int tick, {
    bool baseline = false,
  }) {
    final workspace = ref.watch(itemWorkspaceProvider);
    final relatedEntries =
        workspace.itemRelations
            .where(
              (relation) =>
                  relation.targetKind == ItemRelationTargetKind.location &&
                  relation.targetId == locationId,
            )
            .map((relation) {
              final instance = relation.itemKind == ItemReferenceKind.instance
                  ? workspace.itemInstances[relation.itemId]
                  : null;
              final classId = relation.itemKind == ItemReferenceKind.itemClass
                  ? relation.itemId
                  : instance?.classId;
              final label = relation.itemKind == ItemReferenceKind.itemClass
                  ? workspace.itemClasses[classId]?.name
                  : instance?.name;
              return (
                relation: relation,
                classId: classId,
                label: label?.isNotEmpty == true ? label! : relation.itemId,
              );
            })
            .where((entry) => entry.classId != null)
            .toList(growable: false)
          ..sort((a, b) => a.label.compareTo(b.label));
    final entries = <_LocationItemProjectionEntry>[];
    for (final itemClass in workspace.itemClasses.values) {
      final unit = itemClass.unit.trim();
      final state = baseline
          ? itemClass.defaultState
          : ref.watch(
              itemClassSnapshotProvider((id: itemClass.classId, tick: tick)),
            );
      if (state?.exists == true && state!.allocations.isNotEmpty) {
        for (final allocation in state.allocations.where(
          (value) => value.locationId == locationId,
        )) {
          entries.add(
            _LocationItemProjectionEntry(
              id: allocation.allocationId,
              classId: itemClass.classId,
              itemId: itemClass.classId,
              itemKind: ItemReferenceKind.itemClass,
              name: state.name.isEmpty ? itemClass.name : state.name,
              quantity: allocation.quantity == null
                  ? context.l10n.uiUnknown
                  : "${allocation.quantity}${unit.isEmpty ? "" : " $unit"}",
              description: allocation.note.isNotEmpty
                  ? allocation.note
                  : state.status,
            ),
          );
        }
      }
      if (itemClass.mode == ItemMode.generic) continue;
      for (final instance in workspace.itemInstances.values.where(
        (value) => value.classId == itemClass.classId,
      )) {
        final state = baseline
            ? resolveItemInstanceSnapshot(
                itemClass: itemClass,
                instance: instance,
                timeline: ref.watch(timelineDocumentProvider),
                atTick: 0,
              )
            : ref.watch(
                itemInstanceSnapshotProvider((
                  id: instance.instanceId,
                  tick: tick,
                )),
              );
        if (state == null || !state.exists || state.locationId != locationId) {
          continue;
        }
        entries.add(
          _LocationItemProjectionEntry(
            id: instance.instanceId,
            classId: itemClass.classId,
            itemId: instance.instanceId,
            itemKind: ItemReferenceKind.instance,
            name: state.name.isEmpty
                ? (instance.name.isEmpty ? itemClass.name : instance.name)
                : state.name,
            quantity: "1${unit.isEmpty ? "" : " $unit"}",
            description: state.status,
          ),
        );
      }
    }
    entries.sort((a, b) => a.name.compareTo(b.name));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: SmallTitle(
                icon: Icons.link_outlined,
                text: context.l10n.uiRelatedItems,
              ),
            ),
            FilledButton.tonalIcon(
              key: const Key("location-link-item"),
              onPressed: baseline
                  ? () => _linkItemToLocation(locationId)
                  : null,
              icon: const Icon(Icons.add_link),
              label: Text(context.l10n.uiLinkItem),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (relatedEntries.isEmpty)
          Text(context.l10n.uiNoRelatedItemsAreConfigured)
        else
          ...relatedEntries.map(
            (entry) => ListTile(
              dense: true,
              key: ValueKey(
                "location-related-item-${entry.relation.relationId}",
              ),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.link),
              title: Text(entry.label),
              subtitle: Text(
                [
                  if (entry.relation.role.isNotEmpty) entry.relation.role,
                  if (entry.relation.note.isNotEmpty) entry.relation.note,
                ].join(context.l10n.uiLiteral),
              ),
              trailing: Wrap(
                children: [
                  if (widget.onOpenItem != null)
                    NeonIconButton(
                      key: ValueKey(
                        "location-open-related-item-${entry.relation.relationId}",
                      ),
                      label: context.l10n.uiOpenItems,
                      onPressed: () => widget.onOpenItem!(entry.classId!),
                      icon: Icons.open_in_new,
                    ),
                  NeonIconButton(
                    key: ValueKey(
                      "location-unlink-item-${entry.relation.relationId}",
                    ),
                    label: context.l10n.uiUnlink,
                    onPressed: !baseline
                        ? null
                        : () => ref
                              .read(itemWorkspaceProvider.notifier)
                              .removeRelation(entry.relation.relationId),
                    icon: Icons.link_off,
                    destructive: true,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SmallTitle(
                icon: Icons.inventory_2_outlined,
                text: context.l10n.uiItemsCurrentlyAtThisLocation,
              ),
            ),
            FilledButton.tonalIcon(
              key: const Key("location-assign-item"),
              onPressed: baseline
                  ? () => _assignItemToLocation(locationId)
                  : null,
              icon: const Icon(Icons.inventory_2_outlined),
              label: Text(context.l10n.uiAssignItem),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          AppEmptyState(
            title: context.l10n.uiNoItemsHere,
            description:
                context.l10n.uiUseAllocateItemsToSetLocationsOrAggregate,
            icon: Icons.inventory_2_outlined,
            compact: true,
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              key: const ValueKey("location-items-table"),
              columns: [
                DataColumn(label: Text(context.l10n.uiItem)),
                DataColumn(label: Text(context.l10n.uiQuantity), numeric: true),
                DataColumn(label: Text(context.l10n.uiStatusNotes)),
                DataColumn(label: Text(context.l10n.uiActions)),
              ],
              rows: entries
                  .map(
                    (entry) => DataRow(
                      key: ValueKey("location-item-${entry.id}"),
                      cells: [
                        DataCell(
                          TextButton.icon(
                            key: ValueKey("location-open-item-${entry.id}"),
                            onPressed: widget.onOpenItem == null
                                ? null
                                : () => widget.onOpenItem!(entry.classId),
                            icon: const Icon(Icons.open_in_new, size: 16),
                            label: Text(entry.name),
                          ),
                        ),
                        DataCell(Text(entry.quantity)),
                        DataCell(Text(entry.description)),
                        DataCell(
                          NeonIconButton(
                            key: ValueKey("location-unassign-item-${entry.id}"),
                            label: context.l10n.uiClearDefaultAssignment,
                            onPressed: !baseline
                                ? null
                                : () => _clearLocationItemAssignment(
                                    locationId,
                                    entry,
                                  ),
                            icon: Icons.remove_circle_outline,
                            destructive: true,
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
      ],
    );
  }

  Future<void> _linkItemToLocation(String locationId) async {
    final workspace = ref.read(itemWorkspaceProvider);
    final excluded = workspace.itemRelations
        .where(
          (relation) =>
              relation.targetKind == ItemRelationTargetKind.location &&
              relation.targetId == locationId,
        )
        .map(
          (relation) =>
              "${relation.itemKind == ItemReferenceKind.itemClass ? ProjectObjectKind.itemClass.name : ProjectObjectKind.itemInstance.name}:${relation.itemId}",
        )
        .toSet();
    final selected = await showProjectObjectSelector(
      context: context,
      title: context.l10n.uiChooseALocationItemToLink,
      allowedKinds: const {
        ProjectObjectKind.itemClass,
        ProjectObjectKind.itemInstance,
      },
      excludedKeys: excluded,
    );
    final itemKind = selected?.itemReferenceKind;
    if (!mounted || selected == null || itemKind == null) return;
    ref
        .read(itemWorkspaceProvider.notifier)
        .putRelation(
          ItemRelationData(
            relationId: const Uuid().v4(),
            itemId: selected.id,
            itemKind: itemKind,
            targetId: locationId,
            targetKind: ItemRelationTargetKind.location,
            role: context.l10n.uiRelated,
          ),
        );
  }

  Future<void> _assignItemToLocation(String locationId) async {
    final selected = await showProjectObjectSelector(
      context: context,
      title: context.l10n.uiChooseAnItemToPlaceHere,
      allowedKinds: const {
        ProjectObjectKind.itemClass,
        ProjectObjectKind.itemInstance,
      },
    );
    final itemKind = selected?.itemReferenceKind;
    if (!mounted || selected == null || itemKind == null) return;
    int? quantity = 1;
    final workspace = ref.read(itemWorkspaceProvider);
    final itemClass = workspace.itemClasses[selected.classId ?? selected.id];
    if (itemKind == ItemReferenceKind.itemClass &&
        itemClass != null &&
        itemClass.mode != ItemMode.dedicated) {
      var quantityText = "1";
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.uiAssign((selected.label).toString())),
          content: TextFormField(
            key: const Key("location-assignment-quantity"),
            autofocus: true,
            keyboardType: TextInputType.number,
            initialValue: quantityText,
            decoration: appFieldDecoration(
              context,
              decoration: InputDecoration(
                labelText: context.l10n.uiQuantity,
                helperText: context.l10n.uiLeaveBlankIfTheQuantityIsUnknown,
              ),
            ),
            onChanged: (value) => quantityText = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              key: const Key("location-assignment-confirm"),
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.uiAssign2),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
      quantity = quantityText.trim().isEmpty
          ? null
          : int.tryParse(quantityText.trim());
      if (quantityText.trim().isNotEmpty &&
          (quantity == null || quantity < 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.uiQuantityMustBeZeroOrAPositiveInteger),
          ),
        );
        return;
      }
    }
    try {
      final current = ref.read(itemWorkspaceProvider);
      final result = assignItemDefault(
        itemClasses: current.itemClasses,
        itemInstances: current.itemInstances,
        itemKind: itemKind,
        itemId: selected.id,
        targetKind: ItemRelationTargetKind.location,
        targetId: locationId,
        allocationId: const Uuid().v4(),
        quantity: quantity,
      );
      ref
          .read(itemWorkspaceProvider.notifier)
          .setWorkspace(
            current.copyWith(
              itemClasses: result.itemClasses,
              itemInstances: result.itemInstances,
            ),
          );
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.uiCouldNotAssignTheItem((error).toString()),
            ),
          ),
        );
      }
    }
  }

  void _clearLocationItemAssignment(
    String locationId,
    _LocationItemProjectionEntry entry,
  ) {
    final current = ref.read(itemWorkspaceProvider);
    final result = clearItemDefaultAssignment(
      itemClasses: current.itemClasses,
      itemInstances: current.itemInstances,
      itemKind: entry.itemKind,
      itemId: entry.itemId,
      targetKind: ItemRelationTargetKind.location,
      targetId: locationId,
    );
    ref
        .read(itemWorkspaceProvider.notifier)
        .setWorkspace(
          current.copyWith(
            itemClasses: result.itemClasses,
            itemInstances: result.itemInstances,
          ),
        );
  }

  Future<void> _migrateLegacyWorldItems() async {
    final worldNodes = ref.read(worldSettingsDataProvider);
    final count = countWorldItemNodes(worldNodes);
    if (count == 0) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.uiMoveLegacyWorldbuildingItems),
        content: Text(
          context.l10n.uiMoveItemNodesToTheNewItemManager((count).toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            key: const Key("world-migrate-items-confirm"),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.uiMove),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    _flushDetailDraft();
    final latestWorldNodes = ref.read(worldSettingsDataProvider);
    final workspace = ref.read(itemWorkspaceProvider);
    final result = migrateWorldItems(
      worldNodes: latestWorldNodes,
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
    setState(() {
      selectedNodeId = null;
      lastSelectedNodeId = null;
      _selectedLocationSnapshotId = null;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.uiMovedItemsToTheNewItemManager(
              (result.migratedCount).toString(),
            ),
          ),
        ),
      );
    }
  }

  // MARK: - UI 介面建構
  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(worldSettingsDataProvider);
    final tick = ref.watch(timelineViewProvider).currentTick;
    final flatList = _buildFlatList(locations, tick: tick);
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final menuIconColor = Theme.of(context).colorScheme.onSurface;
    const listMinHeight = 320.0;
    final listHeight = math.max(viewportHeight * 0.4, listMinHeight);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _pageScrollController,
            primary: false,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: AppLayoutSpacing.pageForWidth(constraints.maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      children: [
                        LargeTitle(
                          icon: Icons.public,
                          text: context.l10n.uiWorldbuilding2,
                        ),
                        const Spacer(),
                        PopupMenuButton<String>(
                          icon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.grid_view, color: menuIconColor),
                              const SizedBox(width: 4),
                              Text(context.l10n.uiManageTemplates),
                            ],
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case "import":
                                _importTemplate();
                                break;
                              case "exportSelected":
                                _exportSelectedTemplate();
                                break;
                              case "exportAll":
                                _exportAllTemplates();
                                break;
                              case "save":
                                _saveCurrentAsPreset();
                                break;
                              case "rename":
                                _showRenamePresetDialog();
                                break;
                              case "delete":
                                _deleteSelectedPreset();
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: "import",
                              child: Text(context.l10n.uiImportTemplateFile),
                            ),
                            PopupMenuItem(
                              value: "exportSelected",
                              enabled: _selectedPreset != null,
                              child: Text(
                                context.l10n.uiExportSelectedTemplate,
                              ),
                            ),
                            PopupMenuItem(
                              value: "exportAll",
                              enabled: templatePresets.isNotEmpty,
                              child: Text(context.l10n.uiExportAllTemplates),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: "save",
                              child: Text(context.l10n.uiSaveTemplatePreset),
                            ),
                            PopupMenuItem(
                              value: "rename",
                              enabled: _selectedPreset != null,
                              child: Text(context.l10n.uiRenamePreset),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              enabled:
                                  _selectedPreset != null &&
                                  _selectedPreset!.name != "空白",
                              child: Text(context.l10n.uiDeleteSelectedPreset),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    SnapshotWorkspaceLayout(
                      collection: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MediumTitle(
                            icon: Icons.map,
                            text: context.l10n.uiWorldStructure,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedNodeId = null;
                              });
                            },
                            child: CollectionPanel.builder(
                              title: context.l10n.uiWorldStructure,
                              showSectionCard: false,
                              minHeight: listHeight,
                              maxHeight: listHeight,
                              controller: _treeScrollController,
                              showScrollbar: true,
                              itemCount: flatList.length,
                              emptyTitle: context.l10n.uiNoLocationsYet,
                              emptyDescription:
                                  context.l10n.uiAddYourFirstLocation,
                              emptyIcon: Icons.public_off_outlined,
                              itemBuilder: (context, index) {
                                final item = flatList[index];
                                return _buildLocationRow(item);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                            ),
                            child: AddItemInput(
                              useNeonStyle: true,
                              title: selectedNodeId != null
                                  ? context.l10n.uiChildLocation
                                  : context.l10n.uiTopLevelLocation,
                              onAdd: _addLocation,
                            ),
                          ),
                        ],
                      ),
                      timeline: _buildLocationSnapshotCard(),
                      details: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MediumTitle(
                            icon: Icons.info_outline,
                            text: context.l10n.uiNodeDetails,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            constraints: const BoxConstraints(minHeight: 320),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: 0.2),
                              ),
                              borderRadius: AppSurfaceShape.borderRadius,
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerLowest,
                            ),
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: _buildDetailPanel(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationRow(_FlatNode item) {
    final location = item.node;
    final depth = item.depth;
    final snapshot = item.snapshot;
    final isSelected = selectedNodeId == location.id;
    final isEditing = editingNodeId == location.id;
    final isUnavailable = snapshot?.exists == false;

    final titleWidget = InlineEditableText(
      key: ValueKey("location-name-editor-${location.id}"),
      value: location.localName,
      isEditing: isEditing,
      onEdit: () {
        setState(() {
          editingNodeId = location.id;
        });
      },
      onSubmitted: (value) {
        _renameNode(location.id, value);
        setState(() {
          editingNodeId = null;
        });
      },
      onCanceled: () {
        setState(() {
          editingNodeId = null;
        });
      },
      emptyText: context.l10n.uiUntitled,
      style: TextStyle(
        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : isUnavailable
            ? Theme.of(context).colorScheme.onSurfaceVariant
            : Theme.of(context).colorScheme.onSurface,
        decoration: isUnavailable ? TextDecoration.lineThrough : null,
      ),
    );

    return DraggableCardNode<LocationDragData>(
      key: ValueKey(location.id),
      dragData: LocationDragData(
        locationId: location.id,
        locationName: location.localName,
      ),
      nodeId: location.id,
      nodeType: location.child.isEmpty ? NodeType.item : NodeType.folder,

      // 內容
      leading: Icon(
        isUnavailable ? Icons.location_off_outlined : location.nodeType.icon,
        size: 20,
        color: isUnavailable
            ? Theme.of(context).colorScheme.onSurfaceVariant
            : Theme.of(context).colorScheme.primary,
      ),
      title: Row(
        children: [
          Flexible(child: titleWidget),
          RevisionRecordMarker(
            recordKey: ProjectRecordKey(
              kind: ProjectRecordKind.worldNode,
              recordId: location.id,
            ),
          ),
        ],
      ),
      subtitle: Text(
        [
          context.l10n.worldChildNodeCount(
            context.l10n.legacyLabel(location.nodeType.label),
            context.formats.integer(location.child.length),
          ),
          if (isUnavailable) context.l10n.uiDoesNotExistAtThisTick,
          if (item.retainedShell)
            context.l10n.uiTreeShellRetainedExistingChildLocationsRemain,
          if (item.unavailableAncestor && !isUnavailable)
            context.l10n.uiParentDoesNotExistAtThisTickThis,
          if (snapshot != null &&
              snapshot.name.isNotEmpty &&
              snapshot.name != location.localName)
            context.l10n.uiNameAtThisPoint2((snapshot.name).toString()),
        ].join("\n"),
        key: ValueKey("location-timeline-status-${location.id}"),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: ItemActionBar.editDelete(
        useNeonStyle: true,
        iconSize: AppControlSize.smallIcon,
        onEdit: () {
          setState(() {
            editingNodeId = location.id;
          });
        },
        onDelete: () => _deleteNode(location.id),
        deleteTooltip: context.l10n.uiDeleteLocation,
      ),

      // 狀態與回調
      isSelected: isSelected,
      onClicked: () {
        _flushDetailDraft();
        setState(() {
          selectedNodeId = location.id;
          lastSelectedNodeId = location.id;
          _selectedLocationSnapshotId = null;
          _syncDetailControllers();
        });
      },

      // 拖放
      isDragging: _isDragging,
      isThisDragging: _draggingLocationId == location.id,
      isDragForbidden:
          _isDragging &&
          _draggingLocationId != null &&
          _isDescendant(_draggingLocationId!, location.id),

      onDragStarted: () {
        setState(() {
          _isDragging = true;
          _draggingLocationId = location.id;
        });
      },
      onDragEnd: () {
        setState(() {
          _isDragging = false;
          _draggingLocationId = null;
        });
      },

      getDropZoneSize: (pos) {
        switch (pos) {
          case DropPosition.before:
            return 0.3;
          case DropPosition.child:
            return 0.4;
          case DropPosition.after:
            return 0.3;
        }
      },

      onWillAccept: (data, pos) {
        if (data.locationId == location.id) return false;
        return true;
      },

      onAccept: (data, pos) {
        String positionStr;
        String messageKey;

        switch (pos) {
          case DropPosition.before:
            positionStr = "before";
            messageKey = context.l10n.uiBefore;
            break;
          case DropPosition.child:
            positionStr = "child";
            messageKey = context.l10n.uiAsAChildLocation;
            break;
          case DropPosition.after:
            positionStr = "after";
            messageKey = context.l10n.uiAfter;
            break;
        }

        final message = pos == DropPosition.child
            ? context.l10n.uiIsNowPlaced(
                (data.locationName).toString(),
                (location.localName).toString(),
                (messageKey).toString(),
              )
            : context.l10n.uiMoved(
                (data.locationName).toString(),
                (location.localName).toString(),
                (messageKey).toString(),
              );

        _moveLocationTo(data.locationId, location.id, positionStr);
        AppFeedback.success(
          context,
          message,
          duration: const Duration(seconds: 1),
        );
      },

      indent: depth * 16.0,
    );
  }

  Widget _buildLocationSnapshotCard() {
    final displayNodeId = selectedNodeId ?? lastSelectedNodeId;
    final location = displayNodeId == null
        ? null
        : _getLocation(displayNodeId, _locations);
    if (location == null || location.nodeType != WorldNodeType.location) {
      return SnapshotPanelCard(
        key: ValueKey("location-snapshot-card"),
        child: AppEmptyState(
          title: context.l10n.uiSelectALocationFirst,
          description: context.l10n.uiSelectALocationToPreviewItsTimelineAnd,
          icon: Icons.location_on_outlined,
          compact: true,
        ),
      );
    }
    final tick = ref.watch(timelineViewProvider).currentTick;
    final previewMode =
        _locationPreviewModes[location.id] ?? SnapshotPreviewMode.baseline;
    final snapshot = previewMode == SnapshotPreviewMode.baseline
        ? LocationSnapshotState(
            name: location.localName,
            description: location.note,
            properties: {
              for (final value in location.customVal) value.key: value.val,
            },
          )
        : location.nodeType == WorldNodeType.location
        ? ref.watch(locationSnapshotProvider((id: location.id, tick: tick)))
        : null;
    final sceneLabels = _sceneLabels();
    final characterLabels = {
      for (final entry in ref.watch(characterDataProvider).entries)
        entry.key: entry.value.displayName,
    };
    final locationChanges = orderedLocationStateChanges(
      locationId: location.id,
      changes: ref.watch(itemWorkspaceProvider).locationStateChanges,
      timeline: ref.watch(timelineDocumentProvider),
    ).reversed.map((entry) => entry.change).toList(growable: false);
    final selectedSnapshotChange = locationChanges
        .where((change) => change.stateChangeId == _selectedLocationSnapshotId)
        .firstOrNull;

    return SnapshotPanelCard(
      key: const ValueKey("location-snapshot-card"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SnapshotTimelinePreview(
            key: ValueKey("location-snapshot-preview-${location.id}"),
            subject: (kind: SnapshotSubjectKind.location, id: location.id),
            mode: previewMode,
            autoSelectAtTick: true,
            selectedEventId: _selectedLocationSnapshotId == null
                ? null
                : "location:$_selectedLocationSnapshotId",
            onModeChanged: (value) {
              _flushDetailDraft();
              setState(() => _locationPreviewModes[location.id] = value);
            },
            onEventSelected: (event) =>
                setState(() => _selectedLocationSnapshotId = event?.sourceId),
            snapshotActionsBuilder: (event) => [
              NeonIconButton(
                key: ValueKey("location-add-snapshot-${location.id}"),
                label: context.l10n.uiAddSceneSnapshot,
                onPressed: () => _addLocationSnapshot(location),
                icon: Icons.add_photo_alternate_outlined,
                accent: NeonAccent.green,
              ),
              NeonIconButton(
                key: ValueKey("location-copy-snapshot-${location.id}"),
                label: context.l10n.uiDuplicateSnapshot,
                icon: Icons.copy_all_outlined,
                onPressed: () => _addLocationSnapshot(
                  location,
                  sourceState: event == null
                      ? snapshot
                      : resolveLocationSnapshot(
                          locationId: location.id,
                          defaultState: LocationSnapshotState(
                            name: location.localName,
                            description: location.note,
                            properties: {
                              for (final value in location.customVal)
                                value.key: value.val,
                            },
                          ),
                          changes: ref
                              .read(itemWorkspaceProvider)
                              .locationStateChanges,
                          timeline: ref.read(timelineDocumentProvider),
                          atTick: event.tick,
                          throughStateChangeId: event.sourceId,
                        ),
                ),
              ),
              NeonIconButton(
                key: ValueKey(
                  "location-delete-selected-snapshot-${location.id}",
                ),
                label: context.l10n.uiDeleteCurrentSnapshot,
                onPressed: selectedSnapshotChange == null
                    ? null
                    : () => _removeLocationSnapshot(selectedSnapshotChange),
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
                        if (snapshot.name.isNotEmpty)
                          context.l10n.uiName((snapshot.name).toString()),
                        if (snapshot.description.isNotEmpty)
                          context.l10n.uiDescription2(
                            (snapshot.description).toString(),
                          ),
                        if (snapshot.properties.isNotEmpty)
                          context.l10n.uiProperties(
                            (snapshot.properties.entries
                                    .map(
                                      (entry) => "${entry.key}=${entry.value}",
                                    )
                                    .join("、"))
                                .toString(),
                          ),
                        snapshot.exists
                            ? context.l10n.uiExists
                            : context.l10n.uiDoesNotExistYet,
                        snapshot.accessible
                            ? context.l10n.uiAccessible
                            : context.l10n.uiInaccessible,
                        if (snapshot.status.isNotEmpty) snapshot.status,
                        if (snapshot.controllerCharacterId != null)
                          context.l10n.uiController3(
                            (characterLabels[snapshot.controllerCharacterId] ??
                                    snapshot.controllerCharacterId)
                                .toString(),
                          ),
                      ].join(context.l10n.uiLiteral),
              ),
            ),
          ),
          if (locationChanges.isNotEmpty)
            Material(
              color: Colors.transparent,
              child: ExpansionTile(
                key: ValueKey("location-snapshot-history-${location.id}"),
                leading: const Icon(Icons.history),
                title: Text(
                  context.l10n.uiSnapshotHistory(
                    context.formats.integer(locationChanges.length),
                  ),
                ),
                children: locationChanges
                    .map(
                      (change) => ListTile(
                        key: ValueKey(
                          "location-snapshot-${change.stateChangeId}",
                        ),
                        title: Text(
                          sceneLabels[change.sceneUUID] ?? change.sceneUUID,
                        ),
                        subtitle: Text(
                          change.patch.status?.value?.isNotEmpty == true
                              ? change.patch.status!.value!
                              : context.l10n.uiLinkThisScene,
                        ),
                        trailing: NeonIconButton(
                          label: context.l10n.uiRemoveLocationSnapshot,
                          onPressed: () => _removeLocationSnapshot(change),
                          icon: Icons.delete_outline,
                          destructive: true,
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel() {
    // 如果當前沒有選中節點，使用上次選取的節點
    final displayNodeId = selectedNodeId ?? lastSelectedNodeId;

    if (displayNodeId == null) {
      return AppEmptyState(
        title: context.l10n.uiChooseALocation,
        description: context.l10n.uiSelectALocationToEditItsDetails,
        icon: Icons.touch_app_outlined,
        compact: true,
      );
    }

    final location = _getLocation(displayNodeId, _locations);
    if (location == null) {
      return AppEmptyState(
        title: context.l10n.uiLocationNotFound,
        icon: Icons.location_off_outlined,
        compact: true,
      );
    }
    final tick = ref.watch(timelineViewProvider).currentTick;
    final previewMode =
        _locationPreviewModes[location.id] ?? SnapshotPreviewMode.baseline;
    if (location.nodeType == WorldNodeType.location &&
        previewMode == SnapshotPreviewMode.followTimeline) {
      final event = snapshotEventAtTick(
        ref.watch(
          snapshotTimelineEventsProvider((
            kind: SnapshotSubjectKind.location,
            id: location.id,
          )),
        ),
        tick,
        selectedId: _selectedLocationSnapshotId == null
            ? null
            : "location:$_selectedLocationSnapshotId",
      );
      final changes = ref.watch(itemWorkspaceProvider).locationStateChanges;
      final change = changes
          .where((change) => change.stateChangeId == event?.sourceId)
          .firstOrNull;
      final state = resolveLocationSnapshot(
        locationId: location.id,
        defaultState: LocationSnapshotState(
          name: location.localName,
          description: location.note,
          properties: {
            for (final value in location.customVal) value.key: value.val,
          },
        ),
        changes: changes,
        timeline: ref.watch(timelineDocumentProvider),
        atTick: tick,
        throughStateChangeId: change?.stateChangeId,
      );
      return SingleChildScrollView(
        controller: _detailScrollController,
        primary: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (change != null) ...[
              Text(context.l10n.uiEditing((event!.label).toString())),
              const SizedBox(height: AppSpacing.md),
            ],
            LocationSnapshotStateEditor(
              key: ValueKey(
                "location-editor-${location.id}-${change?.stateChangeId ?? 'preview-$tick'}",
              ),
              state: state,
              characters: ref
                  .watch(characterDataProvider)
                  .entries
                  .map(
                    (entry) => DropdownOption(
                      value: entry.key,
                      label: entry.value.displayName,
                    ),
                  )
                  .toList(),
              onChanged: change == null
                  ? null
                  : (patch) =>
                        _updateLocationSnapshot(change.stateChangeId, patch),
            ),
            const SizedBox(height: 16),
            _buildLocationItemProjection(location.id, tick),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      controller: _detailScrollController,
      primary: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 應用模板
          Row(
            children: [
              Text(context.l10n.uiApplyTemplate),
              Expanded(
                child: AppDropdownField<String>(
                  value: selectedPresetName,
                  options: templatePresets
                      .map(
                        (preset) => DropdownOption<String>(
                          value: preset.name,
                          label: preset.name,
                        ),
                      )
                      .toList(),
                  hintText: context.l10n.uiChooseTemplate,
                  onChanged: (value) {
                    setState(() {
                      selectedPresetName = value ?? context.l10n.uiBlank;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final preset = templatePresets.firstWhere(
                    (p) => p.name == selectedPresetName,
                    orElse: () => templatePresets.first,
                  );
                  _applyTemplateTo(location.id, preset);
                },
                child: Text(context.l10n.commonConfirm),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 名稱
          Row(
            children: [
              Expanded(
                child: CollaborativeProjectTextFieldRegion(
                  key: ValueKey("world-name-${location.id}"),
                  fieldId: ProjectCollaborativeTextCodec.worldNodeFieldId(
                    location.id,
                    "localName",
                  ),
                  crdtDocumentId:
                      ProjectCollaborativeTextCodec.worldNodeFieldId(
                        location.id,
                        "localName",
                      ),
                  controller: locationNameController,
                  focusNode: _locationNameFocusNode,
                  shouldPublishTextChanges: () => !_isSyncingDetailControllers,
                  child: AppTextField(
                    controller: locationNameController,
                    focusNode: _locationNameFocusNode,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiName2,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              RevisionFieldMarker(
                recordKey: ProjectRecordKey(
                  kind: ProjectRecordKind.worldNode,
                  recordId: location.id,
                ),
                field: 'name',
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 類型
          Row(
            children: [
              Expanded(
                child: CollaborativeProjectTextFieldRegion(
                  key: ValueKey("world-type-${location.id}"),
                  fieldId: ProjectCollaborativeTextCodec.worldNodeFieldId(
                    location.id,
                    "localType",
                  ),
                  crdtDocumentId:
                      ProjectCollaborativeTextCodec.worldNodeFieldId(
                        location.id,
                        "localType",
                      ),
                  controller: locationTypeController,
                  focusNode: _locationTypeFocusNode,
                  shouldPublishTextChanges: () => !_isSyncingDetailControllers,
                  child: AppTextField(
                    controller: locationTypeController,
                    focusNode: _locationTypeFocusNode,
                    decoration: InputDecoration(
                      labelText: context.l10n.uiType,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              RevisionFieldMarker(
                recordKey: ProjectRecordKey(
                  kind: ProjectRecordKind.worldNode,
                  recordId: location.id,
                ),
                field: 'localType',
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (location.nodeType == WorldNodeType.item)
            AppNoticeBanner(
              message: context.l10n.uiThisIsALegacyItemNodeItemsAre,
              icon: Icons.move_down_outlined,
              tone: AppFeedbackTone.warning,
              action: TextButton.icon(
                key: const Key("world-migrate-items"),
                onPressed: _migrateLegacyWorldItems,
                icon: const Icon(Icons.move_down_outlined),
                label: Text(context.l10n.uiMoveAllItems),
              ),
            )
          else
            AppDropdownField<WorldNodeType>(
              value: location.nodeType,
              labelText: context.l10n.uiNodeType,
              options: WorldNodeType.values
                  .where((type) => type != WorldNodeType.item)
                  .map(
                    (type) => DropdownOption<WorldNodeType>(
                      value: type,
                      label: context.l10n.legacyLabel(type.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null || value == location.nodeType) return;
                _updateLocationById(
                  location.id,
                  (current) => current.copyWith(nodeType: value),
                );
              },
            ),
          const SizedBox(height: 16),

          if (location.nodeType == WorldNodeType.location) ...[
            _buildLocationItemProjection(
              location.id,
              tick,
              baseline: previewMode == SnapshotPreviewMode.baseline,
            ),
            const SizedBox(height: 16),
          ],

          // 自訂值表
          Text(
            context.l10n.uiCustomProperties,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 8),
          AppTwoColumnTable(
            firstHeader: context.l10n.uiSettings,
            secondHeader: context.l10n.uiValue,
            bodyHeight: 200,
            onSelectionCleared: _clearCustomValueSelection,
            emptyState: AppEmptyState(
              title: context.l10n.uiNoCustomProperties,
              description: context.l10n.uiEnterAPropertyNameAndValueBelowTo,
              icon: Icons.tune_outlined,
              compact: true,
            ),
            rows: location.customVal
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return AppTwoColumnTableRow(
                    key: ValueKey(item.id),
                    selected: selectedCustomValueId == item.id,
                    showDivider: index != location.customVal.length - 1,
                    firstCell: AppEditableTableCell(
                      key: ValueKey("custom-key-${item.id}"),
                      value: item.key,
                      selected: selectedCustomValueId == item.id,
                      onEditStarted: () =>
                          _selectCustomValueForEditing(location.id, item),
                      onEditCanceled: _clearCustomValueSelection,
                      onSubmitted: (value) => _updateCustomValueCell(
                        location.id,
                        item.id,
                        key: value,
                      ),
                    ),
                    secondCell: AppEditableTableCell(
                      key: ValueKey("custom-value-${item.id}"),
                      value: item.val,
                      selected: selectedCustomValueId == item.id,
                      onEditStarted: () =>
                          _selectCustomValueForEditing(location.id, item),
                      onEditCanceled: _clearCustomValueSelection,
                      onSubmitted: (value) => _updateCustomValueCell(
                        location.id,
                        item.id,
                        value: value,
                      ),
                    ),
                    onTap: () {
                      _selectCustomValueForEditing(location.id, item);
                    },
                  );
                })
                .toList(growable: false),
          ),
          const SizedBox(height: 8),
          AppTwoColumnTableEditor(
            firstController: tempKeyController,
            secondController: tempValController,
            firstLabel: context.l10n.uiSettings,
            secondLabel: context.l10n.uiValue,
            isEditing: selectedCustomValueId != null,
            canSubmit: (key, _) => key.trim().isNotEmpty,
            onSubmit: (_, _) => _saveCustomValue(location.id),
            onDelete: () => _deleteSelectedCustomValue(location.id),
          ),
          const SizedBox(height: 16),

          // 備註
          Text(
            context.l10n.uiNotes4,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CollaborativeProjectTextFieldRegion(
                  key: ValueKey("world-note-${location.id}"),
                  fieldId: ProjectCollaborativeTextCodec.worldNodeFieldId(
                    location.id,
                    "note",
                  ),
                  crdtDocumentId:
                      ProjectCollaborativeTextCodec.worldNodeFieldId(
                        location.id,
                        "note",
                      ),
                  controller: locationNoteController,
                  focusNode: _locationNoteFocusNode,
                  shouldPublishTextChanges: () => !_isSyncingDetailControllers,
                  child: AppTextField(
                    controller: locationNoteController,
                    focusNode: _locationNoteFocusNode,
                    decoration: const InputDecoration(isDense: true),
                    maxLines: 4,
                  ),
                ),
              ),
              RevisionFieldMarker(
                recordKey: ProjectRecordKey(
                  kind: ProjectRecordKind.worldNode,
                  recordId: location.id,
                ),
                field: 'note',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 模板管理相關方法
  TemplatePreset? get _selectedPreset {
    return templatePresets
        .where((p) => p.name == selectedPresetName)
        .firstOrNull;
  }

  void _applyTemplateTo(String locationId, TemplatePreset preset) {
    _updateLocationById(locationId, (current) {
      final nextCustomValues = preset.keys
          .map((key) => LocationCustomize(key: key, val: ""))
          .toList();

      return current.copyWith(
        localType: preset.type,
        localName: preset.name,
        customVal: nextCustomValues,
      );
    });
  }

  void _saveCurrentAsPreset() {
    if (selectedNodeId == null) return;
    final location = _getLocation(selectedNodeId!, _locations);
    if (location == null) return;

    final worldType = location.localType.trim();
    if (worldType.isEmpty) return;

    final preset = TemplatePreset(
      name: worldType,
      type: worldType,
      keys: location.customVal.map((cv) => cv.key).toList(),
    );

    final existingIndex = templatePresets.indexWhere(
      (p) => p.name == preset.name,
    );
    if (existingIndex != -1) {
      _showOverwritePresetDialog(preset);
    } else {
      setState(() {
        templatePresets.add(preset);
        selectedPresetName = preset.name;
      });
      _saveTemplatesToDisk();
    }
  }

  Future<void> _showOverwritePresetDialog(TemplatePreset preset) async {
    final confirmed = await AppDialog.confirm(
      context: context,
      title: context.l10n.uiSaveTemplatePreset2,
      message: context.l10n.uiATemplateWithThisNameExistsOverwriteIt,
      confirmLabel: context.l10n.uiOverwrite,
    );
    if (!mounted || !confirmed) return;

    final index = templatePresets.indexWhere((p) => p.name == preset.name);
    setState(() {
      templatePresets[index] = preset;
      selectedPresetName = preset.name;
    });
    _saveTemplatesToDisk();
  }

  Future<void> _showRenamePresetDialog() async {
    final newName = await AppDialog.prompt(
      context: context,
      title: context.l10n.uiRenamePreset2,
      labelText: context.l10n.uiNewTemplateName,
      initialValue: selectedPresetName,
    );
    if (!mounted || newName == null) {
      return;
    }
    _renameSelectedPreset(newName);
  }

  void _renameSelectedPreset(String newName) {
    final index = templatePresets.indexWhere(
      (p) => p.name == selectedPresetName,
    );
    if (index != -1) {
      setState(() {
        templatePresets[index].name = newName;
        templatePresets[index].type = newName;
        selectedPresetName = newName;
      });
      _saveTemplatesToDisk();
    }
  }

  void _deleteSelectedPreset() {
    final index = templatePresets.indexWhere(
      (p) => p.name == selectedPresetName && p.name != "空白",
    );
    if (index != -1) {
      setState(() {
        templatePresets.removeAt(index);
        selectedPresetName = templatePresets.isNotEmpty
            ? templatePresets.first.name
            : "";
      });
      _saveTemplatesToDisk();
    }
  }

  void _importTemplate() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["xml", "txt"],
    );

    if (result != null && result.files.single.path != null) {
      try {
        final file = File(result.files.single.path!);
        final xml = await file.readAsString();
        final presets = _parseAllTemplatesXML(xml);

        if (presets.isEmpty) {
          _showErrorDialog(context.l10n.uiImportFailedNoTypeNodesFoundInThe);
        } else {
          setState(() {
            // 合併：同名覆蓋
            for (final preset in presets) {
              final index = templatePresets.indexWhere(
                (p) => p.name == preset.name,
              );
              if (index != -1) {
                templatePresets[index] = preset;
              } else {
                templatePresets.add(preset);
              }
            }
            _ensureBlankPresetExists();
            if (presets.isNotEmpty) {
              selectedPresetName = presets.last.name;
            }
          });
          _saveTemplatesToDisk();
        }
      } catch (e) {
        _showErrorDialog(
          context.l10n.uiCouldNotReadFile((e.toString()).toString()),
        );
      }
    }
  }

  void _exportSelectedTemplate() async {
    final preset = _selectedPreset;
    if (preset == null) return;

    final xml = _toXML(preset);
    await _exportToFile(xml, "${preset.name}.xml");
  }

  void _exportAllTemplates() async {
    final xml = templatePresets.map(_toXML).join("\n");
    await _exportToFile(xml, "AllTemplates.xml");
  }

  Future<void> _exportToFile(String content, String fileName) async {
    final result = await FilePicker.platform.saveFile(
      dialogTitle: context.l10n.uiExportFile,
      fileName: fileName,
      // 不在 saveFile 上傳遞 bytes，因為 macOS 不支援
      // 內容將由應用程式寫入檔案
    );

    if (result != null) {
      try {
        // 在桌面平台上仍需要寫入檔案
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          final file = File(result);
          await file.writeAsString(content);
        }
        _showSuccessDialog(context.l10n.uiFileExportedTo((result).toString()));
      } catch (e) {
        _showErrorDialog(
          context.l10n.uiExportFailed((e.toString()).toString()),
        );
      }
    }
  }

  // XML/Parse（模板檔案，與專案無關）
  String _toXML(TemplatePreset preset) {
    var xml = "<Type>\n";
    xml += "  <WorldType>${preset.type}</WorldType>\n";
    for (final key in preset.keys) {
      xml += "  <Key>$key</Key>\n";
    }
    xml += "</Type>";
    return xml;
  }

  TemplatePreset? _parseTemplateXML(String xml) {
    final worldTypeMatch = RegExp(
      r"<WorldType>(.*?)</WorldType>",
      dotAll: true,
    ).firstMatch(xml);
    final worldType = worldTypeMatch?.group(1)?.trim() ?? "";
    if (worldType.isEmpty) return null;

    final keyMatches = RegExp(
      r"<Key>(.*?)</Key>",
      dotAll: true,
    ).allMatches(xml);
    final keys = keyMatches.map((m) => m.group(1)?.trim() ?? "").toList();

    return TemplatePreset(name: worldType, type: worldType, keys: keys);
  }

  List<TemplatePreset> _parseAllTemplatesXML(String xml) {
    final typeMatches = RegExp(
      r"<Type>([\s\S]*?)</Type>",
      dotAll: true,
    ).allMatches(xml);
    return typeMatches
        .map((match) => _parseTemplateXML("<Type>${match.group(1)}</Type>"))
        .where((preset) => preset != null)
        .cast<TemplatePreset>()
        .toList();
  }

  // 持久化（沙盒 Application Support/Data/WorldTemplate.xml）
  Future<String> _getDataDirectoryPath() async {
    final appDir = await getApplicationSupportDirectory();
    final dataDir = Directory("${appDir.path}/Data");
    if (!await dataDir.exists()) {
      await dataDir.create(recursive: true);
    }
    return dataDir.path;
  }

  Future<String> get _worldTemplateFilePath async {
    final dataPath = await _getDataDirectoryPath();
    return "$dataPath/WorldTemplate.xml";
  }

  Future<void> _saveTemplatesToDisk() async {
    try {
      final xml = templatePresets.map(_toXML).join("\n");
      final filePath = await _worldTemplateFilePath;
      final file = File(filePath);
      await file.writeAsString(xml);
    } catch (e) {
      _log.warning("儲存模板失敗：${e.toString()}");
    }
  }

  Future<void> _loadTemplatesFromDisk() async {
    final generation = ++_templateLoadGeneration;
    try {
      final filePath = await _worldTemplateFilePath;
      if (!mounted || generation != _templateLoadGeneration) return;
      final file = File(filePath);

      if (!await file.exists()) {
        if (!mounted || generation != _templateLoadGeneration) return;
        setState(_ensureBlankPresetExists);
        return;
      }

      final xml = await file.readAsString();
      if (!mounted || generation != _templateLoadGeneration) return;
      final presets = _parseAllTemplatesXML(xml);

      if (presets.isEmpty) {
        _log.info("讀檔成功但解析為空，保留現有預設。");
        setState(_ensureBlankPresetExists);
        return;
      }

      setState(() {
        templatePresets = presets;
        _ensureBlankPresetExists();
        selectedPresetName = templatePresets.isNotEmpty
            ? templatePresets.first.name
            : context.l10n.uiBlank;
      });
    } catch (e) {
      _log.warning("讀取模板失敗：${e.toString()}");
      if (mounted && generation == _templateLoadGeneration) {
        setState(_ensureBlankPresetExists);
      }
    }
  }

  void _ensureBlankPresetExists() {
    if (!templatePresets.any((p) => p.name == "空白")) {
      templatePresets.insert(
        0,
        TemplatePreset(name: context.l10n.uiBlank, type: "", keys: []),
      );
    }
  }

  // TreeView 操作
  void _addLocation(String name) {
    final added = ref
        .read(worldSettingsDataProvider.notifier)
        .addLocation(name: name, parentId: selectedNodeId);
    if (!added) {
      return;
    }

    _refreshLocationIndex();
    _notifyChange();
  }

  void _renameNode(String id, String newName) {
    _updateLocationById(id, (current) => current.copyWith(localName: newName));
  }

  // MARK: - 拖動相關方法

  bool _isDescendant(String sourceId, String targetId) {
    final sourceEntry = _locationDfsEntry[sourceId];
    final sourceExit = _locationDfsExit[sourceId];
    final targetEntry = _locationDfsEntry[targetId];
    final targetExit = _locationDfsExit[targetId];
    if (sourceEntry != null &&
        sourceExit != null &&
        targetEntry != null &&
        targetExit != null) {
      return sourceEntry < targetEntry && targetExit < sourceExit;
    }

    final sourceNode = _getLocation(sourceId, _locations);
    if (sourceNode == null) {
      return false;
    }

    bool walk(LocationData node) {
      if (node.id == targetId) {
        return true;
      }
      for (final child in node.child) {
        if (walk(child)) {
          return true;
        }
      }
      return false;
    }

    return walk(sourceNode);
  }

  // 移動節點到目標位置
  // position: "before" (排序至該項目上), "child" (設為副目錄), "after" (排序至該項目下)
  void _moveLocationTo(String sourceId, String targetId, String position) {
    final moved = ref
        .read(worldSettingsDataProvider.notifier)
        .moveLocation(
          sourceId: sourceId,
          targetId: targetId,
          position: position,
        );
    if (!moved) {
      AppFeedback.warning(
        context,
        "無法移動到自己或自己的後代節點",
        duration: const Duration(seconds: 1),
      );
      return;
    }

    _refreshLocationIndex();
    _notifyChange();
  }

  Future<void> _deleteNode(String id) async {
    final location = _getLocation(id, _locations);
    if (location == null) return;
    final workspace = ref.read(itemWorkspaceProvider);
    final locationIds = LocationDeletionPlanner.collectSubtreeIds(location);
    final impact = LocationDeletionPlanner.inspect(
      locationIds: locationIds,
      itemClasses: workspace.itemClasses,
      itemInstances: workspace.itemInstances,
      itemRelations: workspace.itemRelations,
      itemClassStateChanges: workspace.itemClassStateChanges,
      itemInstanceStateChanges: workspace.itemInstanceStateChanges,
      locationStateChanges: workspace.locationStateChanges,
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.l10n.uiPermanentlyDelete((location.localName).toString()),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.uiToMakeALocationDisappearOnlyWithinThe),
            const SizedBox(height: 12),
            Text(
              context.l10n.uiPermanentlyDeleteLocationNodes(
                (impact.locationCount).toString(),
              ),
            ),
            Text(
              context.l10n.uiRemoveLocationSnapshots(
                (impact.snapshotCount).toString(),
              ),
            ),
            Text(
              context.l10n.uiRemoveItemLinks((impact.relationCount).toString()),
            ),
            Text(
              context.l10n.uiClearItemLocationRecords(
                (impact.itemPlacementCount).toString(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            key: const Key("location-permanent-delete-confirm"),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.uiDeletePermanently),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final cleanup = LocationDeletionPlanner.cleanup(
      locationIds: locationIds,
      itemClasses: workspace.itemClasses,
      itemInstances: workspace.itemInstances,
      itemRelations: workspace.itemRelations,
      itemClassStateChanges: workspace.itemClassStateChanges,
      itemInstanceStateChanges: workspace.itemInstanceStateChanges,
      locationStateChanges: workspace.locationStateChanges,
    );
    final removed = ref
        .read(worldSettingsDataProvider.notifier)
        .removeLocationById(id);
    if (!removed) {
      return;
    }
    ref
        .read(itemWorkspaceProvider.notifier)
        .setWorkspace(
          ItemWorkspaceData(
            itemClasses: cleanup.itemClasses,
            itemInstances: cleanup.itemInstances,
            itemRelations: cleanup.itemRelations,
            itemClassStateChanges: cleanup.itemClassStateChanges,
            itemInstanceStateChanges: cleanup.itemInstanceStateChanges,
            locationStateChanges: cleanup.locationStateChanges,
          ),
        );

    _refreshLocationIndex();
    if (selectedNodeId == id || lastSelectedNodeId == id) {
      setState(() {
        if (selectedNodeId == id) {
          selectedNodeId = null;
        }
        if (lastSelectedNodeId == id) {
          lastSelectedNodeId = null;
        }
      });
    }

    _syncDetailControllers();
    _notifyChange();
  }

  LocationData? _getLocation(String id, [List<LocationData>? locations]) {
    final indexed = _locationIndex[id];
    if (indexed != null) {
      return indexed;
    }

    return _findLocation(id, locations ?? _locations);
  }

  LocationData? _findLocation(String id, List<LocationData> locations) {
    for (final location in locations) {
      if (location.id == id) return location;
      final found = _findLocation(id, location.child);
      if (found != null) return found;
    }
    return null;
  }

  void _syncDetailControllers() {
    _isSyncingDetailControllers = true;
    try {
      final displayNodeId = selectedNodeId ?? lastSelectedNodeId;
      if (_customValueEditorLocationId != displayNodeId) {
        _customValueEditorLocationId = displayNodeId;
        _clearCustomValueEditor();
      }
      if (displayNodeId == null) {
        _setControllerTextIfChanged(locationNameController, "");
        _setControllerTextIfChanged(locationTypeController, "");
        _setControllerTextIfChanged(locationNoteController, "");
        return;
      }
      final location = _getLocation(displayNodeId, _locations);
      if (location != null) {
        _setControllerTextIfChanged(locationNameController, location.localName);
        _setControllerTextIfChanged(locationTypeController, location.localType);
        _setControllerTextIfChanged(locationNoteController, location.note);
        return;
      }

      _setControllerTextIfChanged(locationNameController, "");
      _setControllerTextIfChanged(locationTypeController, "");
      _setControllerTextIfChanged(locationNoteController, "");
    } finally {
      _isSyncingDetailControllers = false;
    }
  }

  void _setControllerTextIfChanged(
    TextEditingController controller,
    String text,
  ) {
    if (controller.text == text || _isComposing(controller)) {
      return;
    }
    controller.text = text;
  }

  void _showErrorDialog(String message) {
    AppDialog.message(
      context: context,
      title: context.l10n.uiError,
      message: message,
      closeLabel: context.l10n.commonConfirm,
      tone: AppFeedbackTone.error,
    );
  }

  void _showSuccessDialog(String message) {
    AppDialog.message(
      context: context,
      title: context.l10n.uiSuccess,
      message: message,
      closeLabel: context.l10n.commonConfirm,
      tone: AppFeedbackTone.success,
    );
  }
}

class _FlatNode {
  final LocationData node;
  final int depth;
  final LocationSnapshotState? snapshot;
  final bool unavailableAncestor;
  final bool retainedShell;

  const _FlatNode(
    this.node,
    this.depth, {
    this.snapshot,
    this.unavailableAncestor = false,
    this.retainedShell = false,
  });
}
