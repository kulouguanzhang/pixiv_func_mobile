import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/lazy_indexed_stack/lazy_indexed_stack.dart';
import 'package:pixiv_func_mobile/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/widgets/select_group/select_group.dart';

import 'controller.dart';
import 'illust/source.dart';
import 'novel/source.dart';

class UserWorkContent extends StatefulWidget {
  final int id;
  final bool expandTypeSelector;

  const UserWorkContent({Key? key, required this.id, required this.expandTypeSelector}) : super(key: key);

  @override
  State<UserWorkContent> createState() => _UserWorkContentState();
}

class _UserWorkContentState extends State<UserWorkContent> {
  @override
  void didUpdateWidget(covariant UserWorkContent oldWidget) {
    if (widget.expandTypeSelector != oldWidget.expandTypeSelector) {
      Get.find<UserWorkController>().expandableController.expanded = widget.expandTypeSelector;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserWorkController());
    return GetBuilder<UserWorkController>(
      builder: (controller) => Column(
        children: [
          ExpandablePanel(
            controller: controller.expandableController,
            collapsed: const SizedBox(),
            expanded: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 9),
              child: SelectGroup<WorkType>(
                items: const {'插画': WorkType.illust, '漫画': WorkType.manga, '小说': WorkType.novel},
                value: controller.workType,
                onChanged: controller.workTypeOnChanged,
              ),
            ),
          ),
          Expanded(
            child: LazyIndexedStack(
              index: controller.workType == WorkType.illust ? 0 : 1,
              children: [
                DataContent<Illust>(
                  sourceList: UserIllustListSource(widget.id, IllustType.illust),
                  extendedListDelegate:
                      const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
                  itemBuilder: (BuildContext context, Illust item, int index) => IllustPreviewer(illust: item, showUserName: false),
                ),
                DataContent<Illust>(
                  sourceList: UserIllustListSource(widget.id, IllustType.manga),
                  extendedListDelegate:
                      const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
                  itemBuilder: (BuildContext context, Illust item, int index) => IllustPreviewer(illust: item, showUserName: false),
                ),
                DataContent<Novel>(
                  sourceList: UserNovelListSource(widget.id),
                  itemBuilder: (BuildContext context, Novel item, int index) => NovelPreviewer(novel: item, showUserName: false),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
