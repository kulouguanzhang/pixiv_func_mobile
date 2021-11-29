/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:browsing_history_settings.dart
 * 创建时间:2021/11/26 下午5:02
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/settings/app_settings.dart';

class BrowsingHistorySettingsWidget extends StatelessWidget {
  const BrowsingHistorySettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueBuilder<bool?>(
          builder: (bool? snapshot, void Function(bool?) updater) {
            return CheckboxListTile(
              value: snapshot,
              onChanged: (bool? value) {
                updater(value);
              },
              title: const Text('启用历史记录'),
            );
          },
          initialValue: Get.find<AppSettingsService>().enableBrowsingHistory,
          onUpdate: (bool? value) {
            if (null != value) {
              Get.find<AppSettingsService>().enableBrowsingHistory = value;
            }
          },
        ),
      ],
    );
  }
}
