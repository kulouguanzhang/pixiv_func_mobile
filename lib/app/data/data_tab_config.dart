/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:data_tab_config.dart
 * 创建时间:2021/11/27 下午3:21
 * 作者:小草
 */

import 'package:flutter/cupertino.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_android/app/data/data_source_base.dart';

class DataTabConfig<T> {
  final String name;
  final DataSourceBase<T>? source;
  final SliverGridDelegate? gridDelegate;
  final ExtendedListDelegate? extendedListDelegate;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final bool isCustomChild;
  DataTabConfig({
    required this.name,
    required this.source,
    this.gridDelegate,
    this.extendedListDelegate,
    required this.itemBuilder,
    this.isCustomChild = false,
  });
}
