import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n_expansion.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n_translations.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class LanguageExpansionPage extends StatelessWidget {
  const LanguageExpansionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: '语言拓展',
      child: ListView(
        children: [
          ListTile(
            onTap: () async {
              try {
                final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
                if (null == text) {
                  PlatformApi.toast(I18n.getClipboardDataFailed.tr);
                  return;
                } else if (text.isEmpty) {
                  PlatformApi.toast(I18n.clipboardDataEmpty.tr);
                  return;
                }
                final expansion = I18nExpansion.fromJson(jsonDecode(text));
                final index = I18nTranslations.expansions.indexWhere((e) => e.locale == expansion.locale);
                if (-1 != index) {
                  if (I18nTranslations.expansions[index].locale == expansion.locale) {
                    if (I18nTranslations.expansions[index].versionCode > expansion.versionCode) {
                      await I18nTranslations.addExpansion(expansion);
                      PlatformApi.toast('语言拓展包将在重启APP后生效');
                    } else {
                      PlatformApi.toast('语言已经存在');
                    }
                  }
                } else {
                  await I18nTranslations.addExpansion(expansion);
                  PlatformApi.toast('语言拓展包将在重启APP后生效');
                }
              } catch (e) {
                PlatformApi.toast(I18n.clipboardLanguageDataInvalid.tr);
              }
            },
            title: const TextWidget('从剪贴板加载语言数据'),
          ),
          ListTile(
            onTap: () {
              Dio()
                  .get<String>('https://raw.githubusercontent.com/git-xiaocao/pixiv_func_i18n_expansion/main/i18n_expansion/expansions.json')
                  .then((response) async {
                final list = jsonDecode(response.data!) as List<dynamic>;
                int count = 0;
                for (final item in list) {
                  final jsonString =
                      (await Dio().get<String>('https://raw.githubusercontent.com/git-xiaocao/pixiv_func_i18n_expansion/main/i18n_expansion/$item')).data!;

                  final expansion = I18nExpansion.fromJson(jsonDecode(jsonString));
                  final index = I18nTranslations.expansions.indexWhere((e) => e.locale == expansion.locale);
                  if (-1 != index) {
                    if (I18nTranslations.expansions[index].versionCode > expansion.versionCode) {
                      await I18nTranslations.addExpansion(expansion);
                      ++count;
                    }
                  } else {
                    await I18nTranslations.addExpansion(expansion);
                    ++count;
                  }
                }
                if (count > 0) {
                  PlatformApi.toast('语言拓展包将在重启APP后生效');
                }
              });
            },
            title: const TextWidget('从GitHub加载'),
          ),
          const Divider(),
          for (final item in I18nTranslations.expansions)
            ListTile(
              leading: ClipOval(
                child: ExtendedImage.network(
                  'https://raw.githubusercontent.com/git-xiaocao/pixiv_func_i18n_expansion/main/${item.avatar}',
                  width: 45,
                  height: 45,
                ),
              ),
              title: TextWidget(item.title,fontSize: 16),
              subtitle: TextWidget('${item.github}(${item.author})'),
              // trailing: Icon(
              //   Icons.check,
              //   size: 25,
              //   color: controller.blockTagService.isBlocked(tag) ? Get.theme.colorScheme.primary : null,
              // ),
            ),
        ],
      ),
    );
  }
}
