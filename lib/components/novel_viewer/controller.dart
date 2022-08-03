import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class NovelViewerController extends GetxController {
  final double maxWidth;
  final double maxHeight;

  NovelViewerController(String text, this.maxWidth, this.maxHeight) : textLines = text.split('\n');

  final List<String> textLines;

  final pageController = PageController(keepPage: true);

  int pageIndex = 0;

  TextStyle style = const TextStyle(height: 2, fontSize: 16);

  final List<NovelData> list = [];

  double get progress => list[pageIndex].endIndex / textLines.length;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    list.add(_forward(0));
    _preload();
    update();
  }

  void nextPage() {
    if (list.last.endIndex < textLines.length - 1) {
      ++pageIndex;
      list.add(_forward(list.last.endIndex));
      update();
    }
  }

  void previousPage() {
    if (pageIndex > 0) {
      --pageIndex;
      update();
    }
  }

  void _preload() {
    if (pageIndex == list.length - 1) {
      list.add(_forward(list.last.endIndex));
    }
  }

  NovelData _forward(int startIndex) {
    final renderTextLines = <String>[];
    final heightList = <double>[];
    double renderHeight = 0;
    for (int i = startIndex; i < textLines.length; ++i) {
      final currentText = textLines[i];
      final currentLineHeight = _getTextSize(text: currentText, maxWidth: maxWidth, style: style).height;
      heightList.add(currentLineHeight);
      if (renderHeight + currentLineHeight <= maxHeight) {
        renderHeight += currentLineHeight;
        renderTextLines.add(currentText);
      } else {
        break;
      }
    }
    return NovelData(startIndex, renderTextLines);
  }

  Size _getTextSize({required String text, required double maxWidth, TextStyle? style}) {
    TextPainter painter = TextPainter(
      locale: WidgetsBinding.instance.window.locale,
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: 2 ^ 31,
    )..layout(maxWidth: maxWidth);
    return painter.size;
  }
}

class NovelData {
  final int startIndex;
  final List<String> renderTextLines;

  NovelData(this.startIndex, this.renderTextLines);

  int get endIndex => startIndex + renderTextLines.length;
}
