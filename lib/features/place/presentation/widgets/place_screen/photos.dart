import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:iamhere/features/place/domain/entities/photo.dart';
import 'package:iamhere/shared/utils/photo.dart';
import 'section_widget.dart';

class PlacePhotos extends StatelessWidget {
  final List<PhotoModel> photos;
  final GlobalKey? photosKey;

  const PlacePhotos({super.key, required this.photos, this.photosKey});

  @override
  Widget build(BuildContext context) {
    final urls = photos.map((p) => photoUrl(p.path)).toList();

    return SliverToBoxAdapter(
      child: photos.isNotEmpty
          ? SectionWidget (
              title: 'Фотографии',
              key: photosKey,
              child: GridView.builder(
                padding: .zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        'gallery',
                        extra: {'urls': urls, 'initialIndex': index},
                      );
                    },
                    child: Image.network(
                      photoUrl(photos[index].path),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                  );
                },
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