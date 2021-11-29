/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:step2_proxy_set.dart
 * 创建时间:2021/11/15 下午10:37
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/pages/guide/step3_image_source_set.dart';
import 'package:pixiv_func_android/pages/settings/proxy/proxy_settings.dart';

class ProxySetPage extends StatelessWidget {
  const ProxySetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('代理设置'),
      ),
      body: const ProxySettingsWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_outlined),
        tooltip: '下一步',
        onPressed: () => Get.to(const ImageSourceSetPage()),
        backgroundColor: Get.theme.colorScheme.onBackground,
      ),
    );
  }
}
