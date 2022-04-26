import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/encrypt/encrypt.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/local_data/account_service.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/platform/webview/platform_web_view.dart';
import 'package:pixiv_func_mobile/components/local_user_card/local_user_card.dart';
import 'package:pixiv_func_mobile/pages/about/about.dart';
import 'package:pixiv_func_mobile/pages/account/account.dart';
import 'package:pixiv_func_mobile/pages/any_new/any_new.dart';
import 'package:pixiv_func_mobile/pages/bookmarked/bookmarked.dart';
import 'package:pixiv_func_mobile/pages/browsing_history/browsing_history.dart';
import 'package:pixiv_func_mobile/pages/download_manager/download_manager.dart';
import 'package:pixiv_func_mobile/pages/fans/fans.dart';
import 'package:pixiv_func_mobile/pages/follow_new/follow_new.dart';
import 'package:pixiv_func_mobile/pages/following/following.dart';
import 'package:pixiv_func_mobile/pages/settings/settings.dart';

class SelfPage extends StatelessWidget {
  const SelfPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onLongPress: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: Encrypt.encode(jsonEncode(Get.find<AccountService>().current)),
                  ),
                );
                Get.find<PlatformApi>().toast(I18n.copySuccess.tr);
              },
              child: InkWell(
                onTap: () => Get.to(const AccountPage()),
                child: Obx(
                  () {
                    return LocalUserCard(
                      Get.find<AccountService>().accounts()[Get.find<AccountService>().currentIndex.value].user,
                    );
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => Get.to(const BookmarkedPage()),
                title: Text(I18n.bookmark.tr),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => Get.to(const FollowingPage()),
                title: Text(I18n.follow.tr),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => Get.to(const FansPage()),
                title: Text(I18n.fans.tr),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => Get.to(const FollowNewPage()),
                title: Text(I18n.followingNewIllust.tr),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => Get.to(const AnyNewPage()),
                title: Text(I18n.anyNewIllust.tr),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => Get.to(const SettingsPage()),
                title: Text(I18n.settings.tr),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => Get.to(const DownloadManagerPage()),
                title: Text(I18n.downloadTask.tr),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => Get.to(const BrowsingHistoryPage()),
                title: Text(I18n.browsingHistory.tr),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () => Get.to(const AboutPage()),
                title: Text(I18n.about.tr),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  //打开对话框询问是否使用本地反向代理
                  Get.dialog<bool>(
                    AlertDialog(
                      content: Text(I18n.useReverseProxy.tr),
                      actions: [
                        OutlinedButton(
                          onPressed: () => Get.back<bool>(result: true),
                          child: Text(I18n.confirm.tr),
                        ),
                        OutlinedButton(
                          onPressed: () => Get.back<bool>(result: false),
                          child: Text(I18n.cancel.tr),
                        ),
                      ],
                    ),
                  ).then((value) {
                    if (value != null) {
                      Get.to(PlatformWebView(url: 'https://www.pixiv.net/settings.php', useLocalReverseProxy: value));
                    }
                  });
                },
                title: Text(I18n.openSettingsPageInBrowser.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
