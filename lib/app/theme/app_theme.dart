/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:app_theme.dart
 * 创建时间:2021/11/23 下午5:17
 * 作者:小草
 */

import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData.dark().copyWith(
    indicatorColor: const Color(0xffea638c),
    toggleableActiveColor: const Color(0xffea638c),
    colorScheme: const ColorScheme(
      primary: Color(0xffea638c),
      primaryVariant: Color(0xffbc2f58),
      secondary: Color(0xffde4f78),
      secondaryVariant: Color(0xffea638c),
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
      primaryVariant: Color(0xffbc2f58),
      secondary: Color(0xffde4f78),
      secondaryVariant: Color(0xffea638c),
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
