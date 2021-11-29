/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:app_settings.dart
 * 创建时间:2021/11/24 下午4:36
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'browsing_history/browsing_history_settings.dart';
import 'image_source/image_source_settings.dart';
import 'preview_quality/preview_quality_settings.dart';
import 'proxy/proxy_settings.dart';
import 'scale_quality/scale_quality_settings.dart';
import 'theme/theme_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void _toSettingsWidget(String title, Widget child) {
    Get.to(
      Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ListTile(
                onTap: () => _toSettingsWidget('主题设置', const ThemeSettingsWidget()),
                title: const Text('主题', style: TextStyle(fontSize: 25)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => _toSettingsWidget('代理设置', const ProxySettingsWidget()),
                title: const Text('代理', style: TextStyle(fontSize: 25)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => _toSettingsWidget('图片源设置', const ImageSourceSettingsWidget()),
                title: const Text('图片源', style: TextStyle(fontSize: 25)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => _toSettingsWidget('图片质量设置', const PreviewQualitySettingsWidget()),
                title: const Text('图片质量', style: TextStyle(fontSize: 25)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => _toSettingsWidget('缩放设置', const ScaleQualitySettingsWidget()),
                title: const Text('缩放质量', style: TextStyle(fontSize: 25)),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => _toSettingsWidget('主题设置', const BrowsingHistorySettingsWidget()),
                title: const Text('历史记录', style: TextStyle(fontSize: 25)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
