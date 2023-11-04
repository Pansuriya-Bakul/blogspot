import 'package:blog/helper/ui.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final String text;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final String hintText;
  final Decoration? decoration;

  const SearchTextField({
    Key? key,
    required this.text,
    required this.hintText,
    required this.onChanged,
    this.onFieldSubmitted,
    this.decoration,
  }) : super(key: key);

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Colors.black, fontSize: 15.0);
    const styleHint = TextStyle(color: Colors.grey, fontSize: 15.0);
    final style = widget.text.isEmpty ? styleHint : styleActive;
    final defaultDecoration =
        UI.boxDecoration(Colors.white, Colors.black, Colors.transparent, 10.0);

    return Container(
      decoration: widget.decoration ?? defaultDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      alignment: Alignment.centerLeft,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: style.color, size: 20.0),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color, size: 20.0),
                  onTap: () {
                    controller.clear();
                    widget.onChanged?.call("");
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        cursorColor: Colors.black,
        style: style,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
      ),
    );
  }
}
