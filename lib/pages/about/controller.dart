/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:controller.dart
 * 创建时间:2021/11/29 下午9:11
 * 作者:小草
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/platform/api/platform_api.dart';
import 'package:pixiv_func_android/models/release_info.dart';
import 'package:pixiv_func_android/utils/log.dart';
import 'package:pixiv_func_android/utils/utils.dart';

class AboutController extends GetxController {

  final thisProjectGitHubUrl = 'https://github.com/xiao-cao-x/pixiv_func_android';

  String? _appVersion;

  String? get appVersion => _appVersion;

  set appVersion(String? value) {
    _appVersion = value;
    update();
  }

  bool loading = false;
  bool initFailed = false;
  ReleaseInfo? releaseInfo;

  void loadLatestReleaseInfo() {
    releaseInfo = null;
    initFailed = false;
    loading = true;
    update();
    Dio().get<String>("https://api.github.com/repos/xiao-cao-x/pixiv-func-android/releases/latest").then((result) {
      final Map<String, dynamic> json = jsonDecode(result.data!);

      final firstAssets = (json['assets'] as List<dynamic>).first;

      releaseInfo = ReleaseInfo(
        htmlUrl: json['html_url'],
        tagName: json['tag_name'],
        updateAt: DateTime.parse(firstAssets['updated_at'] as String),
        browserDownloadUrl: firstAssets['browser_download_url'] as String,
        body: json['body'] as String,
      );
    }).catchError((e, s) {
      Log.e('获取最新发行版信息失败');
      initFailed = true;
    }).whenComplete(() {
      loading = false;
      update();
    });
  }

  Future<void> loadAppVersion() async {
    appVersion = await Get.find<PlatformApi>().appVersion;
  }

  Future<void> openTagHtmlByBrowser() async {
    if (!await Get.find<PlatformApi>().urlLaunch(releaseInfo!.htmlUrl)) {
      Get.find<PlatformApi>().toast('打开浏览器失败');
    }
  }

  Future<void> copyTagHtmlUrl() async {
    await Utils.copyToClipboard(releaseInfo!.htmlUrl);
    Get.find<PlatformApi>().toast('已将 ${releaseInfo!.htmlUrl} 复制到剪切板');
  }

  Future<void> startUpdateApp() async {
    if (!await Get.find<PlatformApi>().updateApp(
      'https://ghproxy.com/${releaseInfo!.browserDownloadUrl}',
      releaseInfo!.tagName,
    )) {
      Get.find<PlatformApi>().toast('启动下载失败');
    }
  }

  Future<void> copyAppLatestVersionDownloadUrl() async {
    await Utils.copyToClipboard(releaseInfo!.browserDownloadUrl);
    Get.find<PlatformApi>().toast('已将 ${releaseInfo!.browserDownloadUrl} 复制到剪切板');
  }

  Future<void> openProjectUrlByBrowser()async{
    if (!await Get.find<PlatformApi>().urlLaunch(thisProjectGitHubUrl)) {
      Get.find<PlatformApi>().toast('打开浏览器失败');
    }
  }

  Future<void> copyProjectUrl()async{
    await Utils.copyToClipboard(thisProjectGitHubUrl);
    Get.find<PlatformApi>().toast('已将 $thisProjectGitHubUrl 复制到剪切板');
  }

}
