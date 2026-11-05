/************************************************************
 * Copyright 2025-2026 Heyairu（部屋伊琉）
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ************************************************************/

import 'package:monogatari_assistant/l10n/app_localization.dart';
import "dart:io";
import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/services.dart"; // Added for MethodChannel
import "package:flutter/foundation.dart"; // Added for compute
import "package:file_picker/file_picker.dart";
import "package:path_provider/path_provider.dart";
import "package:path/path.dart" as path;
import "package:shared_preferences/shared_preferences.dart";
import "package:url_launcher/url_launcher.dart";
import "package:xml/xml.dart" as xml;

import "ui_library.dart";
import "../modules/baseinfoview.dart" as BaseInfoModule;
import "../modules/chapterselectionview.dart" as ChapterModule;
import "../modules/outlineview.dart" as OutlineModule;
import "../modules/planview.dart" as PlanModule;
import "../modules/worldsettingsview.dart";
import "../modules/characterview.dart";
import "../models/project_data.dart";
import '../models/project_defaults.dart';
import "../models/project_file.dart";
import "../models/project_operation_error.dart";
import "../models/project_migrator.dart";
import "../models/writing_goal_data.dart";
import "../features/writing_goals/writing_goals_codec.dart";
import "../models/codecs/character_state_codec.dart";
import "../models/codecs/character_snapshot_codec.dart";
import "../models/character_snapshot_data.dart";
import "../models/codecs/timeline_codec.dart";
import "../models/timeline_data.dart";
import "../models/item_data.dart";
import "../models/item_snapshot_data.dart";
import "../models/location_snapshot_data.dart";
import "../models/codecs/item_codec.dart";
import "../models/codecs/item_snapshot_codec.dart";
import "../models/codecs/location_snapshot_codec.dart";
import "../features/phrases/phrase_entry.dart";
import "../features/phrases/phrase_library_codec.dart";
import "../data/repositories/storage_preferences_repository.dart";

export "../models/project_data.dart";
export "../models/project_file.dart";

// MARK: - 1. IO (Input/Output)
/// 負責底層磁碟讀寫操作
class _FileIO {
  /// 寫入檔案
  static Future<void> write(String filePath, String content) async {
    final file = File(filePath);
    await file.writeAsString(content, encoding: utf8);
  }

  /// 讀取檔案
  static Future<String> read(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return "";
  }

  /// 檢查存在
  static Future<bool> exists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }

  /// 刪除
  static Future<void> delete(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

// MARK: - 2. System Calls (系統調用)
/// 負責與作業系統交互 (Dialogs, Path Providers, File Info)
class _SystemBridge {
  static const platform = MethodChannel(
    "com.heyairu.monogatari_assistant/file",
  );

  /// 寫入 URI (Android SAF)
  static Future<void> writeToUri(String uri, String content) async {
    try {
      await platform.invokeMethod("writeToUri", {
        "uri": uri,
        "content": content,
      });
    } on PlatformException catch (e) {
      throw FileException("寫入 URI 失敗: ${e.message}", cause: e);
    }
  }

  /// 保留 Android SAF 檔案的讀寫權限，讓後續自動儲存可直接寫回。
  static Future<void> persistUriPermission(String? uri) async {
    if (!Platform.isAndroid || uri == null || uri.trim().isEmpty) {
      return;
    }

    try {
      await platform.invokeMethod("persistUriPermission", {"uri": uri.trim()});
    } on PlatformException catch (e) {
      debugPrint("Persist Android URI permission failed: ${e.message}");
    }
  }

  /// 選擇 Android AutoBackup 目錄並保留 SAF 寫入權限。
  static Future<String?> selectAutoBackupDirectory() async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      return await platform.invokeMethod<String>("selectAutoBackupDirectory");
    } on PlatformException catch (e) {
      throw FileException(
        "選擇 AutoBackup 目錄失敗: ${e.message ?? e.code}",
        cause: e,
      );
    }
  }

  static Future<String?> getSelectedAutoBackupDirectory() async {
    if (!Platform.isAndroid) {
      return null;
    }

    try {
      return await platform.invokeMethod<String>(
        "getSelectedAutoBackupDirectory",
      );
    } on PlatformException catch (e) {
      debugPrint("Get selected Android backup directory failed: ${e.message}");
      return null;
    }
  }

  static Future<void> openSelectedAutoBackupDirectory() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      await platform.invokeMethod("openSelectedAutoBackupDirectory");
    } on PlatformException catch (e) {
      throw FileException(
        "開啟 AutoBackup 目錄失敗: ${e.message ?? e.code}",
        cause: e,
      );
    }
  }

  static Future<String> saveAutoBackupFile({
    required String fileName,
    required String content,
  }) async {
    if (!Platform.isAndroid) {
      throw FileException("此平台不支援 Android SAF 備份寫入");
    }

    try {
      final result = await platform.invokeMethod<String>("saveAutoBackupFile", {
        "fileName": fileName,
        "content": content,
      });
      if (result == null || result.trim().isEmpty) {
        throw FileException("Android SAF 未回傳備份檔案位置");
      }
      return result;
    } on PlatformException catch (e) {
      if (e.code == "NO_BACKUP_DIRECTORY") {
        throw FileException("請先在設定中選擇 AutoBackup 目錄。");
      }
      throw FileException("寫入 AutoBackup 失敗: ${e.message ?? e.code}", cause: e);
    }
  }

  static Future<List<Map<String, Object?>>> listAutoBackupFiles() async {
    if (!Platform.isAndroid) return const [];
    final result = await platform.invokeListMethod<dynamic>(
      "listAutoBackupFiles",
    );
    return (result ?? const <dynamic>[])
        .whereType<Map<dynamic, dynamic>>()
        .map(
          (entry) => entry.map(
            (key, value) => MapEntry(key.toString(), value as Object?),
          ),
        )
        .toList(growable: false);
  }

  static Future<void> deleteAutoBackupFile(String uri) async {
    if (!Platform.isAndroid) return;
    await platform.invokeMethod<void>("deleteAutoBackupFile", {"uri": uri});
  }

  static Future<int?> getAvailableBackupBytes() async {
    if (!Platform.isAndroid) return null;
    return platform.invokeMethod<int>("getAvailableBackupBytes");
  }

  /// 建立 macOS security-scoped bookmark
  static Future<String?> createSecurityScopedBookmark(String filePath) async {
    if (!Platform.isMacOS || filePath.trim().isEmpty) {
      return null;
    }

    try {
      return await platform.invokeMethod<String>(
        "createSecurityScopedBookmark",
        {"path": filePath},
      );
    } on PlatformException catch (e) {
      debugPrint("Create macOS bookmark failed: ${e.message}");
      return null;
    }
  }

  /// 透過 macOS security-scoped bookmark 開啟檔案
  static Future<({String name, String? path, String? uri, String content})?>
  openProjectFromSecurityScopedBookmark(String bookmark) async {
    if (!Platform.isMacOS || bookmark.trim().isEmpty) {
      return null;
    }

    try {
      final dynamic rawResult = await platform.invokeMethod<dynamic>(
        "openProjectFromSecurityScopedBookmark",
        {"bookmark": bookmark},
      );

      if (rawResult is! Map) {
        return null;
      }

      final rawName = rawResult["name"];
      final rawPath = rawResult["path"];
      final rawUri = rawResult["uri"];
      final rawContent = rawResult["content"];

      if (rawName is! String ||
          rawName.trim().isEmpty ||
          rawContent is! String) {
        return null;
      }

      return (
        name: rawName,
        path: rawPath is String && rawPath.trim().isNotEmpty
            ? rawPath.trim()
            : null,
        uri: rawUri is String && rawUri.trim().isNotEmpty
            ? rawUri.trim()
            : bookmark,
        content: rawContent,
      );
    } on PlatformException catch (e) {
      throw FileException("無法以持久授權開啟檔案: ${e.message ?? e.code}", cause: e);
    }
  }

  /// Writes a project while the native macOS security scope remains active.
  static Future<({String path, String uri})>
  writeProjectFromSecurityScopedBookmark(
    String bookmark,
    String content,
  ) async {
    final result = await platform.invokeMapMethod<String, dynamic>(
      "writeProjectFromSecurityScopedBookmark",
      {"bookmark": bookmark, "content": content},
    );
    final resolvedPath = result?["path"];
    final resolvedUri = result?["uri"];
    if (resolvedPath is! String || resolvedUri is! String) {
      throw const FormatException("Invalid bookmark write response");
    }
    return (path: resolvedPath, uri: resolvedUri);
  }

  /// Reads a project delivered by Android through an ACTION_VIEW URI.
  static Future<({String name, String uri, String content})?>
  openExternalProjectUri(String uri) async {
    if (!Platform.isAndroid || uri.trim().isEmpty) {
      return null;
    }
    try {
      final rawResult = await platform.invokeMethod<dynamic>(
        "openExternalProjectUri",
        {"uri": uri.trim()},
      );
      if (rawResult is! Map) {
        return null;
      }
      final rawName = rawResult["name"];
      final rawUri = rawResult["uri"];
      final rawContent = rawResult["content"];
      if (rawName is! String || rawUri is! String || rawContent is! String) {
        return null;
      }
      return (name: rawName, uri: rawUri, content: rawContent);
    } on PlatformException catch (e) {
      throw FileException("無法開啟外部專案檔案: ${e.message ?? e.code}", cause: e);
    }
  }

  /// 選擇專案檔案並讀取內容 (因為 FilePicker 在某些平台直接給 bytes)
  static Future<({String name, String? path, String? uri, String content})?>
  pickProjectFile() async {
    FilePickerResult? result;

    if (Platform.isAndroid) {
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );
    } else {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["mnproj", "xml", "txt"],
        withData: true,
      );
    }

    if (result == null) {
      return null;
    }

    final file = result.files.single;
    final filePath = file.path?.trim();

    String? content;
    if (file.bytes != null) {
      content = utf8.decode(file.bytes!);
    } else if (filePath != null && filePath.isNotEmpty) {
      content = await _FileIO.read(filePath);
    }

    if (content == null) {
      return null;
    }

    return (
      name: file.name,
      path: filePath,
      uri: file.identifier,
      content: content,
    );
  }

  /// 顯示儲存專案對話框
  static Future<String?> saveProjectFileDialog({
    required String defaultName,
    String? dialogTitle,
    required String content,
  }) async {
    if (Platform.isAndroid) {
      try {
        // file_picker 8.x writes through ACTION_CREATE_DOCUMENT but returns a
        // guessed Downloads path instead of the selected SAF content URI.
        // Keeping that path makes every later scoped-storage write fail and
        // reopens Save As. The app bridge returns the real persistable URI.
        return await platform.invokeMethod<String>("saveProjectFile", {
          "fileName": defaultName,
          "content": content,
        });
      } on PlatformException catch (e) {
        throw FileException("儲存 Android 專案檔案失敗: ${e.message}", cause: e);
      }
    } else if (Platform.isIOS) {
      return await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle ?? "儲存專案檔案",
        fileName: defaultName,
        type: FileType.any,
        bytes: utf8.encode(content),
      );
    } else {
      // macOS, Windows, Linux: 不傳遞 bytes，由應用程式寫入檔案
      return await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle ?? "儲存專案檔案",
        fileName: defaultName,
        type: FileType.custom,
        allowedExtensions: ["mnproj"],
      );
    }
  }

  /// 顯示匯出對話框
  static Future<String?> saveExportDialog({
    required String defaultName,
    String? dialogTitle,
    required String extension,
    required String content,
  }) async {
    // 僅在 Android 和 iOS 上傳遞 bytes
    // macOS, Windows, Linux: 由應用程式寫入檔案
    if (Platform.isAndroid || Platform.isIOS) {
      return await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle ?? "匯出文字檔案",
        fileName: defaultName,
        type: FileType.custom,
        allowedExtensions: [extension.substring(1)], // 移除點號
        bytes: utf8.encode(content),
      );
    } else {
      return await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle ?? "匯出文字檔案",
        fileName: defaultName,
        type: FileType.custom,
        allowedExtensions: [extension.substring(1)], // 移除點號
      );
    }
  }

  /// 獲取文件目錄
  static Future<String> getAppDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// 獲取檔案系統統計資訊
  static Future<FileInfo> getFileInfo(String filePath) async {
    final file = File(filePath);
    final stat = await file.stat();

    return FileInfo(
      name: path.basename(filePath),
      path: filePath,
      size: stat.size,
      modified: stat.modified,
      created: stat.changed,
    );
  }
}

// MARK: - 3. Process Calls (程式調用)
/// 負責高層邏輯控制與狀態管理，連接 UI 與底層服務
class ProjectManager {
  /// 標記內容已修改 (需配合 setState 使用)
  static bool markAsModified() {
    return true; // 返回新的 hasUnsavedChanges 狀態 (true)
  }

  /// 標記內容已儲存 (需配合 setState 使用)
  static bool markAsSaved() {
    return false; // 返回新的 hasUnsavedChanges 狀態 (false)
  }

  /// 檢查是否有未儲存的變更
  static bool hasUnsavedChanges(bool hasUnsavedChanges) {
    return hasUnsavedChanges;
  }

  static ChapterModule.ChapterLocation? _findSelectedChapter({
    required List<ChapterModule.SegmentData> segmentsData,
    required String? selectedSegID,
    required String? selectedChapID,
  }) {
    if (selectedSegID == null || selectedChapID == null) return null;

    return ChapterModule.ChapterTree.findChapter(
      segmentsData,
      folderId: selectedSegID,
      chapterId: selectedChapID,
    );
  }

  static bool hasEditorContentChangedForSelectedChapter({
    required List<ChapterModule.SegmentData> segmentsData,
    required String? selectedSegID,
    required String? selectedChapID,
    required TextEditingController textController,
  }) {
    final selectedChapter = _findSelectedChapter(
      segmentsData: segmentsData,
      selectedSegID: selectedSegID,
      selectedChapID: selectedChapID,
    );
    if (selectedChapter == null) return false;

    return selectedChapter.chapter.chapterContent != textController.text;
  }

  /// 同步編輯器內容到選中的章節
  static bool syncEditorToSelectedChapter({
    required List<ChapterModule.SegmentData> segmentsData,
    required String? selectedSegID,
    required String? selectedChapID,
    required TextEditingController textController,
    required Function(String) updateContentCallback,
  }) {
    // 防呆檢查
    final selectedChapter = _findSelectedChapter(
      segmentsData: segmentsData,
      selectedSegID: selectedSegID,
      selectedChapID: selectedChapID,
    );
    if (selectedChapter == null) return false;

    final currentEditorContent = textController.text;
    final currentChapter = selectedChapter.chapter;
    if (currentChapter.chapterContent == currentEditorContent) {
      return false;
    }

    bool updateFolder(List<ChapterModule.SegmentData> folders) {
      for (var index = 0; index < folders.length; index++) {
        final folder = folders[index];
        if (folder.segmentUUID == selectedChapter.folder.segmentUUID) {
          final chapters = [...folder.chapters];
          chapters[selectedChapter.chapterIndex] = currentChapter.copyWith(
            chapterContent: currentEditorContent,
          );
          folders[index] = folder.copyWith(chapters: chapters);
          return true;
        }
        final children = [...folder.childSegments];
        if (updateFolder(children)) {
          folders[index] = folder.copyWith(childSegments: children);
          return true;
        }
      }
      return false;
    }

    updateFolder(segmentsData);
    updateContentCallback(currentEditorContent);
    return true;
  }

  /// 生成專案XML內容
  static Future<String> generateProjectXML(
    ProjectData data, {
    bool updateLatestSave = true,
  }) async {
    if (updateLatestSave) {
      return compute(FileService.generateProjectXML, data);
    }
    return compute(FileService.generateProjectXMLWithoutLatestSaveUpdate, data);
  }

  /// 從XML載入專案
  static Future<ProjectData> loadProjectFromXML(
    ProjectFile projectFile, {
    ProjectDefaults defaults = const ProjectDefaults(),
  }) async {
    final result = await loadProjectParseResultFromXML(
      projectFile,
      defaults: defaults,
    );
    return result.data;
  }

  /// 從XML載入專案，並回傳同一次解析取得的檔案版本
  static Future<ProjectParseResult> loadProjectParseResultFromXML(
    ProjectFile projectFile, {
    ProjectDefaults defaults = const ProjectDefaults(),
  }) async {
    try {
      final content = projectFile.takeContent();
      return await compute(_parseProjectWithDefaults, (content, defaults));
    } catch (e) {
      throw FileException("解析專案檔案失敗：${e.toString()}", cause: e);
    }
  }

  /// 顯示儲存確認對話框
  static Future<bool?> showSaveConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    bool showDontShowAgain = false,
    required Function(bool) onDontShowAgainChanged,
    required Function() onSave,
  }) async {
    bool dontShowAgain = false;

    return AppDialog.showCustom<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AppDialog(
              title: title,
              icon: Icons.warning_amber_rounded,
              tone: AppFeedbackTone.error,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message),
                  if (showDontShowAgain) ...[
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      value: dontShowAgain,
                      onChanged: (bool? value) {
                        setDialogState(() {
                          dontShowAgain = value ?? false;
                        });
                      },
                      title: Text(context.l10n.uiDonTAskAgain),
                      contentPadding: AppSpacing.checkboxTile,
                      dense: true,
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(null); // 取消
                  },
                  child: Text(context.l10n.commonCancel),
                ),
                TextButton(
                  onPressed: () async {
                    if (showDontShowAgain && dontShowAgain) {
                      await onDontShowAgainChanged(true);
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop(true); // 不儲存，直接繼續
                    }
                  },
                  child: Text(
                    context.l10n.uiDonTSave,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    if (showDontShowAgain && dontShowAgain) {
                      await onDontShowAgainChanged(true);
                    }

                    await onSave();

                    if (context.mounted) {
                      Navigator.of(context).pop(false); // 儲存後繼續
                    }
                  },
                  child: Text(context.l10n.commonSave),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// 處理退出
  static Future<bool> handleExit(
    BuildContext context, {
    required bool showExitWarning,
    required bool hasUnsavedChanges,
    required Function(bool) onDontShowAgainChanged,
    required Function() onSave,
  }) async {
    if (!showExitWarning && !hasUnsavedChanges) {
      return true;
    }

    final result = await showSaveConfirmDialog(
      context,
      title: context.l10n.uiUnsavedChanges,
      message: context.l10n.uiYouHaveUnsavedChangesSaveBeforeExiting,
      showDontShowAgain: true,
      onDontShowAgainChanged: onDontShowAgainChanged,
      onSave: onSave,
    );

    // null = 取消, true = 不儲存, false = 已儲存
    if (result == null) {
      return false; // 取消退出
    } else {
      return true; // 允許退出
    }
  }

  /// 顯示版本相容性警告對話框
  static Future<bool> showVersionCompatibilityDialog(
    BuildContext context, {
    required String fileVersion,
    required String supportedVersion,
  }) async {
    final result = await AppDialog.showCustom<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AppDialog(
          title: context.l10n.uiVersionCompatibilityWarning,
          icon: Icons.warning_amber_rounded,
          tone: AppFeedbackTone.error,
          content: Text(
            context.l10n.uiThisFileSVersionIsNewerThanThe(
              (fileVersion).toString(),
              (supportedVersion).toString(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(context.l10n.uiOpenAnyway),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // Operation Actions (New, Open, Save, Export)

  static Future<void> newProject(
    BuildContext context, {
    required bool hasUnsavedChanges,
    required Function(bool) setLoading,
    required Function(String) onSuccess,
    required Function(String) onError,
    required Function(ProjectFile, ProjectData) onProjectLoaded,
    required Function() onSave,
  }) async {
    final labels = context.l10n;
    if (hasUnsavedChanges) {
      final shouldProceed = await showSaveConfirmDialog(
        context,
        title: context.l10n.uiCreateProject,
        message: context.l10n.uiYouHaveUnsavedChangesSaveBeforeCreatingA,
        onDontShowAgainChanged: (_) {},
        onSave: onSave,
      );

      if (shouldProceed == null) return;
    }

    try {
      setLoading(true);
      final newProject = await FileService.createNewProject();
      final newData = ProjectData.empty(defaults: labels.projectDefaults);
      newProject.fileName = labels.uiUntitled2;
      onProjectLoaded(newProject, newData);
      setLoading(false);
      onSuccess(context.l10n.uiProjectCreated);
    } catch (e) {
      setLoading(false);
      onError(
        context.l10n.uiCouldNotCreateTheProject(context.l10n.projectError(e)),
      );
    }
  }

  static Future<void> openProject(
    BuildContext context, {
    required bool hasUnsavedChanges,
    required Function(bool) setLoading,
    required Function(String) onSuccess,
    required Function(String) onError,
    required Function(ProjectFile, ProjectData) onProjectLoaded,
    required Function() onSave,
  }) async {
    final labels = context.l10n;
    if (hasUnsavedChanges) {
      final shouldProceed = await showSaveConfirmDialog(
        context,
        title: context.l10n.uiOpenProject,
        message: context.l10n.uiYouHaveUnsavedChangesSaveBeforeOpeningAnother,
        onDontShowAgainChanged: (_) {},
        onSave: onSave,
      );
      if (shouldProceed == null) return;
    }

    try {
      setLoading(true);
      final projectFile = await FileService.openProject();
      if (projectFile != null) {
        final parseResult = await loadProjectParseResultFromXML(
          projectFile,
          defaults: labels.projectDefaults,
        );
        final openedVersion = parseResult.projectVersion;
        final hasNewerVersion = FileService.isProjectVersionNewerThanSupported(
          openedVersion,
        );

        if (hasNewerVersion) {
          setLoading(false);
          if (!context.mounted) return;

          final shouldContinue = await showVersionCompatibilityDialog(
            context,
            fileVersion: openedVersion ?? "unknown",
            supportedVersion: FileService.projectVersion,
          );

          if (!shouldContinue) {
            onError(context.l10n.uiOpeningTheNewerFileWasCancelled);
            return;
          }
          setLoading(true);
        }

        final data = parseResult.data;
        onProjectLoaded(projectFile, data);
        onSuccess(
          context.l10n.uiProjectOpened(
            (projectFile.nameWithoutExtension).toString(),
          ),
        );
      }
    } catch (e) {
      onError(
        context.l10n.uiCouldNotOpenTheProject(context.l10n.projectError(e)),
      );
    } finally {
      setLoading(false);
    }
  }

  static Future<void> openProjectFromPath(
    BuildContext context, {
    required String filePath,
    String? accessToken,
    required bool hasUnsavedChanges,
    required Function(bool) setLoading,
    required Function(String) onSuccess,
    required Function(String) onError,
    required Function(ProjectFile, ProjectData) onProjectLoaded,
    required Function() onSave,
  }) async {
    final labels = context.l10n;
    if (hasUnsavedChanges) {
      final shouldProceed = await showSaveConfirmDialog(
        context,
        title: context.l10n.uiOpenRecentProject,
        message: context.l10n.uiYouHaveUnsavedChangesSaveBeforeOpeningA,
        onDontShowAgainChanged: (_) {},
        onSave: onSave,
      );
      if (shouldProceed == null) return;
    }

    try {
      setLoading(true);
      final projectFile = await FileService.openProjectFromPath(
        filePath,
        accessToken: accessToken,
      );
      final parseResult = await loadProjectParseResultFromXML(
        projectFile,
        defaults: labels.projectDefaults,
      );
      final openedVersion = parseResult.projectVersion;
      final hasNewerVersion = FileService.isProjectVersionNewerThanSupported(
        openedVersion,
      );

      if (hasNewerVersion) {
        setLoading(false);
        if (!context.mounted) return;

        final shouldContinue = await showVersionCompatibilityDialog(
          context,
          fileVersion: openedVersion ?? "unknown",
          supportedVersion: FileService.projectVersion,
        );

        if (!shouldContinue) {
          onError(context.l10n.uiOpeningTheNewerFileWasCancelled);
          return;
        }
        setLoading(true);
      }

      final data = parseResult.data;
      onProjectLoaded(projectFile, data);
      onSuccess(
        context.l10n.uiProjectOpened(
          (projectFile.nameWithoutExtension).toString(),
        ),
      );
    } catch (e) {
      onError(
        context.l10n.uiCouldNotOpenTheRecentProject(
          context.l10n.projectError(e),
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  static Future<void> saveProject(
    BuildContext context, {
    required ProjectFile? currentProject,
    required ProjectData currentData,
    required Function(bool) setLoading,
    required Function(String) onSuccess,
    required Function(String) onError,
    required Function(ProjectFile) onProjectSaved,
  }) async {
    try {
      setLoading(true);

      if (currentProject == null) {
        await saveProjectAs(
          context,
          currentProject: currentProject,
          currentData: currentData,
          setLoading: setLoading,
          onSuccess: onSuccess,
          onError: onError,
          onProjectSaved: onProjectSaved,
        );
        return;
      }

      final xmlContent = await generateProjectXML(currentData);
      currentProject.content = xmlContent;

      final savedProject = await FileService.saveProject(currentProject);
      onProjectSaved(savedProject);
      setLoading(false);
      onSuccess(context.l10n.uiProjectSaved);
    } catch (e) {
      setLoading(false);
      onError(
        context.l10n.uiCouldNotSaveTheProject(context.l10n.projectError(e)),
      );
    }
  }

  static Future<void> saveProjectAs(
    BuildContext context, {
    required ProjectFile? currentProject,
    required ProjectData currentData,
    required Function(bool) setLoading,
    required Function(String) onSuccess,
    required Function(String) onError,
    required Function(ProjectFile) onProjectSaved,
  }) async {
    try {
      setLoading(true);

      final projectToSave =
          currentProject ?? await FileService.createNewProject();

      final xmlContent = await generateProjectXML(currentData);
      projectToSave.content = xmlContent;

      final savedProject = await FileService.saveProjectAs(projectToSave);
      onProjectSaved(savedProject);
      setLoading(false);
      onSuccess(
        context.l10n.uiProjectSavedAs(
          (savedProject.nameWithoutExtension).toString(),
        ),
      );
    } catch (e) {
      setLoading(false);
      onError(
        context.l10n.uiCouldNotSaveTheProjectAsANew(
          context.l10n.projectError(e),
        ),
      );
    }
  }
}

class _AutoBackupFileEntry {
  final String name;
  final String location;
  final int size;
  final DateTime modified;

  const _AutoBackupFileEntry({
    required this.name,
    required this.location,
    required this.size,
    required this.modified,
  });
}

ProjectParseResult _parseProjectWithDefaults((String, ProjectDefaults) input) =>
    FileService.parseProjectXMLWithMetadata(input.$1, defaults: input.$2);

// MARK: - 5. Parsing (解析)
/// 負責將 XML 字串解析為資料結構
class _ProjectParser {
  static ProjectParseResult parseProjectXMLWithMetadata(
    String xmlContent, {
    ProjectDefaults defaults = const ProjectDefaults(),
  }) {
    // 準備載入的數據 - 使用 ProjectData.empty() 作為預設值
    final defaultData = ProjectData.empty(defaults: defaults);
    String? projectVersion;
    String? projectUUID;
    String? revisionTrackingJson;
    List<PhraseEntry>? loadedPhrases;
    String? phrasesRecoveryPayload;

    BaseInfoModule.BaseInfoData? loadedBaseInfo;
    List<ChapterModule.SegmentData>? loadedSegments;
    List<OutlineModule.StorylineData>? loadedOutline;
    List<PlanModule.ForeshadowItem>? loadedForeshadow;
    List<PlanModule.UpdatePlanItem>? loadedUpdatePlans;
    List<LocationData>? loadedWorldSettings;
    Map<String, CharacterEntryData>? loadedCharacterData;
    List<CharacterState>? loadedCharacterStates;
    Map<String, CharacterStateBaseline>? loadedCharacterStateBaselines;
    List<CharacterStateChange>? loadedCharacterStateChanges;
    Map<String, ItemClassData>? loadedItemClasses;
    Map<String, ItemInstanceData>? loadedItemInstances;
    List<ItemRelationData>? loadedItemRelations;
    List<ItemClassStateChange>? loadedItemClassChanges;
    List<ItemInstanceStateChange>? loadedItemInstanceChanges;
    List<LocationStateChange>? loadedLocationChanges;
    Object? itemSectionError;
    TimelineProjectData? loadedTimeline;
    var loadedWritingGoals = const ProjectWritingGoals();

    // 計算 contentText 和 totalWords
    String contentText = "";
    int totalWords = 0;

    try {
      final document = xml.XmlDocument.parse(xmlContent);
      loadedWritingGoals = WritingGoalsCodec.decode(
        document.rootElement.findElements("Type"),
      );
      final rootUUID = document.rootElement.getAttribute("UUID")?.trim();
      if (ProjectData.isValidProjectUUID(rootUUID)) {
        projectUUID = rootUUID;
      }
      final version = document
          .findAllElements("ver")
          .firstOrNull
          ?.innerText
          .trim();
      if (version != null && version.isNotEmpty) {
        projectVersion = version;
      }

      // 尋找所有的 Type 區塊
      final typeElements = document.findAllElements("Type");

      for (final element in typeElements) {
        // 檢查 Name 標籤確認區塊類型
        final nameElement = element.findElements("Name").firstOrNull;
        if (nameElement == null) continue;

        final typeName = nameElement.innerText;

        try {
          switch (typeName) {
            case "Phrases":
              final encoded = element
                  .findElements("Data")
                  .firstOrNull
                  ?.innerText
                  .trim();
              if (encoded != null && encoded.isNotEmpty) {
                try {
                  loadedPhrases ??= PhraseLibraryCodec.decode(
                    utf8.decode(base64.decode(encoded)),
                  );
                } catch (_) {
                  phrasesRecoveryPayload ??= encoded;
                }
              }
              break;
            case "PhrasesRecovery":
              phrasesRecoveryPayload ??= element
                  .findElements("Data")
                  .firstOrNull
                  ?.innerText
                  .trim();
              break;
            case "RevisionTracking":
              final encoded = element
                  .findElements("Data")
                  .firstOrNull
                  ?.innerText
                  .trim();
              if (encoded != null && encoded.isNotEmpty) {
                try {
                  revisionTrackingJson ??= utf8.decode(base64.decode(encoded));
                } catch (_) {
                  // Retain damaged payload for the recovery UI and next save.
                  revisionTrackingJson ??= encoded;
                }
              }
              break;
            case "BaseInfo":
              // 避免重複載入，只取第一個遇到的有效區塊
              loadedBaseInfo ??= BaseInfoModule.BaseInfoCodec.loadElement(
                element,
              );
              break;

            case "ChapterSelection":
              loadedSegments ??=
                  ChapterModule.ChapterSelectionCodec.loadElement(element);
              break;

            case "Outline":
              loadedOutline ??= OutlineModule.OutlineCodec.loadElement(element);
              break;

            case "PlanSettings":
              final planData = PlanModule.PlanCodec.loadElement(element);
              if (planData != null) {
                loadedForeshadow ??= planData.foreshadows;
                loadedUpdatePlans ??= planData.updatePlans;
              }
              break;

            case "WorldSettings":
              loadedWorldSettings ??= WorldSettingsCodec.loadElement(element);
              break;

            case "Characters":
              loadedCharacterData ??= CharacterCodec.loadElement(
                element,
                migrateLegacyRelationshipLists:
                    ProjectMigrator.requiresMigration(projectVersion),
              );
              break;

            case "CharacterStates":
              loadedCharacterStates ??= CharacterStateCodec.loadElement(
                element,
              );
              break;

            case "CharacterStateBaselines":
              loadedCharacterStateBaselines ??=
                  CharacterSnapshotCodec.loadBaselines(element);
              break;

            case "CharacterStateChanges":
              loadedCharacterStateChanges ??=
                  CharacterSnapshotCodec.loadChanges(element);
              break;

            case "Timeline":
              loadedTimeline ??= TimelineCodec.loadElement(
                element,
                defaults: defaults,
              );
              break;
            case "ItemClasses":
              loadedItemClasses ??= ItemCodec.loadClasses(element);
              break;
            case "ItemInstances":
              loadedItemInstances ??= ItemCodec.loadInstances(element);
              break;
            case "ItemRelations":
              loadedItemRelations ??= ItemCodec.loadRelations(element);
              break;
            case "ItemClassStateChanges":
              loadedItemClassChanges ??= ItemSnapshotCodec.loadClassChanges(
                element,
              );
              break;
            case "ItemInstanceStateChanges":
              loadedItemInstanceChanges ??=
                  ItemSnapshotCodec.loadInstanceChanges(element);
              break;
            case "LocationStateChanges":
              loadedLocationChanges ??= LocationSnapshotCodec.loadChanges(
                element,
              );
              break;
          }
        } catch (e) {
          debugPrint("解析 $typeName 區塊時發生錯誤: $e");
          if (const {
            "ItemClasses",
            "ItemInstances",
            "ItemRelations",
            "ItemClassStateChanges",
            "ItemInstanceStateChanges",
            "LocationStateChanges",
          }.contains(typeName)) {
            itemSectionError ??= e;
          }
          // 繼續解析其他區塊
        }
      }
    } catch (e) {
      debugPrint("XML 解析失敗: $e");
      // 如果 XML 格式完全錯誤，將回傳預設的空專案
    }

    // Never replace malformed new-domain data with empty collections and then
    // permit the next save to silently discard it.
    if (itemSectionError != null) {
      throw FormatException("物品／地點快照資料無效：$itemSectionError");
    }

    List<ChapterModule.SegmentData> snapshotSegments(
      List<ChapterModule.SegmentData> source,
    ) {
      return ChapterModule.ChapterTreeSchema.upgrade(
        sourceVersion: ChapterModule.ChapterTreeSchema.currentVersion,
        segments: source,
      );
    }

    List<OutlineModule.StorylineData> snapshotOutline(
      List<OutlineModule.StorylineData> source,
    ) {
      return List<OutlineModule.StorylineData>.unmodifiable(
        source
            .map(
              (storyline) => storyline.copyWith(
                people: [...storyline.people],
                item: [...storyline.item],
                scenes: storyline.scenes
                    .map(
                      (event) => event.copyWith(
                        people: [...event.people],
                        item: [...event.item],
                        scenes: event.scenes
                            .map(
                              (scene) => scene.copyWith(
                                people: [...scene.people],
                                item: [...scene.item],
                                doingThings: [...scene.doingThings],
                              ),
                            )
                            .toList(growable: false),
                      ),
                    )
                    .toList(growable: false),
              ),
            )
            .toList(growable: false),
      );
    }

    final parsedBaseInfo = (loadedBaseInfo ?? defaultData.baseInfoData)
        .copyWith(tags: [...(loadedBaseInfo ?? defaultData.baseInfoData).tags]);
    final parsedSegments = snapshotSegments(
      loadedSegments ?? defaultData.segmentsData,
    );
    final parsedOutline = snapshotOutline(
      loadedOutline ?? defaultData.outlineData,
    );
    // Keep decoding version-agnostic. ProjectMigrator owns the decision to
    // project an old outline into timeline boxes; current-version projects may
    // intentionally contain no timeline data.
    final parsedTimelineDocument =
        loadedTimeline?.document ?? defaultData.timelineDocument;

    // 如果有載入章節數據，使用第一個章節的內容
    final firstChapter = ChapterModule.ChapterTree.firstChapter(parsedSegments);
    if (firstChapter != null) {
      contentText = firstChapter.chapter.chapterContent;
      // 簡單的字數統計
      totalWords = contentText
          .split(RegExp(r"\s+"))
          .where((word) => word.isNotEmpty)
          .length;
    }

    final decodedData = ProjectData(
      itemClasses: loadedItemClasses ?? const {},
      itemInstances: loadedItemInstances ?? const {},
      itemRelations: loadedItemRelations ?? const [],
      itemClassStateChanges: loadedItemClassChanges ?? const [],
      itemInstanceStateChanges: loadedItemInstanceChanges ?? const [],
      locationStateChanges: loadedLocationChanges ?? const [],
      projectUUID: projectUUID ?? defaultData.projectUUID,
      writingGoals: loadedWritingGoals,
      baseInfoData: parsedBaseInfo,
      segmentsData: parsedSegments,
      outlineData: parsedOutline,
      foreshadowData: loadedForeshadow ?? defaultData.foreshadowData,
      updatePlanData: loadedUpdatePlans ?? defaultData.updatePlanData,
      worldSettingsData: loadedWorldSettings ?? defaultData.worldSettingsData,
      characterData: loadedCharacterData ?? defaultData.characterData,
      characterStates: loadedCharacterStates ?? defaultData.characterStates,
      characterStateBaselines:
          loadedCharacterStateBaselines ?? defaultData.characterStateBaselines,
      characterStateChanges:
          loadedCharacterStateChanges ?? defaultData.characterStateChanges,
      timelineDocument: parsedTimelineDocument,
      outlineChapterLinks:
          loadedTimeline?.chapterLinks ?? defaultData.outlineChapterLinks,
      totalWords: totalWords,
      contentText: contentText,
      revisionTrackingJson: revisionTrackingJson,
      phrases: loadedPhrases ?? const <PhraseEntry>[],
      phrasesRecoveryPayload: phrasesRecoveryPayload,
    );
    final migration = ProjectMigrator.migrate(
      sourceVersion: projectVersion,
      parsedData: decodedData,
    );

    return ProjectParseResult(
      projectVersion: projectVersion,
      sourceProjectUuid: projectUUID,
      data: migration.data,
      migrationWarnings: [
        ...migration.warnings,
        if (decodedData.writingGoals.recoveryXml.isNotEmpty)
          const ProjectMigrationWarning(
            code: 'writing-goals-recovery',
            message: '字數目標含無法解析的資料，已保留原始區塊；目前使用可讀目標或預設值。',
          ),
      ],
      wasMigrated: migration.wasMigrated || projectUUID == null,
    );
  }

  static ProjectData parseProjectXML(
    String xmlContent, {
    ProjectDefaults defaults = const ProjectDefaults(),
  }) {
    return parseProjectXMLWithMetadata(xmlContent, defaults: defaults).data;
  }
}

// MARK: - 6. Merging (合併)
/// 負責將資料結構合併/生成為 XML 或其他格式
class _ProjectMerger {
  /// 生成專案XML內容
  static String generateProjectXML(
    ProjectData data, {
    bool updateLatestSave = true,
  }) {
    final buffer = StringBuffer();

    buffer.writeln("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    buffer.writeln("<Project UUID=\"${data.projectUUID}\">");
    buffer.writeln("<ver>${FileService.projectVersion}</ver>");

    buffer.writeln(WritingGoalsCodec.encode(data.writingGoals));

    // BaseInfo
    final baseInfoXml = BaseInfoModule.BaseInfoCodec.saveXML(
      data: data.baseInfoData,
      totalWords: data.totalWords,
      contentText: data.contentText,
      updateLatestSave: updateLatestSave,
    );
    if (baseInfoXml != null) {
      buffer.writeln(baseInfoXml);
    }

    // ChapterSelection
    final chapterXml = ChapterModule.ChapterSelectionCodec.saveXML(
      data.segmentsData,
    );
    if (chapterXml != null) {
      buffer.writeln(chapterXml);
    }

    // Outline
    final outlineXml = OutlineModule.OutlineCodec.saveXML(data.outlineData);
    if (outlineXml != null) {
      buffer.writeln(outlineXml);
    }

    final timelineXml = TimelineCodec.saveXML(
      data.timelineDocument,
      data.outlineChapterLinks,
    );
    if (timelineXml != null) {
      buffer.writeln(timelineXml);
    }

    // PlanSettings
    final planXml = PlanModule.PlanCodec.saveXML(
      data.foreshadowData,
      data.updatePlanData,
    );
    if (planXml != null) {
      buffer.writeln();
      buffer.write(planXml);
    }

    // WorldSettings
    final worldXml = WorldSettingsCodec.saveXML(data.worldSettingsData);
    if (worldXml != null) {
      buffer.writeln();
      buffer.write(worldXml);
    }

    // Characters
    final characterXml = CharacterCodec.saveXML(data.characterData);
    if (characterXml != null) {
      buffer.writeln();
      buffer.write(characterXml);
    }

    final characterStatesXml = CharacterStateCodec.saveXML(
      data.characterStates,
    );
    if (characterStatesXml != null) {
      buffer.writeln();
      buffer.write(characterStatesXml);
    }

    final characterBaselinesXml = CharacterSnapshotCodec.saveBaselines(
      data.characterStateBaselines,
    );
    if (characterBaselinesXml != null) {
      buffer.writeln();
      buffer.write(characterBaselinesXml);
    }

    final characterChangesXml = CharacterSnapshotCodec.saveChanges(
      data.characterStateChanges,
    );
    if (characterChangesXml != null) {
      buffer.writeln();
      buffer.write(characterChangesXml);
    }

    for (final section in [
      ItemCodec.saveClasses(data.itemClasses),
      ItemCodec.saveInstances(data.itemInstances),
      ItemCodec.saveRelations(data.itemRelations),
      ItemSnapshotCodec.saveClassChanges(data.itemClassStateChanges),
      ItemSnapshotCodec.saveInstanceChanges(data.itemInstanceStateChanges),
      LocationSnapshotCodec.saveChanges(data.locationStateChanges),
    ]) {
      if (section != null) buffer.writeln(section);
    }

    final revisionJson = data.revisionTrackingJson;
    if (data.phrases.isNotEmpty) {
      buffer.writeln(
        '<Type><Name>Phrases</Name><Data>${base64.encode(utf8.encode(PhraseLibraryCodec.encode(data.phrases)))}</Data></Type>',
      );
    }
    if (data.phrasesRecoveryPayload case final recovery?) {
      final recoveryName = data.phrases.isEmpty ? "Phrases" : "PhrasesRecovery";
      buffer.writeln(
        '<Type><Name>$recoveryName</Name><Data>$recovery</Data></Type>',
      );
    }
    if (revisionJson != null && revisionJson.isNotEmpty) {
      buffer.writeln(
        '<Type><Name>RevisionTracking</Name><Data>${base64.encode(utf8.encode(revisionJson))}</Data></Type>',
      );
    }

    buffer.writeln("</Project>");

    return buffer.toString();
  }
}

// MARK: - 7. Interface (介面)
// 負責協調 IO、System、Parsing、Merging 四大模組

class FileService {
  static const String defaultFileName = "Untitled";
  static const String projectExtension = ".mnproj"; // MonogatariAssistant 專案檔案
  static const String textExtension = ".txt";
  static const String markdownExtension = ".md";
  static const String projectVersion = ProjectMigrator.currentVersion;
  static const String autoBackupFolderNameDesktop = "autosave";
  static const String autoBackupFolderNameMobile = "MonoAshi_Backup";
  static const String _customAutoBackupDirectoryKey =
      StoragePreferencesRepository.backupDirectoryKey;

  /// 從專案 XML 取出版本號（`<ver>`）
  static String? extractProjectVersion(String xmlContent) {
    try {
      final document = xml.XmlDocument.parse(xmlContent);
      final versionElement = document.findAllElements("ver").firstOrNull;
      final version = versionElement?.innerText.trim();
      if (version == null || version.isEmpty) return null;
      return version;
    } catch (_) {
      return null;
    }
  }

  /// 判斷檔案版本是否高於目前支援版本
  static bool isProjectVersionNewerThanSupported(String? fileVersion) {
    if (fileVersion == null || fileVersion.isEmpty) return false;
    return _compareVersion(fileVersion, projectVersion) > 0;
  }

  /// 比較語義版本字串，a > b 回傳 1，a < b 回傳 -1，相等回傳 0
  static int _compareVersion(String a, String b) {
    final aParts = a.split(".").map((p) => int.tryParse(p) ?? 0).toList();
    final bParts = b.split(".").map((p) => int.tryParse(p) ?? 0).toList();
    final maxLength = aParts.length > bParts.length
        ? aParts.length
        : bParts.length;

    for (var i = 0; i < maxLength; i++) {
      final aValue = i < aParts.length ? aParts[i] : 0;
      final bValue = i < bParts.length ? bParts[i] : 0;
      if (aValue > bValue) return 1;
      if (aValue < bValue) return -1;
    }
    return 0;
  }

  static bool _isPermissionDeniedError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains("permission denied") ||
        message.contains("operation not permitted") ||
        message.contains("access denied") ||
        message.contains("errno = 13");
  }

  static bool _looksLikeLocalPath(String value) {
    return value.startsWith("/") ||
        value.startsWith("\\") ||
        RegExp(r"^[a-zA-Z]:[\\/]").hasMatch(value);
  }

  static String? _normalizeLocalPathOrNull(String? rawPath) {
    if (rawPath == null) {
      return null;
    }

    final trimmed = rawPath.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.scheme.toLowerCase() == "file") {
      try {
        return uri.toFilePath(windows: Platform.isWindows);
      } catch (_) {
        return null;
      }
    }

    if (_looksLikeLocalPath(trimmed)) {
      return trimmed;
    }

    return null;
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, "0");

  static String _formatBackupTimestamp(DateTime now) {
    final yy = _twoDigits(now.year % 100);
    final mm = _twoDigits(now.month);
    final dd = _twoDigits(now.day);
    final hh = _twoDigits(now.hour);
    final min = _twoDigits(now.minute);
    final ss = _twoDigits(now.second);
    final millis = now.millisecond.toString().padLeft(3, "0");
    return "${yy}${mm}${dd}_${hh}${min}${ss}_$millis";
  }

  static String _sanitizeBackupProjectName(String projectName) {
    final sanitized = projectName
        .trim()
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), "_")
        .replaceAll(RegExp(r"\s+"), " ")
        .replaceAll(RegExp(r"^\.+|\.+$"), "");
    return sanitized.isEmpty ? defaultFileName : sanitized;
  }

  static Future<Directory> _defaultAutoBackupDirectory() async {
    if (Platform.isWindows) {
      final appData = Platform.environment["APPDATA"];
      if (appData != null && appData.trim().isNotEmpty) {
        return Directory(
          path.join(appData, "MonogatariAsstant", autoBackupFolderNameDesktop),
        );
      }
    }

    if (Platform.isMacOS) {
      final home = Platform.environment["HOME"];
      if (home != null && home.trim().isNotEmpty) {
        return Directory(
          path.join(
            home,
            "Library",
            "Containers",
            "com.heyairu.monoashi",
            autoBackupFolderNameDesktop,
          ),
        );
      }
    }

    if (Platform.isLinux) {
      final home = Platform.environment["HOME"];
      if (home != null && home.trim().isNotEmpty) {
        return Directory(
          path.join(
            home,
            ".config",
            "MonogatariAsstant",
            autoBackupFolderNameDesktop,
          ),
        );
      }
    }

    final supportDir = await getApplicationSupportDirectory();
    return Directory(path.join(supportDir.path, autoBackupFolderNameMobile));
  }

  static Future<String?> _customAutoBackupDirectoryPath() async {
    if (Platform.isAndroid) {
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString(_customAutoBackupDirectoryKey)?.trim();
    return savedPath == null || savedPath.isEmpty ? null : savedPath;
  }

  static Future<void> _setCustomAutoBackupDirectoryPath(
    String? directoryPath,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final normalized = directoryPath?.trim();
    if (normalized == null || normalized.isEmpty) {
      await prefs.remove(_customAutoBackupDirectoryKey);
      return;
    }

    final defaultDir = await _defaultAutoBackupDirectory();
    if (path.equals(
      path.normalize(normalized),
      path.normalize(defaultDir.path),
    )) {
      await prefs.remove(_customAutoBackupDirectoryKey);
      return;
    }

    await prefs.setString(_customAutoBackupDirectoryKey, normalized);
  }

  static Future<Directory> _autoBackupDirectory() async {
    final customPath = await _customAutoBackupDirectoryPath();
    if (customPath != null) {
      return Directory(customPath);
    }
    return _defaultAutoBackupDirectory();
  }

  static Future<Directory> _ensureAutoBackupDirectory() async {
    final backupDir = await _autoBackupDirectory();
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  /// 建立平台持久化存取 token（目前 macOS 會回傳 security-scoped bookmark）
  static Future<String?> createPersistentAccessToken(String? filePath) async {
    if (filePath == null || filePath.trim().isEmpty) {
      return null;
    }
    if (!Platform.isMacOS) {
      return null;
    }
    final normalizedPath = _normalizeLocalPathOrNull(filePath);
    if (normalizedPath == null || normalizedPath.isEmpty) {
      return null;
    }
    return await _SystemBridge.createSecurityScopedBookmark(normalizedPath);
  }

  // --- 專案生命週期 ---

  /// 創建新專案
  static Future<ProjectFile> createNewProject({String? fileName}) async {
    return ProjectFile(
      fileName: fileName ?? defaultFileName,
      filePath: null,
      content: "",
    );
  }

  /// 開啟專案檔案
  static Future<ProjectFile?> openProject() async {
    try {
      final result = await _SystemBridge.pickProjectFile();
      if (result != null) {
        final normalizedPath =
            _normalizeLocalPathOrNull(result.path) ??
            _normalizeLocalPathOrNull(result.uri);
        final resolvedFileName = result.name.trim().isNotEmpty
            ? result.name.trim()
            : (normalizedPath != null
                  ? path.basename(normalizedPath)
                  : "$defaultFileName$projectExtension");
        await _SystemBridge.persistUriPermission(result.uri);
        return ProjectFile(
          fileName: resolvedFileName,
          filePath: normalizedPath,
          uri: Platform.isMacOS
              ? await createPersistentAccessToken(normalizedPath)
              : result.uri,
          content: result.content,
        );
      }
    } catch (e) {
      throw FileException("開啟檔案失敗: ${e.toString()}", cause: e);
    }
    return null;
  }

  /// 依照完整路徑開啟專案檔案
  static Future<ProjectFile> openProjectFromPath(
    String filePath, {
    String? accessToken,
  }) async {
    final normalizedPath =
        _normalizeLocalPathOrNull(filePath) ?? filePath.trim();
    if (normalizedPath.isEmpty) {
      throw FileException("檔案路徑不可為空", code: ProjectErrorCode.invalidPath);
    }

    // Restore persistent access before even checking existence. A sandbox can
    // report an inaccessible file as absent, and a readable path alone does not
    // imply that the subsequent save will be permitted.
    if (Platform.isMacOS && accessToken?.trim().isNotEmpty == true) {
      try {
        return await openProjectFromSecurityScopedBookmark(accessToken!.trim());
      } catch (error) {
        debugPrint("Persistent project access failed: $error");
      }
    }

    try {
      final exists = await _FileIO.exists(normalizedPath);
      if (!exists) {
        throw FileException(
          "檔案不存在：$normalizedPath",
          code: ProjectErrorCode.fileMissing,
        );
      }

      final content = await _FileIO.read(normalizedPath);
      return ProjectFile(
        fileName: path.basename(normalizedPath),
        filePath: normalizedPath,
        uri: Platform.isMacOS
            ? await createPersistentAccessToken(normalizedPath)
            : null,
        content: content,
      );
    } catch (e) {
      if (e is FileException) {
        rethrow;
      }

      final normalizedToken = accessToken?.trim();

      // On macOS, reopening a path from Recent may fail if file permission
      // tokens expire; try bookmark-based access first, then re-authorize.
      if (Platform.isMacOS && _isPermissionDeniedError(e)) {
        if (normalizedToken != null && normalizedToken.isNotEmpty) {
          try {
            final reopened =
                await _SystemBridge.openProjectFromSecurityScopedBookmark(
                  normalizedToken,
                );
            if (reopened != null) {
              return ProjectFile(
                fileName: reopened.name,
                filePath: reopened.path ?? normalizedPath,
                uri: reopened.uri,
                content: reopened.content,
              );
            }
          } catch (_) {
            // Fall through to picker-based re-authorization.
          }
        }

        final picked = await _SystemBridge.pickProjectFile();
        if (picked != null) {
          return ProjectFile(
            fileName: picked.name,
            filePath: picked.path,
            uri: picked.uri,
            content: picked.content,
          );
        }
        throw FileException(
          "最近檔案權限已失效，請重新選取檔案。",
          code: ProjectErrorCode.accessDenied,
        );
      }

      throw FileException("開啟最近檔案失敗: ${e.toString()}", cause: e);
    }
  }

  /// 透過 macOS security-scoped bookmark 開啟專案檔案。
  static Future<ProjectFile> openProjectFromSecurityScopedBookmark(
    String bookmark,
  ) async {
    try {
      final opened = await _SystemBridge.openProjectFromSecurityScopedBookmark(
        bookmark,
      );
      if (opened == null) {
        throw FileException("無法讀取外部專案檔案", code: ProjectErrorCode.invalidData);
      }
      return ProjectFile(
        fileName: opened.name.trim().isEmpty
            ? "$defaultFileName$projectExtension"
            : opened.name.trim(),
        filePath: opened.path,
        uri: opened.uri,
        content: opened.content,
      );
    } catch (e) {
      if (e is FileException) {
        rethrow;
      }
      throw FileException("開啟外部專案檔案失敗: $e", cause: e);
    }
  }

  /// 開啟 Android 檔案管理器以 ACTION_VIEW 交付的 SAF URI。
  static Future<ProjectFile> openProjectFromExternalUri(String uri) async {
    try {
      final opened = await _SystemBridge.openExternalProjectUri(uri);
      if (opened == null) {
        throw FileException("無法讀取外部專案檔案", code: ProjectErrorCode.invalidData);
      }
      return ProjectFile(
        fileName: opened.name.trim().isEmpty
            ? "$defaultFileName$projectExtension"
            : opened.name.trim(),
        filePath: null,
        uri: opened.uri,
        content: opened.content,
      );
    } catch (e) {
      if (e is FileException) {
        rethrow;
      }
      throw FileException("開啟外部專案檔案失敗: $e", cause: e);
    }
  }

  /// 儲存專案檔案
  static Future<void> _writeProjectToLocalPath(
    ProjectFile projectFile,
    String normalizedPath,
  ) async {
    if (Platform.isMacOS) {
      final token =
          projectFile.uri ?? await createPersistentAccessToken(normalizedPath);
      if (token != null && token.isNotEmpty) {
        final result =
            await _SystemBridge.writeProjectFromSecurityScopedBookmark(
              token,
              projectFile.content,
            );
        projectFile.filePath = result.path;
        projectFile.uri = result.uri;
        return;
      }
    }
    await _FileIO.write(normalizedPath, projectFile.content);
  }

  /// 儲存專案檔案
  static Future<ProjectFile> saveProject(
    ProjectFile projectFile, {
    String? dialogTitle,
  }) async {
    try {
      // Android SAF URI Support
      if (Platform.isAndroid && projectFile.uri != null) {
        try {
          await _SystemBridge.writeToUri(projectFile.uri!, projectFile.content);
          projectFile.content = "";
          return projectFile;
        } catch (e) {
          debugPrint("SAF Write failed (URI might be invalid or expired): $e");
          throw FileException("原儲存位置已無法寫入；請明確使用「另存為」重新選擇位置。原因：$e", cause: e);
        }
      }

      final normalizedPath = _normalizeLocalPathOrNull(projectFile.filePath);

      if (normalizedPath != null) {
        projectFile.filePath = normalizedPath;
        // 儲存到現有路徑
        try {
          await _writeProjectToLocalPath(projectFile, normalizedPath);
          projectFile.content = "";
          return projectFile;
        } catch (e) {
          // iOS retains its previous explicit recovery behavior. Android
          // projects should use their persisted SAF URI and must never open a
          // surprise Save As dialog when a known location becomes invalid.
          if (Platform.isIOS) {
            return await saveProjectAs(projectFile, dialogTitle: dialogTitle);
          }
          rethrow;
        }
      } else {
        // 另存新檔
        return await saveProjectAs(projectFile, dialogTitle: dialogTitle);
      }
    } catch (e) {
      projectFile.content = "";
      throw FileException("儲存檔案失敗: ${e.toString()}", cause: e);
    }
  }

  /// 只儲存到已知位置，不觸發另存新檔對話框。
  static Future<ProjectFile> saveProjectToKnownLocation(
    ProjectFile projectFile,
  ) async {
    try {
      if (Platform.isAndroid && projectFile.uri != null) {
        await _SystemBridge.writeToUri(projectFile.uri!, projectFile.content);
        projectFile.content = "";
        return projectFile;
      }

      final normalizedPath = _normalizeLocalPathOrNull(projectFile.filePath);
      if (normalizedPath == null) {
        throw FileException(
          "自動儲存需要已知檔案路徑。",
          code: ProjectErrorCode.noSaveLocation,
        );
      }

      projectFile.filePath = normalizedPath;
      await _writeProjectToLocalPath(projectFile, normalizedPath);
      projectFile.content = "";
      return projectFile;
    } catch (e) {
      projectFile.content = "";
      if (e is FileException) {
        rethrow;
      }
      throw FileException("自動儲存失敗: ${e.toString()}", cause: e);
    }
  }

  /// 另存新檔
  static Future<ProjectFile> saveProjectAs(
    ProjectFile projectFile, {
    String? dialogTitle,
  }) async {
    try {
      final content = projectFile.takeContent();
      final outputFileRaw = await _SystemBridge.saveProjectFileDialog(
        defaultName: "${projectFile.nameWithoutExtension}$projectExtension",
        dialogTitle: dialogTitle,
        content: content,
      );

      // 如果使用者取消儲存
      if (outputFileRaw == null) {
        throw FileException("另存檔案已取消", code: ProjectErrorCode.cancelled);
      }

      final outputFile = outputFileRaw.trim();
      if (outputFile.isEmpty) {
        throw FileException(
          "另存檔案失敗: 無效檔案路徑",
          code: ProjectErrorCode.invalidPath,
        );
      }

      final normalizedPath =
          _normalizeLocalPathOrNull(outputFile) ?? outputFile;
      final normalizedLocalPath = _normalizeLocalPathOrNull(normalizedPath);
      final outputUri = normalizedLocalPath == null ? normalizedPath : null;
      await _SystemBridge.persistUriPermission(outputUri);

      // 在桌面平台上仍需要寫入檔案 (SystemBridge 可能只回傳路徑)
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        await _FileIO.write(normalizedPath, content);
      }

      final resolvedFileName = _looksLikeLocalPath(normalizedPath)
          ? path.basenameWithoutExtension(normalizedPath)
          : (projectFile.fileName.trim().isNotEmpty
                ? projectFile.fileName.trim()
                : defaultFileName);

      return ProjectFile(
        fileName: resolvedFileName,
        filePath: normalizedLocalPath,
        uri: Platform.isMacOS
            ? await createPersistentAccessToken(normalizedLocalPath)
            : outputUri,
        content: "",
      );
    } catch (e) {
      throw FileException("另存檔案失敗: ${e.toString()}", cause: e);
    }
  }

  /// 寫入 AutoBackup 檔案，不影響目前專案路徑或未儲存狀態。
  static Future<String> saveProjectAutoBackup({
    required String projectName,
    required String content,
    required int maxTotalBytes,
  }) async {
    try {
      final safeProjectName = _sanitizeBackupProjectName(projectName);
      final timestamp = _formatBackupTimestamp(DateTime.now());
      final backupName =
          "${safeProjectName}_backup_$timestamp$projectExtension";

      final contentBytes = utf8.encode(content).length;
      if (contentBytes > maxTotalBytes) {
        throw FileException(
          "單一專案備份已超過設定的 AutoBackup 容量上限，請提高上限。",
          code: ProjectErrorCode.backupLimit,
        );
      }
      final availableBytes = await _availableBackupBytes();
      if (availableBytes != null &&
          availableBytes < contentBytes + (16 * 1024 * 1024)) {
        throw FileException(
          "AutoBackup 可用空間不足，請清理備份或更換目錄。",
          code: ProjectErrorCode.noSpace,
        );
      }

      late final String savedLocation;
      if (Platform.isAndroid) {
        savedLocation = await _SystemBridge.saveAutoBackupFile(
          fileName: backupName,
          content: content,
        );
      } else {
        final backupDir = await _ensureAutoBackupDirectory();
        final backupPath = path.join(backupDir.path, backupName);
        final temporaryPath = "$backupPath.tmp";
        await _FileIO.write(temporaryPath, content);
        await File(temporaryPath).rename(backupPath);
        savedLocation = backupPath;
      }

      try {
        await _pruneAutoBackups(
          projectName: safeProjectName,
          maxTotalBytes: maxTotalBytes,
          maxGenerations: 100,
          maxAge: const Duration(days: 30),
        );
      } catch (error, stackTrace) {
        debugPrint("AutoBackup cleanup failed: $error\n$stackTrace");
      }
      return savedLocation;
    } catch (e) {
      throw FileException("寫入 AutoBackup 失敗: ${e.toString()}", cause: e);
    }
  }

  /// 取得 AutoBackup 目錄；若尚未存在會先建立。
  static Future<String> getAutoBackupDirectoryPath() async {
    final info = await getAutoBackupDirectoryInfo();
    return info.path;
  }

  static Future<AutoBackupDirectoryInfo> getAutoBackupDirectoryInfo() async {
    final inventory = await _listAutoBackupFiles();
    final totalBytes = inventory.fold<int>(0, (sum, item) => sum + item.size);
    if (Platform.isAndroid) {
      final selectedUri = await _SystemBridge.getSelectedAutoBackupDirectory();
      return AutoBackupDirectoryInfo(
        path: selectedUri ?? "",
        isConfigured: selectedUri != null && selectedUri.trim().isNotEmpty,
        isDefault: false,
        canReset: false,
        isAndroid: true,
        totalBytes: totalBytes,
        fileCount: inventory.length,
      );
    }

    final defaultDir = await _defaultAutoBackupDirectory();
    final customPath = await _customAutoBackupDirectoryPath();
    final activePath = customPath ?? defaultDir.path;
    final isDefault = customPath == null;

    return AutoBackupDirectoryInfo(
      path: activePath,
      isConfigured: true,
      isDefault: isDefault,
      canReset: !isDefault,
      isAndroid: false,
      totalBytes: totalBytes,
      fileCount: inventory.length,
    );
  }

  static Future<AutoBackupCleanupResult> clearAutoBackups() async {
    final files = await _listAutoBackupFiles();
    var deletedFiles = 0;
    var freedBytes = 0;
    for (final file in files) {
      await _deleteAutoBackupFile(file);
      deletedFiles++;
      freedBytes += file.size;
    }
    return AutoBackupCleanupResult(
      deletedFiles: deletedFiles,
      freedBytes: freedBytes,
    );
  }

  static Future<List<_AutoBackupFileEntry>> _listAutoBackupFiles() async {
    if (Platform.isAndroid) {
      final raw = await _SystemBridge.listAutoBackupFiles();
      return raw
          .map((entry) {
            final modifiedMillis = entry["modified"] as int? ?? 0;
            return _AutoBackupFileEntry(
              name: entry["name"] as String? ?? "",
              location: entry["uri"] as String? ?? "",
              size: entry["size"] as int? ?? 0,
              modified: DateTime.fromMillisecondsSinceEpoch(modifiedMillis),
            );
          })
          .where((entry) => entry.name.endsWith(projectExtension))
          .toList();
    }

    final directory = await _ensureAutoBackupDirectory();
    final entries = <_AutoBackupFileEntry>[];
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is! File || !entity.path.endsWith(projectExtension)) continue;
      final stat = await entity.stat();
      entries.add(
        _AutoBackupFileEntry(
          name: path.basename(entity.path),
          location: entity.path,
          size: stat.size,
          modified: stat.modified,
        ),
      );
    }
    return entries;
  }

  static Future<void> _deleteAutoBackupFile(_AutoBackupFileEntry entry) async {
    if (Platform.isAndroid) {
      await _SystemBridge.deleteAutoBackupFile(entry.location);
    } else {
      await File(entry.location).delete();
    }
  }

  static Future<void> _pruneAutoBackups({
    required String projectName,
    required int maxTotalBytes,
    required int maxGenerations,
    required Duration maxAge,
  }) async {
    final prefix = "${projectName}_backup_";
    final files =
        (await _listAutoBackupFiles())
            .where((entry) => entry.name.startsWith(prefix))
            .toList()
          ..sort((a, b) => b.modified.compareTo(a.modified));
    final cutoff = DateTime.now().subtract(maxAge);
    var retainedBytes = 0;
    for (var index = 0; index < files.length; index++) {
      final file = files[index];
      final exceedsGeneration = index >= maxGenerations;
      final exceedsAge = file.modified.isBefore(cutoff);
      final exceedsBytes = retainedBytes + file.size > maxTotalBytes;
      if (exceedsGeneration || exceedsAge || exceedsBytes) {
        await _deleteAutoBackupFile(file);
      } else {
        retainedBytes += file.size;
      }
    }
  }

  static Future<int?> _availableBackupBytes() async {
    if (Platform.isAndroid) {
      return _SystemBridge.getAvailableBackupBytes();
    }
    try {
      final backupDir = await _ensureAutoBackupDirectory();
      if (Platform.isWindows) {
        final root = path.rootPrefix(backupDir.path).replaceAll("\\", "");
        final result = await Process.run("wmic", [
          "logicaldisk",
          "where",
          "DeviceID='$root'",
          "get",
          "FreeSpace",
          "/value",
        ]);
        final match = RegExp(
          r"FreeSpace=(\d+)",
        ).firstMatch(result.stdout.toString());
        if (match != null) return int.tryParse(match.group(1)!);
        final driveName = root.replaceAll(":", "");
        final fallback = await Process.run("powershell", [
          "-NoProfile",
          "-NonInteractive",
          "-Command",
          "(Get-PSDrive -Name '$driveName').Free",
        ]);
        return int.tryParse(fallback.stdout.toString().trim());
      }
      final result = await Process.run("df", ["-Pk", backupDir.path]);
      final lines = result.stdout.toString().trim().split(RegExp(r"\r?\n"));
      if (lines.length < 2) return null;
      final columns = lines.last.trim().split(RegExp(r"\s+"));
      return columns.length < 4 ? null : (int.tryParse(columns[3]) ?? 0) * 1024;
    } catch (_) {
      return null;
    }
  }

  static Future<String> selectAutoBackupDirectory({String? dialogTitle}) async {
    if (Platform.isAndroid) {
      final selectedUri = await _SystemBridge.selectAutoBackupDirectory();
      if (selectedUri == null || selectedUri.trim().isEmpty) {
        throw FileException(
          "已取消選擇 AutoBackup 目錄。",
          code: ProjectErrorCode.cancelled,
        );
      }
      return selectedUri;
    }

    final defaultDir = await _defaultAutoBackupDirectory();
    final currentDir = await _autoBackupDirectory();
    final selectedPath = await FilePicker.platform.getDirectoryPath(
      dialogTitle: dialogTitle ?? "選擇 AutoBackup 目錄",
      initialDirectory: (await currentDir.exists())
          ? currentDir.path
          : defaultDir.parent.path,
    );

    if (selectedPath == null || selectedPath.trim().isEmpty) {
      throw FileException(
        "已取消選擇 AutoBackup 目錄。",
        code: ProjectErrorCode.cancelled,
      );
    }

    await _setCustomAutoBackupDirectoryPath(selectedPath);
    final selectedDir = Directory(selectedPath);
    if (!await selectedDir.exists()) {
      await selectedDir.create(recursive: true);
    }
    return selectedDir.path;
  }

  static Future<String> resetAutoBackupDirectory() async {
    if (Platform.isAndroid) {
      throw FileException("Android 需要由使用者選擇 AutoBackup 目錄。");
    }

    await _setCustomAutoBackupDirectoryPath(null);
    final backupDir = await _ensureAutoBackupDirectory();
    return backupDir.path;
  }

  /// 使用平台檔案管理器開啟 AutoBackup 目錄。
  static Future<String> openAutoBackupDirectory() async {
    if (Platform.isAndroid) {
      await _SystemBridge.openSelectedAutoBackupDirectory();
      final selectedUri = await _SystemBridge.getSelectedAutoBackupDirectory();
      return selectedUri ?? "";
    }

    final backupDir = await _ensureAutoBackupDirectory();

    try {
      if (Platform.isWindows) {
        final result = await Process.run("explorer", [backupDir.path]);
        if (result.exitCode == 0) {
          return backupDir.path;
        }
      } else if (Platform.isMacOS) {
        final result = await Process.run("open", [backupDir.path]);
        if (result.exitCode == 0) {
          return backupDir.path;
        }
      } else if (Platform.isLinux) {
        final result = await Process.run("xdg-open", [backupDir.path]);
        if (result.exitCode == 0) {
          return backupDir.path;
        }
      }

      final directoryUri = Uri.directory(
        backupDir.path,
        windows: Platform.isWindows,
      );
      final launched = await launchUrl(
        directoryUri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) {
        return backupDir.path;
      }
    } catch (e) {
      throw FileException("開啟 AutoBackup 目錄失敗: ${e.toString()}", cause: e);
    }

    throw FileException("此平台不支援直接開啟 AutoBackup 目錄：${backupDir.path}");
  }

  /// 匯出文字檔案
  static Future<void> exportText({
    required String content,
    required String fileName,
    required String extension,
  }) async {
    await exportTextWithResult(
      content: content,
      fileName: fileName,
      extension: extension,
    );
  }

  /// 匯出文字檔案，並回報使用者是否實際選擇了儲存位置。
  static Future<bool> exportTextWithResult({
    String? dialogTitle,
    required String content,
    required String fileName,
    required String extension,
  }) async {
    try {
      final exportContent = content;

      final outputFile = await _SystemBridge.saveExportDialog(
        defaultName: "$fileName$extension",
        dialogTitle: dialogTitle,
        extension: extension,
        content: exportContent, // 傳遞內容以供某些平台 direct save
      );

      if (outputFile == null) return false;

      // 在桌面平台上仍需要寫入檔案
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        await _FileIO.write(outputFile, exportContent);
      }
      return true;
    } catch (e) {
      throw FileException("匯出檔案失敗: ${e.toString()}", cause: e);
    }
  }

  //Mark: --- 本地檔案操作 ---

  /// 讀取本地檔案（用於應用程式內部儲存）
  static Future<String> readLocalFile(String fileName) async {
    try {
      final dirPath = await _SystemBridge.getAppDocumentsPath();
      final fullPath = path.join(dirPath, fileName);
      return await _FileIO.read(fullPath);
    } catch (e) {
      throw FileException("讀取本地檔案失敗: ${e.toString()}", cause: e);
    }
  }

  /// 寫入本地檔案（用於應用程式內部儲存）
  static Future<void> writeLocalFile(String fileName, String content) async {
    try {
      final dirPath = await _SystemBridge.getAppDocumentsPath();
      final fullPath = path.join(dirPath, fileName);
      await _FileIO.write(fullPath, content);
    } catch (e) {
      throw FileException("寫入本地檔案失敗: ${e.toString()}", cause: e);
    }
  }

  // --- 系統資訊與管理 ---

  /// 獲取應用程式文件目錄
  static Future<String> getAppDocumentsPath() async {
    return _SystemBridge.getAppDocumentsPath();
  }

  /// 檢查檔案是否存在
  static Future<bool> fileExists(String filePath) async {
    return _FileIO.exists(filePath);
  }

  /// 刪除檔案
  static Future<void> deleteFile(String filePath) async {
    try {
      await _FileIO.delete(filePath);
    } catch (e) {
      throw FileException("刪除檔案失敗: ${e.toString()}", cause: e);
    }
  }

  /// 獲取檔案資訊
  static Future<FileInfo> getFileInfo(String filePath) async {
    try {
      return await _SystemBridge.getFileInfo(filePath);
    } catch (e) {
      throw FileException("獲取檔案資訊失敗: ${e.toString()}", cause: e);
    }
  }

  // --- 轉換與處理 ---

  /// 生成專案XML內容 (Merger)
  static String generateProjectXML(ProjectData data) {
    return _ProjectMerger.generateProjectXML(data);
  }

  static String generateProjectXMLWithoutLatestSaveUpdate(ProjectData data) {
    return _ProjectMerger.generateProjectXML(data, updateLatestSave: false);
  }

  /// 解析專案XML內容 (Parser)
  static ProjectData parseProjectXML(
    String xmlContent, {
    ProjectDefaults defaults = const ProjectDefaults(),
  }) {
    return _ProjectParser.parseProjectXML(xmlContent, defaults: defaults);
  }

  static ProjectParseResult parseProjectXMLWithMetadata(
    String xmlContent, {
    ProjectDefaults defaults = const ProjectDefaults(),
  }) {
    return _ProjectParser.parseProjectXMLWithMetadata(
      xmlContent,
      defaults: defaults,
    );
  }
}
