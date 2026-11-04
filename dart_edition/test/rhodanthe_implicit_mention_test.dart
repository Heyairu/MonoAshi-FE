import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/ui_library.dart';
import 'package:monogatari_assistant/features/inline_annotations/inline_annotation_projection.dart';
import 'package:monogatari_assistant/features/inline_annotations/inline_annotation_rhodanthe_adapter.dart';
import 'package:monogatari_assistant/infrastructure/rhodanthe/rhodanthe_protocol.dart';
import 'package:monogatari_assistant/infrastructure/rhodanthe/rhodanthe_text_span_adapter.dart';
import 'package:monogatari_assistant/infrastructure/rhodanthe/rhodanthe_theme.dart';

void main() {
  const id = '4e251fc2-1e2b-4f78-93da-91f8c76d9a92';
  RhodantheSpanBuildResult render(
    String source,
    RhodantheTheme theme, {
    Color? baseColor,
  }) {
    final projection = InlineAnnotationProjection.build(source);
    final annotation = const InlineAnnotationRhodantheAdapter()
        .build(projection: projection, documentRevision: 1)
        .single;
    return const RhodantheTextSpanAdapter().build(
      text: projection.displayText,
      currentRevision: 1,
      theme: theme,
      baseStyle: TextStyle(color: baseColor),
      renderPlan: RhodantheVersionedRenderPlan(
        documentId: 'test',
        revision: 1,
        plan: RhodantheRenderPlan(
          contractVersion: rhodantheContractVersion,
          textLenUtf16: projection.displayText.length,
          runs: [
            RhodantheRenderRun(
              range: annotation.range,
              styleTokenSetId: 0,
              annotationIds: [annotation.annotationId],
            ),
          ],
          tokenSets: [annotation.style],
        ),
      ),
    );
  }

  test('implicit mention uses italic and dims the inherited foreground', () {
    const base = Color(0xff123456);
    final result = render(
      '前//@~<$id|（😀艾莉絲）>//後',
      RhodantheTheme.light(),
      baseColor: base,
    );
    expect(result.applied, isTrue);
    final span = result.span.children!.cast<TextSpan>().singleWhere(
      (s) => s.text == '（😀艾莉絲）',
    );
    expect(span.style!.fontStyle, FontStyle.italic);
    expect(span.style!.color, base.withValues(alpha: .6));
    expect(span.semanticsIdentifier, isNotNull);
  });
  test(
    'explicit foreground and high contrast resolve without losing the color',
    () {
      for (final theme in [
        RhodantheTheme.light(),
        RhodantheTheme.dark(),
        RhodantheTheme.highContrast(),
        RhodantheTheme.highContrast(brightness: Brightness.dark),
      ]) {
        final result = render('//@~^CE<$id|（艾莉絲）>//', theme);
        final span = result.span.children!.cast<TextSpan>().singleWhere(
          (s) => s.text == '（艾莉絲）',
        );
        expect(result.applied, isTrue);
        expect(
          span.style!.color,
          theme
              .resolveColor('annotation.yellow.foreground')!
              .withValues(alpha: theme.implicitMentionOpacity),
        );
        expect(
          span.style!.backgroundColor,
          theme.resolveColor('annotation.pink.background'),
        );
        expect(span.style!.fontStyle, FontStyle.italic);
      }
    },
  );
  test('explicit mentions retain their existing tokens', () {
    final projection = InlineAnnotationProjection.build('//@<$id|艾莉絲>//');
    final style = const InlineAnnotationRhodantheAdapter()
        .build(projection: projection, documentRevision: 1)
        .single
        .style;
    expect(style.slant, isNull);
    expect(style.foreground, isNull);
  });
  test('search foreground keeps implicit opacity after arbitration', () {
    final projection = InlineAnnotationProjection.build('//@~<$id|（艾莉絲）>//');
    final annotation = const InlineAnnotationRhodantheAdapter()
        .build(projection: projection, documentRevision: 1)
        .single;
    final theme = RhodantheTheme.light();
    final result = const RhodantheTextSpanAdapter().build(
      text: projection.displayText,
      currentRevision: 1,
      theme: theme,
      renderPlan: RhodantheVersionedRenderPlan(
        documentId: 'test',
        revision: 1,
        plan: RhodantheRenderPlan(
          contractVersion: rhodantheContractVersion,
          textLenUtf16: projection.displayText.length,
          runs: [
            RhodantheRenderRun(
              range: annotation.range,
              styleTokenSetId: 0,
              annotationIds: [annotation.annotationId, 'search:1'],
            ),
          ],
          tokenSets: const [
            RhodantheStyleTokenSet(
              foreground: 'search.current.foreground',
              slant: 'italic',
            ),
          ],
        ),
      ),
    );
    final span = result.span.children!.cast<TextSpan>().singleWhere(
      (s) => s.text == '（艾莉絲）',
    );
    expect(
      span.style!.color,
      theme.resolveColor('search.current.foreground')!.withValues(alpha: .6),
    );
    expect(span.style!.fontStyle, FontStyle.italic);
  });
  test('application high contrast preset disables dimming', () {
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
      final rhodanthe = theme.extension<RhodantheTheme>()!;
      expect(rhodanthe.implicitMentionOpacity, 1);
    }
  });
  testWidgets(
    'system high contrast preserves configured colors and removes dimming',
    (tester) async {
      late RhodantheTheme theme;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [RhodantheTheme.dark()]),
          home: MediaQuery(
            data: const MediaQueryData(highContrast: true),
            child: Builder(
              builder: (context) {
                theme = RhodantheTheme.resolve(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(
        theme
            .resolveColor(
              'annotation.implicit.foreground',
              baseForeground: Colors.red,
            )!
            .a,
        1,
      );
      expect(theme.resolveColor('annotation.implicit.yellow.foreground')!.a, 1);
    },
  );
}
