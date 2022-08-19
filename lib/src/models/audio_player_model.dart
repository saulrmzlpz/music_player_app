// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/material.dart';

class AudioplayerModel with ChangeNotifier {
  bool _isPlaying = false;
  AnimationController? _controller;
  Duration _songDuration = const Duration(milliseconds: 0);
  Duration _currentDuration = const Duration(milliseconds: 0);

  String get songTotalDuration => printDuration(_songDuration);

  String get currentSeconds => printDuration(_currentDuration);

  double get percentage => _songDuration.inSeconds > 0 ? _currentDuration.inSeconds / _songDuration.inSeconds : 0;

  bool get isPlaying => _isPlaying;

  set isPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  Duration get songDuration => _songDuration;

  set songDuration(Duration value) {
    _songDuration = value;
    notifyListeners();
  }

  Duration get currentDuration => _currentDuration;

  set currentDuration(Duration value) {
    _currentDuration = value;
    notifyListeners();
  }

  AnimationController? get controller => _controller;

  set controller(AnimationController? ctrl) {
    _controller = ctrl;
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  void reset() {
    _songDuration = Duration(milliseconds: 0);
    _currentDuration = Duration(milliseconds: 0);
    _isPlaying = false;
    notifyListeners();
  }
}
