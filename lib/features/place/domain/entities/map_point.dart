import 'package:equatable/equatable.dart';
import 'package:iamhere/features/place/domain/entities/place.dart';

/// Модель точки на карте
class MapPoint extends Equatable {
  const MapPoint({
    required this.latitude,
    required this.longitude,
  });

  /// Широта
  final double latitude;

  /// Долгота
  final double longitude;

  factory MapPoint.fromPlace(PlaceModel place) {
    return MapPoint(
      latitude: place.latitude,
      longitude: place.longitude,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude];
}