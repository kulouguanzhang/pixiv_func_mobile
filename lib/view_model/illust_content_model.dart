/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_content_model.dart
 * 创建时间:2021/8/26 下午8:32
 * 作者:小草
 */

import 'package:dio/dio.dart';
import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/api/model/illusts.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_state_list_model.dart';
import 'package:pixiv_func_android/view_model/illust_previewer_model.dart';

class IllustContentModel extends BaseViewStateListModel<Illust> {
  final Illust illust;
  final IllustPreviewerModel? _illustPreviewerModel;

  IllustContentModel(this.illust, {IllustPreviewerModel? illustPreviewerModel})
      : _illustPreviewerModel = illustPreviewerModel {
    if (settingsManager.enableBrowsingHistory) {
      browsingHistoryManager.exist(illust.id).then((exist) {
        if (!exist) {
          browsingHistoryManager.insert(illust);
        }
      });
    }
  }

  final CancelToken cancelToken = CancelToken();

  bool _showOriginalCaption = false;

  bool _bookmarkRequestWaiting = false;

  bool get isBookmarked => illust.isBookmarked;

  set isBookmarked(bool value) {
    illust.isBookmarked = value;
    _illustPreviewerModel?.isBookmarked = value;
    notifyListeners();
  }

  bool get isUgoira => 'ugoira' == illust.type;

  bool get showOriginalCaption => _showOriginalCaption;

  set showOriginalCaption(bool value) {
    _showOriginalCaption = value;
    notifyListeners();
  }

  bool get bookmarkRequestWaiting => _bookmarkRequestWaiting;

  set bookmarkRequestWaiting(bool value) {
    _bookmarkRequestWaiting = value;
    notifyListeners();
  }

  void loadFirstData() {
    setBusy();

    pixivAPI.getIllustRelated(illust.id, cancelToken: cancelToken).then((result) {
      if (result.illusts.isNotEmpty) {
        list.addAll(result.illusts);
        setIdle();
      } else {
        setEmpty();
      }

      nextUrl = result.nextUrl;
      initialized = true;
    }).catchError((e, s) {
      Log.e('首次加载数据异常', e);
      setInitFailed(e, s);
    });
  }

  void loadNextData() {
    setBusy();
    pixivAPI.next<Illusts>(nextUrl!, cancelToken: cancelToken).then((result) {
      list.addAll(result.illusts);
      nextUrl = result.nextUrl;
      setIdle();
    }).catchError((e) {
      Log.e('加载下一条数据异常', e);
      setLoadFailed();
    });
  }

  void changeBookmarkState() {
    bookmarkRequestWaiting = true;
    if (!illust.isBookmarked) {
      pixivAPI.bookmarkAdd(illust.id).then((result) {
        isBookmarked = true;
      }).catchError((e) {
        Log.e('添加书签失败', e);
      }).whenComplete(() => bookmarkRequestWaiting = false);
    } else {
      pixivAPI.bookmarkDelete(illust.id).then((result) {
        isBookmarked = false;
      }).catchError((e) {
        Log.e('删除书签失败', e);
      }).whenComplete(() => bookmarkRequestWaiting = false);
    }
  }
}
