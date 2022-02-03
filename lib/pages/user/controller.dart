/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:controller.dart
 * 创建时间:2021/11/25 下午10:34
 * 作者:小草
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/api/dto/user_detail.dart';

class UserController extends GetxController {
  final int id;

  UserController(this.id);

  final CancelToken cancelToken = CancelToken();

  UserDetail? userDetail;

  bool error = false;

  bool notFound = false;

  bool loading = false;

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  void loadData() {
    userDetail = null;
    error = false;
    notFound = false;
    loading = true;
    update();
    Get.find<ApiClient>().getUserDetail(id, cancelToken: cancelToken).then((result) {
      userDetail = result;
    }).catchError((e) {
      if (e is DioError && HttpStatus.notFound == e.response?.statusCode) {
        notFound = true;
      } else {
        error = true;
      }
    }).whenComplete(() {
      loading = false;
      update();
    });
  }
}
