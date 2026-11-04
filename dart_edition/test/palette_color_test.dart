import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/models/palette_data.dart';

void main() {
  const entry = PaletteEntry(
    id: 'one',
    text: '霧灰',
    createdAt: '2026-11-05T00:00:00Z',
    updatedAt: '2026-11-05T00:00:00Z',
  );
  test('OKLab reference coordinates and neutral distances', () {
    final red = paletteOklab(Colors.red); // Material red is not sRGB pure red.
    expect(red.every((x) => x.isFinite), isTrue);
    final pureRed = paletteOklab(const Color(0xffff0000));
    expect(pureRed[0], closeTo(.627955, .000001));
    expect(pureRed[1], closeTo(.224863, .000001));
    expect(pureRed[2], closeTo(.125846, .000001));
    expect(
      paletteColorDistance(Colors.black, Colors.white),
      closeTo(1, .000001),
    );
    expect(
      paletteColorDistance(const Color(0xff808080), const Color(0xffa0a0a0)),
      closeTo(.10537, .002),
    );
    expect(
      paletteColorDistance(const Color(0xff808080), const Color(0xff888888)),
      lessThan(.05),
    );
    expect(paletteColorDistance(Colors.black, Colors.black), 0);
  });
  test('arbitrary RGB placements survive JSON and YAML and accept v1', () {
    final state = immutablePaletteState(
      slotEntryIds: {
        'rgb-123ABC': ['one'],
        'gray-v050': ['one'],
      },
      entryIndex: {'one': entry},
    );
    final decoded = PaletteDataCodec.decode(PaletteDataCodec.encode(state));
    expect(decoded.data.slotEntryIds, state.slotEntryIds);
    expect(decoded.data.entryIndex['one']!.createdAt, entry.createdAt);
    expect(resolvePaletteSlot('rgb-123ABC')!.color, const Color(0xff123abc));
    final yaml = PaletteYamlCodec.decode(PaletteYamlCodec.encode(state));
    expect(yaml.data.slotEntryIds.keys, contains('rgb-123ABC'));
    expect(yaml.warnings, isEmpty);
    expect(
      PaletteDataCodec.decode(
        '{"version":1,"slotEntryIds":{},"entries":{}}',
      ).warnings,
      isEmpty,
    );
    expect(resolvePaletteSlot('rgb-GGGGGG'), isNull);
  });
  test(
    'multiple placements return one entry using the closest actual color',
    () {
      final state = immutablePaletteState(
        slotEntryIds: {
          'h000-s100-v100': ['one'],
          'rgb-808080': ['one'],
        },
        entryIndex: {'one': entry},
      );
      final hits = paletteColorMatches(state, const Color(0xff808080));
      expect(hits, hasLength(1));
      expect(hits.single.distance, 0);
      expect(hits.single.slot.id, 'rgb-808080');
      expect(paletteColorMatches(state, Colors.white, query: '不存在'), isEmpty);
    },
  );
}
