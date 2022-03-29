/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:following_new.dart
 * 创建时间:2021/11/30 下午12:29
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_config.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_page.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/dropdown_menu/dropdown_menu.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_mobile/models/dropdown_item.dart';

import 'illust/source.dart';
import 'novel/source.dart';

class FollowingNewPage extends StatelessWidget {
  const FollowingNewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ObxValue<Rx<bool?>>((data) {
          return DataTabPage(
            key: Key('Key($runtimeType:${data.hashCode})'),
            title: I18n.followingNewIllust.tr,
            actions: [
              DropdownButtonHideUnderline(
                child: DropdownMenu<bool?>(
                  menuItems: [
                    DropdownItem(null, I18n.all.tr),
                    DropdownItem(true, I18n.public.tr),
                    DropdownItem(false, I18n.private.tr),
                  ],
                  currentValue: data.value,
                  onChanged: (bool? value) => data.value = value,
                ),
              ),
            ],
            tabs: [
              DataTabConfig(
                name: I18n.illustAndManga.tr,
                source: FollowerNewIllustListSource(data.value),
                itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
                extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              ),
              DataTabConfig(
                name: I18n.novel.tr,
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
