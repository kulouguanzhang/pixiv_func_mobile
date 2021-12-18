/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:language_settings.dart
 * 创建时间:2021/12/18 下午4:41
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/i18n/i18n.dart';
import 'package:pixiv_func_android/app/settings/app_settings.dart';

class LanguageSettingsWidget extends StatelessWidget {
  final bool isPage;

  const LanguageSettingsWidget({Key? key, this.isPage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widget = ObxValue(
      (Rx<String> data) {
        void _updater(String? value) {
          if (null != value) {
            final list = value.split('-');
            Get.updateLocale(Locale(list.first, list.last));
            data.value = value;
            Get.find<AppSettingsService>().language = value;
          }
        }

        return Column(
          children: [
            RadioListTile(
              title: const Text('简体中文'),
              groupValue: data.value,
              value: 'zh-CN',
              onChanged: _updater,
            ),
            RadioListTile(
              title: const Text('English'),
              groupValue: data.value,
              value: 'en-US',
              onChanged: _updater,
            ),
            RadioListTile(
              title: const Text('日本語'),
              groupValue: data.value,
              value: 'ja-JP',
              onChanged: _updater,
            ),
          ],
        );
      },
      Get.find<AppSettingsService>().language.obs,
    );
    if (isPage) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${I18n.language.tr}${I18n.settings.tr}'),
        ),
        body: widget,
      );
    } else {
      return widget;
    }
  }
}
