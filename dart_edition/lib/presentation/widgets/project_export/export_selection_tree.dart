import 'package:monogatari_assistant/l10n/app_localization.dart';
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
          decoration: InputDecoration(
            labelText: context.l10n.uiSearchNamesKeepSelection,
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
              child: Text(context.l10n.uiSelectEntireList),
            ),
            TextButton(
              onPressed: () => widget.onChanged({}),
              child: Text(context.l10n.uiClearListSelection),
            ),
            TextButton(
              onPressed: () => setState(expandAll),
              child: Text(context.l10n.uiExpandAll),
            ),
            TextButton(
              onPressed: () => setState(_expanded.clear),
              child: Text(context.l10n.uiCollapseAll),
            ),
          ],
        ),
        Text(
          context.l10n.uiSelectedOf(
            context.formats.integer(widget.selected.length),
            context.formats.integer(all.length),
          ),
        ),
        SizedBox(
          height: 280,
          child: rows.isEmpty
              ? Center(child: Text(context.l10n.uiNoMatchingEntries))
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
                                        ? context.l10n.uiCollapse3(
                                            (node.label).toString(),
                                          )
                                        : context.l10n.uiExpand2(
                                            (node.label).toString(),
                                          ),
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
                            semanticLabel: context.l10n.uiSelectedOf2(
                              (node.label).toString(),
                              context.l10n.legacyLabel(node.kind),
                              (count).toString(),
                              context.formats.integer(keys.length),
                            ),
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
                                      '${context.l10n.legacyLabel(node.kind)}${node.children.isEmpty ? '' : ' · $count／${keys.length}'}',
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
                              tooltip: context.l10n.uiOnlyThisItem(
                                (node.label).toString(),
                              ),
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
