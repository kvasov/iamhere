part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

/// Событие для загрузки информации о пользователе
final class UserLoadEvent extends UserEvent {
  final int userId;

  UserLoadEvent({
    required this.userId,
  });
}