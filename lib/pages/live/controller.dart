import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/live_detail_result.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_live_proxy_server/pixiv_live_proxy_server.dart';

class LiveController extends GetxController {
  final String id;

  LiveController(this.id);

  PageState state = PageState.none;

  LiveDetailResult? _liveDetailResult;

  LiveDetailResult? get liveDetail => _liveDetailResult;

  final CancelToken cancelToken = CancelToken();

  FijkPlayer? ijkPlayer;

  PixivLiveProxyServer? _proxyServer;

  void loadData() {
    state = PageState.loading;
    update();
    Get.find<ApiClient>().getLiveDetail(id, cancelToken: cancelToken).then((result) async{
      _liveDetailResult = result;

      await initPlayer(result.data.owner.hlsMovie.url);
      state = PageState.complete;
    }).catchError((e) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        state = PageState.notFound;
      } else {
        state = PageState.error;
      }
      state = PageState.error;
    }).whenComplete(() {
      update();
    });
  }

  Future<void> initPlayer(String url) async {
    final uri = Uri.parse(url);
    _proxyServer = PixivLiveProxyServer(url: url, port: 55555, serverIp: '210.140.92.212');
    ijkPlayer = FijkPlayer();
    ijkPlayer!.setDataSource(url.replaceFirst('${uri.scheme}://${uri.host}', 'http://127.0.0.1:55555'),autoPlay: true);
    await _proxyServer!.listen();
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  @override
  void onClose() {
    cancelToken.cancel();
    ijkPlayer?.release();
    _proxyServer?.close();
    super.onClose();
  }
}
