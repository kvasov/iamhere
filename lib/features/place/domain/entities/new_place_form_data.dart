import 'package:equatable/equatable.dart';

/// Маркер «значение не передано» для copyWith.
/// Позволяет отличить: не передано (сохранить) / передано null (очистить) / передано значение (установить).
const _keep = Object();

/// Хранилище полей формы создания места.
/// Заполняется из разных событий, при редактировании поля — обновляется через copyWith.
class NewPlaceFormData extends Equatable {
  const NewPlaceFormData({
    this.name = '',
    this.description = '',
    this.country = '',
    this.address = '',
    this.latitude,
    this.longitude,
  });

  final String name;
  final String description;
  final String country;
  final String address;
  final double? latitude;
  final double? longitude;

  NewPlaceFormData copyWith({
    String? name,
    String? description,
    String? country,
    String? address,
    Object? latitude = _keep,
    Object? longitude = _keep,
  }) {
    return NewPlaceFormData(
      name: name ?? this.name,
      description: description ?? this.description,
      country: country ?? this.country,
      address: address ?? this.address,
      latitude: identical(latitude, _keep) ? this.latitude : latitude as double?,
      longitude: identical(longitude, _keep) ? this.longitude : longitude as double?,
    );
  }

  static NewPlaceFormData get initial => const NewPlaceFormData();

  @override
  List<Object?> get props => [name, description, country, address, latitude, longitude];
}
