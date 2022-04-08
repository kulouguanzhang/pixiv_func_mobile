/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:following.dart
 * 创建时间:2021/11/25 下午11:40
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_config.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_page.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/local_data/account_service.dart';
import 'package:pixiv_func_mobile/components/user_previewer/user_previewer.dart';

import 'content/source.dart';

class FollowingPage extends StatelessWidget {
  final int? id;

  const FollowingPage({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DataTabPage(
          title: I18n.follow.tr,
          tabs: [
            DataTabConfig(
              name: I18n.public.tr,
              source: FollowingListSource(id ?? Get.find<AccountService>().currentUserId, Restrict.public),
              itemBuilder: (BuildContext context, item, int index) => UserPreviewer(userPreview: item),
            ),
            DataTabConfig(
              name: I18n.private.tr,
              source: FollowingListSource(id ?? Get.find<AccountService>().currentUserId, Restrict.private),
              itemBuilder: (BuildContext context, item, int index) => UserPreviewer(userPreview: item),
            ),
          ],
        ),
      ),
    );
  }
}
