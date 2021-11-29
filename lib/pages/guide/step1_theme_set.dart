/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:step1_theme_set.dart
 * 创建时间:2021/11/15 下午11:05
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/pages/settings/theme/theme_settings.dart';

import 'step2_proxy_set.dart';

class ThemeSetPage extends StatelessWidget {
  const ThemeSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final AppSettingsService appInfo = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('主题设置'),
      ),
      body: const ThemeSettingsWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_outlined),
        tooltip: '下一步',
        onPressed: () => Get.to(const ProxySetPage()),
        backgroundColor: Get.theme.colorScheme.onBackground,
      ),
    );
  }
}
