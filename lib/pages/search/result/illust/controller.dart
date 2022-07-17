import 'package:expandable/expandable.dart';
import 'package:get/get.dart';

import 'source.dart';

class SearchIllustResultController extends GetxController {
  SearchIllustResultController(String keyword) : sourceList = SearchIllustResultListSource(keyword);

  final SearchIllustResultListSource sourceList;

  final filterPanelController = ExpandableController();
  bool _expandedFilter = false;

  DateTime lastFilterChangeTime = DateTime.now();

  bool get expandedFilter => _expandedFilter;

  void expandedFilterChangeState() {
    _expandedFilter = !_expandedFilter;
    filterPanelController.expanded = _expandedFilter;
    update();
  }

  void onFilterChanged() {
    lastFilterChangeTime = DateTime.now();
    Future.delayed(const Duration(seconds: 1), () {
      if (DateTime.now().difference(lastFilterChangeTime) > const Duration(seconds: 1)) {
        sourceList.refresh(true);
      }
    });
  }
}
