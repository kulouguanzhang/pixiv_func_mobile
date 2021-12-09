/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:proxy_settings.dart
 * 创建时间:2021/11/24 下午5:29
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/http/http.dart';
import 'package:pixiv_func_android/app/settings/app_settings.dart';

class ProxySettingsWidget extends StatelessWidget {
  const ProxySettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueBuilder<bool?>(
          builder: (bool? snapshot, void Function(bool?) updater) {
            return CheckboxListTile(
              value: snapshot,
              onChanged: (bool? value) {
                updater(value);
              },
              title: const Text('启用Http代理'),
            );
          },
          initialValue: Get.find<AppSettingsService>().enableProxy,
          onUpdate: (bool? value) {
            if (null != value) {
              Get.find<AppSettingsService>().enableProxy = value;
            }
          },
        ),
        ValueBuilder<String?>(
          builder: (String? snapshot, void Function(String?) updater) {
            return InkWell(
              onTap: () {
                final TextEditingController ipInput = TextEditingController(
                  text: Get.find<AppSettingsService>().httpProxyUrl.split(':').first,
                );
                final TextEditingController portInput = TextEditingController(
                  text: Get.find<AppSettingsService>().httpProxyUrl.split(':').last,
                );
                Get.dialog(
                  AlertDialog(
                    content: Column(
                      children: [
                        TextField(
                          controller: ipInput,
                          decoration: const InputDecoration(label: Text('IP')),
                        ),
                        TextField(
                          controller: portInput,
                          decoration: const InputDecoration(label: Text('端口')),
                        ),
                      ],
                    ),
                    actions: [
                      OutlinedButton(
                          onPressed: () {
                            updater('${ipInput.text}:${portInput.text}');
                            Get.back();
                          },
                          child: const Text('确定')),
                      OutlinedButton(onPressed: () => Get.back(), child: const Text('取消')),
                    ],
                  ),
                );
              },
              child: Text(
                Get.find<AppSettingsService>().httpProxyUrl,
                style: const TextStyle(fontSize: 25),
              ),
            );
          },
          initialValue: Get.find<AppSettingsService>().httpProxyUrl,
          onUpdate: (String? value) {
            if (null != value) {
              Get.find<AppSettingsService>().httpProxyUrl = value;
              HttpConfig.refreshHttpClient();
            }
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text('这个是仅代理模式\n不了解就不要用否则无法正常联网\n是给WSA之类的没有VPN模块的系统用的\n手机用不到'),
        ),
      ],
    );
  }
}
