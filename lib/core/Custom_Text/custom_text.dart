import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class  TextWidget extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  const TextWidget({super.key, required this.text, required this.textStyle});
  @override
  Widget build(BuildContext context) {
    return Text(
        text,
      style: textStyle
    );
  }
}
