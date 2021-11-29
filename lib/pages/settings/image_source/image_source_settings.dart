/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:image_source_settings.dart
 * 创建时间:2021/11/24 下午5:40
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/settings/app_settings.dart';

class ImageSourceSettingsWidget extends StatelessWidget {
  const ImageSourceSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<String?>(
      builder: (String? snapshot, void Function(String?) updater) {
        final TextEditingController customImageSourceInput = TextEditingController();

        const List<MapEntry<String, String>> imageSources = [
          MapEntry('使用IP直连(210.140.92.139)', '210.140.92.139'),
          MapEntry('使用原始图片源(i.pximg.net)', 'i.pximg.net'),
          MapEntry('使用代理图片源(i.pixiv.re)', 'i.pixiv.re'),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final imageSource in imageSources)
              RadioListTile(
                title: Text(imageSource.key),
                value: imageSource.value,
                groupValue: snapshot,
                onChanged: updater,
              ),
            RadioListTile(
              title: const Text('使用自定义图片源'),
              value: customImageSourceInput.text,
              groupValue: snapshot,
              onChanged: updater,
            ),
            ListTile(
              title: TextField(
                decoration: const InputDecoration(label: Text('自定义图片源')),
                controller: customImageSourceInput,
                onChanged: updater,
              ),
            ),
          ],
        );
      },
      initialValue: Get.find<AppSettingsService>().imageSource,
      onUpdate: (String? value) {
        if (null != value) {
          Get.find<AppSettingsService>().imageSource = value;
        }
      },
    );
  }
}
