/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:pull_to_refresh_header.dart
 * 创建时间:2021/11/29 下午11:51
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class PullToRefreshHeader extends StatelessWidget {
  final PullToRefreshScrollNotificationInfo? info;
  const PullToRefreshHeader({Key? key,required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offset = info?.dragOffset ?? 0.0;
    final mode = info?.mode;

    final Widget child;
    if (mode == RefreshIndicatorMode.error) {
      child = GestureDetector(
          onTap: () {
            // refreshNotification;
            info?.pullToRefreshNotificationState.show();
          },
          child: Container(
            color: Get.theme.cardColor,
            alignment: Alignment.bottomCenter,
            height: offset,
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.only(left: 5.0),
              alignment: Alignment.center,
              child: Text(
                mode.toString() + "  click to retry",
                style: const TextStyle(fontSize: 12.0, inherit: false),
              ),
            ),
          ));
    } else {
      child = Container(
        color: Get.theme.cardColor,
        alignment: Alignment.bottomCenter,
        height: offset,
        width: double.infinity,
        //padding: EdgeInsets.only(top: offset),
        child: Container(
          padding: const EdgeInsets.only(left: 5.0),
          alignment: Alignment.center,
          child: Text(
            mode?.toString() ?? "",
            style: const TextStyle(fontSize: 12.0, inherit: false),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: child,
    );
  }
}
