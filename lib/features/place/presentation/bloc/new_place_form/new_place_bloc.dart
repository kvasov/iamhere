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
    on<NewPlacePhotoAdded>(_onPhotoAdded);
    on<NewPlacePhotoRemoved>(_onPhotoRemoved);
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

  void _onPhotoAdded(NewPlacePhotoAdded event, Emitter<NewPlaceState> emit) {
    final formData = _formDataFromState;
    if (formData == null) return;
    emit(NewPlaceEditing(formData.copyWith(photosLoading: true)));
    final currentFormData = _formDataFromState;
    if (currentFormData != null) {
      emit(NewPlaceEditing(currentFormData.copyWith(
        photos: [...currentFormData.photos, event.photo],
        photosLoading: false,
      )));
    }
  }

  void _onPhotoRemoved(NewPlacePhotoRemoved event, Emitter<NewPlaceState> emit) {
    final formData = _formDataFromState;
    if (formData != null) {
      emit(NewPlaceEditing(formData.copyWith(photos: formData.photos.where((photo) => photo != event.photo).toList())));
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
    if (formData.photos.isEmpty) {
      emit(NewPlaceFailure(
          message: 'At least one photo is required', formData: formData));
      return;
    }

    emit(NewPlaceLoading(formData));

    try {
      final result = await placesRepository.createPlace(
        name: formData.name,
        description: formData.description,
        country: formData.country,
        address: formData.address,
        latitude: formData.latitude!,
        longitude: formData.longitude!,
        photos: formData.photos,
      );
      if (result.isSuccess) {
        emit(NewPlaceSuccess(placeData: result.data ?? {}));
      } else {
        emit(NewPlaceFailure(message: result.error?.description ?? 'Failed to create place', formData: formData));
      }
    } catch (e) {
      debugPrint('NewPlaceBloc: error: $e');
      emit(NewPlaceFailure(
          message: 'An unexpected error occurred: $e', formData: formData));
    }
  }
}
