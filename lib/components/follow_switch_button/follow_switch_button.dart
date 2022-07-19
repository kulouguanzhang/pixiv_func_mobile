import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class FollowSwitchButton extends StatelessWidget {
  final int id;
  final bool initValue;

  const FollowSwitchButton({
    Key? key,
    required this.id,
    required this.initValue,
  }) : super(key: key);

  void _restrictDialog() {
    final controller = Get.find<FollowSwitchButtonController>(tag: '$runtimeType-$id');
  }

  @override
  Widget build(BuildContext context) {
    final controllerTag = '$runtimeType-$id';

    final bool isRootController = !Get.isRegistered<FollowSwitchButtonController>(tag: controllerTag);
    if (isRootController) {
      Get.put(FollowSwitchButtonController(id, initValue: initValue), tag: controllerTag);
    }

    return GetBuilder<FollowSwitchButtonController>(
      tag: controllerTag,
      dispose: (state) {
        if (isRootController) {
          Get.delete<FollowSwitchButtonController>(tag: controllerTag);
        }
      },
      builder: (controller) {
        return SizedBox(
          width: 90,
          height: 40,
          child: controller.requesting
              ?  SizedBox(
                  width: 90,
                  height: 40,
                  child: Center(
                    child: CupertinoActivityIndicator(color: Theme.of(context).colorScheme.onSurface),
                  ),
                )
              : controller.isFollowed
                  ? MaterialButton(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      onPressed: () => controller.changeFollowState(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextWidget('已关注', color: Theme.of(context).colorScheme.onSurface, isBold: true),
                      ),
                    )
                  : MaterialButton(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      onPressed: () => controller.changeFollowState(),
                      onLongPress: () => _restrictDialog(),
                      child: const Center(
                        child: TextWidget('关注', color: Colors.white, isBold: true),
                      ),
                    ),
        );
      },
    );
  }
}
