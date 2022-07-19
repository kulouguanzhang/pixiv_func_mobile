import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/widgets/text/text.dart';

class ScaffoldWidget extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool centerTitle;

  final bool emptyAppBar;
  final bool automaticallyImplyLeading;
  final Widget? child;

  const ScaffoldWidget({
    Key? key,
    this.title,
    this.titleWidget,
    this.actions,
    this.centerTitle = true,
    this.emptyAppBar = false,
    this.automaticallyImplyLeading = true,
    this.child,
  }) : super(key: key);

  Widget _backButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(Icons.arrow_back_ios_new),
      ),
      onTap: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppBar? appBar;
    if (emptyAppBar) {
      appBar = AppBar(
        elevation: 0,
        toolbarHeight: 0,
        leading: automaticallyImplyLeading && (ModalRoute.of(context)?.canPop ?? false)
            ? _backButton()
            : null,
        automaticallyImplyLeading: false,
      );
    } else if (null != titleWidget) {
      appBar = AppBar(
        elevation: 0,
        title: titleWidget,
        centerTitle: centerTitle,
        leading: automaticallyImplyLeading && (ModalRoute.of(context)?.canPop ?? false)
            ? _backButton()
            : null,
        actions: actions,
        automaticallyImplyLeading: false,
      );
    } else if (null != title) {
      appBar = AppBar(
        elevation: 0,
        title: TextWidget(title!),
        centerTitle: centerTitle,
        leading: automaticallyImplyLeading && (ModalRoute.of(context)?.canPop ?? false)
            ? _backButton()
            : null,
        actions: actions,
        automaticallyImplyLeading: false,
      );
    } else {
      appBar = AppBar(
        elevation: 0,
        leading: automaticallyImplyLeading && (ModalRoute.of(context)?.canPop ?? false)
            ? _backButton()
            : null,
        actions: actions,
        automaticallyImplyLeading: false,
      );
    }
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: appBar,
      body: child,
    );
  }
}
