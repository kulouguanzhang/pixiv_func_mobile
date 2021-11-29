/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:about.dart
 * 创建时间:2021/11/29 下午9:05
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/components/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_android/pages/about/controller.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  static const thisProjectGitHubUrl = 'https://github.com/xiao-cao-x/pixiv_func_android';

  Widget _buildReleaseInfo() {
    final controller = Get.find<AboutController>();
    final releaseInfo = controller.releaseInfo!;
    return Column(
      children: [
        ListTile(
          onTap: () => controller.loadLatestReleaseInfo(),
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
            onTap: () async => await controller.openTagHtmlByBrowser(),
            onLongPress: () async => await controller.copyTagHtmlUrl(),
            title: const Text('打开标签页'),
            subtitle: const Text('长按复制url'),
          ),
        ),
        if (controller.appVersion != null && controller.appVersion != releaseInfo.tagName)
          Card(
            child: ListTile(
              onTap: () async => await controller.startUpdateApp(),
              onLongPress: () async => await controller.copyAppLatestVersionDownloadUrl(),
              title: const Text('下载最新版本'),
              subtitle: const Text('长按复制url'),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AboutController());
    return GetBuilder<AboutController>(
      assignId: true,
      initState: (state) async {
        await controller.loadAppVersion();
        controller.loadLatestReleaseInfo();
      },
      builder: (AboutController controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('关于'),
          ),
          body: SingleChildScrollView(
            child: Column(
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
                    onTap: () async => await controller.openProjectUrlByBrowser(),
                    onLongPress: () async => await controller.copyProjectUrl(),
                    title: Text(controller.thisProjectGitHubUrl),
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
                  title: Text('当前版本:${null != controller.appVersion ? controller.appVersion! : '正在获取...'}'),
                ),
                const Divider(),
                if (controller.loading)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (null != controller.releaseInfo)
                  _buildReleaseInfo()
                else if (controller.initFailed)
                    ListTile(
                      onTap: () => controller.loadLatestReleaseInfo(),
                      title: const Center(
                        child: Text('加载失败发行版信息失败,点击重新加载'),
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
