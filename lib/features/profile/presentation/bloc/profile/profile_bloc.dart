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
    final currentUserInfo = state is ProfileLoaded ? (state as ProfileLoaded) : null;
    emit(ProfileLoading());

    final result = await userRepository.updateUserInfo(
      userId: currentUserInfo?.userId ?? '',
      name: event.name,
      password: event.password,
      passwordConfirm: event.passwordConfirm,
      photoPath: event.photoPath,
    );

    if (result.isSuccess) {
      debugPrint('🤍 ProfileBloc _onProfileUpdateEvent - result.data: ${result.data}');
      debugPrint('🤍 ProfileBloc _onProfileUpdateEvent - result.data тип: ${result.data?.runtimeType}');

      if (result.data is Map) {
        debugPrint('🤍 ProfileBloc _onProfileUpdateEvent - ключи в result.data: ${(result.data as Map).keys.toList()}');
        if (result.data?['user'] is Map) {
          debugPrint('🤍 ProfileBloc _onProfileUpdateEvent - ключи в result.data.user: ${(result.data?['user'] as Map).keys.toList()}');
        }
      }

      // Проверяем разные возможные структуры ответа
      String photoPath = result.data?['photoPath'];

      emit(ProfileUpdateSuccess());
      emit(ProfileLoaded(
        isAuth: true,
        userId: currentUserInfo?.userId,
        login: currentUserInfo?.login,
        email: currentUserInfo?.email,
        name: event.name,
        photoPath: photoPath,
      ));
    } else {
      emit(ProfileFailure(message: result.error?.description ?? 'Update failed'));
    }
  }
}
