import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_config.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_page.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/dropdown_menu/dropdown_menu.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_mobile/models/dropdown_item.dart';

import 'illust/source.dart';
import 'novel/source.dart';

class FollowNewPage extends StatelessWidget {
  const FollowNewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ObxValue<Rx<Restrict?>>((data) {
          return DataTabPage(
            key: Key('Key($runtimeType:${data.hashCode})'),
            title: I18n.followingNewIllust.tr,
            actions: [
              DropdownButtonHideUnderline(
                child: DropdownMenu<Restrict?>(
                  menuItems: [
                    DropdownItem(null, I18n.all.tr),
                    DropdownItem(Restrict.public, I18n.public.tr),
                    DropdownItem(Restrict.private, I18n.private.tr),
                  ],
                  currentValue: data.value,
                  onChanged: (Restrict? value) => data.value = value,
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
        }, Rx<Restrict?>(null)),
      ),
    );
  }
}
