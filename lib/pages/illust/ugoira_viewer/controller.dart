import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/pages/illust/controller.dart';
import 'package:pixiv_func_mobile/utils/log.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';

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
      PlatformApi.toast('开始获取动图信息');
      try {
        state.ugoiraMetadata = await Get.find<ApiClient>().getUgoiraMetadata(id, cancelToken: cancelToken);
        state.delays.addAll(state.ugoiraMetadata!.ugoiraMetadata.frames.map((frame) => frame.delay));
        Log.i('获取动图信息成功');
      } catch (e) {
        Log.e('获取动图信息失败', e);
        PlatformApi.toast('获取动图信息失败');
        state.loading = false;
        return false;
      }
    }

    if (null == state.gifZipResponse) {
      PlatformApi.toast('开始下载动图压缩包');
      try {
        state.gifZipResponse = await _httpClient.get<Uint8List>(
          Utils.replaceImageSource(
            state.ugoiraMetadata!.ugoiraMetadata.zipUrls.medium,
          ),
        );
      } catch (e) {
        Log.e('下载动图压缩包失败', e);
        PlatformApi.toast('下载动图压缩包失败');
        state.loading = false;
        return false;
      }
    }

    if (state.imageFiles.isEmpty) {
      state.imageFiles.addAll(await PlatformApi.unZipGif(state.gifZipResponse!.data!));
    }

    state.loaded = true;

    return true;
  }

  Future<void> _generateImages() async {
    PlatformApi.toast('开始生成图片 共${state.imageFiles.length}帧');
    bool init = false;
    for (final imageBytes in state.imageFiles) {
      state.images.add(await _loadImage(imageBytes));
      if (!init) {
        init = true;
        final previewWidth = Get.mediaQuery.size.width;

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
        PlatformApi.toast('开始合成图片 共${state.imageFiles.length}帧');
        final saveResult = await PlatformApi.saveGifImage(id, state.imageFiles, state.delays);

        if (Get.isRegistered<IllustController>(tag: 'IllustPage-$id')) {
          Get.find<IllustController>(tag: 'IllustPage-$id').downloadComplete(0, saveResult);
        } else {
          if (saveResult) {
            PlatformApi.toast('保存成功');
          } else {
            PlatformApi.toast('保存失败');
          }
        }
      }
    }
  }
}
