import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/data_page/data_content.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';

import 'illust/source.dart';
import 'novel/source.dart';
import 'user/source.dart';

class RecommendedPage extends StatelessWidget {
  const RecommendedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: ScaffoldWidget(
        titleWidget: const TabBarWidget(
          indicatorMinWidth: 20,
          indicator: RRecTabIndicator(
            radius: 4,
            insets: EdgeInsets.only(bottom: 5),
            color: Colors.blueAccent,
          ),
          labelColor: Colors.white,
          tabs: [
            Tab(text: '插画'),
            Tab(text: '漫画'),
            Tab(text: '小说'),
            Tab(text: '用户'),
          ],
        ),
        child: TabBarView(
          children: [
            DataContent<Illust>(
              sourceList: RecommendedIllustListSource(IllustType.illust),
              extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, Illust item, int index) => IllustPreviewer(illust: item),
            ),
            DataContent<Illust>(
              sourceList: RecommendedIllustListSource(IllustType.manga),
              extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, Illust item, int index) => IllustPreviewer(illust: item),
            ),
            const SizedBox(),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
