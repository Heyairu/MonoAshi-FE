import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FakeIntroController extends VideoPlayerController {
  FakeIntroController({this.failInitialization = false, this.initialization})
    : super.asset('fake-intro.mp4');

  final bool failInitialization;
  final Completer<void>? initialization;
  bool disposed = false;
  int playCount = 0;

  @override
  Future<void> initialize() async {
    if (failInitialization) {
      throw UnsupportedError('No native video in this test');
    }
    if (initialization != null) await initialization!.future;
    value = const VideoPlayerValue(
      duration: Duration(seconds: 3),
      size: Size(1920, 1080),
      isInitialized: true,
    );
  }

  @override
  Future<void> setLooping(bool looping) async =>
      value = value.copyWith(isLooping: looping);

  @override
  Future<void> play() async {
    playCount++;
    value = value.copyWith(isPlaying: true);
  }

  @override
  Future<void> pause() async => value = value.copyWith(isPlaying: false);

  void advance(Duration position) => value = value.copyWith(
    position: position,
    isCompleted: position >= value.duration,
  );

  @override
  Future<void> dispose() async {
    disposed = true;
    await super.dispose();
  }
}
