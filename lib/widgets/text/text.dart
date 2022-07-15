import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final bool isBold;
  final TextOverflow? overflow;

  const TextWidget(
    this.text, {
    Key? key,
    this.fontSize,
    this.color,
    this.isBold = false,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Theme.of(context).textTheme.caption?.color,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        overflow: overflow,
      ),
    );
  }
}
