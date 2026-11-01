import 'package:flutter/material.dart';

/// Keeps controls mounted so folding a section preserves in-progress edits.
class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
    this.initiallyExpanded = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: colors.outlineVariant.withValues(alpha: .6)),
    );
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: colors.surfaceContainerLow,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: PageStorageKey('settings-section-$id'),
        initiallyExpanded: initiallyExpanded,
        maintainState: true,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        expandedAlignment: Alignment.centerLeft,
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colors.onPrimaryContainer, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        children: [
          const Divider(height: 24),
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 20),
            children[i],
          ],
        ],
      ),
    );
  }
}

class SettingsModeOption {
  const SettingsModeOption({
    required this.id,
    required this.label,
    required this.description,
    required this.preview,
    required this.selected,
    required this.onSelected,
  });

  final String id;
  final String label;
  final String description;
  final Widget preview;
  final bool selected;
  final VoidCallback onSelected;
}

/// Offers wrapping choices or a compact row of equally sized previews.
class SettingsModePicker extends StatelessWidget {
  const SettingsModePicker({
    super.key,
    required this.options,
    this.compactRow = false,
  });

  final List<SettingsModeOption> options;
  final bool compactRow;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final spacing = compactRow ? 6.0 : 10.0;
      final columns = compactRow
          ? options.length
          : ((constraints.maxWidth + spacing) / 110).floor().clamp(
              1,
              options.length,
            );
      final width = ((constraints.maxWidth - spacing * (columns - 1)) / columns)
          .clamp(0.0, compactRow ? 110.0 : 160.0);
      final colors = Theme.of(context).colorScheme;
      final cards = <Widget>[
        for (final option in options)
          SizedBox(
            width: width,
            child: Semantics(
              selected: option.selected,
              inMutuallyExclusiveGroup: true,
              button: true,
              excludeSemantics: true,
              onTap: option.onSelected,
              label: '${option.label}，${option.description}',
              child: Tooltip(
                message: option.description,
                child: Material(
                  color: option.selected
                      ? colors.primaryContainer.withValues(alpha: .4)
                      : colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    key: ValueKey('settings-mode-${option.id}'),
                    onTap: option.onSelected,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: EdgeInsets.all(compactRow ? 3 : 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: option.selected
                                    ? colors.primary
                                    : colors.outlineVariant,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.55,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: ExcludeSemantics(
                                      child: option.preview,
                                    ),
                                  ),
                                ),
                                if (option.selected)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: colors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.check,
                                          size: 12,
                                          color: colors.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: compactRow ? 6 : 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              option.label,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontSize: compactRow ? 12 : null,
                                    color: option.selected
                                        ? colors.primary
                                        : colors.onSurfaceVariant,
                                    fontWeight: option.selected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ];
      if (compactRow) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) SizedBox(width: spacing),
              cards[i],
            ],
          ],
        );
      }
      return Wrap(spacing: spacing, runSpacing: 12, children: cards);
    },
  );
}
