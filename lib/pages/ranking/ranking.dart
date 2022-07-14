import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';

import 'content/source.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: RankingMode.values.length,
      child: ScaffoldWidget(
        titleWidget: const TabBarWidget(
          indicatorMinWidth: 15,
          isScrollable: true,
          indicator: RRecTabIndicator(
            radius: 4,
            insets: EdgeInsets.only(bottom: 5),
          ),
          tabs: [
            Tab(text: '每日'),
            Tab(text: '每日(R-18)'),
            Tab(text: '每日(男性欢迎)'),
            Tab(text: '每日(男性欢迎 & R-18)'),
            Tab(text: '每日(女性欢迎)'),
            Tab(text: '每日(女性欢迎 & R-18)'),
            Tab(text: '每周'),
            Tab(text: '每周(R-18)'),
            Tab(text: '每周(原创)'),
            Tab(text: '每周(新人)'),
            Tab(text: '每月'),
          ],
        ),
        child: TabBarView(
          children: [
            for (int i = 0; i < RankingMode.values.length; ++i)
              DataContent<Illust>(
                sourceList: () => RankingListSource(RankingMode.values[i]),
                extendedListDelegate:
                const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
                itemBuilder: (BuildContext context, Illust item, int index) => IllustPreviewer(illust: item),
              ),
          ],
        ),
      ),
    );
  }
}
