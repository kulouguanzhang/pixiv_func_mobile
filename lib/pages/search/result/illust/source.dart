/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:source.dart
 * 创建时间:2021/11/29 下午12:49
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/api/dto/illusts.dart';
import 'package:pixiv_func_mobile/app/api/entity/illust.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';

class SearchIllustResultListSource extends DataSourceBase<Illust> {
  final String word;

  SearchFilter filter;

  SearchIllustResultListSource(this.word, this.filter);

  final api = Get.find<ApiClient>();

  void onFilterChanged(SearchFilter value) {
    filter = value;
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.searchIllust(
          word,
          Utils.enumToPixivParameter(filter.sort),
          Utils.enumToPixivParameter(filter.target),
          startDate: filter.enableDateRange ? filter.formatStartDate : null,
          endDate: filter.enableDateRange ? filter.formatEndDate : null,
          bookmarkTotal: filter.bookmarkTotal,
          cancelToken: cancelToken,
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
