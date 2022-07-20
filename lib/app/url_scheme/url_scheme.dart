import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/auth_client.dart';
import 'package:pixiv_func_mobile/app/data/account_service.dart';
import 'package:pixiv_func_mobile/app/data/settings_service.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/pages/home/home.dart';
import 'package:pixiv_func_mobile/pages/illust/id_search/id_search.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class UrlScheme {
  static Future<void> handler(String url) async {
    PlatformApi.toast('从$url启动');
    final uri = Uri.parse(url);
    if ('account' == uri.host) {
      _login(uri);
    } else {
      _content(uri);
    }
  }

  static void _content(Uri uri) {
    if (Get.find<AccountService>().isEmpty) {
      PlatformApi.toast('请先登录');
      return;
    }
    if ('http' == uri.scheme || 'https' == uri.scheme) {
      if (uri.host.contains('pixiv.net')) {
        if ('artworks' == uri.pathSegments.first) {
          final idString = uri.pathSegments.last;
          final id = int.tryParse(idString);
          if (id == null) {
            PlatformApi.toast('无效的id:$idString');
            return;
          }
          Get.to(IllustIdSearchPage(id: id));
        } else if ('users' == uri.pathSegments.first) {
          final idString = uri.pathSegments.last;
          final id = int.tryParse(idString);
          if (id == null) {
            PlatformApi.toast('无效的id:$idString');
            return;
          }
          Get.to(UserPage(id: id));
        } else {
          PlatformApi.toast('不支持的path:${uri.path}');
        }
      }
    } else if ("pixiv" == uri.scheme) {
      if ('illusts' == uri.host) {
        final idString = uri.pathSegments.last;
        final id = int.tryParse(idString);
        if (id == null) {
          PlatformApi.toast('无效的id:$idString');
          return;
        }
        Get.to(IllustIdSearchPage(id: id));
      } else if ('users' == uri.host) {
        final idString = uri.pathSegments.last;
        final id = int.tryParse(idString);
        if (id == null) {
          PlatformApi.toast('无效的id:$idString');
          return;
        }
        Get.to(UserPage(id: id));
      }
    }
  }

  static void _login(Uri uri) {
    if ('account' == uri.host) {
      final SettingsService settingsService = Get.find();
      final AccountService accountService = Get.find();
      final AuthClient authClient = Get.find();
      authClient.initAccountAuthToken(uri.queryParameters['code'] as String).then((result) {
        Log.i(result);

        PlatformApi.toast('登录成功');

        final firstAccount = accountService.isEmpty;

        accountService.add(result);
        Get.back();
        settingsService.guideInit = true;

        if (firstAccount) {
          Get.offAll(const HomePage());
        } else {
          Get.back();
        }
      }).catchError((e) {
        Log.e('登录失败', e);
      });
    }
  }
}
