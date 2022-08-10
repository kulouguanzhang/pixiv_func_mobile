import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/widgets/dropdown/dropdown.dart';
import 'package:pixiv_func_mobile/widgets/select_group/select_group.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class SearchNovelFilterEditorWidget extends StatelessWidget {
  final String keyword;
  final VoidCallback onFilterChanged;
  final ExpandableController expandableController;

  const SearchNovelFilterEditorWidget({Key? key, required this.keyword, required this.onFilterChanged, required this.expandableController})
      : super(key: key);

  String get controllerTag => 'SearchNovelFilterEditor-$keyword';

  void _openStartDatePicker() {
    final controller = Get.find<SearchNovelFilterEditorController>(tag: controllerTag);
    showDatePicker(
      context: Get.context!,
      initialDate: controller.dateRange.start,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (null != value) {
        final currentDate = DateTime.now();
        final temp = controller.dateRange;
        //+1年
        final valuePlus1 = DateTime(value.year + 1, value.month, value.day);
        if (temp.end.isAfter(valuePlus1) || value.isAfter(temp.end)) {
          //start差距大于1年
          controller.dateRangeOnChanged(DateTimeRange(start: value, end: currentDate.isAfter(valuePlus1) ? valuePlus1 : currentDate));
        } else {
          //start差距小于1年
          controller.dateRangeOnChanged(DateTimeRange(start: value, end: temp.end));
        }
      }
    });
  }

  void _openEndDatePicker() {
    final controller = Get.find<SearchNovelFilterEditorController>(tag: controllerTag);
    showDatePicker(
      context: Get.context!,
      initialDate: controller.dateRange.end,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (null != value) {
        final temp = controller.dateRange;
        //-1年
        final minus1 = DateTime(value.year - 1, value.month, value.day);
        if (temp.start.isBefore(minus1) || value.isBefore(temp.start)) {
          //end差距大于1年
          controller.dateRangeOnChanged(DateTimeRange(start: minus1, end: value));
        } else {
          //end差距小于1年
          controller.dateRangeOnChanged(DateTimeRange(start: temp.start, end: value));
        }
      }
    });
  }

  Widget _buildDateRangeEdit() {
    final controller = Get.find<SearchNovelFilterEditorController>(tag: controllerTag);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openStartDatePicker(),
          child: TextWidget(controller.startDate, fontSize: 16, forceStrutHeight: true),
        ),
        const Text(' - '),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openEndDatePicker(),
          child: TextWidget(controller.endDate, fontSize: 16, forceStrutHeight: true),
        ),
      ],
    );
  }

  Widget _buildDateRangeTypeEdit() {
    final controller = Get.find<SearchNovelFilterEditorController>(tag: controllerTag);
    final items = {
      0: '无限制',
      1: '一天内',
      2: '一周内',
      3: '一月内',
      4: '半年内',
      5: '一年内',
      6: '自定义',
    };
    return SizedBox(
      height: 35,
      width: 90,
      child: DropdownButtonWidgetHideUnderline(
        child: DropdownButtonWidget<int>(
          isDense: true,
          elevation: 0,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          items: [
            for (final item in items.entries)
              DropdownMenuItemWidget<int>(
                value: item.key,
                child: Container(
                  height: 35,
                  width: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    border: controller.dateRangeType == item.key ? Border.all(color: Get.theme.colorScheme.primary) : null,
                    color: Get.theme.colorScheme.surface,
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      const Icon(AppIcons.toggle, size: 12),
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
          value: controller.dateRangeType,
          onChanged: controller.dateTimeRangeTypeOnChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchNovelFilterEditorController>(
      tag: controllerTag,
      builder: (controller) => ExpandablePanel(
        controller: expandableController,
        collapsed: const SizedBox(),
        expanded: Padding(
          padding: const EdgeInsets.fromLTRB(28, 5, 28, 12),
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
                        const TextWidget('搜索方式', fontSize: 14),
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
                  final Widget widget;
                  switch (controller.editFilterIndex) {
                    case 0:
                      widget = SelectGroup<SearchSort>(
                        items: const {
                          '时间降序': SearchSort.dateDesc,
                          '时间升序': SearchSort.dateAsc,
                          '热度降序': SearchSort.popularDesc,
                        },
                        value: controller.sort,
                        onChanged: controller.searchSortOnChanged,
                      );
                      break;
                    case 1:
                      widget = SelectGroup<SearchNovelTarget>(
                        items: const {
                          '标签(部分)': SearchNovelTarget.partialMatchForTags,
                          '标签(完全)': SearchNovelTarget.exactMatchForTags,
                          '尾巴': SearchNovelTarget.text,
                          '关键字': SearchNovelTarget.keyword,
                        },
                        value: controller.target,
                        onChanged: controller.searchNovelTargetOnChanged,
                      );
                      break;
                    case 2:
                      widget = Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDateRangeTypeEdit(),
                          if (controller.dateRangeType == 6) _buildDateRangeEdit(),
                        ],
                      );
                      break;
                    case 3:
                      widget = Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Slider(
                              value: controller.bookmarkTotalSelected.toDouble(),
                              min: 0,
                              max: controller.bookmarkTotalItems.length - 1,
                              divisions: controller.bookmarkTotalItems.length - 1,
                              onChanged: controller.bookmarkTotalSliderOnChange,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextWidget(controller.bookmarkTotalText, fontSize: 14),
                          )
                        ],
                      );
                      break;
                    default:
                      widget = const SizedBox();
                      break;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      child: widget,
                    ),
                  );
                }(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
