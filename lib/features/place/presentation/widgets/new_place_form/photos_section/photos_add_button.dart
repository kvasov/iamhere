import 'package:flutter/material.dart';

class PhotosAddButton extends StatelessWidget {
  const PhotosAddButton({
    super.key,
    required this.showImageSourceDialog,
    required this.loading,
  });

  final VoidCallback showImageSourceDialog;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: loading ? null : () {
        showImageSourceDialog();
      },
      child: Text(loading ? 'Adding...' : 'Add Photo')
      );
  }
}