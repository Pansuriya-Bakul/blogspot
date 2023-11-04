import 'package:blog/helper/ui.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.text,
      this.textColor,
      this.textSize,
      this.backgroundColor,
      this.shadowColor,
      this.padding,
      this.onPressed})
      : super(key: key);

  final String text;
  final Color? textColor;
  final double? textSize;
  final Color? backgroundColor;
  final Color? shadowColor;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(text,
            style:
                UI.textStyleBold(textColor ?? Colors.white, textSize ?? 15.0),
            textAlign: TextAlign.center),
        style: ElevatedButton.styleFrom(
            primary: backgroundColor ?? Colors.black,
            elevation: 2.5,
            shadowColor: shadowColor ?? Colors.black,
            padding:
                padding ?? const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0))));
  }
}
