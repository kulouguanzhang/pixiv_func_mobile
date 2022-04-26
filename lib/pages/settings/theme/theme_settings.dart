import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/settings/app_settings.dart';
import 'package:pixiv_func_mobile/app/theme/app_theme.dart';

class ThemeSettingsWidget extends StatelessWidget {
  final bool isPage;

  const ThemeSettingsWidget({Key? key, this.isPage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widget = ValueBuilder<bool?>(
      builder: (bool? snapshot, void Function(bool?) updater) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile(
              title: Text(I18n.dark.tr),
              value: false,
              groupValue: snapshot,
              onChanged: (bool? value) {
                updater(value);
              },
            ),
            RadioListTile(
              title: Text(I18n.light.tr),
              value: true,
              groupValue: snapshot,
              onChanged: (bool? value) {
                updater(value);
              },
            ),
          ],
        );
      },
      initialValue: Get.find<AppSettingsService>().isLightTheme,
      onUpdate: (bool? value) {
        if (null != value) {
          Get.find<AppSettingsService>().isLightTheme = value;
          Get.changeTheme(value ? AppTheme.lightTheme : AppTheme.darkTheme);
        }
      },
    );
    if (isPage) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${I18n.theme.tr}${I18n.settings.tr}'),
        ),
        body: widget,
      );
    } else {
      return widget;
    }
  }
}
