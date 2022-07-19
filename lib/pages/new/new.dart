import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/widgets/auto_keep/auto_keep.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';

import 'controller.dart';
import 'everyone/eyeryone.dart';
import 'follow/follow.dart';

class NewPage extends StatefulWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Get.put(NewController(this));
    return GetBuilder<NewController>(
      builder: (controller) => ScaffoldWidget(
        titleWidget: TabBarWidget(
          physics: const NeverScrollableScrollPhysics(),
          onTap: controller.tabIndexOnChanged,
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
              text: '所有人',
              icon: controller.tabController.index == 0
                  ? controller.expandTypeSelector
                      ? const Icon(Icons.keyboard_arrow_up, size: 12)
                      : const Icon(Icons.keyboard_arrow_down, size: 12)
                  : null,
            ),
            TabWidget(
              text: '关注者',
              icon: controller.tabController.index == 1
                  ? controller.expandTypeSelector
                      ? const Icon(Icons.keyboard_arrow_up, size: 12)
                      : const Icon(Icons.keyboard_arrow_down, size: 12)
                  : null,
            ),
            TabWidget(
              text: '好P友',
              icon: controller.tabController.index == 2
                  ? controller.expandTypeSelector
                      ? const Icon(Icons.keyboard_arrow_up, size: 12)
                      : const Icon(Icons.keyboard_arrow_down, size: 12)
                  : null,
            ),
          ],
        ),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.tabController,
          children: [
            AutomaticKeepWidget(
              child: EveryoneNewContent(expandTypeSelector: controller.expandTypeSelector),
            ),
            AutomaticKeepWidget(
              child: FollowNewContent(expandTypeSelector: controller.expandTypeSelector),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
