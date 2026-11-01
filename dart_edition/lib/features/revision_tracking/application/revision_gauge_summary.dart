import '../domain/revision_models.dart';

/// Counts baseline differences, not editor keystrokes. Text uses logical lines;
/// settings use records, so changing several fields of one record counts once.
class RevisionGaugeSummary {
  final int additions;
  final int revisions;

  const RevisionGaugeSummary({this.additions = 0, this.revisions = 0});

  factory RevisionGaugeSummary.fromComparison(RevisionComparison? comparison) {
    if (comparison == null) return const RevisionGaugeSummary();
    var additions = comparison.addedLines;
    var revisions = comparison.removedLines;
    for (final text in comparison.texts) {
      // A terminal-newline-only modification has no changed logical line.
      if (text.trailingNewlineChanged &&
          text.addedLines == 0 &&
          text.removedLines == 0) {
        additions++;
        revisions++;
      }
    }
    for (final record in comparison.records) {
      switch (record.kind) {
        case RevisionChangeKind.added:
          additions++;
        case RevisionChangeKind.removed:
          revisions++;
        case RevisionChangeKind.modified:
          additions++;
          revisions++;
      }
    }
    return RevisionGaugeSummary(additions: additions, revisions: revisions);
  }

  int get total => additions + revisions;
  double get additionsFraction => total == 0 ? 0 : additions / total;
  double get revisionsFraction => total == 0 ? 0 : revisions / total;
}
