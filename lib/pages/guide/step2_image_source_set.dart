/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:step2_image_source_set.dart
 * 创建时间:2021/11/15 下午10:37
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/login/login.dart';
import 'package:pixiv_func_mobile/pages/settings/image_source/image_source_settings.dart';

class ImageSourceSetPage extends StatelessWidget {
  const ImageSourceSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${I18n.imageSource.tr}${I18n.settings.tr}'),
      ),
      body: const ImageSourceSettingsWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_outlined),
        tooltip: I18n.nextStep.tr,
        onPressed: () => Get.to(const LoginPage()),
        backgroundColor: Get.theme.colorScheme.onBackground,
      ),
    );
  }
}
