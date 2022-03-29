/*
 * Copyright (C) 2022. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:source.dart
 * 创建时间:2022/3/29 下午4:42
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/api/dto/users.dart';
import 'package:pixiv_func_mobile/app/api/entity/user_preview.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';
import 'package:pixiv_func_mobile/app/local_data/account_manager.dart';

class FansListSource extends DataSourceBase<UserPreview> {
  FansListSource();

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getFollower(
          Get.find<AccountService>().currentUserId,
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
