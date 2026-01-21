class Place {
  final int id;
  final double latitude;
  final double longitude;
  final String country;
  final String address;
  final String name;

  Place({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.address,
    required this.name});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      country: json['country'] as String,
      address: json['address'] as String,
      name: json['name'] as String,
    );
  }
}