import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/user_preview.dart';
import 'package:pixiv_func_mobile/app/data/data_content.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/pull_to_refresh_header/pull_to_refresh_header.dart';
import 'package:pixiv_func_mobile/components/user_previewer/user_previewer.dart';
import 'package:pixiv_func_mobile/pages/search/result/user/source.dart';
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
          body: DataContent<UserPreview>(
            sourceList: source,
            itemBuilder: (BuildContext context, UserPreview item, int index) => UserPreviewer(userPreview: item),
          ),
          floatHeaderSlivers: true,
        ),
      ),
    );
  }
}
