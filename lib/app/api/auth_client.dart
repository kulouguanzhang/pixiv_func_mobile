import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/pixiv_auth.dart';

class AuthClient extends GetxService with PixivAuth {
  Future<AuthClient> initSuper() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    super.init(
      targetIPGetter: () => "210.140.92.183",
      languageGetter: () => Get.locale!.toLanguageTag(),
      deviceName: androidInfo.model ?? 'CAO',
    );
    return this;
  }
}
