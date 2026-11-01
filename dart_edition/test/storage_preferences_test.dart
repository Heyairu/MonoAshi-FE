import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/file.dart';
import 'package:monogatari_assistant/data/repositories/storage_preferences_repository.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class _RecordingFilePicker extends FilePicker {
  String? initial;
  String? next;

  @override
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Uint8List? bytes,
    bool lockParentWindow = false,
  }) async {
    initial = initialDirectory;
    return next;
  }

  @override
  Future<String?> getDirectoryPath({
    String? dialogTitle,
    bool lockParentWindow = false,
    String? initialDirectory,
  }) async {
    initial = initialDirectory;
    return next;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory temp;
  late FilePicker originalPicker;
  late _RecordingFilePicker picker;
  final repository = StoragePreferencesRepository();

  setUpAll(() => FilePicker.platform = _RecordingFilePicker());

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    temp = await Directory.systemTemp.createTemp('monoashi-storage-test-');
    originalPicker = FilePicker.platform;
    picker = _RecordingFilePicker();
    FilePicker.platform = picker;
  });

  tearDown(() async {
    FilePicker.platform = originalPicker;
    await temp.delete(recursive: true);
  });

  test(
    'save-as uses the system dialog without a preferred directory',
    () async {
      picker.next = path.join(temp.path, 'story.mnproj');
      final saved = await FileService.saveProjectAs(
        ProjectFile(
          fileName: 'story.mnproj',
          filePath: null,
          content: '<story>test</story>',
        ),
      );
      expect(picker.initial, isNull);
      expect(saved.filePath, picker.next);
      expect(await File(saved.filePath!).readAsString(), '<story>test</story>');
    },
    skip: !(Platform.isMacOS || Platform.isWindows || Platform.isLinux),
  );

  test('auto-backup writes into the configured backup directory', () async {
    final directory = Directory(path.join(temp.path, 'backups'));
    await repository.save(StorageDirectories(backupDirectory: directory.path));
    final saved = await FileService.saveProjectAutoBackup(
      projectName: 'story',
      content: '<story>backup</story>',
      maxTotalBytes: 1024 * 1024,
    );
    expect(path.dirname(saved), directory.path);
    expect(await File(saved).readAsString(), '<story>backup</story>');
  }, skip: !(Platform.isMacOS || Platform.isWindows || Platform.isLinux));

  test(
    'missing backup directory does not become the picker starting location',
    () async {
      picker.next = null;
      expect(
        await repository.pickDirectory(
          title: 'Backup folder',
          initialDirectory: path.join(temp.path, 'removed'),
        ),
        isNull,
      );
      expect(picker.initial, isNull);
    },
    skip: !(Platform.isMacOS || Platform.isWindows || Platform.isLinux),
  );

  test('picking and cancelling folders do not persist draft choices', () async {
    picker.next = temp.path;
    expect(await repository.pickDirectory(title: 'Backup folder'), temp.path);
    expect((await repository.load()).backupDirectory, isNull);
    picker.next = null;
    expect(
      await repository.pickDirectory(
        title: 'Backup folder',
        initialDirectory: temp.path,
      ),
      isNull,
    );
    expect(picker.initial, temp.path);
    expect((await repository.load()).backupDirectory, isNull);
  }, skip: !(Platform.isMacOS || Platform.isWindows || Platform.isLinux));

  test(
    'reset restores defaults without moving or deleting existing files',
    () async {
      final existing = File(path.join(temp.path, 'existing.mnproj'));
      await existing.writeAsString('original');
      await repository.save(StorageDirectories(backupDirectory: temp.path));
      await repository.save(const StorageDirectories());
      final directories = await repository.load();
      expect(directories.backupDirectory, isNull);
      expect(await existing.readAsString(), 'original');
    },
  );
}
