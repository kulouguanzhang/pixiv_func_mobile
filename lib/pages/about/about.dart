import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/state/page_state.dart';
import 'package:pixiv_func_mobile/pages/about/controller.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  Widget _buildItem({required VoidCallback onTap, required String title}) {
    return ListTile(
      onTap: onTap,
      title: TextWidget(title, fontSize: 16, isBold: true),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  Widget _buildButton() {
    final controller = Get.find<AboutController>();
    final String text;
    final Color? color;
    final Color? textColor;
    final BorderSide borderSide;
    final VoidCallback? onPressed;
    if (PageState.none == controller.state) {
      if (null == controller.hasNewVersion) {
        text = '检查版本更新';
        color = null;
        textColor = Get.theme.colorScheme.primary;
        borderSide = BorderSide(color: Get.theme.colorScheme.primary);
        onPressed = controller.loadData;
      } else if (controller.hasNewVersion!) {
        text = '发现新版本 点击更新';
        color = Get.theme.colorScheme.primary;
        textColor = Colors.white;
        borderSide = BorderSide.none;
        onPressed = controller.updateApp;
      } else {
        text = '已经是最新版本';
        color = Get.theme.colorScheme.surface;
        textColor = Colors.white;
        borderSide = BorderSide.none;
        onPressed = controller.loadData;
      }
    } else if (PageState.loading == controller.state) {
      text = '正在检查更新...';
      color = Get.theme.colorScheme.surface;
      textColor = Get.theme.colorScheme.primary;
      borderSide = BorderSide(color: Get.theme.colorScheme.primary);
      onPressed = null;
    } else if (PageState.error == controller.state) {
      text = '检查更新失败 点击重试';
      color = Get.theme.colorScheme.surface;
      textColor = Get.theme.colorScheme.primary;
      borderSide = BorderSide(color: Get.theme.colorScheme.primary);
      onPressed = controller.loadData;
    } else {
      text = '';
      color = null;
      textColor = null;
      borderSide = BorderSide.none;
      onPressed = null;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
      child: MaterialButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: borderSide,
        ),
        color: color,
        minWidth: double.infinity,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: TextWidget(text, fontSize: 18, color: textColor, isBold: true),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutController>(
      builder: (controller) => ScaffoldWidget(
        title: '设置',
        child: Column(
          children: [
            const Divider(),
            _buildItem(onTap: () => controller.action(0), title: '联系作者'),
            const Divider(),
            _buildItem(onTap: () => controller.action(1), title: '获取帮助'),
            const Divider(),
            _buildItem(onTap: () => controller.action(2), title: '当前版本:${controller.appVersion ?? '正在获取...'}'),
            const Divider(),
            _buildItem(onTap: () => controller.action(3), title: '打开标签页'),
            const Divider(),
            const Spacer(),
            _buildButton(),
            SizedBox(height: Get.height * 0.05),
          ],
        ),
      ),
    );
  }
}
