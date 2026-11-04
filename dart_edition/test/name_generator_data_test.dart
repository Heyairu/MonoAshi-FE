import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/bin/ui_library.dart';
import 'package:monogatari_assistant/features/name_generator/name_generator_data.dart';
import 'package:monogatari_assistant/modules/WelcomeView.dart';

class _FirstRandom implements Random {
  @override
  bool nextBool() => false;
  @override
  double nextDouble() => 0;
  @override
  int nextInt(int max) => 0;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('homepage offers countries and generates neutral names', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: WelcomeView(recentProjects: [])),
      ),
    );
    final fields = find.byType(AppDropdownField<String>);
    final culture = tester.widget<AppDropdownField<String>>(fields.at(0));
    expect(
      culture.options.map((option) => option.value),
      containsAll(['ZH', 'JP', 'KR', 'UK', 'US', 'CA', 'AU']),
    );
    culture.onChanged!('CA');
    await tester.pump();
    final gender = tester.widget<AppDropdownField<String>>(fields.at(1));
    expect(
      gender.options
          .where((option) => option.value == 'neutral')
          .single
          .enabled,
      isTrue,
    );
    gender.onChanged!('neutral');
    await tester.pump();
    final button = find
        .ancestor(of: find.text('生成'), matching: find.byType(TextButton))
        .first;
    final generate = tester.widget<TextButton>(button).onPressed!;
    await tester.runAsync(() async {
      await (generate as Future<void> Function())();
    });
    await tester.pumpAndSettle();
    final results = tester.widgetList<Text>(
      find.descendant(
        of: find.byType(SelectionArea),
        matching: find.byType(Text),
      ),
    );
    expect(
      results.any(
        (text) => RegExp(
          r'\b(Smith|Brown|Tremblay|Martin|Roy)\b',
        ).hasMatch(text.data ?? ''),
      ),
      isTrue,
    );
  });
  test('loads every culture, locale and gender from bundled tables', () async {
    final generator = NameGeneratorData(random: Random(42));
    for (final locale in ['zh', 'ja', 'en']) {
      for (final culture in ['ZH', 'JP', 'KR', 'UK', 'US', 'CA', 'AU']) {
        for (final gender in ['female', 'male', 'neutral', 'all']) {
          final names = await generator.generate(
            culture: culture,
            gender: gender,
            locale: locale,
            count: 5,
          );
          expect(names, hasLength(5), reason: '$locale $culture $gender');
          final annotated = locale == 'en'
              ? {'ZH', 'JP', 'KR'}.contains(culture)
              : locale == 'ja'
              ? culture != 'JP'
              : culture != 'ZH';
          expect(
            names.every((name) => name.contains('（') == annotated),
            isTrue,
            reason: '$locale $culture $gender',
          );
        }
      }
    }
  });
  test(
    'formats complete names and switches locale without stale data',
    () async {
      final generator = NameGeneratorData(random: _FirstRandom());
      Future<String> one(String culture, String locale) async =>
          (await generator.generate(
            culture: culture,
            gender: 'male',
            locale: locale,
            count: 1,
          )).single;
      expect(await one('KR', 'en'), 'Kim Seongsil（김성실）');
      expect(await one('KR', 'ja'), 'キムソンシル（김성실）');
      expect(await one('JP', 'ja'), '正木誠');
      expect(await one('JP', 'en'), 'Masaki Makoto（正木誠）');
      expect(await one('UK', 'en'), 'Justice Smith');
      expect(await one('UK', 'zh'), '賈斯提斯 史密斯（Justice Smith）');
      expect(await one('UK', 'ja'), 'ジャスティス スミス（Justice Smith）');
    },
  );
}
