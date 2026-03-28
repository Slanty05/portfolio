import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../storage/app_boxes.dart';

const _themeModeKey = 'theme_mode';

final themeModeControllerProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class ThemeModeController extends Notifier<ThemeMode> {
  late final Box<dynamic> _box;

  @override
  ThemeMode build() {
    _box = Hive.box<dynamic>(AppBoxes.settings);
    final raw = _box.get(_themeModeKey);
    return _decodeThemeMode(raw);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _box.put(_themeModeKey, _encodeThemeMode(mode));
  }

  ThemeMode _decodeThemeMode(Object? raw) {
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _encodeThemeMode(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }
}

