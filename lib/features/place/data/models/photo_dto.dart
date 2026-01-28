class PhotoDTO {
  final int id;
  final String path;

  PhotoDTO({
    required this.id,
    required this.path,
  });

  factory PhotoDTO.fromJson(Map<String, dynamic> json) {
    return PhotoDTO(
      id: json['id'] as int,
      path: json['path'] as String,
    );
  }
}