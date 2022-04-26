import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/user_preview.dart';
import 'package:pixiv_func_mobile/app/data/data_content.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/pull_to_refresh_header/pull_to_refresh_header.dart';
import 'package:pixiv_func_mobile/components/user_previewer/user_previewer.dart';
import 'package:pixiv_func_mobile/pages/fans/source.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class FansPage extends StatelessWidget {
  const FansPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final source = FansListSource();
    return Scaffold(
      body: PullToRefreshNotification(
        onRefresh: () async => await source.refresh(true),
        maxDragOffset: 100,
        child: ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(title: Text(I18n.fans.tr)),
              PullToRefreshContainer((info) => PullToRefreshHeader(info: info)),
            ];
          },
          body: DataContent<UserPreview>(
            sourceList: source,
            itemBuilder: (content, item, index) => UserPreviewer(userPreview: item),
          ),
        ),
      ),
    );
  }
}
