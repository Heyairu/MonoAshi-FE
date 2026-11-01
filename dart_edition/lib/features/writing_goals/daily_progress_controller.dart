import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../bin/content_manager.dart';
import '../../bin/settings_manager.dart';
import '../../data/repositories/writing_progress_repository.dart';
import '../inline_annotations/inline_annotation_projection.dart';

typedef WritingDeltaCalculator =
    Future<int> Function(Map<String, List<String>> changes);

Future<int> calculateWritingDelta(Map<String, List<String>> changes) =>
    compute(_calculateDelta, changes);

int _calculateDelta(Map<String, List<String>> changes) {
  int count(String raw) => ContentManager.calculateWordCount(
    InlineAnnotationProjection.readerTextFromRaw(raw),
    mode: WordCountMode.wordsAndCharacters,
  );
  return changes.values.fold(
    0,
    (sum, pair) => sum + count(pair[1]) - count(pair[0]),
  );
}

String writingDayKey(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

/// Personal progress is independent of project snapshots and dashboard mounts.
/// A checkpoint is a coordinate in the local editing history. Excluded changes
/// leave it unchanged, so undoing an import cannot manufacture writing credit.
class DailyProgressController extends ChangeNotifier {
  final WritingProgressRepository repository;
  final DateTime Function() clock;
  final WritingDeltaCalculator calculate;
  final String _session = const Uuid().v4();
  final Queue<Future<void> Function()> _jobs = Queue();
  final Map<String, String> _chapters = {};
  Map<String, List<String>> _pending = {};
  WritingProgressLedger ledger = const WritingProgressLedger();
  Object? error;
  bool isLoading = true;
  bool _disposed = false;
  bool _clockRunning = false;
  Future<void>? _running;
  Timer? _debounce;
  Timer? _midnight;
  String? _project;
  String? _pendingDay;
  int _sequence = 0;
  int _position = 0;
  Future<int> _savedPosition = Future.value(0);

  DailyProgressController({
    required this.repository,
    DateTime Function()? clock,
    WritingDeltaCalculator? calculate,
    bool scheduleMidnight = true,
  }) : clock = clock ?? DateTime.now,
       calculate = calculate ?? calculateWritingDelta {
    _jobs.add(() async {
      ledger = await repository.load();
      isLoading = false;
    });
    unawaited(_drain());
    if (scheduleMidnight) startClock();
  }

  String get day => writingDayKey(clock());
  int get todayTotal => ledger.totalFor(day);
  bool get isPending => _pending.isNotEmpty || _jobs.isNotEmpty;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  void _scheduleMidnight() {
    final now = clock();
    final next = DateTime(now.year, now.month, now.day + 1);
    _midnight?.cancel();
    _midnight = Timer(next.difference(now), () {
      refreshDate();
    });
  }

  void startClock() {
    _clockRunning = true;
    _scheduleMidnight();
  }

  void stopClock() {
    _clockRunning = false;
    _midnight?.cancel();
  }

  void refreshDate() {
    if (_pendingDay != null && _pendingDay != day) _seal();
    if (_clockRunning) _scheduleMidnight();
    _notify();
  }

  void replaceBaseline(String project, Map<String, String> chapters) {
    _seal();
    if (_project != project) {
      _jobs.add(() async {
        _position = 0;
      });
      _project = project;
      _savedPosition = checkpoint();
    }
    _chapters
      ..clear()
      ..addAll(chapters);
    unawaited(_drain());
  }

  void endSession() {
    _seal();
    _project = null;
    _chapters.clear();
  }

  void observeChapter(String id, String raw, {bool counted = true}) {
    if (_project == null) return;
    final before = _chapters[id] ?? '';
    if (before == raw) return;
    if (!counted || (_pendingDay != null && _pendingDay != day)) _seal();
    _chapters[id] = raw;
    if (!counted) return;
    _pendingDay = day;
    final old = _pending[id];
    _pending[id] = [old?[0] ?? before, raw];
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _seal);
    _notify();
  }

  void _seal() {
    _debounce?.cancel();
    if (_pending.isEmpty) return;
    final changes = _pending;
    final project = _project!;
    final date = _pendingDay!;
    final sequence = ++_sequence;
    _pending = {};
    _pendingDay = null;
    int? delta;
    _jobs.add(() async {
      delta ??= await calculate(changes);
      ledger = await repository.applyDelta(
        session: _session,
        sequence: sequence,
        day: date,
        project: project,
        delta: delta!,
      );
      _position += delta!;
    });
    unawaited(_drain());
  }

  Future<int> checkpoint() {
    _seal();
    final result = Completer<int>();
    _jobs.add(() async {
      result.complete(_position);
    });
    unawaited(_drain());
    return result.future;
  }

  void markSaved({Future<int>? position}) {
    _savedPosition = position ?? checkpoint();
  }

  void adoptProjectIdentity(String project) {
    _seal();
    _project = project;
  }

  void restoreCheckpoint(Future<int> checkpoint) {
    _seal();
    final project = _project;
    if (project == null) return;
    final date = day;
    final sequence = ++_sequence;
    _jobs.add(() async {
      final target = await checkpoint;
      ledger = await repository.applyDelta(
        session: _session,
        sequence: sequence,
        day: date,
        project: project,
        delta: target - _position,
      );
      _position = target;
    });
    unawaited(_drain());
  }

  void discardUnsaved() => restoreCheckpoint(_savedPosition);

  Future<void> _drain() {
    if (_running != null) return _running!;
    // Yield once so assignment to _running precedes completion, even for an
    // empty queue. Failed head jobs stay queued and can be retried in order.
    _running = Future<void>.microtask(() async {
      try {
        while (_jobs.isNotEmpty) {
          await _jobs.first();
          _jobs.removeFirst();
        }
        error = null;
      } catch (e) {
        error = e;
      } finally {
        _running = null;
        _notify();
      }
    });
    return _running!;
  }

  Future<void> flush() async {
    _seal();
    await _drain();
    if (error != null) throw StateError('每日統計尚未保存：$error');
  }

  Future<void> retry() => flush();

  @override
  void dispose() {
    _seal();
    _disposed = true;
    _debounce?.cancel();
    _midnight?.cancel();
    super.dispose();
  }
}
