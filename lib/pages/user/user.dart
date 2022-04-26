import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_config.dart';
import 'package:pixiv_func_mobile/app/data/data_tab_page.dart';
import 'package:pixiv_func_mobile/app/download/downloader.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_mobile/components/follow_switch_button/follow_switch_button.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_mobile/components/novel_previewer/novel_previewer.dart';
import 'package:pixiv_func_mobile/pages/following/following.dart';

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
    final userDetail = Get.find<UserController>(tag: '$runtimeType:$id').userDetailResult!;
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
          Expanded(
            child: Center(
              child: Text(I18n.noBackgroundImage.tr),
            ),
          ),
        ListTile(
          leading: GestureDetector(
            onTap: () => Get.dialog(
              Dialog(
                child: SizedBox(
                  height: 300,
                  child: GestureDetector(
                    child: ImageFromUrl(user.profileImageUrls.medium),
                    onLongPress: () => Downloader.start(url: user.profileImageUrls.medium),
                  ),
                ),
              ),
            ),
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
            onTap: () => Get.to(FollowingPage(id: userDetail.user.id)),
            child: Text('${userDetail.profile.totalFollowUsers}${I18n.follow.tr}'),
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
              title: Center(child: Text(I18n.loadFailedRetry.tr)),
            ),
          );
        } else if (controller.notFound) {
          widget = Center(
            child: ListTile(
              title: Center(
                child: Text('${I18n.user.tr}ID:$id${I18n.notExist.tr}'),
              ),
            ),
          );
        } else {
          final userDetail = Get.find<UserController>(tag: '$runtimeType:$id').userDetailResult!;
          widget = DataTabPage(
            title: I18n.user.tr,
            tabs: [
              DataTabConfig(
                name: I18n.info.tr,
                source: null,
                itemBuilder: (BuildContext context, dynamic item, int index) {
                  return UserInfoContent(userDetail: userDetail);
                },
                isCustomChild: true,
              ),
              if (userDetail.profile.totalIllusts > 0)
                DataTabConfig(
                  name: I18n.illust.tr,
                  source: UserIllustListSource(id, IllustType.illust),
                  itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(
                    illust: item,
                    showUserName: false,
                  ),
                  extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                ),
              if (userDetail.profile.totalManga > 0)
                DataTabConfig(
                  name: I18n.manga.tr,
                  source: UserIllustListSource(id, IllustType.manga),
                  itemBuilder: (BuildContext context, item, int index) => IllustPreviewer(
                    illust: item,
                    showUserName: true,
                  ),
                  extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                ),
              if (userDetail.profile.totalNovels > 0)
                DataTabConfig(
                  name: I18n.novel.tr,
                  source: UserNovelListSource(id),
                  itemBuilder: (BuildContext context, item, int index) => NovelPreviewer(novel: item),
                ),
              DataTabConfig(
                name: I18n.bookmark.tr,
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
