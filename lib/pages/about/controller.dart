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
  static const _projectGitHubUrl = 'https://github.com/xiao-cao-x/pixiv_func_mobile';

  static const _getHelpUrl = 'https://pixiv.xiaocao.move/#/pixiv-func/mobile';

  PageState _state = PageState.none;

  PageState get state => _state;

  bool _first = true;

  String? _appVersionName;

  String? get appVersion => _appVersionName;

  ReleaseInfo? releaseInfo;

  bool? get hasNewVersion => true;

  void loadLatestReleaseInfo() async {
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
      if (releaseInfo!.tagName != appVersion) {
        if (_first) {
          Get.snackbar(
            '版本信息',
            '当前版本:$appVersion,最新版本:${releaseInfo!.tagName},点击前往查看',
            duration: const Duration(seconds: 6),
            onTap: (snack) => Get.to(const SizedBox()),
          );
          _first = false;
        }
      }
      _state = PageState.none;
    }).catchError((e, s) {
      Log.e('获取最新发行版信息失败');
      _state = PageState.error;
    }).whenComplete(() {
      update();
    });
  }

  void updateApp() async {
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

  Future<void> loadAppVersionName() async {
    _appVersionName = await PlatformApi.appVersionName;
    update();
  }

  @override
  void onInit() async {
    await loadAppVersionName();
    loadLatestReleaseInfo();
    super.onInit();
  }
}
