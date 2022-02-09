/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:image.dart
 * 创建时间:2021/11/29 下午6:18
 * 作者:小草
 */
import 'dart:typed_data';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/i18n/i18n.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_mobile/models/search_image_item.dart';
import 'package:pixiv_func_mobile/pages/illust/illust.dart';
import 'package:pixiv_func_mobile/pages/search/result/image/controller.dart';

class SearchImageResultPage extends StatelessWidget {
  final Uint8List imageBytes;
  final String filename;

  const SearchImageResultPage({Key? key, required this.imageBytes, required this.filename}) : super(key: key);

  Widget _buildItem(BuildContext context, SearchImageItem item) {
    final controller = Get.find<SearchImageResultController>();
    if (item.loadFailed) {
      return InkWell(
        onTap: () => controller.loadData(item),
        child: Card(
          child: SizedBox(
            height: 180,
            child: Center(
              child: Text(I18n.loadFailedRetry.tr),
            ),
          ),
        ),
      );
    } else if (item.loading) {
      return const Card(
        child: SizedBox(
          height: 180,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (null == item.illust) {
      return Container();
    } else {
      final illust = item.illust!;
      return InkWell(
        onTap: () => Get.to(IllustPage(illust: illust)),
        child: Card(
          child: SizedBox(
            height: 180,
            child: Center(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ImageFromUrl(
                            illust.imageUrls.squareMedium,
                            width: 150,
                            height: 150,
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(illust.title, overflow: TextOverflow.ellipsis),
                            subtitle: Text('${I18n.similarity.tr}:${item.result.similarityText}'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchImageResultController(imageBytes: imageBytes, filename: filename));
    return GetBuilder<SearchImageResultController>(
      assignId: true,
      initState: (state) async {
        await controller.init();
      },
      builder: (controller) {
        final Widget widget;
        if (controller.loading) {
          widget = const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.initFailed) {
          widget = Center(
            child: ListTile(
              onTap: () => controller.init(),
              title: Center(
                child: Text(I18n.loadFailedRetry.tr),
              ),
            ),
          );
        } else {
          widget = ListView(
            children: [
              for (final result in controller.list) _buildItem(context, result),
            ],
          );
        }
        return Scaffold(
          body: ExtendedNestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text('${I18n.search.tr}${I18n.image.tr}'),
                  actions: [
                    IconButton(
                      onPressed: () => controller.init(),
                      icon: const Icon(Icons.refresh_outlined),
                    )
                  ],
                )
              ];
            },
            body: widget,
          ),
        );
      },
    );
  }
}
