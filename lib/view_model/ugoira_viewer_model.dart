/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ugoira_viewer_model.dart
 * 创建时间:2021/10/20 下午4:49
 * 作者:小草
 */

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:pixiv_func_android/api/model/ugoira_metadata.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_state_model.dart';
import 'package:pixiv_func_android/util/utils.dart';

class UgoiraViewerModel extends BaseViewStateModel {
  final int id;
  final double maxWidth;

  UgoiraViewerModel(this.id, this.maxWidth);

  final CancelToken cancelToken = CancelToken();

  final List<Uint8List> imageFiles = [];

  final List<ui.Image> images = [];

  final List<int> delays = [];

  ui.Size size = ui.Size.zero;

  final Dio _httpClient = Dio(
    BaseOptions(
      headers: {'Referer': 'https://app-api.pixiv.net/'},
      responseType: ResponseType.bytes,
      sendTimeout: 6000,
      //60秒
      receiveTimeout: 60000,
      connectTimeout: 6000,
    ),
  );

  UgoiraMetadata? _ugoiraMetadata;

  Response<Uint8List>? _gifZipResponse;

  bool _loaded = false;

  bool _loading = false;

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  Future<ui.Image> _loadImage(Uint8List bytes) async {
    final coder = await ui.instantiateImageCodec(bytes);

    final frame = await coder.getNextFrame();

    return frame.image;
  }

  Future<bool> loadData() async {
    _loading = true;
    if (null == _ugoiraMetadata) {
      platformAPI.toast('开始获取动图信息');
      try {
        _ugoiraMetadata = await pixivAPI.getUgoiraMetadata(id, cancelToken: cancelToken);
        delays.addAll(_ugoiraMetadata!.ugoiraMetadata.frames.map((frame) => frame.delay));
        Log.i('获取动图信息成功');
      } catch (e) {
        Log.e('获取动图信息失败', e);
        platformAPI.toast('获取动图信息失败');
        _loading = false;
        return false;
      }
    }

    if (null == _gifZipResponse) {
      platformAPI.toast('开始下载动图压缩包');
      try {
        _gifZipResponse = await _httpClient.get<Uint8List>(
          Utils.replaceImageSource(
            _ugoiraMetadata!.ugoiraMetadata.zipUrls.medium,
          ),
        );
      } catch (e) {
        Log.e('下载动图压缩包失败', e);
        platformAPI.toast('下载动图压缩包失败');
        _loading = false;
        return false;
      }
    }

    if (imageFiles.isEmpty) {
      imageFiles.addAll(await platformAPI.unZipGif(_gifZipResponse!.data!));
    }

    _loaded = true;
    _loading = false;
    return true;
  }

  Future<void> _generateImages() async {
    Log.i('开始生成图片共${imageFiles.length}帧');
    platformAPI.toast('开始生成图片共${imageFiles.length}帧');
    bool init = false;
    for (final imageBytes in imageFiles) {
      images.add(await _loadImage(imageBytes));
      if (!init) {
        init = true;
        final previewWidth = images.first.width > maxWidth ? maxWidth : images.first.width.toDouble();
        final previewHeight = previewWidth / images.first.width * images.first.height.toDouble();
        size = ui.Size(previewWidth, previewHeight.toDouble());
      }
    }
  }

  void play() {
    setBusy();
    Future.sync(_playRoutine);
  }

  void save() {
    Future.sync(_saveRoutine);
  }

  Future<void> _playRoutine() async {
    if (_loading) {
      Future.delayed(const Duration(milliseconds: 333), _playRoutine);
    } else {
      if (_loaded || !_loaded && await loadData()) {
        await _generateImages();
        initialized = true;
      }
      setIdle();
    }
  }

  Future<void> _saveRoutine() async {
    if (_loading) {
      Future.delayed(const Duration(milliseconds: 333), _saveRoutine);
    } else {
      if (_loaded || !_loaded && await loadData()) {
        platformAPI.toast('动图共${imageFiles.length}帧,合成可能需要一些时间');
        final result = await platformAPI.saveGifImage(id, imageFiles, delays);
        if (null == result) {
          platformAPI.toast('动图已经存在');
        } else {
          if (result) {
            platformAPI.toast('保存动图成功');
          } else {
            platformAPI.toast('保存动图失败');
          }
        }
      }
    }
  }
}
