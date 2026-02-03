import 'user_dto.dart';
import 'package:iamhere/features/place/data/models/photo_dto.dart';
import 'package:iamhere/features/place/domain/entities/review_model.dart';

class PlaceDTO {
  final int id;
  final double latitude;
  final double longitude;
  final String country;
  final String address;
  final String name;
  final UserDTO author;
  final String? imageUrl;
  final List<PhotoDTO>? photos;
  final String? description;
  final List<ReviewModel>? reviews;
  PlaceDTO({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.address,
    required this.name,
    required this.author,
    this.imageUrl,
    this.photos,
    this.description,
    this.reviews,
  });

  factory PlaceDTO.fromJson(Map<String, dynamic> json) {
    final photosList = json['photos'] != null
      ? (json['photos'] as List).map((photo) => PhotoDTO.fromJson(photo as Map<String, dynamic>)).toList()
      : null;
    // debugPrint('photosList 💚🤍: $photosList');
    final reviewsList = json['reviews'] != null
      ? (json['reviews'] as List).map((review) => ReviewModel.fromJson(review as Map<String, dynamic>)).toList()
      : null;
    return PlaceDTO(
      id: json['id'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      country: json['country'] as String,
      address: json['address'] as String,
      name: json['name'] as String,
      author: UserDTO.fromJson(json['author'] as Map<String, dynamic>),
      imageUrl: json['firstPhoto'] as String?,
      photos: photosList,
      description: json['description'] as String?,
      reviews: reviewsList,
    );
  }
}