import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:iamhere/core/di/injection_container.dart';
import 'package:iamhere/shared/data/user/repositories/user_repository.dart';
import 'package:iamhere/shared/data/fcm/fcm_local_datasource.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(ProfileInitial()) {
    on<ProfileLoadEvent>(_onProfileLoadEvent);
    on<ProfileSetIsAuthEvent>(_onProfileSetIsAuthEvent);
    on<ProfileSignOutEvent>(_onProfileSignOutEvent);
    on<ProfileUpdateEvent>(_onProfileUpdateEvent);
    on<ProfileTokenDeleteEvent>(_onProfileTokenDeleteEvent);
  }

  Future<void> _onProfileLoadEvent(ProfileLoadEvent event, Emitter<ProfileState> emit) async {
    debugPrint('🤍⚡️ ProfileBloc _onProfileLoadEvent');
    // Сохраняем текущее состояние isAuth перед загрузкой
    emit(ProfileLoading());

    try {
      final userInfo = await userRepository.getUserInfo();

      if (userInfo?['error'] != null) {
        debugPrint('‼️‼️‼️ ProfileBloc _onProfileLoadEvent error: ${userInfo?['error']}');
        // Эмитим ProfileTokenExpired только если пользователь ещё не был помечен как авторизованный
        // (иначе после успешного входа старый/задержанный ответ API мог бы перезаписать состояние)
        final errorStr = userInfo!['error'].toString();
        final isTokenExpiredError = errorStr.contains('Token is expired');
        if (isTokenExpiredError) {
          emit(ProfileTokenExpired());
        }
        return;
      } else {
        try {
          debugPrint('💚💚💚 ProfileBloc _onProfileLoadEvent updateUserFcmToken');
          await userRepository.updateUserFcmToken();
          emit(ProfileLoaded(
            isAuth: true,
            userId: userInfo?['id'].toString(),
            login: userInfo?['login'],
            name: userInfo?['name'],
            email: userInfo?['email'],
            photoPath: userInfo?['photo'],
          ));
        } catch (e) {
          debugPrint('ProfileBloc _onProfileLoadEvent error: $e');
        }

      }
    } catch (e) {
      emit(ProfileLoaded(isAuth: false));
    }
  }

  Future<void> _onProfileSetIsAuthEvent(ProfileSetIsAuthEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoaded(isAuth: event.isAuth));
  }

  Future<void> _onProfileSignOutEvent(ProfileSignOutEvent event, Emitter<ProfileState> emit) async {
    final result = await userRepository.signOut();
    if (result.isSuccess) {
      debugPrint('💚 ProfileBloc _onProfileSignOutEvent success');
      emit(ProfileLoaded(isAuth: false));
    } else {
      debugPrint('❌ ProfileBloc _onProfileSignOutEvent error: ${result.error?.description}');
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

  Future<void> _onProfileTokenDeleteEvent(ProfileTokenDeleteEvent event, Emitter<ProfileState> emit) async {
    await userRepository.deleteToken();
  }
}
