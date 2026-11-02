import "dart:convert";
import "dart:io";
import "package:path/path.dart" as path;
import "package:path_provider/path_provider.dart";
import "package:uuid/uuid.dart";

class WritingProgressLedger {
  final Map<String, Map<String, int>> days;
  final Map<String, int> sequences;
  final String? warning;

  const WritingProgressLedger({
    this.days = const {},
    this.sequences = const {},
    this.warning,
  });

  int totalFor(String day) =>
      (days[day]?.values ?? const <int>[]).fold(0, (a, b) => a + b);

  factory WritingProgressLedger.decode(String source) {
    final json = jsonDecode(source) as Map;
    if (json["schemaVersion"] != 1 || json["countPolicyVersion"] != 1) {
      throw UnsupportedError("每日統計的格式版本不受支援，原始檔案已保留。");
    }
    return WritingProgressLedger(
      days: Map.unmodifiable(
        (json["days"] as Map).map(
          (day, values) => MapEntry(
            day as String,
            Map<String, int>.unmodifiable((values as Map).cast<String, int>()),
          ),
        ),
      ),
      sequences: Map<String, int>.unmodifiable(
        (json["sequences"] as Map).cast<String, int>(),
      ),
    );
  }

  String encode() => jsonEncode({
    "schemaVersion": 1,
    "countPolicyVersion": 1,
    "days": days,
    "sequences": sequences,
  });

  WritingProgressLedger applying({
    required String session,
    required int sequence,
    required String day,
    required String project,
    required int delta,
  }) {
    if (sequence <= (sequences[session] ?? 0)) return this;
    return WritingProgressLedger(
      days: Map.unmodifiable({
        ...days,
        day: Map<String, int>.unmodifiable({
          ...?days[day],
          project: (days[day]?[project] ?? 0) + delta,
        }),
      }),
      sequences: Map.unmodifiable({...sequences, session: sequence}),
      warning: warning,
    );
  }
}

/// One lock protects read/merge/replace across windows and app processes.
class WritingProgressRepository {
  static final Map<String, Future<void>> _queues = {};
  final Future<Directory> Function() directory;
  WritingProgressRepository({Future<Directory> Function()? directory})
    : directory = directory ?? getApplicationSupportDirectory;

  Future<T> _locked<T>(Future<T> Function(File file) operation) async {
    final folder = Directory(path.join((await directory()).path, "Data"));
    await folder.create(recursive: true);
    final file = File(path.join(folder.path, "WritingProgress.json"));
    final previous = _queues[file.path] ?? Future<void>.value();
    final task = previous.then((_) async {
      final lock = await File("${file.path}.lock").open(mode: FileMode.append);
      var locked = false;
      try {
        await lock.lock(FileLock.blockingExclusive);
        locked = true;
        return await operation(file);
      } finally {
        if (locked) await lock.unlock();
        await lock.close();
      }
    });
    final barrier = task.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    _queues[file.path] = barrier;
    return task.whenComplete(() {
      if (identical(_queues[file.path], barrier)) _queues.remove(file.path);
    });
  }

  Future<WritingProgressLedger> _read(File file) async {
    final backup = File("${file.path}.bak");
    if (!await file.exists() && !await backup.exists()) {
      return const WritingProgressLedger();
    }
    try {
      return WritingProgressLedger.decode(await file.readAsString());
    } on UnsupportedError {
      rethrow;
    } catch (_) {
      // Do not destroy evidence or turn an unreadable ledger into zero.
      if (!await backup.exists()) throw StateError("每日統計無法讀取，原始檔案已保留。");
      final restored = WritingProgressLedger.decode(
        await backup.readAsString(),
      );
      if (await file.exists()) {
        await file.rename("${file.path}.corrupt.${const Uuid().v4()}");
      }
      return WritingProgressLedger(
        days: restored.days,
        sequences: restored.sequences,
        warning: "每日統計已從備份恢復，最近一次記錄可能遺失。",
      );
    }
  }

  Future<WritingProgressLedger> load() => _locked(_read);

  Future<WritingProgressLedger> applyDelta({
    required String session,
    required int sequence,
    required String day,
    required String project,
    required int delta,
  }) => _locked((file) async {
    final current = await _read(file);
    final next = current.applying(
      session: session,
      sequence: sequence,
      day: day,
      project: project,
      delta: delta,
    );
    if (identical(current, next)) return current;
    final temporary = File("${file.path}.${const Uuid().v4()}.tmp");
    try {
      await temporary.writeAsString(next.encode(), flush: true);
      if (await file.exists()) await file.copy("${file.path}.bak");
      await temporary.rename(file.path);
    } finally {
      if (await temporary.exists()) await temporary.delete();
    }
    return next;
  });
}
