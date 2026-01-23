import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем данные профиля только если login отсутствует
    final currentState = context.read<ProfileBloc>().state;
    if (currentState is! ProfileLoaded || currentState.login == null) {
      context.read<ProfileBloc>().add(ProfileLoadEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Profile'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Profile'),
                Text('Login: ${state.login}'),
                Text('Name: ${state.name}'),
                GFButton(
                  text: 'Sign Out',
                  onPressed: () {
                    context.read<ProfileBloc>().add(ProfileSignOutEvent());
                  },
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}