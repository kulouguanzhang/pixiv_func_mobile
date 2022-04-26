import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/comment_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';
import 'package:pixiv_func_mobile/models/comment_tree.dart';

class IllustCommentListSource extends DataSourceBase<CommentTree> {
  final int id;

  IllustCommentListSource(this.id);

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getIllustCommentPage(
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
          final result = await api.getNextPage<CommentPageResult>(nextUrl!, cancelToken: cancelToken);
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
