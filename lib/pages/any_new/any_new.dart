/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:any_new.dart
 * 创建时间:2021/11/30 下午12:35
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_android/app/api/enums.dart';
import 'package:pixiv_func_android/app/data/data_tab_config.dart';
import 'package:pixiv_func_android/app/data/data_tab_page.dart';
import 'package:pixiv_func_android/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_android/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_android/pages/any_new/illust/source.dart';
import 'package:pixiv_func_android/pages/any_new/novel/source.dart';

class AnyNewPage extends StatelessWidget {
  const AnyNewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DataTabPage(
          title: '所有人的新作品',
          tabs: [
            DataTabConfig(
              name: '插画',
              source: AnyNewIllustListSource(WorkType.illust),
              itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
              extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            ),
            DataTabConfig(
              name: '漫画',
              source: AnyNewIllustListSource(WorkType.manga),
              itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
              extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            ),
            DataTabConfig(
              name: '小说',
              source: AnyNewNovelListSource(),
              itemBuilder: (BuildContext context, item, int index) => NovelPreviewer(novel: item),
            ),
          ],
        ),
      ),
    );
  }
}
