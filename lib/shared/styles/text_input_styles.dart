import 'package:flutter/material.dart';

/// Placeholder при фокусе скрывается.
/// [hintText] — показывается когда нет фокуса
InputDecoration textInputDecoration(
  String? hintText,
  IconData prefixIcon, {
  EdgeInsetsGeometry? contentPadding,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
    contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(30),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(30),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade500),
      borderRadius: BorderRadius.circular(30),
    ),
    filled: true,
    fillColor: Colors.white,
    prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600),
    constraints: const BoxConstraints(minHeight: 60),
  );
}