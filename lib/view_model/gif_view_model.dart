/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:gif_view_model.dart
 * 创建时间:2021/10/20 下午12:51
 * 作者:小草
 */

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class GifViewModel extends BaseViewModel {
  final List<ui.Image> images;
  final List<int> delays;

  GifViewModel({
    required this.images,
    required this.delays,
  });

  final ValueNotifier<int> indexValueNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> pauseValueNotifier = ValueNotifier<bool>(false);

  bool _dispose = false;

  bool get isPause => pauseValueNotifier.value;

  set isPause(bool value) {
    pauseValueNotifier.value = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _dispose = true;
    super.dispose();
  }

  Future<void> start() async {
    Future.sync(_updateRender);
  }

  void _updateRender() {
    Future.delayed(Duration(milliseconds: delays[indexValueNotifier.value]), () {
      if (!isPause) {
        if (indexValueNotifier.value == images.length - 1) {
          indexValueNotifier.value = 0;
        } else {
          indexValueNotifier.value++;
        }
      }
      if (!_dispose) {
        _updateRender();
      }
    });
  }
}
