import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_config.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_page.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_mobile/components/user_previewer/user_previewer.dart';

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
              name: I18n.illust.tr,
              source: RecommendedIllustListSource(IllustType.illust),
              extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
            ),
            DataTabConfig(
              name: I18n.manga.tr,
              source: RecommendedIllustListSource(IllustType.manga),
              extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
            ),
            DataTabConfig(
              name: I18n.novel.tr,
              source: RecommendedNovelListSource(),
              itemBuilder: (BuildContext context, item, int index) => NovelPreviewer(novel: item),
            ),
            DataTabConfig(
              name: I18n.user.tr,
              source: RecommendedUserListSource(),
              itemBuilder: (BuildContext context, item, int index) => UserPreviewer(userPreview: item),
            ),
          ],
        ),
      ),
    );
  }
}
