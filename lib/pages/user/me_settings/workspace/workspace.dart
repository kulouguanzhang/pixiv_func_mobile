import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/pages/user/me_settings/workspace/controller.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class MeWorkspaceSettingsPage extends StatelessWidget {
  final UserWorkspace workspace;

  const MeWorkspaceSettingsPage({Key? key, required this.workspace}) : super(key: key);

  Widget buildItem({required String name, required TextEditingController controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075, vertical: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          label: TextWidget(name),
          constraints: const BoxConstraints(maxHeight: 40),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(MeWorkspaceSettingsController(workspace));
    return GetBuilder<MeWorkspaceSettingsController>(
      builder: (controller) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: ScaffoldWidget(
          title: '工作环境',
          child: Column(
            children: [
              Flexible(
                child: ListView(
                  children: [
                    buildItem(name: '电脑', controller: controller.pcInput),
                    buildItem(name: '显示器', controller: controller.monitorInput),
                    buildItem(name: '软件', controller: controller.toolInput),
                    buildItem(name: '扫描仪', controller: controller.scannerInput),
                    buildItem(name: '数位板', controller: controller.tabletInput),
                    buildItem(name: '鼠标', controller: controller.mouseInput),
                    buildItem(name: '打印机', controller: controller.printerInput),
                    buildItem(name: '桌面上的东西', controller: controller.desktopInput),
                    buildItem(name: '画图时听的音乐', controller: controller.musicInput),
                    buildItem(name: '桌子', controller: controller.desktopInput),
                    buildItem(name: '椅子', controller: controller.chairInput),
                    buildItem(name: '其他', controller: controller.commentInput),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, bottom: 35),
                child: MaterialButton(
                  elevation: 0,
                  color: const Color(0xFFFF6289),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  minWidth: double.infinity,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: TextWidget('更新工作环境', fontSize: 18, color: Colors.white, isBold: true),
                  ),
                  onPressed: () => controller.updateWorkspace(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
