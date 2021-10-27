/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_input_model.dart
 * 创建时间:2021/9/3 下午4:15
 * 作者:小草
 */

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixiv_func_android/api/model/search_autocomplete.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/util/log.dart';
import 'package:pixiv_func_android/model/search_filter.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class SearchInputModel extends BaseViewModel {
  SearchAutocomplete? _searchAutocomplete;
  final TextEditingController wordInput = TextEditingController();

  final CancelToken cancelToken = CancelToken();

  @override
  void dispose() {
    cancelToken.cancel();
    wordInput.dispose();
    super.dispose();
  }

  SearchFilter filter = SearchFilter.create();

  SearchAutocomplete? get searchAutocomplete => _searchAutocomplete;

  set searchAutocomplete(SearchAutocomplete? value) {
    _searchAutocomplete = value;
    if (null == value) {
      cancelToken.cancel();
    }
    notifyListeners();
  }

  int _type = 0;

  int get type => _type;

  set type(int value) {
    if (value != _type) {
      _type = value;
      notifyListeners();
    }
  }

  bool get inputIsNumber => null != int.tryParse(wordInput.text);

  int get inputAsNumber => int.parse(wordInput.text);

  String get inputAsString => wordInput.text;

  DateTime _lastInputTime = DateTime.now();

  DateTime get lastInputTime => _lastInputTime;

  set lastInputTime(DateTime value) {
    _lastInputTime = value;
    notifyListeners();
  }

  CancelableOperation<SearchAutocomplete>? _cancelableTask;

  void startAutocomplete() {
    Future.delayed(const Duration(seconds: 1), () {
      if (DateTime.now().difference(lastInputTime) > const Duration(seconds: 1)) {
        loadAutocomplete();
      }
    });
  }

  void loadAutocomplete() {
    if (inputAsString.isEmpty) {
      return;
    }
    cancelToken.cancel();
    searchAutocomplete = null;
    pixivAPI.searchAutocomplete(inputAsString, cancelToken: cancelToken);

    _cancelableTask?.value.then((result) {
      searchAutocomplete = result;
    }).catchError((e, s) {
      Log.e('关键字自动补全失败', e, s);
    });
  }
}
