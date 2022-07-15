import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark().copyWith(
    // indicatorColor: const Color(0xFFFF6289),
    // toggleableActiveColor: const Color(0xFFFF6289),
    scaffoldBackgroundColor: const Color(0xFF181818),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff181818),
      selectedItemColor: Color(0xFFFF6289),
      unselectedItemColor: Color(0xFF8C8C8C),
    ),
    cardColor: const Color(0xFF1F1F1F),
    textTheme: const TextTheme(
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xFFD5D5D5),
      ),
      subtitle1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFFD5D5D5),
      ),
      subtitle2: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFFD5D5D5),
      ),
      bodyText1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFFD5D5D5),
      ),
      bodyText2: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFFD5D5D5),
      ),
      caption: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFFD5D5D5),
      ),
      button: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFFD5D5D5),
      ),
      overline: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFFD5D5D5),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff181818),
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFD5D5D5),
    ),
    colorScheme: const ColorScheme(
      primary: Color(0xFFFF6289),
      secondary:  Color(0xFFFF6289),
      background: Color(0xFF181818),
      surface: Color(0xFF252628),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary:  Colors.white,
      onSurface: Color(0xFF606163),
      onBackground: Color(0xFFD5D5D5),
      onError:  Colors.white,
      brightness: Brightness.dark,
    ),
  );

  static final lightTheme = ThemeData.light().copyWith(
    indicatorColor: const Color(0xFFFF6289),
    toggleableActiveColor: const Color(0xFFFF6289),
    colorScheme: const ColorScheme(
      primary: Color(0xFFFF6289),
      secondary: Color(0xFFFF6289),
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
