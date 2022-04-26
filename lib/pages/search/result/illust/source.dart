import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_dart_api/vo/illust_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';

class SearchIllustResultListSource extends DataSourceBase<Illust> {
  final String word;

  SearchFilter filter;

  SearchIllustResultListSource(this.word, this.filter);

  final api = Get.find<ApiClient>();

  void onFilterChanged(SearchFilter value) {
    filter = value;
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getSearchIllustPage(
          word,
          filter.sort,
          filter.target,
          startDate: filter.enableDateRange ? filter.formatStartDate : null,
          endDate: filter.enableDateRange ? filter.formatEndDate : null,
          bookmarkTotal: filter.bookmarkTotal,
          cancelToken: cancelToken,
        );
        nextUrl = result.nextUrl;
        addAll(result.illusts);
        initData = true;
      } else {
        if (hasMore) {
          final result = await api.getNextPage<IllustPageResult>(nextUrl!, cancelToken: cancelToken);
          nextUrl = result.nextUrl;
          addAll(result.illusts);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
