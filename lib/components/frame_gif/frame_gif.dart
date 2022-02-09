/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:frame_gif.dart
 * 创建时间:2021/11/28 下午6:23
 * 作者:小草
 */
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/route/route.dart';

import 'controller.dart';

class FrameGif extends StatelessWidget with RouteAware {
  final int id;
  final String previewUrl;
  final List<ui.Image> images;
  final List<int> delays;
  final String? heroTag;
  final Size size;

  const FrameGif({
    Key? key,
    required this.id,
    required this.previewUrl,
    required this.images,
    required this.delays,
    this.heroTag,
    required this.size,
  }) : super(key: key);

  @override
  void didPushNext() {
    Get.find<FrameGifController>(tag: '$runtimeType:$id').stop();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    Get.find<FrameGifController>(tag: '$runtimeType:$id').start();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    final controllerTag = '$runtimeType:$id';
    final controller = Get.put(FrameGifController(images, delays), tag: controllerTag);
    return GetBuilder<FrameGifController>(
      tag: controllerTag,
      assignId: true,
      didChangeDependencies: (state) {
        routeObserver.subscribe(this, ModalRoute.of(context)!);
      },
      dispose: (state) {
        routeObserver.unsubscribe(this);
        controller.stop();
        Get.delete<FrameGifController>(tag: controllerTag);
      },
      initState: (state) => controller.start(),
      builder: (controller) {
        if (controller.playing) {
          return Hero(
            tag: heroTag ?? 'IllustHero:$id',
            child: GestureDetector(
              onTap: () => controller.pauseStateChange(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: size,
                    painter: _GifPainter(
                      controller.images,
                      delays: controller.delays,
                      indexValueNotifier: controller.indexValueNotifier,
                      pauseValueNotifier: controller.pauseValueNotifier,
                      size: size,
                    ),
                  ),
                  Visibility(
                    visible: controller.isPause,
                    child: const Icon(Icons.play_circle_outline_outlined, size: 70),
                  )
                ],
              ),
            ),
          );
        } else {
          return SizedBox(
            height: size.height,
            width: size.width,
          );
        }
      },
    );
  }
}

class _GifPainter extends CustomPainter {
  final List<ui.Image> images;

  final List<int> delays;

  final ValueNotifier<int> indexValueNotifier;

  final ValueNotifier<bool> pauseValueNotifier;

  final Size size;

  _GifPainter(
    this.images, {
    required this.delays,
    required this.indexValueNotifier,
    required this.pauseValueNotifier,
    required this.size,
  }) : super(repaint: indexValueNotifier);

  final paintE = Paint();

  @override
  void paint(Canvas canvas, Size size) async {
    final Size imageSize = Size(
      images[indexValueNotifier.value].width.toDouble(),
      images[indexValueNotifier.value].height.toDouble(),
    );
    final Rect dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
    FittedSizes fittedSizes = applyBoxFit(BoxFit.fitWidth, imageSize, dstRect.size);
    Rect inputRect = Alignment.center.inscribe(fittedSizes.source, Offset.zero & imageSize);
    Rect outputRect = Alignment.center.inscribe(fittedSizes.destination, dstRect);

    canvas.drawImageRect(images[indexValueNotifier.value], inputRect, outputRect, paintE);
    if (pauseValueNotifier.value) {
      canvas.drawRect(outputRect, Paint()..color = Get.isDarkMode ? Colors.black45 : Colors.white24);
    }
  }

  @override
  bool shouldRepaint(covariant _GifPainter oldDelegate) {
    return indexValueNotifier != oldDelegate.indexValueNotifier;
  }
}
