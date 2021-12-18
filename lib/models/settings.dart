/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:app_settings.dart
 * 创建时间:2021/9/6 下午5:57
 * 作者:小草
 */

import 'dart:convert';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable(explicitToJson: true)
class Settings {
  bool isLightTheme;

  String imageSource;

  //中等 大图
  bool previewQuality;

  //大图 原图
  bool scaleQuality;

  //启用浏览历史记录
  bool enableBrowsingHistory;

  //语言
  String language;

  Settings(
    this.isLightTheme,
    this.imageSource,
    this.previewQuality,
    this.scaleQuality,
    this.enableBrowsingHistory,
    this.language,
  );

  factory Settings.defaultValue() => Settings(
        false,
        '210.140.92.139',
        true,
        true,
        false,
        window.locale.toLanguageTag(),
      );

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
