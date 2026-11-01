import 'package:flutter/material.dart';

import '../../../application/project_export/export_models.dart';
import '../../../application/project_export/export_selection.dart';
import '../../../features/help/help_scope.dart';
import '../../../features/help/help_topic.dart';
import '../../../models/project_data.dart';
import '../../../ui_library/dialogs.dart';
import 'export_selection_tree.dart';
import 'export_file_tree.dart';

class ProjectExportDialog extends StatefulWidget {
  final ProjectData snapshot;
  final bool Function() isCurrent;
  final Future<ExportSaveResult> Function(PreparedExport) save;
  final Future<PreparedExport> Function(ExportRequest) prepare;
  final ExportFormat initialFormat;
  final String? currentChapterId;
  const ProjectExportDialog({
    super.key,
    required this.snapshot,
    required this.isCurrent,
    required this.save,
    required this.prepare,
    this.initialFormat = ExportFormat.markdown,
    this.currentChapterId,
  });

  @override
  State<ProjectExportDialog> createState() => _ProjectExportDialogState();
}

class _ProjectExportDialogState extends State<ProjectExportDialog> {
  late final Map<SelectiveProjectModule, List<ExportSelectionNode>> _trees;
  final _selected = <SelectiveProjectModule, Set<String>>{};
  final _modules = <SelectiveProjectModule>{SelectiveProjectModule.chapters};
  ExportPurpose _purpose = ExportPurpose.manuscript;
  late ExportFormat _format;
  ExportPackaging _packaging = ExportPackaging.singleFile;
  bool _bookInfo = false;
  bool _headings = true;
  bool _busy = false;
  String? _message;
  PreparedExport? _output;
  int _previewIndex = 0;

  @override
  void initState() {
    super.initState();
    _format = widget.initialFormat;
    _trees = buildExportSelections(widget.snapshot);
    for (final module in _trees.keys) {
      _selected[module] = module == SelectiveProjectModule.chapters
          ? {for (final node in _trees[module]!) ...node.selectableKeys}
          : {};
    }
  }

  void _change(VoidCallback action) => setState(() {
    action();
    _output = null;
    _message = null;
    _previewIndex = 0;
  });

  Future<void> _prepareOutput() async {
    setState(() {
      _busy = true;
      _message = '準備內容與封裝…';
    });
    try {
      if (!widget.isCurrent()) throw const FormatException('來源專案已切換，請重新開啟匯出。');
      final request = ExportRequest(
        purpose: _purpose,
        format: _format,
        packaging: _packaging,
        modules: _purpose == ExportPurpose.manuscript
            ? {SelectiveProjectModule.chapters}
            : _modules,
        selections: {
          for (final module in _selected.keys)
            if ((_purpose == ExportPurpose.manuscript
                    ? module == SelectiveProjectModule.chapters
                    : _modules.contains(module)) &&
                (_trees[module]?.isNotEmpty ?? false))
              module: _selected[module]!,
        },
        includeBookInfo: _bookInfo,
        includeHeadings: _headings,
      );
      final prepared = await widget.prepare(request);
      if (!mounted) return;
      setState(() {
        _output = prepared;
        _previewIndex = 0;
        _message = null;
      });
    } catch (error) {
      if (mounted) setState(() => _message = '無法準備匯出：$error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    final output = _output;
    if (output == null) return;
    setState(() {
      _busy = true;
      _message = '選擇位置並儲存…';
    });
    try {
      if (!widget.isCurrent()) throw const FormatException('來源專案已切換，請重新開啟匯出。');
      final result = await widget.save(output);
      if (!mounted) return;
      if (result.status == ExportSaveStatus.saved) {
        Navigator.of(context).pop(result);
      } else {
        setState(() => _message = '已取消儲存，可重新選擇位置。');
      }
    } catch (error) {
      if (mounted) setState(() => _message = '匯出失敗：$error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final output = _output;
    final formats = switch (_purpose) {
      ExportPurpose.manuscript => [
        ExportFormat.txt,
        ExportFormat.markdown,
        ExportFormat.docx,
        ExportFormat.pdf,
      ],
      ExportPurpose.reference => [
        ExportFormat.markdown,
        ExportFormat.docx,
        ExportFormat.pdf,
      ],
      ExportPurpose.exchange => [ExportFormat.xml],
    };
    return PopScope(
      canPop: !_busy,
      child: HelpTarget(
        topicId: HelpTopicId.exportFiles,
        child: AppDialog(
          title: '匯出',
          icon: Icons.output,
          maxWidth: 840,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          content: SizedBox(
            width: 760,
            height: MediaQuery.sizeOf(context).height * .72,
            child: AbsorbPointer(
              absorbing: _busy,
              child: ListView(
                children: [
                  Text(
                    '來源：${widget.snapshot.baseInfoData.bookName.isEmpty ? '目前作品' : widget.snapshot.baseInfoData.bookName}（開啟匯出時的內容快照）',
                  ),
                  if (_busy)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: LinearProgressIndicator(),
                    ),
                  if (_message != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(_message!, key: const Key('export-message')),
                    ),
                  if (output == null) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ExportPurpose>(
                      key: const Key('export-purpose'),
                      initialValue: _purpose,
                      decoration: const InputDecoration(labelText: '用途'),
                      items: const [
                        DropdownMenuItem(
                          value: ExportPurpose.manuscript,
                          child: Text('正文交稿'),
                        ),
                        DropdownMenuItem(
                          value: ExportPurpose.reference,
                          child: Text('設定資料閱讀稿'),
                        ),
                        DropdownMenuItem(
                          value: ExportPurpose.exchange,
                          child: Text('局部專案交換'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _change(() {
                            _purpose = value;
                            _format = value == ExportPurpose.exchange
                                ? ExportFormat.xml
                                : ExportFormat.markdown;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ExportFormat>(
                      key: ValueKey('export-format-${_purpose.name}'),
                      initialValue: _format,
                      decoration: const InputDecoration(labelText: '內容格式'),
                      items: [
                        for (final f in formats)
                          DropdownMenuItem(
                            value: f,
                            enabled: f.available,
                            child: Text(f.label),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) _change(() => _format = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ExportPackaging>(
                      key: const Key('export-packaging'),
                      initialValue: _packaging,
                      decoration: const InputDecoration(labelText: '檔案組織'),
                      items: const [
                        DropdownMenuItem(
                          value: ExportPackaging.singleFile,
                          child: Text('合併為單一文件'),
                        ),
                        DropdownMenuItem(
                          value: ExportPackaging.splitZip,
                          child: Text('分散文件（ZIP）'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) _change(() => _packaging = value);
                      },
                    ),
                    if (_purpose == ExportPurpose.manuscript) ...[
                      CheckboxListTile(
                        title: const Text('包含作品資訊'),
                        value: _bookInfo,
                        onChanged: (v) => _change(() => _bookInfo = v ?? false),
                      ),
                      CheckboxListTile(
                        title: const Text('包含資料夾／文稿標題'),
                        value: _headings,
                        onChanged: (v) => _change(() => _headings = v ?? true),
                      ),
                      if (widget.currentChapterId != null)
                        TextButton(
                          onPressed: () => _change(() {
                            _selected[SelectiveProjectModule.chapters] = {
                              'chapter:${widget.currentChapterId}',
                            };
                            _modules.add(SelectiveProjectModule.chapters);
                          }),
                          child: const Text('僅目前文稿'),
                        ),
                    ],
                    const SizedBox(height: 8),
                    for (final module in SelectiveProjectModule.values)
                      if (_purpose != ExportPurpose.manuscript ||
                          module == SelectiveProjectModule.chapters)
                        _moduleSelector(module),
                  ],
                  if (output != null) ...[
                    const Divider(),
                    Text(
                      '預覽：${output.documents.length} 份文件 · ${output.bytes.length} bytes · .${output.extension}',
                      key: const Key('export-preview-summary'),
                    ),
                    for (final warning in output.warnings)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(warning),
                      ),
                    if (output.extension == 'zip')
                      ExportFileTree(
                        documents: output.documents,
                        onSelected: (index) =>
                            setState(() => _previewIndex = index),
                      ),
                    if (output.documents.length > 1)
                      DropdownButton<int>(
                        isExpanded: true,
                        value: _previewIndex,
                        items: [
                          for (var i = 0; i < output.documents.length; i++)
                            DropdownMenuItem(
                              value: i,
                              child: Text(
                                output.documents[i].path,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: (index) {
                          if (index != null) {
                            setState(() => _previewIndex = index);
                          }
                        },
                      ),
                    Text(
                      output.documents[_previewIndex].logicalPath.join(' / '),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 240,
                      child: SingleChildScrollView(
                        child: SelectableText(
                          output.documents[_previewIndex].preview,
                          key: const Key('export-preview-text'),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _busy ? null : () => Navigator.of(context).pop(),
              child: const Text('關閉'),
            ),
            OutlinedButton(
              key: const Key('export-prepare'),
              onPressed: _busy
                  ? null
                  : output == null
                  ? _prepareOutput
                  : () => _change(() {}),
              child: Text(output == null ? '產生預覽' : '返回選項'),
            ),
            FilledButton(
              key: const Key('export-save'),
              onPressed: _busy || output == null ? null : _save,
              child: const Text('匯出檔案'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _moduleSelector(SelectiveProjectModule module) {
    final roots = _trees[module];
    final all = {
      for (final root in roots ?? <ExportSelectionNode>[])
        ...root.selectableKeys,
    };
    final active =
        _purpose == ExportPurpose.manuscript || _modules.contains(module);
    final selected = _selected[module] ?? <String>{};
    final bool? checked = !active
        ? false
        : selected.length == all.length
        ? true
        : selected.isEmpty
        ? false
        : null;
    return ExpansionTile(
      key: ValueKey('export-module-${module.id}'),
      maintainState: true,
      initiallyExpanded: module == SelectiveProjectModule.chapters,
      title: Text(module.label),
      leading: Checkbox(
        key: ValueKey('export-module-check-${module.id}'),
        tristate: true,
        value: checked,
        onChanged: _purpose == ExportPurpose.manuscript
            ? null
            : (_) => _change(() {
                if (checked == true) {
                  _modules.remove(module);
                  if (roots != null) _selected[module] = {};
                } else {
                  _modules.add(module);
                  if (roots != null) _selected[module] = all;
                }
              }),
      ),
      children: roots == null
          ? [
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('此模組以完整內容匯出。'),
              ),
            ]
          : [
              ExportSelectionTree(
                key: ValueKey('export-tree-${module.id}'),
                roots: roots,
                selected: selected,
                onChanged: (value) => _change(() {
                  _selected[module] = value;
                  if (value.isEmpty) {
                    _modules.remove(module);
                  } else {
                    _modules.add(module);
                  }
                }),
              ),
            ],
    );
  }
}
