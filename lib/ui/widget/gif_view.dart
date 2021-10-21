/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:gif_view.dart
 * 创建时间:2021/10/19 下午10:51
 * 作者:小草
 */

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/view_model/gif_view_model.dart';

class GifView extends StatelessWidget {
  final int id;
  final String previewUrl;
  final List<ui.Image> renderImages;
  final List<int> delays;
  final double width;
  final double height;
  final String? heroTag;

  const GifView({
    Key? key,
    required this.id,
    required this.previewUrl,
    required this.renderImages,
    required this.delays,
    required this.width,
    required this.height,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: GifViewModel(renderImages: renderImages, delays: delays),
      builder: (BuildContext context, GifViewModel model, Widget? child) {
        return Hero(
          tag: heroTag ?? 'illust:$id',
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(width, height),
                  painter: GifPainter(
                    model.renderImages,
                    delays: model.delays,
                    valueNotifier: model.valueNotifier,
                  ),
                ),
                Visibility(
                  visible: model.pause,
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

  final ValueNotifier<int> valueNotifier;

  GifPainter(
    this.images, {
    required this.delays,
    required this.valueNotifier,
  }) : super(repaint: valueNotifier);

  final paintE = Paint();

  @override
  void paint(Canvas canvas, Size size) async {
    canvas.drawImage(images[valueNotifier.value], Offset.zero, paintE);
  }

  @override
  bool shouldRepaint(covariant GifPainter oldDelegate) {
    return valueNotifier != oldDelegate.valueNotifier;
  }
}
