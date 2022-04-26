import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/api/auth_client.dart';
import 'package:pixiv_func_mobile/app/download/download_manager_controller.dart';
import 'package:pixiv_func_mobile/app/local_data/account_service.dart';
import 'package:pixiv_func_mobile/app/local_data/browsing_history_service.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/settings/app_settings.dart';
import 'package:pixiv_func_mobile/app/version_info/version_info.dart';

class Inject {
  static Future<void> init() async {
    Get.lazyPut(() => PlatformApi());
    Get.lazyPut(() => DownloadManagerController());
    Get.lazyPut(() => AuthClient().initSuper());
    Get.lazyPut(() => ApiClient().initSuper(Get.find()));

    await Get.putAsync(() => AccountService().init());
    await Get.putAsync(() => BrowsingHistoryService().init());
    await Get.putAsync(() => AppSettingsService().init());
    await Get.putAsync(() => VersionInfoController().init());
  }
}
