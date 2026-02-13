import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:iamhere/features/profile/presentation/widgets/profile/update/user_form.dart';
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
    // Загружаем данные профиля только если состояние не загружено
    final currentState = context.read<ProfileBloc>().state;
    if (currentState is! ProfileLoaded) {
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
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded && state.status == ProfileStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: .floating,
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is ProfileLoaded && state.status == ProfileStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: .floating,
                content: Text('Something went wrong'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserForm(state: state),
                // Text('Profile'),
                // Text('UserId: ${state.userId}'),
                // Text('Login: ${state.login}'),
                // Text('Name: ${state.name}'),
                // Text('PhotoPath: ${state.photoPath}'),
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
        }
      ),
    );
  }
}