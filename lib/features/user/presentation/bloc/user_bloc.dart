import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:iamhere/shared/data/user/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({
    required this.userRepository,
  }) : super(UserInitial()) {
    on<UserLoadEvent>(_onUserLoadEvent);
  }

  Future<void> _onUserLoadEvent(
    UserLoadEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    try {
      final result = await userRepository.getUserInfoById(
        userId: event.userId,
      );

      if (result.isSuccess) {
        debugPrint('✅ SignInBloc: result: ${result.data}');
        emit(UserSuccess(userData: result.data!));
      } else {
        emit(UserFailure(message: result.error?.description ?? 'Sign in failed'));
      }
    } catch (e) {
      debugPrint('UserBloc: error: $e');
      emit(UserFailure(message: 'An unexpected error occurred: $e'));
    }
  }
}
