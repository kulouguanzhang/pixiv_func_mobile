/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:http.dart
 * 创建时间:2021/11/29 下午10:10
 * 作者:小草
 */

import 'dart:io';

class HttpConfig {
  static void refreshHttpClient() {
    HttpOverrides.global = _MyHttpOverrides();
  }
}

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
