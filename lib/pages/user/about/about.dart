import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/vo/user_detail_result.dart';
import 'package:pixiv_func_mobile/app/icon/icon.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class UserAboutContent extends StatelessWidget {
  final UserDetailResult userDetail;

  const UserAboutContent({Key? key, required this.userDetail}) : super(key: key);

  Widget buildValueItem(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onLongPress: () async {
          if (value.isNotEmpty) {
            await Utils.copyToClipboard(value);
            PlatformApi.toast('复制成功');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075, vertical: 4),
            child: TextWidget(value, fontSize: 14, isBold: true),
          ),
        ),
      ),
    );
  }

  Widget buildNameValueItem(
    String name,
    String value,
  ) {
    return InkWell(
      onLongPress: () async {
        if (value.isNotEmpty) {
          await Utils.copyToClipboard(value);
          PlatformApi.toast('复制成功');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextWidget(name, fontSize: 14, isBold: true),
              const SizedBox(height: 4),
              TextWidget(value, fontSize: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWebUrlItem(String name, String url, IconData iconData) {
    return GestureDetector(
      onLongPress: () async {
        if (url.isNotEmpty) {
          await Utils.copyToClipboard(url);
          PlatformApi.toast('复制成功');
        }
      },
      onTap: () async {
        if (Utils.urlIsTwitter(url)) {
          final twitterUsername = Utils.findTwitterUsernameByUrl(url);
          if (!await PlatformApi.urlLaunch('twitter://user?screen_name=$twitterUsername')) {
            PlatformApi.urlLaunch(url);
          }
        } else {
          PlatformApi.urlLaunch(url);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075),
              child: TextWidget(name, fontSize: 14, isBold: true),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(42), color: Get.theme.colorScheme.surface),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextWidget(url, fontSize: 14),
                    ),
                    Icon(iconData),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = userDetail.user;
    final profile = userDetail.profile;
    final workspace = userDetail.workspace;

    return NoScrollBehaviorWidget(
      child: ListView(
        children: [
          //user
          buildValueItem(user.name), buildNameValueItem('ID', user.id.toString()), buildNameValueItem('账号', user.account),
          //profile
          if (profile.birth.isNotEmpty) buildNameValueItem('出生', profile.birth),
          if (profile.gender.isNotEmpty) buildNameValueItem('性别', profile.gender == 'male' ? '男' : '女'),
          if (profile.region.isNotEmpty) buildNameValueItem('地区', profile.region),
          if (profile.job.isNotEmpty) buildNameValueItem('工作', profile.job),

          //workspace
          if (workspace.pc.isNotEmpty) buildNameValueItem('电脑', workspace.pc),
          if (workspace.monitor.isNotEmpty) buildNameValueItem('显示器', workspace.monitor),
          if (workspace.tool.isNotEmpty) buildNameValueItem('软件', workspace.tool),
          if (workspace.scanner.isNotEmpty) buildNameValueItem('扫描仪', workspace.scanner),
          if (workspace.tablet.isNotEmpty) buildNameValueItem('数位板', workspace.tablet),
          if (workspace.mouse.isNotEmpty) buildNameValueItem('鼠标', workspace.mouse),
          if (workspace.printer.isNotEmpty) buildNameValueItem('打印机', workspace.printer),
          if (workspace.desktop.isNotEmpty) buildNameValueItem('桌子上的东西', workspace.desktop),
          if (workspace.music.isNotEmpty) buildNameValueItem('画图时听的音乐', workspace.music),
          if (workspace.desk.isNotEmpty) buildNameValueItem('桌子', workspace.desk),
          if (workspace.chair.isNotEmpty) buildNameValueItem('椅子', workspace.chair),
          if (workspace.comment.isNotEmpty) buildNameValueItem('留言', workspace.comment),

          //web
          if (null != profile.webpage) buildWebUrlItem('个人网页', profile.webpage!, AppIcons.web),
          if (null != profile.twitterUrl) buildWebUrlItem('twitter', profile.twitterUrl!, AppIcons.twitter),
          if (null != profile.pawooUrl) buildWebUrlItem('pawoo', profile.pawooUrl!, AppIcons.pawoo),
          if (null != user.comment)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.075, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget('简介', fontSize: 14, isBold: true),
                  HtmlRichText(user.comment!),
                ],
              ),
            )
        ],
      ),
    );
  }
}
