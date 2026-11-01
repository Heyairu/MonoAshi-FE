import 'dart:io';

import 'package:file_picker/file_picker.dart';
import '../../application/project_export/export_models.dart';
import '../../application/project_export/export_service.dart';
import '../../domain/repositories/export_writer.dart';

class PlatformExportWriter implements ExportWriter {
  @override
  Future<ExportSaveResult> save(
    PreparedExport output,
    String fileName, {
    bool Function()? canWrite,
  }) async {
    if (canWrite != null && !canWrite()) throw StateError('來源專案已切換，請重新開啟匯出。');
    final mobile = Platform.isAndroid || Platform.isIOS;
    final destination = await FilePicker.platform.saveFile(
      dialogTitle: '匯出檔案',
      fileName: '${safeExportName(fileName)}.${output.extension}',
      type: FileType.custom,
      allowedExtensions: [output.extension],
      bytes: mobile ? output.bytes : null,
    );
    if (destination == null) return const ExportSaveResult.cancelled();
    if (!mobile) {
      if (canWrite != null && !canWrite()) {
        throw StateError('選擇位置期間來源專案已切換，未寫入檔案。');
      }
      await writeExportBytesAtomically(destination, output.bytes);
    }
    // Mobile pickers may return a guessed path instead of their actual URI.
    return ExportSaveResult.saved(mobile ? null : destination);
  }
}

/// A unique sibling temporary file prevents partial replacement on write error.
Future<void> writeExportBytesAtomically(
  String destination,
  List<int> bytes,
) async {
  final target = File(destination);
  final temporaryDirectory = await Directory(
    target.parent.path,
  ).createTemp('.monogatari-export-');
  try {
    final temporary = File('${temporaryDirectory.path}/output');
    await temporary.writeAsBytes(bytes, flush: true);
    await temporary.rename(target.path);
  } finally {
    if (await temporaryDirectory.exists()) {
      await temporaryDirectory.delete(recursive: true);
    }
  }
}
