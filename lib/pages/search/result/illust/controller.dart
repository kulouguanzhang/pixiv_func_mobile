import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';

class SearchIllustResultController extends GetxController {
  final filterPanelController = ExpandableController();
  final editFilterPanelController = ExpandableController();

  final SearchFilter filter = SearchFilter.create();

  final filterItems = <int, bool?>{};

  bool _expandedFilter = false;

  bool get editFilter => _expandedFilter;

  bool _editFilter = false;

  bool get editFilterTarget => _editFilter;

  void expandedFilterChangeState() {
    _expandedFilter = !_expandedFilter;
    filterPanelController.expanded = _expandedFilter;
    update();
  }

  void editFilterChangeState(int index) {
    if (filterItems[index] == null) {
      filterItems.clear();
      filterItems[index] = true;
    } else {
      filterItems.clear();
    }
    _editFilter = filterItems.values.contains(true);
    editFilterPanelController.expanded = _editFilter;
    update();
  }

  set target(SearchTarget value) {
    filter.target = value;
    update();
  }

  set sort(SearchSort value) {
    filter.sort = value;
    update();
  }

  set enableDateRange(bool value) {
    filter.enableDateRange = value;
    update();
  }



  int get editFilterIndex => filterItems.keys.toList().firstWhereOrNull((key) => filterItems[key] == true) ?? -1;

  String get targetName {
    switch (filter.target) {
      case SearchTarget.partialMatchForTags:
        return '标签(部分匹配)';
      case SearchTarget.exactMatchForTags:
        return '标签(完全匹配)';
      case SearchTarget.titleAndCaption:
        return '标题&简介';
    }
  }

  String get sortName {
    switch (filter.sort) {
      case SearchSort.dateDesc:
        return '时间降序';
      case SearchSort.dateAsc:
        return '时间升序';
      case SearchSort.popularDesc:
        return '热度降序';
    }
  }
}
