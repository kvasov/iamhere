import 'package:flutter/material.dart';
import 'section_widget.dart';

class PlaceDescription extends StatelessWidget {
  final String description;
  final GlobalKey? descriptionKey;

  PlaceDescription({super.key, required this.description, this.descriptionKey});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SectionWidget(
        key: descriptionKey,
        title: 'Описание',
        child: Text(description),
      ),
    );
  }
}