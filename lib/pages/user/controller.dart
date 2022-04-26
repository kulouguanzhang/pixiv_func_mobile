import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';

class UserController extends GetxController {
  final int id;

  UserController(this.id);

  final CancelToken cancelToken = CancelToken();

  UserDetailResult? userDetailResult;

  bool error = false;

  bool notFound = false;

  bool loading = false;

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  void loadData() {
    userDetailResult = null;
    error = false;
    notFound = false;
    loading = true;
    update();
    Get.find<ApiClient>().getUserDetail(id, cancelToken: cancelToken).then((result) {
      userDetailResult = result;
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
