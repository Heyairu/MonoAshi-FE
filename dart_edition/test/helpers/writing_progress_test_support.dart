import 'package:monogatari_assistant/data/repositories/writing_progress_repository.dart';

class MemoryProgressRepository extends WritingProgressRepository {
  WritingProgressLedger value = const WritingProgressLedger();
  bool fail = false;
  @override
  Future<WritingProgressLedger> load() async => value;
  @override
  Future<WritingProgressLedger> applyDelta({
    required String session,
    required int sequence,
    required String day,
    required String project,
    required int delta,
  }) async {
    if (fail) throw StateError('disk full');
    return value = value.applying(
      session: session,
      sequence: sequence,
      day: day,
      project: project,
      delta: delta,
    );
  }
}

Future<int> lengthDelta(Map<String, List<String>> changes) async => changes
    .values
    .fold<int>(0, (n, pair) => n + pair[1].length - pair[0].length);
