import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_account_result.dart';
import 'package:pixiv_func_mobile/app/encrypt/encrypt.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/models/account.dart';
import 'package:pixiv_func_mobile/pages/home/home.dart';
import 'package:pixiv_func_mobile/services/account_service.dart';

class LoginController extends GetxController {
  bool _useLocalReverseProxy = true;
  bool _help = false;

  bool get useLocalReverseProxy => _useLocalReverseProxy;

  set useLocalReverseProxy(bool value) {
    _useLocalReverseProxy = value;
    update();
  }

  bool get help => _help;

  set help(bool value) {
    _help = value;
    update();
  }

  void loginFromClipboard() async {
    try {
      final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
      if (null == text) {
        PlatformApi.toast('获取剪贴板数据失败,可能是没有剪贴板权限');
        return;
      } else if (text.isEmpty) {
        PlatformApi.toast('剪贴板数据为空');
        return;
      }
      final clipboardDataString = Encrypt.decode(text);
      final json = jsonDecode(clipboardDataString);
      final userAccount = UserAccountResult.fromJson(json);
      Get.find<AccountService>().add(Account(null, userAccount));
      Get.offAll(const HomePage());
      PlatformApi.toast('登录成功');
    } catch (e) {
      PlatformApi.toast('剪贴板数据不是有效的账号数据');
    }
  }
}
