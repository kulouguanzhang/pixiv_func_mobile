import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/widgets/dropdown/dropdown.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class BookmarkSwitchButton extends StatelessWidget {
  final int id;
  final String title;
  final bool initValue;
  final bool isNovel;
  final bool floating;

  const BookmarkSwitchButton({
    Key? key,
    required this.id,
    required this.title,
    required this.initValue,
    this.isNovel = false,
    this.floating = false,
  }) : super(key: key);

  void _restrictDialog() {
    final controller = Get.find<BookmarkSwitchButtonController>(tag: '$runtimeType-$id');
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
                      child: TextWidget('收藏插画', fontSize: 18, isBold: true),
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
                    TextWidget(title, fontSize: 16),
                    TextWidget('$id', fontSize: 12),
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
                          controller.changeBookmarkState(isChange: true, restrict: Restrict.public);
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
              backgroundColor: Get.theme.cardColor,
              heroTag: 'IllustBookmarkButtonHero:$id',
              onPressed: () => controller.requesting ? null : controller.changeBookmarkState(),
              child: controller.requesting
                  ? const CircularProgressIndicator()
                  : controller.isBookmarked
                      ? Icon(
                          Icons.favorite_sharp,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Icon(
                          Icons.favorite_outline_sharp,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
            ),
          );
        }
        if (controller.requesting) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: CupertinoActivityIndicator(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          );
        } else {
          return GestureDetector(
            onLongPress: () => controller.requesting || controller.isBookmarked ? null : _restrictDialog(),
            child: IconButton(
              splashRadius: 20,
              iconSize: 24,
              onPressed: () => controller.changeBookmarkState(),
              icon: controller.isBookmarked
                  ? Icon(
                      Icons.favorite_sharp,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : const Icon(Icons.favorite_outline_sharp),
            ),
          );
        }
      },
    );
  }
}
