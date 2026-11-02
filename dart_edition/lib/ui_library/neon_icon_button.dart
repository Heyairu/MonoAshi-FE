import 'package:monogatari_assistant/l10n/app_localization.dart';
import "package:flutter/material.dart";

import "control_size.dart";
import "neon_status_icon.dart";
import "neon_ui_theme.dart";

/// Material supplies keyboard activation, focus, ripple and toggle semantics.
class NeonIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool? selected;
  final NeonAccent accent;
  final NeonAccent selectedAccent;
  final NeonStatus status;
  final bool busy;
  final bool destructive;
  final String? statusLabel;
  final double iconSize;

  const NeonIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected,
    this.accent = NeonAccent.neutral,
    this.selectedAccent = NeonAccent.green,
    this.status = NeonStatus.idle,
    this.busy = false,
    this.destructive = false,
    this.statusLabel,
    this.iconSize = AppControlSize.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = NeonUiTheme.resolve(context);
    final media = MediaQuery.maybeOf(context);
    final desktop = switch (theme.platform) {
      TargetPlatform.windows ||
      TargetPlatform.linux ||
      TargetPlatform.macOS => true,
      _ => false,
    };
    final targetSize = desktop ? AppControlSize.height : 48.0;
    final description = [
      label,
      if (selected != null)
        selected! ? context.l10n.uiEnabled : context.l10n.uiDisabled2,
      if (status != NeonStatus.idle || statusLabel != null)
        statusLabel ??
            switch (status) {
              NeonStatus.idle => context.l10n.uiStandby,
              NeonStatus.error => context.l10n.uiError,
              NeonStatus.warning => context.l10n.uiAttentionRequired,
              NeonStatus.notice => context.l10n.uiAwaitingConfirmation,
              NeonStatus.active => context.l10n.uiActive,
              NeonStatus.connected => context.l10n.uiLinked,
              NeonStatus.info => context.l10n.uiInformation2,
              NeonStatus.preview => context.l10n.uiHistoricalPreview,
            },
      if (busy) context.l10n.uiProcessing,
    ].join("，");
    final statusIcon = NeonStatusIcon(
      icon: icon,
      size: iconSize,
      selected: selected == true,
      accent: accent,
      selectedAccent: selectedAccent,
      status: status,
      disabled: onPressed == null,
      busy: busy,
      destructive: destructive,
    );
    return Tooltip(
      message: description,
      child: IconButton(
        onPressed: busy ? null : onPressed,
        isSelected: selected,
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size.square(targetSize)),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(8)),
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          visualDensity: VisualDensity.standard,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          animationDuration: media?.disableAnimations == true
              ? Duration.zero
              : const Duration(milliseconds: 150),
          shape: const WidgetStatePropertyAll(CircleBorder()),
          side: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.focused)
                ? BorderSide(color: colors.color(NeonStatus.idle), width: 2)
                : BorderSide.none,
          ),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.transparent;
            }
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.focused)) {
              return colors.pressed;
            }
            if (states.contains(WidgetState.hovered)) {
              return colors.hover;
            }
            return Colors.transparent;
          }),
        ),
        icon: statusIcon,
        selectedIcon: statusIcon,
      ),
    );
  }
}
