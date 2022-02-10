/*
 * Copyright (C) 2022. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:version_info.dart
 * 创建时间:2022/2/10 下午12:25
 * 作者:小草
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/models/release_info.dart';
import 'package:pixiv_func_mobile/pages/about/about.dart';
import 'package:pixiv_func_mobile/utils/log.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';

class VersionInfoController extends GetxController implements GetxService {
  final thisProjectGitHubUrl = 'https://github.com/xiao-cao-x/pixiv_func_mobile';

  bool _frist = true;

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
    Dio().get<String>("https://api.github.com/repos/xiao-cao-x/pixiv_func_mobile/releases/latest").then((result) {
      final Map<String, dynamic> json = jsonDecode(result.data!);

      final firstAssets = (json['assets'] as List<dynamic>).first;

      releaseInfo = ReleaseInfo(
        htmlUrl: json['html_url'],
        tagName: json['tag_name'],
        updateAt: DateTime.parse(firstAssets['updated_at'] as String),
        browserDownloadUrl: firstAssets['browser_download_url'] as String,
        body: json['body'] as String,
      );
      if (releaseInfo!.tagName != appVersion) {
        if (_frist) {
          Get.snackbar(
            '版本信息',
            '当前版本:$appVersion,最新版本:${releaseInfo!.tagName},点击前往查看',
            duration: const Duration(seconds: 6),
            onTap: (snack) => Get.to(const AboutPage()),
          );
          _frist = false;
        }
      }
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
      Get.find<PlatformApi>().toast(I18n.openBrowserFailed.tr);
    }
  }

  Future<void> copyTagHtmlUrl() async {
    await Utils.copyToClipboard(releaseInfo!.htmlUrl);
    Get.find<PlatformApi>().toast(I18n.copySuccess.tr);
  }

  Future<void> startUpdateApp() async {
    if (!await Get.find<PlatformApi>().updateApp(
      'https://ghproxy.com/${releaseInfo!.browserDownloadUrl}',
      releaseInfo!.tagName,
    )) {
      Get.find<PlatformApi>().toast(I18n.startUpdateFailed.tr);
    }
  }

  Future<void> copyAppLatestVersionDownloadUrl() async {
    await Utils.copyToClipboard(releaseInfo!.browserDownloadUrl);
    Get.find<PlatformApi>().toast(I18n.copySuccess.tr);
  }

  Future<void> openProjectUrlByBrowser() async {
    if (!await Get.find<PlatformApi>().urlLaunch(thisProjectGitHubUrl)) {
      Get.find<PlatformApi>().toast(I18n.openBrowserFailed.tr);
    }
  }

  Future<void> copyProjectUrl() async {
    await Utils.copyToClipboard(thisProjectGitHubUrl);
    Get.find<PlatformApi>().toast(I18n.copySuccess.tr);
  }

  Future<VersionInfoController> init() async {
    await loadAppVersion();
    loadLatestReleaseInfo();
    return this;
  }
}
