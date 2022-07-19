import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/models/release_info.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class AboutController extends GetxController implements GetxService {
  static const _authorGitHubUrl = 'https://github.com/git-xiaocao';

  static const _repoName = 'pixiv_func_mobile';

  static const _helpUrl = 'https://pixiv.xiaocao.moe/#/pixiv-func/mobile';

  PageState _state = PageState.none;

  PageState get state => _state;

  bool _first = true;

  int? _latestReleaseVersionCode;

  late String _appVersionName;

  late int _appVersionCode;

  String? get appVersion => _appVersionName;

  ReleaseInfo? releaseInfo;

  bool? get hasNewVersion => _latestReleaseVersionCode == null ? null : _appVersionCode < _latestReleaseVersionCode!;

  Future<void> loadData() async {
    releaseInfo = null;
    _state = PageState.loading;
    update();
    await Dio().get<String>("https://api.github.com/repos/git-xiaocao/pixiv_func_mobile/releases/latest").then((result) {
      final Map<String, dynamic> json = jsonDecode(result.data!);

      final firstAssets = (json['assets'] as List<dynamic>).first;

      releaseInfo = ReleaseInfo(
        htmlUrl: json['html_url'],
        tagName: json['tag_name'],
        updateAt: DateTime.parse(firstAssets['updated_at'] as String),
        browserDownloadUrl: firstAssets['browser_download_url'] as String,
        body: json['body'] as String,
      );
      _latestReleaseVersionCode = int.parse(releaseInfo!.tagName.split('+').last);
      _state = PageState.none;
    }).catchError((e, s) {
      Log.e('获取最新发行版信息失败');
      _state = PageState.error;
    }).whenComplete(() {
      update();
    });
  }

  Future<void> updateApp() async {
    const installPackagesStatus = Permission.requestInstallPackages;
    if (!await installPackagesStatus.isGranted) {
      await Permission.requestInstallPackages.request();
      if (!await installPackagesStatus.isGranted) {
        PlatformApi.toast('请给权限');
        return;
      }
    }
    PlatformApi.updateApp(
      'https://ghproxy.com/${releaseInfo!.browserDownloadUrl}',
      releaseInfo!.tagName,
    );
  }

  void action(int index) {
    switch (index) {
      case 0:
        openUrlByBrowser(_authorGitHubUrl);
        break;
      case 1:
        openUrlByBrowser(_helpUrl);
        break;
      case 2:
        openUrlByBrowser('$_authorGitHubUrl/$_repoName/releases/$_appVersionName+$_appVersionCode');
        break;
      case 3:
        openUrlByBrowser('$_authorGitHubUrl/$_repoName');
        break;
    }
  }

  void openUrlByBrowser(String url) {
    PlatformApi.urlLaunch(url);
  }

  Future<AboutController> init() async {
    _appVersionName = await PlatformApi.appVersionName;
    _appVersionCode = await PlatformApi.appVersionCode;
    loadData().then((_) {
      if (true == hasNewVersion) {
        if (_first) {
          Get.snackbar(
            '版本更新提示',
            '当前版本:$appVersion,最新版本:${releaseInfo!.tagName},点击前往查看',
            duration: const Duration(seconds: 6),
            onTap: (snack) => Get.to(const SizedBox()),
          );
          _first = false;
        }
      }
    });
    return this;
  }
}
