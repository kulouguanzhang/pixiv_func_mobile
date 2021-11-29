/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:http.dart
 * 创建时间:2021/11/29 下午10:10
 * 作者:小草
 */

import 'dart:io';

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/settings/app_settings.dart';

class HttpConfig{
  static void refreshHttpClient(){
    HttpOverrides.global = _MyHttpOverrides(
      Get.find<AppSettingsService>().enableProxy,
      Get.find<AppSettingsService>().httpProxyUrl,
    );
  }
}

class _MyHttpOverrides extends HttpOverrides {
  final bool enableProxy;
  final String httpProxyUrl;

  _MyHttpOverrides(this.enableProxy, this.httpProxyUrl);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    if (enableProxy) {
      client.findProxy = (Uri? uri) => httpProxyUrl;
    }
    return client;
  }
}
