import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/tag.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/pages/search/result/illust/search_illust_result.dart';
import 'package:pixiv_func_mobile/pages/search/result/user/search_user_result.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class SearchController extends GetxController {
  final TabController tabController;

  SearchController(TickerProvider vsync) : tabController = TabController(length: 3, vsync: vsync);

  final focusNode = FocusNode();

  late final searchContentInput = TextEditingController();

  final List<Tag> autocompleteTags = [];

  bool get inputIsNumber => null != int.tryParse(searchContentInput.text);

  int get inputAsNumber => int.parse(searchContentInput.text);

  String get inputAsString => searchContentInput.text;

  DateTime lastInputTime = DateTime.now();

  CancelToken? autocompleteCancelToken;
  CancelToken? queryIllustCancelToken;

  void toSearchResultPage(String value) async {
    focusNode.unfocus();
    switch (tabController.index) {
      case 0:
        Navigator.push(
          Get.context!,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
                SearchIllustResultPage(keyword: value),
          ),
        );
        break;
      case 1:
        // Get.to(SearchNovelResultPage(word: value));
        break;
      case 2:
        Navigator.push(
          Get.context!,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
                SearchUserResultPage(keyword: value),
          ),
        );
        // Get.to(SearchUserResultPage(keyword: value));
        break;
    }
  }

  void searchContentOnChanged(String value) {
    if (value.isNotEmpty) {
      lastInputTime = DateTime.now();
      startAutocomplete();
    } else {
      autocompleteTags.clear();
    }
    update();
  }

  void startAutocomplete() {
    Future.delayed(const Duration(seconds: 1), () {
      if (DateTime.now().difference(lastInputTime) > const Duration(seconds: 1)) {
        loadAutocomplete();
      }
    });
  }

  void loadAutocomplete() {
    if (inputAsString.isEmpty) {
      return;
    }
    if (null != autocompleteCancelToken) {
      autocompleteCancelToken!.cancel();
    }

    autocompleteCancelToken = CancelToken();
    autocompleteTags.clear();
    update();
    Get.find<ApiClient>().getSearchAutocomplete(inputAsString, cancelToken: autocompleteCancelToken!).then((result) {
      autocompleteTags.addAll(result.tags);
      update();
    }).catchError((e) {
      Log.e('关键字自动补全失败', e);
    });
  }
}
