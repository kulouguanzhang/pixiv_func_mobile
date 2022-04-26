import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/components/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';

class UserInfoContent extends StatelessWidget {
  final UserDetailResult userDetail;

  const UserInfoContent({Key? key, required this.userDetail}) : super(key: key);

  Widget _buildItem(String name, String value, {bool isUrl = false}) {
    return Card(
      child: ListTile(
        onLongPress: () async {
          if (value.isNotEmpty) {
            await Utils.copyToClipboard(value);
            Get.find<PlatformApi>().toast(I18n.copySuccess.tr);
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
    children.add(_buildItem(I18n.name.tr, user.name));
    children.add(const Divider());
    children.add(_buildItem('ID', user.id.toString()));
    children.add(const Divider());
    children.add(_buildItem(I18n.account.tr, user.account));
    children.add(const Divider());

    //profile
    if (null != profile.webpage) {
      children.add(_buildItem(I18n.webpage.tr, profile.webpage!));
      children.add(const Divider());
    }

    if (profile.birth.isNotEmpty) {
      children.add(_buildItem(I18n.birth.tr, profile.birth));
      children.add(const Divider());
    }

    children.add(_buildItem(I18n.job.tr, profile.job));
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
      children.add(_buildItem(I18n.pc.tr, workspace.pc));
      children.add(const Divider());
    }

    if (workspace.monitor.isNotEmpty) {
      children.add(_buildItem(I18n.monitor.tr, workspace.monitor));
      children.add(const Divider());
    }

    if (workspace.tool.isNotEmpty) {
      children.add(_buildItem(I18n.tool.tr, workspace.tool));
      children.add(const Divider());
    }

    if (workspace.scanner.isNotEmpty) {
      children.add(_buildItem(I18n.scanner.tr, workspace.scanner));
      children.add(const Divider());
    }

    if (workspace.tablet.isNotEmpty) {
      children.add(_buildItem(I18n.tablet.tr, workspace.tablet));
      children.add(const Divider());
    }

    if (workspace.mouse.isNotEmpty) {
      children.add(_buildItem(I18n.mouse.tr, workspace.mouse));
      children.add(const Divider());
    }

    if (workspace.printer.isNotEmpty) {
      children.add(_buildItem(I18n.printer.tr, workspace.printer));
      children.add(const Divider());
    }

    if (workspace.desktop.isNotEmpty) {
      children.add(_buildItem(I18n.desktop.tr, workspace.desktop));
      children.add(const Divider());
    }

    if (workspace.music.isNotEmpty) {
      children.add(_buildItem(I18n.music.tr, workspace.music));
      children.add(const Divider());
    }

    if (workspace.desk.isNotEmpty) {
      children.add(_buildItem(I18n.desk.tr, workspace.desk));
      children.add(const Divider());
    }

    if (workspace.chair.isNotEmpty) {
      children.add(_buildItem(I18n.chair.tr, workspace.chair));
      children.add(const Divider());
    }

    if (workspace.comment.isNotEmpty) {
      children.add(_buildItem(I18n.other.tr, workspace.comment));
      children.add(const Divider());
    }

    return SingleChildScrollView(child: Column(children: children));
  }
}
