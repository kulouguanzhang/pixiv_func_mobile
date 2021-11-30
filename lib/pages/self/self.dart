/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:self.dart
 * 创建时间:2021/11/24 下午11:00
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/local_data/account_manager.dart';
import 'package:pixiv_func_android/components/local_user_card/local_user_card.dart';
import 'package:pixiv_func_android/pages/about/about.dart';
import 'package:pixiv_func_android/pages/account/account.dart';
import 'package:pixiv_func_android/pages/any_new/any_new.dart';
import 'package:pixiv_func_android/pages/bookmarked/bookmarked.dart';
import 'package:pixiv_func_android/pages/browsing_history/browsing_history.dart';
import 'package:pixiv_func_android/pages/download_manager/download_manager.dart';
import 'package:pixiv_func_android/pages/follower_new/follower_new.dart';
import 'package:pixiv_func_android/pages/following/following.dart';
import 'package:pixiv_func_android/pages/settings/settings.dart';

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
                  title: const Text('收藏', style: TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const FollowingPage()),
                  title: const Text('关注', style: TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const FollowerNewPage()),
                  title: const Text('最新作品(关注者)', style: TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const AnyNewPage()),
                  title: const Text('最新作品(所有人)', style: TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const SettingsPage()),
                  title: const Text('设置', style: TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const DownloadManagerPage()),
                  title: const Text('下载任务', style: TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const BrowsingHistoryPage()),
                  title: const Text('历史记录', style: TextStyle(fontSize: 25)),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () => Get.to(const AboutPage()),
                  title: const Text('关于', style: TextStyle(fontSize: 25)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
