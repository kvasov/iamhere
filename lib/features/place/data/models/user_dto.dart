class UserDTO {
  final int id;
  final String name;
  final String email;
  final String photoPath;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.photoPath,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      photoPath: json['photoPath'] as String,
    );
  }
}