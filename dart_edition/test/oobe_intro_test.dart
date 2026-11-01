import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monogatari_assistant/features/oobe/oobe_intro.dart';

import 'helpers/fake_intro_controller.dart';

final _fill = find.byKey(const Key('oobe-intro-white-fill'));
final _fade = find.byKey(const Key('oobe-intro-fade'));
final _video = find.byKey(const Key('oobe-intro-video-area'));

Future<void> mountIntro(
  WidgetTester tester,
  FakeIntroController player, {
  Widget? child,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: OobeIntro(
        createController: () => player,
        child: child ?? const Scaffold(body: Text('OOBE setup')),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('bundled intro has an MP4 header', (tester) async {
    final bytes = await rootBundle.load(OobeIntro.assetPath);
    expect(String.fromCharCodes(bytes.buffer.asUint8List(4, 4)), 'ftyp');
  });

  for (final size in [const Size(1200, 500), const Size(390, 844)]) {
    testWidgets(
      'white fill covers $size while video keeps its original aspect ratio',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final player = FakeIntroController();
        await mountIntro(tester, player);
        expect(tester.getSize(_fill), size);
        expect(tester.widget<ColoredBox>(_fill).color, Colors.white);
        final video = tester.getSize(_video);
        expect(video.width / video.height, closeTo(16 / 9, .001));
        expect(video.width, lessThanOrEqualTo(size.width));
        expect(video.height, lessThanOrEqualTo(size.height));
        expect(find.descendant(of: _fade, matching: _fill), findsOneWidget);
        expect(find.descendant(of: _fade, matching: _video), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
        expect(player.disposed, isTrue);
      },
    );
  }

  testWidgets(
    'video and white fill fade together at the end of actual playback',
    (tester) async {
      final player = FakeIntroController();
      await mountIntro(tester, player);
      expect(player.value.isLooping, isFalse);
      expect(tester.widget<FadeTransition>(_fade).opacity.value, 1);
      player.advance(const Duration(milliseconds: 2550));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 225));
      final opacity = tester.widget<FadeTransition>(_fade).opacity.value;
      expect(opacity, greaterThan(0));
      expect(opacity, lessThan(1));
      await tester.pumpAndSettle();
      expect(_fill, findsNothing);
      expect(find.text('OOBE setup'), findsOneWidget);
      expect(player.disposed, isTrue);
    },
  );

  testWidgets('native initialization failure reveals setup immediately', (
    tester,
  ) async {
    final player = FakeIntroController(failInitialization: true);
    await mountIntro(tester, player);
    expect(_fill, findsNothing);
    expect(find.text('OOBE setup'), findsOneWidget);
    expect(player.disposed, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an initialization timeout cannot trap the user in the intro', (
    tester,
  ) async {
    final player = FakeIntroController(initialization: Completer<void>());
    await mountIntro(tester, player);
    expect(_fill, findsOneWidget);
    await tester.pump(OobeIntro.initializationTimeout);
    await tester.pump();
    expect(_fill, findsNothing);
    expect(player.disposed, isTrue);
  });

  testWidgets('setup cannot receive clicks until the overlay has faded', (
    tester,
  ) async {
    final player = FakeIntroController();
    var clicked = 0;
    await mountIntro(
      tester,
      player,
      child: Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => clicked++,
            child: const Text('Continue setup'),
          ),
        ),
      ),
    );
    final button = find.text('Continue setup');
    await tester.tapAt(tester.getCenter(button));
    expect(clicked, 0);
    player.advance(const Duration(milliseconds: 2550));
    await tester.pumpAndSettle();
    await tester.tap(button);
    expect(clicked, 1);
  });

  testWidgets('backgrounding pauses playback and foregrounding resumes it', (
    tester,
  ) async {
    final player = FakeIntroController();
    await mountIntro(tester, player);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(player.value.isPlaying, isFalse);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(player.value.isPlaying, isTrue);
    expect(player.playCount, 2);
    await tester.pumpWidget(const SizedBox());
  });
}
