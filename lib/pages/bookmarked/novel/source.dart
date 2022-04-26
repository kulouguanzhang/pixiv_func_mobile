import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_dart_api/vo/novel_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';
import 'package:pixiv_func_mobile/app/local_data/account_service.dart';
import 'package:pixiv_func_mobile/models/bookmarked_filter.dart';

class BookmarkedNovelListSource extends DataSourceBase<Novel> {
  final BookmarkedFilter filter;

  BookmarkedNovelListSource(this.filter);

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getUserNovelBookmarkPage(
          int.parse(Get.find<AccountService>().current!.user.id),
          restrict: filter.restrict,
          cancelToken: cancelToken,
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
