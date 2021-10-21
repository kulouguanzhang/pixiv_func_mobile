/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:platform.dart
 * 创建时间:2021/8/20 下午1:35
 * 作者:小草
 */

import 'dart:typed_data';

import 'package:flutter/services.dart';

class PlatformAPI {
  static const _pluginName = 'xiaocao/platform/api';

  final _channel = const MethodChannel(_pluginName);

  Future<bool?> saveImage(Uint8List imageBytes, String filename) async {
    try {
      final result = await _channel.invokeMethod(
        _Method.saveImage,
        {
          'imageBytes': imageBytes,
          'filename': filename,
        },
      );
      return result;
    } on PlatformException {
      toast('保存失败 可能是没有存储权限');
      return null;
    }
  }

  Future<bool?> saveGifImage(int id, List<Uint8List> images, List<int> delays) async {
    try {
      final result = await _channel.invokeMethod(
        _Method.saveGifImage,
        {
          'id': id,
          'images': images,
          'delays': delays,
        },
      );
      return result;
    } on PlatformException {
      toast('保存失败 可能是没有存储权限');
      return null;
    }
  }

  Future<List<Uint8List>> unZipGif({
    required int id,
    required Uint8List zipBytes,
    required List<int> delays,
  }) async {
    final result = await _channel.invokeMethod<List<Object?>>(
      _Method.unZipGif,
      {
        'id': id,
        'zipBytes': zipBytes,
        'delays': delays,
      },
    );
    return result!.map((e) => e as Uint8List).toList();
  }

  Future<bool> imageIsExist(String filename) async {
    final result = await _channel.invokeMethod(
      _Method.imageIsExist,
      {
        'filename': filename,
      },
    );
    return true == result;
  }

  Future<void> toast(String content, {bool isLong = false}) async {
    await _channel.invokeMethod(
      _Method.toast,
      {
        'content': content,
        'isLong': isLong,
      },
    );
  }

  Future<int> get buildVersion async {
    final result = await _channel.invokeMethod(_Method.getBuildVersion);
    return result as int;
  }

  Future<String> get appVersion async {
    final result = await _channel.invokeMethod(_Method.getAppVersion);
    return result as String;
  }

  Future<bool> urlLaunch(String url) async {
    final result = await _channel.invokeMethod(_Method.urlLaunch, {
      'url': url,
    });
    return result as bool;
  }

  Future<bool> updateApp(String url, String versionTag) async {
    final result = await _channel.invokeMethod(
      _Method.updateApp,
      {
        'url': url,
        'versionTag': versionTag,
      },
    );
    return result as bool;
  }
}

class _Method {
  static const saveImage = 'saveImage';
  static const saveGifImage = 'saveGifImage';
  static const unZipGif = 'unZipGif';
  static const imageIsExist = 'imageIsExist';
  static const toast = 'toast';
  static const getBuildVersion = 'getBuildVersion';
  static const getAppVersion = 'getAppVersion';
  static const urlLaunch = 'urlLaunch';
  static const updateApp = 'updateApp';
}
