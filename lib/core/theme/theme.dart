
import 'package:flutter/material.dart';

class ExoTheme {
  static const blue = Color(0xFF0D74D6);
  static ThemeData dark() {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0F1216),
      colorScheme: base.colorScheme.copyWith(primary: blue, secondary: blue),
      textTheme: base.textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0F1216)),
      cardTheme: CardThemeData(
        color: const Color(0xFF151A20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      dividerColor: Colors.white12,
    );
  }
}
