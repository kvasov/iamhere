part of 'profile_bloc.dart';

enum ProfileStatus { idle, saving, success, error }

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileTokenExpired extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final String? userId;
  final String? login;
  final String? name;
  final String? email;
  final String? photoPath;
  final bool isAuth;
  final ProfileStatus status;

  ProfileLoaded({
    this.userId,
    this.login,
    this.name,
    this.email,
    this.photoPath,
    required this.isAuth,
    this.status = ProfileStatus.idle,
  });

  ProfileLoaded copyWith({
    String? userId,
    String? login,
    String? name,
    String? email,
    String? photoPath,
    bool? isAuth,
    ProfileStatus? status,
  }) {
    return ProfileLoaded(
      userId: userId ?? this.userId,
      login: login ?? this.login,
      name: name ?? this.name,
      email: email ?? this.email,
      photoPath: photoPath ?? this.photoPath,
      isAuth: isAuth ?? this.isAuth,
      status: status ?? this.status,
    );
  }
}

final class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure({required this.message});
}