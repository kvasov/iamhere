import 'package:iamhere/shared/domain/entities/user_model.dart';
class ReviewModel {
  final int id;
  final String text;
  final int rating;
  final UserModel author;

  ReviewModel({required this.id, required this.text, required this.rating, required this.author});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
    );
  }
}