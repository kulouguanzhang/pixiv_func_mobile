import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/local_data/account_manager.dart';
import 'package:pixiv_func_android/app/settings/app_settings.dart';
import 'package:pixiv_func_android/pages/app_body/app_body.dart';
import 'package:pixiv_func_android/pages/guide/step0_language_set.dart';
import 'package:pixiv_func_android/pages/login/login.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.find<AccountService>().isEmpty) {
      if (Get.find<AppSettingsService>().guideInit) {
        return const LoginPage();
      } else {
        return const LanguageSetPage();
      }
    } else {
      return const AppBodyPage();
    }
  }
}
