import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/data/account_service.dart';

class UserController extends GetxController {
  final int id;

  UserController(this.id, TickerProvider vsync) : tabController = TabController(length: 4, vsync: vsync);
  final TabController tabController;
  final CancelToken cancelToken = CancelToken();

  UserDetailResult? userDetailResult;

  Restrict _restrict = Restrict.public;

  Restrict get restrict => _restrict;

  int _previousTabIndex = 0;

  bool _expandTypeSelector = false;

  bool get expandTypeSelector => _expandTypeSelector;

  void restrictOnChanged(Restrict? value) {
    if (null != value) {
      _restrict = value;
      update();
    }
  }

  void refreshData() {
    userDetailResult = null;

    update();
    Get.find<ApiClient>().getUserDetail(id, cancelToken: cancelToken).then((result) {
      userDetailResult = result;
    }).catchError((e) {
      if (e is DioError && HttpStatus.notFound == e.response?.statusCode) {
        // notFound = true;
      } else {
        // error = true;
      }
    }).whenComplete(() {
      // loading = false;
      update();
    });
  }

  void tabIndexOnChanged(int index) {
    if (index == _previousTabIndex) {
      _expandTypeSelector = !_expandTypeSelector;
    }
    _previousTabIndex = index;
    update();
  }

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    cancelToken.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    refreshData();
    super.onInit();
  }
}

class MeController extends GetxController implements GetxService {
  MeController(TickerProvider vsync) : tabController = TabController(length: 4, vsync: vsync);
  final TabController tabController;
  final CancelToken cancelToken = CancelToken();

  int get currentUserId => Get.find<AccountService>().currentUserId;

  UserDetailResult? userDetailResult;

  Restrict _restrict = Restrict.public;

  Restrict get restrict => _restrict;

  int _previousTabIndex = 0;

  bool _expandTypeSelector = false;

  bool get expandTypeSelector => _expandTypeSelector;

  void restrictOnChanged(Restrict? value) {
    if (null != value) {
      _restrict = value;
      update();
    }
  }

  void refreshData() {
    userDetailResult = null;

    update();
    Get.find<ApiClient>().getUserDetail(Get.find<AccountService>().currentUserId, cancelToken: cancelToken).then((result) {
      userDetailResult = result;
    }).catchError((e) {
      if (e is DioError && HttpStatus.notFound == e.response?.statusCode) {
        // notFound = true;
      } else {
        // error = true;
      }
    }).whenComplete(() {
      // loading = false;
      update();
    });
  }

  void tabIndexOnChanged(int index) {
    if (index == _previousTabIndex) {
      _expandTypeSelector = !_expandTypeSelector;
    }
    _previousTabIndex = index;
    update();
  }

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    cancelToken.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    refreshData();
    super.onInit();
  }
}
