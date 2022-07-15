import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/app/data/account_service.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';
import 'package:pixiv_func_mobile/pages/search/result/illust/controller.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/sliding_segmented_control/sliding_segmented_control.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'source.dart';

class SearchIllustResultPage extends StatelessWidget {
  final String keyword;

  const SearchIllustResultPage({Key? key, required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SearchIllustResultController());
    return GetBuilder<SearchIllustResultController>(
      builder: (controller) => ScaffoldWidget(
        automaticallyImplyLeading: false,
        titleWidget: SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.back(),
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController(text: keyword),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        gapPadding: 0,
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      hintText: '搜索',
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 3),
                      fillColor: Theme.of(context).colorScheme.surface,
                      filled: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Get.back(),
                child: TextWidget('取消', color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(width: 25),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.expandedFilterChangeState(),
                child: Icon(Icons.filter_alt_outlined, color: controller.editFilter ? Theme.of(context).colorScheme.primary : null),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        child: Column(
          children: [
            ExpandablePanel(
              controller: controller.filterPanelController,
              collapsed: const SizedBox(),
              expanded: Padding(
                padding: const EdgeInsets.fromLTRB(28, 10, 28, 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => controller.editFilterChangeState(0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const TextWidget('搜索目标', fontSize: 14),
                              Icon(
                                controller.editFilterIndex == 0 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: controller.editFilterIndex == 0 ? Theme.of(context).colorScheme.primary : null,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => controller.editFilterChangeState(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const TextWidget('搜索排序', fontSize: 14),
                              Icon(
                                controller.editFilterIndex == 1 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: controller.editFilterIndex == 1 ? Theme.of(context).colorScheme.primary : null,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => controller.editFilterChangeState(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const TextWidget('时间范围', fontSize: 14),
                              Icon(
                                controller.editFilterIndex == 2 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: controller.editFilterIndex == 2 ? Theme.of(context).colorScheme.primary : null,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => controller.editFilterChangeState(3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const TextWidget('收藏数量', fontSize: 14),
                              Icon(
                                controller.editFilterIndex == 3 ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: controller.editFilterIndex == 3 ? Theme.of(context).colorScheme.primary : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ExpandablePanel(
                      controller: controller.editFilterPanelController,
                      collapsed: const SizedBox(),
                      expanded: () {
                        switch (controller.editFilterIndex) {
                          case 0:
                            return SlidingSegmentedControl(
                              children: const <SearchSort, Widget>{
                                SearchSort.dateDesc: TextWidget('时间降序'),
                                SearchSort.dateAsc: TextWidget('时间升序'),
                                SearchSort.popularDesc: TextWidget('热度降序'),
                              },
                              groupValue: controller.filter.sort,
                              onValueChanged: (SearchSort? value) {
                                if (null != value) {
                                  if (SearchSort.popularDesc == value && !Get.find<AccountService>().current!.user.isPremium) {
                                    PlatformApi.toast('你不是Pixiv高级会员,所以该选项与时间降序行为一致');
                                  }
                                  controller.sort = value;
                                }
                              },
                              splitEqually: false,
                            );
                          case 1:
                            return SlidingSegmentedControl(
                              children: const <SearchTarget, Widget>{
                                SearchTarget.partialMatchForTags: Text('标签(部分匹配)'),
                                SearchTarget.exactMatchForTags: Text('标签(完全匹配)'),
                                SearchTarget.titleAndCaption: Text('标题&简介'),
                              },
                              groupValue: controller.filter.target,
                              onValueChanged: (SearchTarget? value) {
                                if (null != value) {
                                  controller.target = value;
                                }
                              },
                              splitEqually: false,
                            );
                          default:
                            return const SizedBox();
                        }
                      }(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: DataContent<Illust>(
                sourceList: () => SearchIllustResultListSource(keyword, SearchFilter.create()),
                extendedListDelegate:
                    const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
                itemBuilder: (BuildContext context, Illust item, int index) => IllustPreviewer(illust: item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
