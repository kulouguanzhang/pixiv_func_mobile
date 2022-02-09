import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pixiv_func_mobile/app/api/entity/illust.dart';
import 'package:pixiv_func_mobile/app/download/downloader.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/app/local_data/browsing_history_manager.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/settings/app_settings.dart';
import 'package:pixiv_func_mobile/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_mobile/components/bookmark_switch_button/bookmark_switch_button.dart';
import 'package:pixiv_func_mobile/components/follow_switch_button/follow_switch_button.dart';
import 'package:pixiv_func_mobile/components/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_mobile/components/loading_more_indicator/loading_more_indicator.dart';
import 'package:pixiv_func_mobile/pages/illust/related/source.dart';
import 'package:pixiv_func_mobile/pages/illust/scale/scale.dart';
import 'package:pixiv_func_mobile/pages/search/result/illust/illust_result.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';

import 'comment/comment.dart';
import 'ugoira_viewer/ugoira_viewer.dart';

class IllustPage extends StatelessWidget {
  final Illust illust;

  const IllustPage({Key? key, required this.illust}) : super(key: key);

  Widget _buildImageCard({
    required int id,
    required String title,
    required String previewUrl,
    required String originUrl,
    required int index,
  }) {
    final widget = Card(
      child: GestureDetector(
        onTap: () => Get.to(ImageScalePage(illust: illust, initialPage: index)),
        onLongPress: () => Downloader.start(illust: illust, url: originUrl),
        child: ImageFromUrl(
          previewUrl,
          placeholderWidget: const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
    return SliverToBoxAdapter(child: 0 == index ? Hero(tag: 'IllustHero:$id', child: widget) : widget);
  }

  Widget _buildIllustInfo() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: ListTile(
                contentPadding: EdgeInsets.zero,
                //头像
                leading: GestureDetector(
                  onTap: () => Get.to(UserPage(id: illust.user.id)),
                  child: Hero(
                    tag: 'UserHero:${illust.user.id}',
                    child: AvatarFromUrl(illust.user.profileImageUrls.medium),
                  ),
                ),
                trailing: FollowSwitchButton(
                  id: illust.user.id,
                  initValue: illust.user.isFollowed!,
                ),
                //标题
                title: SelectableText(illust.title),
                //用户名
                subtitle: Text(illust.user.name)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: InkWell(
              onLongPress: () async {
                await Utils.copyToClipboard('${illust.id}');
                Get.find<PlatformApi>().toast(I18n.copySuccess.tr);
              },
              child: Text('${I18n.illust.tr}ID:${illust.id}'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: Get.textTheme.bodyText1?.color),
                    children: [
                      TextSpan(text: Utils.japanDateToLocalDateString(DateTime.parse(illust.createDate))),
                      const TextSpan(text: '  '),
                      TextSpan(
                        text: '${illust.totalView} ',
                        style: TextStyle(color: Get.theme.colorScheme.primary),
                      ),
                      TextSpan(text: I18n.totalView.tr),
                      const TextSpan(text: '  '),
                      TextSpan(
                        text: '${illust.totalBookmarks} ',
                        style: TextStyle(color: Get.theme.colorScheme.primary),
                      ),
                      TextSpan(text: I18n.totalBookmark.tr),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              runSpacing: 5,
              spacing: 5,
              children: [
                for (final tag in illust.tags)
                  GestureDetector(
                    onTap: () => Get.to(
                      SearchIllustResultPage(
                        word: tag.name,
                        isTemp: true,
                      ),
                    ),
                    onLongPress: () {
                      Utils.copyToClipboard(tag.name);
                      Get.find<PlatformApi>().toast('${I18n.copySuccess.tr}[${tag.name}]');
                    },
                    child: RichText(
                      text: TextSpan(
                        style: Get.theme.textTheme.bodyText2,
                        children: null != tag.translatedName
                            ? [
                                TextSpan(
                                  text: '#${tag.name}  ',
                                  style: TextStyle(color: Get.theme.colorScheme.primary),
                                ),
                                TextSpan(
                                  text: '${tag.translatedName}',
                                ),
                              ]
                            : [
                                TextSpan(
                                  text: '#${tag.name}',
                                  style: TextStyle(color: Get.theme.colorScheme.primary),
                                ),
                              ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (illust.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Card(
                child: HtmlRichText(
                  illust.caption,
                  padding: const EdgeInsets.all(5),
                  canShowOriginal: true,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Card(
              child: ListTile(
                onTap: () => Get.to(IllustCommentPage(id: illust.id)),
                title: Center(
                  child: Text(I18n.viewComment.tr),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final source = IllustRelatedListSource(illust.id);
    if (Get.find<AppSettingsService>().enableBrowsingHistory) {
      Get.find<BrowsingHistoryService>().exist(illust.id).then(
        (exist) {
          if (!exist) {
            Get.find<BrowsingHistoryService>().insert(illust);
          }
        },
      );
    }
    return Scaffold(
      body: LoadingMoreCustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(I18n.illust.tr),
          ),
          if (illust.isUgoira)
            SliverToBoxAdapter(
              child: UgoiraViewer(
                id: illust.id,
                previewUrl: Utils.getPreviewUrl(illust.imageUrls),
              ),
            )
          else if (1 == illust.pageCount)
            _buildImageCard(
              id: illust.id,
              title: illust.title,
              previewUrl: Utils.getPreviewUrl(illust.imageUrls),
              originUrl: illust.metaSinglePage.originalImageUrl!,
              index: 0,
            )
          else
            for (var index = 0; index < illust.metaPages.length; ++index)
              _buildImageCard(
                id: illust.id,
                title: illust.title,
                previewUrl: Utils.getPreviewUrl(illust.metaPages[index].imageUrls),
                originUrl: illust.metaPages[index].imageUrls.original!,
                index: index,
              ),
          _buildIllustInfo(),
          LoadingMoreSliverList(
            SliverListConfig(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (BuildContext context, Illust item, int index) {
                return IllustPreviewer(illust: item, square: true);
              },
              sourceList: source,
              childCountBuilder: (int count) => source.length,
              indicatorBuilder: (BuildContext context, IndicatorStatus status) => LoadingMoreIndicator(
                status: status,
                errorRefresh: () => source.errorRefresh(),
                isSliver: true,
                fullScreenErrorCanRetry: true,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: BookmarkSwitchButton(
        id: illust.id,
        floating: true,
        initValue: illust.isBookmarked,
      ),
    );
  }
}
