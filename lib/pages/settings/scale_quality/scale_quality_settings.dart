/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:scale_quality_settings.dart
 * 创建时间:2021/11/26 下午5:02
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/settings/app_settings.dart';

class ScaleQualitySettingsWidget extends StatelessWidget {
  final bool isPage;

  const ScaleQualitySettingsWidget({Key? key, this.isPage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widget = ValueBuilder<bool?>(
      builder: (bool? snapshot, void Function(bool?) updater) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile(
              title: Text(I18n.scaleQualityItem1.tr),
              value: false,
              groupValue: snapshot,
              onChanged: (bool? value) {
                updater(value);
              },
            ),
            RadioListTile(
              title: Text(I18n.scaleQualityItem2.tr),
              value: true,
              groupValue: snapshot,
              onChanged: (bool? value) {
                updater(value);
              },
            ),
          ],
        );
      },
      initialValue: Get.find<AppSettingsService>().scaleQuality,
      onUpdate: (bool? value) {
        if (null != value) {
          Get.find<AppSettingsService>().scaleQuality = value;
        }
      },
    );
    if (isPage) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${I18n.scaleQuality.tr}${I18n.settings.tr}'),
        ),
        body: widget,
      );
    } else {
      return widget;
    }
  }
}
