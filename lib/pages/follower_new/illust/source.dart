/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:source.dart
 * 创建时间:2021/11/30 下午12:54
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/api/entity/illust.dart';
import 'package:pixiv_func_android/app/api/model/illusts.dart';
import 'package:pixiv_func_android/app/data/data_source_base.dart';

class FollowerNewIllustListSource extends DataSourceBase<Illust> {
  final bool? restrict;

  FollowerNewIllustListSource(this.restrict);

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getFollowerNewIllusts(
          cancelToken: cancelToken,
          restrict: restrict,
        );
        nextUrl = result.nextUrl;
        addAll(result.illusts);
        initData = true;
      } else {
        if (hasMore) {
          final result = await api.next<Illusts>(nextUrl!, cancelToken: cancelToken);
          nextUrl = result.nextUrl;
          addAll(result.illusts);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
