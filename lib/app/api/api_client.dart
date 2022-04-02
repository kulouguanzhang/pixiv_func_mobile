/*
 * Copyright (C) 2022. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:api_client.dart
 * 创建时间:2022/4/2 下午4:29
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_dart_api/pixiv_api.dart';
import 'package:pixiv_func_mobile/app/api/auth_client.dart';
import 'package:pixiv_func_mobile/app/local_data/account_manager.dart';

class ApiClient extends GetxService with PixivApi {
  ApiClient initSuper(AuthClient authClient) {
    super.init(
      auth: authClient,
      targetIPGetter: () => "210.140.92.183",
      languageGetter: () => Get.locale!.toLanguageTag(),
      deviceName: "XiaoCao",
      accountGetter: () => Get.find<AccountService>().current,
      accountUpdater: (data) => Get.find<AccountService>().update(data),
    );
    return this;
  }
}
