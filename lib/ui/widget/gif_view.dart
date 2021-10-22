/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:gif_view.dart
 * 创建时间:2021/10/19 下午10:51
 * 作者:小草
 */

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/view_model/gif_view_model.dart';

class GifView extends StatelessWidget {
  final int id;
  final String previewUrl;
  final List<ui.Image> images;
  final List<int> delays;
  final String? heroTag;
  final Size size;

  const GifView({
    Key? key,
    required this.id,
    required this.previewUrl,
    required this.images,
    required this.delays,
    this.heroTag,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: GifViewModel(images: images, delays: delays),
      builder: (BuildContext context, GifViewModel model, Widget? child) {
        return Hero(
          tag: heroTag ?? 'illust:$id',
          child: GestureDetector(
            onTap: () => model.isPause = !model.isPause,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: size,
                  painter: GifPainter(
                    model.images,
                    delays: model.delays,
                    indexValueNotifier: model.indexValueNotifier,
                    pauseValueNotifier: model.pauseValueNotifier,
                  ),
                ),
                Visibility(
                  visible: model.isPause,
                  child: const Icon(Icons.play_circle_outline_outlined, size: 70),
                )
              ],
            ),
          ),
        );
      },
      onModelReady: (GifViewModel model) => model.start(),
    );
  }
}

class GifPainter extends CustomPainter {
  final List<ui.Image> images;

  final List<int> delays;

  final ValueNotifier<int> indexValueNotifier;

  final ValueNotifier<bool> pauseValueNotifier;

  GifPainter(
    this.images, {
    required this.delays,
    required this.indexValueNotifier,
    required this.pauseValueNotifier,
  }) : super(repaint: indexValueNotifier);

  final paintE = Paint();

  @override
  void paint(Canvas canvas, Size size) async {
    final Size imageSize = Size(
      images[indexValueNotifier.value].width.toDouble(),
      images[indexValueNotifier.value].height.toDouble(),
    );
    final Rect dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    FittedSizes fittedSizes = applyBoxFit(BoxFit.contain, imageSize, dstRect.size);
    Rect inputRect = Alignment.center.inscribe(fittedSizes.source, Offset.zero & imageSize);
    Rect outputRect = Alignment.center.inscribe(fittedSizes.destination, dstRect);

    canvas.drawImageRect(images[indexValueNotifier.value], inputRect, outputRect, paintE);
    if (pauseValueNotifier.value) {
      canvas.drawRect(outputRect, Paint()..color = settingsManager.isLightTheme ? Colors.white24 : Colors.black45);
    }
  }

  @override
  bool shouldRepaint(covariant GifPainter oldDelegate) {
    return indexValueNotifier != oldDelegate.indexValueNotifier;
  }
}
