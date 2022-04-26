import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/local_data/account_service.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/components/dropdown_menu/dropdown_menu.dart';
import 'package:pixiv_func_mobile/components/sliding_segmented_control/sliding_segmented_control.dart';
import 'package:pixiv_func_mobile/models/dropdown_item.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';
import 'package:pixiv_func_mobile/pages/search/filter_editor/controller.dart';

class SearchFilterEditor extends StatelessWidget {
  final SearchFilter filter;

  const SearchFilterEditor({Key? key, required this.filter}) : super(key: key);

  void _openStartDatePicker(BuildContext context) {
    final controller = Get.find<SearchFilterEditorController>();
    showDatePicker(
      context: context,
      initialDate: controller.dateTimeRange.start,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (null != value) {
        final temp = controller.dateTimeRange;
        //+1年
        final valuePlus1 = DateTime(value.year + 1, value.month, value.day);
        if (temp.end.isAfter(valuePlus1) || value.isAfter(temp.end)) {
          //start差距大于1年
          controller.dateTimeRange = DateTimeRange(
            start: value,
            end: controller.currentDate.isAfter(valuePlus1) ? valuePlus1 : controller.currentDate,
          );
        } else {
          //start差距小于1年
          controller.dateTimeRange = DateTimeRange(start: value, end: temp.end);
        }
      }
    });
  }

  void _openEndDatePicker(BuildContext context) {
    final controller = Get.find<SearchFilterEditorController>();
    showDatePicker(
      context: context,
      initialDate: controller.dateTimeRange.end,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (null != value) {
        final temp = controller.dateTimeRange;
        //-1年
        final minus1 = DateTime(value.year - 1, value.month, value.day);
        if (temp.start.isBefore(minus1) || value.isBefore(temp.start)) {
          //end差距大于1年
          controller.dateTimeRange = DateTimeRange(start: minus1, end: value);
        } else {
          //end差距小于1年
          controller.dateTimeRange = DateTimeRange(start: temp.start, end: value);
        }
      }
    });
  }

  Widget _buildDateRangeTypeEdit() {
    final controller = Get.find<SearchFilterEditorController>();
    return ListTile(
      title: Text(I18n.timeRange.tr),
      trailing: DropdownButtonHideUnderline(
        child: DropdownMenu<int>(
          menuItems: [
            DropdownItem(0, I18n.timeRangeUnlimit.tr),
            DropdownItem(1, I18n.timeRangeOneDay.tr),
            DropdownItem(2, I18n.timeRangeOneWeek.tr),
            DropdownItem(3, I18n.timeRangeOneMonth.tr),
            DropdownItem(4, I18n.timeRangeHalfYear.tr),
            DropdownItem(5, I18n.timeRangeOneYear.tr),
            DropdownItem(-1, I18n.timeRangeCustom.tr),
          ],
          currentValue: controller.dateTimeRangeType,
          onChanged: (int? value) {
            controller.dateTimeRangeType = value!;
            if (!controller.enableDateRange && value != 0) {
              controller.enableDateRange = true;
            }
            switch (value) {
              case 0:
                controller.enableDateRange = false;
                break;
              case 1:
                controller.dateTimeRange = DateTimeRange(
                  start: controller.currentDate.subtract(const Duration(days: 1)),
                  end: controller.currentDate,
                );
                break;
              case 2:
                controller.dateTimeRange = DateTimeRange(
                  start: controller.currentDate.subtract(const Duration(days: 7)),
                  end: controller.currentDate,
                );
                break;
              case 3:
                controller.dateTimeRange = DateTimeRange(
                  start: controller.currentDate.subtract(const Duration(days: 30)),
                  end: controller.currentDate,
                );
                break;
              case 4:
                controller.dateTimeRange = DateTimeRange(
                  start: controller.currentDate.subtract(const Duration(days: 182)),
                  end: controller.currentDate,
                );
                break;
              case 5:
                controller.dateTimeRange = DateTimeRange(
                  start: controller.currentDate.subtract(const Duration(days: 365)),
                  end: controller.currentDate,
                );
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildDateRangeEdit(BuildContext context) {
    final controller = Get.find<SearchFilterEditorController>();
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _openStartDatePicker(context),
            child: Text(
              controller.startDate,
              style: Get.textTheme.headline5,
            ),
          ),
          const Text(' - '),
          InkWell(
            onTap: () => _openEndDatePicker(context),
            child: Text(
              controller.endDate,
              style: Get.textTheme.headline5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SearchFilterEditorController(filter));
    return GetBuilder<SearchFilterEditorController>(
      builder: (SearchFilterEditorController controller) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SlidingSegmentedControl(
                  children: <SearchSort, Widget>{
                    SearchSort.dateDesc: Text(I18n.dateDesc.tr),
                    SearchSort.dateAsc: Text(I18n.dateAsc.tr),
                    SearchSort.popularDesc: Text(I18n.popularDesc.tr),
                  },
                  groupValue: controller.sort,
                  onValueChanged: (SearchSort? value) {
                    if (null != value) {
                      if (SearchSort.popularDesc == value && !Get.find<AccountService>().current!.user.isPremium) {
                        Get.find<PlatformApi>().toast(I18n.noPremiumHint.tr);
                      }
                      controller.sort = value;
                    }
                  },
                  splitEqually: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SlidingSegmentedControl(
                  children: <SearchTarget, Widget>{
                    SearchTarget.partialMatchForTags: Text(I18n.partialMatchForTags.tr),
                    SearchTarget.exactMatchForTags: Text(I18n.exactMatchForTags.tr),
                    SearchTarget.titleAndCaption: Text(I18n.titleAndCaption.tr),
                  },
                  groupValue: controller.target,
                  onValueChanged: (SearchTarget? value) {
                    if (null != value) {
                      controller.target = value;
                    }
                  },
                  splitEqually: false,
                ),
              ),
              const Divider(),
              Text(controller.bookmarkTotalText),
              Slider(
                value: controller.bookmarkTotalSelected.toDouble(),
                min: 0,
                max: controller.bookmarkTotalItems.length - 1,
                divisions: controller.bookmarkTotalItems.length - 1,
                onChanged: (double value) {
                  controller.bookmarkTotalSelected = value.round();
                },
              ),
              const Divider(),
              _buildDateRangeTypeEdit(),
              Visibility(
                visible: controller.dateTimeRangeType == -1,
                child: _buildDateRangeEdit(context),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back(result: SearchFilter.copy(controller.filter));
              },
              child: Text(I18n.confirm.tr),
            ),
          ],
        );
      },
    );
  }
}
