import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/photos_section/photos_add_button.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/photos_section/photos_source_modal.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:iamhere/features/place/presentation/bloc/new_place_form/new_place_bloc.dart';

class PhotosSection extends StatefulWidget {
  const PhotosSection({super.key});

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
        BlocBuilder<NewPlaceBloc, NewPlaceState>(
          builder: (context, state) {
            final photos = switch (state) {
              NewPlaceEditing(formData: final f) => f.photos,
              NewPlaceLoading(formData: final f) => f.photos,
              NewPlaceFailure(formData: final f) => f.photos,
              _ => <String>[],
            };
            if (photos.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 100,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Image.file(
                          width: double.infinity,
                          height: double.infinity,
                          File(photos[index]),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              context.read<NewPlaceBloc>().add(
                                    NewPlacePhotoRemoved(photos[index]),
                                  );
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 8),
              ],
            );
          },
        ),
        PhotosAddButton(showImageSourceDialog: _showImageSourceDialog),
      ],
    );
  }
}