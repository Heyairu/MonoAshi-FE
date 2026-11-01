import 'package:flutter/material.dart';
import '../../../application/project_export/export_models.dart';

class ExportSelectionTree extends StatefulWidget {
  final List<ExportSelectionNode> roots;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  const ExportSelectionTree({
    super.key,
    required this.roots,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<ExportSelectionTree> createState() => _ExportSelectionTreeState();
}

class _ExportSelectionTreeState extends State<ExportSelectionTree> {
  final _expanded = <String>{};
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final all = {for (final root in widget.roots) ...root.selectableKeys};
    final rows = <(ExportSelectionNode, int, List<String>)>[];
    bool matches(ExportSelectionNode node) =>
        node.label.toLowerCase().contains(_query) || node.children.any(matches);
    void add(ExportSelectionNode node, int depth, List<String> parents) {
      if (_query.isNotEmpty && !matches(node)) return;
      rows.add((node, depth, parents));
      if (_query.isNotEmpty || _expanded.contains(node.key)) {
        for (final child in node.children) {
          add(child, depth + 1, [...parents, node.label]);
        }
      }
    }

    for (final root in widget.roots) {
      add(root, 0, []);
    }
    void expandAll() {
      final stack = [...widget.roots];
      while (stack.isNotEmpty) {
        final n = stack.removeLast();
        _expanded.add(n.key);
        stack.addAll(n.children);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key('export-tree-search'),
          decoration: const InputDecoration(
            labelText: '搜尋名稱（保留原選取）',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) =>
              setState(() => _query = value.trim().toLowerCase()),
        ),
        Wrap(
          spacing: 4,
          children: [
            TextButton(
              onPressed: () => widget.onChanged(all),
              child: const Text('全選清單'),
            ),
            TextButton(
              onPressed: () => widget.onChanged({}),
              child: const Text('清除清單'),
            ),
            TextButton(
              onPressed: () => setState(expandAll),
              child: const Text('全部展開'),
            ),
            TextButton(
              onPressed: () => setState(_expanded.clear),
              child: const Text('全部收合'),
            ),
          ],
        ),
        Text('已選 ${widget.selected.length}／${all.length} 項'),
        SizedBox(
          height: 280,
          child: rows.isEmpty
              ? const Center(child: Text('沒有符合的項目'))
              : ListView.builder(
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    final (node, depth, parents) = rows[index];
                    final keys = node.selectableKeys.toSet();
                    final count = keys.where(widget.selected.contains).length;
                    final bool? checked = count == 0
                        ? false
                        : count == keys.length
                        ? true
                        : null;
                    return Padding(
                      padding: EdgeInsets.only(left: depth.clamp(0, 5) * 12.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 36,
                            child:
                                (node.children.isEmpty && node.summary == null)
                                ? null
                                : IconButton(
                                    tooltip: _expanded.contains(node.key)
                                        ? '收合 ${node.label}'
                                        : '展開 ${node.label}',
                                    icon: Icon(
                                      _expanded.contains(node.key)
                                          ? Icons.expand_more
                                          : Icons.chevron_right,
                                    ),
                                    onPressed: () => setState(() {
                                      if (!_expanded.remove(node.key)) {
                                        _expanded.add(node.key);
                                      }
                                    }),
                                  ),
                          ),
                          Checkbox(
                            key: ValueKey('export-check-${node.key}'),
                            tristate: true,
                            value: checked,
                            onChanged: keys.isEmpty
                                ? null
                                : (_) {
                                    final next = {...widget.selected};
                                    if (checked == true) {
                                      next.removeAll(keys);
                                    } else {
                                      next.addAll(keys);
                                    }
                                    widget.onChanged(next);
                                  },
                            semanticLabel:
                                '${node.label}，${node.kind}，已選 $count／${keys.length}',
                          ),
                          Expanded(
                            child: Tooltip(
                              message: [...parents, node.label].join(' / '),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      node.label,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${node.kind}${node.children.isEmpty ? '' : ' · $count／${keys.length}'}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    if (node.summary != null &&
                                        _expanded.contains(node.key))
                                      Text(
                                        node.summary!,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (node.selectable &&
                              node.children.isNotEmpty &&
                              node.kind != '資料夾')
                            IconButton(
                              tooltip: '僅此項：${node.label}',
                              icon: const Icon(Icons.check_box_outlined),
                              onPressed: () {
                                widget.onChanged(
                                  {...widget.selected}
                                    ..removeAll(keys)
                                    ..add(node.key),
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
