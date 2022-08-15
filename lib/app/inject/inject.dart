import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/api/auth_client.dart';
import 'package:pixiv_func_mobile/app/api/web_api_client.dart';
import 'package:pixiv_func_mobile/app/downloader/downloader.dart';
import 'package:pixiv_func_mobile/global_controllers/about_controller.dart';
import 'package:pixiv_func_mobile/services/account_service.dart';
import 'package:pixiv_func_mobile/services/block_tag_service.dart';
import 'package:pixiv_func_mobile/services/history_service.dart';
import 'package:pixiv_func_mobile/services/settings_service.dart';

class Inject {
  static Future<void> init() async {
    await Get.putAsync(() async => await AuthClient().initSuper());
    await Get.putAsync(() async => await WebApiClient().initSuper());
    await Get.putAsync(() async => await ApiClient().initSuper(Get.find()));
    await Get.putAsync(() async => await AccountService().init());
    await Get.putAsync(() async => await HistoryService().init());
    await Get.putAsync(() async => await SettingsService().init());
    await Get.putAsync(() async => await BlockTagService().init());

    // await Get.putAsync(() async => await ChatService().init());
    // await Get.putAsync(() async => await MessageService().init());
    // Get.put(ChatListController());

    await Get.putAsync(() => AboutController().init());

    Get.lazyPut(() => Downloader());
  }
}
