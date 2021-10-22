/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:follower_new_novel_model.dart
 * 创建时间:2021/10/4 下午8:36
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/novel_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/view_model/follower_new_novel_model.dart';

class FollowerNewNovelContent extends StatelessWidget {
  final bool? restrict;
  const FollowerNewNovelContent(this.restrict, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: FollowerNewNovelModel(restrict),
      builder: (BuildContext context, FollowerNewNovelModel model, Widget? child) {
        return RefresherWidget(
          model,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    for (final novel in model.list)
                      Card(
                        child: NovelPreviewer(novel),
                      )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
