/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ugoira_viewer.dart
 * 创建时间:2021/11/28 下午1:38
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_android/components/frame_gif/frame_gif.dart';
import 'package:pixiv_func_android/components/image_from_url/image_from_url.dart';

import 'controller.dart';

class UgoiraViewer extends StatelessWidget {
  final int id;
  final String previewUrl;
  final String? heroTag;

  const UgoiraViewer({
    Key? key,
    required this.id,
    required this.previewUrl,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerTag = '$runtimeType:$id';
    Get.put(UgoiraViewerController(id), tag: controllerTag);

    return GetBuilder<UgoiraViewerController>(
      tag: controllerTag,
      assignId: true,
      builder: (UgoiraViewerController controller) {
        final state = controller.state;
        return Card(
          child: state.init
              ? GestureDetector(
                  onLongPress: () => controller.save(),
                  child: FrameGif(
                    id: id,
                    previewUrl: previewUrl,
                    images: state.images,
                    delays: state.delays,
                    size: state.size,
                  ),
                )
              : GestureDetector(
                  onTap: () => controller.play(),
                  onLongPress: () => controller.save(),
                  child: Hero(
                    tag: heroTag ?? 'IllustHero:$id',
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ImageFromUrl(
                          previewUrl,
                          color: Get.isDarkMode ? Colors.black45 : Colors.white24,
                          colorBlendMode: BlendMode.srcOver,
                          placeholderWidget: const SizedBox(
                            height: 180,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        state.loading
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.play_circle_outline_outlined, size: 70),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
