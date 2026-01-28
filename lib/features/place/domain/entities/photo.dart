import 'package:iamhere/features/place/data/models/photo_dto.dart';

class PhotoModel {
  final int id;
  final String path;

  PhotoModel({
    required this.id,
    required this.path,
  });

  // factory PhotoModel.fromJson(Map<String, dynamic> json) {
  //   return PhotoModel(
  //     id: json['id'] as int,
  //     path: json['path'] as String,
  //   );
  // }

  factory PhotoModel.fromDto(PhotoDTO dto) {
    return PhotoModel(
      id: dto.id,
      path: dto.path,
    );
  }
}