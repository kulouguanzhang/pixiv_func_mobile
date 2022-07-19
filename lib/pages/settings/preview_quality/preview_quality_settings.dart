import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/data/settings_service.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class PreviewQualitySettingsPage extends StatelessWidget {
  const PreviewQualitySettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<MapEntry<String, bool>> items = [
      MapEntry('中等', false),
      MapEntry('大图', true),
    ];
    return ScaffoldWidget(
      title: '预览质量',
      child: ObxValue(
        (Rx<bool> data) {
          void updater(bool? value) {
            if (null != value) {
              data.value = value;
              Get.find<SettingsService>().previewQuality = value;
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
        Get.find<SettingsService>().previewQuality.obs,
      ),
    );
  }
}
