/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:controller.dart
 * 创建时间:2021/12/5 下午11:00
 * 作者:小草
 */

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/api/model/illust_detail.dart';

class IllustIdSearchController extends GetxController {
  final int id;

  IllustIdSearchController(this.id);

  IllustDetail? illustDetail;

  final CancelToken cancelToken = CancelToken();

  final ApiClient api = Get.find<ApiClient>();

  bool loading = false;

  bool initFailed = false;

  void loadData() {
    loading = true;
    initFailed = false;
    update();
    api.getIllustDetail(id, cancelToken: cancelToken).then((result) {
      illustDetail = result;
    }).catchError((e) {
      initFailed = true;
    }).whenComplete(() {
      loading = false;
      update();
    });
  }
}
