import 'package:flutter/material.dart';
import 'package:iamhere/features/place/domain/entities/review_model.dart';
import 'section_widget.dart';
import 'package:iamhere/core/constants/host.dart';
import 'package:go_router/go_router.dart';

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
              (review) => _reviewItem(review, context),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _reviewItem(ReviewModel review, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
        ),
      ],
    ),
    child: GestureDetector(
      onTap: () {
        context.push('/user/${review.author.id}');
      },
      child:
        Column(
          children: [
            Text(review.text),
            const SizedBox(height: 12),
            Row(children: [
              ClipOval(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.network(
                    'http://$host/${review.author.photoPath.startsWith('/') ? review.author.photoPath.substring(1) : review.author.photoPath}',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 32),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(review.author.name, style: const TextStyle(fontSize: 12),),
            ],),
          ],
        ),
    ),
  );
}