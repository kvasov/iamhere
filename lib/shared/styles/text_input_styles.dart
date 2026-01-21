import 'package:flutter/material.dart';

InputDecoration textInputDecoration(
  String labelText,
  IconData prefixIcon, {
  double? fontSize,
  TextStyle? labelStyle,
  EdgeInsetsGeometry? contentPadding,
  double? height,
}) {
  return InputDecoration(
    hintText: null,
    labelText: labelText,
    labelStyle: TextStyle(fontSize: 12.0),
    contentPadding: .symmetric(horizontal: 12.0, vertical: 14.0),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade500),
    ),
    filled: true,
    fillColor: Colors.white,
    prefixIcon: Icon(prefixIcon),
    constraints: BoxConstraints(minHeight: 60),

  );
}