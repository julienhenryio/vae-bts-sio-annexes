import 'package:flutter/material.dart';

class DeeplyDraftTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: const Color(0xffF2F5DA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF2F5DA),
    ),
    cardColor: Colors.white,
    colorScheme: const ColorScheme(
      primary: Color(0xFF163648),
      secondary: Color(0xFFFFFFFF),
      surface: Colors.white,
      background: Color(0xffF2F5DA),
      error: Color(0xFFB00020),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Color(0xFF163648),
      onError: Colors.white,
      brightness: Brightness.light,
    ),
  );

  static ThemeData dark = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
    ),
    cardColor: const Color(0xFF1E1E1E),
    colorScheme: const ColorScheme(
      primary: Color(0xFF163648),
      secondary: Color(0xFFFFFFFF),
      surface: Color.fromARGB(255, 255, 255, 255),
      background: Color(0xFF1E1E1E),
      error: Color(0xFFCF6679),
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
  );
}
