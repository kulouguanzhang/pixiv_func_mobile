import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/lazy_indexed_stack/lazy_indexed_stack.dart';
import 'package:pixiv_func_mobile/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/widgets/select_group/select_group.dart';

import 'controller.dart';
import 'illust/source.dart';
import 'novel/source.dart';

class EveryoneNewContent extends StatefulWidget {
  final bool expandTypeSelector;

  const EveryoneNewContent({Key? key, required this.expandTypeSelector}) : super(key: key);

  @override
  State<EveryoneNewContent> createState() => _EveryoneNewContentState();
}

class _EveryoneNewContentState extends State<EveryoneNewContent> {
  @override
  void didUpdateWidget(covariant EveryoneNewContent oldWidget) {
    if (widget.expandTypeSelector != oldWidget.expandTypeSelector) {
      Get.find<EveryoneNewController>().expandableController.expanded = widget.expandTypeSelector;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(EveryoneNewController());
    return GetBuilder<EveryoneNewController>(
      builder: (controller) => Column(
        children: [
          ExpandablePanel(
            controller: controller.expandableController,
            collapsed: const SizedBox(),
            expanded: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 9),
              child: SelectGroup<WorkType>(
                items: {I18n.illust.tr: WorkType.illust, I18n.manga.tr: WorkType.manga, I18n.novel.tr: WorkType.novel},
                value: controller.workType,
                onChanged: controller.workTypeOnChanged,
              ),
            ),
          ),
          Expanded(
            child: LazyIndexedStack(
              index: controller.workType.index,
              children: [
                DataContent<Illust>(
                  sourceList: EveryoneNewIllustListSource(IllustType.illust),
                  extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
                  itemBuilder: (BuildContext context, Illust item, int index) => IllustPreviewer(illust: item),
                ),
                DataContent<Illust>(
                  sourceList: EveryoneNewIllustListSource(IllustType.manga),
                  extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
                  itemBuilder: (BuildContext context, Illust item, int index) => IllustPreviewer(illust: item),
                ),
                DataContent<Novel>(
                  sourceList: EveryoneNewNovelListSource(),
                  itemBuilder: (BuildContext context, Novel item, int index) => NovelPreviewer(novel: item),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
