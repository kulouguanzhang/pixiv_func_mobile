import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';

import 'controller.dart';

class BookmarkSwitchButton extends StatelessWidget {
  final int id;
  final bool floating;
  final bool initValue;
  final bool isNovel;

  const BookmarkSwitchButton({
    Key? key,
    required this.id,
    required this.floating,
    required this.initValue,
    this.isNovel = false,
  }) : super(key: key);

  void _restrictDialog() {
    final controller = Get.find<BookmarkSwitchButtonController>(tag: '$runtimeType:$id');
    Get.dialog(
      ObxValue<Rx<Restrict>>(
        (data) {
          return AlertDialog(
            title: Text('${I18n.follow.tr}${I18n.illust.tr}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: Text(I18n.public.tr),
                  value: Restrict.public,
                  groupValue: data.value,
                  onChanged: (Restrict? value) {
                    if (null != value) {
                      data.value = value;
                    }
                  },
                ),
                RadioListTile(
                  title: Text(I18n.private.tr),
                  value: Restrict.private,
                  groupValue: data.value,
                  onChanged: (Restrict? value) {
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
                  controller.changeBookmarkState(isChange: true, restrict: data.value);
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
        Restrict.public.obs,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controllerTag = '$runtimeType:$id';
    final bool isRootController = !Get.isRegistered<BookmarkSwitchButtonController>(tag: controllerTag);
    if (isRootController) {
      Get.put(BookmarkSwitchButtonController(id, initValue: initValue, isNovel: isNovel), tag: controllerTag);
    }

    return GetBuilder<BookmarkSwitchButtonController>(
      tag: controllerTag,
      dispose: (state) {
        if (isRootController) {
          Get.delete<BookmarkSwitchButtonController>(tag: controllerTag);
        }
      },
      builder: (controller) {
        if (floating) {
          return GestureDetector(
            onLongPress: () => controller.requesting || controller.isBookmarked ? null : _restrictDialog(),
            child: FloatingActionButton(
              backgroundColor: Get.theme.colorScheme.onBackground,
              heroTag: 'IllustBookmarkButtonHero:$id',
              onPressed: () => controller.requesting ? null : controller.changeBookmarkState(),
              child: controller.requesting
                  ? const CircularProgressIndicator()
                  : controller.isBookmarked
                      ? const Icon(
                          Icons.favorite_sharp,
                          color: Colors.pinkAccent,
                        )
                      : Icon(
                          Icons.favorite_outline_sharp,
                          color: Get.theme.colorScheme.background,
                        ),
            ),
          );
        } else {
          return controller.requesting
              ? const RefreshProgressIndicator()
              : GestureDetector(
                  onLongPress: controller.isBookmarked ? null : () => _restrictDialog(),
                  child: IconButton(
                    splashRadius: 20,
                    onPressed: () => controller.changeBookmarkState(),
                    icon: controller.isBookmarked
                        ? const Icon(
                            Icons.favorite_sharp,
                            color: Colors.pinkAccent,
                          )
                        : Icon(
                            Icons.favorite_outline_sharp,
                            color: Get.theme.colorScheme.onSurface,
                          ),
                  ),
                );
        }
      },
    );
  }
}
