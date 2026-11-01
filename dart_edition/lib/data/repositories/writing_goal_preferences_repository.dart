import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/writing_goal_data.dart';

class WritingGoalPreferencesRepository {
  static const key = 'writing_goal_defaults_v1';

  Future<WritingGoalDefaults> load() async {
    final raw = (await SharedPreferences.getInstance()).getString(key);
    if (raw == null) return const WritingGoalDefaults();
    return WritingGoalDefaults.fromJson(
      Map<String, Object?>.from(jsonDecode(raw) as Map),
    );
  }

  Future<void> save(WritingGoalDefaults defaults) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(key, jsonEncode(defaults.toJson()))) {
      throw StateError('無法保存寫作目標，請重試。');
    }
  }
}
