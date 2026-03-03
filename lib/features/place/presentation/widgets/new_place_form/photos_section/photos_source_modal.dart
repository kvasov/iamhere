import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotosSourceModal extends StatelessWidget {
  const PhotosSourceModal({super.key, required this.pickImage});

  final void Function(ImageSource source) pickImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Выбрать из галереи'),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Сделать фото'),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }
}