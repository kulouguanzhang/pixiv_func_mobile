import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/components/select_button/select_button.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'controller.dart';

class MeWebSettingsPage extends StatelessWidget {
  final UserDetailResult currentDetail;

  const MeWebSettingsPage({Key? key, required this.currentDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MeWebSettingsController(currentDetail));
    return GetBuilder<MeWebSettingsController>(
      builder: (controller) => ScaffoldWidget(
        title: 'Web设置',
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
              child: Row(
                children: [
                  const TextWidget('年龄限制', fontSize: 16),
                  const Spacer(),
                  SelectButtonWidget(
                    items: const {
                      '全年龄': 0,
                      'R-18': 1,
                      'R-18G': 2,
                    },
                    value: controller.restrict,
                    onChanged: controller.restrictOnChange,
                    width: 45,
                    height: 70,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
