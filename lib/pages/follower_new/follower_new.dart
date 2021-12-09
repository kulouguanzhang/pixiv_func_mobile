/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:follower_new.dart
 * 创建时间:2021/11/30 下午12:29
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_android/app/data/data_tab_config.dart';
import 'package:pixiv_func_android/app/data/data_tab_page.dart';
import 'package:pixiv_func_android/components/dropdown_menu/dropdown_menu.dart';
import 'package:pixiv_func_android/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_android/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_android/models/dropdown_item.dart';

import 'illust/source.dart';
import 'novel/source.dart';

class FollowerNewPage extends StatelessWidget {
  const FollowerNewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ObxValue<Rx<bool?>>((data) {
          return DataTabPage(
            key: Key('Key($runtimeType:${data.hashCode})'),
            title: '关注者的新作品',
            actions: [
              DropdownButtonHideUnderline(
                child: DropdownMenu<bool?>(
                  menuItems: [
                    DropdownItem(null, '全部'),
                    DropdownItem(true, '公开'),
                    DropdownItem(false, '悄悄'),
                  ],
                  currentValue: data.value,
                  onChanged: (bool? value) => data.value = value,
                ),
              ),
            ],
            tabs: [
              DataTabConfig(
                name: '插画&漫画',
                source: FollowerNewIllustListSource(data.value),
                itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
                extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              ),
              DataTabConfig(
                name: '小说',
                source: FollowerNewNovelListSource(data.value),
                itemBuilder: (BuildContext context, item, int index) => NovelPreviewer(novel: item),
              ),
            ],
          );
        }, Rx<bool?>(null)),
      ),
    );
  }
}
