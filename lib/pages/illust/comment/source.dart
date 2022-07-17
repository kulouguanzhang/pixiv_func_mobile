import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/comment_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/data_content/data_source_base.dart';
import 'package:pixiv_func_mobile/models/comment_tree.dart';

class IllustCommentListSource extends DataSourceBase<CommentTree> {
  final int id;

  IllustCommentListSource(this.id);

  final api = Get.find<ApiClient>();

  @override
  Future<List<CommentTree>> init(CancelToken cancelToken) {
    return api.getIllustCommentPage(id, cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return [
        for (final comment in result.comments) CommentTree(data: comment, parent: null),
      ];
    });
  }

  @override
  Future<List<CommentTree>> next(CancelToken cancelToken) {
    return api.getNextPage<CommentPageResult>(nextUrl!, cancelToken: cancelToken).then((result) {
      nextUrl = result.nextUrl;
      return [
        for (final comment in result.comments) CommentTree(data: comment, parent: null),
      ];
    });
  }

  @override
  String tag() => '$runtimeType-$id';
}
