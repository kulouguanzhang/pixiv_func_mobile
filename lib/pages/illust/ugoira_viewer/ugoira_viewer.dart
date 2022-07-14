import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_mobile/widgets/frame_gif/frame_gif.dart';

import 'controller.dart';

class UgoiraViewer extends StatelessWidget with RouteAware {
  final int id;
  final String previewUrl;
  final String? heroTag;

  @override
  void didPopNext() {}

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
                  child: FrameGifWidget(
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
                        state.loading ? const CircularProgressIndicator() : const Icon(Icons.play_circle_outline_outlined, size: 70),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
