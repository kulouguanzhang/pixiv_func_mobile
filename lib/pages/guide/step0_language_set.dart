/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:step0_language_set.dart
 * 创建时间:2021/11/15 下午11:04
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/pages/guide/step1_theme_set.dart';

class LanguageSetPage extends StatelessWidget {
  const LanguageSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final AppSettingsService appInfo = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('语言设置'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(child: Text('目前仅支持简体中文', style: TextStyle(fontSize: 25))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_outlined),
        tooltip: '下一步',
        onPressed: () => Get.to(const ThemeSetPage()),
        backgroundColor: Get.theme.colorScheme.onBackground,
      ),
    );
  }
}
