import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/services/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<MapEntry<String, String>> items = [
      MapEntry('简体中文', 'zh-CN'),
      MapEntry('English', 'en-US'),
      MapEntry('日本語', 'ja-JP'),
      MapEntry('Русский', 'ru-RU'),
    ];
    return ScaffoldWidget(
      title: I18n.languageSettingsPageTitle.tr,
      child: ObxValue(
        (Rx<String> data) {
          void updater(String? value) {
            if (null != value) {
              final list = value.split('-');
              Get.updateLocale(Locale(list.first, list.last));
              data.value = value;
              Get.find<SettingsService>().language = value;
            }
          }

          return Column(
            children: [
              for (final item in items)
                CupertinoSwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                  onTap: () => updater(item.value),
                  title: TextWidget(item.key, fontSize: 18, isBold: true),
                  value: data.value == item.value,
                ),
            ],
          );
        },
        Get.find<SettingsService>().language.obs,
      ),
    );
  }
}
