/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmarked.dart
 * 创建时间:2021/11/24 下午11:17
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_android/app/data/data_tab_config.dart';
import 'package:pixiv_func_android/app/data/data_tab_page.dart';
import 'package:pixiv_func_android/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_android/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_android/models/bookmarked_filter.dart';

import 'filter_editor/filter_editor.dart';
import 'illust/source.dart';
import 'novel/source.dart';

class BookmarkedPage extends StatelessWidget {
  const BookmarkedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: ObxValue<Rx<BookmarkedFilter>>(
            (Rx<BookmarkedFilter> data) {
              return DataTabPage(
                key: Key('Key($runtimeType:${data.hashCode})'),
                title: 'Pixiv Func',
                tabs: [
                  DataTabConfig(
                    name: '插画&漫画',
                    source: BookmarkedIllustListSource(data.value),
                    itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
                    extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  ),
                  DataTabConfig(
                    name: '小说',
                    source: BookmarkedNovelListSource(data.value),
                    itemBuilder: (BuildContext context, item, int index) => NovelPreviewer(novel: item),
                    extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  ),
                ],
                actions: [
                  IconButton(
                    tooltip: '打开收藏滤编辑器',
                    onPressed: () {
                      Get.dialog<BookmarkedFilter>(
                        BookmarkedFilterEditor(
                          filter: data.value,
                        ),
                      ).then(
                        (BookmarkedFilter? value) {
                          if (null != value) {
                            if (data.value != value) {
                              data.value = value;
                            }
                          }
                        },
                      );
                    },
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                ],
              );
            },
            BookmarkedFilter.create().obs,
          ),
        ),
      ),
    );
  }
}
