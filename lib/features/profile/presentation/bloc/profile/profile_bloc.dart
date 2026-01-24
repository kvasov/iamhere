import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:iamhere/features/profile/data/repositories/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(ProfileInitial()) {
    on<ProfileLoadEvent>(_onProfileLoadEvent);
    on<ProfileSetIsAuthEvent>(_onProfileSetIsAuthEvent);
    on<ProfileSignOutEvent>(_onProfileSignOutEvent);
    on<ProfileUpdateEvent>(_onProfileUpdateEvent);
  }

  Future<void> _onProfileLoadEvent(ProfileLoadEvent event, Emitter<ProfileState> emit) async {
    // Сохраняем текущее состояние isAuth перед загрузкой
    final currentIsAuth = state is ProfileLoaded ? (state as ProfileLoaded).isAuth : false;
    emit(ProfileLoading());

    try {
      final userInfo = await userRepository.getUserInfo();
      debugPrint('🤍 ProfileBloc _onProfileLoadEvent - userInfo: $userInfo');
      emit(ProfileLoaded(
        isAuth: userInfo != null ? true : currentIsAuth,
        userId: userInfo?['id'].toString(),
        login: userInfo?['login'],
        name: userInfo?['name'],
        email: userInfo?['email'],
        photoPath: userInfo?['photo'],
      ));
    } catch (e) {
      // В случае ошибки сохраняем предыдущее состояние авторизации
      emit(ProfileLoaded(isAuth: currentIsAuth));
    }
  }

  Future<void> _onProfileSetIsAuthEvent(ProfileSetIsAuthEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoaded(isAuth: event.isAuth));
  }

  Future<void> _onProfileSignOutEvent(ProfileSignOutEvent event, Emitter<ProfileState> emit) async {
    final result = await userRepository.signOut();
    if (result.isSuccess) {
      emit(ProfileLoaded(isAuth: false));
    } else {
      emit(ProfileLoaded(isAuth: true));
    }
  }

  Future<void> _onProfileUpdateEvent(ProfileUpdateEvent event, Emitter<ProfileState> emit) async {
    final current = state is ProfileLoaded ? (state as ProfileLoaded) : null;
    emit(current?.copyWith(status: ProfileStatus.saving) ?? ProfileLoading());

    final result = await userRepository.updateUserInfo(
      userId: current?.userId ?? '',
      name: event.name,
      password: event.password,
      passwordConfirm: event.passwordConfirm,
      photoPath: event.photoPath,
    );

    if (result.isSuccess) {
      String photoPath = result.data?['photoPath'];

      emit(current?.copyWith(
        name: event.name,
        photoPath: photoPath,
        status: ProfileStatus.success
        ) ?? ProfileLoading()
      );
    } else {
      emit(current?.copyWith(
        status: ProfileStatus.error,
      ) ?? ProfileLoading());
    }
  }
}
