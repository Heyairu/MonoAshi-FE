import "../../bin/file.dart";
import '../../models/project_defaults.dart';
import "../../domain/repositories/file_repository.dart";

export "../../domain/repositories/file_repository.dart";

import '../../l10n/app_localization.dart';

class DefaultFileRepository implements FileRepository {
  DefaultFileRepository({this.localizations});
  final AppLocalizations Function()? localizations;
  @override
  Future<ProjectFile> createNewProject() {
    return FileService.createNewProject(
      fileName: localizations?.call().uiUntitled2,
    );
  }

  @override
  Future<ProjectFile?> openProject() {
    return FileService.openProject();
  }

  @override
  Future<ProjectFile> openProjectFromPath(
    String filePath, {
    String? accessToken,
  }) {
    return FileService.openProjectFromPath(filePath, accessToken: accessToken);
  }

  @override
  Future<ProjectFile> openProjectFromExternalUri(String uri) {
    return FileService.openProjectFromExternalUri(uri);
  }

  @override
  Future<ProjectFile> saveProject(ProjectFile projectFile) {
    return FileService.saveProject(
      projectFile,
      dialogTitle: localizations?.call().uiSaveProjectFile,
    );
  }

  @override
  Future<ProjectFile> saveProjectToKnownLocation(ProjectFile projectFile) {
    return FileService.saveProjectToKnownLocation(projectFile);
  }

  @override
  Future<ProjectFile> saveProjectAs(ProjectFile projectFile) {
    return FileService.saveProjectAs(
      projectFile,
      dialogTitle: localizations?.call().uiSaveProjectFile,
    );
  }

  @override
  Future<String> saveProjectAutoBackup({
    required String projectName,
    required String content,
    required int maxTotalBytes,
  }) {
    return FileService.saveProjectAutoBackup(
      projectName: projectName,
      content: content,
      maxTotalBytes: maxTotalBytes,
    );
  }

  @override
  Future<String> getAutoBackupDirectoryPath() {
    return FileService.getAutoBackupDirectoryPath();
  }

  @override
  Future<AutoBackupDirectoryInfo> getAutoBackupDirectoryInfo() {
    return FileService.getAutoBackupDirectoryInfo();
  }

  @override
  Future<String> selectAutoBackupDirectory() {
    return FileService.selectAutoBackupDirectory(
      dialogTitle: localizations?.call().uiChooseAutoBackupFolder,
    );
  }

  @override
  Future<String> resetAutoBackupDirectory() {
    return FileService.resetAutoBackupDirectory();
  }

  @override
  Future<String> openAutoBackupDirectory() {
    return FileService.openAutoBackupDirectory();
  }

  @override
  Future<bool> exportText({
    required String content,
    required String fileName,
    required String extension,
  }) {
    return FileService.exportTextWithResult(
      dialogTitle: localizations?.call().uiExportTextFile,
      content: content,
      fileName: fileName,
      extension: extension,
    );
  }

  @override
  Future<String> readLocalFile(String fileName) {
    return FileService.readLocalFile(fileName);
  }

  @override
  Future<void> writeLocalFile(String fileName, String content) {
    return FileService.writeLocalFile(fileName, content);
  }

  @override
  Future<String> getAppDocumentsPath() {
    return FileService.getAppDocumentsPath();
  }

  @override
  Future<bool> fileExists(String filePath) {
    return FileService.fileExists(filePath);
  }

  @override
  Future<void> deleteFile(String filePath) {
    return FileService.deleteFile(filePath);
  }

  @override
  Future<FileInfo> getFileInfo(String filePath) {
    return FileService.getFileInfo(filePath);
  }

  @override
  Future<String> generateProjectXml(
    ProjectData data, {
    bool updateLatestSave = true,
  }) {
    return ProjectManager.generateProjectXML(
      data,
      updateLatestSave: updateLatestSave,
    );
  }

  @override
  Future<AutoBackupCleanupResult> clearAutoBackups() {
    return FileService.clearAutoBackups();
  }

  @override
  Future<ProjectData> loadProjectFromXml(ProjectFile projectFile) {
    return ProjectManager.loadProjectFromXML(
      projectFile,
      defaults:
          localizations?.call().projectDefaults ?? const ProjectDefaults(),
    );
  }

  @override
  Future<ProjectParseResult> loadProjectParseResultFromXml(
    ProjectFile projectFile,
  ) {
    return ProjectManager.loadProjectParseResultFromXML(
      projectFile,
      defaults:
          localizations?.call().projectDefaults ?? const ProjectDefaults(),
    );
  }
}
