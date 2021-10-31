/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:base_view_state_refresh_list_model.dart
 * 创建时间:2021/8/23 上午12:17
 * 作者:小草
 */

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixiv_func_android/util/log.dart';
import 'package:pixiv_func_android/provider/base_view_state_list_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseViewStateRefreshListModel<T> extends BaseViewStateListModel<T> {
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  final ScrollController scrollController = ScrollController();

  CancelToken cancelToken = CancelToken();

  BaseViewStateRefreshListModel() {
    scrollController.addListener(scrollEvent);
  }

  @override
  void dispose() {
    cancelToken.cancel();
    refreshController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  bool _showToTop = false;

  bool get showToTop => _showToTop;

  set showToTop(bool value) {
    _showToTop = value;
    notifyListeners();
  }

  void scrollEvent() {
    if (scrollController.hasClients) {
      final show = scrollController.offset > 1200;
      if (show != showToTop) {
        showToTop = show;
      }
    }
  }

  void scrollToTop() {
    if (scrollController.hasClients) {
      if (scrollController.offset != 0) {
        scrollController.jumpTo(0);
      }
    }
  }

  void refresh() {
    cancelToken.cancel();
    refreshController.refreshToIdle();
    cancelToken = CancelToken();
    refreshController.requestRefresh();
  }

  ///刷新
  void refreshRoutine() {
    initialized = false;
    nextUrl = null;
    list.clear();
    setBusy();

    loadFirstDataRoutine().then((result) {
      refreshController.refreshCompleted();
      if (!hasNext) {
        refreshController.loadNoData();
      }
      initialized = true;
      if (result.isEmpty) {
        setEmpty();
      } else {
        list.addAll(result);
        setIdle();
      }
    }).catchError((e, s) {
      refreshController.refreshFailed();
      Log.e('异常', e, s);

      setInitFailed(e, s);
    });
  }

  ///加载下一页
  void nextRoutine() async {
    if (hasNext) {
      setBusy();
      loadNextDataRoutine().then((result) {
        list.addAll(result);
        if (hasNext) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
      }).catchError((e, s) {
        Log.d('异常', e, s);
        refreshController.loadFailed();
      }).whenComplete(() => setIdle());
    }
  }

  ///内部使用
  ///
  ///首次加载数据的实现
  Future<List<T>> loadFirstDataRoutine();

  ///内部使用
  ///
  ///加载下一条数据的实现
  Future<List<T>> loadNextDataRoutine();
}
