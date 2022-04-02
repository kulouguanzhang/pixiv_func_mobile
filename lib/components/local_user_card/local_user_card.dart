/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:local_user_card.dart
 * 创建时间:2021/11/25 下午12:45
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_dart_api/entity/local_user.dart';
import 'package:pixiv_func_mobile/components/avatar_from_url/avatar_from_url.dart';

class LocalUserCard extends StatelessWidget {
  final LocalUser localUser;

  const LocalUserCard(this.localUser, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
            child: SizedBox(
              height: 85,
              child: AvatarFromUrl(
                localUser.profileImageUrls.px170x170,
                radius: 85,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localUser.name,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  localUser.mailAddress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
