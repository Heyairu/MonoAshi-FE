import 'package:monogatari_assistant/l10n/app_localization.dart';
import "package:flutter/material.dart";

import "../../ui_library/spacing.dart";
import "../../ui_library/surface_shape.dart";

import "inline_annotation.dart";
import "inline_annotation_anchored_popup.dart";
import "inline_annotation_parser.dart";
import "inline_annotation_syntax.dart";
import "inline_annotation_target_resolver.dart";
import "../../ui_library/forms.dart";

enum InlineAnnotationDetailsAction {
  applyDisplayText,
  applySyntax,
  editAnnotation,
  navigateToTarget,
  relinkTarget,
  copySyntax,
  updateToPrimaryName,
  removeKeepText,
}

final class InlineAnnotationDetailsResult {
  final InlineAnnotationDetailsAction action;
  final String? displayText;
  final String? rawSyntax;

  const InlineAnnotationDetailsResult(
    this.action, {
    this.displayText,
    this.rawSyntax,
  });
}

abstract final class InlineAnnotationDetailsDialog {
  static Future<InlineAnnotationDetailsResult?> show({
    required BuildContext context,
    required InlineAnnotation annotation,
    required String rawSyntax,
    InlineAnnotationTargetInfo? target,
    Rect? anchor,
  }) {
    return InlineAnnotationAnchoredPopup.show<InlineAnnotationDetailsResult>(
      context: context,
      anchor: anchor,
      width: 320,
      builder: (_) => _InlineAnnotationQuickEditor(
        annotation: annotation,
        rawSyntax: rawSyntax,
        target: target,
      ),
    );
  }
}

class _InlineAnnotationQuickEditor extends StatefulWidget {
  final InlineAnnotation annotation;
  final String rawSyntax;
  final InlineAnnotationTargetInfo? target;

  const _InlineAnnotationQuickEditor({
    required this.annotation,
    required this.rawSyntax,
    required this.target,
  });

  @override
  State<_InlineAnnotationQuickEditor> createState() =>
      _InlineAnnotationQuickEditorState();
}

class _InlineAnnotationQuickEditorState
    extends State<_InlineAnnotationQuickEditor> {
  late final TextEditingController _displayController;
  late final TextEditingController _rawSyntaxController;
  late final TextEditingController _noteController;
  String? _syntaxError;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController(
      text: widget.annotation.displayText,
    );
    _rawSyntaxController = TextEditingController(text: widget.rawSyntax);
    _noteController = TextEditingController(text: widget.annotation.note ?? "");
  }

  @override
  void dispose() {
    _displayController.dispose();
    _rawSyntaxController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _apply() {
    if (_noteController.text != (widget.annotation.note ?? "")) {
      final parsed = const InlineAnnotationParser().parse(
        _rawSyntaxController.text,
      );
      if (parsed.length != 1 ||
          parsed.single.sourceRange.end != _rawSyntaxController.text.length ||
          parsed.single.sourceRange.start != 0) {
        setState(
          () => _syntaxError =
              context.l10n.uiInvalidAnnotationSyntaxCorrectItBeforeApplying,
        );
        return;
      }
      final annotation = parsed.single;
      _rawSyntaxController.text = InlineAnnotationSyntax.format(
        kind: annotation.kind,
        state: annotation.state,
        colors: annotation.colors,
        targetId: annotation.targetId,
        displayText:
            annotation.kind == InlineAnnotationKind.emphasis &&
                _displayController.text.trim().isEmpty
            ? widget.annotation.displayText
            : _displayController.text,
        note: _noteController.text,
      );
    }
    final rawSyntax = _rawSyntaxController.text;
    if (rawSyntax != widget.rawSyntax) {
      final parsed = const InlineAnnotationParser().parse(rawSyntax);
      if (parsed.length != 1 ||
          parsed.single.sourceRange.start != 0 ||
          parsed.single.sourceRange.end != rawSyntax.length) {
        setState(
          () => _syntaxError =
              context.l10n.uiInvalidAnnotationSyntaxCorrectItBeforeApplying,
        );
        return;
      }
      Navigator.of(context).pop(
        InlineAnnotationDetailsResult(
          InlineAnnotationDetailsAction.applySyntax,
          rawSyntax: rawSyntax,
        ),
      );
      return;
    }
    final entered = _displayController.text;
    Navigator.of(context).pop(
      InlineAnnotationDetailsResult(
        InlineAnnotationDetailsAction.applyDisplayText,
        displayText:
            widget.annotation.kind == InlineAnnotationKind.emphasis &&
                entered.trim().isEmpty
            ? widget.annotation.displayText
            : entered,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      key: const ValueKey("inline-annotation-quick-editor"),
      elevation: 10,
      color: colors.surfaceContainerHigh,
      borderRadius: AppSurfaceShape.borderRadius,
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.alternate_email, size: 18, color: colors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Mention",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.commonClose,
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
              _buildDisplayField(),
              const SizedBox(height: 8),
              TextField(
                key: const ValueKey("inline-annotation-note"),
                controller: _noteController,
                minLines: 1,
                maxLines: 3,
                decoration: appFieldDecoration(
                  context,
                  decoration: InputDecoration(
                    labelText: context.l10n.uiNotes,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                key: const ValueKey("inline-annotation-basic-info"),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: AppSurfaceShape.borderRadius,
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      label: context.l10n.uiType,
                      value: _kindLabel(widget.annotation.kind),
                    ),
                    _InfoRow(
                      label: context.l10n.uiTarget,
                      value:
                          widget.target?.primaryName ??
                          (widget.annotation.targetId == null
                              ? "不適用"
                              : "遺失的對象"),
                    ),
                    if (widget.annotation.targetId case final targetId?)
                      _InfoRow(label: "UUID", value: targetId),
                    _InfoRow(
                      label: context.l10n.uiStatus,
                      value: _stateLabel(widget.annotation.state),
                    ),
                    _InfoRow(
                      label: context.l10n.uiColor,
                      value:
                          "${widget.annotation.colors.background}${widget.annotation.colors.foreground}",
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildSyntaxField(context),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.end,
                runSpacing: 4,
                spacing: 8,
                children: [
                  if (widget.target != null)
                    TextButton.icon(
                      key: const ValueKey("inline-annotation-open-target"),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => Navigator.of(context).pop(
                        const InlineAnnotationDetailsResult(
                          InlineAnnotationDetailsAction.navigateToTarget,
                        ),
                      ),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: Text(context.l10n.uiOpenNode),
                    ),
                  _buildMoreMenu(),
                  OutlinedButton.icon(
                    key: const ValueKey("inline-annotation-edit"),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => Navigator.of(context).pop(
                      const InlineAnnotationDetailsResult(
                        InlineAnnotationDetailsAction.editAnnotation,
                      ),
                    ),
                    icon: const Icon(Icons.tune, size: 16),
                    label: Text(context.l10n.uiEditAnnotation),
                  ),
                  FilledButton(
                    key: const ValueKey("inline-annotation-quick-apply"),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: _apply,
                    child: Text(context.l10n.uiApply),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreMenu() {
    final canRelink =
        widget.target == null && widget.annotation.targetId != null;
    final canUpdateName =
        widget.target != null &&
        widget.target!.primaryName != widget.annotation.displayText;
    return PopupMenuButton<InlineAnnotationDetailsAction>(
      key: const ValueKey("inline-annotation-more"),
      tooltip: context.l10n.uiMoreAnnotationActions,
      onSelected: (action) =>
          Navigator.of(context).pop(InlineAnnotationDetailsResult(action)),
      itemBuilder: (_) => [
        if (canUpdateName)
          PopupMenuItem(
            key: ValueKey("inline-annotation-update-name"),
            value: InlineAnnotationDetailsAction.updateToPrimaryName,
            child: _AnnotationMenuLabel(
              icon: Icons.drive_file_rename_outline,
              label: context.l10n.uiUpdateToCurrentName,
            ),
          ),
        if (canRelink)
          PopupMenuItem(
            key: ValueKey("inline-annotation-relink"),
            value: InlineAnnotationDetailsAction.relinkTarget,
            child: _AnnotationMenuLabel(
              icon: Icons.add_link,
              label: context.l10n.uiRelinkMissingTarget,
            ),
          ),
        PopupMenuItem(
          key: ValueKey("inline-annotation-remove-keep-text"),
          value: InlineAnnotationDetailsAction.removeKeepText,
          child: _AnnotationMenuLabel(
            icon: Icons.link_off,
            label: context.l10n.uiRemoveAnnotationKeepText,
          ),
        ),
      ],
      icon: const Icon(Icons.more_horiz, size: 18),
    );
  }

  String _kindLabel(InlineAnnotationKind kind) => switch (kind) {
    InlineAnnotationKind.character => context.l10n.uiCharacter,
    InlineAnnotationKind.location => context.l10n.uiLocation,
    InlineAnnotationKind.event => context.l10n.uiEvent,
    InlineAnnotationKind.foreshadowing => context.l10n.uiForeshadowing,
    InlineAnnotationKind.plan => context.l10n.uiPlan,
    InlineAnnotationKind.item => context.l10n.uiItem,
    InlineAnnotationKind.emphasis => context.l10n.uiHighlight,
  };

  Widget _buildDisplayField() {
    return TextField(
      key: const ValueKey("inline-annotation-quick-display-text"),
      controller: _displayController,
      autofocus: true,
      decoration: appFieldDecoration(
        context,
        decoration: InputDecoration(
          labelText: context.l10n.uiDisplayText,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
      ),
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _apply(),
    );
  }

  Widget _buildSyntaxField(BuildContext context) {
    return TextField(
      key: const ValueKey("inline-annotation-quick-syntax"),
      controller: _rawSyntaxController,
      maxLines: 1,
      autocorrect: false,
      enableSuggestions: false,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(fontFamily: "monospace", fontSize: 11),
      decoration: appFieldDecoration(
        context,
        textStyle: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontFamily: "monospace", fontSize: 11),
        decoration: InputDecoration(
          labelText: context.l10n.uiFullSyntax,
          errorText: _syntaxError,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          suffixIcon: IconButton(
            key: const ValueKey("inline-annotation-copy-syntax"),
            tooltip: context.l10n.uiCopySyntax,
            visualDensity: VisualDensity.compact,
            onPressed: () => Navigator.of(context).pop(
              InlineAnnotationDetailsResult(
                InlineAnnotationDetailsAction.copySyntax,
                rawSyntax: _rawSyntaxController.text,
              ),
            ),
            icon: const Icon(Icons.copy_outlined, size: 16),
          ),
        ),
      ),
      onChanged: (_) {
        if (_syntaxError != null) setState(() => _syntaxError = null);
      },
    );
  }

  String _stateLabel(InlineAnnotationState state) => switch (state) {
    InlineAnnotationState.none => context.l10n.uiGeneral,
    InlineAnnotationState.start => context.l10n.uiStart,
    InlineAnnotationState.end => context.l10n.uiEnd,
  };
}

class _AnnotationMenuLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AnnotationMenuLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 18), const SizedBox(width: 10), Text(label)],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42,
            child: Text(
              label,
              style: style?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: style)),
        ],
      ),
    );
  }
}
