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
  final List<ui.Image> renderImages;
  final List<int> delays;

  GifViewModel({
    required this.renderImages,
    required this.delays,
  });

  final ValueNotifier<int> valueNotifier = ValueNotifier<int>(0);

  bool _dispose = false;

  bool _pause = false;

  bool get pause => _pause;

  set pause(bool value) {
    _pause = value;
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
    Future.delayed(Duration(milliseconds: delays[valueNotifier.value]), () {
      if (!pause) {
        if (valueNotifier.value == renderImages.length - 1) {
          valueNotifier.value = 0;
        } else {
          valueNotifier.value++;
        }
      }
      if (!_dispose) {
        _updateRender();
      }
    });
  }

}
