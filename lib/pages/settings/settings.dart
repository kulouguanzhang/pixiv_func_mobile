import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/data/account_service.dart';
import 'package:pixiv_func_mobile/app/encrypt/encrypt.dart';
import 'package:pixiv_func_mobile/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_mobile/pages/about/about.dart';
import 'package:pixiv_func_mobile/pages/account/account.dart';
import 'package:pixiv_func_mobile/pages/block_tag/block_tag.dart';
import 'package:pixiv_func_mobile/pages/downloader/downloader.dart';
import 'package:pixiv_func_mobile/pages/history/history.dart';
import 'package:pixiv_func_mobile/pages/settings/image_source/image_source_settings.dart';
import 'package:pixiv_func_mobile/pages/settings/language/language_settings.dart';
import 'package:pixiv_func_mobile/pages/settings/preview_quality/preview_quality_settings.dart';
import 'package:pixiv_func_mobile/pages/settings/scale_quality/sacle_quality_settings.dart';
import 'package:pixiv_func_mobile/pages/settings/theme/theme_settings.dart';
import 'package:pixiv_func_mobile/pages/user/me.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  Widget _buildItem({required VoidCallback onTap, required String title}) {
    return ListTile(
      onTap: onTap,
      title: TextWidget(title, fontSize: 16, isBold: true),
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
            GestureDetector(
              onLongPress: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: Encrypt.encode(jsonEncode(Get.find<AccountService>().current)),
                  ),
                );
              },
              child: InkWell(
                onTap: () => Get.to(const MePage()),
                child: Obx(
                  () {
                    final localUser = Get.find<AccountService>().accounts()[Get.find<AccountService>().currentIndex.value].user;
                    return Card(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                            child: SizedBox(
                              height: 85,
                              child: AvatarFromUrl(
                                localUser.profileImageUrls.px170x170,
                                radius: 85,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localUser.name,
                                  style: const TextStyle(fontSize: 28),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  localUser.mailAddress,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
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
            _buildItem(onTap: () => Get.to(const BlockTagPage()), title: '屏蔽标签管理'),
            const Divider(),
            _buildItem(onTap: () => Get.to(const DownloaderPage()), title: '下载任务'),
            const Divider(),
            _buildItem(onTap: () => Get.to(const HistoryPage()), title: '浏览记录'),
            const Divider(),
            _buildItem(onTap: () => Get.to(const AboutPage()), title: '关于'),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
