import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/domain/collaboration/collaboration_operation.dart';
import 'package:monogatari_assistant/domain/collaboration/typed_operation_log.dart';
import 'package:monogatari_assistant/features/revision_tracking/application/revision_gauge_summary.dart';
import 'package:monogatari_assistant/features/revision_tracking/application/revision_text_diff_service.dart';
import 'package:monogatari_assistant/features/revision_tracking/domain/revision_models.dart';

RevisionComparison comparison({
  List<RevisionTextDiff> texts = const [],
  List<RevisionRecordChange> records = const [],
}) => RevisionComparison(
  baselineVersion: 'base',
  targetVersion: 'target',
  texts: texts,
  records: records,
  unsupportedKinds: {},
);

void main() {
  test('text replacement counts one addition and one revision', () {
    final diff = const RevisionTextDiffService().compare(
      chapterId: 'chapter',
      before: '保留\n舊句',
      after: '保留\n新句',
    );
    final summary = RevisionGaugeSummary.fromComparison(
      comparison(texts: [diff]),
    );
    expect(summary.additions, 1);
    expect(summary.revisions, 1);
    expect(summary.additionsFraction, .5);
    expect(summary.revisionsFraction, .5);
  });

  test('added, removed and modified records use separate buckets', () {
    final records = [
      for (final kind in RevisionChangeKind.values)
        RevisionRecordChange(
          key: ProjectRecordKey(
            kind: ProjectRecordKind.character,
            recordId: kind.name,
          ),
          kind: kind,
        ),
    ];
    final summary = RevisionGaugeSummary.fromComparison(
      comparison(records: records),
    );
    expect(summary.additions, 2);
    expect(summary.revisions, 2);
  });

  test('pure insertion, deletion and newline edits are retained', () {
    const diff = RevisionTextDiffService();
    final added = RevisionGaugeSummary.fromComparison(
      comparison(
        texts: [diff.compare(chapterId: 'chapter', before: '', after: '新句')],
      ),
    );
    expect((added.additions, added.revisions), (1, 0));
    final removed = RevisionGaugeSummary.fromComparison(
      comparison(
        texts: [diff.compare(chapterId: 'chapter', before: '舊句', after: '')],
      ),
    );
    expect((removed.additions, removed.revisions), (0, 1));
    final newline = RevisionGaugeSummary.fromComparison(
      comparison(
        texts: [diff.compare(chapterId: 'chapter', before: '句', after: '句\n')],
      ),
    );
    expect((newline.additions, newline.revisions), (1, 1));
    final empty = RevisionGaugeSummary.fromComparison(null);
    expect((empty.additionsFraction, empty.revisionsFraction), (0, 0));
  });
}
