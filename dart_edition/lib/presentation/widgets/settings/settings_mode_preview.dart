import 'package:flutter/material.dart';

import '../../../bin/ui_library.dart' show AppThemeMode;
import '../../../models/navigation_style.dart';
import '../../../models/toolbar_mode.dart';

/// Code-drawn previews stay sharp at every scale and follow the accent color.
class SettingsModePreview extends StatelessWidget {
  const SettingsModePreview({
    super.key,
    required this.accent,
    this.themeMode,
    this.navigationStyle,
    this.toolbarMode,
  });

  final Color accent;
  final AppThemeMode? themeMode;
  final NavigationStyle? navigationStyle;
  // Null with no theme/navigation choice represents automatic toolbar mode.
  final ToolbarMode? toolbarMode;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _ModePreviewPainter(
      accent: accent,
      themeMode: themeMode,
      navigationStyle: navigationStyle,
      toolbarMode: toolbarMode,
      dark: Theme.of(context).brightness == Brightness.dark,
    ),
  );
}

class _ModePreviewPainter extends CustomPainter {
  const _ModePreviewPainter({
    required this.accent,
    required this.themeMode,
    required this.navigationStyle,
    required this.toolbarMode,
    required this.dark,
  });

  final Color accent;
  final AppThemeMode? themeMode;
  final NavigationStyle? navigationStyle;
  final ToolbarMode? toolbarMode;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 156, size.height / 100);
    final automaticTheme = themeMode == AppThemeMode.system;
    final automaticToolbar =
        themeMode == null && navigationStyle == null && toolbarMode == null;
    if (automaticTheme || automaticToolbar) {
      for (final right in [false, true]) {
        canvas.save();
        canvas.clipRect(Rect.fromLTWH(right ? 78 : 0, 0, 78, 100));
        _paintScene(
          canvas,
          isDark: automaticTheme ? right : dark,
          toolbar: automaticToolbar
              ? (right ? ToolbarMode.moderate : ToolbarMode.full)
              : ToolbarMode.full,
        );
        canvas.restore();
      }
      canvas.drawLine(
        const Offset(78, 0),
        const Offset(78, 100),
        Paint()
          ..color = Colors.white.withValues(alpha: .65)
          ..strokeWidth = 1,
      );
    } else {
      _paintScene(
        canvas,
        isDark: themeMode == null ? dark : themeMode == AppThemeMode.dark,
        toolbar: toolbarMode ?? ToolbarMode.full,
      );
    }
    canvas.restore();
  }

  void _paintScene(
    Canvas canvas, {
    required bool isDark,
    required ToolbarMode toolbar,
  }) {
    final surface = isDark ? const Color(0xff202838) : const Color(0xfff8faff);
    final raised = isDark ? const Color(0xff303c50) : const Color(0xffe3eaf5);
    final line = isDark ? const Color(0xff71839c) : const Color(0xffa4b4cb);
    final ink = isDark ? const Color(0xffc0cede) : const Color(0xff72859e);
    void box(
      double x,
      double y,
      double w,
      double h,
      Color color, [
      double radius = 2,
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, w, h),
          Radius.circular(radius),
        ),
        Paint()..color = color,
      );
    }

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 156, 100),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(accent, const Color(0xff182e69), .4)!,
            accent,
            const Color(0xff6dd9c8),
          ],
        ).createShader(const Rect.fromLTWH(0, 0, 156, 100)),
    );
    final sweep = Path()
      ..moveTo(0, 86)
      ..cubicTo(36, 28, 65, 90, 156, 14)
      ..lineTo(156, 48)
      ..cubicTo(70, 110, 60, 38, 0, 100)
      ..close();
    canvas.drawPath(
      sweep,
      Paint()..color = Colors.white.withValues(alpha: .15),
    );
    box(9, 9, 138, 84, Colors.black.withValues(alpha: .15), 6);
    box(8, 7, 138, 84, surface, 5);
    box(8, 7, 138, 12, raised, 5);
    box(8, 14, 138, 5, raised, 0);
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(15 + i * 6, 13),
        1.5,
        Paint()
          ..color = [
            const Color(0xfff27c77),
            const Color(0xfff0c66a),
            const Color(0xff6cbd9d),
          ][i],
      );
    }
    box(42, 12, 30, 3, line);
    for (var i = 0; i < 3; i++) {
      box(14 + i * 25, 23, 19, 3, i == 0 ? accent : line);
    }
    final full = toolbar == ToolbarMode.full;
    final ribbonBottom = full ? 49.0 : 39.0;
    box(9, 29, 136, ribbonBottom - 29, raised, 0);
    if (full) {
      box(14, 33, 10, 12, accent);
      for (var i = 0; i < 4; i++) {
        box(30 + i * 27, 33, 5, 5, i == 2 ? accent : line);
        box(38 + i * 27, 34, 13, 2, ink);
        box(30 + i * 27, 41, 21, 2, line);
      }
    } else {
      for (var i = 0; i < (toolbar == ToolbarMode.concise ? 8 : 4); i++) {
        final x = 14.0 + i * (toolbar == ToolbarMode.concise ? 15 : 32);
        box(x, 32, 5, 4, i == 0 ? accent : line);
        if (toolbar == ToolbarMode.moderate) box(x + 8, 33, 16, 2, ink);
      }
    }
    final nav = navigationStyle ?? NavigationStyle.railLabel;
    final drawer =
        nav == NavigationStyle.railButtonDrawer ||
        nav == NavigationStyle.railHoverDrawer;
    final railWidth = drawer ? 45.0 : 16.0;
    box(9, ribbonBottom + 1, railWidth, 39, raised, 0);
    for (var i = 0; i < 3; i++) {
      final y = ribbonBottom + 6 + i * 11;
      box(12, y, 10, 6, i == 0 ? accent : line, 3);
      if (drawer) box(26, y + 2, 21, 2, ink);
      if (nav == NavigationStyle.railLabel) box(13, y + 8, 8, 1, ink);
    }
    if (nav == NavigationStyle.railTooltip) {
      box(25, ribbonBottom + 5, 26, 9, ink);
      box(29, ribbonBottom + 9, 17, 1, surface);
    }
    if (drawer) {
      // A small edge affordance distinguishes the click and hover variants.
      final p = Offset(49, ribbonBottom + 32);
      if (nav == NavigationStyle.railButtonDrawer) {
        canvas.drawCircle(p, 3, Paint()..color = accent);
        canvas.drawLine(
          p - const Offset(1, 0),
          p + const Offset(1, 0),
          Paint()..color = surface,
        );
      } else {
        final pointer = Path()
          ..moveTo(p.dx, p.dy - 5)
          ..lineTo(p.dx + 6, p.dy + 1)
          ..lineTo(p.dx + 2, p.dy + 2)
          ..lineTo(p.dx + 1, p.dy + 6)
          ..close();
        canvas.drawPath(pointer, Paint()..color = accent);
      }
    }
    final contentX = 9 + railWidth + 7;
    for (var i = 0; i < 5; i++) {
      box(
        contentX,
        ribbonBottom + 7 + i * 6,
        (137 - contentX) * (i == 4 ? .65 : 1),
        2,
        i == 0 ? ink : line,
      );
    }
    box(9, 85, 136, 5, raised, 0);
    box(121, 87, 16, 1, accent);
  }

  @override
  bool shouldRepaint(_ModePreviewPainter oldDelegate) =>
      accent != oldDelegate.accent ||
      themeMode != oldDelegate.themeMode ||
      navigationStyle != oldDelegate.navigationStyle ||
      toolbarMode != oldDelegate.toolbarMode ||
      dark != oldDelegate.dark;
}
