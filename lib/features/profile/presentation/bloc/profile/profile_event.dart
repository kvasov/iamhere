part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class ProfileLoadEvent extends ProfileEvent {}

class ProfileSetIsAuthEvent extends ProfileEvent {
  final bool isAuth;

  ProfileSetIsAuthEvent({required this.isAuth});
}