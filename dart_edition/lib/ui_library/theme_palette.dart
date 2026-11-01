import "package:flutter/material.dart";

/// Stable names are persisted independently of the user's custom accent color.
enum AppThemePreset {
  standard("一般配色"),
  highContrast("高對比"),
  rainbow("Show Your Pride/彩虹旗"),
  lesbian("Show Your Pride/女同志"),
  bisexual("Show Your Pride/雙性戀"),
  transgender("Show Your Pride/跨性別");

  const AppThemePreset(this.label);
  final String label;

  bool get isPride => flagColors.isNotEmpty;

  List<Color> get flagColors => switch (this) {
    rainbow => const [
      Color(0xFFE40303),
      Color(0xFFFF8C00),
      Color(0xFFFFED00),
      Color(0xFF008026),
      Color(0xFF004DFF),
      Color(0xFF750787),
    ],
    lesbian => const [
      Color(0xFFD52D00),
      Color(0xFFFF9A56),
      Colors.white,
      Color(0xFFD362A4),
      Color(0xFFA30262),
    ],
    bisexual => const [Color(0xFFD60270), Color(0xFF9B4F96), Color(0xFF0038A8)],
    transgender => const [
      Color(0xFF5BCEFA),
      Color(0xFFF5A9B8),
      Colors.white,
      Color(0xFFF5A9B8),
      Color(0xFF5BCEFA),
    ],
    _ => const [],
  };

  List<int> get flagWeights =>
      this == bisexual ? const [2, 1, 2] : List.filled(flagColors.length, 1);

  Color accent(Color fallback) => switch (this) {
    standard => fallback,
    highContrast => Colors.black,
    rainbow => const Color(0xFF008026),
    lesbian => const Color(0xFFA30262),
    bisexual => const Color(0xFFD60270),
    transgender => const Color(0xFF5BCEFA),
  };
}

abstract final class AppThemePalette {
  static ColorScheme scheme(
    Color seed,
    Brightness brightness,
    AppThemePreset preset,
  ) {
    if (preset.isPride) return _prideScheme(preset, brightness);
    final highContrast = preset == AppThemePreset.highContrast;
    final neutral =
        highContrast ||
        (preset == AppThemePreset.standard &&
            seed.toARGB32() == Colors.grey.toARGB32());
    final base = ColorScheme.fromSeed(
      seedColor: preset.accent(seed),
      brightness: brightness,
      dynamicSchemeVariant: neutral
          ? DynamicSchemeVariant.monochrome
          : DynamicSchemeVariant.tonalSpot,
      contrastLevel: highContrast ? 1 : 0,
    );
    if (highContrast) {
      final dark = brightness == Brightness.dark;
      final foreground = dark ? Colors.white : Colors.black;
      final background = dark ? Colors.black : Colors.white;
      return base.copyWith(
        surface: background,
        onSurface: foreground,
        onSurfaceVariant: foreground,
        outline: foreground,
        outlineVariant: foreground,
        surfaceTint: Colors.transparent,
      );
    }
    return base;
  }

  static ColorScheme _prideScheme(
    AppThemePreset preset,
    Brightness brightness,
  ) {
    if (preset == AppThemePreset.rainbow) return _rainbowScheme(brightness);
    // Keep flag colors in semantic pairs, and balance the entire surface ladder
    // independently so the first accent does not tint every panel the same hue.
    final (secondarySeed, tertiarySeed, surfaceSeed) = switch (preset) {
      AppThemePreset.lesbian => (
        const Color(0xFFFF9A56),
        const Color(0xFFD362A4),
        const Color(0xFFC69A9D),
      ),
      AppThemePreset.bisexual => (
        const Color(0xFF0038A8),
        const Color(0xFF9B4F96),
        const Color(0xFF9C9ABF),
      ),
      AppThemePreset.transgender => (
        const Color(0xFFF5A9B8),
        Colors.white,
        const Color(0xFFB1CDD2),
      ),
      _ => throw ArgumentError.value(
        preset,
        'preset',
        'Expected a pride theme',
      ),
    };
    ColorScheme tones(Color seed) =>
        ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
    final primary = tones(preset.accent(Colors.green));
    final secondary = tones(secondarySeed);
    final tertiary = tones(tertiarySeed);
    final surfaces = tones(surfaceSeed);
    return surfaces.copyWith(
      primary: primary.primary,
      onPrimary: primary.onPrimary,
      primaryContainer: primary.primaryContainer,
      onPrimaryContainer: primary.onPrimaryContainer,
      primaryFixed: primary.primaryFixed,
      primaryFixedDim: primary.primaryFixedDim,
      onPrimaryFixed: primary.onPrimaryFixed,
      onPrimaryFixedVariant: primary.onPrimaryFixedVariant,
      inversePrimary: primary.inversePrimary,
      surfaceTint: primary.primary,
      secondary: secondary.primary,
      onSecondary: secondary.onPrimary,
      secondaryContainer: secondary.primaryContainer,
      onSecondaryContainer: secondary.onPrimaryContainer,
      secondaryFixed: secondary.primaryFixed,
      secondaryFixedDim: secondary.primaryFixedDim,
      onSecondaryFixed: secondary.onPrimaryFixed,
      onSecondaryFixedVariant: secondary.onPrimaryFixedVariant,
      tertiary: tertiary.primary,
      onTertiary: tertiary.onPrimary,
      tertiaryContainer: tertiary.primaryContainer,
      onTertiaryContainer: tertiary.onPrimaryContainer,
      tertiaryFixed: tertiary.primaryFixed,
      tertiaryFixedDim: tertiary.primaryFixedDim,
      onTertiaryFixed: tertiary.onPrimaryFixed,
      onTertiaryFixedVariant: tertiary.onPrimaryFixedVariant,
    );
  }

  static ColorScheme _rainbowScheme(Brightness brightness) {
    // Green actions and yellow selections with orange foregrounds lead the
    // palette. Blue-violet adds a cool counterpoint; warm red marks errors. Every surface
    // role is defined so panels stay ivory/olive instead of inheriting pink.
    if (brightness == Brightness.light) {
      return const ColorScheme.light(
        primary: Color(0xFF236238),
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFC8EBC0),
        onPrimaryContainer: Color(0xFF123A20),
        primaryFixed: Color(0xFFC8EBC0),
        primaryFixedDim: Color(0xFFA5D89C),
        onPrimaryFixed: Color(0xFF08210F),
        onPrimaryFixedVariant: Color(0xFF285633),
        secondary: Color(0xFF6C5B00),
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFF7E58A),
        onSecondaryContainer: Color(0xFF9B3D00),
        secondaryFixed: Color(0xFFF7E58A),
        secondaryFixedDim: Color(0xFFE5CD66),
        onSecondaryFixed: Color(0xFF211B00),
        onSecondaryFixedVariant: Color(0xFF544600),
        tertiary: Color(0xFF4D5B9C),
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFFDFE3FF),
        onTertiaryContainer: Color(0xFF192452),
        tertiaryFixed: Color(0xFFDFE3FF),
        tertiaryFixedDim: Color(0xFFB6C3FF),
        onTertiaryFixed: Color(0xFF0C1640),
        onTertiaryFixedVariant: Color(0xFF344077),
        error: Color(0xFFB3261E),
        onError: Colors.white,
        errorContainer: Color(0xFFFFDAD4),
        onErrorContainer: Color(0xFF410001),
        surface: Color(0xFFFBFCF3),
        onSurface: Color(0xFF202A1F),
        onSurfaceVariant: Color(0xFF485141),
        surfaceDim: Color(0xFFD7DFCA),
        surfaceBright: Color(0xFFFBFCF3),
        surfaceContainerLowest: Colors.white,
        surfaceContainerLow: Color(0xFFF3F6E8),
        surfaceContainer: Color(0xFFEBEFDD),
        surfaceContainerHigh: Color(0xFFE2E9D3),
        surfaceContainerHighest: Color(0xFFD9E1C8),
        outline: Color(0xFF717C68),
        outlineVariant: Color(0xFFC0CAB3),
        inverseSurface: Color(0xFF283126),
        onInverseSurface: Color(0xFFEFF5E8),
        inversePrimary: Color(0xFFA5D89C),
        surfaceTint: Color(0xFF236238),
      );
    }
    return const ColorScheme.dark(
      primary: Color(0xFFA5D89C),
      onPrimary: Color(0xFF103A1D),
      primaryContainer: Color(0xFF285633),
      onPrimaryContainer: Color(0xFFCBEEC3),
      primaryFixed: Color(0xFFC8EBC0),
      primaryFixedDim: Color(0xFFA5D89C),
      onPrimaryFixed: Color(0xFF08210F),
      onPrimaryFixedVariant: Color(0xFF285633),
      secondary: Color(0xFFE5CD66),
      onSecondary: Color(0xFF392F00),
      secondaryContainer: Color(0xFF544600),
      onSecondaryContainer: Color(0xFFFFB873),
      secondaryFixed: Color(0xFFF7E58A),
      secondaryFixedDim: Color(0xFFE5CD66),
      onSecondaryFixed: Color(0xFF211B00),
      onSecondaryFixedVariant: Color(0xFF544600),
      tertiary: Color(0xFFB6C3FF),
      onTertiary: Color(0xFF1B285B),
      tertiaryContainer: Color(0xFF344077),
      onTertiaryContainer: Color(0xFFDFE3FF),
      tertiaryFixed: Color(0xFFDFE3FF),
      tertiaryFixedDim: Color(0xFFB6C3FF),
      onTertiaryFixed: Color(0xFF0C1640),
      onTertiaryFixedVariant: Color(0xFF344077),
      error: Color(0xFFFFB4A8),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD4),
      surface: Color(0xFF11180F),
      onSurface: Color(0xFFE1E9D9),
      onSurfaceVariant: Color(0xFFC0CBB4),
      surfaceDim: Color(0xFF11180F),
      surfaceBright: Color(0xFF374331),
      surfaceContainerLowest: Color(0xFF0B100A),
      surfaceContainerLow: Color(0xFF192115),
      surfaceContainer: Color(0xFF20291B),
      surfaceContainerHigh: Color(0xFF293324),
      surfaceContainerHighest: Color(0xFF343F2E),
      outline: Color(0xFF8A967E),
      outlineVariant: Color(0xFF46533F),
      inverseSurface: Color(0xFFE1E9D9),
      onInverseSurface: Color(0xFF283126),
      inversePrimary: Color(0xFF236238),
      surfaceTint: Color(0xFFA5D89C),
    );
  }
}

/// A decorative flag with hard stripe boundaries and the correct proportions.
class PrideFlag extends StatelessWidget {
  const PrideFlag({super.key, required this.preset, this.axis = Axis.vertical});
  final AppThemePreset preset;
  final Axis axis;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Flex(
      direction: axis,
      children: [
        for (var i = 0; i < preset.flagColors.length; i++)
          Expanded(
            flex: preset.flagWeights[i],
            child: ColoredBox(
              color: preset.flagColors[i],
              child: const SizedBox.expand(),
            ),
          ),
      ],
    ),
  );
}

/// Decorative edge color that fades inward without tinting or blocking content.
class PrideEdgeGlow extends StatelessWidget {
  const PrideEdgeGlow({
    super.key,
    required this.preset,
    this.fromBottom = false,
    this.saturation = 1,
    this.opacity = 1,
  }) : assert(saturation >= 0 && saturation <= 1),
       assert(opacity >= 0 && opacity <= 1);

  final AppThemePreset preset;
  final bool fromBottom;
  final double saturation;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final colors = preset.flagColors.map((color) {
      final hsl = HSLColor.fromColor(color);
      return hsl.withSaturation(hsl.saturation * saturation).toColor();
    }).toList();
    if (colors.isEmpty) return const SizedBox.shrink();
    final weights = preset.flagWeights;
    final totalWeight = weights.fold<int>(0, (sum, weight) => sum + weight);
    var offset = 0;
    final stops = <double>[];
    for (final weight in weights) {
      stops.add((offset + weight / 2) / totalWeight);
      offset += weight;
    }
    return IgnorePointer(
      child: ExcludeSemantics(
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: fromBottom ? Alignment.bottomCenter : Alignment.topCenter,
            end: fromBottom ? Alignment.topCenter : Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: opacity),
              Colors.white.withValues(alpha: 0),
            ],
          ).createShader(bounds),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: colors,
                stops: stops,
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
