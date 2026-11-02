import 'package:monogatari_assistant/l10n/app_localization.dart';
import "package:flutter/material.dart";

import "../../bin/ui_library.dart";
import "../../models/item_snapshot_data.dart";
import "../../models/location_snapshot_data.dart";

/// Callers merge these patches into the selected event, preserving baseline
/// data and unrelated overrides.
class ItemSnapshotStateEditor extends StatelessWidget {
  final ItemSnapshotState state;
  final ValueChanged<ItemStatePatch>? onChanged;
  final List<DropdownOption<String>> characters;
  final List<DropdownOption<String>> locations;

  const ItemSnapshotStateEditor({
    super.key,
    required this.state,
    this.onChanged,
    this.characters = const [],
    this.locations = const [],
  });

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _snapshotText(
          "name",
          context.l10n.uiNameAtThisPoint,
          state.name,
          onChanged == null
              ? null
              : (value) =>
                    onChanged!(ItemStatePatch(name: StateValue.set(value))),
        ),
        _snapshotText(
          "description",
          context.l10n.uiDescriptionAtThisPoint,
          state.description,
          onChanged == null
              ? null
              : (value) => onChanged!(
                  ItemStatePatch(description: StateValue.set(value)),
                ),
          lines: 3,
        ),
        _snapshotText(
          "status",
          context.l10n.uiStatus,
          state.status,
          onChanged == null
              ? null
              : (value) =>
                    onChanged!(ItemStatePatch(status: StateValue.set(value))),
        ),
        _snapshotSwitch(
          "exists",
          context.l10n.uiExistsAtThisPoint,
          state.exists,
          onChanged == null
              ? null
              : (value) =>
                    onChanged!(ItemStatePatch(exists: StateValue.set(value))),
        ),
        _snapshotReference(
          context,
          "holder",
          context.l10n.uiHolder,
          state.holderCharacterId,
          characters,
          onChanged == null
              ? null
              : (value) => onChanged!(
                  ItemStatePatch(
                    holderCharacterId: StateValue<String?>.set(value),
                  ),
                ),
        ),
        _snapshotReference(
          context,
          "location",
          context.l10n.uiLocation2,
          state.locationId,
          locations,
          onChanged == null
              ? null
              : (value) => onChanged!(
                  ItemStatePatch(locationId: StateValue<String?>.set(value)),
                ),
        ),
        for (final entry in state.properties.entries)
          _snapshotText(
            "property-${entry.key}",
            entry.key,
            entry.value,
            onChanged == null
                ? null
                : (value) => onChanged!(
                    ItemStatePatch(
                      properties: StateValue.set({
                        ...state.properties,
                        entry.key: value,
                      }),
                    ),
                  ),
          ),
      ],
    ),
  );
}

class LocationSnapshotStateEditor extends StatelessWidget {
  final LocationSnapshotState state;
  final ValueChanged<LocationStatePatch>? onChanged;
  final List<DropdownOption<String>> characters;

  const LocationSnapshotStateEditor({
    super.key,
    required this.state,
    this.onChanged,
    this.characters = const [],
  });

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _snapshotText(
          "name",
          context.l10n.uiNameAtThisPoint,
          state.name,
          onChanged == null
              ? null
              : (value) =>
                    onChanged!(LocationStatePatch(name: StateValue.set(value))),
        ),
        _snapshotText(
          "description",
          context.l10n.uiDescriptionAtThisPoint,
          state.description,
          onChanged == null
              ? null
              : (value) => onChanged!(
                  LocationStatePatch(description: StateValue.set(value)),
                ),
          lines: 3,
        ),
        _snapshotText(
          "status",
          context.l10n.uiStatus,
          state.status,
          onChanged == null
              ? null
              : (value) => onChanged!(
                  LocationStatePatch(status: StateValue.set(value)),
                ),
        ),
        _snapshotSwitch(
          "exists",
          context.l10n.uiExistsAtThisPoint,
          state.exists,
          onChanged == null
              ? null
              : (value) => onChanged!(
                  LocationStatePatch(exists: StateValue.set(value)),
                ),
        ),
        _snapshotSwitch(
          "accessible",
          context.l10n.uiAccessible,
          state.accessible,
          onChanged == null
              ? null
              : (value) => onChanged!(
                  LocationStatePatch(accessible: StateValue.set(value)),
                ),
        ),
        _snapshotReference(
          context,
          "controller",
          context.l10n.uiController2,
          state.controllerCharacterId,
          characters,
          onChanged == null
              ? null
              : (value) => onChanged!(
                  LocationStatePatch(
                    controllerCharacterId: StateValue<String?>.set(value),
                  ),
                ),
        ),
        for (final entry in state.properties.entries)
          _snapshotText(
            "property-${entry.key}",
            entry.key,
            entry.value,
            onChanged == null
                ? null
                : (value) => onChanged!(
                    LocationStatePatch(
                      properties: StateValue.set({
                        ...state.properties,
                        entry.key: value,
                      }),
                    ),
                  ),
          ),
      ],
    ),
  );
}

Widget _snapshotSwitch(
  String id,
  String label,
  bool value,
  ValueChanged<bool>? onChanged,
) => Padding(
  padding: const EdgeInsets.only(bottom: AppSpacing.md),
  child: SwitchListTile(
    key: ValueKey("snapshot-state-$id"),
    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    title: Text(label),
    value: value,
    onChanged: onChanged,
  ),
);

Widget _snapshotText(
  String id,
  String label,
  String value,
  ValueChanged<String>? onChanged, {
  int lines = 1,
}) => Padding(
  padding: const EdgeInsets.only(bottom: AppSpacing.md),
  child: TextFormField(
    key: ValueKey("snapshot-state-$id"),
    initialValue: value,
    enabled: onChanged != null,
    minLines: lines,
    maxLines: lines,
    decoration: InputDecoration(labelText: label, isDense: true),
    onChanged: onChanged,
  ),
);

Widget _snapshotReference(
  BuildContext context,
  String id,
  String label,
  String? value,
  List<DropdownOption<String>> options,
  ValueChanged<String?>? onChanged,
) => Padding(
  padding: const EdgeInsets.only(bottom: AppSpacing.md),
  child: AppDropdownField<String>(
    key: ValueKey("snapshot-state-$id"),
    value: value ?? "",
    labelText: label,
    options: [
      DropdownOption(value: "", label: context.l10n.uiNotSet),
      if (value != null && !options.any((option) => option.value == value))
        DropdownOption(value: value, label: context.l10n.uiNotFound(value)),
      ...options,
    ],
    onChanged: onChanged == null
        ? null
        : (value) => onChanged(value == "" ? null : value),
  ),
);
