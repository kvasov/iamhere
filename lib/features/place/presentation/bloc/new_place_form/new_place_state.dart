part of 'new_place_bloc.dart';

@immutable
sealed class NewPlaceState {}

/// Состояние редактирования — содержит текущие данные формы
final class NewPlaceEditing extends NewPlaceState {
  final NewPlaceFormData formData;

  NewPlaceEditing(this.formData);
}

/// Состояние загрузки при отправке
final class NewPlaceLoading extends NewPlaceState {
  final NewPlaceFormData formData;

  NewPlaceLoading(this.formData);
}

/// Успешное создание места
final class NewPlaceSuccess extends NewPlaceState {
  final Map<String, dynamic> placeData;

  NewPlaceSuccess({required this.placeData});
}

/// Ошибка создания места
final class NewPlaceFailure extends NewPlaceState {
  final String message;
  final NewPlaceFormData formData;

  NewPlaceFailure({required this.message, required this.formData});
}
