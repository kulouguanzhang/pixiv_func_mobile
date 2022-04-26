import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/settings/app_settings.dart';

class ImageSourceSettingsWidget extends StatelessWidget {
  final bool isPage;

  const ImageSourceSettingsWidget({Key? key, this.isPage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController customImageSourceInput = TextEditingController();

    const List<MapEntry<String, String>> imageSources = [
      MapEntry('IP(210.140.92.146)', '210.140.92.146'),
      MapEntry('Original(i.pximg.net)', 'i.pximg.net'),
      MapEntry('MirroImage(i.pixiv.re)', 'i.pixiv.re'),
    ];

    final widget = ObxValue<Rx<String>>(
      (Rx<String> data) {
        void updater(String? value) {
          if (null != value) {
            data.value = value;
            Get.find<AppSettingsService>().imageSource = value;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final imageSource in imageSources)
              RadioListTile(
                title: Text(imageSource.key),
                value: imageSource.value,
                groupValue: data.value,
                onChanged: updater,
              ),
            RadioListTile(
              title: Text('${I18n.use.tr}${I18n.customImageSource.tr}'),
              value: customImageSourceInput.text,
              groupValue: data.value,
              onChanged: updater,
            ),
            ListTile(
              title: TextField(
                decoration: InputDecoration(label: Text(I18n.customImageSource.tr)),
                controller: customImageSourceInput,
                onChanged: updater,
              ),
            ),
          ],
        );
      },
      Get.find<AppSettingsService>().imageSource.obs,
    );
    if (isPage) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${I18n.imageSource.tr}${I18n.settings.tr}'),
        ),
        body: widget,
      );
    } else {
      return widget;
    }
  }
}
