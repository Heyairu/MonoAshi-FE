import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/features/palettes/palette_color_picker.dart';

void main() {
  test('selection circle matches the ring width for every hue and size', () {
    for (final size in [240.0, 320.0, 400.0]) {
      for (final hue in [0.0, 90.0, 198.0, 359.0]) {
        final g = PalettePickerGeometry(size, hue);
        expect(g.selectionRadius * 2, g.ringWidth);
        expect(g.triangleCenter, g.center);
        final pureDirection =
            (g.pure - g.center) / (g.pure - g.center).distance;
        final hueDirection =
            (g.huePoint - g.center) / (g.huePoint - g.center).distance;
        expect((pureDirection - hueDirection).distance, lessThan(1e-9));
        expect(g.onRing(g.huePoint), isTrue);
        expect(g.contains(g.point(HSVColor.fromAHSV(1, hue, .6, .7))), isTrue);
      }
    }
  });
  test('rotated triangle projects pointer to exact HSV weights', () {
    for (final hue in [0.0, 90.0, 198.0, 359.0]) {
      final g = PalettePickerGeometry(320, hue);
      final weights = g.weights(g.pure * .4 + g.black * .3 + g.white * .3);
      expect(weights[0], closeTo(.4, 1e-9));
      expect(weights[1], closeTo(.3, 1e-9));
      expect(weights[2], closeTo(.3, 1e-9));
    }
  });

  testWidgets('triangle selects white and black while retaining the hue', (
    tester,
  ) async {
    var value = const HSVColor.fromAHSV(1, 198, .8, .8);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: StatefulBuilder(
              builder: (context, update) => PaletteColorPicker(
                value: value,
                onChanged: (color) => update(() => value = color),
              ),
            ),
          ),
        ),
      ),
    );
    final wheel = tester.getRect(
      find.byKey(const ValueKey('palette-color-wheel')),
    );
    await tester.tapAt(
      wheel.topLeft +
          PalettePickerGeometry(wheel.width, 198).white * .999 +
          PalettePickerGeometry(wheel.width, 198).center * .001,
    );
    await tester.pump();
    expect(value.hue, 198);
    expect(value.value, closeTo(1, .002));
    expect(value.saturation, closeTo(0, .002));
    await tester.tapAt(
      wheel.topLeft +
          PalettePickerGeometry(wheel.width, 198).black * .999 +
          PalettePickerGeometry(wheel.width, 198).center * .001,
    );
    await tester.pump();
    expect(value.hue, 198);
    expect(value.value, lessThan(.002));
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'wheel drag supports arbitrary hue and SV sliders remain accessible',
    (tester) async {
      var value = const HSVColor.fromAHSV(1, 0, .5, .7);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              child: StatefulBuilder(
                builder: (context, update) => PaletteColorPicker(
                  value: value,
                  onChanged: (color) => update(() => value = color),
                ),
              ),
            ),
          ),
        ),
      );
      final wheel = tester.getRect(
        find.byKey(const ValueKey('palette-color-wheel')),
      );
      final gesture = await tester.startGesture(
        wheel.center + Offset(wheel.width * .43, 0),
      );
      await gesture.moveTo(
        wheel.center + Offset(wheel.width * .3, wheel.height * .3),
      );
      await gesture.up();
      await tester.pump();
      expect(value.hue, closeTo(135, .1));
      expect(value.saturation, .5);
      expect(value.value, .7);
      expect(find.byType(Slider), findsNWidgets(3));
    },
  );
}
