import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/settings/language/language_settings.dart';

import 'browsing_history/browsing_history_settings.dart';
import 'image_source/image_source_settings.dart';
import 'preview_quality/preview_quality_settings.dart';
import 'scale_quality/scale_quality_settings.dart';
import 'theme/theme_settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  Widget _buildItem(String title, Widget child) {
    return Card(
      child: ListTile(
        title: Text(title),
        onTap: () => Get.to(child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.settings.tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildItem(I18n.theme.tr, const ThemeSettingsWidget(isPage: true)),
            _buildItem(I18n.language.tr, const LanguageSettingsWidget(isPage: true)),
            _buildItem(I18n.imageSource.tr, const ImageSourceSettingsWidget(isPage: true)),
            _buildItem(I18n.previewQuality.tr, const PreviewQualitySettingsWidget(isPage: true)),
            _buildItem(I18n.scaleQuality.tr, const ScaleQualitySettingsWidget(isPage: true)),
            _buildItem(I18n.browsingHistory.tr, const BrowsingHistorySettingsWidget(isPage: true)),
          ],
        ),
      ),
    );
  }
}
