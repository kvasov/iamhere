import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:iamhere/features/home/data/repositories/todo_repository_impl.dart';
import 'package:iamhere/features/home/data/models/place.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final PlacesRepository placesRepository;

  PlacesBloc({required this.placesRepository}) : super(PlacesInitial()) {
    on<PlacesLoadEvent>(_onPlacesLoadEvent);
    on<PlacesClearEvent>(_onPlacesClearEvent);
  }

  Future<void> _onPlacesLoadEvent(
    PlacesLoadEvent event,
    Emitter<PlacesState> emit,
  ) async {
    emit(PlacesLoading());

    final result = await placesRepository.getTodos();

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
}
