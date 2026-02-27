import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:iamhere/shared/data/user/repositories/user_repository.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final UserRepository userRepository;

  SubscriptionBloc({
    required this.userRepository,
  }) : super(SubscriptionInitial()) {
    on<SubscriptionToggleEvent>(_onSubscriptionToggleEvent);
    on<SubscriptionCheckEvent>(_onSubscriptionCheckEvent);
  }

  Future<void> _onSubscriptionToggleEvent(
    SubscriptionToggleEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionSubscribeLoading(isSubscribed: state.isSubscribedOrNull));
    if (state.isSubscribedOrNull) {
      final result = await userRepository.unSubscribeFromUser(userId: event.userId);
      if (result.isSuccess) {
        emit(SubscriptionSubscribeSuccess(isSubscribed: false));
      } else {
        emit(SubscriptionSubscribeFailure(message: result.error?.description ?? 'Failed to unsubscribe from user', isSubscribed: true));
      }
    } else {
      final result = await userRepository.subscribeToUser(userId: event.userId);
      if (result.isSuccess) {
        emit(SubscriptionSubscribeSuccess(isSubscribed: true));
      }
    }
  }

  Future<void> _onSubscriptionCheckEvent(
    SubscriptionCheckEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionSubscribeLoading(isSubscribed: false));
    try {
      final result = await userRepository.checkSubscription(followedId: event.followedId);
      if (result.isError) {
        emit(SubscriptionSubscribeFailure(message: result.error?.description ?? 'Failed to check subscription', isSubscribed: false));
      } else {
        emit(SubscriptionReady(isSubscribed: result.data?['isFollowed'] ?? false));
      }
    }
    catch (e) {
      debugPrint('UserBloc: error: $e');
      emit(SubscriptionSubscribeFailure(message: 'An unexpected error occurred: $e', isSubscribed: false));
    }
  }
}
