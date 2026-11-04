import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Shared geometry keeps the rotated painting and pointer mapping identical.
class PalettePickerGeometry {
  final double size;
  final double hue;
  const PalettePickerGeometry(this.size, this.hue);
  Offset get center => Offset(size / 2, size / 2);
  Offset get direction =>
      Offset(math.sin(hue * math.pi / 180), -math.cos(hue * math.pi / 180));
  double get ringRadius => size * .41;
  double get ringWidth => 12;
  double get selectionRadius => ringWidth / 2;
  double get outerRadius => ringRadius + ringWidth / 2;
  double get innerRadius => ringRadius - ringWidth / 2;
  Offset get triangleCenter => center;
  double get triangleRadius => innerRadius - size * .02;
  Path get ringPath => Path()
    ..fillType = PathFillType.evenOdd
    ..addOval(Rect.fromCircle(center: center, radius: outerRadius))
    ..addOval(Rect.fromCircle(center: center, radius: innerRadius));
  Offset rotate(Offset p) {
    final d = p - triangleCenter;
    final angle = hue * math.pi / 180;
    return triangleCenter +
        Offset(
          d.dx * math.cos(angle) - d.dy * math.sin(angle),
          d.dx * math.sin(angle) + d.dy * math.cos(angle),
        );
  }

  Offset get pure => triangleCenter + direction * triangleRadius;
  Offset get black =>
      rotate(triangleCenter + Offset(-math.sqrt(3) / 2, .5) * triangleRadius);
  Offset get white =>
      rotate(triangleCenter + Offset(math.sqrt(3) / 2, .5) * triangleRadius);
  Offset get huePoint => center + direction * ringRadius;
  Path get path => Path()
    ..moveTo(pure.dx, pure.dy)
    ..lineTo(black.dx, black.dy)
    ..lineTo(white.dx, white.dy)
    ..close();
  List<double> _raw(Offset p) {
    final a = pure, b = black, c = white;
    final determinant =
        (b.dy - c.dy) * (a.dx - c.dx) + (c.dx - b.dx) * (a.dy - c.dy);
    final x =
        ((b.dy - c.dy) * (p.dx - c.dx) + (c.dx - b.dx) * (p.dy - c.dy)) /
        determinant;
    final y =
        ((c.dy - a.dy) * (p.dx - c.dx) + (a.dx - c.dx) * (p.dy - c.dy)) /
        determinant;
    return [x, y, 1 - x - y];
  }

  bool contains(Offset p) => _raw(p).every((w) => w >= -1e-9);
  bool onRing(Offset p) =>
      (p - center).distance <= outerRadius + 3 &&
      (p - triangleCenter).distance >= innerRadius;
  List<double> weights(Offset p) {
    if (contains(p)) return _raw(p).map((w) => w.clamp(0.0, 1.0)).toList();
    Offset closest = pure;
    double distance = double.infinity;
    for (final edge in [(pure, black), (black, white), (white, pure)]) {
      final d = edge.$2 - edge.$1;
      final t =
          (((p - edge.$1).dx * d.dx + (p - edge.$1).dy * d.dy) /
                  d.distanceSquared)
              .clamp(0.0, 1.0);
      final q = edge.$1 + d * t;
      if ((p - q).distanceSquared < distance) {
        closest = q;
        distance = (p - q).distanceSquared;
      }
    }
    return _raw(closest).map((w) => w.clamp(0.0, 1.0)).toList();
  }

  Offset point(HSVColor color) =>
      pure * (color.saturation * color.value) +
      black * (1 - color.value) +
      white * ((1 - color.saturation) * color.value);
}

/// Continuous HSV selection with a rotating triangle and a fixed-width ring.
class PaletteColorPicker extends StatefulWidget {
  final HSVColor value;
  final ValueChanged<HSVColor> onChanged;
  const PaletteColorPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });
  @override
  State<PaletteColorPicker> createState() => _PaletteColorPickerState();
}

class _PaletteColorPickerState extends State<PaletteColorPicker> {
  bool? _dragRing;
  void _update(Offset point, double size, {bool start = false}) {
    final geometry = PalettePickerGeometry(size, widget.value.hue);
    if (start) {
      _dragRing = geometry.onRing(point)
          ? true
          : geometry.contains(point)
          ? false
          : null;
    }
    if (_dragRing == null) return;
    if (_dragRing!) {
      final delta = point - geometry.center;
      final hue = (math.atan2(delta.dy, delta.dx) * 180 / math.pi + 450) % 360;
      widget.onChanged(widget.value.withHue(hue));
    } else {
      final weights = geometry.weights(point);
      final value = weights[0] + weights[2];
      widget.onChanged(
        widget.value
            .withValue(value.clamp(0, 1))
            .withSaturation(
              value <= 1e-10
                  ? widget.value.saturation
                  : (weights[0] / value).clamp(0, 1),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final size = math.min(constraints.maxWidth, 400.0);
            return Center(
              child: RepaintBoundary(
                child: SizedBox.square(
                  dimension: size,
                  child: GestureDetector(
                    key: const ValueKey('palette-color-wheel'),
                    onPanDown: (d) =>
                        _update(d.localPosition, size, start: true),
                    onPanUpdate: (d) => _update(d.localPosition, size),
                    onPanEnd: (_) => _dragRing = null,
                    onPanCancel: () => _dragRing = null,
                    child: CustomPaint(
                      painter: PaletteColorWheelPainter(
                        widget.value,
                        theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        for (final axis in ['H', 'S', 'V'])
          Row(
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  axis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                width: 52,
                child: Text(
                  '${axis == 'H' ? widget.value.hue.round() % 360 : ((axis == 'S' ? widget.value.saturation : widget.value.value) * 100).round()}${axis == 'H' ? '°' : '%'}',
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(
                child: Slider(
                  key: ValueKey('palette-slider-$axis'),
                  label: axis,
                  semanticFormatterCallback: (v) => '$axis ${v.round()}',
                  min: 0,
                  max: axis == 'H' ? 359.999 : 100,
                  value: axis == 'H'
                      ? widget.value.hue
                      : (axis == 'S'
                                ? widget.value.saturation
                                : widget.value.value) *
                            100,
                  onChanged: (v) => widget.onChanged(
                    axis == 'H'
                        ? widget.value.withHue(v)
                        : axis == 'S'
                        ? widget.value.withSaturation(v / 100)
                        : widget.value.withValue(v / 100),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class PaletteColorWheelPainter extends CustomPainter {
  final HSVColor hsv;
  final Color outline;
  PaletteColorWheelPainter(this.hsv, this.outline);

  void _marker(Canvas canvas, Offset center, double radius, {Color? fill}) {
    if (fill != null) canvas.drawCircle(center, radius, Paint()..color = fill);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: .6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final g = PalettePickerGeometry(size.width, hsv.hue);
    final ringBounds = Rect.fromCircle(center: g.center, radius: g.ringRadius);
    final paint = Paint()..style = PaintingStyle.stroke;
    // Fine instrument ticks, without numeric clutter around the color spectrum.
    for (var degree = 0; degree < 360; degree += 5) {
      final a = (degree - 90) * math.pi / 180;
      final d = Offset(math.cos(a), math.sin(a));
      final outer = g.outerRadius + 3;
      canvas.drawLine(
        g.center + d * outer,
        g.center + d * (outer + (degree % 30 == 0 ? 3 : 2)),
        Paint()
          ..color = outline
          ..strokeWidth = degree % 30 == 0 ? 1.2 : .6,
      );
    }
    canvas.drawPath(
      g.ringPath,
      paint
        ..style = PaintingStyle.fill
        ..shader = const SweepGradient(
          colors: [
            Color(0xffff0000),
            Color(0xffffff00),
            Color(0xff00ff00),
            Color(0xff00ffff),
            Color(0xff0000ff),
            Color(0xffff00ff),
            Color(0xffff0000),
          ],
          transform: GradientRotation(-math.pi / 2),
        ).createShader(ringBounds),
    );
    canvas.drawPath(
      g.ringPath,
      Paint()
        ..color = outline
        ..style = PaintingStyle.stroke
        ..strokeWidth = .6,
    );
    // One interpolated mesh keeps the rotated gradient continuous and avoids
    // antialiasing seams from individually painted scanlines.
    final pure = HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor();
    final vertices = ui.Vertices(
      ui.VertexMode.triangles,
      [g.pure, g.black, g.white],
      colors: [pure, Colors.black, Colors.white],
    );
    canvas.save();
    canvas.clipPath(g.path);
    canvas.drawVertices(vertices, BlendMode.dst, Paint());
    canvas.restore();
    vertices.dispose();
    canvas.drawPath(
      g.path,
      Paint()
        ..color = outline
        ..style = PaintingStyle.stroke
        ..strokeWidth = .8,
    );
    _marker(canvas, g.huePoint, g.selectionRadius, fill: pure);
    _marker(canvas, g.point(hsv), 5, fill: hsv.toColor());
  }

  @override
  bool shouldRepaint(PaletteColorWheelPainter old) =>
      old.hsv != hsv || old.outline != outline;
}
