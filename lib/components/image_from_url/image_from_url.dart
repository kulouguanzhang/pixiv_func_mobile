/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:image_from_url.dart
 * 创建时间:2021/8/25 下午8:42
 * 作者:小草
 */

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/utils/utils.dart';

class ImageFromUrl extends StatelessWidget {
  final String url;

  final Color? color;

  final BlendMode? colorBlendMode;

  final double? width;

  final double? height;

  final BoxFit? fit;

  final Widget Function(Widget imageWidget)? imageBuilder;

  final Widget? placeholderWidget;

  const ImageFromUrl(
    this.url, {
    Key? key,
    this.color,
    this.colorBlendMode,
    this.width,
    this.height,
    this.fit,
    this.imageBuilder,
    this.placeholderWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //转义 不然 '/' 被当成路径会报错
    final cacheUrlPath = Uri.parse(url).path.replaceAll('/', '%2F');
    return ExtendedImage.network(
      Utils.replaceImageSource(url),
      headers: const {'Referer': 'https://app-api.pixiv.net/'},
      cacheKey: cacheUrlPath,
      printError: false,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return placeholderWidget ??
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(child: CircularProgressIndicator()),
                );
          case LoadState.completed:
            return imageBuilder?.call(state.completedWidget);
          case LoadState.failed:
            return Center(
              child: IconButton(
                icon: const Icon(Icons.refresh_sharp),
                iconSize: 35,
                onPressed: state.reLoadImage,
              ),
            );
        }
      },
      color: color,
      colorBlendMode: colorBlendMode,
      enableMemoryCache: false,
      width: width,
      height: height,
      fit: fit ?? BoxFit.fitWidth,
    );
  }
}
