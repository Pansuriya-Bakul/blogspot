import 'package:flutter/material.dart';

class UI {
  static toast(BuildContext context, String message) {
    var snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        dismissDirection: DismissDirection.horizontal,
        content: Container(
          child: Text(
            message,
            textAlign: TextAlign.start,
            style: textStyleNormal(Colors.white, 15.0),
          ),
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        ),
        backgroundColor: Colors.black);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static OutlineInputBorder borderStyle(Color borderColor) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(color: borderColor, width: 1.2));
  }

  static TextStyle textStyleBold(Color textColor, double fontSize) {
    return textStyle(
        textColor: textColor, fontWeight: FontWeight.bold, fontSize: fontSize);
  }

  static TextStyle textStyleNormal(Color textColor, double fontSize) {
    return textStyle(textColor: textColor, fontSize: fontSize);
  }

  static TextStyle textStyle(
      {required Color textColor,
      FontWeight? fontWeight = FontWeight.normal,
      FontStyle? fontStyle = FontStyle.normal,
      required double fontSize,
      TextDecoration? decoration = TextDecoration.none}) {
    return TextStyle(
        color: textColor,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        decoration: decoration);
  }

  static BoxDecoration boxDecoration(Color backgroundColor, Color shadowColor,
      Color borderColor, double radius) {
    BoxBorder? border;
    if (borderColor != Colors.transparent) {
      border = Border.all(color: borderColor, width: 2.0);
    }
    List<BoxShadow> boxShadow = [];
    if (shadowColor != Colors.transparent) {
      boxShadow = [
        BoxShadow(
            color: shadowColor.withOpacity(0.25),
            blurRadius: 2,
            offset: const Offset(0, 2)),
      ];
    }

    return BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: boxShadow);
  }

  static BoxDecoration circleDecoration(
      Color backgroundColor, Color shadowColor, Color borderColor) {
    List<BoxShadow> shadows = [];
    if (shadowColor != Colors.transparent) {
      shadows.add(BoxShadow(
          color: shadowColor.withOpacity(0.25),
          blurRadius: 2,
          offset: const Offset(0, 2)));
    }

    BoxBorder? border;
    if (borderColor != Colors.transparent) {
      border = Border.all(color: borderColor, width: 2.0);
    }

    return BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: border,
        boxShadow: shadows);
  }

  static Widget badge(int count, Color textColor, Color backgroundColor) {
    return Visibility(
        visible: count > 0,
        child: Container(
          width: 18,
          child: Center(
              child: Text("$count",
                  style: UI.textStyleBold(textColor, 10.0),
                  textAlign: TextAlign.center)),
          decoration:
              BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
        ));
  }
}
