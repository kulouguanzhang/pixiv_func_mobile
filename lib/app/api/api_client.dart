import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/pixiv_api.dart';
import 'package:pixiv_func_mobile/app/api/auth_client.dart';
import 'package:pixiv_func_mobile/services/account_service.dart';

class ApiClient extends GetxService with PixivApi {
  Future<ApiClient> initSuper(AuthClient authClient) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    super.init(
      auth: authClient,
      targetIPGetter: () => "210.140.92.183",
      languageGetter: () => Get.locale!.toLanguageTag(),
      deviceName: androidInfo.model ?? 'CAO',
      accountGetter: () => Get.find<AccountService>().current?.userAccount,
      accountUpdater: (data) => Get.find<AccountService>().updateUserAccount(data),
    );
    return this;
  }
}
