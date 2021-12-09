/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user.dart
 * 创建时间:2021/11/25 下午9:12
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_android/app/api/enums.dart';
import 'package:pixiv_func_android/app/api/model/user_detail.dart';
import 'package:pixiv_func_android/app/data/data_tab_config.dart';
import 'package:pixiv_func_android/app/data/data_tab_page.dart';
import 'package:pixiv_func_android/app/download/downloader.dart';
import 'package:pixiv_func_android/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_android/components/follow_switch_button/follow_switch_button.dart';
import 'package:pixiv_func_android/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_android/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_android/components/novel_previewer/novel_previewer.dart';

import 'bookmarked/source.dart';
import 'controller.dart';
import 'ilust/source.dart';
import 'info/content.dart';
import 'novel/source.dart';

class UserPage extends StatelessWidget {
  final int id;

  const UserPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  Widget _buildFlexibleSpace() {
    final userDetail = Get.find<UserController>(tag: '$runtimeType:$id').userDetail!;
    final String? backgroundImageUrl = userDetail.profile.backgroundImageUrl;
    final UserInfo user = userDetail.user;
    return FlexibleSpaceBar(
      background: Column(children: [
        if (null != backgroundImageUrl)
          Expanded(
            child: ImageFromUrl(
              backgroundImageUrl,
              fit: BoxFit.contain,
            ),
          )
        else
          const Expanded(
            child: Center(
              child: Text('没有背景图片'),
            ),
          ),
        ListTile(
          leading: GestureDetector(
            onTap: () => Get.dialog(Dialog(
              child: SizedBox(
                height: 350,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ImageFromUrl(user.profileImageUrls.medium),
                    ),
                    IconButton(
                      tooltip: '保存原图',
                      splashRadius: 20,
                      onPressed: () => Downloader.start(url: user.profileImageUrls.medium),
                      icon: const Icon(Icons.save_alt_outlined),
                    ),
                  ],
                ),
              ),
            )),
            child: Hero(
              tag: 'UserHero:${user.id}',
              child: AvatarFromUrl(
                user.profileImageUrls.medium,
                radius: 35,
              ),
            ),
          ),
          title: Text(user.name),
          subtitle: GestureDetector(
            onTap: () {},
            child: Text('${userDetail.profile.totalFollowUsers}关注'),
          ),
          trailing: FollowSwitchButton(id: user.id, initValue: user.isFollowed),
        )
      ]),
      collapseMode: CollapseMode.pin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controllerTag = '$runtimeType:$id';
    final controller = Get.put(UserController(id), tag: controllerTag);
    return GetBuilder<UserController>(
      tag: controllerTag,
      assignId: true,
      initState: (state) => controller.loadData(),
      builder: (UserController controller) {
        final Widget widget;
        if (controller.loading) {
          widget = const Center(child: CircularProgressIndicator());
        } else if (controller.error) {
          widget = Center(
            child: ListTile(
              onTap: () => controller.loadData(),
              title: const Center(child: Text('加载失败,点击重新加载')),
            ),
          );
        } else if (controller.notFound) {
          widget = Center(
            child: ListTile(
              title: Center(
                child: Text('用户ID:$id不存在'),
              ),
            ),
          );
        } else {
          final userDetail = Get.find<UserController>(tag: '$runtimeType:$id').userDetail!;
          widget = DataTabPage(
            title: '用户',
            tabs: [
              DataTabConfig(
                name: '信息',
                source: null,
                itemBuilder: (BuildContext context, dynamic item, int index) {
                  return UserInfoContent(userDetail: userDetail);
                },
                isCustomChild: true,
              ),
              DataTabConfig(
                name: '插画',
                source: UserIllustListSource(id, WorkType.illust),
                itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(
                  illust: item,
                  showUserName: false,
                ),
                extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              ),
              DataTabConfig(
                name: '漫画',
                source: UserIllustListSource(id, WorkType.manga),
                itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(
                  illust: item,
                  showUserName: true,
                ),
                extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              ),
              DataTabConfig(
                name: '小说',
                source: UserNovelListSource(id),
                itemBuilder: (BuildContext context, item, int index) => NovelPreviewer(novel: item),
              ),
              DataTabConfig(
                name: '收藏',
                source: UserBookmarkedListSource(id),
                itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(illust: item),
                extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              ),
            ],
            floatHeaderSlivers: false,
            flexibleSpace: _buildFlexibleSpace(),
            expandedHeight: 320,
          );
        }
        return SafeArea(child: Scaffold(body: widget));
      },
    );
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  TabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
