import "dart:typed_data";

import "../project_import/selective_project_import.dart";

export "../project_import/selective_project_import.dart"
    show SelectiveProjectModule;

enum ExportPurpose { manuscript, reference, exchange }

enum ExportFormat {
  txt("TXT", "txt", "text/plain"),
  markdown("Markdown", "md", "text/markdown"),
  xml("XML", "xml", "application/xml"),
  docx(
    "Word（尚未開放）",
    "docx",
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  ),
  pdf("PDF（尚未開放）", "pdf", "application/pdf");

  final String label;
  final String extension;
  final String mimeType;
  const ExportFormat(this.label, this.extension, this.mimeType);
  bool get available => this != docx && this != pdf;
}

enum ExportPackaging { singleFile, splitZip }

/// Null selection means the whole module. An empty set never means select all.
class ExportRequest {
  final ExportPurpose purpose;
  final ExportFormat format;
  final ExportPackaging packaging;
  final Set<SelectiveProjectModule> modules;
  final Map<SelectiveProjectModule, Set<String>> selections;
  final bool includeBookInfo;
  final bool includeHeadings;

  ExportRequest({
    required this.purpose,
    required this.format,
    this.packaging = ExportPackaging.singleFile,
    Set<SelectiveProjectModule> modules = const {
      SelectiveProjectModule.chapters,
    },
    Map<SelectiveProjectModule, Set<String>> selections = const {},
    this.includeBookInfo = false,
    this.includeHeadings = true,
  }) : modules = Set.unmodifiable(modules),
       selections = Map.unmodifiable(
         selections.map(
           (key, value) => MapEntry(key, Set<String>.unmodifiable(value)),
         ),
       );
}

class ExportSelectionNode {
  final String key;
  final String label;
  final String kind;
  final bool selectable;
  final String? summary;
  final List<ExportSelectionNode> children;
  const ExportSelectionNode({
    required this.key,
    required this.label,
    required this.kind,
    this.selectable = true,
    this.summary,
    this.children = const [],
  });

  Iterable<String> get selectableKeys sync* {
    final pending = <ExportSelectionNode>[this];
    while (pending.isNotEmpty) {
      final node = pending.removeLast();
      if (node.selectable) yield node.key;
      pending.addAll(node.children.reversed);
    }
  }
}

class ExportDocument {
  final String path;
  final List<String> logicalPath;
  final Uint8List bytes;
  final String preview;
  ExportDocument({
    required this.path,
    required List<String> logicalPath,
    required this.bytes,
    required this.preview,
  }) : logicalPath = List.unmodifiable(logicalPath);
}

class PreparedExport {
  final Uint8List bytes;
  final String extension;
  final String mimeType;
  final List<ExportDocument> documents;
  final List<String> warnings;
  PreparedExport({
    required this.bytes,
    required this.extension,
    required this.mimeType,
    required List<ExportDocument> documents,
    List<String> warnings = const [],
  }) : documents = List.unmodifiable(documents),
       warnings = List.unmodifiable(warnings);
}

enum ExportSaveStatus { saved, cancelled }

class ExportSaveResult {
  final ExportSaveStatus status;
  final String? destination;
  const ExportSaveResult.saved(this.destination)
    : status = ExportSaveStatus.saved;
  const ExportSaveResult.cancelled()
    : status = ExportSaveStatus.cancelled,
      destination = null;
}
