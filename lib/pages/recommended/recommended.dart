/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_previewer.dart
 * 创建时间:2021/11/17 下午11:57
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_android/app/api/enums.dart';
import 'package:pixiv_func_android/app/data/data_tab_config.dart';
import 'package:pixiv_func_android/app/data/data_tab_page.dart';
import 'package:pixiv_func_android/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_android/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_android/components/user_previewer/user_previewer.dart';

import 'illust/source.dart';
import 'novel/source.dart';
import 'user/source.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DataTabPage(
          title: 'Pixiv Func',
          tabs: [
            DataTabConfig(
              name: '插画',
              source: RecommendedIllustListSource(WorkType.illust),
              extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
            ),
            DataTabConfig(
              name: '漫画',
              source: RecommendedIllustListSource(WorkType.manga),
              extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
            ),
            DataTabConfig(
              name: '小说',
              source: RecommendedNovelListSource(),
              itemBuilder: (BuildContext context, item, int index) => NovelPreviewer(novel: item),
            ),
            DataTabConfig(
              name: '用户',
              source: RecommendedUserListSource(),
              itemBuilder: (BuildContext context, item, int index) => UserPreviewer(userPreview: item),
            ),
          ],
        ),
      ),
    );
  }
}
