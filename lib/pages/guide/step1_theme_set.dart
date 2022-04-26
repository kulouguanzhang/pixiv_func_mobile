import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/login/login.dart';
import 'package:pixiv_func_mobile/pages/settings/theme/theme_settings.dart';

class ThemeSetPage extends StatelessWidget {
  const ThemeSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final AppSettingsService appInfo = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('${I18n.theme.tr}${I18n.settings.tr}'),
      ),
      body: const ThemeSettingsWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_outlined),
        tooltip: I18n.nextStep.tr,
        onPressed: () => Get.to(const LoginPage()),
        backgroundColor: Get.theme.colorScheme.onBackground,
      ),
    );
  }
}
