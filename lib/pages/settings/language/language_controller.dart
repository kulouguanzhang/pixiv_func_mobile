import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/services/settings_service.dart';

class LanguageController extends GetxController {
  String _language = Get.find<SettingsService>().language;

  String get language => _language;

  void languageOnChange(String? value) {
    if (null != value) {
      _language = value;
      Get.find<SettingsService>().language = value;
      final list = value.split('_');
      Get.updateLocale(Locale(list.first, list.last));
    }
  }
}
