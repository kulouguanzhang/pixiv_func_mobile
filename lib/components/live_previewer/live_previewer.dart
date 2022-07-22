import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_dart_api/model/live.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';
import 'package:pixiv_func_mobile/pages/live/live.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class LivePreviewer extends StatelessWidget {
  final Live live;

  const LivePreviewer({Key? key, required this.live}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            //固定的
            final previewHeight = constraints.maxWidth * 0.56;
            return GestureDetector(
              onTap: () => Get.to(LivePage(id: live.id, name: live.name)),
              child: ClipRRect(
                borderRadius:  const BorderRadius.all(Radius.circular(12)),
                child: ImageFromUrl(live.thumbnailImageUrl, width: double.infinity, height: previewHeight, fit: BoxFit.fitWidth),
              ),
            );
          },
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    live.name,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    isBold: true,
                  ),
                ],
              ),
            ),
            if (live.isEnabledMicInput) const Icon(Icons.mic) else const Icon(Icons.mic_off),
          ],
        ),
      ],
    );
  }
}
