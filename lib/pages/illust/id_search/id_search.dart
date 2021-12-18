/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:id_search.dart
 * 创建时间:2021/12/5 下午10:58
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/i18n/i18n.dart';
import 'package:pixiv_func_android/pages/illust/illust.dart';

import 'controller.dart';

class IllustIdSearch extends StatelessWidget {
  final int id;

  const IllustIdSearch({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(IllustIdSearchController(id));
    return GetBuilder<IllustIdSearchController>(
      assignId: true,
      initState: (state) => controller.loadData(),
      builder: (controller) {
        if (controller.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.initFailed) {
          return Center(
            child: ListTile(
              onTap: () => controller.loadData(),
              title: Text(I18n.loadFailedRetry.tr),
            ),
          );
        } else {
          if (null != controller.illustDetail) {
            return IllustPage(illust: controller.illustDetail!.illust);
          } else {
            return const SizedBox();
          }
        }
      },
    );
  }
}
