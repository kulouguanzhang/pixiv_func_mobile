import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_func_mobile/components/bookmark_switch_button/bookmark_switch_button.dart';
import 'package:pixiv_func_mobile/components/pixiv_image/pixiv_image.dart';
import 'package:pixiv_func_mobile/pages/novel/novel.dart';
import 'package:pixiv_func_mobile/widgets/html_rich_text/html_rich_text.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';
// import 'package:pixiv_func_mobile/components/novel_detail_dialog/novel_detail_dialog.dart';

class NovelPreviewer extends StatelessWidget {
  final Novel novel;
  final bool showUserName;

  const NovelPreviewer({Key? key, required this.novel, this.showUserName = true}) : super(key: key);

  static const heightRatio = 248 / 176;

  @override
  Widget build(BuildContext context) {
    final sb = StringBuffer();
    final textCountString = novel.textLength.toString().replaceAllMapped(
      RegExp(r'\B(?=(?:\d{3})+\b)'),
      (match) {
        return ',${match.input.substring(match.start, match.end)}';
      },
    );
    sb.write('$textCountString字 ');
    for (final tag in novel.tags) {
      sb.write(' #${tag.name}');
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.to(() => NovelPage(novel: novel)),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxWidth * 0.3 * heightRatio,
              child: Row(
                children: [
                  SizedBox(
                    width: constraints.maxWidth * 0.3,
                    height: constraints.maxWidth * 0.3 * heightRatio,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                      child: PixivImageWidget(
                        novel.imageUrls.medium,
                        // fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    // width: constraints.maxWidth * 0.7 - 12,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(novel.title, fontSize: 16, isBold: true, overflow: TextOverflow.ellipsis),
                                  if (showUserName) TextWidget(novel.user.name, fontSize: 10, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            BookmarkSwitchButton(
                              id: novel.id,
                              title: novel.title,
                              initValue: novel.isBookmarked,
                              isNovel: true,
                            ),
                          ],
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: Get.height * 0.15),
                          child: Wrap(
                            runSpacing: 5,
                            spacing: 5,
                            clipBehavior: Clip.hardEdge,
                            children: [
                              for (final tag in novel.tags)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                    child: TextWidget('${tag.name} ${tag.translatedName != null ? ' ${tag.translatedName}' : ''}',
                                        fontSize: 12, forceStrutHeight: true),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Expanded(child: HtmlRichText(novel.caption, overflow: TextOverflow.fade)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
