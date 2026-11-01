import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageDirectories {
  const StorageDirectories({this.backupDirectory});

  final String? backupDirectory;
}

/// Device-local backup location, shared by OOBE and the backup writer.
class StoragePreferencesRepository {
  static const backupDirectoryKey = 'custom_auto_backup_directory';

  bool get supportsDirectorySelection =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  Future<StorageDirectories> load() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageDirectories(
      backupDirectory: prefs.getString(backupDirectoryKey),
    );
  }

  Future<void> save(StorageDirectories directories) async {
    final prefs = await SharedPreferences.getInstance();
    final value = directories.backupDirectory?.trim();
    final saved = value == null || value.isEmpty
        ? await prefs.remove(backupDirectoryKey)
        : await prefs.setString(backupDirectoryKey, value);
    if (!saved) throw StateError('無法保存備份位置，請重試。');
  }

  Future<String?> pickDirectory({
    required String title,
    String? initialDirectory,
  }) async {
    if (!supportsDirectorySelection) return null;
    final initial = await _existingDirectory(initialDirectory);
    return FilePicker.platform.getDirectoryPath(
      dialogTitle: title,
      initialDirectory: initial,
      lockParentWindow: true,
    );
  }

  Future<String?> _existingDirectory(String? directory) async {
    if (directory == null || directory.trim().isEmpty) return null;
    try {
      return await Directory(directory).exists() ? directory : null;
    } on FileSystemException {
      return null;
    }
  }
}

final storagePreferencesRepositoryProvider =
    Provider<StoragePreferencesRepository>(
      (ref) => StoragePreferencesRepository(),
    );

final storageDirectoriesProvider = FutureProvider<StorageDirectories>(
  (ref) => ref.watch(storagePreferencesRepositoryProvider).load(),
);
