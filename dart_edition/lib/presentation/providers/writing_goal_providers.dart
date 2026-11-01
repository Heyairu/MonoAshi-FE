import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/writing_goal_preferences_repository.dart';
import '../../models/writing_goal_data.dart';
import 'project_state_providers.dart';

final writingGoalPreferencesRepositoryProvider = Provider(
  (ref) => WritingGoalPreferencesRepository(),
);

final writingGoalDefaultsProvider =
    AsyncNotifierProvider<WritingGoalDefaultsNotifier, WritingGoalDefaults>(
      WritingGoalDefaultsNotifier.new,
    );

class WritingGoalDefaultsNotifier extends AsyncNotifier<WritingGoalDefaults> {
  Future<void> _writes = Future.value();

  @override
  Future<WritingGoalDefaults> build() =>
      ref.watch(writingGoalPreferencesRepositoryProvider).load();

  Future<void> setGoal(WritingGoalKind kind, int value) {
    final operation = _writes.then((_) async {
      final current = await future;
      final next = current.withGoal(kind, value);
      await ref.read(writingGoalPreferencesRepositoryProvider).save(next);
      state = AsyncData(next);
    });
    _writes = operation.catchError((Object _) {});
    return operation;
  }
}

final effectiveWritingGoalDefaultsProvider = Provider(
  (ref) =>
      ref.watch(writingGoalDefaultsProvider).valueOrNull ??
      const WritingGoalDefaults(),
);

final effectiveChapterWordGoalProvider = Provider(
  (ref) => ref
      .watch(projectWritingGoalsProvider)
      .effective(
        WritingGoalKind.chapter,
        ref.watch(effectiveWritingGoalDefaultsProvider),
      ),
);

final effectiveTotalWordGoalProvider = Provider(
  (ref) => ref
      .watch(projectWritingGoalsProvider)
      .effective(
        WritingGoalKind.total,
        ref.watch(effectiveWritingGoalDefaultsProvider),
      ),
);
