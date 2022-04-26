import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/vo/trending_tag_list_result.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_mobile/components/loading_more_indicator/loading_more_indicator.dart';
import 'package:pixiv_func_mobile/pages/illust/illust.dart';
import 'package:pixiv_func_mobile/pages/search/result/illust/illust_result.dart';
import 'package:pixiv_func_mobile/pages/search/trending_illust/source.dart';

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
          child: Icon(
            Icons.search_outlined,
            color: Get.theme.colorScheme.background,
          ),
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
                            return GestureDetector(
                              onTap: () => Get.to(SearchIllustResultPage(word: item.tag)),
                              onLongPress: () => Get.to(IllustPage(illust: item.illust)),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  imageWidget,
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
                              ),
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
