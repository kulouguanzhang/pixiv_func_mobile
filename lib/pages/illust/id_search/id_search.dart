import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/pages/illust/illust.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class IllustIdSearchPage extends StatelessWidget {
  final int id;

  const IllustIdSearchPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(IllustIdSearchController(id));
    return GetBuilder<IllustIdSearchController>(
      builder: (controller) {
        if (PageState.loading == controller.state) {
          return ScaffoldWidget(
            titleWidget: TextWidget('插画ID$id', isBold: true),
            child: Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          );
        } else if (PageState.error == controller.state) {
          return ScaffoldWidget(
            titleWidget: TextWidget('插画ID$id', isBold: true),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => controller.loadData(),
              child: Container(
                alignment: Alignment.center,
                child: const TextWidget('加载失败,点击重试', fontSize: 16),
              ),
            ),
          );
        } else if (PageState.notFound == controller.state) {
          return ScaffoldWidget(
            titleWidget: TextWidget('插画ID$id', isBold: true),
            child: Container(
              alignment: Alignment.center,
              child: TextWidget('插画ID$id不存在', fontSize: 16),
            ),
          );
        } else {
          if (null != controller.illustDetail) {
            return IllustPage(illust: controller.illustDetail!.illust);
          } else {
            return const SizedBox();
          }
        }
      },
    );
  }
}
