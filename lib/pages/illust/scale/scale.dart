/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:scale.dart
 * 创建时间:2021/11/26 下午6:52
 * 作者:小草
 */

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/entity/illust.dart';
import 'package:pixiv_func_mobile/app/download/downloader.dart';
import 'package:pixiv_func_mobile/app/settings/app_settings.dart';
import 'package:pixiv_func_mobile/utils/utils.dart';

class ImageScalePage extends StatelessWidget {
  final Illust illust;
  final int initialPage;

  const ImageScalePage({Key? key, required this.illust, this.initialPage = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final urls = <String>[];
    if (1 == illust.pageCount) {
      urls.add(
        Get.find<AppSettingsService>().scaleQuality ? illust.metaSinglePage.originalImageUrl! : illust.imageUrls.large,
      );
    } else {
      urls.addAll(
        [
          for (final metaPage in illust.metaPages)
            Get.find<AppSettingsService>().scaleQuality ? metaPage.imageUrls.original! : metaPage.imageUrls.large
        ],
      );
    }
    return ObxValue<RxInt>(
      (data) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('${data.value + 1}/${urls.length}张'),
          ),
          body: ExtendedImageGesturePageView(
            controller: ExtendedPageController(initialPage: initialPage),
            onPageChanged: (int page) => data.value = page,
            children: [
              for (int i = 0; i < urls.length; ++i)
                Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: ExtendedImage.network(
                          Utils.replaceImageSource(urls[i]),
                          headers: const {'Referer': 'https://app-api.pixiv.net'},
                          gaplessPlayback: true,
                          mode: ExtendedImageMode.gesture,
                          loadStateChanged: (ExtendedImageState state) {
                            if (state.extendedImageLoadState == LoadState.loading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            return null;
                          },
                          initGestureConfigHandler: (ExtendedImageState state) => GestureConfig(
                            minScale: 0.9,
                            maxScale: 6.0,
                            speed: 1.0,
                            initialScale: 0.95,
                            inPageView: true,
                          ),
                        ),
                      ),
                      IconButton(
                        splashRadius: 20,
                        onPressed: () => Downloader.start(illust: illust, url: urls[i]),
                        icon: const Icon(Icons.save_alt_outlined),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
      initialPage.obs,
    );
  }
}
