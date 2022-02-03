/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:source.dart
 * 创建时间:2021/11/20 上午12:48
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/api/dto/users.dart';
import 'package:pixiv_func_android/app/api/entity/user_preview.dart';
import 'package:pixiv_func_android/app/data/data_source_base.dart';

class RecommendedUserListSource extends DataSourceBase<UserPreview> {
  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getRecommendedUsers(
          cancelToken: cancelToken,
        );
        nextUrl = result.nextUrl;
        addAll(result.userPreviews);
        initData = true;
      } else {
        if (hasMore) {
          final result = await api.next<Users>(nextUrl!, cancelToken: cancelToken);
          nextUrl = result.nextUrl;
          addAll(result.userPreviews);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
