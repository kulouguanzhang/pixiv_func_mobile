import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/auth_client.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/local_data/account_manager.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/platform/webview/platform_web_view.dart';
import 'package:pixiv_func_mobile/app/settings/app_settings.dart';
import 'package:pixiv_func_mobile/pages/app_body/app_body.dart';
import 'package:pixiv_func_mobile/utils/log.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';

import 'state.dart';

class LoginController extends GetxController {
  final LoginState state = LoginState();
  final _getHelpUrl = 'https://pixiv.xiaocao.site/#/pixiv-func/mobile';

  void useReverseProxyOnChanged(bool? value) {
    if (null != value) {
      state.useReverseProxy = value;
      update();
    }
  }

  void login(bool create) {
    final AccountService accountManager = Get.find();
    final AuthClient authClient = Get.find();
    final AppSettingsService appInfo = Get.find();
    final s = authClient.randomString(128);

    final url = 'https://app-api.pixiv.net/web/v1/' +
        (create ? 'provisional-accounts/create' : 'login') +
        '?code_challenge=${authClient.generateCodeChallenge(s)}&code_challenge_method=S256&client=pixiv-android';

    Get.to(
      PlatformWebView(
        useLocalReverseProxy: state.useReverseProxy,
        url: url,
        onMessageHandler: (BuildContext context, dynamic message) async {
          final map = message as Map;
          switch (map['type']) {
            case 'code':
              final code = map['content'] as String;

              Log.i('code:$code');
              authClient.initAccountAuthToken(code, s).then((result) {
                Log.i(result);

                Get.find<PlatformApi>().toast('${I18n.login.tr}${I18n.success.tr}');

                final firstAccount = accountManager.isEmpty;

                accountManager.add(result);
                Get.back();
                appInfo.guideInit = true;

                if (firstAccount) {
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

  Future<void> openGetHelpUrlByBrowser() async {
    if (!await Get.find<PlatformApi>().urlLaunch(_getHelpUrl)) {
      Get.find<PlatformApi>().toast(I18n.openBrowserFailed.tr);
    }
  }

  Future<void> copyGetHelpUrl() async {
    await Utils.copyToClipboard(_getHelpUrl);
    Get.find<PlatformApi>().toast(I18n.copySuccess.tr);
  }
}
