/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:pull_to_refresh_header.dart
 * 创建时间:2021/11/29 下午11:51
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class PullToRefreshHeader extends StatelessWidget {
  final PullToRefreshScrollNotificationInfo? info;

  const PullToRefreshHeader({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offset = info?.dragOffset ?? 0.0;
    final mode = info?.mode;

    final Widget child;
    if (mode == RefreshIndicatorMode.error) {
      child = GestureDetector(
        onTap: () {
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
            child: const Text(
              "加载失败点击重试",
              style: TextStyle(fontSize: 12.0, inherit: false),
            ),
          ),
        ),
      );
    } else {
      final String text;
      if (null != mode) {
        switch (mode) {
          case RefreshIndicatorMode.drag:
            text = I18n.refreshIndicatorModeDarg.tr;
            break;
          case RefreshIndicatorMode.armed:
            text = I18n.refreshIndicatorModeArmed.tr;
            break;
          case RefreshIndicatorMode.snap:
            text = I18n.refreshIndicatorModeSnap.tr;
            break;
          case RefreshIndicatorMode.refresh:
            text = I18n.refreshIndicatorModeRefresh.tr;
            break;
          case RefreshIndicatorMode.done:
            text = '';
            break;
          case RefreshIndicatorMode.canceled:
            text = I18n.refreshIndicatorModeCanceled.tr;
            break;
          case RefreshIndicatorMode.error:
            text = '';
            break;
        }
      } else {
        text = '';
      }
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
            text,
            style: TextStyle(fontSize: 12.0, inherit: false, color: Get.theme.textTheme.bodyText2?.color),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: child,
    );
  }
}
