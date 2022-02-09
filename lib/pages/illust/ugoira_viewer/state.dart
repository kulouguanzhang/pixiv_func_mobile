/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:state.dart
 * 创建时间:2021/11/28 下午1:38
 * 作者:小草
 */
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:pixiv_func_mobile/app/api/dto/ugoira_metadata.dart';

class UgoiraViewerState {
  final List<Uint8List> imageFiles = [];

  final List<ui.Image> images = [];

  final List<int> delays = [];

  ui.Size size = ui.Size.zero;

  UgoiraMetadata? ugoiraMetadata;

  Response<Uint8List>? gifZipResponse;

  bool loaded = false;

  bool loading = false;

  bool init = false;
}
