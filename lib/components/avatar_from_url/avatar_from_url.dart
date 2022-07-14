import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/data/settings_service.dart';
import 'package:pixiv_func_mobile/components/image_from_url/image_from_url.dart';

class AvatarFromUrl extends StatelessWidget {
  static const _targetHost = 'i.pximg.net';

  final String url;
  final double? radius;
  final Widget Function(Widget imageWidget)? imageBuilder;

  const AvatarFromUrl(this.url, {Key? key, this.radius, this.imageBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = url.replaceFirst(_targetHost, Get.find<SettingsService>().imageSource);

    return ClipOval(
      child: ImageFromUrl(
        imageUrl,
        fit: BoxFit.cover,
        width: radius ?? 40,
        height: radius ?? 40,
        imageBuilder: imageBuilder,
      ),
    );
  }
}
