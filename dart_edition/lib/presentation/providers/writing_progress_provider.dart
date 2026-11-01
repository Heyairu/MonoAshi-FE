import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/writing_progress_repository.dart';
import '../../features/writing_goals/daily_progress_controller.dart';

final writingProgressRepositoryProvider = Provider(
  (ref) => WritingProgressRepository(),
);
final dailyWritingProgressProvider = ChangeNotifierProvider.autoDispose(
  (ref) => DailyProgressController(
    repository: ref.watch(writingProgressRepositoryProvider),
    scheduleMidnight: false,
  ),
);
