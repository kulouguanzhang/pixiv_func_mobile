import 'package:get/get.dart';
import 'package:pixiv_dart_api/enums.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_dart_api/vo/novel_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';

class FollowerNewNovelListSource extends DataSourceBase<Novel> {
  final Restrict? restrict;

  FollowerNewNovelListSource(this.restrict);

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getFollowNewNovelPage(
          cancelToken: cancelToken,
          restrict: restrict,
        );
        nextUrl = result.nextUrl;
        addAll(result.novels);
        initData = true;
      } else {
        if (hasMore) {
          final result = await api.getNextPage<NovelPageResult>(nextUrl!, cancelToken: cancelToken);
          nextUrl = result.nextUrl;
          addAll(result.novels);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
