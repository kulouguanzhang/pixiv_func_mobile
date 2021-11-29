/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_previewer.dart
 * 创建时间:2021/11/19 下午6:56
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_android/app/api/enums.dart';
import 'package:pixiv_func_android/app/data/data_tab_config.dart';
import 'package:pixiv_func_android/app/data/data_tab_page.dart';
import 'package:pixiv_func_android/components/illust_previewer/illust_previewer.dart';

import 'content/source.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  static const tabNames = [
    '每日',
    '每日(R-18)',
    '每日(男性欢迎)',
    '每日(男性欢迎 & R-18)',
    '每日(女性欢迎)',
    '每日(女性欢迎 & R-18)',
    '每周',
    '每周(R-18)',
    '每周(原创)',
    '每周(新人)',
    '每月',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DataTabPage(
          title: 'Pixiv Func',
          tabs: [
            for (int index = 0; index < tabNames.length; ++index)
              DataTabConfig(
                name: tabNames[index],
                source: RankingListSource(RankingMode.values[index]),
                itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
                extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              ),
          ],
          isScrollable: true,
        ),
      ),
    );
  }
}
