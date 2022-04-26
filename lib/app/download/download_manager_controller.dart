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
