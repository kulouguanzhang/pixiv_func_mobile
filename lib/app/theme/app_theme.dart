import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark().copyWith(
    indicatorColor: const Color(0xffea638c),
    toggleableActiveColor: const Color(0xffea638c),
    colorScheme: const ColorScheme(
      primary: Color(0xffea638c),
      secondary: Color(0xffde4f78),
      background: Color(0xff121212),
      surface: Color(0xff121212),
      error: Colors.red,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
  );

  static final lightTheme = ThemeData.light().copyWith(
    indicatorColor: const Color(0xffea638c),
    toggleableActiveColor: const Color(0xffea638c),
    colorScheme: const ColorScheme(
      primary: Color(0xffea638c),
      secondary: Color(0xffde4f78),
      background: Colors.white,
      surface: Colors.white,
      error: Color(0xFFB00020),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
  );
}
