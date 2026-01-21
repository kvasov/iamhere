part of 'sign_in_bloc.dart';

@immutable
sealed class SignInState {}

/// Начальное состояние входа
final class SignInInitial extends SignInState {}

/// Состояние загрузки входа
final class SignInLoading extends SignInState {}

/// Состояние успешной входа
final class SignInSuccess extends SignInState {
  final Map<String, dynamic> userData;

  SignInSuccess({required this.userData});
}

/// Состояние ошибки входа
final class SignInFailure extends SignInState {
  final String message;

  SignInFailure({required this.message});
}
