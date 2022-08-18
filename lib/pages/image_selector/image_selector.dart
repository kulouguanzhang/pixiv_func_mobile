import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:get/get.dart';
import 'package:image/image.dart' hide BlendMode;
import 'package:image_picker/image_picker.dart';
import 'package:pixiv_func_mobile/models/image_info.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class ImageSelectorPage extends StatefulWidget {
  final double? ratio;
  final ValueChanged<PickedImageInfo> onChanged;

  const ImageSelectorPage({Key? key, this.ratio, required this.onChanged}) : super(key: key);

  @override
  State<ImageSelectorPage> createState() => _ImageSelectorPageState();
}

class _ImageSelectorPageState extends State<ImageSelectorPage> {
  Uint8List? _imageBytes;
  String? _filename;

  final editorKey = GlobalKey<ExtendedImageEditorState>();

  @override
  void initState() {
    selectImage();
    super.initState();
  }

  void selectImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((file) async {
      if (null != file) {
        final bytes = await file.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _filename = file.name;
        });
      }
    });
  }

  Widget buildActionButton({required VoidCallback onTap, required IconData iconData, required String text}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: 30,
            ),
            const SizedBox(height: 10),
            TextWidget(text, fontSize: 20)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: null == _imageBytes
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => selectImage(),
              child: const Center(
                child: TextWidget('选择图片', fontSize: 30),
              ),
            )
          : ExtendedImage.memory(
              _imageBytes!,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              extendedImageEditorKey: editorKey,
              initEditorConfigHandler: (state) {
                return EditorConfig(
                    maxScale: 8.0,
                    cropRectPadding: const EdgeInsets.all(20.0),
                    hitTestSize: 20.0,
                    cropAspectRatio: widget.ratio,
                    cropLayerPainter: CustomEditorCropLayerPainter());
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: buildActionButton(
                onTap: () async {
                  final state = editorKey.currentState;
                  final Rect? cropRect = state?.getCropRect();
                  Uint8List? data = state?.rawImageData;
                  if (null == cropRect || null == data) {
                    return;
                  }

                  final image = copyCrop(
                    decodeImage(data)!,
                    cropRect.left.toInt(),
                    cropRect.top.toInt(),
                    cropRect.width.toInt(),
                    cropRect.height.toInt(),
                  );

                  widget.onChanged(PickedImageInfo(Uint8List.fromList(encodePng(image)), _filename!));
                  Get.back();
                },
                iconData: Icons.check,
                text: '确定',
              ),
            ),
            Expanded(child: buildActionButton(onTap: () => editorKey.currentState?.reset(), iconData: Icons.refresh, text: '重置')),
            Expanded(child: buildActionButton(onTap: () => selectImage(), iconData: Icons.cached, text: '重选')),
            Expanded(child: buildActionButton(onTap: () => Get.back(), iconData: Icons.close, text: '取消')),
          ],
        ),
      ),
    );
  }
}

class CustomEditorCropLayerPainter extends EditorCropLayerPainter {
  @override
  void paint(Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    super.paint(canvas, size, painter);
    final Paint paint = Paint()
      ..color = painter.cornerColor.withOpacity(2 / 3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawArc(painter.cropRect.deflate(paint.strokeWidth * 0.5), 0, 360, false, paint);
  }
}
