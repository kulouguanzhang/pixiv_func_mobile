import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/pages/search/filter_editor/search_filter_editor.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class SearchNovelResultPage extends StatelessWidget {
  final String keyword;

  const SearchNovelResultPage({Key? key, required this.keyword}) : super(key: key);

  String get controllerTag => '$runtimeType-$keyword';

  @override
  Widget build(BuildContext context) {
    Get.put(SearchNovelResultController(keyword), tag: controllerTag);
    return GetBuilder<SearchNovelResultController>(
      tag: controllerTag,
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
                child: TextWidget('取消', color: Theme.of(context).colorScheme.onSecondary),
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
              child: DataContent<Novel>(
                sourceList: controller.sourceList,
                itemBuilder: (BuildContext context, Novel item, int index) => NovelPreviewer(novel: item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
