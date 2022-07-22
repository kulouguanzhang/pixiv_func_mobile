import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/pages/live/controller.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class LivePage extends StatelessWidget {
  final String id;
  final String name;
  const LivePage({Key? key, required this.id,required this.name}) : super(key: key);

  String get controllerTag => '$runtimeType-$id';

  @override
  Widget build(BuildContext context) {
    Get.put(LiveController(id), tag: controllerTag);
    return GetBuilder<LiveController>(
      tag: controllerTag,
      builder: (controller) => ScaffoldWidget(
        title: name,
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
            return FijkView(player: controller.ijkPlayer!, color: Colors.transparent);
          }
        }(),
      ),
    );
  }
}
