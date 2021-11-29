/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:following.dart
 * 创建时间:2021/11/25 下午11:40
 * 作者:小草
 */

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/local_data/account_manager.dart';
import 'package:pixiv_func_android/components/sliver_tab_bar/sliver_tab_bar.dart';
import 'package:pixiv_func_android/pages/following/content/content.dart';

class FollowingPage extends StatelessWidget {
  final int? id;

  const FollowingPage({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: ExtendedNestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                const SliverAppBar(
                  title: Text('关注'),
                ),
                const SliverTabBar(
                  child: TabBar(
                    tabs: [
                      Tab(child: Text('公开')),
                      Tab(child: Text('私有')),
                    ],
                  ),
                  pinned: true,
                ),
              ];
            },
            onlyOneScrollInBody: true,
            floatHeaderSlivers: true,
            body: TabBarView(
              children: [
                FollowingContent(id: id ?? Get.find<AccountService>().currentUserId, restrict: true),
                FollowingContent(id: id ?? Get.find<AccountService>().currentUserId, restrict: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
