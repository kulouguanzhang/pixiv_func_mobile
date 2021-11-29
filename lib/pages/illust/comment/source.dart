/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:source.dart
 * 创建时间:2021/11/28 上午12:55
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/api/model/comments.dart';
import 'package:pixiv_func_android/app/data/data_source_base.dart';
import 'package:pixiv_func_android/models/comment_tree.dart';

class IllustCommentListSource extends DataSourceBase<CommentTree> {
  final int id;

  IllustCommentListSource(this.id);

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getIllustComments(
          id,
          cancelToken: cancelToken,
        );
        nextUrl = result.nextUrl;
        addAll(
          [
            for (final comment in result.comments) CommentTree(data: comment, parent: null),
          ],
        );
        initData = true;
      } else {
        if (hasMore) {
          final result = await api.next<Comments>(nextUrl!, cancelToken: cancelToken);
          nextUrl = result.nextUrl;
          addAll(
            [
              for (final comment in result.comments) CommentTree(data: comment, parent: null),
            ],
          );
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
