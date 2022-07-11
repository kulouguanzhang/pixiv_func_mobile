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
