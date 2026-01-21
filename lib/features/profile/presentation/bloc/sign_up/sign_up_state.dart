part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpState {}

/// Начальное состояние регистрации
final class SignUpInitial extends SignUpState {}

/// Состояние загрузки регистрации
final class SignUpLoading extends SignUpState {}

/// Состояние успешной регистрации
final class SignUpSuccess extends SignUpState {
  final Map<String, dynamic> userData;

  SignUpSuccess({required this.userData});
}

/// Состояние ошибки регистрации
final class SignUpFailure extends SignUpState {
  final String message;

  SignUpFailure({required this.message});
}
