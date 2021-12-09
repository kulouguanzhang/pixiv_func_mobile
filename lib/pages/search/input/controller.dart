/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:controller.dart
 * 创建时间:2021/11/29 下午12:45
 * 作者:小草
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/platform/api/platform_api.dart';
import 'package:pixiv_func_android/models/search_filter.dart';
import 'package:pixiv_func_android/pages/illust/illust.dart';
import 'package:pixiv_func_android/pages/novel/novel.dart';
import 'package:pixiv_func_android/pages/search/input/state.dart';
import 'package:pixiv_func_android/pages/search/result/illust/illust_result.dart';
import 'package:pixiv_func_android/pages/search/result/image/image.dart';
import 'package:pixiv_func_android/pages/search/result/novel/novel_result.dart';
import 'package:pixiv_func_android/pages/search/result/user/user_result.dart';
import 'package:pixiv_func_android/pages/user/user.dart';
import 'package:pixiv_func_android/utils/log.dart';

class SearchInputController extends GetxController {
  final SearchInputState state = SearchInputState();

  CancelToken? autocompleteCancelToken;
  CancelToken? queryIllustCancelToken;

  @override
  void dispose() {
    autocompleteCancelToken?.cancel();
    autocompleteCancelToken = null;
    queryIllustCancelToken?.cancel();
    autocompleteCancelToken = null;
    super.dispose();
  }

  void typeOnChanged(int? value) {
    if (null != value) {
      state.type = value;
      update();
    }
  }

  void wordInputOnChanged(String value) {
    if (value.isNotEmpty) {
      state.lastInputTime = DateTime.now();
      startAutocomplete();
    } else {
      state.searchAutocomplete = null;
    }
    update();
  }

  void filterOnChanged(SearchFilter? value) {
    if (null != value) {
      state.filter = value;
    }
  }

  void typeValueOnChanged(int? value) {
    if (null != value) {
      state.type = value;
      update();
    }
  }

  void toSearchResultPage(String value) {
    switch (state.type) {
      case 0:
        Get.to(SearchIllustResultPage(word: value, filter: state.filter));
        break;
      case 1:
        Get.to(SearchNovelResultPage(word: value, filter: state.filter));
        break;
      case 2:
        Get.to(SearchUserResultPage(word: value));
        break;
    }
  }

  void toIllustPageById() {
    queryIllustCancelToken = CancelToken();

    Get.find<ApiClient>().getIllustDetail(state.inputAsNumber, cancelToken: queryIllustCancelToken!).then(
      (value) {
        if (true == Get.isDialogOpen) {
          Get.back(result: false);
          Get.to(IllustPage(illust: value.illust));
        }
      },
    ).catchError(
      (e) {
        if (e is DioError) {
          if (DioErrorType.cancel == e.type) {
            Log.i('取消搜索插画ID:${state.inputAsNumber}');
          } else {
            if (true == Get.isDialogOpen) {
              Get.back(result: false);
            }

            if (HttpStatus.notFound == e.response?.statusCode) {
              Log.i('插画ID不存在${state.inputAsNumber}', e);
              Get.find<PlatformApi>().toast('插画ID不存在${state.inputAsNumber}');
            } else {
              Log.e('查询插画信息异常', e);
              Get.find<PlatformApi>().toast('搜索插画ID失败');
            }
          }
        }
      },
    );

    Get.defaultDialog<bool>(
      title: '搜索插画ID${state.inputAsNumber}',
      content: const CircularProgressIndicator(),
      cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text('取消')),
    ).then((value) {
      if (true != value) {
        queryIllustCancelToken?.cancel();
        queryIllustCancelToken = null;
      }
    });
  }

  void toNovelPageById() {
    Get.to(NovelPage(id: state.inputAsNumber));
  }

  void toUserPageById() {
    Get.to(UserPage(id: state.inputAsNumber));
  }

  void searchImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((picker) async {
      if (null != picker) {
        picker.readAsBytes();
        Get.to(
          SearchImageResultPage(
            imageBytes: await picker.readAsBytes(),
            filename: picker.name,
          ),
        );
      }
    });
  }

  void startAutocomplete() {
    Future.delayed(const Duration(seconds: 1), () {
      if (DateTime.now().difference(state.lastInputTime) > const Duration(seconds: 1)) {
        loadAutocomplete();
      }
    });
  }

  void loadAutocomplete() {
    if (state.inputAsString.isEmpty) {
      return;
    }
    if (null != autocompleteCancelToken) {
      autocompleteCancelToken!.cancel();
    }

    autocompleteCancelToken = CancelToken();
    state.searchAutocomplete = null;
    update();
    Get.find<ApiClient>().searchAutocomplete(state.inputAsString, cancelToken: autocompleteCancelToken!).then((result) {
      state.searchAutocomplete = result;
      update();
    }).catchError((e, s) {
      Log.e('关键字自动补全失败', e, s);
    });
  }
}
