import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/user_preview.dart';
import 'package:pixiv_dart_api/vo/user_page_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';
import 'package:pixiv_func_mobile/app/local_data/account_service.dart';

class FansListSource extends DataSourceBase<UserPreview> {
  FansListSource();

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getFollowerPage(
          Get.find<AccountService>().currentUserId,
          cancelToken: cancelToken,
        );
        nextUrl = result.nextUrl;
        addAll(result.userPreviews);
        initData = true;
      } else {
        if (hasMore) {
          final result = await api.getNextPage<UserPageResult>(nextUrl!, cancelToken: cancelToken);
          nextUrl = result.nextUrl;
          addAll(result.userPreviews);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
