import 'package:flutter/material.dart';


class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: const Color(0xFF4F46E5),
      fontFamily: 'Lato',
    );

    return base.copyWith(
      visualDensity: VisualDensity.standard,
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFF4F46E5),
      fontFamily: 'Lato',
    );

    return base.copyWith(
      visualDensity: VisualDensity.standard,
    );
  }
}

