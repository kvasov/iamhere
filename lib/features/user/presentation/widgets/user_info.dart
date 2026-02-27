import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iamhere/shared/utils/photo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/user/presentation/bloc/subscription_bloc/subscription_bloc.dart';

class UserInfo extends StatelessWidget {
  final int userId;
  final String name;
  final String photoPath;
  final String profileId;

  const UserInfo({
    super.key,
    required this.userId,
    required this.name,
    required this.photoPath,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionSubscribeSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: .floating,
              content: Text(state.isSubscribedOrNull
                ? 'Подписка на пользователя выполнена'
                : 'Подписка отменена'),
              backgroundColor: state.isSubscribedOrNull ? Colors.green : Colors.orangeAccent,
            ),
          );
        }
        if (state is SubscriptionSubscribeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: .floating,
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const .all(8.0),
          child: Row(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(photoUrl(photoPath)),
                radius: 30,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(name),
                  if (profileId == userId)
                    Text('Это вы', style: TextStyle(color: Colors.green))
                  else
                    GFButton(
                      text: state is SubscriptionSubscribeLoading
                          ? 'Загрузка...'
                          : state.isSubscribedOrNull
                              ? 'Отписаться'
                              : 'Подписаться',
                      icon: const Icon(Icons.person, size: 16, color: Colors.white),
                      onPressed: () {
                        if (state is SubscriptionSubscribeLoading) return;
                        context.read<SubscriptionBloc>().add(SubscriptionToggleEvent(userId: userId));
                      },
                    ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}