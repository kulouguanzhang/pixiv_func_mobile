/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:about_page.dart
 * 创建时间:2021/9/6 下午6:57
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/provider/view_state.dart';
import 'package:pixiv_func_android/ui/widget/html_rich_text.dart';
import 'package:pixiv_func_android/util/utils.dart';
import 'package:pixiv_func_android/view_model/about_model.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  static const thisProjectGitHubUrl = 'https://github.com/xiao-cao-x/pixiv_func_android';

  Widget _buildReleaseInfo(AboutModel model) {
    final releaseInfo = model.releaseInfo!;
    return Column(
      children: [
        ListTile(
          onTap: model.loadLatestReleaseInfo,
          title: Text('最新发行版 ${releaseInfo.tagName}'),
          subtitle: const Text('点击检查更新'),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            child: HtmlRichText(releaseInfo.body),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () async {
              if (!await platformAPI.urlLaunch(releaseInfo.htmlUrl)) {
                platformAPI.toast('打开浏览器失败');
              }
            },
            onLongPress: () async {
              await Utils.copyToClipboard(releaseInfo.htmlUrl);
              platformAPI.toast('已将 ${releaseInfo.htmlUrl} 复制到剪切板');
            },
            title: const Text('打开标签页'),
            subtitle: const Text('长按复制url'),
          ),
        ),
        if (model.appVersion != null && model.appVersion != releaseInfo.tagName)
          Card(
            child: ListTile(
              onTap: () async {
                if (!await platformAPI.updateApp(
                  'https://ghproxy.com/${releaseInfo.browserDownloadUrl}',
                  releaseInfo.tagName,
                )) {
                  platformAPI.toast('启动下载失败');
                }
              },
              onLongPress: () async {
                await Utils.copyToClipboard(releaseInfo.browserDownloadUrl);
                platformAPI.toast('已将 ${releaseInfo.browserDownloadUrl} 复制到剪切板');
              },
              title: const Text('下载最新版本'),
              subtitle: const Text('长按复制url'),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: AboutModel(),
      builder: (BuildContext context, AboutModel model, Widget? child) {
        return ListView(
          children: [
            ListTile(
              leading: Image.asset(
                'assets/xiaocao.png',
                width: 50,
              ),
              title: const Text('这是小草的个人玩具项目'),
              subtitle: const Text('夹批搪与牲口不得使用此软件'),
            ),
            const Divider(),
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                onTap: () async {
                  if (!await platformAPI.urlLaunch(thisProjectGitHubUrl)) {
                    platformAPI.toast('打开浏览器失败');
                  }
                },
                onLongPress: () async {
                  await Utils.copyToClipboard(thisProjectGitHubUrl);
                  platformAPI.toast('已将 $thisProjectGitHubUrl 复制到剪切板');
                },
                title: const Text(thisProjectGitHubUrl),
                subtitle: const Text('项目地址(点击前往浏览器,长按复制url)'),
              ),
            ),
            const Divider(),
            ListTile(
              title: Row(
                children: [
                  const Text('该软件使用'),
                  Image.asset(
                    'assets/dart-logo.png',
                    width: 30,
                    height: 30,
                  ),
                  const Text('与'),
                  Image.asset(
                    'assets/kotlin-logo.png',
                    width: 30,
                    height: 30,
                  ),
                  const Text('开发 开源且免费'),
                ],
              ),
              subtitle: const Text('禁止用于盈利(包括但不仅限于收取打赏)'),
            ),
            const Divider(),
            const ListTile(
              title: Text('该项目与一切现有同类项目无关'),
              subtitle: Text('请不要拿来比较'),
            ),
            const Divider(),
            ListTile(
              title: Text('当前版本:${null != model.appVersion ? model.appVersion! : '正在获取...'}'),
            ),
            const Divider(),
            if (ViewState.busy == model.viewState)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (ViewState.idle == model.viewState)
              if (null != model.releaseInfo)
                _buildReleaseInfo(model)
              else if (ViewState.initFailed == model.viewState)
                ListTile(
                  onTap: model.loadLatestReleaseInfo,
                  title: const Center(
                    child: Text('加载失败发行版信息失败,点击重新加载'),
                  ),
                ),
          ],
        );
      },
      onModelReady: (AboutModel model) async {
        await model.loadAppVersion();
        model.loadLatestReleaseInfo();
      },
    );
  }
}
