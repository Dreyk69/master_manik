import 'package:flutter/material.dart';

class StylesTextField extends InputDecoration {
  const StylesTextField({
    super.suffixIcon,
    super.prefixIcon,
    Color super.prefixIconColor = const Color.fromARGB(255, 199, 100, 216),
    InputBorder super.enabledBorder = const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.transparent)),
    bool isCollapsed = true,
    Color super.fillColor = const Color.fromARGB(255, 223, 223, 223),
    bool super.filled = true,
    super.hintText,
    TextStyle super.hintStyle = const TextStyle(color: Colors.black, fontSize: 15),
    super.errorText,
    int super.errorMaxLines = 3,
    EdgeInsetsGeometry super.contentPadding =
        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
  });
}
