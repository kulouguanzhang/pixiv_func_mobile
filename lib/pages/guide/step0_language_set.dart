import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/guide/step1_theme_set.dart';
import 'package:pixiv_func_mobile/pages/settings/language/language_settings.dart';

class LanguageSetPage extends StatelessWidget {
  const LanguageSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final AppSettingsService appInfo = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text('${I18n.language.tr}${I18n.settings.tr}'),
      ),
      body: const LanguageSettingsWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_outlined),
        tooltip: I18n.nextStep.tr,
        onPressed: () => Get.to(const ThemeSetPage()),
        backgroundColor: Get.theme.colorScheme.onBackground,
      ),
    );
  }
}
