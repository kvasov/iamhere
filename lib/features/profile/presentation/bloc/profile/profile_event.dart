part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class ProfileLoadEvent extends ProfileEvent {}

class ProfileSetIsAuthEvent extends ProfileEvent {
  final bool isAuth;

  ProfileSetIsAuthEvent({required this.isAuth});
}

class ProfileSignOutEvent extends ProfileEvent {}

class ProfileTokenDeleteEvent extends ProfileEvent {}

class ProfileUpdateEvent extends ProfileEvent {
  final String name;
  final String password;
  final String passwordConfirm;
  final String? photoPath;

  ProfileUpdateEvent({
    required this.name,
    required this.password,
    required this.passwordConfirm,
    this.photoPath,
  });
}