import 'package:hive_flutter/hive_flutter.dart';

class AppBoxes {
  static const settings = 'settings';

  static Future<void> ensureOpened() async {
    if (!Hive.isBoxOpen(settings)) {
      await Hive.openBox<dynamic>(settings);
    }
  }
}

