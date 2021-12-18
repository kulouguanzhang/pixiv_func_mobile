/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:browsing_history_settings.dart
 * 创建时间:2021/11/26 下午5:02
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/i18n/i18n.dart';
import 'package:pixiv_func_android/app/settings/app_settings.dart';

class BrowsingHistorySettingsWidget extends StatelessWidget {
  final bool isPage;

  const BrowsingHistorySettingsWidget({Key? key, this.isPage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widget = ValueBuilder<bool?>(
      builder: (bool? snapshot, void Function(bool?) updater) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              value: snapshot,
              onChanged: (bool? value) {
                updater(value);
              },
              title: Text(I18n.enableBrowsingHistory.tr),
            ),
          ],
        );
      },
      initialValue: Get.find<AppSettingsService>().enableBrowsingHistory,
      onUpdate: (bool? value) {
        if (null != value) {
          Get.find<AppSettingsService>().enableBrowsingHistory = value;
        }
      },
    );

    if (isPage) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${I18n.browsingHistory.tr}${I18n.settings.tr}'),
        ),
        body: widget,
      );
    } else {
      return widget;
    }
  }
}
