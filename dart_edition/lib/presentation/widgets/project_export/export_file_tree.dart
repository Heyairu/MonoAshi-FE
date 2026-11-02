import 'package:monogatari_assistant/l10n/app_localization.dart';
import 'package:flutter/material.dart';
import '../../../application/project_export/export_models.dart';

class ExportFileTree extends StatelessWidget {
  final List<ExportDocument> documents;
  final ValueChanged<int> onSelected;
  const ExportFileTree({
    super.key,
    required this.documents,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final root = _Directory();
    for (var i = 0; i < documents.length; i++) {
      final parts = documents[i].path.split('/');
      var parent = root;
      for (final name in parts.take(parts.length - 1)) {
        parent = parent.directories.putIfAbsent(name, _Directory.new);
      }
      parent.files[parts.last] = i;
    }
    List<Widget> children(_Directory parent, String path) => [
      for (final entry in parent.directories.entries)
        ExpansionTile(
          key: PageStorageKey('export-files-$path/${entry.key}'),
          leading: const Icon(Icons.folder_outlined),
          title: Text(entry.key),
          childrenPadding: const EdgeInsets.only(left: 12),
          children: children(entry.value, '$path/${entry.key}'),
        ),
      for (final entry in parent.files.entries)
        ListTile(
          dense: true,
          leading: const Icon(Icons.description_outlined),
          title: Text(entry.key),
          onTap: () => onSelected(entry.value),
        ),
    ];
    return ExpansionTile(
      title: Text(context.l10n.uiZIPFileTree),
      initiallyExpanded: true,
      children: [
        ...children(root, ''),
        ListTile(
          dense: true,
          leading: Icon(Icons.info_outline),
          title: Text('README.txt'),
          subtitle: Text(context.l10n.uiExportNotes),
        ),
        ListTile(
          dense: true,
          leading: Icon(Icons.list_alt),
          title: Text('export-manifest.json'),
          subtitle: Text(context.l10n.uiFileAndHierarchyIndex),
        ),
      ],
    );
  }
}

class _Directory {
  final directories = <String, _Directory>{};
  final files = <String, int>{};
}
