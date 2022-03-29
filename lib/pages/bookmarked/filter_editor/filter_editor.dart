/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:filter_editor.dart
 * 创建时间:2021/10/4 下午2:56
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/sliding_segmented_control/sliding_segmented_control.dart';
import 'package:pixiv_func_mobile/models/bookmarked_filter.dart';

class BookmarkedFilterEditor extends StatelessWidget {
  final BookmarkedFilter filter;

  const BookmarkedFilterEditor({Key? key, required this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<BookmarkedFilter>>(
      (Rx<BookmarkedFilter> data) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlidingSegmentedControl(
                children: <bool, Widget>{
                  true: Text(I18n.public.tr),
                  false: Text(I18n.private.tr),
                },
                groupValue: data.value.restrict,
                onValueChanged: (bool? value) {
                  if (null != value) {
                    data.update((val) {
                      val?.restrict = value;
                    });
                  }
                },
                splitEqually: false,
              )
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back(result: data.value);
              },
              child: Text(I18n.confirm.tr),
            ),
          ],
        );
      },
      BookmarkedFilter.copy(filter).obs,
    );
  }
}
