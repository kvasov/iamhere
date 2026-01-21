part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}

/// Событие для регистрации пользователя
final class SignUpSubmitted extends SignUpEvent {
  final String name;
  final String login;
  final String email;
  final String password;
  final String passwordConfirm;

  SignUpSubmitted({
    required this.name,
    required this.login,
    required this.email,
    required this.password,
    required this.passwordConfirm,
  });
}
