/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:data_tab_view_content.dart
 * 创建时间:2021/11/27 下午3:35
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_android/app/data/data_source_base.dart';
import 'package:pixiv_func_android/components/loading_more_indicator/loading_more_indicator.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class DataTabViewContent<T> extends StatelessWidget {
  final DataSourceBase<T> sourceList;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final SliverGridDelegate? gridDelegate;
  final ExtendedListDelegate? extendedListDelegate;

  const DataTabViewContent({
    Key? key,
    required this.sourceList,
    required this.itemBuilder,
    this.gridDelegate,
    this.extendedListDelegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingMoreList(
      ListConfig(
        showGlowLeading: false,
        primary: true,
        itemBuilder: itemBuilder,
        sourceList: sourceList,
        extendedListDelegate: extendedListDelegate,
        gridDelegate: gridDelegate,
        itemCountBuilder: (int count) => sourceList.length,
        indicatorBuilder: (BuildContext context, IndicatorStatus status) => LoadingMoreIndicator(
          status: status,
          errorRefresh: () async => await sourceList.errorRefresh(),
        ),
      ),
    );
  }

  Widget buildPullToRefreshHeader(PullToRefreshScrollNotificationInfo? info) {
    var offset = info?.dragOffset ?? 0.0;
    var mode = info?.mode;
    // Widget refreshWidget = Container();
    //
    // if (info?.refreshWidget != null && offset > 18.0 && mode != RefreshIndicatorMode.error) {
    //   refreshWidget = info!.refreshWidget!;
    // }

    final Widget child;
    if (mode == RefreshIndicatorMode.error) {
      child = GestureDetector(
          onTap: () {
            // refreshNotification;
            info?.pullToRefreshNotificationState.show();
          },
          child: Container(
            color: Colors.grey,
            alignment: Alignment.bottomCenter,
            height: offset,
            width: double.infinity,
            //padding: EdgeInsets.only(top: offset),
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
        color: Colors.grey,
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
