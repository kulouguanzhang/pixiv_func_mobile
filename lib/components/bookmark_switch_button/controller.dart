/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:controller.dart
 * 创建时间:2021/11/23 下午11:33
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/utils/log.dart';

class BookmarkSwitchButtonController extends GetxController {
  final int id;

  final bool isNovel;

  BookmarkSwitchButtonController(
    this.id, {
    required bool initValue,
    required this.isNovel,
  }) : _isBookmarked = initValue;

  bool _isBookmarked;

  bool _requesting = false;

  bool get isBookmarked => _isBookmarked;

  bool get requesting => _requesting;

  void changeBookmarkState() {
    _requesting = true;
    update();

    if (!_isBookmarked) {
      Get.find<ApiClient>().bookmarkAdd(id, isNovel: isNovel).then((result) {
        _isBookmarked = true;
      }).catchError((e) {
        Log.e('添加书签失败', e);
      }).whenComplete(() {
        _requesting = false;
        update();
      });
    } else {
      Get.find<ApiClient>().bookmarkDelete(id, isNovel: isNovel).then((result) {
        _isBookmarked = false;
        update();
      }).catchError((e) {
        Log.e('删除书签失败', e);
      }).whenComplete(() {
        _requesting = false;
        update();
      });
    }
  }
}
