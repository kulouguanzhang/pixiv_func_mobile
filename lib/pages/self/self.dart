/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:self.dart
 * 创建时间:2021/11/24 下午11:00
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/local_data/account_manager.dart';
import 'package:pixiv_func_mobile/components/local_user_card/local_user_card.dart';
import 'package:pixiv_func_mobile/pages/about/about.dart';
import 'package:pixiv_func_mobile/pages/account/account.dart';
import 'package:pixiv_func_mobile/pages/any_new/any_new.dart';
import 'package:pixiv_func_mobile/pages/bookmarked/bookmarked.dart';
import 'package:pixiv_func_mobile/pages/browsing_history/browsing_history.dart';
import 'package:pixiv_func_mobile/pages/download_manager/download_manager.dart';
import 'package:pixiv_func_mobile/pages/follower_new/follower_new.dart';
import 'package:pixiv_func_mobile/pages/following/following.dart';
import 'package:pixiv_func_mobile/pages/settings/settings.dart';

class SelfPage extends StatelessWidget {
  const SelfPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              InkWell(
                onTap: () => Get.to(const AccountPage()),
                child: Obx(
                  () {
                    return LocalUserCard(
                      Get.find<AccountService>().accounts()[Get.find<AccountService>().currentIndex.value].user,
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const BookmarkedPage()),
                  title: Text(I18n.bookmark.tr, style: const TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const FollowingPage()),
                  title: Text(I18n.follow.tr, style: const TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const FollowerNewPage()),
                  title: Text(I18n.followerNewIllust.tr, style: const TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const AnyNewPage()),
                  title: Text(I18n.anyNewIllust.tr, style: const TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const SettingsPage()),
                  title: Text(I18n.settings.tr, style: const TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const DownloadManagerPage()),
                  title: Text(I18n.downloadTask.tr, style: const TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const BrowsingHistoryPage()),
                  title: Text(I18n.browsingHistory.tr, style: const TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const AboutPage()),
                  title: Text(I18n.about.tr, style: const TextStyle(fontSize: 25)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
