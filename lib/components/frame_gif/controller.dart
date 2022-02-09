/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:controller.dart
 * 创建时间:2021/11/28 下午6:23
 * 作者:小草
 */

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FrameGifController extends GetxController {
  final List<ui.Image> images;
  final List<int> delays;

  FrameGifController(
    this.images,
    this.delays,
  );

  final ValueNotifier<int> indexValueNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> pauseValueNotifier = ValueNotifier<bool>(false);

  bool playing = false;

  bool get isPause => pauseValueNotifier.value;

  void pauseStateChange() {
    pauseValueNotifier.value = !isPause;
    update();
  }

  Future<void> start() async {
    playing = true;
    Future.sync(_updateRender);
  }

  void stop() {
    playing = false;
  }

  void _updateRender() {
    Future.delayed(
      Duration(milliseconds: delays[indexValueNotifier.value]),
      () {
        if (!isPause) {
          if (indexValueNotifier.value == images.length - 1) {
            indexValueNotifier.value = 0;
          } else {
            indexValueNotifier.value++;
          }
        }
        if (playing) {
          _updateRender();
        }
      },
    );
  }
}
