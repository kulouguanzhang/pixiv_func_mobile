import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/trending_tag_list_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';

class TrendingIllustListSource extends DataSourceBase<TrendTag> {
  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getTrendingTagList(
          cancelToken: cancelToken,
        );

        addAll(result.trendTags);
        initData = true;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
