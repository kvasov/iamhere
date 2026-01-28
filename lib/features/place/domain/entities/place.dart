import 'package:iamhere/shared/domain/entities/user_model.dart';
import 'package:iamhere/features/place/data/models/place_dto.dart';
import 'package:iamhere/features/place/domain/entities/photo.dart';

class PlaceModel {
  final int id;
  final double latitude;
  final double longitude;
  final String country;
  final String address;
  final String name;
  final UserModel? author;
  final String? imageUrl;
  final List<PhotoModel>? photos;

  PlaceModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.address,
    required this.name,
    this.author,
    this.imageUrl,
    this.photos,
  });

  factory PlaceModel.fromDto(PlaceDTO dto) {
    return PlaceModel(
      id: dto.id,
      latitude: dto.latitude,
      longitude: dto.longitude,
      country: dto.country,
      address: dto.address,
      name: dto.name,
      author: UserModel.fromDto(dto.author),
      imageUrl: dto.imageUrl,
      photos: dto.photos != null
        ? (dto.photos as List).map((photo) => PhotoModel.fromDto(photo)).toList()
        : null,
    );
  }
}