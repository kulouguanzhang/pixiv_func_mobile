/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:source.dart
 * 创建时间:2021/11/26 下午7:04
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/entity/illust.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/local_data/browsing_history_service.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class BrowsingHistoryListSource extends DataSourceBase<Illust> {
  static const _limit = 30;
  int offset = 0;

  int total = 0;

  @override
  bool get hasMore => offset < total || !initData;

  final BrowsingHistoryService browsingHistoryService = Get.find<BrowsingHistoryService>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        total = await Get.find<BrowsingHistoryService>().count();

        final result = await Get.find<BrowsingHistoryService>().query(offset, _limit);
        offset += result.length;
        addAll(result);

        initData = true;
      } else {
        if (hasMore) {
          final result = await Get.find<BrowsingHistoryService>().query(offset, _limit);
          offset += result.length;
          addAll(result);
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeItem(int illustId) async {
    await browsingHistoryService.delete(illustId).then((column) {
      if (column > 0) {
        removeWhere((illust) => illustId == illust.id);
        --total;
        if (0 == total) {
          indicatorStatus = IndicatorStatus.empty;
        }
        setState();
      } else {
        Get.find<PlatformApi>().toast(I18n.failed.tr);
      }
    }).catchError((e) {
      Log.e('删除历史记录$illustId失败 SQL异常');
    });
  }

  Future<void> clearItem() async {
    await browsingHistoryService.clear();
    Get.find<PlatformApi>().toast(I18n.success.tr);
    total = 0;
    clear();
    indicatorStatus = IndicatorStatus.empty;
    setState();
  }
}
