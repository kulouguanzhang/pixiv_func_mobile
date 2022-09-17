import 'package:flutter/services.dart';


class PlatformAppWidget {
  Future<PlatformAppWidget> init(Future<Object?> Function(dynamic map) handler) async {
    const BasicMessageChannel(
      'xiaocao/platform/appwidget/message',
      StandardMessageCodec(),
    ).setMessageHandler(handler);
    return this;
  }
}
