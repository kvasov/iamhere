import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:iamhere/features/user/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:iamhere/core/di/injection_container.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/user/presentation/widgets/user_info.dart';
import 'package:iamhere/features/user/presentation/bloc/subscription_bloc/subscription_bloc.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    // Обращение к context/InheritedWidget нельзя делать в initState — виджет ещё не в дереве.
    // Выполняем после первой отрисовки, когда контекст уже доступен.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final userId = GoRouterState.of(context).pathParameters['userId'];
      context.read<UserBloc>().add(UserLoadEvent(userId: int.parse(userId ?? '0')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const UserView();
  }
}

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('User'),
        backgroundColor: Colors.white,
        elevation: 0,
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          Icon(Icons.search),
          Icon(Icons.person),
        ],
        foregroundColor: Colors.blueGrey,
        toolbarHeight: 30,
        actionsPadding: .only(right: 16),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserSuccess) {
              // return Text('userData: ${state.userData.toString()}');
            }
            if (state is UserFailure) {
              // return Text('Error: ${state.message.toString()}');
            }
          },
          builder: (context, state) {
            // Просто читаем состояние ProfileBloc без реактивности
            final profileState = context.read<ProfileBloc>().state;
            final profileLoaded = profileState is ProfileLoaded ? profileState : null;

            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserSuccess) {
              return Column(
                children: [
                  BlocProvider<SubscriptionBloc>(
                    create: (_) => di.sl<SubscriptionBloc>()
                      ..add(SubscriptionCheckEvent(followedId: state.userData['id'])),
                    child: UserInfo(
                      userId: state.userData['id'],
                      name: state.userData['name'] ?? '',
                      photoPath: state.userData['photoPath'] ?? '',
                      profileId: profileLoaded?.userId ?? '',
                    ),
                  ),
                ],
              );
            }
            if (state is UserFailure) {
              return Text('Error: ${state.message.toString()}');
            }
            return const Text('State is not loaded');
          },
        ),
      ),
    );
  }
}