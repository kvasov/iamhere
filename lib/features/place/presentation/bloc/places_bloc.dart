import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:iamhere/features/place/data/repositories/places_repository_impl.dart';
import 'package:iamhere/features/place/data/models/place_dto.dart';
import 'package:iamhere/features/place/domain/entities/place.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final PlacesRepository placesRepository;

  PlacesBloc({required this.placesRepository}) : super(PlacesInitial()) {
    on<PlacesLoadEvent>(_onPlacesLoadEvent);
    on<PlacesClearEvent>(_onPlacesClearEvent);
    on<PlaceLoadEvent>(_onPlaceLoadEvent);
  }

  Future<void> _onPlacesLoadEvent(
    PlacesLoadEvent event,
    Emitter<PlacesState> emit,
  ) async {
    emit(PlacesLoading());

    final result = await placesRepository.getPlaces();

    if (result.isSuccess) {
      emit(PlacesLoaded(items: result.data!));
    } else {
      debugPrint('error: ${result.error!.description}');
      emit(PlacesError(message: result.error!.description));
    }
  }

  Future<void> _onPlacesClearEvent(
    PlacesClearEvent event,
    Emitter<PlacesState> emit,
  ) async {
    emit(PlacesLoaded(items: []));
  }

  Future<void> _onPlaceLoadEvent(
    PlaceLoadEvent event,
    Emitter<PlacesState> emit,
  ) async {
    emit(PlaceLoading());

    final result = await placesRepository.getPlace(event.placeId);

    if (result.isSuccess) {
      emit(PlaceLoaded(place: result.data!));
    } else {
      emit(PlaceError(message: result.error!.description));
    }
  }
}
