import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/photos_section/photos_add_button.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/photos_section/photos_source_modal.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/photos_section/photos_grid.dart';
import 'package:image_picker/image_picker.dart';

import 'package:iamhere/features/place/presentation/bloc/new_place_form/new_place_bloc.dart';

class PhotosSection extends StatefulWidget {
  const PhotosSection({
    super.key,
    required this.state,
  });

  final NewPlaceState state;

  @override
  State<PhotosSection> createState() => _PhotosSectionState();
}

class _PhotosSectionState extends State<PhotosSection> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> images = await _imagePicker.pickMultiImage(
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 85,
        );
        if (images.isNotEmpty && mounted) {
          for (final image in images) {
            context.read<NewPlaceBloc>().add(NewPlacePhotoAdded(image.path));
          }
        }
      } else {
        final XFile? image = await _imagePicker.pickImage(
          source: source,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 85,
        );
        if (image != null && mounted) {
          context.read<NewPlaceBloc>().add(NewPlacePhotoAdded(image.path));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при выборе фото: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return PhotosSourceModal(pickImage: _pickImage);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loading = switch (widget.state) {
      NewPlaceEditing(formData: final f) => f.photosLoading,
      NewPlaceLoading(formData: final f) => f.photosLoading,
      NewPlaceFailure(formData: final f) => f.photosLoading,
      _ => false,
    };
    final photos = switch (widget.state) {
      NewPlaceEditing(formData: final f) => f.photos,
      NewPlaceLoading(formData: final f) => f.photos,
      NewPlaceFailure(formData: final f) => f.photos,
      _ => <String>[],
    };
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisAlignment: .start,
      children: [
        Text(
          'Photos',
          style: TextStyle(
            fontSize: 16,
            fontWeight: .normal
          ),
          textAlign: .left,
        ),
        SizedBox(height: 8),
        PhotosGrid(photos: photos, bloc: context.read<NewPlaceBloc>()),
        PhotosAddButton(showImageSourceDialog: _showImageSourceDialog, loading: loading),
      ],
    );
  }
}