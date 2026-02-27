part of 'subscription_bloc.dart';

@immutable
sealed class SubscriptionEvent {}

final class SubscriptionToggleEvent extends SubscriptionEvent {
  final int userId;

  SubscriptionToggleEvent({required this.userId});
}

final class SubscriptionCheckEvent extends SubscriptionEvent {
  final int followedId;

  SubscriptionCheckEvent({required this.followedId});
}