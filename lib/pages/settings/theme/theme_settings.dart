/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:theme_settings.dart
 * 创建时间:2021/11/24 下午4:37
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/settings/app_settings.dart';
import 'package:pixiv_func_android/app/theme/app_theme.dart';

class ThemeSettingsWidget extends StatelessWidget {
  const ThemeSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<bool?>(
      builder: (bool? snapshot, void Function(bool?) updater) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile(
              title: const Text('黑暗(推荐)'),
              value: false,
              groupValue: snapshot,
              onChanged: (bool? value) {
                updater(value);
              },
            ),
            RadioListTile(
              title: const Text('明亮'),
              value: true,
              groupValue: snapshot,
              onChanged: (bool? value) {
                updater(value);
              },
            ),
          ],
        );
      },
      initialValue: Get.find<AppSettingsService>().isLightTheme,
      onUpdate: (bool? value) {
        if (null != value) {
          Get.find<AppSettingsService>().isLightTheme = value;
          Get.changeTheme(value ? AppTheme.lightTheme : AppTheme.darkTheme);
        }
      },
    );
  }
}
