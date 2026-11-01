enum WritingGoalKind { daily, chapter, total }

const maximumWritingGoal = 999999999;

bool isValidWritingGoal(int value) => value > 0 && value <= maximumWritingGoal;

String? validateWritingGoal(String? text) {
  final value = int.tryParse(text?.trim() ?? '');
  return value != null && isValidWritingGoal(value)
      ? null
      : '請輸入 1 到 999,999,999 的整數';
}

class WritingGoalDefaults {
  final int dailyWordGoal;
  final int chapterWordGoal;
  final int totalWordGoal;

  const WritingGoalDefaults({
    this.dailyWordGoal = 1000,
    this.chapterWordGoal = 2000,
    this.totalWordGoal = 100000,
  });

  int valueFor(WritingGoalKind kind) => switch (kind) {
    WritingGoalKind.daily => dailyWordGoal,
    WritingGoalKind.chapter => chapterWordGoal,
    WritingGoalKind.total => totalWordGoal,
  };

  WritingGoalDefaults withGoal(WritingGoalKind kind, int value) {
    if (!isValidWritingGoal(value)) throw ArgumentError.value(value);
    return WritingGoalDefaults(
      dailyWordGoal: kind == WritingGoalKind.daily ? value : dailyWordGoal,
      chapterWordGoal: kind == WritingGoalKind.chapter
          ? value
          : chapterWordGoal,
      totalWordGoal: kind == WritingGoalKind.total ? value : totalWordGoal,
    );
  }

  Map<String, Object?> toJson() => {
    'daily': dailyWordGoal,
    'chapter': chapterWordGoal,
    'total': totalWordGoal,
  };

  factory WritingGoalDefaults.fromJson(Map<String, Object?> json) {
    int read(String key, int fallback) {
      final value = json[key];
      return value is int && isValidWritingGoal(value) ? value : fallback;
    }

    return WritingGoalDefaults(
      dailyWordGoal: read('daily', 1000),
      chapterWordGoal: read('chapter', 2000),
      totalWordGoal: read('total', 100000),
    );
  }
}

/// Null means live inheritance, including when a default changes later.
class ProjectWritingGoals {
  final int? chapterWordGoal;
  final int? totalWordGoal;
  final List<String> recoveryXml;

  const ProjectWritingGoals({
    this.chapterWordGoal,
    this.totalWordGoal,
    this.recoveryXml = const [],
  });

  int? overrideFor(WritingGoalKind kind) => switch (kind) {
    WritingGoalKind.daily => null,
    WritingGoalKind.chapter => chapterWordGoal,
    WritingGoalKind.total => totalWordGoal,
  };

  int effective(WritingGoalKind kind, WritingGoalDefaults defaults) =>
      overrideFor(kind) ?? defaults.valueFor(kind);

  ProjectWritingGoals withGoal(WritingGoalKind kind, int? value) {
    if (kind == WritingGoalKind.daily ||
        (value != null && !isValidWritingGoal(value))) {
      throw ArgumentError.value(value);
    }
    return ProjectWritingGoals(
      chapterWordGoal: kind == WritingGoalKind.chapter
          ? value
          : chapterWordGoal,
      totalWordGoal: kind == WritingGoalKind.total ? value : totalWordGoal,
      recoveryXml: recoveryXml,
    );
  }

  Map<String, Object?> toJson() => {
    'chapter': chapterWordGoal,
    'total': totalWordGoal,
    'recovery': recoveryXml,
  };

  factory ProjectWritingGoals.fromJson(Map<String, Object?> json) {
    int? read(String key) {
      final value = json[key];
      if (value == null) return null;
      if (value is! int || !isValidWritingGoal(value)) {
        throw FormatException('字數目標 $key 無效');
      }
      return value;
    }

    final recovery = json['recovery'] ?? const <String>[];
    if (recovery is! List || recovery.any((item) => item is! String)) {
      throw const FormatException('字數目標復原資料無效');
    }
    return ProjectWritingGoals(
      chapterWordGoal: read('chapter'),
      totalWordGoal: read('total'),
      recoveryXml: List<String>.unmodifiable(recovery.cast<String>()),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ProjectWritingGoals &&
      chapterWordGoal == other.chapterWordGoal &&
      totalWordGoal == other.totalWordGoal &&
      recoveryXml.length == other.recoveryXml.length &&
      recoveryXml.asMap().entries.every(
        (e) => e.value == other.recoveryXml[e.key],
      );

  @override
  int get hashCode =>
      Object.hash(chapterWordGoal, totalWordGoal, Object.hashAll(recoveryXml));
}
