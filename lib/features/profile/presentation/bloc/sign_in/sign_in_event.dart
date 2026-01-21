part of 'sign_in_bloc.dart';

@immutable
sealed class SignInEvent {}

/// Событие для входа пользователя
final class SignInSubmitted extends SignInEvent {
  final String login;
  final String password;

  SignInSubmitted({
    required this.login,
    required this.password,
  });
}

/// Событие проверки наличия токена в БД при запуске приложения
final class SignInCheckTokenEvent extends SignInEvent {}