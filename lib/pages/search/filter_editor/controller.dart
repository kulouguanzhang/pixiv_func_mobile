/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:controller.dart
 * 创建时间:2021/11/29 下午12:03
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/enums.dart';
import 'package:pixiv_func_android/app/i18n/i18n.dart';
import 'package:pixiv_func_android/models/search_filter.dart';

class SearchFilterEditorController extends GetxController {
  SearchFilter filter;

  SearchFilterEditorController(SearchFilter filter) : filter = SearchFilter.copy(filter);

  SearchTarget get target => filter.target;

  DateTime get currentDate => DateTime.now();

  int get dateTimeRangeType => filter.dateTimeRangeType;

  int get bookmarkTotalSelected => bookmarkTotalItems.indexWhere((item) {
        return item == filter.bookmarkTotal;
      });

  final bookmarkTotalItems = <int?>[
    null,
    100,
    250,
    500,
    1000,
    5000,
    7500,
    10000,
    20000,
    30000,
    50000,
    100000,
  ];

  set bookmarkTotalSelected(int value) {
    bookmarkTotal = bookmarkTotalItems[value];
    update();
  }

  set dateTimeRangeType(int value) {
    if (value != filter.dateTimeRangeType) {
      filter.dateTimeRangeType = value;
      update();
    }
  }

  set target(SearchTarget value) {
    filter.target = value;
    update();
  }

  SearchSort get sort => filter.sort;

  set sort(SearchSort value) {
    filter.sort = value;
    update();
  }

  bool get enableDateRange => filter.enableDateRange;

  set enableDateRange(bool value) {
    filter.enableDateRange = value;
    update();
  }

  String get startDate => filter.formatStartDate;

  String get endDate => filter.formatEndDate;

  DateTimeRange get dateTimeRange => filter.dateTimeRange;

  set dateTimeRange(DateTimeRange value) {
    filter.dateTimeRange = value;
    update();
  }

  int? get bookmarkTotal => filter.bookmarkTotal;

  set bookmarkTotal(int? value) {
    filter.bookmarkTotal = value;
    update();
  }

  String get bookmarkTotalText {
    final item = bookmarkTotalItems[bookmarkTotalSelected];
    if (null == item) {
      return I18n.bookmarksNumUnlimited.tr;
    } else {
      return '$item ${I18n.bookmarksOverNum.tr}';
    }
  }
}
