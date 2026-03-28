import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../storage/app_boxes.dart';

const _localeKey = 'locale';

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);

class LocaleController extends Notifier<Locale?> {
  late final Box<dynamic> _box;

  @override
  Locale? build() {
    _box = Hive.box<dynamic>(AppBoxes.settings);
    final raw = _box.get(_localeKey);
    return _decode(raw);
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    await _box.put(_localeKey, _encode(locale));
  }

  Locale? _decode(Object? raw) {
    if (raw == null || raw == 'system') return null;
    if (raw is String) {
      // Supports "en" or "en_US"
      final parts = raw.split('_');
      if (parts.length == 1) return Locale(parts[0]);
      return Locale(parts[0], parts[1]);
    }
    return null;
  }

  String _encode(Locale? locale) {
    if (locale == null) return 'system';
    final country = locale.countryCode;
    return country == null || country.isEmpty
        ? locale.languageCode
        : '${locale.languageCode}_$country';
  }
}

