import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

final oobeIntroControllerFactoryProvider =
    Provider<VideoPlayerController Function()>(
      (ref) =>
          () => VideoPlayerController.asset(OobeIntro.assetPath),
    );

/// Keeps the video and its white letterbox in one fading layer over setup.
class OobeIntro extends StatefulWidget {
  const OobeIntro({
    super.key,
    required this.child,
    required this.createController,
  });

  static const assetPath = 'assets/videos/oobe_intro.mp4';
  static const fadeDuration = Duration(milliseconds: 450);
  static const initializationTimeout = Duration(seconds: 8);

  final Widget child;
  final VideoPlayerController Function() createController;

  @override
  State<OobeIntro> createState() => _OobeIntroState();
}

class _OobeIntroState extends State<OobeIntro>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final VideoPlayerController _player;
  late final AnimationController _fadeController;
  late final Animation<double> _opacity;
  bool _finished = false;
  bool _released = false;
  bool _resumePlayback = false;

  @override
  void initState() {
    super.initState();
    _fadeController =
        AnimationController(vsync: this, duration: OobeIntro.fadeDuration)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) _finish();
          });
    _opacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOutCubic),
    );
    _player = widget.createController()..addListener(_onPlaybackChanged);
    WidgetsBinding.instance.addObserver(this);
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    try {
      await _player.initialize().timeout(OobeIntro.initializationTimeout);
      if (!mounted || _finished) return;
      if (!_player.value.isInitialized ||
          _player.value.duration <= Duration.zero) {
        _finish();
        return;
      }
      await _player.setLooping(false);
      if (!mounted || _finished) return;
      await _player.play();
    } catch (_) {
      // Playback must never prevent the user from reaching first-run setup.
      _finish();
    }
  }

  void _onPlaybackChanged() {
    if (!mounted || _finished) return;
    final value = _player.value;
    if (value.hasError) {
      _finish();
      return;
    }
    if (value.isInitialized) {
      final remaining = value.duration - value.position;
      if (remaining <= OobeIntro.fadeDuration &&
          !_fadeController.isAnimating &&
          (value.isPlaying || value.isCompleted)) {
        _startFade(
          remaining > Duration.zero ? remaining : OobeIntro.fadeDuration,
        );
      }
    }
    setState(() {});
  }

  void _startFade(Duration remaining) {
    final remainingFraction = 1 - _fadeController.value;
    if (remainingFraction <= 0) {
      _finish();
      return;
    }
    _fadeController.duration = Duration(
      microseconds: (remaining.inMicroseconds / remainingFraction).round(),
    );
    unawaited(_fadeController.forward());
  }

  void _finish() {
    if (!mounted || _finished) return;
    setState(() => _finished = true);
    _fadeController.stop();
    _releasePlayer();
  }

  void _releasePlayer() {
    if (_released) return;
    _released = true;
    _player.removeListener(_onPlaybackChanged);
    unawaited(_player.dispose().catchError((Object _) {}));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_finished || !_player.value.isInitialized) return;
    if (state == AppLifecycleState.resumed) {
      if (_resumePlayback) {
        _resumePlayback = false;
        unawaited(_player.play().catchError((Object _) => _finish()));
      }
    } else {
      _resumePlayback = _resumePlayback || _player.value.isPlaying;
      _fadeController.stop();
      unawaited(_player.pause().catchError((Object _) => _finish()));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _releasePlayer();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      ExcludeFocus(
        excluding: !_finished,
        child: ExcludeSemantics(excluding: !_finished, child: widget.child),
      ),
      if (!_finished)
        Positioned.fill(
          child: AbsorbPointer(
            child: FadeTransition(
              key: const Key('oobe-intro-fade'),
              opacity: _opacity,
              child: ColoredBox(
                key: const Key('oobe-intro-white-fill'),
                color: Colors.white,
                child: Center(
                  child: _player.value.isInitialized
                      ? AspectRatio(
                          key: const Key('oobe-intro-video-area'),
                          aspectRatio: _player.value.aspectRatio,
                          child: VideoPlayer(_player),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
    ],
  );
}
