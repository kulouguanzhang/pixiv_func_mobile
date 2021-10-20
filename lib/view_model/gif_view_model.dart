/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:gif_view_model.dart
 * 创建时间:2021/10/20 下午12:51
 * 作者:小草
 */

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_state_model.dart';

class GifViewModel extends BaseViewStateModel {
  final BuildContext context;
  final List<Uint8List> images;
  final List<int> delays;

  GifViewModel({
    required this.context,
    required this.images,
    required this.delays,
  });

  final renderImages = <ui.Image>[];

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

  Future<ui.Image> _loadImage(Uint8List bytes) async {
    final coder = await ui.instantiateImageCodec(bytes);
    final frame = await coder.getNextFrame();
    return frame.image;
  }

  Future<void> start() async {
    setBusy();
    for (final bytes in images) {
      renderImages.add(await _loadImage(bytes));
    }
    initialized = true;
    setIdle();
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

  void save(int id) {
    platformAPI.toast('共${images.length}帧,合成可能需要一些时间');
    platformAPI.saveGifImage(id, images, delays).then((result){
      platformAPI.toast('保存动图成功');
    });
  }
}
