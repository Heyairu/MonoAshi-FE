import "package:flutter/widgets.dart";

/// Shared geometry for mobile floating controls, module pages and manuscript.
abstract final class MobileEditorInsets {
  static const buttonSize = 64.0;
  static const edge = 16.0;
  static const bottomClearance = buttonSize + edge * 2;
}

/// Adds trailing scroll content only to pages inside the mobile module host.
class MobileModuleInsets extends InheritedWidget {
  const MobileModuleInsets({super.key, required super.child});

  static double bottomOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MobileModuleInsets>() == null
      ? 0
      : MobileEditorInsets.bottomClearance;

  static EdgeInsets scrollPaddingOf(
    BuildContext context, [
    EdgeInsets padding = EdgeInsets.zero,
  ]) => padding.copyWith(bottom: padding.bottom + bottomOf(context));

  @override
  bool updateShouldNotify(MobileModuleInsets oldWidget) => false;
}
