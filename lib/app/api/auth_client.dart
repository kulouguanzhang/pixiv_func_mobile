/*
 * Copyright (C) 2022. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:auth_client.dart
 * 创建时间:2022/4/2 下午4:59
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_dart_api/pixiv_auth.dart';

class AuthClient extends GetxService with PixivAuth {
  AuthClient initSuper() {
    super.init(
      targetIPGetter: () => "210.140.92.183",
      languageGetter: () => Get.locale!.toLanguageTag(),
      deviceName: "XiaoCao",
    );
    return this;
  }
}
