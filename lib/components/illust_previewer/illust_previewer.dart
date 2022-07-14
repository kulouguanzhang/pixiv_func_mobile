import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/components/bookmark_switch_button/bookmark_switch_button.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_mobile/pages/illust/illust.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class IllustPreviewer extends StatelessWidget {
  final Illust illust;

  final bool square;

  final bool showUserName;

  final String? heroTag;

  final BorderRadius? borderRadius;

  const IllustPreviewer({
    Key? key,
    required this.illust,
    this.square = false,
    this.showUserName = true,
    this.heroTag,
    this.borderRadius,
  }) : super(key: key);

  Widget _buildImage({
    required String url,
    required double width,
    required double height,
    required int pageCount,
    BorderRadius? borderRadius,
  }) {
    final widget = ImageFromUrl(
      url,
      width: width,
      height: height,
      fit: square ? BoxFit.fill : BoxFit.fitWidth,
      imageBuilder: (Widget imageWidget) {
        return Stack(
          fit: StackFit.expand,
          children: [
            imageWidget,
            Visibility(
              visible: illust.isR18,
              child: Positioned(
                left: 2,
                top: 2,
                child: Card(
                  color: Colors.pink.shade300,
                  child: const Padding(
                    padding: EdgeInsets.all(1.5),
                    child: Text('R-18'),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: illust.isUgoira,
              child: const Positioned(
                left: 2,
                bottom: 2,
                child: Card(
                  color: Colors.white12,
                  child: Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0), child: Text('Ugoira')),
                ),
              ),
            ),
            Visibility(
              visible: pageCount > 1,
              child: Positioned(
                right: 2,
                top: 2,
                child: Card(
                  color: Colors.white12,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Text('$pageCount'),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.to(IllustPage(illust: illust), preventDuplicates: false),
      child: borderRadius != null
          ? ClipRRect(
              borderRadius: borderRadius,
              child: widget,
            )
          : widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (square) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return _buildImage(
            url: illust.imageUrls.squareMedium,
            width: constraints.maxWidth,
            height: constraints.maxWidth,
            pageCount: illust.pageCount,
            borderRadius: borderRadius,
          );
        },
      );
    } else {
      return Column(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final previewHeight = constraints.maxWidth / illust.width * illust.height;
              return Hero(
                tag: heroTag ?? 'IllustHero:${illust.id}',
                child: _buildImage(
                  url: Utils.getPreviewUrl(illust.imageUrls),
                  width: constraints.maxWidth,
                  height: previewHeight,
                  pageCount: illust.pageCount,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      illust.title,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      isBold: true,
                    ),
                    if (showUserName)
                      Text(
                        illust.user.name,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              BookmarkSwitchButton(
                id: illust.id,
                initValue: illust.isBookmarked,
              ),
            ],
          ),
        ],
      );
    }
  }
}
