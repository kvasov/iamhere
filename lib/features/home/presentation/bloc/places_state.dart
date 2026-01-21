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