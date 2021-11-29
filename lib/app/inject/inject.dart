/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:inject.dart
 * 创建时间:2021/11/23 下午6:04
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/api/auth_client.dart';
import 'package:pixiv_func_android/app/download/download_manager_controller.dart';
import 'package:pixiv_func_android/app/local_data/account_manager.dart';
import 'package:pixiv_func_android/app/local_data/browsing_history_manager.dart';
import 'package:pixiv_func_android/app/platform/api/platform_api.dart';
import 'package:pixiv_func_android/app/settings/app_settings.dart';

class Inject {
  static Future<void> init() async {
    await Get.putAsync(() => AccountService().init());
    await Get.putAsync(() => BrowsingHistoryService().init());
    await Get.putAsync(() => AppSettingsService().init());

    Get.lazyPut(() => PlatformApi());
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => AuthClient());
    Get.lazyPut(() => DownloadManagerController());
  }
}
