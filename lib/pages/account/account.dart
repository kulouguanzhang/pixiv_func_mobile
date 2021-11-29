/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:account.dart
 * 创建时间:2021/11/29 下午9:39
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/local_data/account_manager.dart';
import 'package:pixiv_func_android/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_android/pages/login/login.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountService = Get.find<AccountService>();
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('账号'),
            actions: [
              const SizedBox(height: 5),
              IconButton(
                tooltip: '登录一个账号',
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
                        tooltip: '移除这个账号',
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
