/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:novel_result.dart
 * 创建时间:2021/11/29 下午1:47
 * 作者:小草
 */
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/entity/novel.dart';
import 'package:pixiv_func_android/app/data/data_tab_view_content.dart';
import 'package:pixiv_func_android/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_android/components/pull_to_refresh_header/pull_to_refresh_header.dart';
import 'package:pixiv_func_android/models/search_filter.dart';
import 'package:pixiv_func_android/pages/search/filter_editor/filter_editor.dart';
import 'package:pixiv_func_android/pages/search/input/controller.dart';
import 'package:pixiv_func_android/pages/search/result/novel/source.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class SearchNovelResultPage extends StatelessWidget {
  final String word;
  final SearchFilter filter;
  final bool isTemp;

  SearchNovelResultPage({Key? key, required this.word, required SearchFilter filter, this.isTemp = false})
      : filter = SearchFilter.copy(filter),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final source = SearchNovelResultListSource(word, filter);
    final isRegistered = Get.isRegistered<SearchInputController>();

    return Scaffold(
      body: PullToRefreshNotification(
        onRefresh: () async => await source.refresh(true),
        maxDragOffset: 100,
        child: ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text('搜索小说:$word'),
                actions: [
                  IconButton(
                    tooltip: '打开搜索过滤编辑器',
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => SearchFilterEditor(
                        filter: isRegistered && !isTemp ? Get.find<SearchInputController>().state.filter : filter,
                        onChanged: (SearchFilter value) {
                          if (isRegistered && !isTemp) {
                            Get.find<SearchInputController>().filterOnChanged(value);
                          }
                          source.filter = value;
                          source.refresh(true);
                        },
                      ),
                    ),
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                ],
              ),
              PullToRefreshContainer((info) => PullToRefreshHeader(info: info)),
            ];
          },
          body: DataTabViewContent<Novel>(
            sourceList: source,
            itemBuilder: (BuildContext context, Novel item, int index) => NovelPreviewer(novel: item),
          ),
          floatHeaderSlivers: true,
        ),
      ),
    );
  }
}
