/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:auth_token_interceptor.dart
 * 创建时间:2021/8/24 上午11:10
 * 作者:小草
 */

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/util/log.dart';

import 'model/error_message.dart';
import 'oauth_api.dart';

class AuthTokenInterceptor extends InterceptorsWrapper {
  String? getToken() {
    final currentAccount = accountManager.current;
    if (null == currentAccount) {
      return null;
    }

    final token = currentAccount.accessToken;
    return 'Bearer $token';
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = getToken();
    if (null != token) {
      options.headers[OAuthAPI.fieldName] = token;
    }

    handler.next(options);
  }

  //刷新token最小间隔 1分钟
  static const _refreshTokenMinInterval = 60 * 1000;

  //上次刷新token的时间
  int _refreshTokenLastTime = 0;

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (null == err.response) {
      return handler.reject(err);
    }

    //http 400
    if (HttpStatus.badRequest != err.response!.statusCode) {
      return handler.reject(err);
    }

    final errorMessage = ErrorMessage.fromJson(jsonDecode(err.response!.data));

    final message = errorMessage.error.message!;

    if (!message.contains('OAuth')) {
      return handler.reject(err);
    }

    Log.d('AuthToken错误');

    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (null == accountManager.current) {
      return handler.reject(err);
    }

    final option = err.requestOptions;

    //防止连续多个OAuth错误 导致重复刷新token
    if ((currentTime - _refreshTokenLastTime) > _refreshTokenMinInterval) {
      pixivAPI.httpClient.interceptors.errorLock.lock();
      Log.d('需要刷新AuthToken');

      final currentAccount = accountManager.current!;

      bool hasError = false;

      await oAuthAPI.refreshAuthToken(currentAccount.refreshToken).then((result) {
        accountManager.update(result);
        _refreshTokenLastTime = currentTime;
        final token = getToken();
        if (null != token) {
          option.headers[OAuthAPI.fieldName] = getToken();
        }
      }).catchError((e) {
        Log.e('刷新AuthToken失败', e);
        hasError = true;
      }).whenComplete(() {
        pixivAPI.httpClient.interceptors.errorLock.unlock();
      });

      if (hasError) {
        return handler.reject(err);
      }
    }

    final response = await pixivAPI.httpClient.request(
      option.path,
      data: option.data,
      queryParameters: option.queryParameters,
      cancelToken: option.cancelToken,
      options: Options(
        method: option.method,
        headers: option.headers,
        contentType: option.contentType,
      ),
    );

    return handler.resolve(response);
  }
}
