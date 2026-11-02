import 'package:monogatari_assistant/l10n/app_localization.dart';
import "dart:convert";

import "package:flutter/material.dart";

import "../../ui_library/spacing.dart";
import "../../domain/models/p2p_sync_models.dart";
import "../../ui_library/surface_shape.dart";

class P2pConflictResolutionDialog extends StatefulWidget {
  final List<P2pFieldConflictItem> conflicts;
  final ValueChanged<P2pConflictResolutionResult> onApply;
  final VoidCallback onCancel;

  const P2pConflictResolutionDialog({
    super.key,
    required this.conflicts,
    required this.onApply,
    required this.onCancel,
  });

  static Future<P2pConflictResolutionResult?> show(
    BuildContext context, {
    required List<P2pFieldConflictItem> conflicts,
  }) {
    return showDialog<P2pConflictResolutionResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => P2pConflictResolutionDialog(
        conflicts: conflicts,
        onApply: (result) => Navigator.of(dialogContext).pop(result),
        onCancel: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }

  @override
  State<P2pConflictResolutionDialog> createState() =>
      _P2pConflictResolutionDialogState();
}

class _P2pConflictResolutionDialogState
    extends State<P2pConflictResolutionDialog> {
  final Map<String, P2pConflictSide?> _groupDefaults =
      <String, P2pConflictSide?>{};
  final Map<String, P2pFieldConflictChoice> _fieldChoices =
      <String, P2pFieldConflictChoice>{};

  List<_P2pConflictGroup> get _groups {
    final grouped = <String, List<P2pFieldConflictItem>>{};
    for (final conflict in widget.conflicts) {
      grouped
          .putIfAbsent(_groupKey(conflict), () => <P2pFieldConflictItem>[])
          .add(conflict);
    }
    final groups =
        grouped.entries.map((entry) {
          final first = entry.value.first;
          final conflicts = entry.value.toList()
            ..sort((a, b) => a.fieldPath.compareTo(b.fieldPath));
          return _P2pConflictGroup(
            key: entry.key,
            type: first.groupType,
            id: first.groupId,
            label: first.groupLabel,
            conflicts: conflicts,
          );
        }).toList()..sort((a, b) {
          final type = a.type.compareTo(b.type);
          return type != 0 ? type : a.label.compareTo(b.label);
        });
    return groups;
  }

  String _groupKey(P2pFieldConflictItem conflict) {
    return "${conflict.groupType.length}:${conflict.groupType}/"
        "${conflict.groupId.length}:${conflict.groupId}";
  }

  P2pConflictSide? _effectiveSide(
    _P2pConflictGroup group,
    P2pFieldConflictItem conflict,
  ) {
    return switch (_fieldChoices[conflict.conflictId] ??
        P2pFieldConflictChoice.inheritGroup) {
      P2pFieldConflictChoice.inheritGroup => _groupDefaults[group.key],
      P2pFieldConflictChoice.local => P2pConflictSide.local,
      P2pFieldConflictChoice.remote => P2pConflictSide.remote,
    };
  }

  bool get _isComplete {
    return _groups.every(
      (group) => group.conflicts.every(
        (conflict) => _effectiveSide(group, conflict) != null,
      ),
    );
  }

  void _setAllDefaults(P2pConflictSide side) {
    setState(() {
      for (final group in _groups) {
        _groupDefaults[group.key] = side;
      }
    });
  }

  void _apply() {
    if (!_isComplete) return;
    final resolved = <String, P2pConflictSide>{};
    for (final group in _groups) {
      for (final conflict in group.conflicts) {
        resolved[conflict.conflictId] = _effectiveSide(group, conflict)!;
      }
    }
    widget.onApply(P2pConflictResolutionResult(resolved));
  }

  @override
  Widget build(BuildContext context) {
    final unresolvedCount = _groups.fold<int>(
      0,
      (count, group) =>
          count +
          group.conflicts
              .where((conflict) => _effectiveSide(group, conflict) == null)
              .length,
    );
    return AlertDialog(
      title: Text(context.l10n.uiSyncConflictsChooseAVersionForEachField),
      content: SizedBox(
        width: 760,
        height: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              unresolvedCount == 0
                  ? context.l10n.uiAllConflictingFieldsResolved(
                      context.formats.integer(widget.conflicts.length),
                    )
                  : context.l10n.uiUnresolvedFields(
                      (unresolvedCount).toString(),
                    ),
              key: const Key("p2p-conflict-progress"),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => _setAllDefaults(P2pConflictSide.local),
                  child: Text(context.l10n.uiDefaultAllFieldsToLocal),
                ),
                OutlinedButton(
                  onPressed: () => _setAllDefaults(P2pConflictSide.remote),
                  child: Text(context.l10n.uiDefaultAllFieldsToRemote),
                ),
              ],
            ),
            const Divider(height: 24),
            Expanded(
              child: ListView(
                children: _groups.map(_buildGroup).toList(growable: false),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const Key("p2p-conflict-cancel"),
          onPressed: widget.onCancel,
          child: Text(context.l10n.uiCancelAndKeepBothVersions),
        ),
        FilledButton(
          key: const Key("p2p-conflict-apply"),
          onPressed: _isComplete ? _apply : null,
          child: Text(
            context.l10n.uiApplyFieldChoicesAndFinishSync(
              context.formats.integer(widget.conflicts.length),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroup(_P2pConflictGroup group) {
    final defaultSide = _groupDefaults[group.key];
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: Key("p2p-conflict-group-${group.key}"),
        initiallyExpanded: false,
        title: Text("${_displayGroupType(group.type)}：${group.label}"),
        subtitle: Text(
          context.l10n.uiConflictingFields(
            context.formats.integer(group.conflicts.length),
            (_shortId(group.id)).toString(),
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                Text(context.l10n.uiDefaultVersion),
                ChoiceChip(
                  key: Key("p2p-group-local-${group.key}"),
                  label: Text(context.l10n.uiLocalVersion),
                  selected: defaultSide == P2pConflictSide.local,
                  onSelected: (_) => setState(() {
                    _groupDefaults[group.key] = P2pConflictSide.local;
                  }),
                ),
                ChoiceChip(
                  key: Key("p2p-group-remote-${group.key}"),
                  label: Text(context.l10n.uiRemoteVersion),
                  selected: defaultSide == P2pConflictSide.remote,
                  onSelected: (_) => setState(() {
                    _groupDefaults[group.key] = P2pConflictSide.remote;
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...group.conflicts.map(
            (conflict) => _buildFieldConflict(group, conflict),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldConflict(
    _P2pConflictGroup group,
    P2pFieldConflictItem conflict,
  ) {
    final choice =
        _fieldChoices[conflict.conflictId] ??
        P2pFieldConflictChoice.inheritGroup;
    final inherited = _groupDefaults[group.key];
    final inheritedLabel = switch (inherited) {
      P2pConflictSide.local => context.l10n.uiInheritLocalVersion,
      P2pConflictSide.remote => context.l10n.uiInheritRemoteVersion,
      null => context.l10n.uiInheritNotSet,
    };
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: AppSurfaceShape.borderRadius,
        ),
        child: ExpansionTile(
          key: Key("p2p-field-${conflict.conflictId}"),
          title: Text(
            context.l10n.uiConflictingField(
              context.l10n.conflictFieldPathLabel(conflict.fieldPathSegments),
            ),
          ),
          subtitle: Text(
            _effectiveSide(group, conflict) == null
                ? context.l10n.uiUnresolved
                : context.l10n.uiResolved,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          children: [
            _buildVersionPreview(
              context.l10n.uiCommonAncestor,
              conflict.base,
              characterType:
                  conflict.fieldPathSegments.length == 1 &&
                  conflict.fieldPathSegments.first == "角色類型",
            ),
            _buildVersionPreview(
              context.l10n.uiThisDevice,
              conflict.local,
              characterType:
                  conflict.fieldPathSegments.length == 1 &&
                  conflict.fieldPathSegments.first == "角色類型",
            ),
            _buildVersionPreview(
              context.l10n.uiPeer,
              conflict.remote,
              characterType:
                  conflict.fieldPathSegments.length == 1 &&
                  conflict.fieldPathSegments.first == "角色類型",
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    key: Key("p2p-field-inherit-${conflict.conflictId}"),
                    label: Text(inheritedLabel),
                    selected: choice == P2pFieldConflictChoice.inheritGroup,
                    onSelected: (_) => _setFieldChoice(
                      conflict,
                      P2pFieldConflictChoice.inheritGroup,
                    ),
                  ),
                  ChoiceChip(
                    key: Key("p2p-field-local-${conflict.conflictId}"),
                    label: Text(context.l10n.uiLocalVersion),
                    selected: choice == P2pFieldConflictChoice.local,
                    onSelected: (_) =>
                        _setFieldChoice(conflict, P2pFieldConflictChoice.local),
                  ),
                  ChoiceChip(
                    key: Key("p2p-field-remote-${conflict.conflictId}"),
                    label: Text(context.l10n.uiRemoteVersion),
                    selected: choice == P2pFieldConflictChoice.remote,
                    onSelected: (_) => _setFieldChoice(
                      conflict,
                      P2pFieldConflictChoice.remote,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setFieldChoice(
    P2pFieldConflictItem conflict,
    P2pFieldConflictChoice choice,
  ) {
    setState(() {
      _fieldChoices[conflict.conflictId] = choice;
    });
  }

  Widget _buildVersionPreview(
    String label,
    P2pFieldValue value, {
    bool characterType = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: Theme.of(context).textTheme.labelMedium),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: AppSurfaceShape.borderRadius,
              ),
              child: SelectableText(
                characterType && value.exists && value.value is String
                    ? context.l10n.characterTypeLabel(value.value! as String)
                    : _displayValue(value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _displayValue(P2pFieldValue value) {
    if (!value.exists) return context.l10n.uiMissingDeleted;
    final raw = value.value;
    if (raw is Map || raw is List) {
      try {
        return const JsonEncoder.withIndent("  ").convert(raw);
      } catch (_) {
        return raw.toString();
      }
    }
    return raw?.toString() ?? "null";
  }

  String _shortId(String id) => id.length <= 8 ? id : id.substring(0, 8);

  String _displayGroupType(String type) => switch (type) {
    "project" => context.l10n.uiWork,
    "character" => context.l10n.uiCharacters3,
    "projectRemainder" => context.l10n.uiProjectSections,
    "itemWorkspace" => context.l10n.uiItem,
    "phrase" => context.l10n.uiPhrases,
    "phraseLibrary" => context.l10n.uiPhraseLibrary,
    _ => type,
  };
}

class _P2pConflictGroup {
  final String key;
  final String type;
  final String id;
  final String label;
  final List<P2pFieldConflictItem> conflicts;

  const _P2pConflictGroup({
    required this.key,
    required this.type,
    required this.id,
    required this.label,
    required this.conflicts,
  });
}
