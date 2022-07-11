import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/data/settings_service.dart';
import 'package:pixiv_func_mobile/pages/login/login.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class GuideSelectThemePage extends StatelessWidget {
  const GuideSelectThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<int>>(
      (data) => ScaffoldWidget(
        emptyAppBar: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const TextWidget('选择你喜欢的主题', fontSize: 24, isBold: true),
              const Spacer(flex: 1),
              CupertinoSwitchListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                onTap: () {
                  data.value = 1;
                  Get.find<SettingsService>().theme = 1;
                  Get.changeThemeMode(ThemeMode.dark);
                },
                title: const TextWidget('黑暗', fontSize: 18, isBold: true),
                value: 1 == data.value,
              ),
              const Divider(),
              CupertinoSwitchListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                onTap: () {
                  data.value = 2;
                  Get.find<SettingsService>().theme = 2;
                  Get.changeThemeMode(ThemeMode.light);
                },
                title: const TextWidget('明亮', fontSize: 18, isBold: true),
                value: 2 == data.value,
              ),
              const Divider(),
              CupertinoSwitchListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                onTap: () {
                  data.value = -1;
                  Get.find<SettingsService>().theme = -1;
                  Get.changeThemeMode(ThemeMode.system);
                },
                title: const TextWidget('跟随系统', fontSize: 18, isBold: true),
                value: -1 == data.value,
              ),
              const Spacer(flex: 2),
              MaterialButton(
                elevation: 0,
                color: const Color(0xFFFF6289),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                minWidth: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: TextWidget('下一步', fontSize: 18, color: Colors.white, isBold: true),
                ),
                onPressed: () {
                  Get.find<SettingsService>().guideInit = true;
                  Get.to(const LoginPage());
                },
              ),
              const Spacer(flex: 1),
              const TextWidget('稍后您可以在设置中进行相应变更', fontSize: 14),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
      Rx<int>(Get.find<SettingsService>().theme),
    );
  }
}
