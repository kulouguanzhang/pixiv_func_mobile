import 'package:dio/dio.dart';
import 'package:loading_more_list/loading_more_list.dart';

abstract class DataSourceBase<T> extends LoadingMoreBase<T> {
  bool _initData = false;
  String? nextUrl;

  @override
  bool get hasMore => !_initData || null != nextUrl;
  final CancelToken _cancelToken = CancelToken();

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    _initData = false;
    nextUrl = null;
    final result = super.refresh(notifyStateChanged);
    return result;
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!_initData) {
        addAll(await init(_cancelToken));
        _initData = true;
      } else {
        if (hasMore) {
          addAll(await next(_cancelToken));
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<T>> init(CancelToken cancelToken);

  Future<List<T>> next(CancelToken cancelToken);

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }
}
