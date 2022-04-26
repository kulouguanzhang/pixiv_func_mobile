import 'package:dio/dio.dart';
import 'package:loading_more_list/loading_more_list.dart';

abstract class DataSourceBase<T> extends LoadingMoreBase<T> {
  bool initData = false;

  String? nextUrl;

  @override
  bool get hasMore => !initData || null != nextUrl;

  bool forceRefresh = false;

  CancelToken cancelToken = CancelToken();

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    initData = false;
    nextUrl = null;
    forceRefresh = !notifyStateChanged;
    final result = super.refresh(notifyStateChanged);
    forceRefresh = false;
    return result;
  }

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }
}
