import 'dart:typed_data';
import 'package:flutter/services.dart';

class PlatformApi {
  PlatformApi._();

  static const _pluginName = 'xiaocao/platform/api';

  static const _channel = MethodChannel(_pluginName);

  static Future<bool?> saveImage(Uint8List imageBytes, String filename) async {
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
      return null;
    }
  }

  static Future<bool?> saveGifImage(int id, List<Uint8List> images, List<int> delays) async {
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
      return null;
    }
  }

  static Future<List<Uint8List>> unZipGif(Uint8List zipBytes) async {
    final result = await _channel.invokeMethod<List<Object?>>(
      _Method.unZipGif,
      {
        'zipBytes': zipBytes,
      },
    );
    return result!.map((e) => e as Uint8List).toList();
  }

  static Future<bool> imageIsExist(String filename) async {
    final result = await _channel.invokeMethod(
      _Method.imageIsExist,
      {
        'filename': filename,
      },
    );
    return true == result;
  }

  static Future<void> toast(String content, {bool isLong = false}) async {
    await _channel.invokeMethod(
      _Method.toast,
      {
        'content': content,
        'isLong': isLong,
      },
    );
  }

  static Future<int> get buildVersion async {
    final result = await _channel.invokeMethod(_Method.getBuildVersion);
    return result as int;
  }

  static Future<String> get appVersion async {
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
