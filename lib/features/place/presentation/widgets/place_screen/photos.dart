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
                      debugPrint(photos[index].path);
                    },
                    child: Image.network(
                      'http://$host/${photos[index].path}',
                      fit: BoxFit.cover,
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