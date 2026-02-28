part of 'new_place_bloc.dart';

@immutable
sealed class NewPlaceEvent {}

final class NewPlaceNameChanged extends NewPlaceEvent {
  final String name;
  NewPlaceNameChanged(this.name);
}

final class NewPlaceDescriptionChanged extends NewPlaceEvent {
  final String description;
  NewPlaceDescriptionChanged(this.description);
}

final class NewPlaceCountryChanged extends NewPlaceEvent {
  final String country;
  NewPlaceCountryChanged(this.country);
}

final class NewPlaceAddressChanged extends NewPlaceEvent {
  final String address;
  NewPlaceAddressChanged(this.address);
}

final class NewPlaceCoordinatesChanged extends NewPlaceEvent {
  final double? latitude;
  final double? longitude;
  NewPlaceCoordinatesChanged({this.latitude, this.longitude});
}

/// Отправка формы. Данные берутся из текущего состояния bloc.
final class NewPlaceSubmitted extends NewPlaceEvent {}
