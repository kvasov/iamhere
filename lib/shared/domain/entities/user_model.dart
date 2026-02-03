import 'package:iamhere/features/place/data/models/user_dto.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? password;
  final String photoPath;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    required this.photoPath,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoPath: json['photoPath'] as String? ?? json['photo'] as String? ?? '',
    );
  }

  factory UserModel.fromDto(UserDTO dto) {
    return UserModel(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      photoPath: dto.photoPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'photoPath': photoPath,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, password: $password, photoPath: $photoPath)';
  }
}