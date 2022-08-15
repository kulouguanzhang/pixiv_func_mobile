import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/encrypt/encrypt.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/components/pixiv_avatar/pixiv_avatar.dart';
import 'package:pixiv_func_mobile/pages/login/login.dart';
import 'package:pixiv_func_mobile/services/account_service.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountService = Get.find<AccountService>();
    return Obx(
      () {
        return ScaffoldWidget(
          title: '账号管理',
          actions: [
            const SizedBox(height: 5),
            IconButton(
              onPressed: () => Get.to(() => const LoginPage()),
              icon: const Icon(Icons.add),
            ),
            const SizedBox(height: 5),
          ],
          child: NoScrollBehaviorWidget(
            child: ListView(
              children: [
                for (final account in accountService.accounts())
                  ListTile(
                    onTap: () {
                      accountService.select(accountService.accounts().indexWhere((element) => element == account));
                    },
                    onLongPress: () {
                      Utils.copyToClipboard(Encrypt.encode(jsonEncode(account)));
                      PlatformApi.toast('已复制到剪贴板');
                    },
                    title: Text(
                      '${account.localUser.name}(${account.localUser.mailAddress})',
                      style: account.localUser.id == Get.find<AccountService>().current?.localUser.id
                          ? TextStyle(color: Get.theme.colorScheme.primary)
                          : null,
                    ),
                    subtitle: Text('${account.localUser.account}(${account.localUser.id})'),
                    leading: PixivAvatarWidget(account.localUser.profileImageUrls.px50x50, radius: 50),
                    trailing: IconButton(
                      splashRadius: 40,
                      onPressed: () {
                        Get.bottomSheet(
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                              color: Theme.of(context).colorScheme.background,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: Get.height * 0.35, minHeight: Get.height * 0.35),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(flex: 1),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30),
                                    child: TextWidget('确认退出此账号', fontSize: 18, isBold: true),
                                  ),
                                  const Spacer(flex: 1),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(account.localUser.name, fontSize: 16),
                                        TextWidget(account.localUser.mailAddress, fontSize: 12),
                                      ],
                                    ),
                                  ),
                                  const Spacer(flex: 2),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: MaterialButton(
                                            elevation: 0,
                                            color: Theme.of(context).colorScheme.surface,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40),
                                              side: BorderSide.none,
                                            ),
                                            minWidth: double.infinity,
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 20),
                                              child: TextWidget('取消', fontSize: 18, color: Colors.white, isBold: true),
                                            ),
                                            onPressed: () => Get.back(),
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: MaterialButton(
                                            elevation: 0,
                                            color: const Color(0xFFFF6289),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                            minWidth: double.infinity,
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 20),
                                              child: TextWidget('确认', fontSize: 18, color: Colors.white, isBold: true),
                                            ),
                                            onPressed: () async {
                                              final removeIndex = accountService.accounts().indexWhere((element) => element == account);
                                              accountService.removeAt(removeIndex);
                                              if (removeIndex == accountService.currentIndex.value) {
                                                if (accountService.accounts().isNotEmpty) {
                                                  accountService.select(0);
                                                } else {
                                                  accountService.select(-1);
                                                  Get.offAll(const LoginPage());
                                                }
                                              }
                                              Get.back();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(flex: 1),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_forever_outlined),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
