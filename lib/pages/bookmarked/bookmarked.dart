import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_config.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_page.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_mobile/models/bookmarked_filter.dart';

import 'filter_editor/filter_editor.dart';
import 'illust/source.dart';
import 'novel/source.dart';

class BookmarkedPage extends StatelessWidget {
  const BookmarkedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: ObxValue<Rx<BookmarkedFilter>>(
            (Rx<BookmarkedFilter> data) {
              return DataTabPage(
                key: Key('Key($runtimeType:${data.hashCode})'),
                title: 'Pixiv Func',
                tabs: [
                  DataTabConfig(
                    name: I18n.illustAndManga.tr,
                    source: BookmarkedIllustListSource(data.value),
                    itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
                    extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  ),
                  DataTabConfig(
                    name: I18n.novel.tr,
                    source: BookmarkedNovelListSource(data.value),
                    itemBuilder: (BuildContext context, item, int index) => NovelPreviewer(novel: item),
                    extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  ),
                ],
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.dialog<BookmarkedFilter>(
                        BookmarkedFilterEditor(
                          filter: data.value,
                        ),
                      ).then(
                        (BookmarkedFilter? value) {
                          if (null != value) {
                            if (data.value != value) {
                              data.value = value;
                            }
                          }
                        },
                      );
                    },
                    icon: const Icon(Icons.filter_alt_outlined),
                  ),
                ],
              );
            },
            BookmarkedFilter.create().obs,
          ),
        ),
      ),
    );
  }
}
