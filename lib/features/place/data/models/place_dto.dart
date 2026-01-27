import 'user_dto.dart';

class PlaceDTO {
  final int id;
  final double latitude;
  final double longitude;
  final String country;
  final String address;
  final String name;
  final UserDTO author;
  final String? imageUrl;

  PlaceDTO({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.address,
    required this.name,
    required this.author,
    this.imageUrl,
  });

  factory PlaceDTO.fromJson(Map<String, dynamic> json) {
    return PlaceDTO(
      id: json['id'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      country: json['country'] as String,
      address: json['address'] as String,
      name: json['name'] as String,
      author: UserDTO.fromJson(json['author'] as Map<String, dynamic>),
      imageUrl: json['firstPhoto'] as String?,
    );
  }
}