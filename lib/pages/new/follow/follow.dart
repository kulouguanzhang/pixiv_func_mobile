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
import 'package:pixiv_func_mobile/widgets/dropdown/dropdown.dart';
import 'package:pixiv_func_mobile/widgets/select_group/select_group.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';
import 'illust/source.dart';
import 'novel/source.dart';

class FollowNewContent extends StatefulWidget {
  final bool expandTypeSelector;

  const FollowNewContent({Key? key, required this.expandTypeSelector}) : super(key: key);

  @override
  State<FollowNewContent> createState() => _FollowNewContentState();
}

class _FollowNewContentState extends State<FollowNewContent> {
  @override
  void didUpdateWidget(covariant FollowNewContent oldWidget) {
    if (widget.expandTypeSelector != oldWidget.expandTypeSelector) {
      Get.find<FollowNewController>().expandableController.expanded = widget.expandTypeSelector;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final items = {
      null: '全部',
      Restrict.public: '公开',
      Restrict.private: '悄悄',
    };
    Get.put(FollowNewController());
    return GetBuilder<FollowNewController>(
      builder: (controller) => Column(
        children: [
          ExpandablePanel(
            controller: controller.expandableController,
            collapsed: const SizedBox(),
            expanded: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectGroup<WorkType>(
                    items: const {'插画&漫画': WorkType.illust, '小说': WorkType.novel},
                    value: controller.workType,
                    onChanged: controller.workTypeOnChanged,
                  ),
                  SizedBox(
                    height: 35,
                    width: 70,
                    child: DropdownButtonWidgetHideUnderline(
                      child: DropdownButtonWidget<Restrict?>(
                        isDense: true,
                        elevation: 0,
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        items: [
                          for (final item in items.entries)
                            DropdownMenuItemWidget<Restrict?>(
                              value: item.key,
                              child: Container(
                                height: 35,
                                width: 70,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  border: controller.restrict == item.key ? Border.all(color: Theme.of(context).colorScheme.primary) : null,
                                  color: Get.theme.colorScheme.surface,
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    const Icon(Icons.cached_outlined),
                                    const SizedBox(width: 7),
                                    TextWidget(
                                      item.value,
                                      fontSize: 14,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                        ],
                        value: controller.restrict,
                        onChanged: controller.restrictOnChanged,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: LazyIndexedStack(
              index: controller.workType == WorkType.illust ? 0 : 1,
              children: [
                DataContent<Illust>(
                  sourceList: FollowNewIllustListSource(controller.restrict),
                  extendedListDelegate:
                      const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 10),
                  itemBuilder: (BuildContext context, Illust item, int index) => IllustPreviewer(illust: item),
                ),
                DataContent<Novel>(
                  sourceList: FollowNewNovelListSource(controller.restrict),
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
