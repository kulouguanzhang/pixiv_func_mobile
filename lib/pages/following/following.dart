/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:following.dart
 * 创建时间:2021/11/25 下午11:40
 * 作者:小草
 */


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/data/data_tab_config.dart';
import 'package:pixiv_func_android/app/data/data_tab_page.dart';
import 'package:pixiv_func_android/app/local_data/account_manager.dart';
import 'package:pixiv_func_android/components/illust_previewer/illust_previewer.dart';


import 'content/source.dart';

class FollowingPage extends StatelessWidget {
  final int? id;

  const FollowingPage({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        body: DataTabPage(
          title: '关注',
          tabs: [
            DataTabConfig(
              name: '公开',
              source: FollowingListSource(id ?? Get.find<AccountService>().currentUserId,true),
              itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
            ),
            DataTabConfig(
              name: '私有',
              source: FollowingListSource(id ?? Get.find<AccountService>().currentUserId,false),
              itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
            ),

          ],
        ),
      ),
    );
  }
}
