import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/user_preview.dart';
import 'package:pixiv_func_mobile/components/loading_more_indicator/loading_more_indicator.dart';
import 'package:pixiv_func_mobile/components/user_previewer/user_previewer.dart';

import 'source.dart';

class FollowingContent extends StatelessWidget {
  final int id;
  final Restrict restrict;

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
