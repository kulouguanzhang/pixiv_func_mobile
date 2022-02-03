/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:source.dart
 * 创建时间:2021/11/25 下午9:28
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/api/dto/illusts.dart';
import 'package:pixiv_func_android/app/api/entity/illust.dart';
import 'package:pixiv_func_android/app/api/enums.dart';
import 'package:pixiv_func_android/app/data/data_source_base.dart';
import 'package:pixiv_func_android/utils/utils.dart';

class UserIllustListSource extends DataSourceBase<Illust> {
  final int id;
  final WorkType type;

  UserIllustListSource(this.id, this.type);

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getUserIllusts(
          id,
          Utils.enumToPixivParameter(type),
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
