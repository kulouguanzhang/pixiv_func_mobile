/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:state.dart
 * 创建时间:2021/11/29 下午1:39
 * 作者:小草
 */

import 'package:flutter/cupertino.dart';
import 'package:pixiv_func_mobile/app/api/dto/search_autocomplete.dart';
import 'package:pixiv_func_mobile/models/search_filter.dart';

class SearchInputState {
  final TextEditingController wordInput = TextEditingController();

  bool get inputIsNumber => null != int.tryParse(wordInput.text);

  int get inputAsNumber => int.parse(wordInput.text);

  String get inputAsString => wordInput.text;

  SearchFilter filter = SearchFilter.create();
  SearchAutocomplete? searchAutocomplete;
  int type = 0;

  DateTime lastInputTime = DateTime.now();
}
