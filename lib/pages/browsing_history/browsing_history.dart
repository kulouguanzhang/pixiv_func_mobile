/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:browsing_history.dart
 * 创建时间:2021/11/26 下午7:01
 * 作者:小草
 */
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_android/app/api/entity/illust.dart';
import 'package:pixiv_func_android/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_android/components/loading_more_indicator/loading_more_indicator.dart';
import 'package:pixiv_func_android/pages/browsing_history/source.dart';

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
              title: const Text('历史记录'),
              actions: [
                IconButton(
                  tooltip: '清空历史记录',
                  icon: const Icon(Icons.delete_forever_outlined),
                  onPressed: () {
                    Get.dialog<bool>(AlertDialog(
                      title: const Text('清空'),
                      content: const Text('确定要清空历史记录嘛?'),
                      actions: [
                        OutlinedButton(onPressed: () => Navigator.pop<bool>(context, true), child: const Text('确定')),
                        OutlinedButton(onPressed: () => Navigator.pop<bool>(context, false), child: const Text('取消')),
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
                      title: const Text('删除这一条历史记录'),
                      content: const Text('确定要删除嘛?'),
                      actions: [
                        OutlinedButton(onPressed: () => Navigator.pop<bool>(context, true), child: const Text('确定')),
                        OutlinedButton(onPressed: () => Navigator.pop<bool>(context, false), child: const Text('取消')),
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
