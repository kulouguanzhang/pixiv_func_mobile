/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:source.dart
 * 创建时间:2021/11/29 下午12:53
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/api/model/trending_tags.dart';
import 'package:pixiv_func_android/app/data/data_source_base.dart';

class TrendingIllustListSource extends DataSourceBase<TrendTag> {
  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getTrendingTags(
          cancelToken: cancelToken,
        );

        addAll(result.trendTags);
        initData = true;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
