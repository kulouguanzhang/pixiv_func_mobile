/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:illust_result.dart
 * 创建时间:2021/11/29 下午12:48
 * 作者:小草
 */

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/entity/illust.dart';
import 'package:pixiv_func_mobile/app/data/data_content.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/pull_to_refresh_header/pull_to_refresh_header.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';
import 'package:pixiv_func_mobile/pages/search/filter_editor/filter_editor.dart';
import 'package:pixiv_func_mobile/pages/search/input/controller.dart';
import 'package:pixiv_func_mobile/pages/search/result/illust/source.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class SearchIllustResultPage extends StatelessWidget {
  final String word;
  final bool isTemp;

  const SearchIllustResultPage({Key? key, required this.word, this.isTemp = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRegistered = Get.isRegistered<SearchInputController>();
    final source =
        SearchIllustResultListSource(word, isRegistered && !isTemp ? Get.find<SearchInputController>().state.filter : SearchFilter.create());

    return Scaffold(
      body: PullToRefreshNotification(
        onRefresh: () async => await source.refresh(true),
        maxDragOffset: 100,
        child: ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text('${I18n.search.tr}${I18n.illust.tr}:$word'),
                actions: [
                  IconButton(
                    onPressed: () => Get.dialog<SearchFilter>(
                      SearchFilterEditor(filter: source.filter),
                    ).then(
                      (SearchFilter? value) {
                        if (null != value && source.filter != value) {
                          if (isRegistered && !isTemp) {
                            Get.find<SearchInputController>().onFilterChanged(value);
                          }
                          source.onFilterChanged(value);
                          source.refresh(true);
                        }
                      },
                    ),
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                ],
              ),
              PullToRefreshContainer((info) => PullToRefreshHeader(info: info)),
            ];
          },
          body: DataContent<Illust>(
            sourceList: source,
            itemBuilder: (BuildContext context, Illust item, int index) => IllustPreviewer(illust: item),
            extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          ),
          floatHeaderSlivers: true,
        ),
      ),
    );
  }
}
