import 'package:flutter/material.dart';
import 'package:iamhere/features/place/domain/entities/review_model.dart';
import 'section_widget.dart';

class PlaceReviews extends StatelessWidget {
  final List<ReviewModel> reviews;
  final GlobalKey? reviewsKey;

  const PlaceReviews({super.key, required this.reviews, this.reviewsKey});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SectionWidget(
        title: 'Отзывы',
        key: reviewsKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...reviews.map(
              (review) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  review.text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}