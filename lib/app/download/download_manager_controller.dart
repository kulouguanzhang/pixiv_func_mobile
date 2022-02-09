/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:download_manager_controller.dart
 * 创建时间:2021/11/26 下午4:59
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_mobile/models/download_task.dart';

class DownloadManagerController extends GetxController implements GetxService {
  final List<DownloadTask> _tasks = [];

  void add(DownloadTask task) {
    _tasks.add(task);
    update();
  }

  void stateChange(int index, void Function(DownloadTask task) changer) {
    changer(tasks[index]);
    update();
  }

  List<DownloadTask> get tasks => _tasks;
}
