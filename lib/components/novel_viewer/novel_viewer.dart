import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/components/novel_viewer/controller.dart';

class NovelViewer extends StatelessWidget {
  final String text;
  final int id;

  const NovelViewer({Key? key, required this.text, required this.id}) : super(key: key);

  String get controllerTag => '$runtimeType-$id';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Get.put(NovelViewerController(text, constraints.maxWidth, constraints.maxHeight), tag: controllerTag);
        return GetBuilder<NovelViewerController>(
          tag: controllerTag,
          builder: (controller) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (TapUpDetails details) {
              if (details.globalPosition.dx < constraints.maxWidth * 0.3) {
                controller.previousPage();
              } else if (details.globalPosition.dx > constraints.maxWidth * 0.7) {
                controller.nextPage();
              }
            },
            child: PageView.builder(
              onPageChanged: (index) {
                if (index > controller.pageIndex) {
                  controller.nextPage();
                } else if (index < controller.pageIndex) {
                  controller.previousPage();
                }
              },
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.topLeft,
                  height: constraints.maxHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final text in controller.list[index].renderTextLines)
                        Text(
                          text,
                          style: controller.style,
                          textDirection: TextDirection.ltr,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
