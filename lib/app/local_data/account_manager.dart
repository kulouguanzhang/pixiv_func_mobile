/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:account_manager.dart
 * 创建时间:2021/8/23 上午10:55
 * 作者:小草
 */

import 'dart:convert';

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/model/user_account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountService extends GetxService {
  static const _dataKeyName = "accounts";
  static const _dataIndexKeyName = "account_index";

  final Rx<List<UserAccount>> accounts = Rx([]);

  late final SharedPreferences _sharedPreferences;

  late final RxInt currentIndex;

  Future<AccountService> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    final tempAccounts = _sharedPreferences.getStringList(_dataKeyName);
    if (null != tempAccounts) {
      accounts().addAll(
        tempAccounts.map(
          (jsonString) {
            final json = jsonDecode(jsonString);
            return UserAccount.fromJson(json);
          },
        ),
      );
    }
    currentIndex = RxInt(_sharedPreferences.getInt(_dataIndexKeyName) ?? (accounts().isNotEmpty ? 0 : -1));
    return this;
  }

  ///保存账号
  void save() {
    _sharedPreferences.setStringList(_dataKeyName, accounts().map((account) => jsonEncode(account.toJson())).toList());
  }

  void select(int index) async {
    currentIndex.value = index;
    _sharedPreferences.setInt(_dataIndexKeyName, index);
  }

  ///添加账号
  void add(UserAccount account) {
    //如果已经存在就更新
    if (accounts().any((element) => element.user.id == account.user.id)) {
      update(account);
    } else {
      accounts.update((val) {
        val?.add(account);
      });
      if (1 == accounts().length) {
        select(0);
      }
      save();
    }
  }

  ///更新账号
  void update(UserAccount account) {
    accounts.update((val) {
      if (null != val) {
        for (int i = 0; i < val.length; i++) {
          if (account.user.id == val[i].user.id) {
            val[i] = account;
            save();
            break;
          }
        }
      }
    });
  }

  ///移除账号
  void remove(UserAccount account) {
    accounts.update((val) {
      val?.remove(account);
    });
    save();
  }

  ///移除账号
  void removeAt(int i) {
    accounts.update((val) {
      val?.removeAt(i);
    });
    save();
  }

  UserAccount? get current {
    if (-1 == currentIndex.value) {
      return null;
    }
    return accounts()[currentIndex.value];
  }

  int get currentUserId => int.parse(current!.user.id);

  bool get isEmpty => accounts().isEmpty;

  bool get isNotEmpty => accounts().isNotEmpty;
}
