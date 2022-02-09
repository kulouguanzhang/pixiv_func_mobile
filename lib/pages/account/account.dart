/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:account.dart
 * 创建时间:2021/11/29 下午9:39
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/local_data/account_manager.dart';
import 'package:pixiv_func_mobile/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_mobile/pages/login/login.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountService = Get.find<AccountService>();
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            title: Text(I18n.account.tr),
            actions: [
              const SizedBox(height: 5),
              IconButton(
                onPressed: () => Get.to(const LoginPage()),
                icon: const Icon(Icons.add),
              ),
              const SizedBox(height: 5),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                for (final account in accountService.accounts())
                  Card(
                    child: ListTile(
                      onTap: () {
                        accountService.select(accountService.accounts().indexWhere((element) => element == account));
                      },
                      title: Text(
                        '${account.user.name}(${account.user.mailAddress})',
                        style: account.user.id == Get.find<AccountService>().current?.user.id
                            ? TextStyle(color: Get.theme.colorScheme.primary)
                            : null,
                      ),
                      subtitle: Text('${account.user.account}(${account.user.id})'),
                      leading: AvatarFromUrl(account.user.profileImageUrls.px50x50),
                      trailing: IconButton(
                        splashRadius: 40,
                        onPressed: () {
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
                        },
                        icon: const Icon(Icons.delete_forever_outlined),
                      ),
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
