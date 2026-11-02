import "dart:convert";
import "../../application/project_export/export_models.dart";
import "../../application/project_export/export_service.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../bin/file.dart";
import "../../modules/baseinfoview.dart" as base_info_module;
import "core_providers.dart";
import "global_state_providers.dart";
import "project_snapshot_utils.dart";

/// A first save binds the in-memory collaboration project to a path and must
/// preserve its UUID. Only Save As from an already persisted file creates a
/// distinct project identity.
bool shouldRegenerateProjectUuidForSaveAs(ProjectFile? currentProject) {
  return currentProject != null && !currentProject.isNewFile;
}

final projectIoControllerProvider =
    AsyncNotifierProvider<ProjectIoController, ProjectIoStatus>(
      ProjectIoController.new,
    );

/// Riverpod may retain the preceding busy value in an AsyncError. A completed
/// operation that failed must release every UI gate, including keyboard actions.
extension ProjectIoAsyncStatus on AsyncValue<ProjectIoStatus> {
  bool get isProjectIoBusy => !hasError && (valueOrNull?.isBusy ?? isLoading);

  bool get blocksProjectEditor =>
      !hasError && (valueOrNull?.blocksEditor ?? isLoading);
}

enum ProjectIoOperation {
  idle,
  newProject,
  openProject,
  openRecentProject,
  saveProject,
  saveProjectAs,
  saveProjectAutoSave,
  saveProjectAutoBackup,
  exportText,
  exportSelective,
}

class ProjectIoStatus {
  final ProjectIoOperation operation;
  final String? message;
  final bool isOpeningProject;
  final bool isSaving;
  final bool isExporting;
  final bool isParsing;

  const ProjectIoStatus({
    required this.operation,
    this.message,
    this.isOpeningProject = false,
    this.isSaving = false,
    this.isExporting = false,
    this.isParsing = false,
  });

  const ProjectIoStatus.idle() : this(operation: ProjectIoOperation.idle);

  bool get isBusy => isOpeningProject || isSaving || isExporting || isParsing;

  bool get blocksEditor => isOpeningProject || isParsing;
}

class ProjectLoadResult {
  final ProjectFile projectFile;
  final ProjectData data;
  final String? persistedXmlContent;
  final String? persistedProjectUuid;
  final String? projectVersion;
  final List<ProjectMigrationWarning> migrationWarnings;
  final bool wasMigrated;

  const ProjectLoadResult({
    required this.projectFile,
    required this.data,
    this.persistedXmlContent,
    this.persistedProjectUuid,
    this.projectVersion,
    this.migrationWarnings = const <ProjectMigrationWarning>[],
    this.wasMigrated = false,
  });
}

class AutoBackupResult {
  final String? path;
  final bool wasWritten;

  const AutoBackupResult._({required this.path, required this.wasWritten});

  const AutoBackupResult.written({required String path})
    : this._(path: path, wasWritten: true);
}

class ProjectIoPayload {
  final ProjectData snapshot;
  final String xmlContent;

  const ProjectIoPayload({required this.snapshot, required this.xmlContent});
}

class ProjectIoController extends AsyncNotifier<ProjectIoStatus> {
  @override
  ProjectIoStatus build() => const ProjectIoStatus.idle();

  Future<ProjectIoPayload> prepareProjectPayload(
    ProjectData currentData, {
    bool regenerateProjectUuid = false,
  }) async {
    final useCase = ref.read(projectFileUseCaseProvider);
    final baseInfoSnapshot = base_info_module.BaseInfoCodec.createSaveSnapshot(
      data: currentData.baseInfoData,
      contentText: currentData.contentText,
    );
    final snapshotData = snapshotProjectData(
      currentData,
      baseInfoOverride: baseInfoSnapshot,
    );
    if (regenerateProjectUuid) {
      snapshotData.projectUUID = ProjectData.createProjectUUID();
    }
    final xmlContent = await useCase.generateProjectXml(snapshotData);
    return ProjectIoPayload(snapshot: snapshotData, xmlContent: xmlContent);
  }

  /// Serializes an immutable collaboration draft without changing save-time
  /// fields and without writing the user's project file.
  Future<ProjectIoPayload> prepareDraftProjectPayload(
    ProjectData currentData,
  ) async {
    final useCase = ref.read(projectFileUseCaseProvider);
    final baseInfoSnapshot = base_info_module.BaseInfoCodec.createSaveSnapshot(
      data: currentData.baseInfoData,
      contentText: currentData.contentText,
      updateLatestSave: false,
    );
    final snapshotData = snapshotProjectData(
      currentData,
      baseInfoOverride: baseInfoSnapshot,
    );
    final xmlContent = await useCase.generateProjectXml(
      snapshotData,
      updateLatestSave: false,
    );
    return ProjectIoPayload(snapshot: snapshotData, xmlContent: xmlContent);
  }

  Future<ProjectLoadResult> createNewProject() async {
    state = const AsyncData(
      ProjectIoStatus(
        operation: ProjectIoOperation.newProject,
        isOpeningProject: true,
      ),
    );
    try {
      final useCase = ref.read(projectFileUseCaseProvider);
      final projectFile = await useCase.createNewProject();
      final data = snapshotProjectData(ProjectData.empty());
      final profile = await ref.read(userProfileProvider.future);
      data.baseInfoData = data.baseInfoData.copyWith(
        author: profile.defaultPenName,
      );
      state = const AsyncData(
        ProjectIoStatus(
          operation: ProjectIoOperation.newProject,
          message: "新專案建立成功！",
        ),
      );
      return ProjectLoadResult(projectFile: projectFile, data: data);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<ProjectFile?> pickProjectFile() async {
    state = const AsyncData(
      ProjectIoStatus(
        operation: ProjectIoOperation.openProject,
        isOpeningProject: true,
      ),
    );
    try {
      final useCase = ref.read(projectFileUseCaseProvider);
      final projectFile = await useCase.openProject();
      state = const AsyncData(
        ProjectIoStatus(operation: ProjectIoOperation.openProject),
      );
      return projectFile;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<ProjectFile> openProjectFromPath(
    String filePath, {
    String? accessToken,
  }) async {
    state = const AsyncData(
      ProjectIoStatus(
        operation: ProjectIoOperation.openRecentProject,
        isOpeningProject: true,
      ),
    );
    try {
      final useCase = ref.read(projectFileUseCaseProvider);
      final projectFile = await useCase.openProjectFromPath(
        filePath,
        accessToken: accessToken,
      );
      state = const AsyncData(
        ProjectIoStatus(operation: ProjectIoOperation.openRecentProject),
      );
      return projectFile;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<ProjectFile> openProjectFromExternalUri(String uri) async {
    state = const AsyncData(
      ProjectIoStatus(
        operation: ProjectIoOperation.openProject,
        isOpeningProject: true,
      ),
    );
    try {
      final useCase = ref.read(projectFileUseCaseProvider);
      final projectFile = await useCase.openProjectFromExternalUri(uri);
      state = const AsyncData(
        ProjectIoStatus(operation: ProjectIoOperation.openProject),
      );
      return projectFile;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<ProjectData> loadProjectData(ProjectFile projectFile) async {
    final result = await loadProject(projectFile);
    return result.data;
  }

  Future<ProjectLoadResult> loadProject(ProjectFile projectFile) async {
    state = const AsyncData(
      ProjectIoStatus(
        operation: ProjectIoOperation.openProject,
        isParsing: true,
      ),
    );
    try {
      final useCase = ref.read(projectFileUseCaseProvider);
      final persistedXmlContent = projectFile.content;
      final parseResult = await useCase.loadProjectParseResultFromXml(
        projectFile,
      );
      final snapshot = snapshotProjectData(parseResult.data);
      state = const AsyncData(
        ProjectIoStatus(
          operation: ProjectIoOperation.openProject,
          message: "專案解析完成",
        ),
      );
      return ProjectLoadResult(
        projectFile: projectFile,
        data: snapshot,
        persistedXmlContent: persistedXmlContent.isEmpty
            ? null
            : persistedXmlContent,
        persistedProjectUuid: parseResult.sourceProjectUuid,
        projectVersion: parseResult.projectVersion,
        migrationWarnings: parseResult.migrationWarnings,
        wasMigrated: parseResult.wasMigrated,
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  /// Saves an already-serialized, externally verified project snapshot to a
  /// user-selected location and parses the exact bytes that were verified.
  ///
  /// Unlike the normal Save As flow this deliberately does not regenerate the
  /// project UUID. The caller remains responsible for trust/session checks and
  /// for deciding whether the returned project should replace editor state.
  Future<ProjectLoadResult> saveAndLoadExternalProjectSnapshotAs({
    required String suggestedFileName,
    required String xmlContent,
  }) async {
    state = const AsyncData(
      ProjectIoStatus(
        operation: ProjectIoOperation.saveProjectAs,
        isSaving: true,
      ),
    );
    try {
      final useCase = ref.read(projectFileUseCaseProvider);
      final projectFile = ProjectFile(
        fileName: suggestedFileName,
        filePath: null,
        content: xmlContent,
      );
      final savedProject = await useCase.saveProjectAs(projectFile);

      // saveProjectAs consumes its transient payload. Parse the same verified
      // XML from memory instead of reopening a platform URI with weaker or
      // already-expired permissions.
      savedProject.content = xmlContent;
      final parseResult = await useCase.loadProjectParseResultFromXml(
        savedProject,
      );
      final snapshot = snapshotProjectData(parseResult.data);
      state = const AsyncData(
        ProjectIoStatus(
          operation: ProjectIoOperation.openProject,
          message: "外部 snapshot 已另存並解析完成",
        ),
      );
      return ProjectLoadResult(
        projectFile: savedProject,
        data: snapshot,
        persistedXmlContent: xmlContent,
        persistedProjectUuid: parseResult.sourceProjectUuid,
        projectVersion: parseResult.projectVersion,
        migrationWarnings: parseResult.migrationWarnings,
        wasMigrated: parseResult.wasMigrated,
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  /// Parses a verified collaboration draft in memory. No file API is called.
  Future<ProjectLoadResult> parseExternalProjectSnapshot({
    required ProjectFile currentProject,
    required String xmlContent,
  }) async {
    state = const AsyncData(
      ProjectIoStatus(
        operation: ProjectIoOperation.openProject,
        isParsing: true,
      ),
    );
    try {
      final useCase = ref.read(projectFileUseCaseProvider);
      final parseResult = await useCase.loadProjectParseResultFromXml(
        ProjectFile(
          fileName: currentProject.fileName,
          filePath: currentProject.filePath,
          uri: currentProject.uri,
          content: xmlContent,
        ),
      );
      final snapshot = snapshotProjectData(parseResult.data);
      state = const AsyncData(
        ProjectIoStatus(
          operation: ProjectIoOperation.openProject,
          message: "遠端 draft 已在記憶體中解析完成",
        ),
      );
      return ProjectLoadResult(
        projectFile: currentProject,
        data: snapshot,
        projectVersion: parseResult.projectVersion,
        migrationWarnings: parseResult.migrationWarnings,
        wasMigrated: parseResult.wasMigrated,
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  /// Parses an already-verified snapshot and overwrites the currently opened
  /// project at its known path/URI. The caller must obtain explicit user
  /// confirmation before invoking this method.
  Future<ProjectLoadResult> overwriteAndLoadExternalProjectSnapshot({
    required ProjectFile currentProject,
    required String xmlContent,
  }) async {
    state = const AsyncData(
      ProjectIoStatus(
        operation: ProjectIoOperation.saveProject,
        isSaving: true,
        isParsing: true,
      ),
    );
    try {
      if (currentProject.isNewFile) {
        throw FileException("目前專案沒有可安全覆蓋的既有儲存位置。");
      }
      final useCase = ref.read(projectFileUseCaseProvider);
      final parseFile = ProjectFile(
        fileName: currentProject.fileName,
        filePath: currentProject.filePath,
        uri: currentProject.uri,
        content: xmlContent,
      );
      final parseResult = await useCase.loadProjectParseResultFromXml(
        parseFile,
      );
      final savedProject = await useCase.saveProjectToKnownLocation(
        ProjectFile(
          fileName: currentProject.fileName,
          filePath: currentProject.filePath,
          uri: currentProject.uri,
          content: xmlContent,
        ),
      );
      final snapshot = snapshotProjectData(parseResult.data);
      state = const AsyncData(
        ProjectIoStatus(
          operation: ProjectIoOperation.openProject,
          message: "遠端 snapshot 已覆蓋目前專案並解析完成",
        ),
      );
      return ProjectLoadResult(
        projectFile: savedProject,
        data: snapshot,
        persistedXmlContent: xmlContent,
        persistedProjectUuid: parseResult.sourceProjectUuid,
        projectVersion: parseResult.projectVersion,
        migrationWarnings: parseResult.migrationWarnings,
        wasMigrated: parseResult.wasMigrated,
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<ProjectFile> saveProject({
    required ProjectFile? currentProject,
    required ProjectData currentData,
    required bool forceSaveAs,
    ProjectIoPayload? preparedPayload,
  }) async {
    final shouldSaveAs = forceSaveAs || currentProject == null;
    final operation = shouldSaveAs
        ? ProjectIoOperation.saveProjectAs
        : ProjectIoOperation.saveProject;
    state = AsyncData(ProjectIoStatus(operation: operation, isSaving: true));
    try {
      final useCase = ref.read(projectFileUseCaseProvider);
      final projectToSave = currentProject ?? await useCase.createNewProject();

      final payload =
          preparedPayload ?? await prepareProjectPayload(currentData);
      projectToSave.content = payload.xmlContent;

      final savedProject = shouldSaveAs
          ? await useCase.saveProjectAs(projectToSave)
          : await useCase.saveProject(projectToSave);

      state = AsyncData(
        ProjectIoStatus(
          operation: shouldSaveAs
              ? ProjectIoOperation.saveProjectAs
              : ProjectIoOperation.saveProject,
          message: shouldSaveAs
              ? "專案另存成功：${savedProject.nameWithoutExtension}"
              : "專案儲存成功！",
        ),
      );
      return savedProject;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<ProjectFile> saveProjectAutoSave({
    required ProjectFile currentProject,
    required ProjectData currentData,
    ProjectIoPayload? preparedPayload,
  }) async {
    state = const AsyncData(
      ProjectIoStatus(
        operation: ProjectIoOperation.saveProjectAutoSave,
        isSaving: true,
      ),
    );
    try {
      final useCase = ref.read(projectFileUseCaseProvider);
      final payload =
          preparedPayload ?? await prepareProjectPayload(currentData);
      currentProject.content = payload.xmlContent;
      final savedProject = await useCase.saveProjectToKnownLocation(
        currentProject,
      );

      state = const AsyncData(
        ProjectIoStatus(
          operation: ProjectIoOperation.saveProjectAutoSave,
          message: "自動儲存完成",
        ),
      );
      return savedProject;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<AutoBackupResult> saveProjectAutoBackup({
    required ProjectFile? currentProject,
    required ProjectData currentData,
    required int maxTotalBytes,
    ProjectIoPayload? preparedPayload,
  }) async {
    state = const AsyncData(
      ProjectIoStatus(
        operation: ProjectIoOperation.saveProjectAutoBackup,
        isSaving: true,
      ),
    );
    try {
      final useCase = ref.read(projectFileUseCaseProvider);
      final payload =
          preparedPayload ?? await prepareProjectPayload(currentData);
      final xmlContent = payload.xmlContent;

      final projectName =
          currentProject?.nameWithoutExtension.trim().isNotEmpty == true
          ? currentProject!.nameWithoutExtension
          : FileService.defaultFileName;
      final backupPath = await useCase.saveProjectAutoBackup(
        projectName: projectName,
        content: xmlContent,
        maxTotalBytes: maxTotalBytes,
      );

      state = const AsyncData(
        ProjectIoStatus(
          operation: ProjectIoOperation.saveProjectAutoBackup,
          message: "AutoBackup 已建立",
        ),
      );
      return AutoBackupResult.written(path: backupPath);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<bool> exportAs({
    required String extension,
    required ProjectData currentData,
    required String defaultFileName,
  }) => _exportPrepared(
    currentData: currentData,
    defaultFileName: defaultFileName,
    operation: ProjectIoOperation.exportText,
    request: ExportRequest(
      purpose: ExportPurpose.manuscript,
      format: extension == "txt" ? ExportFormat.txt : ExportFormat.markdown,
    ),
  );

  Future<bool> exportSelective({
    required ProjectData currentData,
    required String defaultFileName,
    required Set<String> selectedModules,
    required String format,
  }) => _exportPrepared(
    currentData: currentData,
    defaultFileName: defaultFileName,
    operation: ProjectIoOperation.exportSelective,
    request: ExportRequest(
      purpose: format == "xml"
          ? ExportPurpose.exchange
          : ExportPurpose.reference,
      format: format == "xml" ? ExportFormat.xml : ExportFormat.markdown,
      modules: SelectiveProjectModule.values
          .where((m) => selectedModules.contains(m.id))
          .toSet(),
    ),
  );

  Future<bool> _exportPrepared({
    required ProjectData currentData,
    required String defaultFileName,
    required ProjectIoOperation operation,
    required ExportRequest request,
  }) async {
    state = AsyncData(ProjectIoStatus(operation: operation, isExporting: true));
    try {
      final output = const ProjectExportService().prepare(currentData, request);
      final saved = await ref
          .read(projectFileUseCaseProvider)
          .exportText(
            content: utf8.decode(output.bytes),
            fileName: defaultFileName,
            extension: ".${output.extension}",
          );
      state = AsyncData(
        ProjectIoStatus(operation: operation, message: saved ? "匯出完成！" : null),
      );
      return saved;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
