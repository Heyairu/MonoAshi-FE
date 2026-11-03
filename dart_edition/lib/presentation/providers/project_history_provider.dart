import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../bin/file.dart" as file_module;
import "../../features/revision_tracking/application/revision_session_codec.dart";
import "../../features/navigation/app_module.dart";
import "project_snapshot_utils.dart";

/// A deterministic, fixed-size fingerprint of serialized project content.
///
/// CRC-32 and Adler-32 are kept together to make an accidental collision much
/// less likely than either checksum alone. They are not used for security.
class ProjectHistoryContentDigest {
  final int crc32;
  final int adler32;
  final int serializedCodeUnits;

  const ProjectHistoryContentDigest({
    required this.crc32,
    required this.adler32,
    required this.serializedCodeUnits,
  });

  factory ProjectHistoryContentDigest.fromXml(String xml) {
    int crc = 0xffffffff;
    int adlerA = 1;
    int adlerB = 0;

    void addByte(int byte) {
      crc = _crc32Table[(crc ^ byte) & 0xff] ^ (crc >>> 8);
      adlerA += byte;
      if (adlerA >= _adlerModulus) {
        adlerA -= _adlerModulus;
      }
      adlerB += adlerA;
      if (adlerB >= _adlerModulus) {
        adlerB -= _adlerModulus;
      }
    }

    // Hash UTF-16 code units directly to avoid allocating another full UTF-8
    // byte list for large projects.
    for (int index = 0; index < xml.length; index++) {
      final int codeUnit = xml.codeUnitAt(index);
      addByte(codeUnit & 0xff);
      addByte(codeUnit >>> 8);
    }

    return ProjectHistoryContentDigest(
      crc32: (crc ^ 0xffffffff) & 0xffffffff,
      adler32: ((adlerB << 16) | adlerA) & 0xffffffff,
      serializedCodeUnits: xml.length,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProjectHistoryContentDigest &&
            other.crc32 == crc32 &&
            other.adler32 == adler32 &&
            other.serializedCodeUnits == serializedCodeUnits;
  }

  @override
  int get hashCode => Object.hash(crc32, adler32, serializedCodeUnits);

  @override
  String toString() {
    final String crc = crc32.toRadixString(16).padLeft(8, "0");
    final String adler = adler32.toRadixString(16).padLeft(8, "0");
    return "$crc$adler:$serializedCodeUnits";
  }
}

const int _adlerModulus = 65521;

final List<int> _crc32Table = List<int>.generate(256, (int index) {
  int value = index;
  for (int bit = 0; bit < 8; bit++) {
    value = (value & 1) != 0 ? 0xedb88320 ^ (value >>> 1) : value >>> 1;
  }
  return value;
}, growable: false);

class ProjectHistoryEntry {
  static const int _estimatedObjectOverheadBytes = 1024;

  final file_module.ProjectData data;
  final ProjectHistoryContentDigest contentDigest;
  final int approximateByteSize;
  final int pageIndex;

  /// The sidebar page visible while editing the always-mounted desktop editor.
  final int? desktopPageIndex;
  final String? selectedSegID;
  final String? selectedChapID;
  final int cursorOffset;
  final bool isPageTransition;
  final Future<int>? writingProgressPosition;

  ProjectHistoryEntry._({
    required this.data,
    required this.contentDigest,
    required this.approximateByteSize,
    required this.pageIndex,
    this.desktopPageIndex,
    required this.selectedSegID,
    required this.selectedChapID,
    required this.cursorOffset,
    required this.isPageTransition,
    this.writingProgressPosition,
  });

  ProjectHistoryEntry withWritingProgressPosition(Future<int> position) =>
      ProjectHistoryEntry._(
        data: data,
        contentDigest: contentDigest,
        approximateByteSize: approximateByteSize,
        pageIndex: pageIndex,
        desktopPageIndex: desktopPageIndex,
        selectedSegID: selectedSegID,
        selectedChapID: selectedChapID,
        cursorOffset: cursorOffset,
        isPageTransition: isPageTransition,
        writingProgressPosition: position,
      );

  /// Uses the previous content as the destination's baseline without creating
  /// another deep project snapshot. Only a subsequent edit commits this jump.
  ProjectHistoryEntry _transitionTo(ProjectHistoryEntry destination) =>
      ProjectHistoryEntry._(
        data: data,
        contentDigest: contentDigest,
        approximateByteSize: approximateByteSize,
        pageIndex: destination.pageIndex,
        desktopPageIndex: destination.desktopPageIndex,
        selectedSegID: destination.selectedSegID,
        selectedChapID: destination.selectedChapID,
        cursorOffset: destination.cursorOffset,
        isPageTransition: true,
        writingProgressPosition: writingProgressPosition,
      );

  factory ProjectHistoryEntry({
    required file_module.ProjectData data,
    required int pageIndex,
    int? desktopPageIndex,
    required String? selectedSegID,
    required String? selectedChapID,
    required int cursorOffset,
    bool isPageTransition = false,
    Future<int>? writingProgressPosition,
  }) {
    // A history entry owns exactly one immutable project snapshot.
    final file_module.ProjectData snapshot = snapshotProjectData(data);

    // Keep save timestamps out of history equality, as before, without making
    // another deep snapshot. This lightweight view shares every project
    // collection with [snapshot] and only replaces BaseInfoData.
    final file_module.ProjectData comparisonView = file_module.ProjectData(
      projectUUID: snapshot.projectUUID,
      writingGoals: snapshot.writingGoals,
      baseInfoData: snapshot.baseInfoData.copyWith(latestSave: null),
      segmentsData: snapshot.segmentsData,
      outlineData: snapshot.outlineData,
      foreshadowData: snapshot.foreshadowData,
      updatePlanData: snapshot.updatePlanData,
      worldSettingsData: snapshot.worldSettingsData,
      itemClasses: snapshot.itemClasses,
      itemInstances: snapshot.itemInstances,
      itemRelations: snapshot.itemRelations,
      itemClassStateChanges: snapshot.itemClassStateChanges,
      itemInstanceStateChanges: snapshot.itemInstanceStateChanges,
      locationStateChanges: snapshot.locationStateChanges,
      characterData: snapshot.characterData,
      characterStates: snapshot.characterStates,
      characterStateBaselines: snapshot.characterStateBaselines,
      characterStateChanges: snapshot.characterStateChanges,
      timelineDocument: snapshot.timelineDocument,
      outlineChapterLinks: snapshot.outlineChapterLinks,
      totalWords: snapshot.totalWords,
      contentText: snapshot.contentText,
      isDirty: snapshot.isDirty,
      phrases: snapshot.phrases,
      phrasesRecoveryPayload: snapshot.phrasesRecoveryPayload,
    );

    // Serialize once. The XML is only a transient input to the fixed-size
    // digest and size estimate; it is never retained by the entry.
    final String xml = file_module
        .FileService.generateProjectXMLWithoutLatestSaveUpdate(comparisonView);

    return ProjectHistoryEntry._(
      data: snapshot,
      contentDigest: ProjectHistoryContentDigest.fromXml(
        '$xml${RevisionSessionCodec.decisionDigest(snapshot.revisionTrackingJson)}',
      ),
      approximateByteSize:
          (xml.length * 2) +
          (snapshot.revisionTrackingJson?.length ?? 0) * 2 +
          _estimatedObjectOverheadBytes,
      pageIndex: pageIndex,
      desktopPageIndex: desktopPageIndex,
      selectedSegID: selectedSegID,
      selectedChapID: selectedChapID,
      cursorOffset: cursorOffset,
      isPageTransition: isPageTransition,
      writingProgressPosition: writingProgressPosition,
    );
  }
}

class ProjectHistoryState {
  final List<ProjectHistoryEntry> undoStack;
  final List<ProjectHistoryEntry> redoStack;

  const ProjectHistoryState({
    this.undoStack = const [],
    this.redoStack = const [],
  });

  bool get canUndo => undoStack.length > 1;
  bool get canRedo => redoStack.isNotEmpty;

  int get entryCount => undoStack.length + redoStack.length;

  int get approximateByteSize {
    int total = 0;
    for (final ProjectHistoryEntry entry in undoStack) {
      total += entry.approximateByteSize;
    }
    for (final ProjectHistoryEntry entry in redoStack) {
      total += entry.approximateByteSize;
    }
    return total;
  }
}

class ProjectHistoryNotifier extends Notifier<ProjectHistoryState> {
  static const int defaultMaxEntries = 50;
  static const int defaultMaxApproximateBytes = 64 * 1024 * 1024;

  final int maxEntries;
  final int maxApproximateBytes;

  ProjectHistoryNotifier({
    this.maxEntries = defaultMaxEntries,
    this.maxApproximateBytes = defaultMaxApproximateBytes,
  }) : assert(maxEntries > 0),
       assert(maxApproximateBytes > 0);

  @override
  ProjectHistoryState build() {
    return const ProjectHistoryState();
  }

  void reset(ProjectHistoryEntry entry) {
    state = ProjectHistoryState(undoStack: [entry], redoStack: const []);
  }

  ProjectHistoryState _trimToLimits({
    required List<ProjectHistoryEntry> undoStack,
    required List<ProjectHistoryEntry> redoStack,
  }) {
    final List<ProjectHistoryEntry> nextUndo = [...undoStack];
    final List<ProjectHistoryEntry> nextRedo = [...redoStack];
    int totalBytes = 0;

    for (final ProjectHistoryEntry entry in nextUndo) {
      totalBytes += entry.approximateByteSize;
    }
    for (final ProjectHistoryEntry entry in nextRedo) {
      totalBytes += entry.approximateByteSize;
    }

    bool exceedsLimit() {
      return nextUndo.length + nextRedo.length > maxEntries ||
          totalBytes > maxApproximateBytes;
    }

    while (exceedsLimit()) {
      final bool canRemoveUndo = nextUndo.length > 1;
      final bool canRemoveRedo = nextRedo.isNotEmpty;
      if (!canRemoveUndo && !canRemoveRedo) {
        // A single entry may exceed the budget by itself. Retaining the current
        // state is more useful than returning an empty, unusable history.
        break;
      }

      bool removeUndo;
      if (!canRemoveRedo) {
        removeUndo = true;
      } else if (!canRemoveUndo) {
        removeUndo = false;
      } else {
        final int oldestUndoDistance = nextUndo.length - 1;
        final int farthestRedoDistance = nextRedo.length;
        if (oldestUndoDistance != farthestRedoDistance) {
          removeUndo = oldestUndoDistance > farthestRedoDistance;
        } else {
          // Both candidates are equally far from the current state. Removing
          // the larger one reaches the byte budget with fewer lost steps.
          removeUndo =
              nextUndo.first.approximateByteSize >=
              nextRedo.last.approximateByteSize;
        }
      }

      final ProjectHistoryEntry removed = removeUndo
          ? nextUndo.removeAt(0)
          : nextRedo.removeLast();
      totalBytes -= removed.approximateByteSize;
    }

    return ProjectHistoryState(undoStack: nextUndo, redoStack: nextRedo);
  }

  bool record(ProjectHistoryEntry entry) {
    // Browsing alone never commits a command or invalidates redo. The next
    // changed snapshot supplies the page that actually owns the modification.
    if (entry.isPageTransition) return false;
    final currentStack = state.undoStack;
    if (currentStack.isNotEmpty &&
        currentStack.last.contentDigest == entry.contentDigest) {
      final updatedStack = entry.writingProgressPosition == null
          ? currentStack
          : [
              ...currentStack.take(currentStack.length - 1),
              currentStack.last.withWritingProgressPosition(
                entry.writingProgressPosition!,
              ),
            ];
      if (!identical(updatedStack, state.undoStack)) {
        state = ProjectHistoryState(
          undoStack: updatedStack,
          redoStack: state.redoStack,
        );
      }
      return false;
    }

    state = _trimToLimits(
      undoStack: [
        ...currentStack,
        if (currentStack.isNotEmpty &&
            currentStack.last.pageIndex != entry.pageIndex)
          currentStack.last._transitionTo(entry),
        entry,
      ],
      redoStack: const [],
    );
    return true;
  }

  bool _skipTransition(ProjectHistoryEntry entry, bool skipEditorTransitions) =>
      skipEditorTransitions &&
      entry.isPageTransition &&
      entry.pageIndex == AppModule.editorPageIndex;

  ProjectHistoryEntry? undo(
    ProjectHistoryEntry currentEntry, {
    bool skipEditorTransitions = false,
  }) {
    if (state.undoStack.isEmpty) {
      reset(currentEntry);
      return null;
    }

    // Capture an edit that has not reached the debounce timer, including its
    // destination baseline, and discard the obsolete redo branch.
    record(currentEntry);
    final undoStack = [...state.undoStack];
    if (currentEntry.writingProgressPosition case final position?) {
      undoStack[undoStack.length - 1] = undoStack.last
          .withWritingProgressPosition(position);
    }
    final redoStack = [...state.redoStack];
    // A resize may leave the cursor on a jump previously replayed in a narrow
    // layout. Skip that command too instead of consuming an empty Undo step.
    while (undoStack.length > 1 &&
        _skipTransition(undoStack.last, skipEditorTransitions)) {
      redoStack.insert(0, undoStack.removeLast());
    }

    if (undoStack.length <= 1) {
      state = _trimToLimits(undoStack: undoStack, redoStack: redoStack);
      return null;
    }

    redoStack.insert(0, undoStack.removeLast());
    while (undoStack.length > 1 &&
        _skipTransition(undoStack.last, skipEditorTransitions)) {
      redoStack.insert(0, undoStack.removeLast());
    }
    final target = undoStack.last;
    state = _trimToLimits(undoStack: undoStack, redoStack: redoStack);
    return target;
  }

  ProjectHistoryEntry? redo(
    ProjectHistoryEntry currentEntry, {
    bool skipEditorTransitions = false,
  }) {
    if (state.undoStack.isNotEmpty &&
        state.undoStack.last.contentDigest != currentEntry.contentDigest) {
      record(currentEntry);
      return null;
    }
    if (state.redoStack.isEmpty) {
      if (state.undoStack.isEmpty) {
        reset(currentEntry);
      }
      return null;
    }

    final redoStack = [...state.redoStack];
    var target = redoStack.removeAt(0);
    final undoStack = [...state.undoStack];
    if (undoStack.isEmpty ||
        undoStack.last.contentDigest != currentEntry.contentDigest) {
      undoStack.add(currentEntry);
    } else if (currentEntry.writingProgressPosition case final position?) {
      undoStack[undoStack.length - 1] = undoStack.last
          .withWritingProgressPosition(position);
    }
    undoStack.add(target);
    while (_skipTransition(target, skipEditorTransitions) &&
        redoStack.isNotEmpty) {
      target = redoStack.removeAt(0);
      undoStack.add(target);
    }

    state = _trimToLimits(undoStack: undoStack, redoStack: redoStack);
    return _skipTransition(target, skipEditorTransitions) ? null : target;
  }
}

final projectHistoryProvider =
    NotifierProvider<ProjectHistoryNotifier, ProjectHistoryState>(
      ProjectHistoryNotifier.new,
    );
