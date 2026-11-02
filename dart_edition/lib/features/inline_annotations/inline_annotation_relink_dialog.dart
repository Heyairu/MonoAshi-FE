import 'package:monogatari_assistant/l10n/app_localization.dart';
import "package:flutter/material.dart";

import "../../ui_library/dialogs.dart";
import "inline_annotation_target_resolver.dart";
import "../../ui_library/forms.dart";

abstract final class InlineAnnotationRelinkDialog {
  static Future<InlineAnnotationTargetInfo?> show({
    required BuildContext context,
    required List<InlineAnnotationTargetInfo> candidates,
  }) {
    return AppDialog.showCustom<InlineAnnotationTargetInfo>(
      context: context,
      builder: (_) => _InlineAnnotationRelinkForm(candidates: candidates),
    );
  }
}

class _InlineAnnotationRelinkForm extends StatefulWidget {
  final List<InlineAnnotationTargetInfo> candidates;

  const _InlineAnnotationRelinkForm({required this.candidates});

  @override
  State<_InlineAnnotationRelinkForm> createState() =>
      _InlineAnnotationRelinkFormState();
}

class _InlineAnnotationRelinkFormState
    extends State<_InlineAnnotationRelinkForm> {
  static const int _resultLimit = 100;
  String _query = "";

  List<InlineAnnotationTargetInfo> get _visibleCandidates {
    final query = _query.trim().toLowerCase();
    return widget.candidates
        .where(
          (candidate) =>
              query.isEmpty ||
              candidate.primaryName.toLowerCase().contains(query) ||
              candidate.id.toLowerCase().contains(query) ||
              (candidate.path?.toLowerCase().contains(query) ?? false),
        )
        .take(_resultLimit)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final candidates = _visibleCandidates;
    return AppDialog(
      title: context.l10n.uiRelinkMissingTarget,
      icon: Icons.add_link,
      maxWidth: 560,
      content: SizedBox(
        width: 520,
        height: 420,
        child: Column(
          children: [
            TextField(
              key: const ValueKey("inline-annotation-relink-search"),
              autofocus: true,
              decoration: appFieldDecoration(
                context,
                decoration: InputDecoration(
                  labelText: context.l10n.uiSearchNamePathOrUUID,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: candidates.isEmpty
                  ? Center(child: Text(context.l10n.uiNoMatchingLinkTargets))
                  : ListView.builder(
                      itemCount: candidates.length,
                      itemBuilder: (context, index) {
                        final candidate = candidates[index];
                        return ListTile(
                          key: ValueKey(
                            "inline-annotation-relink-${candidate.id}",
                          ),
                          leading: const Icon(Icons.link),
                          title: Text(
                            candidate.primaryName.isEmpty
                                ? context.l10n.uiUntitled
                                : candidate.primaryName,
                          ),
                          subtitle: Text(
                            candidate.path?.isNotEmpty == true
                                ? candidate.path!
                                : candidate.id,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => Navigator.of(context).pop(candidate),
                        );
                      },
                    ),
            ),
            if (widget.candidates.length > _resultLimit && _query.isEmpty)
              Text(
                context.l10n.uiShowingTheFirstResultsEnterKeywordsToNarrow(
                  (_resultLimit).toString(),
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.commonCancel),
        ),
      ],
    );
  }
}
