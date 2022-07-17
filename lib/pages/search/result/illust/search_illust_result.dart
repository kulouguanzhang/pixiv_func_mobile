import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/pages/search/filter_editor/controller.dart';
import 'package:pixiv_func_mobile/pages/search/filter_editor/search_filter_editor.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class SearchIllustResultPage extends StatelessWidget {
  final String keyword;

  const SearchIllustResultPage({Key? key, required this.keyword}) : super(key: key);

  String get controllerTag => '$runtimeType-$keyword';

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchIllustResultController(keyword), tag: controllerTag);
    //防止从插画标签点进来的时候没有这个控制器
    Get.put(SearchFilterEditorController(controller.onFilterChanged), tag: 'SearchFilterEditorWidget-$keyword');
    return GetBuilder<SearchIllustResultController>(
      tag: controllerTag,
      assignId: true,
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
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onBackground),
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
                child: TextWidget('取消', color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(width: 25),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.expandedFilterChangeState(),
                child: Icon(AppIcons.filter, color: controller.expandedFilter ? Theme.of(context).colorScheme.primary : null),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        child: Column(
          children: [
            SearchFilterEditorWidget(
              keyword: keyword,
              onFilterChanged: controller.onFilterChanged,
              expandableController: controller.filterPanelController,
            ),
            Expanded(
              child: DataContent<Illust>(
                sourceList: controller.sourceList,
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
