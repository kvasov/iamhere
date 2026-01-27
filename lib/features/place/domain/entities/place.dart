import 'package:iamhere/shared/domain/entities/user_model.dart';
import 'package:iamhere/features/place/data/models/place_dto.dart';

class PlaceModel {
  final int id;
  final double latitude;
  final double longitude;
  final String country;
  final String address;
  final String name;
  final UserModel? author;

  PlaceModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.address,
    required this.name,
    this.author,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      country: json['country'] as String,
      address: json['address'] as String,
      name: json['name'] as String,
      author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
    );
  }

  factory PlaceModel.fromDto(PlaceDTO dto) {
    return PlaceModel(
      id: dto.id,
      latitude: dto.latitude,
      longitude: dto.longitude,
      country: dto.country,
      address: dto.address,
      name: dto.name,
      author: UserModel.fromDto(dto.author),
    );
  }
}