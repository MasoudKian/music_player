import 'package:flutter/material.dart';

class PageManager {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      Duration.zero,
      Duration.zero,
      Duration.zero,
    ),
  );

  final buttonNotifier = ValueNotifier(ButtonState.paused);
}

class ProgressBarState {
  final Duration current;
  final Duration buffrered;
  final Duration total;

  ProgressBarState(this.current, this.buffrered, this.total);
}

enum ButtonState { paused, playing, loading }
