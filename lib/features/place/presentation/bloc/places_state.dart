part of 'places_bloc.dart';

abstract class PlacesState {}

final class PlacesInitial extends PlacesState {}

final class PlacesLoading extends PlacesState {}

final class PlacesLoaded extends PlacesState {
  final List<Place> items;

  PlacesLoaded({required this.items});
}

final class PlacesError extends PlacesState {
  final String message;

  PlacesError({required this.message});
}



final class PlaceLoading extends PlacesState {}

final class PlaceLoaded extends PlacesState {
  final Place place;

  PlaceLoaded({required this.place});
}

final class PlaceError extends PlacesState {
  final String message;

  PlaceError({required this.message});
}