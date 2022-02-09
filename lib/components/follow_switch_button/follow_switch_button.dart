/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:follow_switch_button.dart
 * 创建时间:2021/11/24 下午1:55
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/follow_switch_button/controller.dart';

class FollowSwitchButton extends StatelessWidget {
  final int id;
  final bool initValue;

  const FollowSwitchButton({
    Key? key,
    required this.id,
    required this.initValue,
  }) : super(key: key);

  void _restrictDialog() {
    final controller = Get.find<FollowSwitchButtonController>(tag: '$runtimeType:$id');
    Get.dialog(
      ObxValue<RxBool>(
        (data) {
          return AlertDialog(
            title: Text(I18n.followUser.tr),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: Text(I18n.public.tr),
                  value: true,
                  groupValue: data.value,
                  onChanged: (bool? value) {
                    if (null != value) {
                      data.value = value;
                    }
                  },
                ),
                RadioListTile(
                  title: Text(I18n.private.tr),
                  value: false,
                  groupValue: data.value,
                  onChanged: (bool? value) {
                    if (null != value) {
                      data.value = value;
                    }
                  },
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  controller.changeFollowState(isChange: true, restrict: data.value);
                  Get.back();
                },
                child: Text(I18n.confirm.tr),
              ),
              OutlinedButton(
                onPressed: () => Get.back(),
                child: Text(I18n.cancel.tr),
              ),
            ],
          );
        },
        true.obs,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controllerTag = '$runtimeType:$id';

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
        return controller.requesting
            ? const RefreshProgressIndicator()
            : controller.isFollowed
                ? ElevatedButton(
          onPressed: () => controller.changeFollowState(),
                    child: Text(I18n.followed.tr),
                  )
                : OutlinedButton(
          onPressed: () => controller.changeFollowState(),
                    onLongPress: () => _restrictDialog(),
                    child: Text(I18n.follow.tr),
                  );
      },
    );
  }
}
