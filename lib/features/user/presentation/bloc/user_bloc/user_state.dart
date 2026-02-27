part of 'user_bloc.dart';

@immutable
sealed class UserState {}

/// Начальное состояние загрузки пользователя
final class UserInitial extends UserState {}

/// Состояние загрузки пользователя
final class UserLoading extends UserState {}

/// Состояние успешной загрузки пользователя
final class UserSuccess extends UserState {
  final Map<String, dynamic> userData;

  UserSuccess({required this.userData});
}

/// Состояние ошибки загрузки пользователя
final class UserFailure extends UserState {
  final String message;

  UserFailure({required this.message});
}