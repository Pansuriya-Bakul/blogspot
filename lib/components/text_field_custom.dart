import 'package:blog/helper/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      this.restorationId,
      this.controller,
      this.cursorColor,
      this.text,
      this.textSize,
      this.textColor,
      this.maxLength,
      this.maxLines,
      this.hintText,
      this.hintColor,
      this.errorText,
      this.errorColor,
      this.hideText,
      this.enableSuggestions,
      this.enabled,
      this.showCursor,
      this.keyboardType,
      this.textInputAction,
      this.formatter,
      this.focusNode,
      this.prefix,
      this.prefixIcon,
      this.suffix,
      this.suffixIcon,
      this.onFieldSubmitted,
      this.onValueChanged,
      this.onValueSaved,
      this.onFieldTap})
      : super(key: key);

  final String? restorationId;
  final TextEditingController? controller;
  final Color? cursorColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? errorColor;
  final String? text;
  final double? textSize;
  final int? maxLength;
  final int? maxLines;
  final String? hintText;
  final String? errorText;
  final bool? hideText;
  final bool? enableSuggestions;
  final bool? enabled;
  final bool? showCursor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? formatter;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onValueChanged;
  final FormFieldSetter<String>? onValueSaved;
  final GestureTapCallback? onFieldTap;

  final prefixIconConstraints =
      const BoxConstraints(minWidth: 32.0, minHeight: 32.0, maxHeight: 32.0);
  final suffixIconConstraints =
      const BoxConstraints(minWidth: 32.0, minHeight: 32.0, maxHeight: 32.0);

  static dismissFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static nextFocus(BuildContext context, FocusNode? focus) {
    FocusScope.of(context).requestFocus(focus);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        restorationId: restorationId,
        controller: controller,
        inputFormatters: formatter,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        style: UI.textStyleNormal(textColor ?? Colors.white, textSize ?? 15.0),
        textCapitalization: TextCapitalization.none,
        cursorColor: cursorColor ?? Colors.white,
        textAlign: TextAlign.start,
        cursorWidth: 2.0,
        showCursor: showCursor ?? true,
        enableSuggestions: enableSuggestions ?? true,
        textAlignVertical: TextAlignVertical.center,
        focusNode: focusNode,
        obscureText: hideText ?? false,
        maxLength: maxLength,
        maxLines: maxLines ?? 1,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        onSaved: onValueSaved,
        onChanged: onValueChanged,
        onTap: onFieldTap,
        enabled: enabled,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.all(0.0),
          fillColor: Colors.transparent,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          border: InputBorder.none,
          prefix: prefix,
          prefixIcon: prefixIcon,
          suffix: suffix,
          suffixIcon: suffixIcon,
          prefixIconConstraints: prefixIconConstraints,
          suffixIconConstraints: suffixIconConstraints,
          hintText: hintText,
          hintStyle:
              UI.textStyleNormal(hintColor ?? Colors.grey, textSize ?? 15.0),
          errorText: errorText,
          errorMaxLines: 2,
          errorStyle: UI.textStyleNormal(errorColor ?? Colors.red, 12.0),
        ));
  }
}
