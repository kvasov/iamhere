part of 'places_bloc.dart';

abstract class PlacesEvent {}

final class PlacesLoadEvent extends PlacesEvent {}

final class PlacesClearEvent extends PlacesEvent {}

final class PlaceLoadEvent extends PlacesEvent {
  final String placeId;

  PlaceLoadEvent({required this.placeId});
}