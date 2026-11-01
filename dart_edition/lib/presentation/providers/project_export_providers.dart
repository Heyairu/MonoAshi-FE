import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/project_export/export_service.dart';
import '../../data/repositories/platform_export_writer.dart';
import '../../domain/repositories/export_writer.dart';

final projectExportServiceProvider = Provider<ProjectExportService>(
  (ref) => const ProjectExportService(),
);
final exportWriterProvider = Provider<ExportWriter>(
  (ref) => PlatformExportWriter(),
);
