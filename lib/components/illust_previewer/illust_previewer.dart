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
    bool needHero = false,
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
            if (needHero)
              Hero(
                tag: heroTag ?? 'IllustHero:${illust.id}',
                child: imageWidget,
              )
            else
              imageWidget,
            if (illust.isR18)
              Positioned(
                left: 7,
                top: 7,
                child: Card(
                  color: Get.theme.colorScheme.primary,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: TextWidget('R-18', color: Colors.white),
                  ),
                ),
              ),
            if (illust.isUgoira)
              const Positioned(
                left: 7,
                bottom: 7,
                child: Icon(Icons.gif_box_outlined, color: Color(0xFF606163)),
              ),
            if (pageCount > 1)
              Positioned(
                right: 7,
                top: 7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    color: const Color(0x40383838),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextWidget('$pageCount', color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.to(IllustPage(illust: illust), routeName: 'IllustPage:${illust.id}', preventDuplicates: false),
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
              return _buildImage(
                url: Utils.getPreviewUrl(illust.imageUrls),
                width: constraints.maxWidth,
                height: previewHeight,
                pageCount: illust.pageCount,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                needHero: true,
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
