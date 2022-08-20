import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/comment_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/models/comment_tree.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

import 'source.dart';

class IllustCommentController extends GetxController {
  final int id;

  IllustCommentController(this.id) : source = IllustCommentListSource(id);

  final IllustCommentListSource source;

  final CancelToken cancelToken = CancelToken();

  CommentTree? _repliesCommentTree;

  CommentTree? get repliesCommentTree => _repliesCommentTree;

  set repliesCommentTree(CommentTree? value) {
    _repliesCommentTree = value;
    update();
  }

  bool get isReplies => null != _repliesCommentTree;

  String get commentInputLabel => isReplies ? I18n.replyComment.trArgs([repliesCommentTree!.data.user.name]) : I18n.commentIllust.tr;

  void loadFirstReplies(CommentTree commentTree) {
    commentTree.loading = true;
    source.setState();
    if (commentTree.data.hasReplies) {
      Get.find<ApiClient>().getCommentReplyPage(commentTree.data.id, cancelToken: cancelToken).then((result) {
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
      Get.find<ApiClient>().getNextPage<CommentPageResult>(commentTree.nextUrl!, cancelToken: cancelToken).then((result) {
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

  void onCommentAdd({String? text, int? stampId}) {
    final commentTree = repliesCommentTree;

    Get.find<ApiClient>().postCommentAdd(id, comment: text, parentCommentId: commentTree?.data.id, stampId: stampId).then((result) {
      if (null != commentTree) {
        commentTree.children.insert(0, CommentTree(data: result.comment, parent: commentTree));
        source.setState();
        PlatformApi.toast(I18n.replySuccessHint.tr);
      } else {
        source.insert(0, CommentTree(data: result.comment, parent: null));
        source.setState();
        PlatformApi.toast(I18n.commentSuccessHint.tr);
      }
    }).catchError((e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        PlatformApi.toast(I18n.replyFailedHint.tr);
      } else {
        PlatformApi.toast(I18n.commentFailedHint.tr);
      }
      Log.e('评论异常', e);
    });
  }

  void onCommentDelete(
    CommentTree commentTree,
  ) {
    Get.find<ApiClient>().postCommentDelete(commentTree.data.id).then((value) {
      if (null == commentTree.parent) {
        source.removeWhere((element) => commentTree.data.id == element.data.id);
        source.setState();
      } else {
        commentTree.parent!.children.removeWhere((element) => commentTree.data.id == element.data.id);
        source.setState();
      }
      PlatformApi.toast(I18n.deleteCommentSuccessHint.tr);
    }).catchError((e) {
      Log.e('删除评论失败', e);
      PlatformApi.toast(I18n.deleteCommentFailedHint.tr);
    });
  }

  @override
  void onClose() {
    source.dispose();
    cancelToken.cancel();
    super.onClose();
  }
}
