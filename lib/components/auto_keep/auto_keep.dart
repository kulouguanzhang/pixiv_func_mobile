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
