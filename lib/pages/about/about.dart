import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/version_info/version_info.dart';
import 'package:pixiv_func_mobile/components/html_rich_text/html_rich_text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  Widget _buildReleaseInfo() {
    final controller = Get.find<VersionInfoController>();
    final releaseInfo = controller.releaseInfo!;
    return Column(
      children: [
        ListTile(
          onTap: () => controller.loadLatestReleaseInfo(),
          title: Text('${I18n.latestRelease.tr} ${releaseInfo.tagName}'),
          subtitle: Text(I18n.clickCheckUpdate.tr),
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
            onTap: () => controller.openTagHtmlByBrowser(),
            onLongPress: () => controller.copyTagHtmlUrl(),
            title: Text(I18n.openTagWebPage.tr),
            subtitle: Text(I18n.longPressCopyUrl.tr),
          ),
        ),
        if (controller.appVersion != null && controller.appVersion != releaseInfo.tagName)
          Card(
            child: ListTile(
              onTap: () => controller.startUpdateApp(),
              onLongPress: () => controller.copyAppLatestVersionDownloadUrl(),
              title: Text(I18n.downloadLatestVersion.tr),
              subtitle: Text(I18n.longPressCopyUrl.tr),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VersionInfoController>(
      builder: (VersionInfoController controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(I18n.about.tr),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: () => controller.openProjectUrlByBrowser(),
                    onLongPress: () => controller.copyProjectUrl(),
                    title: Text(I18n.openInGitHub.tr),
                    subtitle: Text(I18n.longPressCopyUrl.tr),
                  ),
                ),
                const Divider(),
                Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: () => controller.openGetHelpUrlByBrowser(),
                    onLongPress: () => controller.copyGetHelpUrl(),
                    title: Text(I18n.getHelp.tr),
                    subtitle: Text(I18n.longPressCopyUrl.tr),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Text('${I18n.currentVersion.tr}:${null != controller.appVersion ? controller.appVersion! : '...'}'),
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
                    title: Center(
                      child: Text(I18n.loadFailedRetry.tr),
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
