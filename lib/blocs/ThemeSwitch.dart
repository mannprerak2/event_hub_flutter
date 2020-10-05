import 'dart:async';

import 'package:flutter/material.dart';

class ThemeSwitch {
  final _themeSwitchController = StreamController<ThemeMode>.broadcast();
  Function(ThemeMode) get addThemeMode => _themeSwitchController.sink.add;

  Stream<ThemeMode> get themeModeStream => _themeSwitchController.stream;

  dispose() {
    _themeSwitchController.close();
  }
}

final ThemeSwitch themeSwitch = ThemeSwitch();
