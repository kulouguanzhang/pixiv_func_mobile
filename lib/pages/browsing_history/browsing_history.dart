/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:browsing_history.dart
 * 创建时间:2021/11/26 下午7:01
 * 作者:小草
 */
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/app/api/entity/illust.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/loading_more_indicator/loading_more_indicator.dart';
import 'package:pixiv_func_mobile/pages/browsing_history/source.dart';

class BrowsingHistoryPage extends StatelessWidget {
  const BrowsingHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final source = BrowsingHistoryListSource();
    return Scaffold(
      body: ExtendedNestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(I18n.browsingHistory.tr),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_forever_outlined),
                  onPressed: () {
                    Get.dialog<bool>(AlertDialog(
                      title: Text(I18n.clear.tr),
                      content: Text(I18n.clearBrowsingHistoryAsk.tr),
                      actions: [
                        OutlinedButton(
                          onPressed: () => Get.back<bool>(result: true),
                          child: Text(I18n.confirm.tr),
                        ),
                        OutlinedButton(
                          onPressed: () => Get.back<bool>(result: false),
                          child: Text(I18n.cancel.tr),
                        ),
                      ],
                    )).then((value) {
                      if (true == value) {
                        source.clearItem();
                      }
                    });
                  },
                )
              ],
            )
          ];
        },
        body: LoadingMoreList(
          ListConfig(
            extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, Illust item, int index) {
              return InkWell(
                onLongPress: () {
                  Get.dialog<bool>(
                    AlertDialog(
                      title: Text(I18n.removeBrowsingHistoryOne.tr),
                      content: Text(I18n.removeBrowsingHistoryOneAsk.tr),
                      actions: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop<bool>(context, true),
                          child: Text(I18n.confirm.tr),
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.pop<bool>(context, false),
                          child: Text(I18n.cancel.tr),
                        ),
                      ],
                    ),
                  ).then(
                    (value) async {
                      if (true == value) {
                        await source.removeItem(item.id);
                      }
                    },
                  );
                },
                child: IllustPreviewer(illust: item),
              );
            },
            sourceList: source,
            itemCountBuilder: (int count) => source.length,
            indicatorBuilder: (BuildContext context, IndicatorStatus status) => LoadingMoreIndicator(
              status: status,
              errorRefresh: () => source.errorRefresh(),
            ),
          ),
        ),
      ),
    );
  }
}
