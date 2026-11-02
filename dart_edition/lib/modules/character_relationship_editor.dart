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

import "../models/character_data.dart";
import "../ui_library/dialogs.dart";
import "../ui_library/forms.dart";
import "character_relationship_resolver.dart";
import "../ui_library/control_size.dart";

class CharacterRelationshipEditorResult {
  final String sourceCharacterId;
  final String person;
  final String description;
  final String internalRelationship;
  final bool bidirectional;

  const CharacterRelationshipEditorResult({
    required this.sourceCharacterId,
    required this.person,
    required this.description,
    this.internalRelationship = "",
    this.bidirectional = false,
  });
}

class CharacterRelationshipEditor {
  const CharacterRelationshipEditor._();

  static Future<CharacterRelationshipEditorResult?> show({
    required BuildContext context,
    required Map<String, CharacterEntryData> characters,
    String? sourceCharacterId,
    String initialPerson = "",
    String initialDescription = "",
    String initialInternalRelationship = "",
    bool allowSourceSelection = true,
    bool allowBidirectional = true,
    String? title,
  }) {
    return AppDialog.showCustom<CharacterRelationshipEditorResult>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _CharacterRelationshipEditorDialog(
        title: title,
        characters: characters,
        sourceCharacterId: sourceCharacterId,
        initialPerson: initialPerson,
        initialDescription: initialDescription,
        initialInternalRelationship: initialInternalRelationship,
        allowSourceSelection: allowSourceSelection,
        allowBidirectional: allowBidirectional,
      ),
    );
  }
}

class _CharacterRelationshipEditorDialog extends StatefulWidget {
  final String? title;
  final Map<String, CharacterEntryData> characters;
  final String? sourceCharacterId;
  final String initialPerson;
  final String initialDescription;
  final String initialInternalRelationship;
  final bool allowSourceSelection;
  final bool allowBidirectional;

  const _CharacterRelationshipEditorDialog({
    required this.title,
    required this.characters,
    required this.sourceCharacterId,
    required this.initialPerson,
    required this.initialDescription,
    required this.initialInternalRelationship,
    required this.allowSourceSelection,
    required this.allowBidirectional,
  });

  @override
  State<_CharacterRelationshipEditorDialog> createState() =>
      _CharacterRelationshipEditorDialogState();
}

class _CharacterRelationshipEditorDialogState
    extends State<_CharacterRelationshipEditorDialog> {
  late final TextEditingController _personController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _internalController;
  late String? _sourceCharacterId;
  bool _bidirectional = false;

  @override
  void initState() {
    super.initState();
    _personController = TextEditingController(text: widget.initialPerson);
    _descriptionController = TextEditingController(
      text: widget.initialDescription,
    );
    _internalController = TextEditingController(
      text: widget.initialInternalRelationship,
    );
    _sourceCharacterId =
        widget.sourceCharacterId ?? widget.characters.keys.firstOrNull;
  }

  @override
  void dispose() {
    _personController.dispose();
    _descriptionController.dispose();
    _internalController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _sourceCharacterId != null && _personController.text.trim().isNotEmpty;

  void _submit() {
    if (!_canSubmit) return;
    Navigator.of(context).pop(
      CharacterRelationshipEditorResult(
        sourceCharacterId: _sourceCharacterId!,
        person: _personController.text.trim(),
        description: _descriptionController.text.trim(),
        internalRelationship: _internalController.text.trim(),
        bidirectional: widget.allowBidirectional && _bidirectional,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final targetOptions = widget.characters.entries
        .where((entry) => entry.key != _sourceCharacterId)
        .map(
          (entry) => CharacterRelationshipResolver.displayLabel(
            entry.key,
            widget.characters,
          ),
        )
        .toList(growable: false);
    return AppDialog(
      title: widget.title ?? context.l10n.uiAddCharacterRelationship,
      icon: Icons.hub_outlined,
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              style: appDropdownTextStyle(context),
              isDense: true,
              isExpanded: true,
              iconSize: AppControlSize.smallIcon,
              itemHeight: appDropdownItemHeight(context),
              menuMaxHeight: AppControlSize.menuMaxHeight,
              key: const ValueKey("relationship-source-field"),
              initialValue: _sourceCharacterId,
              decoration: appDropdownFieldDecoration(
                context,
                decoration: InputDecoration(
                  labelText: context.l10n.uiSourceCharacter,
                ),
              ),
              items: [
                for (final entry in widget.characters.entries)
                  DropdownMenuItem(
                    value: entry.key,
                    child: Text(
                      CharacterRelationshipResolver.displayLabel(
                        entry.key,
                        widget.characters,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: widget.allowSourceSelection
                  ? (value) {
                      setState(() => _sourceCharacterId = value);
                    }
                  : null,
            ),
            const SizedBox(height: 16),
            AppComboBoxField(
              key: const ValueKey("relationship-target-combobox"),
              controller: _personController,
              options: targetOptions,
              labelText: context.l10n.uiTargetCharacter,
              hintText: context.l10n.uiSelectAnExistingCharacterOrEnterANew,
              onChanged: (_) => setState(() {}),
              onSelected: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            AppTextField(
              key: const ValueKey("relationship-description-field"),
              controller: _descriptionController,
              labelText: context.l10n.uiExternalRelationship,
              hintText: context.l10n.uiForExampleFriendFamilyRival,
              maxLines: 1,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            AppTextField(
              key: const ValueKey("relationship-internal-field"),
              controller: _internalController,
              labelText: context.l10n.uiInternalRelationship,
              hintText: context.l10n.uiForExampleTrustAdmirationEnvy,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            if (widget.allowBidirectional) ...[
              const SizedBox(height: 8),
              CheckboxListTile(
                key: const ValueKey("bidirectional-relationship-checkbox"),
                value: _bidirectional,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(context.l10n.uiBidirectionalRelationship),
                subtitle: Text(
                  context.l10n.uiAlsoCreateARelationshipFromTheTargetBack,
                ),
                onChanged: (value) {
                  setState(() => _bidirectional = value ?? false);
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _canSubmit ? _submit : null,
          child: Text(context.l10n.commonSave),
        ),
      ],
    );
  }
}
