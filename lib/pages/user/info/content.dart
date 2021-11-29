/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:content.dart
 * 创建时间:2021/11/25 下午10:22
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/model/user_detail.dart';
import 'package:pixiv_func_android/app/platform/api/platform_api.dart';
import 'package:pixiv_func_android/components/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_android/utils/utils.dart';

class UserInfoContent extends StatelessWidget {
  final UserDetail userDetail;
  const UserInfoContent({Key? key, required this.userDetail}) : super(key: key);

  Widget _buildItem(String name, String value, {bool isUrl = false}) {
    return Card(
      child: ListTile(
        onLongPress: () async {
          if (value.isNotEmpty) {
            await Utils.copyToClipboard(value);
            Get.find<PlatformApi>().toast('已将 $value 复制到剪切板');
          }
        },
        onTap: isUrl
            ? () async {
                if (Utils.urlIsTwitter(value)) {
                  final twitterUsername = Utils.findTwitterUsernameByUrl(value);
                  if (!await Get.find<PlatformApi>().urlLaunch('twitter://user?screen_name=$twitterUsername')) {
                    Get.find<PlatformApi>().urlLaunch(value);
                  }
                } else {
                  Get.find<PlatformApi>().urlLaunch(value);
                }
              }
            : null,
        leading: Text(name),
        title: Center(
          child: Text(
            value,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    final user = userDetail.user;
    final profile = userDetail.profile;
    final workspace = userDetail.workspace;

    if (null != user.comment) {
      children.add(
        Card(
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: HtmlRichText(user.comment!),
          ),
        ),
      );
    }

    //user
    children.add(const Divider());
    children.add(_buildItem('名称', user.name));
    children.add(const Divider());
    children.add(_buildItem('ID', user.id.toString()));
    children.add(const Divider());
    children.add(_buildItem('账号', user.account));
    children.add(const Divider());

    //profile
    if (null != profile.webpage) {
      children.add(_buildItem('网站', profile.webpage!));
      children.add(const Divider());
    }

    if (profile.birth.isNotEmpty) {
      children.add(_buildItem('出生', profile.birth));
      children.add(const Divider());
    }

    children.add(_buildItem('工作', profile.job));
    children.add(const Divider());

    if (null != profile.twitterUrl) {
      children.add(_buildItem('twitter', profile.twitterUrl!, isUrl: true));
      children.add(const Divider());
    }

    if (null != profile.pawooUrl) {
      children.add(_buildItem('pawoo', profile.pawooUrl!, isUrl: true));
      children.add(const Divider());
    }

    //workspace

    if (workspace.pc.isNotEmpty) {
      children.add(_buildItem('电脑', workspace.pc));
      children.add(const Divider());
    }

    if (workspace.monitor.isNotEmpty) {
      children.add(_buildItem('显示器', workspace.monitor));
      children.add(const Divider());
    }

    if (workspace.tool.isNotEmpty) {
      children.add(_buildItem('软件', workspace.tool));
      children.add(const Divider());
    }

    if (workspace.scanner.isNotEmpty) {
      children.add(_buildItem('扫描仪', workspace.scanner));
      children.add(const Divider());
    }

    if (workspace.tablet.isNotEmpty) {
      children.add(_buildItem('数位板', workspace.tablet));
      children.add(const Divider());
    }

    if (workspace.mouse.isNotEmpty) {
      children.add(_buildItem('鼠标', workspace.mouse));
      children.add(const Divider());
    }

    if (workspace.printer.isNotEmpty) {
      children.add(_buildItem('打印机', workspace.printer));
      children.add(const Divider());
    }

    if (workspace.desktop.isNotEmpty) {
      children.add(_buildItem('桌子上的东西', workspace.desktop));
      children.add(const Divider());
    }

    if (workspace.music.isNotEmpty) {
      children.add(_buildItem('画图时听的音乐', workspace.music));
      children.add(const Divider());
    }

    if (workspace.desk.isNotEmpty) {
      children.add(_buildItem('桌子', workspace.desk));
      children.add(const Divider());
    }

    if (workspace.chair.isNotEmpty) {
      children.add(_buildItem('椅子', workspace.chair));
      children.add(const Divider());
    }

    if (workspace.comment.isNotEmpty) {
      children.add(_buildItem('其他', workspace.comment));
      children.add(const Divider());
    }

    return SingleChildScrollView(child: Column(children: children));
  }
}
