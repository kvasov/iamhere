import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:iamhere/features/place/domain/entities/new_place_form_data.dart';
import 'package:iamhere/features/place/data/repositories/places_repository_impl.dart';
import 'package:meta/meta.dart';

part 'new_place_event.dart';
part 'new_place_state.dart';

class NewPlaceBloc extends Bloc<NewPlaceEvent, NewPlaceState> {
  final PlacesRepository placesRepository;

  NewPlaceBloc({required this.placesRepository})
      : super(NewPlaceEditing(const NewPlaceFormData())) {
    on<NewPlaceNameChanged>(_onNameChanged);
    on<NewPlaceDescriptionChanged>(_onDescriptionChanged);
    on<NewPlaceCountryChanged>(_onCountryChanged);
    on<NewPlaceAddressChanged>(_onAddressChanged);
    on<NewPlaceCoordinatesChanged>(_onCoordinatesChanged);
    on<NewPlaceSubmitted>(_onNewPlaceSubmitted);
  }

  void _onNameChanged(NewPlaceNameChanged event, Emitter<NewPlaceState> emit) {
    final formData = _formDataFromState;
    if (formData != null) {
      emit(NewPlaceEditing(formData.copyWith(name: event.name)));
    }
  }

  void _onDescriptionChanged(
      NewPlaceDescriptionChanged event, Emitter<NewPlaceState> emit) {
    final formData = _formDataFromState;
    if (formData != null) {
      emit(NewPlaceEditing(formData.copyWith(description: event.description)));
    }
  }

  void _onCountryChanged(
      NewPlaceCountryChanged event, Emitter<NewPlaceState> emit) {
    final formData = _formDataFromState;
    if (formData != null) {
      emit(NewPlaceEditing(formData.copyWith(country: event.country)));
    }
  }

  void _onAddressChanged(
      NewPlaceAddressChanged event, Emitter<NewPlaceState> emit) {
    final formData = _formDataFromState;
    if (formData != null) {
      emit(NewPlaceEditing(formData.copyWith(address: event.address)));
    }
  }

  void _onCoordinatesChanged(
      NewPlaceCoordinatesChanged event, Emitter<NewPlaceState> emit) {
    final formData = _formDataFromState;
    if (formData != null) {
      emit(NewPlaceEditing(formData.copyWith(
        latitude: event.latitude,
        longitude: event.longitude,
      )));
    }
  }

  NewPlaceFormData? get _formDataFromState {
    return switch (state) {
      NewPlaceEditing(formData: final f) => f,
      NewPlaceLoading(formData: final f) => f,
      NewPlaceFailure(formData: final f) => f,
      NewPlaceSuccess() => null,
    };
  }

  Future<void> _onNewPlaceSubmitted(
    NewPlaceSubmitted event,
    Emitter<NewPlaceState> emit,
  ) async {
    final formData = _formDataFromState;
    if (formData == null) return;

    if (formData.name.isEmpty) {
      emit(NewPlaceFailure(
          message: 'Name is required', formData: formData));
      return;
    }
    if (formData.address.isEmpty) {
      emit(NewPlaceFailure(
          message: 'Address is required', formData: formData));
      return;
    }
    if (formData.country.isEmpty) {
      emit(NewPlaceFailure(
          message: 'Country is required', formData: formData));
      return;
    }
    if (formData.latitude == null || formData.longitude == null) {
      debugPrint('❌❌❌ NewPlaceBloc: Coordinates are required');
      emit(NewPlaceFailure(
          message: 'Coordinates are required', formData: formData));
      return;
    }

    emit(NewPlaceLoading(formData));

    try {
      // TODO: вызвать userRepository / placesRepository для создания места
      // final result = await ...;
      // if (result.isSuccess) emit(NewPlaceSuccess(placeData: result.data!));
      // else emit(NewPlaceFailure(message: ..., formData: formData));
      debugPrint('🔍 NewPlaceBloc: FormData: $formData');
      emit(NewPlaceEditing(formData));
    } catch (e) {
      debugPrint('NewPlaceBloc: error: $e');
      emit(NewPlaceFailure(
          message: 'An unexpected error occurred: $e', formData: formData));
    }
  }
}
