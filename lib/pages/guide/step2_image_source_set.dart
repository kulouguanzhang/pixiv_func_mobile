import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/login/login.dart';
import 'package:pixiv_func_mobile/pages/settings/image_source/image_source_settings.dart';

class ImageSourceSetPage extends StatelessWidget {
  const ImageSourceSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${I18n.imageSource.tr}${I18n.settings.tr}'),
      ),
      body: const ImageSourceSettingsWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_forward_outlined),
        tooltip: I18n.nextStep.tr,
        onPressed: () => Get.to(const LoginPage()),
        backgroundColor: Get.theme.colorScheme.onBackground,
      ),
    );
  }
}
