/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:id_search.dart
 * 创建时间:2021/12/5 下午10:58
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              title: const Text('加载失败点击重新加载'),
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
