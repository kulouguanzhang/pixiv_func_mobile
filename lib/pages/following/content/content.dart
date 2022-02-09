/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:content.dart
 * 创建时间:2021/11/25 下午11:42
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/app/api/entity/user_preview.dart';
import 'package:pixiv_func_mobile/components/loading_more_indicator/loading_more_indicator.dart';
import 'package:pixiv_func_mobile/components/user_previewer/user_previewer.dart';

import 'source.dart';

class FollowingContent extends StatelessWidget {
  final int id;
  final bool restrict;

  const FollowingContent({Key? key, required this.id, required this.restrict}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final source = FollowingListSource(id, restrict);
    return LoadingMoreList(
      ListConfig(
        itemBuilder: (BuildContext context, UserPreview item, int index) {
          return UserPreviewer(userPreview: item);
        },
        sourceList: source,
        itemCountBuilder: (int count) => source.length,
        indicatorBuilder: (BuildContext context, IndicatorStatus status) => LoadingMoreIndicator(
          status: status,
          errorRefresh: () => source.errorRefresh(),
        ),
      ),
    );
  }
}
