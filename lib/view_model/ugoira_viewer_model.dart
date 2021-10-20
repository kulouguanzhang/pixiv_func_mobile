/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ugoira_viewer_model.dart
 * 创建时间:2021/10/20 下午4:49
 * 作者:小草
 */

import 'dart:typed_data';

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

  UgoiraMetadata? _ugoiraMetadata;

  List<Uint8List> images = [];

  final List<int> delays = [];

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }

  Future<void> loadData() async {
    setBusy();
    if (null == _ugoiraMetadata) {
      platformAPI.toast('开始获取动图信息');
      try {
        _ugoiraMetadata = await pixivAPI.getUgoiraMetadata(id, cancelToken: cancelToken);
        Log.i('获取动图信息成功');
      } catch (e, s) {
        Log.e('获取动图信息失败', e, s);
        platformAPI.toast('获取动图信息失败');
        setIdle();
        return;
      }
    }
    platformAPI.toast('开始下载动图压缩包');
    Dio(
      BaseOptions(
        headers: {'Referer': 'https://app-api.pixiv.net/'},
        responseType: ResponseType.bytes,
        sendTimeout: 6000,
        //60秒
        receiveTimeout: 60000,
        connectTimeout: 6000,
      ),
    ).get<Uint8List>(Utils.replaceImageSource(_ugoiraMetadata!.ugoiraMetadata.zipUrls.medium)).then((response) {

      delays.addAll(_ugoiraMetadata!.ugoiraMetadata.frames.map((e) => e.delay).toList());
      Log.i('下载动图压缩包成功:帧数${delays.length}');
      platformAPI.unZipGif(id: id, zipBytes: response.data!, delays: delays).then((files) {
        images.addAll(files);
        initialized = true;
        Log.i('解压动图压缩包成功');
      }).catchError((e, s) {
        Log.e('解压动图压缩包失败', e, s);
        platformAPI.toast('解压动图压缩包失败');
      }).whenComplete(() => setIdle());

    }).catchError((e, s) {
      Log.e('下载动图压缩包失败', e, s);
      platformAPI.toast('下载动图压缩包失败');
      setIdle();
    });
  }
}
