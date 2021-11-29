/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:data_source_base.dart
 * 创建时间:2021/11/17 下午4:59
 * 作者:小草
 */

import 'package:dio/dio.dart';
import 'package:loading_more_list/loading_more_list.dart';

abstract class DataSourceBase<T> extends LoadingMoreBase<T> {
  bool initData = false;

  String? nextUrl;

  @override
  bool get hasMore => !initData || null != nextUrl;

  bool forceRefresh = false;

  CancelToken cancelToken = CancelToken();

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    initData = false;
    nextUrl = null;
    forceRefresh = !notifyStateChanged;
    final result = super.refresh(notifyStateChanged);
    forceRefresh = false;
    return result;
  }

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }
}
