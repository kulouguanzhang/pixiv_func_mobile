/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:any_new.dart
 * 创建时间:2021/11/30 下午12:35
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/app/api/enums.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_config.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_page.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_mobile/pages/any_new/illust/source.dart';
import 'package:pixiv_func_mobile/pages/any_new/novel/source.dart';

class AnyNewPage extends StatelessWidget {
  const AnyNewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DataTabPage(
          title: I18n.anyNewIllust.tr,
          tabs: [
            DataTabConfig(
              name: I18n.illust.tr,
              source: AnyNewIllustListSource(WorkType.illust),
              itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
              extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            ),
            DataTabConfig(
              name: I18n.manga.tr,
              source: AnyNewIllustListSource(WorkType.manga),
              itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
              extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            ),
            DataTabConfig(
              name: I18n.novel.tr,
              source: AnyNewNovelListSource(),
              itemBuilder: (BuildContext context, item, int index) => NovelPreviewer(novel: item),
            ),
          ],
        ),
      ),
    );
  }
}
