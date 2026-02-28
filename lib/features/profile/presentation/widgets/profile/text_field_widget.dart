import 'package:flutter/material.dart';
import 'package:iamhere/shared/extensions/widget_animate_extensions.dart';
import 'package:iamhere/shared/styles/text_input_styles.dart';

class TextFieldWidget extends StatefulWidget {
  final int staggerIndex;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.validator,
    required this.staggerIndex,
    this.onChanged,
    this.obscureText = false,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final showHint = !_focusNode.hasFocus;
    return TextFormField(
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      decoration: textInputDecoration(
        showHint ? widget.hintText : null,
        widget.prefixIcon,
      ),
      controller: widget.controller,
      validator: widget.validator,
      onChanged: widget.onChanged,
    ).formFieldAnimate(staggerIndex: widget.staggerIndex);
  }
}