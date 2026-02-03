import 'package:flutter/material.dart';

import 'package:iamhere/features/place/domain/entities/photo.dart';
import 'package:iamhere/core/constants/host.dart';
import 'section_widget.dart';

class PlacePhotos extends StatelessWidget {
  final List<PhotoModel> photos;
  final GlobalKey? photosKey;

  const PlacePhotos({super.key, required this.photos, this.photosKey});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: photos.isNotEmpty
          ? SectionWidget (
              title: 'Фотографии',
              key: photosKey,
              child: Container(
                color: Color.fromARGB(255, 229, 229, 254),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...photos.map(
                      (photo) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Image.network(
                          'http://$host/${photo.path}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 48),
                        ),
                      ),
                    ),
                  ],
                )
              )
            )
          : Container(
              key: photosKey,
              color: Color.fromARGB(255, 229, 229, 254),
              padding: const EdgeInsets.all(32),
              child: const Center(child: Text('Фотографий нет')),
            ),
    );
  }
}