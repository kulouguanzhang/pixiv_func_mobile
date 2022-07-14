import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_dart_api/vo/comment_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/models/comment_tree.dart';
import 'package:pixiv_func_mobile/pages/illust/comment/source.dart';
import 'package:pixiv_func_mobile/pages/illust/related/source.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class IllustController extends GetxController {
  Illust illust;

  IllustController(this.illust)
      : illustCommentSource = IllustCommentListSource(illust.id),
        illustRelatedSource = IllustRelatedListSource(illust.id);

  final IllustCommentListSource illustCommentSource;

  final IllustRelatedListSource illustRelatedSource;

  final TextEditingController commentInput = TextEditingController();

  final CancelToken cancelToken = CancelToken();

  CommentTree? _repliesCommentTree;

  CommentTree? get repliesCommentTree => _repliesCommentTree;

  double _previousOffset = 0;

  bool _showInputBox = false;

  bool get showInputBox => _showInputBox;

  final scrollController = ScrollController();

  set repliesCommentTree(CommentTree? value) {
    _repliesCommentTree = value;
    update();
  }

  bool get isReplies => null != _repliesCommentTree;

  String get commentInputLabel => isReplies ? '回复 ${repliesCommentTree!.data.user.name}' : '评论 插画';

  bool _showComment = false;

  bool get showComment => _showComment;

  @override
  void dispose() {
    illustRelatedSource.dispose();
    illustCommentSource.dispose();
    cancelToken.cancel();
    super.dispose();
  }

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        _showInputBox = _previousOffset < scrollController.offset;
        update();
        _previousOffset = scrollController.offset;
      }
    });
    super.onInit();
  }

  void loadFirstReplies(CommentTree commentTree) {
    commentTree.loading = true;
    illustCommentSource.setState();
    if (commentTree.data.hasReplies) {
      Get.find<ApiClient>().getCommentReplyPage(commentTree.data.id, cancelToken: cancelToken).then((result) {
        commentTree.children.addAll(result.comments.map((e) => CommentTree(data: e, parent: commentTree)));
        commentTree.nextUrl = result.nextUrl;
      }).catchError((e) {
        Log.e('加载回复异常', e);
      }).whenComplete(() {
        commentTree.loading = false;
        illustCommentSource.setState();
      });
    }
  }

  void loadNextReplies(CommentTree commentTree) {
    if (commentTree.hasNext) {
      commentTree.loading = true;
      illustCommentSource.setState();
      Get.find<ApiClient>().getNextPage<CommentPageResult>(commentTree.nextUrl!, cancelToken: cancelToken).then((result) {
        commentTree.children.addAll(result.comments.map((e) => CommentTree(data: e, parent: commentTree)));
        commentTree.nextUrl = result.nextUrl;
      }).catchError((e) {
        Log.e('加载下一条回复异常', e);
      }).whenComplete(() {
        commentTree.loading = false;
        illustCommentSource.setState();
      });
    }
  }

  void onCommentAdd() {
    final commentTree = repliesCommentTree;
    final content = commentInput.text;
    commentInput.clear();
    Get.find<ApiClient>().postCommentAdd(illust.id, comment: content, parentCommentId: commentTree?.data.id).then((result) {
      if (null != commentTree) {
        commentTree.children.insert(0, CommentTree(data: result.comment, parent: commentTree));
        illustCommentSource.setState();
        PlatformApi.toast('回复成功');
      } else {
        illustCommentSource.insert(0, CommentTree(data: result.comment, parent: null));
        illustCommentSource.setState();
        PlatformApi.toast('评论成功');
      }
    }).catchError((e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        PlatformApi.toast('评论失败,欲回复的评论不存在');
      } else {
        PlatformApi.toast('评论失败,请重试');
      }
      Log.e('评论异常', e);
    });
  }

  void onCommentDelete(
    CommentTree commentTree,
  ) {
    Get.find<ApiClient>().postCommentDelete(commentTree.data.id).then((value) {
      if (null == commentTree.parent) {
        illustCommentSource.removeWhere((element) => commentTree.data.id == element.data.id);
        illustCommentSource.setState();
      } else {
        commentTree.parent!.children.removeWhere((element) => commentTree.data.id == element.data.id);
        illustCommentSource.setState();
      }
      PlatformApi.toast('删除评论成功');
    }).catchError((e) {
      Log.e('删除评论失败', e);
      PlatformApi.toast('删除评论失败');
    });
  }

  void showCommentChangeState() {
    _showComment = !_showComment;
    update();
  }
}
