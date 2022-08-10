import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/data/account_service.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/components/pixiv_image/pixiv_image.dart';
import 'package:pixiv_func_mobile/pages/user/me_settings/profile/profile.dart';
import 'package:pixiv_func_mobile/widgets/auto_keep/auto_keep.dart';
import 'package:pixiv_func_mobile/widgets/dropdown/dropdown.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/sliver_headerr/sliver_tab_bar.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';
import 'package:share_plus/share_plus.dart';

import 'bookmark/bookmark.dart';
import 'controller.dart';
import 'fans/fans.dart';
import 'following/following.dart';
import 'work/work.dart';

class MePage extends StatefulWidget {
  const MePage({Key? key}) : super(key: key);

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> with TickerProviderStateMixin {
  Widget _buildAppBar() {
    final controller = Get.find<MeController>();
    final userDetail = controller.userDetailResult!;
    final String? backgroundImageUrl = userDetail.profile.backgroundImageUrl;
    final UserInfo user = userDetail.user;
    final items = {
      Restrict.public: '公开',
      Restrict.private: '悄悄',
    };

    return ExtendedSliverAppbar(
      toolbarHeight: kToolbarHeight,
      toolBarColor: Get.theme.colorScheme.background,
      leading: (ModalRoute.of(context)?.canPop ?? false)
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Icon(Icons.arrow_back_ios_new),
              ),
              onTap: () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PixivAvatarWidget(
            user.profileImageUrls.medium,
            radius: 24,
          ),
          const SizedBox(width: 10),
          TextWidget(user.name, fontSize: 16),
        ],
      ),
      actions: [0, 1].contains(controller.tabController.index)
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 35,
                width: 70,
                child: DropdownButtonWidgetHideUnderline(
                  child: DropdownButtonWidget<Restrict?>(
                    isDense: true,
                    elevation: 0,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    items: [
                      for (final item in items.entries)
                        DropdownMenuItemWidget<Restrict>(
                          value: item.key,
                          child: Container(
                            height: 35,
                            width: 70,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17),
                              border: controller.restrict == item.key ? Border.all(color: Get.theme.colorScheme.primary) : null,
                              color: Get.theme.colorScheme.surface,
                            ),
                            child: Row(
                              children: [
                                const Spacer(),
                                const Icon(AppIcons.toggle, size: 12),
                                const SizedBox(width: 7),
                                TextWidget(
                                  item.value,
                                  fontSize: 14,
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                    ],
                    value: controller.restrict,
                    onChanged: controller.restrictOnChanged,
                  ),
                ),
              ),
            )
          : null,
      extentActions: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.to(() => MeProfileSettingsPage(currentDetail: userDetail)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Icon(Icons.settings),
        ),
      ),
      background: Container(
        color: Get.theme.colorScheme.background,
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (null != backgroundImageUrl)
                    Container(
                      height: 200,
                      color: Theme.of(Get.context!).colorScheme.surface,
                      child: PixivImageWidget(
                        backgroundImageUrl,
                        fit: BoxFit.contain,
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      color: Theme.of(Get.context!).colorScheme.surface,
                      alignment: Alignment.center,
                      child: const TextWidget('没有背景图片', fontSize: 16),
                    ),
                  Positioned(
                    top: 150,
                    child: PixivAvatarWidget(
                      user.profileImageUrls.medium,
                      radius: 100,
                    ),
                  )
                ],
              ),
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextWidget(user.name, fontSize: 16),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Share.share('[Pixiv Func]\n${user.name}\n用户ID:${user.id}\nhttps://www.pixiv.net/users/${user.id}');
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.share_outlined, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(AppIcons.follow, size: 14),
                const SizedBox(width: 5),
                TextWidget('${userDetail.profile.totalFollowUsers}'),
                const SizedBox(width: 10),
                const Icon(AppIcons.friend, size: 14),
                const SizedBox(width: 5),
                TextWidget('${userDetail.profile.totalMyPixivUsers}'),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(Get.context!).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextWidget(Get.find<AccountService>().current!.user.mailAddress),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MeController(this));
    return GetBuilder<MeController>(
      builder: (controller) => ScaffoldWidget(
        emptyAppBar: controller.userDetailResult != null,
        child: () {
          if (PageState.loading == controller.state) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          } else if (PageState.error == controller.state) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => controller.loadData(),
              child: Container(
                alignment: Alignment.center,
                child: const TextWidget('加载失败,点击重试', fontSize: 16),
              ),
            );
          } else {
            return NoScrollBehaviorWidget(
              child: ExtendedNestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
                  _buildAppBar(),
                  SliverPersistentHeader(
                    delegate: SliverHeader(
                        child: PreferredSize(
                      preferredSize: const Size.fromHeight(kToolbarHeight),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 0.5,
                            color: const Color(0xFF373737),
                          ),
                          TabBarWidget(
                            onTap: controller.tabOnTap,
                            controller: controller.tabController,
                            indicatorMinWidth: 15,
                            labelColor: Theme.of(context).colorScheme.primary,
                            unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                            indicator: const RRecTabIndicator(
                              radius: 4,
                              insets: EdgeInsets.only(bottom: 5),
                            ),
                            tabs: [
                              TabWidget(
                                text: '收藏',
                                icon: controller.tabController.index == 0
                                    ? controller.expandTypeSelector
                                        ? const Icon(Icons.keyboard_arrow_up, size: 12)
                                        : const Icon(Icons.keyboard_arrow_down, size: 12)
                                    : null,
                              ),
                              const TabWidget(
                                text: '关注',
                              ),
                              const TabWidget(
                                text: '粉丝',
                              ),
                              TabWidget(
                                text: '作品',
                                icon: controller.tabController.index == 3
                                    ? controller.expandTypeSelector
                                        ? const Icon(Icons.keyboard_arrow_up, size: 12)
                                        : const Icon(Icons.keyboard_arrow_down, size: 12)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                    pinned: true,
                  )
                ],
                pinnedHeaderSliverHeightBuilder: () => kToolbarHeight * 2,
                onlyOneScrollInBody: true,
                body: TabBarView(
                  controller: controller.tabController,
                  children: [
                    AutomaticKeepWidget(
                      child: UserBookmarkContent(
                        id: controller.currentUserId,
                        restrict: controller.restrict,
                        expandTypeSelector: controller.expandTypeSelector,
                      ),
                    ),
                    AutomaticKeepWidget(
                      child: UserFollowingContent(id: controller.currentUserId, restrict: controller.restrict),
                    ),
                    AutomaticKeepWidget(
                      child: UserFansContent(id: controller.currentUserId),
                    ),
                    AutomaticKeepWidget(
                      child: UserWorkContent(id: controller.currentUserId, expandTypeSelector: controller.expandTypeSelector),
                    )
                  ],
                ),
              ),
            );
          }
        }(),
      ),
    );
  }
}
