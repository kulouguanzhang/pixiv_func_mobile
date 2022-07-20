import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/widgets/dropdown/dropdown.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class FollowSwitchButton extends StatelessWidget {
  final int id;
  final String userName;
  final String userAccount;
  final bool initValue;

  const FollowSwitchButton({
    Key? key,
    required this.id,
    required this.userName,
    required this.userAccount,
    required this.initValue,
  }) : super(key: key);

  void _restrictDialog() {
    final controller = Get.find<FollowSwitchButtonController>(tag: '$runtimeType-$id');
    final items = {
      Restrict.public: '公开',
      Restrict.private: '悄悄',
    };
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          color: Get.theme.colorScheme.background,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: Get.height * 0.35, minHeight: Get.height * 0.35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextWidget('关注用户', fontSize: 18, isBold: true),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        height: 35,
                        width: 70,
                        child: DropdownButtonWidgetHideUnderline(
                          child: DropdownButtonWidget<Restrict>(
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
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(userName, fontSize: 16),
                    TextWidget(userAccount, fontSize: 12),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        elevation: 0,
                        color: Get.theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide.none,
                        ),
                        minWidth: double.infinity,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextWidget('取消', fontSize: 18, color: Colors.white, isBold: true),
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: MaterialButton(
                        elevation: 0,
                        color: const Color(0xFFFF6289),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        minWidth: double.infinity,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: TextWidget('确认', fontSize: 18, color: Colors.white, isBold: true),
                        ),
                        onPressed: () async {
                          controller.changeFollowState(isChange: true, restrict: Restrict.public);
                          Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
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
              ? SizedBox(
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
