/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search.dart
 * 创建时间:2021/11/29 上午11:40
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_android/app/api/model/trending_tags.dart';
import 'package:pixiv_func_android/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_android/components/loading_more_indicator/loading_more_indicator.dart';
import 'package:pixiv_func_android/models/search_filter.dart';
import 'package:pixiv_func_android/pages/illust/illust.dart';
import 'package:pixiv_func_android/pages/search/result/illust/illust_result.dart';
import 'package:pixiv_func_android/pages/search/trending_illust/source.dart';

import 'input/search_input.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final source = TrendingIllustListSource();
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'ToSearchInputPageHero',
          backgroundColor: Get.theme.colorScheme.onBackground,
          onPressed: () => Get.to(const SearchInputPage()),
          child: const Icon(Icons.search_outlined),
        ),
        body: LoadingMoreCustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text('Pixiv Func'),
              floating: true,
            ),
            LoadingMoreSliverList(
              SliverListConfig(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                sourceList: source,
                itemBuilder: (BuildContext context, TrendTag item, int index) {
                  return LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth,
                        child: ImageFromUrl(
                          item.illust.imageUrls.squareMedium,
                          color: Get.isDarkMode ? Colors.black45 : Colors.white24,
                          colorBlendMode: BlendMode.srcOver,
                          fit: BoxFit.fill,
                          imageBuilder: (Widget imageWidget) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.to(
                                    SearchIllustResultPage(
                                      word: item.tag,
                                      filter: SearchFilter.create(),
                                    ),
                                  ),
                                  onLongPress: () => Get.to(
                                    IllustPage(illust: item.illust),
                                  ),
                                  child: imageWidget,
                                ),
                                Positioned(
                                  bottom: 3,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          '#${item.tag}',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      if (null != item.translatedName)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            item.translatedName!,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                indicatorBuilder: (BuildContext context, IndicatorStatus status) => LoadingMoreIndicator(
                  status: status,
                  errorRefresh: () async => await source.errorRefresh(),
                  isSliver: true,
                  fullScreenErrorCanRetry: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
