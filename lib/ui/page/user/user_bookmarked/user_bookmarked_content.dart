/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_bookmarked_content.dart
 * 创建时间:2021/8/31 上午12:27
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/view_model/user_bookmarked_model.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class UserBookmarkedContent extends StatelessWidget {
  final int id;

  const UserBookmarkedContent(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: UserBookmarkedModel(id),
      builder: (BuildContext context, UserBookmarkedModel model, Widget? child) {
        return RefresherWidget(
          model,
          child: WaterfallFlow.builder(
            gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return IllustPreviewer(illust: model.list[index]);
            },
            itemCount: model.list.length,
          ),
        );
      },
      // autoKeep: true,
    );
  }
}
