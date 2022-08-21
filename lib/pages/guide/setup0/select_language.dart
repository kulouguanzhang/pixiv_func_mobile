import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/pages/guide/setup1/select_theme.dart';
import 'package:pixiv_func_mobile/widgets/cupertino_switch_list_tile/cupertino_switch_list_tile.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class GuideSelectLanguagePage extends StatelessWidget {
  const GuideSelectLanguagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObxValue<Rx<Locale?>>(
      (data) => ScaffoldWidget(
        emptyAppBar: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const TextWidget('选择您的语言', fontSize: 24, isBold: true),
              const TextWidget('Select your language', fontSize: 24, isBold: true),
              const TextWidget('言語を選択', fontSize: 24, isBold: true),
              const TextWidget('Выберите свой язык', fontSize: 24, isBold: true),
              const Spacer(flex: 1),
              CupertinoSwitchListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                onTap: () => data.value = const Locale('zh', 'CN'),
                title: const TextWidget('简体中文', fontSize: 18, isBold: true),
                value: const Locale('zh', 'CN') == data.value,
              ),
              const Divider(),
              CupertinoSwitchListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                onTap: () => data.value = const Locale('en', 'US'),
                title: const TextWidget('English', fontSize: 18, isBold: true),
                value: const Locale('en', 'US') == data.value,
              ),
              const Divider(),
              CupertinoSwitchListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                onTap: () => data.value = const Locale('ja', 'JP'),
                title: const TextWidget('日本語', fontSize: 18, isBold: true),
                value: const Locale('ja', 'JP') == data.value,
              ),
              const Divider(),
              CupertinoSwitchListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                onTap: () => data.value = const Locale('ru', 'RU'),
                title: const TextWidget('Русский', fontSize: 18, isBold: true),
                value: const Locale('ru', 'RU') == data.value,
              ),
              const Spacer(flex: 2),
              MaterialButton(
                elevation: 0,
                color: null == data.value ? const Color(0xFFE9E9EA) : const Color(0xFFFF6289),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                minWidth: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextWidget(I18n.next.tr, fontSize: 18, color: Colors.white, isBold: true),
                ),
                onPressed: () => Get.to(() => const GuideSelectThemePage()),
              ),
              const Spacer(flex: 1),
              const TextWidget('稍后您可以在设置中进行相应变更', fontSize: 14),
              const TextWidget('You can change the settings later', fontSize: 14),
              const TextWidget('後で設定を変更できます', fontSize: 14),
              const TextWidget('Вы можете изменить его позже в настройках', fontSize: 14),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
      Rx<Locale?>(null),
    );
  }
}
