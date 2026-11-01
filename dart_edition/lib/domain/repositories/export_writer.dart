import '../../application/project_export/export_models.dart';

abstract class ExportWriter {
  Future<ExportSaveResult> save(
    PreparedExport output,
    String fileName, {
    bool Function()? canWrite,
  });
}
