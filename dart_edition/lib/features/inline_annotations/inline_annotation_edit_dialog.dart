import 'package:monogatari_assistant/l10n/app_localization.dart';
import "../help/help_scope.dart";
import "../help/help_topic.dart";
import "package:flutter/material.dart";

import "../../ui_library/spacing.dart";
import "../../ui_library/dialogs.dart";
import "inline_annotation.dart";
import "inline_annotation_anchored_popup.dart";
import "inline_annotation_parser.dart";
import "inline_annotation_syntax.dart";
import "../../ui_library/forms.dart";
import "../../ui_library/control_size.dart";

abstract final class InlineAnnotationEditDialog {
  static Future<String?> show({
    required BuildContext context,
    required InlineAnnotation annotation,
    String? rawSyntax,
    Rect? anchor,
  }) {
    return InlineAnnotationAnchoredPopup.show<String>(
      context: context,
      anchor: anchor,
      width: 460,
      barrierDismissible: false,
      builder: (_) => HelpTarget(
        topicId: HelpTopicId.annotations,
        child: _InlineAnnotationEditForm(
          annotation: annotation,
          rawSyntax: rawSyntax,
          anchored: anchor != null,
        ),
      ),
    );
  }
}

class _InlineAnnotationEditForm extends StatefulWidget {
  final InlineAnnotation annotation;
  final String? rawSyntax;
  final bool anchored;

  const _InlineAnnotationEditForm({
    required this.annotation,
    required this.rawSyntax,
    required this.anchored,
  });

  @override
  State<_InlineAnnotationEditForm> createState() =>
      _InlineAnnotationEditFormState();
}

class _InlineAnnotationEditFormState extends State<_InlineAnnotationEditForm> {
  late InlineAnnotationKind _kind;
  late InlineAnnotationState _annotationState;
  late String _background;
  late String _foreground;
  late final TextEditingController _targetController;
  late final TextEditingController _displayController;
  late final TextEditingController _noteController;
  late final TextEditingController _rawSyntaxController;
  late final String _initialRawSyntax;
  String? _errorText;

  static const _colorCodes = <String>["0", "A", "B", "C", "D", "E", "F"];

  @override
  void initState() {
    super.initState();
    final annotation = widget.annotation;
    _kind = annotation.kind;
    _annotationState = annotation.state;
    _background = annotation.colors.background;
    _foreground = annotation.colors.foreground;
    _targetController = TextEditingController(text: annotation.targetId ?? "");
    _displayController = TextEditingController(text: annotation.displayText);
    _noteController = TextEditingController(text: annotation.note ?? "");
    _initialRawSyntax =
        widget.rawSyntax ??
        InlineAnnotationSyntax.format(
          kind: annotation.kind,
          state: annotation.state,
          colors: annotation.colors,
          targetId: annotation.targetId,
          displayText: annotation.displayText,
          note: annotation.note,
        );
    _rawSyntaxController = TextEditingController(text: _initialRawSyntax);
  }

  @override
  void dispose() {
    _targetController.dispose();
    _displayController.dispose();
    _noteController.dispose();
    _rawSyntaxController.dispose();
    super.dispose();
  }

  void _submit() {
    try {
      if (_rawSyntaxController.text != _initialRawSyntax) {
        final source = _rawSyntaxController.text;
        final parsed = const InlineAnnotationParser().parse(source);
        if (parsed.length != 1 ||
            parsed.single.sourceRange.start != 0 ||
            parsed.single.sourceRange.end != source.length) {
          throw const FormatException("完整語法無效");
        }
        Navigator.of(context).pop(source);
        return;
      }
      final enteredDisplayText = _displayController.text;
      final source = InlineAnnotationSyntax.format(
        kind: _kind,
        state: _kind == InlineAnnotationKind.emphasis
            ? InlineAnnotationState.none
            : _annotationState,
        colors: InlineAnnotationColorCode(
          background: _background,
          foreground: _foreground,
        ),
        targetId: _kind == InlineAnnotationKind.emphasis
            ? null
            : _targetController.text.trim(),
        displayText:
            _kind == InlineAnnotationKind.emphasis &&
                enteredDisplayText.trim().isEmpty
            ? widget.annotation.displayText
            : enteredDisplayText,
        note: _noteController.text,
      );
      Navigator.of(context).pop(source);
    } on FormatException catch (error) {
      setState(() => _errorText = _formatError(error));
    }
  }

  String _formatError(FormatException error) {
    if (_kind != InlineAnnotationKind.emphasis &&
        _targetController.text.trim().isEmpty) {
      return context.l10n.uiThisAnnotationTypeRequiresAUUID;
    }
    return context.l10n.uiInvalidAnnotationData((error.message).toString());
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: context.l10n.uiEditAnnotation,
      icon: Icons.edit_note_outlined,
      scrollable: true,
      maxWidth: 440,
      insetPadding: widget.anchored
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      content: SizedBox(
        width: 408,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<InlineAnnotationKind>(
              isDense: true,
              isExpanded: true,
              iconSize: AppControlSize.smallIcon,
              itemHeight: appDropdownItemHeight(context),
              menuMaxHeight: AppControlSize.menuMaxHeight,
              key: const ValueKey("inline-annotation-kind"),
              initialValue: _kind,
              style: appDropdownTextStyle(
                context,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              decoration: appDropdownFieldDecoration(
                context,
                textStyle: Theme.of(context).textTheme.bodyMedium,
                decoration: _decoration(context.l10n.uiType),
              ),
              items: [
                for (final kind in InlineAnnotationKind.values)
                  DropdownMenuItem(
                    value: kind,
                    child: Text(_kindLabel(context.l10n, kind)),
                  ),
              ],
              onChanged: (kind) {
                if (kind == null) return;
                setState(() {
                  _kind = kind;
                  if (kind == InlineAnnotationKind.emphasis) {
                    _annotationState = InlineAnnotationState.none;
                  }
                  _errorText = null;
                });
              },
            ),
            const SizedBox(height: 8),
            if (_kind != InlineAnnotationKind.emphasis) ...[
              DropdownButtonFormField<InlineAnnotationState>(
                isDense: true,
                isExpanded: true,
                iconSize: AppControlSize.smallIcon,
                itemHeight: appDropdownItemHeight(context),
                menuMaxHeight: AppControlSize.menuMaxHeight,
                key: const ValueKey("inline-annotation-state"),
                initialValue: _annotationState,
                style: appDropdownTextStyle(
                  context,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                decoration: appDropdownFieldDecoration(
                  context,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  decoration: _decoration(context.l10n.uiStatus),
                ),
                items: [
                  for (final state in InlineAnnotationState.values)
                    DropdownMenuItem(
                      value: state,
                      child: Text(_stateLabel(context.l10n, state)),
                    ),
                ],
                onChanged: (state) {
                  if (state != null) setState(() => _annotationState = state);
                },
              ),
              const SizedBox(height: 8),
              TextField(
                key: const ValueKey("inline-annotation-target"),
                controller: _targetController,
                decoration: appFieldDecoration(
                  context,
                  decoration: _decoration("UUID"),
                ),
                autocorrect: false,
                enableSuggestions: false,
              ),
              const SizedBox(height: 8),
            ],
            TextField(
              key: const ValueKey("inline-annotation-display-text"),
              controller: _displayController,
              decoration: appFieldDecoration(
                context,
                decoration: _decoration(context.l10n.uiDisplayText),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isDense: true,
                    isExpanded: true,
                    iconSize: AppControlSize.smallIcon,
                    itemHeight: appDropdownItemHeight(context),
                    menuMaxHeight: AppControlSize.menuMaxHeight,
                    key: const ValueKey("inline-annotation-background"),
                    initialValue: _background,
                    style: appDropdownTextStyle(
                      context,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    decoration: appDropdownFieldDecoration(
                      context,
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      decoration: _decoration(
                        context.l10n.uiBackgroundColorCode,
                      ),
                    ),
                    items: _colorItems,
                    onChanged: (value) {
                      if (value != null) setState(() => _background = value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isDense: true,
                    isExpanded: true,
                    iconSize: AppControlSize.smallIcon,
                    itemHeight: appDropdownItemHeight(context),
                    menuMaxHeight: AppControlSize.menuMaxHeight,
                    key: const ValueKey("inline-annotation-foreground"),
                    initialValue: _foreground,
                    style: appDropdownTextStyle(
                      context,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    decoration: appDropdownFieldDecoration(
                      context,
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      decoration: _decoration(context.l10n.uiTextColorCode),
                    ),
                    items: _colorItems,
                    onChanged: (value) {
                      if (value != null) setState(() => _foreground = value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              key: const ValueKey("inline-annotation-note"),
              controller: _noteController,
              decoration: appFieldDecoration(
                context,
                decoration: _decoration(context.l10n.uiNotesOptional),
              ),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            TextField(
              key: const ValueKey("inline-annotation-raw-syntax-editor"),
              controller: _rawSyntaxController,
              decoration: appFieldDecoration(
                context,
                textStyle: const TextStyle(fontFamily: "monospace"),
                decoration: _decoration(
                  context.l10n.uiFullSyntax,
                  helperText:
                      context.l10n.uiEditingThisFieldAppliesTheFullSyntaxIn,
                ),
              ),
              minLines: 2,
              maxLines: 4,
              autocorrect: false,
              enableSuggestions: false,
              style: const TextStyle(fontFamily: "monospace"),
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _errorText!,
                  key: const ValueKey("inline-annotation-edit-error"),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.commonCancel),
        ),
        FilledButton(
          key: const ValueKey("inline-annotation-save"),
          style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
          onPressed: _submit,
          child: Text(context.l10n.commonSave),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> get _colorItems => [
    for (final code in _colorCodes)
      DropdownMenuItem(
        value: code,
        child: Text(code == "0" ? context.l10n.uiAutomatic : code),
      ),
  ];

  InputDecoration _decoration(String label, {String? helperText}) {
    return InputDecoration(
      labelText: label,
      helperText: helperText,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
    );
  }

  static String _kindLabel(AppLocalizations l10n, InlineAnnotationKind kind) =>
      switch (kind) {
        InlineAnnotationKind.character => l10n.uiCharacter,
        InlineAnnotationKind.location => l10n.uiLocation,
        InlineAnnotationKind.event => l10n.uiEvent,
        InlineAnnotationKind.foreshadowing => l10n.uiForeshadowing,
        InlineAnnotationKind.plan => l10n.uiPlan,
        InlineAnnotationKind.item => l10n.uiItem,
        InlineAnnotationKind.emphasis => l10n.uiHighlight,
      };

  static String _stateLabel(
    AppLocalizations l10n,
    InlineAnnotationState state,
  ) => switch (state) {
    InlineAnnotationState.none => l10n.uiGeneral,
    InlineAnnotationState.start => l10n.uiStart,
    InlineAnnotationState.end => l10n.uiEnd,
  };
}
