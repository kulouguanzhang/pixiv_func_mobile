import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/user_preview.dart';
import 'package:pixiv_func_mobile/components/user_previewer/user_previewer.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/widgets/pull_to_refresh_header/pull_to_refresh_header.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

import 'source.dart';

class SearchUserResultPage extends StatelessWidget {
  final String keyword;

  const SearchUserResultPage({Key? key, required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      automaticallyImplyLeading: false,
      titleWidget: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
        },
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: false,
                  controller: TextEditingController(text: keyword),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    hintText: '搜索',
                    prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onBackground),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 3),
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Get.back(),
                child: TextWidget('取消', color: Theme.of(context).colorScheme.onSecondary),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      ),
      child: ExtendedNestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
          PullToRefreshContainer((info) => PullToRefreshHeader(info: info)),
        ],
        body: DataContent<UserPreview>(
          sourceList: SearchUserResultListSource(keyword),
          itemBuilder: (BuildContext context, UserPreview item, int index) => UserPreviewer(userPreview: item),
        ),
      ),
    );
  }
}
