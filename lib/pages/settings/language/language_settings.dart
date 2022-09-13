import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/services/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({Key? key}) : super(key: key);

  static const defaultLocale = Locale('zh', 'CN');

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, String>> items = [
      const MapEntry('简体中文', 'zh_CN'),
      const MapEntry('English', 'en_US'),
      const MapEntry('日本語', 'ja_JP'),
      const MapEntry('Русский', 'ru_RU'),
    ];

    return ScaffoldWidget(
      title: I18n.languageSettingsPageTitle.tr,
      child: ObxValue(
        (Rx<String> data) {
          void updater(String? value) {
            if (null != value) {
              final list = value.split('_');
              Get.updateLocale(Locale(list.first, list.last));
              data.value = value;
              Get.find<SettingsService>().language = value;
            }
          }

          return ListView(
            children: [
              for (final item in items)
                CupertinoSwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                  onTap: () => updater(item.value),
                  title: TextWidget(item.key, fontSize: 18, isBold: true, locale: defaultLocale),
                  value: data.value == item.value,
                ),
              // ListTile(
              //   onTap: () => Get.to(const LanguageExpansionPage()),
              //   title: const TextWidget('语言拓展包', fontSize: 18, isBold: true, locale: defaultLocale),
              // )
            ],
          );
        },
        Get.find<SettingsService>().language.obs,
      ),
    );
  }
}
