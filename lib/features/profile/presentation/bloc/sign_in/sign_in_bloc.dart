import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:iamhere/shared/data/user/repositories/user_repository.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository userRepository;
  final ProfileBloc profileBloc;

  SignInBloc({
    required this.userRepository,
    required this.profileBloc,
  }) : super(SignInInitial()) {
    on<SignInSubmitted>(_onSignInSubmitted);
    on<SignInCheckTokenEvent>(_onSignInCheckTokenEvent);
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    // Валидация
    if (event.login.isEmpty) {
      emit(SignInFailure(message: 'Login is required'));
      return;
    }

    if (event.password.isEmpty) {
      emit(SignInFailure(message: 'Password is required'));
      return;
    }

    emit(SignInLoading());

    try {
      final result = await userRepository.signIn(
        login: event.login,
        password: event.password,
      );

      if (result.isSuccess) {
        debugPrint('✅ SignInBloc: result: ${result.data}');
        final savedToken = await userRepository.saveUserToken(
          token: result.data!['token'],
        );
        if (savedToken.isSuccess) {
          profileBloc.add(ProfileSetIsAuthEvent(isAuth: true));
          profileBloc.add(ProfileLoadEvent());
          emit(SignInSuccess(userData: result.data!));
        } else {
          debugPrint('❌❌❌ SignInBloc: savedToken: ${savedToken.error?.description}');
          emit(SignInFailure(message: savedToken.error?.description ?? 'Failed to save token'));
        }
      } else {
        emit(SignInFailure(message: result.error?.description ?? 'Sign in failed'));
      }
    } catch (e) {
      debugPrint('SignInBloc: error: $e');
      emit(SignInFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onSignInCheckTokenEvent(
    SignInCheckTokenEvent event,
    Emitter<SignInState> emit,
  ) async {
    try {
      debugPrint('🩵 SignInBloc: проверка токена');
      final savedToken = await userRepository.getUserToken();

      if (savedToken != null && savedToken.isNotEmpty) {
        // Если токен найден, загружаем данные пользователя
        // если срок действия токена истек, то ....
        // profileBloc.add(ProfileSetIsAuthEvent(isAuth: true));
        profileBloc.add(ProfileLoadEvent());
        // debugPrint('✅✅✅ SignInBloc: токен найден, пользователь авторизован');
      } else {
        debugPrint('ℹ️ SignInBloc: токен не найден, пользователь не авторизован');
      }
    } catch (e) {
      debugPrint('SignInBloc: ошибка при проверке токена: $e');
    }
  }
}
