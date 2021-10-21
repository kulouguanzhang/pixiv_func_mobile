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

  UgoiraViewerModel(this.id);

  final CancelToken cancelToken = CancelToken();

  final List<Uint8List> images = [];

  final List<ui.Image> renderImages = [];

  final List<int> delays = [];

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
        _gifZipResponse = await Dio(
          BaseOptions(
            headers: {'Referer': 'https://app-api.pixiv.net/'},
            responseType: ResponseType.bytes,
            sendTimeout: 6000,
            //60秒
            receiveTimeout: 60000,
            connectTimeout: 6000,
          ),
        ).get<Uint8List>(Utils.replaceImageSource(_ugoiraMetadata!.ugoiraMetadata.zipUrls.medium));
      } catch (e) {
        Log.e('下载动图压缩包失败', e);
        platformAPI.toast('下载动图压缩包失败');
        _loading = false;
        return false;
      }
    }
    if (images.isEmpty) {
      images.addAll(await platformAPI.unZipGif(id: id, zipBytes: _gifZipResponse!.data!, delays: delays));
    }
    _loaded = true;

    _loading = false;
    return true;
  }

  Future<void> generateImages() async {
    Log.i('开始生成图片共${images.length}帧');
    platformAPI.toast('开始生成图片共${images.length}帧');
    for (final imageBytes in images) {
      renderImages.add(await _loadImage(imageBytes));
    }
  }

  void play() {
    setBusy();
    Future.sync(playRoutine);
  }

  void save() {
    Future.sync(saveRoutine);
  }

  Future<void> playRoutine() async {
    if (_loading) {
      Future.delayed(const Duration(milliseconds: 333), playRoutine);
    } else {
      if (_loaded || !_loaded && await loadData()) {
        await generateImages();
        initialized = true;
      }
      setIdle();
    }
  }

  Future<void> saveRoutine() async {
    if (_loading) {
      Future.delayed(const Duration(milliseconds: 333), saveRoutine);
    } else {
      if (_loaded || !_loaded && await loadData()) {
        platformAPI.toast('动图共${images.length}帧,合成可能需要一些时间');
        final result = await platformAPI.saveGifImage(id, images, delays);
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
