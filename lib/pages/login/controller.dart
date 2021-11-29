import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/auth_client.dart';
import 'package:pixiv_func_android/app/local_data/account_manager.dart';
import 'package:pixiv_func_android/app/platform/api/platform_api.dart';
import 'package:pixiv_func_android/app/platform/webview/platform_web_view.dart';
import 'package:pixiv_func_android/app/settings/app_settings.dart';
import 'package:pixiv_func_android/pages/app_body/app_body.dart';
import 'package:pixiv_func_android/utils/log.dart';

import 'state.dart';

class LoginController extends GetxController {
  final LoginState state = LoginState();

  void agreementOnChanged(bool? value) {
    if (null != value) {
      state.agreementAccepted = value;
      update();
    }
  }

  void login(bool create, bool useLocalReverseProxy) {
    final AccountService accountManager = Get.find();
    final AuthClient oAuthAPI = Get.find();
    final AppSettingsService appInfo = Get.find();
    final s = oAuthAPI.randomString(128);

    final url = 'https://app-api.pixiv.net/web/v1/' +
        (create ? 'provisional-accounts/create' : 'login') +
        '?code_challenge=${oAuthAPI.generateCodeChallenge(s)}&code_challenge_method=S256&client=pixiv-android';

    Get.to(
      PlatformWebView(
        useLocalReverseProxy: useLocalReverseProxy,
        url: url,
        onMessageHandler: (BuildContext context, dynamic message) async {
          final map = message as Map;
          switch (map['type']) {
            case 'code':
              final code = map['content'] as String;

              Log.i('code:$code');
              oAuthAPI.initAccountAuthToken(code, s).then((result) {
                Log.i(result);

                Get.find<PlatformApi>().toast('登录成功');
                accountManager.add(result);
                Get.back();
                appInfo.guideInit = true;

                if (1 == accountManager.accounts().length) {
                  Get.offAll(const AppBodyPage());
                } else {
                  Get.back();
                }
              }).catchError((e) {
                Log.e('登录失败', e);
              });

              break;
          }
        },
      ),
    );
  }
}
