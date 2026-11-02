import '../../l10n/app_localization.dart';
import 'package:flutter/widgets.dart';
import "package:flutter/services.dart";

import "../inline_annotations/inline_annotation.dart";
import "../inline_annotations/inline_annotation_syntax.dart";
import "../inline_annotations/inline_annotation_target_resolver.dart";
import "../phrases/phrase_search_index.dart";

enum MosaicCompletionKind { target, color, literal, phrase }

final class MosaicCompletionCandidate {
  final String id;
  final String label;
  final String detail;
  final String insertText;
  final List<MosaicCompletionCandidate> children;
  final bool submenuOnly;
  final InlineAnnotationKind? createTargetKind;
  final String? createParentId;
  final int createDepth;
  final bool customDisplayText;
  final String? createAliasForCharacterId;
  final String? phraseId;
  final bool phraseMenu;

  const MosaicCompletionCandidate({
    required this.id,
    required this.label,
    required this.detail,
    required this.insertText,
    this.children = const [],
    this.submenuOnly = false,
    this.createTargetKind,
    this.createParentId,
    this.createDepth = 0,
    this.customDisplayText = false,
    this.createAliasForCharacterId,
    this.phraseId,
    this.phraseMenu = false,
  });
}

final class MosaicCompletionSession {
  final MosaicCompletionKind kind;
  final TextRange rawReplacementRange;
  final List<MosaicCompletionCandidate> candidates;

  const MosaicCompletionSession({
    required this.kind,
    required this.rawReplacementRange,
    required this.candidates,
  });
}

typedef MosaicTargetCandidateLoader =
    List<InlineAnnotationTargetInfo> Function(InlineAnnotationKind kind);
typedef MosaicPhraseTargetExists =
    bool Function(InlineAnnotationKind kind, String id);

final class MosaicIntelliSenseEngine {
  static const int maxCandidatesPerLevel = 100;

  static const _colorLabels = <String, String>{
    "0": "自動",
    "A": "綠色",
    "B": "藍色",
    "C": "粉色",
    "D": "紫色",
    "E": "黃色",
    "F": "灰色",
  };

  const MosaicIntelliSenseEngine({this.localizations});
  final AppLocalizations? localizations;
  AppLocalizations get l10n =>
      localizations ?? lookupAppLocalizations(defaultAppLocale);

  MosaicCompletionSession? build({
    required String rawText,
    required int rawCaret,
    required MosaicTargetCandidateLoader loadTargets,
    PhraseSearchIndex? phraseIndex,
    MosaicPhraseTargetExists? phraseTargetExists,
    int? phraseMenuTriggerStart,
    int? phraseMenuQueryStart,
  }) {
    final caret = rawCaret.clamp(0, rawText.length);
    final prefix = rawText.substring(0, caret);
    final annotationStart = prefix.lastIndexOf("//");
    if (annotationStart >= 0 && _hasOpenAnnotationDelimiter(prefix)) {
      final draft = prefix.substring(annotationStart);
      final target = _targetSession(draft, annotationStart, caret, loadTargets);
      if (target != null) return target;
      final color = _colorSession(draft, caret);
      if (color != null) return color;
    }
    if (caret == 0) return null;
    if (phraseMenuTriggerStart != null && phraseMenuQueryStart != null) {
      final trigger = rawText.substring(
        phraseMenuTriggerStart,
        phraseMenuQueryStart,
      );
      if (phraseMenuQueryStart <= caret &&
          phraseMenuTriggerStart >= 0 &&
          (trigger == '/' ||
              trigger == r'\' ||
              trigger == '//' ||
              trigger == r'\//')) {
        final query = rawText.substring(phraseMenuQueryStart, caret);
        if (_isPhraseQuery(query)) {
          return _phraseSession(
            phraseMenuTriggerStart,
            caret,
            query,
            phraseIndex,
            phraseTargetExists,
          );
        }
      }
      return null;
    }
    final phraseStart = prefix.lastIndexOf(';;');
    if (phraseStart >= 0 &&
        _precedingBackslashCount(prefix, phraseStart).isEven &&
        (phraseStart == 0 ||
            !_isPhraseCodeUnit(prefix.codeUnitAt(phraseStart - 1))) &&
        _isPhraseQuery(prefix.substring(phraseStart + 2))) {
      return _phraseSession(
        phraseStart,
        caret,
        prefix.substring(phraseStart + 2),
        phraseIndex,
        phraseTargetExists,
      );
    }
    final directTarget = _directTargetDraftSession(prefix, caret, loadTargets);
    if (directTarget != null) return directTarget;
    final manual = _manualTriggerSession(
      prefix,
      caret,
      loadTargets,
      phraseIndex,
      phraseTargetExists,
    );
    if (manual != null) return manual;
    final followsManualSlash =
        caret >= 2 && prefix.codeUnitAt(caret - 2) == 0x2f;
    return switch (rawText[caret - 1]) {
      "^" when !followsManualSlash => _directHighlightSession(caret),
      "<" when !followsManualSlash => _objectBrowserSession(caret, loadTargets),
      _ => null,
    };
  }

  MosaicCompletionSession? _manualTriggerSession(
    String prefix,
    int caret,
    MosaicTargetCandidateLoader loadTargets,
    PhraseSearchIndex? phraseIndex,
    MosaicPhraseTargetExists? phraseTargetExists,
  ) {
    if (prefix.endsWith(r"\//")) {
      return _manualSession(
        caret,
        loadTargets,
        phraseIndex,
        phraseTargetExists,
        replacementStart: caret - 3,
      );
    }
    if (prefix.endsWith("//")) {
      return _manualSession(
        caret,
        loadTargets,
        phraseIndex,
        phraseTargetExists,
        replacementStart: caret - 2,
      );
    }
    final last = prefix.codeUnitAt(caret - 1);
    if (last == 0x2f) {
      final precedingBackslashes = _precedingBackslashCount(prefix, caret - 1);
      // A slash immediately following a backslash belongs to literal input.
      // This remains true when an escaped backslash pair is projected into a
      // single visible backslash; the hidden raw unit must not turn the slash
      // into a fresh manual trigger.
      if (precedingBackslashes > 0) return null;
      return _manualSession(
        caret,
        loadTargets,
        phraseIndex,
        phraseTargetExists,
      );
    }
    if (last == 0x5c) {
      if (caret >= 2 && prefix.codeUnitAt(caret - 2) == 0x2f) return null;
      if (_precedingBackslashCount(prefix, caret).isEven) return null;
      return _manualSession(
        caret,
        loadTargets,
        phraseIndex,
        phraseTargetExists,
      );
    }
    return null;
  }

  int _precedingBackslashCount(String text, int end) {
    var count = 0;
    for (var index = end - 1; index >= 0; index--) {
      if (text.codeUnitAt(index) != 0x5c) break;
      count++;
    }
    return count;
  }

  MosaicCompletionSession _objectBrowserSession(
    int caret,
    MosaicTargetCandidateLoader loadTargets,
  ) {
    MosaicCompletionCandidate category(
      InlineAnnotationKind kind,
      String symbol,
    ) {
      return MosaicCompletionCandidate(
        id: "object-${kind.name}",
        label: "$symbol ${_kindLabel(kind)}",
        detail: l10n.completionBrowseTargets((_kindLabel(kind)).toString()),
        insertText: symbol,
        children: _targetCandidates(
          kind: kind,
          state: InlineAnnotationState.none,
          colors: const InlineAnnotationColorCode(
            background: "B",
            foreground: "0",
          ),
          query: "",
          loadTargets: loadTargets,
        ),
        submenuOnly: true,
      );
    }

    return MosaicCompletionSession(
      kind: MosaicCompletionKind.target,
      rawReplacementRange: TextRange(start: caret - 1, end: caret),
      candidates: [
        category(InlineAnnotationKind.character, "@"),
        category(InlineAnnotationKind.location, "!"),
        category(InlineAnnotationKind.event, "#"),
        category(InlineAnnotationKind.foreshadowing, "?"),
        category(InlineAnnotationKind.plan, "&"),
        category(InlineAnnotationKind.item, "*"),
      ],
    );
  }

  MosaicCompletionSession? _directTargetDraftSession(
    String prefix,
    int caret,
    MosaicTargetCandidateLoader loadTargets,
  ) {
    const symbols = "@!#?&*";
    const maxQueryLength = 128;
    final scanStart = (caret - maxQueryLength - 1).clamp(0, caret);
    for (var index = caret - 1; index >= scanStart; index--) {
      final character = prefix[index];
      if (symbols.contains(character)) {
        if (index > 0 && prefix.codeUnitAt(index - 1) == 0x2f) return null;
        final draft = prefix.substring(index + 1, caret);
        final state = switch (draft.isEmpty ? null : draft[0]) {
          "+" => InlineAnnotationState.start,
          "-" => InlineAnnotationState.end,
          _ => InlineAnnotationState.none,
        };
        final query = state == InlineAnnotationState.none
            ? draft
            : draft.substring(1);
        if (_endsDirectTargetDraft(query)) {
          return _directTargetSession(
            character,
            index,
            caret,
            query.trim().toLowerCase(),
            state,
            loadTargets,
          );
        }
        return null;
      }
      if (_isDirectDraftBoundary(character)) return null;
    }
    return null;
  }

  bool _endsDirectTargetDraft(String query) {
    for (var index = 0; index < query.length; index++) {
      if (_isDirectDraftBoundary(query[index]) ||
          query[index] == "+" ||
          query[index] == "-") {
        return false;
      }
    }
    return true;
  }

  bool _isDirectDraftBoundary(String character) {
    return character.trim().isEmpty ||
        r"/\<>[]{}()，。！？；：,.;:".contains(character) ||
        character == "^";
  }

  MosaicCompletionSession _manualSession(
    int caret,
    MosaicTargetCandidateLoader loadTargets,
    PhraseSearchIndex? phraseIndex,
    MosaicPhraseTargetExists? phraseTargetExists, {
    int? replacementStart,
  }) {
    List<MosaicCompletionCandidate> targetChildren(InlineAnnotationKind kind) =>
        _targetCandidates(
          kind: kind,
          state: InlineAnnotationState.none,
          colors: const InlineAnnotationColorCode(
            background: "B",
            foreground: "0",
          ),
          query: "",
          loadTargets: loadTargets,
        );

    return MosaicCompletionSession(
      kind: MosaicCompletionKind.literal,
      rawReplacementRange: TextRange(
        start: replacementStart ?? caret - 1,
        end: caret,
      ),
      candidates: [
        MosaicCompletionCandidate(
          id: "manual-character",
          label: "@",
          detail: l10n.uiCharacterSuggestions,
          insertText: "@",
          children: targetChildren(InlineAnnotationKind.character),
          submenuOnly: true,
        ),
        MosaicCompletionCandidate(
          id: "manual-phrases",
          label: l10n.uiPhrases,
          detail: l10n.uiSearchAndInsertProjectPhrases,
          insertText: "",
          phraseMenu: true,
          children: _phraseCandidates(phraseIndex, "", phraseTargetExists),
          submenuOnly: true,
        ),
        MosaicCompletionCandidate(
          id: "manual-location",
          label: "!",
          detail: l10n.uiLocationSuggestions,
          insertText: "!",
          children: targetChildren(InlineAnnotationKind.location),
          submenuOnly: true,
        ),
        MosaicCompletionCandidate(
          id: "manual-event",
          label: "#",
          detail: l10n.uiEventSuggestions,
          insertText: "#",
          children: targetChildren(InlineAnnotationKind.event),
          submenuOnly: true,
        ),
        MosaicCompletionCandidate(
          id: "manual-foreshadowing",
          label: "?",
          detail: l10n.uiForeshadowingSuggestions,
          insertText: "?",
          children: targetChildren(InlineAnnotationKind.foreshadowing),
          submenuOnly: true,
        ),
        MosaicCompletionCandidate(
          id: "manual-plan",
          label: "&",
          detail: l10n.uiPlanSuggestions,
          insertText: "&",
          children: targetChildren(InlineAnnotationKind.plan),
          submenuOnly: true,
        ),
        MosaicCompletionCandidate(
          id: "manual-item",
          label: "*",
          detail: l10n.uiItemSuggestions,
          insertText: "*",
          children: targetChildren(InlineAnnotationKind.item),
          submenuOnly: true,
        ),
        MosaicCompletionCandidate(
          id: "manual-highlight",
          label: "^",
          detail: l10n.uiHighlightColorSuggestions,
          insertText: "^",
          children: _directHighlightSession(caret).candidates,
          submenuOnly: true,
        ),
        MosaicCompletionCandidate(
          id: "template-character",
          label: "@<>",
          detail: l10n.uiCharacterMarkerTemplate,
          insertText: "//@<",
        ),
        MosaicCompletionCandidate(
          id: "template-location",
          label: "!<>",
          detail: l10n.uiLocationMarkerTemplate,
          insertText: "//!<",
        ),
        MosaicCompletionCandidate(
          id: "template-event",
          label: "#<>",
          detail: l10n.uiEventMarkerTemplate,
          insertText: "//#<",
        ),
        MosaicCompletionCandidate(
          id: "template-foreshadowing",
          label: "?<>",
          detail: l10n.uiForeshadowingMarkerTemplate,
          insertText: "//?<",
        ),
        MosaicCompletionCandidate(
          id: "template-plan",
          label: "&<>",
          detail: l10n.uiPlanMarkerTemplate,
          insertText: "//&<",
        ),
        MosaicCompletionCandidate(
          id: "template-item",
          label: "*<>",
          detail: l10n.uiItemMarkerTemplate,
          insertText: "//*<",
        ),
        MosaicCompletionCandidate(
          id: "template-highlight",
          label: "^<>",
          detail: l10n.uiHighlightMarkerTemplate,
          insertText: "//^<",
        ),
        MosaicCompletionCandidate(
          id: "literal-slash",
          label: l10n.uiInsertLiteral,
          detail: l10n.uiWriteAsToPreventParsingAsASyntax,
          insertText: r"\/",
        ),
        MosaicCompletionCandidate(
          id: "literal-backslash",
          label: l10n.uiInsertLiteral2,
          detail: l10n.uiWriteAs,
          insertText: r"\\",
        ),
      ],
    );
  }

  MosaicCompletionSession _phraseSession(
    int start,
    int caret,
    String query,
    PhraseSearchIndex? index,
    MosaicPhraseTargetExists? targetExists,
  ) => MosaicCompletionSession(
    kind: MosaicCompletionKind.phrase,
    rawReplacementRange: TextRange(start: start, end: caret),
    candidates: _phraseCandidates(index, query, targetExists),
  );

  List<MosaicCompletionCandidate> _phraseCandidates(
    PhraseSearchIndex? index,
    String query,
    MosaicPhraseTargetExists? targetExists,
  ) => [
    for (final result
        in index?.search(query, limit: maxCandidatesPerLevel) ??
            const <PhraseSearchResult>[])
      MosaicCompletionCandidate(
        id: 'phrase-${result.phrase.id}',
        phraseId: result.phrase.id,
        label:
            '${result.phrase.shortcut} · ${result.preview.replaceAll('\n', ' ').trim()}',
        detail: [
          result.preview.replaceAll('\n', ' ').trim(),
          if (result.annotations.any(
            (annotation) => annotation.targetId != null,
          ))
            'Mention ${result.annotations.where((annotation) => annotation.targetId != null).length}',
          if (result.annotations.any(
                (annotation) => annotation.targetId != null,
              ) &&
              targetExists != null)
            l10n.completionPendingLink(
              (result.annotations
                      .where(
                        (annotation) =>
                            annotation.targetId != null &&
                            (result.phrase.requiresRelink ||
                                !targetExists(
                                  annotation.kind,
                                  annotation.targetId!,
                                )),
                      )
                      .length)
                  .toString(),
            ),
        ].where((part) => part.isNotEmpty).join(' · '),
        insertText: '',
      ),
  ];

  bool _isPhraseQuery(String query) =>
      query.length <= 128 && !query.contains(RegExp(r'[\s\\/;]'));

  bool _isPhraseCodeUnit(int codeUnit) =>
      (codeUnit >= 0x30 && codeUnit <= 0x39) ||
      (codeUnit >= 0x41 && codeUnit <= 0x5a) ||
      (codeUnit >= 0x61 && codeUnit <= 0x7a) ||
      codeUnit == 0x5f ||
      codeUnit == 0x2d;

  MosaicCompletionSession? _targetSession(
    String draft,
    int annotationStart,
    int caret,
    MosaicTargetCandidateLoader loadTargets,
  ) {
    final match = RegExp(
      r"^//([@!#?&*])([+-])?(?:\^([A-F0])([A-F0])?)?(?:<([^|<>]*))?$",
    ).firstMatch(draft);
    if (match == null) return null;
    final kind = _kind(match.group(1)!);
    final state = switch (match.group(2)) {
      "+" => InlineAnnotationState.start,
      "-" => InlineAnnotationState.end,
      _ => InlineAnnotationState.none,
    };
    final background = match.group(3) ?? "B";
    final foreground = match.group(4) ?? "0";
    final query = (match.group(5) ?? "").trim().toLowerCase();
    return MosaicCompletionSession(
      kind: MosaicCompletionKind.target,
      rawReplacementRange: TextRange(start: annotationStart, end: caret),
      candidates: _targetCandidates(
        kind: kind,
        state: state,
        colors: InlineAnnotationColorCode(
          background: background,
          foreground: foreground,
        ),
        query: query,
        loadTargets: loadTargets,
      ),
    );
  }

  MosaicCompletionSession _directTargetSession(
    String symbol,
    int triggerStart,
    int caret,
    String query,
    InlineAnnotationState state,
    MosaicTargetCandidateLoader loadTargets,
  ) {
    final kind = _kind(symbol);
    return MosaicCompletionSession(
      kind: MosaicCompletionKind.target,
      rawReplacementRange: TextRange(start: triggerStart, end: caret),
      candidates: _targetCandidates(
        kind: kind,
        state: state,
        colors: const InlineAnnotationColorCode(
          background: "B",
          foreground: "0",
        ),
        query: query,
        loadTargets: loadTargets,
      ),
    );
  }

  List<MosaicCompletionCandidate> _targetCandidates({
    required InlineAnnotationKind kind,
    required InlineAnnotationState state,
    required InlineAnnotationColorCode colors,
    required String query,
    required MosaicTargetCandidateLoader loadTargets,
  }) {
    final candidates = <MosaicCompletionCandidate>[];
    final loadedTargets = loadTargets(kind);
    final nestedTargetIds = <String>{
      for (final target in loadedTargets)
        for (final child in target.children) child.id,
    };
    final visibleTargets =
        (query.isEmpty
                ? loadedTargets.where(
                    (target) => !nestedTargetIds.contains(target.id),
                  )
                : loadedTargets)
            .toList(growable: false);
    visibleTargets.sort((left, right) {
      final byName = left.primaryName.compareTo(right.primaryName);
      return byName != 0 ? byName : left.id.compareTo(right.id);
    });
    final targetsToBuild = query.isEmpty
        ? visibleTargets.take(maxCandidatesPerLevel - 1)
        : visibleTargets;
    for (final target in targetsToBuild) {
      final metadataMatches =
          query.isNotEmpty &&
          (target.id.toLowerCase().contains(query) ||
              (target.path?.toLowerCase().contains(query) ?? false));
      final primaryNameMatches = target.primaryName.toLowerCase().contains(
        query,
      );
      final primaryMatches =
          query.isEmpty || metadataMatches || primaryNameMatches;
      if (primaryMatches) {
        candidates.add(
          _targetCandidate(
            target: target,
            kind: kind,
            state: state,
            colors: colors,
            includeHierarchy: query.isEmpty,
          ),
        );
      }
      if (primaryMatches && kind == InlineAnnotationKind.character) continue;
      for (
        var aliasIndex = 0;
        aliasIndex < target.aliases.length;
        aliasIndex++
      ) {
        final alias = target.aliases[aliasIndex];
        if (query.isNotEmpty &&
            !metadataMatches &&
            !alias.toLowerCase().contains(query)) {
          continue;
        }
        candidates.add(
          MosaicCompletionCandidate(
            id: "${target.id}:alias:$aliasIndex",
            label: alias,
            detail: l10n.completionAlias(
              (_kindLabel(kind)).toString(),
              (target.primaryName).toString(),
            ),
            insertText: InlineAnnotationSyntax.format(
              kind: kind,
              state: state,
              colors: colors,
              targetId: target.id,
              displayText: alias,
            ),
          ),
        );
      }
    }
    candidates.sort((left, right) => left.label.compareTo(right.label));
    if (query.isNotEmpty) {
      return List.unmodifiable(candidates.take(maxCandidatesPerLevel));
    }
    return List.unmodifiable([...candidates, _createCandidate(kind: kind)]);
  }

  MosaicCompletionCandidate _targetCandidate({
    required InlineAnnotationTargetInfo target,
    required InlineAnnotationKind kind,
    required InlineAnnotationState state,
    required InlineAnnotationColorCode colors,
    required bool includeHierarchy,
    int depth = 0,
  }) {
    final hasCreateAction =
        includeHierarchy &&
        (kind == InlineAnnotationKind.location ||
            (kind == InlineAnnotationKind.event && depth <= 1));
    final childLimit = maxCandidatesPerLevel - (hasCreateAction ? 1 : 0) - 1;
    final children = kind == InlineAnnotationKind.character
        ? <MosaicCompletionCandidate>[
            MosaicCompletionCandidate(
              id: "${target.id}:primary",
              label: target.primaryName,
              detail: l10n.uiCharacterPrimaryName,
              insertText: InlineAnnotationSyntax.format(
                kind: kind,
                state: state,
                colors: colors,
                targetId: target.id,
                displayText: target.primaryName,
              ),
            ),
            for (
              var aliasIndex = 0;
              aliasIndex < target.aliases.length &&
                  aliasIndex < maxCandidatesPerLevel - 3;
              aliasIndex++
            )
              MosaicCompletionCandidate(
                id: "${target.id}:alias:$aliasIndex",
                label: target.aliases[aliasIndex],
                detail: l10n.completionCharacterAlias(
                  (target.primaryName).toString(),
                ),
                insertText: InlineAnnotationSyntax.format(
                  kind: kind,
                  state: state,
                  colors: colors,
                  targetId: target.id,
                  displayText: target.aliases[aliasIndex],
                ),
              ),
            MosaicCompletionCandidate(
              id: "${target.id}:create-alias",
              label: l10n.uiAddAlias2,
              detail: l10n.completionAddAlias((target.primaryName).toString()),
              insertText: "",
              createAliasForCharacterId: target.id,
            ),
          ]
        : includeHierarchy
        ? <MosaicCompletionCandidate>[
            for (final child in target.children.take(childLimit))
              _targetCandidate(
                target: child,
                kind: kind,
                state: state,
                colors: colors,
                includeHierarchy: true,
                depth: depth + 1,
              ),
          ]
        : const <MosaicCompletionCandidate>[];
    final hierarchicalChildren = <MosaicCompletionCandidate>[
      ...children,
      MosaicCompletionCandidate(
        id: "${target.id}:custom-text",
        label: l10n.uiEnterOtherDisplayText,
        detail: l10n.uiUseOnlyForThisMentionDoNotAdd,
        customDisplayText: true,
        insertText: InlineAnnotationSyntax.format(
          kind: kind,
          state: state,
          colors: colors,
          targetId: target.id,
          displayText: target.primaryName,
        ),
      ),
      if (includeHierarchy && kind == InlineAnnotationKind.location)
        _createCandidate(
          kind: kind,
          parentId: target.id,
          depth: depth + 1,
          label: l10n.uiAddChildLocation,
        ),
      if (includeHierarchy && kind == InlineAnnotationKind.event && depth == 0)
        _createCandidate(
          kind: kind,
          parentId: target.id,
          depth: 1,
          label: l10n.uiAddEvent2,
        ),
      if (includeHierarchy && kind == InlineAnnotationKind.event && depth == 1)
        _createCandidate(
          kind: kind,
          parentId: target.id,
          depth: 2,
          label: l10n.uiAddScene2,
        ),
    ];

    return MosaicCompletionCandidate(
      id: target.id,
      label: target.primaryName.isEmpty ? l10n.uiUntitled : target.primaryName,
      detail: _targetDetail(target, kind, depth),
      insertText: InlineAnnotationSyntax.format(
        kind: kind,
        state: state,
        colors: colors,
        targetId: target.id,
        displayText: target.primaryName,
      ),
      children: hierarchicalChildren,
    );
  }

  String _targetDetail(
    InlineAnnotationTargetInfo target,
    InlineAnnotationKind kind,
    int depth,
  ) {
    final path = target.path?.isNotEmpty == true ? target.path! : target.id;
    if (kind != InlineAnnotationKind.event) {
      return "${_kindLabel(kind)} · $path";
    }
    final scope = switch (depth) {
      0 => l10n.uiStoryline3,
      1 => l10n.uiEvent5,
      _ => l10n.uiScene3,
    };
    return "${_kindLabel(kind)} · $scope · $path";
  }

  MosaicCompletionCandidate _createCandidate({
    required InlineAnnotationKind kind,
    String? parentId,
    int depth = 0,
    String? label,
  }) {
    return MosaicCompletionCandidate(
      id: parentId == null && depth == 0
          ? "create-${kind.name}"
          : "create-${kind.name}-$parentId-$depth",
      label:
          label ?? l10n.completionCreateTarget((_kindLabel(kind)).toString()),
      detail: l10n.uiInsertMarkerImmediatelyAfterCreation,
      insertText: "",
      createTargetKind: kind,
      createParentId: parentId,
      createDepth: depth,
    );
  }

  MosaicCompletionSession _directHighlightSession(int caret) {
    return MosaicCompletionSession(
      kind: MosaicCompletionKind.color,
      rawReplacementRange: TextRange(start: caret - 1, end: caret),
      candidates: [
        for (final background in _colorLabels.entries)
          MosaicCompletionCandidate(
            id: "highlight-${background.key}",
            label: "${background.key} · ${l10n.legacyLabel(background.value)}",
            detail: l10n.uiHighlightBackgroundAutomaticTextColor,
            insertText: _highlightSkeleton(background.key, "0"),
            children: [
              for (final foreground in _colorLabels.entries)
                MosaicCompletionCandidate(
                  id: "highlight-${background.key}-foreground-${foreground.key}",
                  label:
                      "${foreground.key} · ${l10n.legacyLabel(foreground.value)}",
                  detail: l10n.completionHighlightForeground(
                    (l10n.legacyLabel(background.value)).toString(),
                  ),
                  insertText: _highlightSkeleton(
                    background.key,
                    foreground.key,
                  ),
                  children: [_customHighlight(background.key, foreground.key)],
                ),
              _customHighlight(background.key, "0"),
            ],
          ),
      ],
    );
  }

  MosaicCompletionCandidate _customHighlight(
    String background,
    String foreground,
  ) => MosaicCompletionCandidate(
    id: "highlight-$background-$foreground-custom-text",
    label: l10n.uiEnterOtherDisplayText,
    detail: l10n.uiOnlyForThisAnnotation,
    customDisplayText: true,
    insertText: InlineAnnotationSyntax.format(
      kind: InlineAnnotationKind.emphasis,
      state: InlineAnnotationState.none,
      colors: InlineAnnotationColorCode(
        background: background,
        foreground: foreground,
      ),
      displayText: l10n.uiAnnotation3,
    ),
  );

  MosaicCompletionSession? _colorSession(String draft, int caret) {
    final match = RegExp(
      r"^//(?:[@!#?&*])?[+-]?\^([A-F0]?)$",
    ).firstMatch(draft);
    if (match == null) return null;
    final query = match.group(1) ?? "";
    return MosaicCompletionSession(
      kind: MosaicCompletionKind.color,
      rawReplacementRange: TextRange(start: caret - query.length, end: caret),
      candidates: [
        for (final background in _colorLabels.entries)
          if (query.isEmpty || background.key == query)
            MosaicCompletionCandidate(
              id: "color-${background.key}",
              label:
                  "${background.key} · ${l10n.legacyLabel(background.value)}",
              detail: l10n.uiMarkerBackgroundColorCodeAutomaticTextColor,
              insertText: background.key,
              children: [
                for (final foreground in _colorLabels.entries)
                  MosaicCompletionCandidate(
                    id: "color-${background.key}-foreground-${foreground.key}",
                    label:
                        "${foreground.key} · ${l10n.legacyLabel(foreground.value)}",
                    detail: l10n.completionMarkerForeground(
                      (l10n.legacyLabel(background.value)).toString(),
                    ),
                    insertText: "${background.key}${foreground.key}",
                  ),
              ],
            ),
      ],
    );
  }

  String _highlightSkeleton(String background, String foreground) {
    final colorCode = foreground == "0"
        ? background == "B"
              ? ""
              : background
        : "$background$foreground";
    return "//^$colorCode<";
  }

  bool _hasOpenAnnotationDelimiter(String prefix) {
    var delimiterCount = 0;
    for (var index = 0; index + 1 < prefix.length; index++) {
      if (prefix.codeUnitAt(index) != 0x2f ||
          prefix.codeUnitAt(index + 1) != 0x2f) {
        continue;
      }
      var slashEscapes = 0;
      for (
        var before = index - 1;
        before >= 0 && prefix.codeUnitAt(before) == 0x5c;
        before--
      ) {
        slashEscapes++;
      }
      if (slashEscapes.isEven) {
        delimiterCount++;
        index++;
      }
    }
    return delimiterCount.isOdd;
  }

  InlineAnnotationKind _kind(String symbol) => switch (symbol) {
    "@" => InlineAnnotationKind.character,
    "!" => InlineAnnotationKind.location,
    "#" => InlineAnnotationKind.event,
    "?" => InlineAnnotationKind.foreshadowing,
    "&" => InlineAnnotationKind.plan,
    "*" => InlineAnnotationKind.item,
    _ => throw StateError("Unsupported annotation kind: $symbol"),
  };

  String _kindLabel(InlineAnnotationKind kind) => switch (kind) {
    InlineAnnotationKind.character => l10n.uiCharacter,
    InlineAnnotationKind.location => l10n.uiLocation,
    InlineAnnotationKind.event => l10n.uiEvent,
    InlineAnnotationKind.foreshadowing => l10n.uiForeshadowing,
    InlineAnnotationKind.plan => l10n.uiPlan,
    InlineAnnotationKind.item => l10n.uiItem,
    InlineAnnotationKind.emphasis => l10n.uiHighlight,
  };
}
