part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final String? userId;
  final String? login;
  final String? name;
  final String? email;
  final String? photoPath;
  final bool isAuth;

  ProfileLoaded({this.userId, this.login, this.name, this.email, this.photoPath, required this.isAuth });
}

final class ProfileUpdateSuccess extends ProfileState {}

final class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure({required this.message});
}