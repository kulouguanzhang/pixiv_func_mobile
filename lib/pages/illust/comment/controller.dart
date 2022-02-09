/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:controller.dart
 * 创建时间:2021/11/28 上午1:20
 * 作者:小草
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/api/dto/comments.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/models/comment_tree.dart';
import 'package:pixiv_func_mobile/pages/illust/comment/source.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class IllustCommentController extends GetxController {
  final int id;

  IllustCommentController(this.id) : source = IllustCommentListSource(id);

  final IllustCommentListSource source;

  final TextEditingController commentInput = TextEditingController();

  final CancelToken cancelToken = CancelToken();

  CommentTree? _repliesCommentTree;

  CommentTree? get repliesCommentTree => _repliesCommentTree;

  set repliesCommentTree(CommentTree? value) {
    _repliesCommentTree = value;
    update();
  }

  bool get isReplies => null != _repliesCommentTree;

  String get commentInputLabel =>
      isReplies ? '${I18n.replice.tr} ${repliesCommentTree!.data.user.name}' : '${I18n.comment.tr} ${I18n.illust.tr}';

  @override
  void dispose() {
    source.dispose();
    cancelToken.cancel();
    super.dispose();
  }

  void loadFirstReplies(CommentTree commentTree) {
    commentTree.loading = true;
    source.setState();
    if (commentTree.data.hasReplies) {
      Get.find<ApiClient>().getCommentReplies(commentTree.data.id, cancelToken: cancelToken).then((result) {
        commentTree.children.addAll(result.comments.map((e) => CommentTree(data: e, parent: commentTree)));
        commentTree.nextUrl = result.nextUrl;
      }).catchError((e) {
        Log.e('加载回复异常', e);
      }).whenComplete(() {
        commentTree.loading = false;
        source.setState();
      });
    }
  }

  void loadNextReplies(CommentTree commentTree) {
    if (commentTree.hasNext) {
      commentTree.loading = true;
      source.setState();
      Get.find<ApiClient>().next<Comments>(commentTree.nextUrl!, cancelToken: cancelToken).then((result) {
        commentTree.children.addAll(result.comments.map((e) => CommentTree(data: e, parent: commentTree)));
        commentTree.nextUrl = result.nextUrl;
      }).catchError((e) {
        Log.e('加载下一条回复异常', e);
      }).whenComplete(() {
        commentTree.loading = false;
        source.setState();
      });
    }
  }

  void doAddComment() {
    final commentTree = repliesCommentTree;
    final content = commentInput.text;
    commentInput.clear();
    Get.find<ApiClient>().addComment(id, comment: content, parentCommentId: commentTree?.data.id).then((result) {
      if (null != commentTree) {
        commentTree.children.insert(0, CommentTree(data: result, parent: commentTree));
        source.setState();
        Get.find<PlatformApi>().toast('${I18n.replice.tr} ${commentTree.data.user.name} ${I18n.success.tr}');
      } else {
        source.insert(0, CommentTree(data: result, parent: null));
        source.setState();
        Get.find<PlatformApi>().toast('${I18n.comment.tr}${I18n.illust.tr}${I18n.success.tr}');
      }
    }).catchError((e, s) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        Get.find<PlatformApi>().toast(I18n.commentNotFoundHint.tr);
      } else {
        Get.find<PlatformApi>().toast(I18n.commentFailedHint.tr);
      }
      Log.e('评论异常', e, s);
    });
  }

  void doDeleteComment(
    CommentTree commentTree,
  ) {
    Get.find<ApiClient>().deleteComment(commentTree.data.id).then((value) {
      if (null == commentTree.parent) {
        source.removeWhere((element) => commentTree.data.id == element.data.id);
        source.setState();
      } else {
        commentTree.parent!.children.removeWhere((element) => commentTree.data.id == element.data.id);
        source.setState();
      }
      Get.find<PlatformApi>().toast('${I18n.delete.tr}${I18n.comment.tr}${I18n.success.tr}');
    }).catchError((e) {
      Log.e('删除评论失败', e);
      Get.find<PlatformApi>().toast('${I18n.delete.tr}${I18n.comment.tr}${I18n.failed.tr}');
    });
  }
}
