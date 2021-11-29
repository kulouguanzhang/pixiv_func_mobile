/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:auto_keep.dart
 * 创建时间:2021/11/19 下午5:40
 * 作者:小草
 */
import 'package:flutter/material.dart';

class AutomaticKeepWidget extends StatefulWidget {
  final Widget child;
  const AutomaticKeepWidget({Key? key, required this.child}) : super(key: key);

  @override
  _AutomaticKeepWidgetState createState() => _AutomaticKeepWidgetState();
}

class _AutomaticKeepWidgetState extends State<AutomaticKeepWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
