import "dart:math" as math;
import "dart:ui" as ui;

import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_test/flutter_test.dart";
import "package:material_ribbon/material_ribbon.dart";
import "package:monogatari_assistant/bin/ui_library.dart";
import "package:monogatari_assistant/presentation/widgets/radial_gauge_dashboard.dart";

double contrast(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  return (math.max(a, b) + .05) / (math.min(a, b) + .05);
}

void main() {
  for (final dark in [false, true]) {
    final theme = dark
        ? AppTheme.getDarkTheme(
            14,
            Colors.blue,
            preset: AppThemePreset.highContrast,
          )
        : AppTheme.getLightTheme(
            14,
            Colors.blue,
            preset: AppThemePreset.highContrast,
          );

    for (final compact in [false, true]) {
      testWidgets(
        "high contrast ribbon text and icons remain readable ($dark, $compact)",
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1000, 500));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final selected = RibbonCommandSize.values.toSet();
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              home: Scaffold(
                body: StatefulBuilder(
                  builder: (context, update) => MaterialRibbon(
                    context: const RibbonContext(),
                    compact: compact,
                    tabs: [
                      RibbonTab(
                        id: "home",
                        label: "Home",
                        groups: [
                          RibbonGroup(
                            id: "toggles",
                            label: "Display",
                            commands: [
                              for (final size in RibbonCommandSize.values)
                                RibbonCommand(
                                  id: size.name,
                                  label: size.name,
                                  icon: Icons.navigation_outlined,
                                  size: size,
                                  type: RibbonCommandType.toggle,
                                  checkState: (_) => selected.contains(size)
                                      ? RibbonCheckState.checked
                                      : RibbonCheckState.unchecked,
                                  onInvoke: () => update(() {
                                    if (!selected.remove(size)) {
                                      selected.add(size);
                                    }
                                  }),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          for (final size in RibbonCommandSize.values) {
            final command = find.byTooltip(size.name);
            for (final isSelected in [true, false]) {
              final materials = tester.widgetList<Material>(
                find.descendant(of: command, matching: find.byType(Material)),
              );
              final background = Color.alphaBlend(
                materials.first.color ?? Colors.transparent,
                theme.colorScheme.surface,
              );
              final paragraphs = find.descendant(
                of: command,
                matching: find.byType(RichText),
              );
              expect(paragraphs, findsWidgets);
              for (final element in paragraphs.evaluate()) {
                final paragraph = element.renderObject! as RenderParagraph;
                final style = paragraph.text.style!;
                final foreground = style.foreground?.color ?? style.color!;
                expect(
                  contrast(foreground, background),
                  greaterThanOrEqualTo(7),
                  reason: "${size.name} selected=$isSelected",
                );
                if (isSelected) {
                  expect(foreground, theme.colorScheme.onSecondaryContainer);
                }
              }
              if (isSelected) {
                await tester.tap(command);
                await tester.pumpAndSettle();
              }
            }
          }
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets(
      "high contrast gauge paints distinct progress and track ($dark)",
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: Center(
                child: RepaintBoundary(
                  key: const Key("gauge"),
                  child: ColoredBox(
                    color: theme.colorScheme.surfaceContainerLow,
                    child: CompactRadialGauge(
                      progress: .5,
                      secondaryProgress: .5,
                      currentValue: "+3",
                      targetValue: "−3",
                      color: theme.colorScheme.primary,
                      secondaryColor: theme.colorScheme.tertiary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const Key("gauge")),
        );
        await tester.runAsync(() async {
          final picture = await boundary.toImage();
          final data = await picture.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          );
          Color pixel(int x, int y) {
            final offset = (y * picture.width + x) * 4;
            return Color.fromARGB(
              data!.getUint8(offset + 3),
              data.getUint8(offset),
              data.getUint8(offset + 1),
              data.getUint8(offset + 2),
            );
          }

          final track = pixel(61, 32);
          expect(contrast(pixel(2, 32), track), greaterThanOrEqualTo(3));
          expect(
            contrast(pixel(10, 32), pixel(53, 32)),
            greaterThanOrEqualTo(3),
          );
          expect(
            contrast(track, theme.colorScheme.surfaceContainerLow),
            greaterThanOrEqualTo(3),
          );
          picture.dispose();
        });
        expect(tester.takeException(), isNull);
      },
    );
  }
}
