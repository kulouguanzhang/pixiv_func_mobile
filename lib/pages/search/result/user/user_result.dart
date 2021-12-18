/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_result.dart
 * 创建时间:2021/11/29 下午1:48
 * 作者:小草
 */
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/entity/user_preview.dart';
import 'package:pixiv_func_android/app/data/data_tab_view_content.dart';
import 'package:pixiv_func_android/app/i18n/i18n.dart';
import 'package:pixiv_func_android/components/pull_to_refresh_header/pull_to_refresh_header.dart';
import 'package:pixiv_func_android/components/user_previewer/user_previewer.dart';
import 'package:pixiv_func_android/pages/search/result/user/source.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class SearchUserResultPage extends StatelessWidget {
  final String word;

  const SearchUserResultPage({Key? key, required this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final source = SearchUserResultListSource(word);

    return Scaffold(
      body: PullToRefreshNotification(
        onRefresh: () async => await source.refresh(true),
        maxDragOffset: 100,
        child: ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text('${I18n.search.tr}${I18n.user.tr}:$word'),
              ),
              PullToRefreshContainer((info) => PullToRefreshHeader(info: info)),
            ];
          },
          body: DataTabViewContent<UserPreview>(
            sourceList: source,
            itemBuilder: (BuildContext context, UserPreview item, int index) => UserPreviewer(userPreview: item),
          ),
          floatHeaderSlivers: true,
        ),
      ),
    );
  }
}
