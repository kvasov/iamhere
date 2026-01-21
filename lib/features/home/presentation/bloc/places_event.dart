part of 'places_bloc.dart';

abstract class PlacesEvent {}

final class PlacesLoadEvent extends PlacesEvent {}

final class PlacesClearEvent extends PlacesEvent {}