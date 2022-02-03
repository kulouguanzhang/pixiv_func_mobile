/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:controller.dart
 * 创建时间:2021/11/28 下午1:38
 * 作者:小草
 */

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/i18n/i18n.dart';
import 'package:pixiv_func_android/app/platform/api/platform_api.dart';
import 'package:pixiv_func_android/utils/log.dart';
import 'package:pixiv_func_android/utils/utils.dart';

import 'state.dart';

class UgoiraViewerController extends GetxController {
  final int id;

  UgoiraViewerController(this.id);

  final UgoiraViewerState state = UgoiraViewerState();

  final CancelToken cancelToken = CancelToken();

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
    state.loading = true;
    update();
    if (null == state.ugoiraMetadata) {
      Get.find<PlatformApi>().toast(I18n.ugoiraLoadStartHint.tr);
      try {
        state.ugoiraMetadata = await Get.find<ApiClient>().getUgoiraMetadata(id, cancelToken: cancelToken);
        state.delays.addAll(state.ugoiraMetadata!.ugoiraMetadata.frames.map((frame) => frame.delay));
        Log.i('获取动图信息成功');
      } catch (e) {
        Log.e('获取动图信息失败', e);
        Get.find<PlatformApi>().toast(I18n.ugoiraLoadFailedHint.tr);
        state.loading = false;
        return false;
      }
    }

    if (null == state.gifZipResponse) {
      Get.find<PlatformApi>().toast(I18n.ugoiraDownloadStartHint.tr);
      try {
        state.gifZipResponse = await _httpClient.get<Uint8List>(
          Utils.replaceImageSource(
            state.ugoiraMetadata!.ugoiraMetadata.zipUrls.medium,
          ),
        );
      } catch (e) {
        Log.e('下载动图压缩包失败', e);
        Get.find<PlatformApi>().toast(I18n.ugoiraDownloadFailedHint.tr);
        state.loading = false;
        return false;
      }
    }

    if (state.imageFiles.isEmpty) {
      state.imageFiles.addAll(await Get.find<PlatformApi>().unZipGif(state.gifZipResponse!.data!));
    }

    state.loaded = true;

    return true;
  }

  Future<void> _generateImages() async {
    Get.find<PlatformApi>().toast('${I18n.ugoiraGenerateStartHint.tr}${state.imageFiles.length}${I18n.frame.tr}');
    bool init = false;
    for (final imageBytes in state.imageFiles) {
      state.images.add(await _loadImage(imageBytes));
      if (!init) {
        init = true;
        final previewWidth = state.images.first.width > Get.mediaQuery.size.width ? Get.mediaQuery.size.width : state.images.first.width.toDouble();
        final previewHeight = previewWidth / state.images.first.width * state.images.first.height.toDouble();
        state.size = ui.Size(previewWidth, previewHeight.toDouble());
      }
    }
  }

  void play() {
    Future.sync(_playRoutine);
  }

  void save() {
    Future.sync(_saveRoutine);
  }

  Future<void> _playRoutine() async {
    if (state.loading) {
      Future.delayed(const Duration(milliseconds: 333), _playRoutine);
    } else {
      if (state.loaded || !state.loaded && await loadData()) {
        await _generateImages();
        state.loading = false;
        state.init = true;
        update();
      }
    }
  }

  Future<void> _saveRoutine() async {
    if (state.loading) {
      Future.delayed(const Duration(milliseconds: 333), _saveRoutine);
    } else {
      if (state.loaded || !state.loaded && await loadData()) {
        state.loading = false;
        update();
        Get.find<PlatformApi>().toast('${I18n.ugoiraSaveStartHint.tr} ${state.imageFiles.length}${I18n.frame.tr}');
        final result = await Get.find<PlatformApi>().saveGifImage(id, state.imageFiles, state.delays);

        if (null == result) {
          Get.find<PlatformApi>().toast(I18n.imageIsExist.tr);
        } else {
          if (result) {
            Get.find<PlatformApi>().toast(I18n.saveSuccess.tr);
          } else {
            Get.find<PlatformApi>().toast(I18n.saveFailed.tr);
          }
        }
      }
    }
  }
}
