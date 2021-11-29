/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:app_settings.dart
 * 创建时间:2021/11/15 下午1:43
 * 作者:小草
 */

import 'dart:convert';

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/theme/app_theme.dart';
import 'package:pixiv_func_android/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService extends GetxService {
  late final SharedPreferences _sharedPreferences;
  late final Settings settings;

  Future<AppSettingsService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    final settingsJsonString = _sharedPreferences.getString('settings');
    if (null != settingsJsonString) {
      settings = Settings.fromJson(jsonDecode(settingsJsonString));
    } else {
      settings = Settings.defaultValue();
    }

    Get.changeTheme(settings.isLightTheme ? AppTheme.lightTheme : AppTheme.darkTheme);

    return this;
  }

  bool get guideInit => _sharedPreferences.getBool('guide_init') ?? false;

  set guideInit(bool value) => _sharedPreferences.setBool('guide_init', value);

  bool get enableProxy => settings.enableProxy;

  set enableProxy(bool value) {
    settings.enableProxy = value;
    _update();
  }

  String get httpProxyUrl => settings.httpProxyUrl;

  set httpProxyUrl(String value) {
    settings.httpProxyUrl = value;
    _update();
  }

  bool get isLightTheme => settings.isLightTheme;

  set isLightTheme(bool value) {
    settings.isLightTheme = value;
    _update();
  }

  String get imageSource => settings.imageSource;

  set imageSource(String value) {
    settings.imageSource = value;
    _update();
  }

  bool get previewQuality => settings.previewQuality;

  set previewQuality(bool value) {
    settings.previewQuality = value;
    _update();
  }

  bool get scaleQuality => settings.scaleQuality;

  set scaleQuality(bool value) {
    settings.scaleQuality = value;
    _update();
  }

  bool get enableBrowsingHistory => settings.enableBrowsingHistory;

  set enableBrowsingHistory(bool value) {
    settings.enableBrowsingHistory = value;
    _update();
  }

  void _update() {
    _sharedPreferences.setString('settings', jsonEncode(settings));
  }
}
