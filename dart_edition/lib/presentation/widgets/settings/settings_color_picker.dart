import 'package:monogatari_assistant/l10n/app_localization.dart';
import "package:flutter/material.dart";

import "../../../bin/ui_library.dart" show UILibrary, AppThemePreset, PrideFlag;

/// The same circular color swatches in settings and first-run setup.
class SettingsColorPicker extends StatelessWidget {
  const SettingsColorPicker({
    super.key,
    required this.selectedColor,
    required this.onChanged,
    this.labels = const {},
    this.keyPrefix = "settings-color",
    this.preset = AppThemePreset.standard,
    this.onPresetChanged,
  });

  final Color selectedColor;
  final AppThemePreset preset;
  final ValueChanged<AppThemePreset>? onPresetChanged;
  final ValueChanged<Color> onChanged;
  final Map<String, String> labels;
  final String keyPrefix;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final entry in UILibrary.supportedColors.entries)
              _swatch(context, entry.key, entry.value, colors),
            if (onPresetChanged != null)
              for (final option in AppThemePreset.values.where(
                (value) => value != AppThemePreset.standard,
              ))
                _presetSwatch(context, option, colors),
          ],
        ),
        if (preset.isPride) ...[
          const SizedBox(height: 12),
          Text(
            context.l10n.uiBeyondUsingThisThemeWhatElseCanYou,
            key: const ValueKey("pride-support-caption"),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.uiRespectPeopleSNamesAndPronounsJoinEvents,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ],
    );
  }

  Widget _presetSwatch(
    BuildContext context,
    AppThemePreset option,
    ColorScheme colors,
  ) {
    final selected = preset == option;
    void select() => onPresetChanged!(option);
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: context.l10n.legacyLabel(option.label),
      excludeSemantics: true,
      onTap: select,
      child: Tooltip(
        message: context.l10n.legacyLabel(option.label),
        child: InkWell(
          key: ValueKey("$keyPrefix-preset-${option.name}"),
          onTap: select,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: SizedBox.square(
              dimension: 36,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipOval(
                    child: option.isPride
                        ? PrideFlag(preset: option)
                        : const ColoredBox(
                            color: Colors.black,
                            child: Icon(
                              Icons.contrast,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected
                            ? colors.onSurface
                            : colors.outlineVariant,
                        width: selected ? 2.5 : 1,
                      ),
                    ),
                  ),
                  if (selected)
                    Align(
                      alignment: option.isPride
                          ? Alignment.center
                          : Alignment.bottomRight,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 18),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _swatch(
    BuildContext context,
    String name,
    Color color,
    ColorScheme colors,
  ) {
    final selected =
        preset == AppThemePreset.standard &&
        selectedColor.toARGB32() == color.toARGB32();
    final label =
        labels[name] ??
        context.l10n.legacyLabel(
          const {
                "Auto": "自動",
                "Gray": "灰色",
                "Red": "紅色",
                "Orange": "橙色",
                "Yellow": "黃色",
                "Green": "綠色",
                "Cyan": "青色",
                "Blue": "藍色",
                "Purple": "紫色",
                "Pink": "粉紅色",
              }[name] ??
              name,
        );
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          key: ValueKey("$keyPrefix-$name"),
          onTap: () => onChanged(color),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? colors.onSurface : colors.outlineVariant,
                  width: selected ? 2.5 : 1,
                ),
              ),
              child: selected
                  ? Icon(
                      Icons.check,
                      size: 20,
                      color: color.computeLuminance() > .5
                          ? Colors.black
                          : Colors.white,
                    )
                  : name == "Auto"
                  ? const Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
