import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/novel.dart';
import 'package:pixiv_func_mobile/components/bookmark_switch_button/bookmark_switch_button.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_mobile/components/novel_detail_dialog/novel_detail_dialog.dart';

class NovelPreviewer extends StatelessWidget {
  final Novel novel;

  const NovelPreviewer({Key? key, required this.novel}) : super(key: key);

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
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 5),
        onTap: () => Get.dialog(NovelDetailDialog(novel: novel)),
        leading: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              width: constraints.maxWidth / 7,
              child: ImageFromUrl(novel.imageUrls.medium),
            );
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: null != novel.series.title,
              child: Text('${novel.series.title}', style: Get.textTheme.caption),
            ),
            Text(novel.title, style: Get.textTheme.bodyText1),
            Text(
              'by ${novel.user.name}',
              style: Get.textTheme.caption?.copyWith(
                color: Get.theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        subtitle: Text(sb.toString()),
        trailing: BookmarkSwitchButton(
          id: novel.id,
          floating: false,
          initValue: novel.isBookmarked,
          isNovel: true,
        ),
      ),
    );
  }
}
