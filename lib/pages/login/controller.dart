import 'package:get/get.dart';

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
}
