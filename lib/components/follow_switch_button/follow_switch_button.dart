/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:follow_switch_button.dart
 * 创建时间:2021/11/24 下午1:55
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/components/follow_switch_button/controller.dart';

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
            title: const Text('关注用户'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: const Text('公开'),
                  value: true,
                  groupValue: data.value,
                  onChanged: (bool? value) {
                    if (null != value) {
                      data.value = value;
                    }
                  },
                ),
                RadioListTile(
                  title: const Text('悄悄'),
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
                child: const Text('确定'),
              ),
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text('取消'),
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
          // print('根控制器删除:$controllerTag');
        }
      },
      builder: (controller) {
        return controller.requesting
            ? const RefreshProgressIndicator()
            : controller.isFollowed
                ? ElevatedButton(
                    onPressed: () => controller.changeFollowState(),
                    child: const Text('已关注'),
                  )
                : OutlinedButton(
                    onPressed: () => controller.changeFollowState(),
                    onLongPress: () => _restrictDialog(),
                    child: const Text('关注'),
                  );
      },
    );
  }
}
