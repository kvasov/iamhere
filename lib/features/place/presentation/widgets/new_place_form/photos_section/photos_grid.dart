import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iamhere/features/place/presentation/bloc/new_place_form/new_place_bloc.dart';
import 'package:iamhere/shared/widgets/explodable_widget.dart';

class PhotosGrid extends StatelessWidget {
  const PhotosGrid({
    super.key,
    required this.photos,
    required this.bloc,
  });

  final List<String> photos;
  final NewPlaceBloc bloc;

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) return const Text('No photos');
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        GridView.builder(
          padding: .zero,
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
            return ExplodableWidget(
              key: ValueKey(photos[index]),
              onExploded: () => bloc.add(NewPlacePhotoRemoved(photos[index])),
              builder: (triggerExplode) => Stack(
                children: [
                  Image.file(
                    width: .infinity,
                    height: .infinity,
                    File(photos[index]),
                    fit: .cover,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: triggerExplode,
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 8),
      ],
    );
  }
}