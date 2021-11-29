/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:novel_detail_dialog.dart
 * 创建时间:2021/11/25 下午2:02
 * 作者:小草
 */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/entity/novel.dart';
import 'package:pixiv_func_android/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_android/components/bookmark_switch_button/bookmark_switch_button.dart';
import 'package:pixiv_func_android/components/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_android/pages/novel/novel.dart';

class NovelDetailDialog extends StatelessWidget {
  final Novel novel;

  const NovelDetailDialog({Key? key, required this.novel}) : super(key: key);
  static const padding = EdgeInsets.only(top: 10, bottom: 10);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // backgroundColor: Get.theme.colorScheme.background,
      contentPadding: const EdgeInsets.only(left: 5, right: 5),
      title: Padding(
        padding: padding,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: AvatarFromUrl(novel.user.profileImageUrls.medium),
          title: Text(novel.user.name),
        ),
      ),
      content: SizedBox(
        width: window.physicalSize.width,
        height: window.physicalSize.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(),
              Padding(
                padding: padding,
                child: Text(novel.title),
              ),
              const Divider(),
              Padding(
                padding: padding,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 5,
                  spacing: 5,
                  children: [
                    for (final tag in novel.tags)
                      RichText(
                        text: TextSpan(
                          style: Get.theme.textTheme.bodyText2,
                          children: null != tag.translatedName
                              ? [
                                  TextSpan(
                                    text: '#${tag.name}  ',
                                    style: TextStyle(color: Get.theme.colorScheme.primary),
                                  ),
                                  TextSpan(
                                    text: '${tag.translatedName}',
                                  ),
                                ]
                              : [
                                  TextSpan(
                                    text: '#${tag.name}',
                                    style: TextStyle(color: Get.theme.colorScheme.primary),
                                  ),
                                ],
                        ),
                      )
                  ],
                ),
              ),
              const Divider(),
              Visibility(
                visible: novel.caption.isNotEmpty,
                child: Padding(
                  padding: padding,
                  child: Card(
                    child: HtmlRichText(
                      novel.caption,
                      canShowOriginal: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(onPressed: () => Get.back(), child: const Text('关闭')),
        OutlinedButton(
            onPressed: () {
              Get.back();
              Get.to(NovelPage(id: novel.id), preventDuplicates: false);
            },
            child: const Text('阅读')),
        BookmarkSwitchButton(id: novel.id, floating: false, initValue: novel.isBookmarked),
      ],
    );
  }
}
