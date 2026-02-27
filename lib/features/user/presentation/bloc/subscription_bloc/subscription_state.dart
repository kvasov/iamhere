part of 'subscription_bloc.dart';

@immutable
sealed class SubscriptionState {
  bool get isSubscribedOrNull => switch (this) {
    SubscriptionReady s => s.isSubscribed,
    SubscriptionSubscribeLoading s => s.isSubscribed,
    SubscriptionSubscribeSuccess s => s.isSubscribed,
    SubscriptionSubscribeFailure s => s.isSubscribed,
    _ => false,
  };
}

class SubscriptionInitial extends SubscriptionState {}  // ещё не проверяли

class SubscriptionReady extends SubscriptionState {
  final bool isSubscribed;
  SubscriptionReady({required this.isSubscribed});
}

class SubscriptionSubscribeLoading extends SubscriptionState {
  final bool isSubscribed;  // сохраняем на время загрузки
  SubscriptionSubscribeLoading({required this.isSubscribed});
}

class SubscriptionSubscribeSuccess extends SubscriptionState {
  final bool isSubscribed;  // true после подписки
  SubscriptionSubscribeSuccess({required this.isSubscribed});
}

class SubscriptionSubscribeFailure extends SubscriptionState {
  final String message;
  final bool isSubscribed;  // прежнее значение
  SubscriptionSubscribeFailure({required this.message, required this.isSubscribed});
}