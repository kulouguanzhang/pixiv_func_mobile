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

}
