import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/pages/about/about.dart';
import 'package:pixiv_func_mobile/pages/account/account.dart';
import 'package:pixiv_func_mobile/pages/download_manager/download_manager.dart';
import 'package:pixiv_func_mobile/pages/history/history.dart';
import 'package:pixiv_func_mobile/pages/settings/image_source/image_source_settings.dart';
import 'package:pixiv_func_mobile/pages/settings/language/language_settings.dart';
import 'package:pixiv_func_mobile/pages/settings/preview_quality/preview_quality_settings.dart';
import 'package:pixiv_func_mobile/pages/settings/scale_quality/sacle_quality_settings.dart';
import 'package:pixiv_func_mobile/pages/settings/theme/theme_settings.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  Widget _buildItem({required VoidCallback onTap, required String title}) {
    return ListTile(
      onTap: onTap,
      title: TextWidget(title, fontSize: 16,isBold: true),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: '设置',
      child: NoScrollBehaviorWidget(
        child: ListView(
          children: [
            const Divider(),
            _buildItem(onTap: () {}, title: '个人资料设置'),
            const Divider(),
            _buildItem(onTap: () => Get.to(const AccountPage()), title: '账号设置'),
            const Divider(),
            _buildItem(onTap: () => Get.to(const ThemeSettingsPage()), title: '主题'),
            _buildItem(onTap: () => Get.to(const LanguageSettingsPage()), title: '语言'),
            const Divider(),
            _buildItem(onTap: () => Get.to(const ImageSourceSettingsPage()), title: '图片源'),
            _buildItem(onTap: () => Get.to(const PreviewQualitySettingsPage()), title: '预览质量'),
            _buildItem(onTap: () => Get.to(const ScaleQualitySettingsPage()), title: '缩放质量'),
            const Divider(),
            _buildItem(onTap: () {}, title: '标签管理'),
            const Divider(),
            _buildItem(onTap: () => Get.to(const DownloadManagerPage()), title: '下载任务'),
            const Divider(),
            _buildItem(onTap: () => Get.to(const HistoryPage()), title: '浏览记录'),
            const Divider(),
            _buildItem(onTap: () =>Get.to(const AboutPage()), title: '关于'),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
