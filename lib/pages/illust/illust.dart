import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/app/downloader/downloader.dart';
import 'package:pixiv_func_mobile/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_mobile/components/bookmark_switch_button/bookmark_switch_button.dart';
import 'package:pixiv_func_mobile/components/follow_switch_button/follow_switch_button.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_mobile/data_content/data_content.dart';
import 'package:pixiv_func_mobile/pages/illust/comment/comment.dart';
import 'package:pixiv_func_mobile/pages/illust/controller.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_mobile/widgets/no_scroll_behavior/no_scroll_behavior.dart';
import 'package:pixiv_func_mobile/widgets/scaffold/scaffold.dart';
import 'package:pixiv_func_mobile/widgets/tab_bar/tab_bar.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

import 'scale/scale.dart';
import 'ugoira_viewer/ugoira_viewer.dart';

class IllustPage extends StatelessWidget {
  final Illust illust;

  const IllustPage({required this.illust, Key? key}) : super(key: key);

  String get controllerTag => '$runtimeType:${illust.id}';

  Widget _buildImageItem({
    required int id,
    required String title,
    required String previewUrl,
    required String originUrl,
    required int index,
  }) {
    final widget = GestureDetector(
      onTap: () => Get.to(ImageScalePage(illust: illust, initialPage: index)),
      onLongPress: () => Downloader.start(illust: illust, url: originUrl),
      child: ImageFromUrl(
        previewUrl,
        placeholderWidget: const SizedBox(
          height: 200,
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
    return 0 == index ? Hero(tag: 'IllustHero:$id', child: widget) : widget;
  }

  Widget _buildImageDetail() {
    final controller = Get.find<IllustController>(tag: controllerTag);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                // onTap: () => Get.to(UserPage(id: userPreview.user.id)),
                child: Hero(
                  tag: 'UserHero:${illust.user.id}',
                  child: AvatarFromUrl(illust.user.profileImageUrls.medium, radius: 48),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    illust.user.name,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 16,
                    isBold: true,
                  ),
                  TextWidget(
                    illust.user.account,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 12,
                  ),
                ],
              ),
              const Spacer(),
              FollowSwitchButton(
                id: illust.user.id,
                initValue: illust.user.isFollowed!,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              TextWidget(
                '上传日期: ${Utils.japanDateToLocalDateString(DateTime.parse(illust.createDate))}',
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 15),
              const Icon(Icons.remove_red_eye_outlined, size: 12),
              const SizedBox(width: 5),
              TextWidget(
                '${illust.totalView}',
              ),
              const SizedBox(width: 15),
              const Icon(Icons.favorite_border, size: 12),
              const SizedBox(width: 5),
              TextWidget(
                '${illust.totalView}',
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextWidget('插画ID: ${illust.id}'),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.share_outlined,
                    size: 12,
                  ),
                ],
              ),
              if (controller.illust.caption.isNotEmpty)
                GestureDetector(
                  onTap: () => controller.showCommentChangeState(),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      TextWidget(
                        '详情',
                        color: controller.showComment ? Get.theme.colorScheme.primary : null,
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        controller.showComment ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: controller.showComment ? Get.theme.colorScheme.primary : null,
                        size: 12,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (controller.showComment)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.topLeft,
              child: HtmlRichText(controller.illust.caption),
            ),
          Padding(
            padding: EdgeInsets.only(top: controller.showComment ? 0 : 20),
            child: Wrap(
              runSpacing: 5,
              spacing: 5,
              children: [
                for (final tag in illust.tags)
                  Padding(
                    padding: const EdgeInsets.only(right: 2, top: 5, bottom: 5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Get.theme.colorScheme.surface,
                      ),
                      child: TextWidget('#${tag.name} ${tag.translatedName != null ? ' ${tag.translatedName}' : ''}', fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Get.put(IllustController(illust), tag: controllerTag);
    return GetBuilder<IllustController>(
      tag: controllerTag,
      assignId: true,
      builder: (controller) => DefaultTabController(
        length: 2,
        child: ScaffoldWidget(
          title: illust.title,
          centerTitle: true,
          actions: [
            BookmarkSwitchButton(id: illust.id, initValue: illust.isBookmarked),
            IconButton(onPressed: () {}, icon: const Icon(Icons.file_download_outlined)),
          ],
          child: NoScrollBehaviorWidget(
            child: ExtendedNestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
                if (illust.isUgoira)
                  SliverToBoxAdapter(
                    child: UgoiraViewer(
                      id: illust.id,
                      previewUrl: Utils.getPreviewUrl(illust.imageUrls),
                    ),
                  )
                else if (1 == illust.pageCount)
                  SliverToBoxAdapter(
                    child: _buildImageItem(
                      id: illust.id,
                      title: illust.title,
                      previewUrl: Utils.getPreviewUrl(illust.imageUrls),
                      originUrl: illust.metaSinglePage.originalImageUrl!,
                      index: 0,
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        for (var index = 0; index < illust.metaPages.length; ++index)
                          _buildImageItem(
                            id: illust.id,
                            title: illust.title,
                            previewUrl: Utils.getPreviewUrl(illust.metaPages[index].imageUrls),
                            originUrl: illust.metaPages[index].imageUrls.original!,
                            index: index,
                          ),
                      ],
                    ),
                  ),
                SliverToBoxAdapter(
                  child: _buildImageDetail(),
                ),
                SliverAppBar(
                  toolbarHeight: 0,
                  automaticallyImplyLeading: false,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 0.5,
                          color: const Color(0xFF373737),
                        ),
                        const TabBarWidget(
                          indicatorMinWidth: 15,
                          indicator: RRecTabIndicator(
                            radius: 4,
                            insets: EdgeInsets.only(bottom: 5),
                          ),
                          tabs: [
                            Tab(text: '推荐'),
                            Tab(text: '评论'),
                          ],
                        )
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ],
              body: TabBarView(
                children: [
                  DataContent(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    sourceList: () => controller.illustRelatedSource,
                    itemBuilder: (BuildContext context, Illust item, int index) {
                      return IllustPreviewer(illust: item, square: true);
                    },
                  ),
                  IllustCommentContent(id: illust.id),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
