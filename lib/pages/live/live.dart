import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/live.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/components/follow_switch_button/follow_switch_button.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/pages/live/controller.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/widgets/dropdown/dropdown.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';
import 'package:video_player/video_player.dart';

class LivePage extends StatelessWidget {
  final Live live;

  const LivePage({
    Key? key,
    required this.live,
  }) : super(key: key);

  String get controllerTag => '$runtimeType-${live.id}';

  Widget buildPlayerWidget(double heightRatio) {
    final controller = Get.find<LiveController>(tag: controllerTag);
    final items = {
      0: controller.list[0].resolution.toString(),
      1: controller.list[1].resolution.toString(),
    };
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: () => controller.togglePlay(),
          onTap: () => controller.toggleMenu(),
          child: SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxWidth * 9 / 16,
            child: Stack(
              alignment: Alignment.center,
              children: [
                () {
                  final child = VideoPlayer(controller.vp!);
                  if (!controller.isPlaying || controller.isBuffering) {
                    return ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Get.isDarkMode ? Colors.black45 : Colors.white24,
                        BlendMode.srcOver,
                      ),
                      child: child,
                    );
                  } else {
                    return child;
                  }
                }(),
                if (!controller.initialized)
                  const TextWidget('正在初始化', fontSize: 16)
                else if (controller.isFirstLoading)
                  const CircularProgressIndicator()
                else if (!controller.isPlaying)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.play_arrow, size: 100, color: Colors.white),
                  )
                else if (controller.isBuffering)
                  const CupertinoActivityIndicator(),
                if (controller.hideMenuCountCountdown > 0)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        height: 35,
                        width: 110,
                        child: DropdownButtonWidgetHideUnderline(
                          child: DropdownButtonWidget<int>(
                            isDense: true,
                            elevation: 0,
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(12),
                            items: [
                              for (final item in items.entries)
                                DropdownMenuItemWidget<int>(
                                  value: item.key,
                                  child: Container(
                                    height: 35,
                                    width: 110,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      border: controller.currentPlay == item.key
                                          ? Border.all(
                                              color: Get.theme.colorScheme.primary.withOpacity(0.5),
                                            )
                                          : null,
                                      color: Get.theme.colorScheme.surface.withOpacity(0.5),
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
                            value: controller.currentPlay,
                            onChanged: controller.currentPlayOnChange,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (controller.hideMenuCountCountdown > 0)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      width: constraints.maxWidth,
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          ObxValue<Rx<Duration>>(
                            (data) => TextWidget('播放时长: ${controller.formatPlayTime(data.value)}', color: Colors.white),
                            controller.playTime,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.fullscreen),
                            onPressed: () => controller.toggleFullScreen(),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(LiveController(live.id), tag: controllerTag);
    return GetBuilder<LiveController>(
      tag: controllerTag,
      builder: (controller) => WillPopScope(
        child: () {
          if (!controller.isFullScreen) {
            return ScaffoldWidget(
              title: live.name,
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
                } else if (PageState.notFound == controller.state) {
                  return Container(
                    alignment: Alignment.center,
                    child: const TextWidget('直播已结束'),
                  );
                } else if (PageState.complete == controller.state) {
                  final liveUser = controller.liveDetail!.data.owner.user;
                  return Column(
                    children: [
                      buildPlayerWidget(9 / 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(() => UserPage(id: liveUser.id)),
                              child: PixivAvatarWidget(
                                live.owner.user.profileImageUrls.medium,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    liveUser.name,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    isBold: true,
                                  ),
                                  TextWidget(
                                    liveUser.uniqueName,
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                            FollowSwitchButton(
                              id: liveUser.id,
                              userName: liveUser.name,
                              userAccount: liveUser.uniqueName,
                              initValue: liveUser.followed,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }(),
            );
          } else {
            return ScaffoldWidget(
              emptyAppBar: true,
              child: buildPlayerWidget(1),
            );
          }
        }(),
        onWillPop: () async {
          if (controller.isFullScreen) {
            controller.toggleFullScreen();
            return false;
          } else {
            return true;
          }
        },
      ),
    );
  }
}
