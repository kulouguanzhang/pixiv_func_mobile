import 'package:flutter/material.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:pixiv_func_mobile/components/bookmark_switch_button/bookmark_switch_button.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';

class IllustPreviewer extends StatelessWidget {
  final Illust illust;

  final bool square;

  final bool showUserName;

  final String? heroTag;

  const IllustPreviewer({
    Key? key,
    required this.illust,
    this.square = false,
    this.showUserName = true,
    this.heroTag,
  }) : super(key: key);

  static final borderRadius = BorderRadius.circular(10);

  static const circularRadius = Radius.circular(10);

  Widget _buildImage({
    required String url,
    required double width,
    required double height,
    required int pageCount,
  }) {
    return GestureDetector(
      onTap: () {},
      child: ImageFromUrl(
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
      ),
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
          );
        },
      );
    } else {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final previewHeight = constraints.maxWidth / illust.width * illust.height;
                return Hero(
                  tag: heroTag ?? 'IllustHero:${illust.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: circularRadius, topRight: circularRadius),
                    child: _buildImage(
                      url: Utils.getPreviewUrl(illust.imageUrls),
                      width: constraints.maxWidth,
                      height: previewHeight,
                      pageCount: illust.pageCount,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.only(left: 5),
              title: Text(
                illust.title,
                style: const TextStyle(fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: showUserName
                  ? Text(
                      illust.user.name,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: BookmarkSwitchButton(
                id: illust.id,
                floating: false,
                initValue: illust.isBookmarked,
              ),
            ),
          ],
        ),
      );
    }
  }
}
