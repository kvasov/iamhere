import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:iamhere/shared/data/user/repositories/user_repository.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository userRepository;

  SignUpBloc({required this.userRepository}) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    // Валидация
    if (event.name.isEmpty) {
      emit(SignUpFailure(message: 'Name is required'));
      return;
    }

    if (event.login.isEmpty) {
      emit(SignUpFailure(message: 'Login is required'));
      return;
    }

    if (event.email.isEmpty) {
      emit(SignUpFailure(message: 'Email is required'));
      return;
    }

    if (event.password.isEmpty) {
      emit(SignUpFailure(message: 'Password is required'));
      return;
    }

    if (event.password.length < 6) {
      emit(SignUpFailure(message: 'Password must be at least 6 characters'));
      return;
    }

    if (event.password != event.passwordConfirm) {
      emit(SignUpFailure(message: 'Passwords do not match'));
      return;
    }

    emit(SignUpLoading());

    try {
      final result = await userRepository.signUp(
        name: event.name,
        login: event.login,
        email: event.email,
        password: event.password,
        photoPath: event.photoPath ?? '',
      );

      if (result.isSuccess) {
        emit(SignUpSuccess(userData: result.data!));
      } else {
        emit(SignUpFailure(message: result.error?.description ?? 'Sign up failed'));
      }
    } catch (e) {
      debugPrint('SignUpBloc: error: $e');
      emit(SignUpFailure(message: 'An unexpected error occurred: $e'));
    }
  }
}
