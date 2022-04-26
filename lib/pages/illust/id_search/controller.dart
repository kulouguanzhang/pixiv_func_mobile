import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/illust_detail_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';

class IllustIdSearchController extends GetxController {
  final int id;

  IllustIdSearchController(this.id);

  IllustDetailResult? illustDetail;

  final CancelToken cancelToken = CancelToken();

  final ApiClient api = Get.find<ApiClient>();

  bool loading = false;

  bool initFailed = false;

  void loadData() {
    loading = true;
    initFailed = false;
    update();
    api.getIllustDetail(id, cancelToken: cancelToken).then((result) {
      illustDetail = result;
    }).catchError((e) {
      initFailed = true;
    }).whenComplete(() {
      loading = false;
      update();
    });
  }
}
