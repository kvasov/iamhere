import 'package:flutter/material.dart';

class PhotosAddButton extends StatelessWidget {
  const PhotosAddButton({
    super.key, required this.showImageSourceDialog
  });

  final VoidCallback showImageSourceDialog;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showImageSourceDialog();
      },
      child: Text('Add Photo')
      );
  }
}