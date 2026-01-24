import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:iamhere/features/profile/presentation/widgets/profile/update/avatar_widget.dart';
import 'package:iamhere/features/profile/presentation/widgets/profile/update/text_field_widget.dart';
import 'package:iamhere/shared/extensions/widget_animate_extensions.dart';
import 'package:getwidget/getwidget.dart';

class UserForm extends StatefulWidget {
  final ProfileLoaded state;
  const UserForm({
    super.key,
    required this.state,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedPhotoPath;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.state.name ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    loginController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  void _handleUpdate(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileBloc>().add(ProfileUpdateEvent(
        name: nameController.text,
        password: passwordController.text,
        passwordConfirm: passwordConfirmController.text,
        photoPath: _selectedPhotoPath,
      ));
    }
  }

  void _handlePhotoSelected(String? photoPath) {
    setState(() {
      _selectedPhotoPath = photoPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 0,
          children: [
            // Виджет для выбора и отображения фото
            AvatarWidget(
              photoPath: widget.state.photoPath,
              onPhotoSelected: _handlePhotoSelected,
              selectedPhotoPath: _selectedPhotoPath,
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              hintText: 'Name',
              prefixIcon: Icons.person,
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
              staggerIndex: 0,
            ),
            TextFieldWidget(
              hintText: 'Password',
              prefixIcon: Icons.password,
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                }
                return null;
              },
              staggerIndex: 1,
            ),
            TextFieldWidget(
              hintText: 'Password Confirm',
              prefixIcon: Icons.password,
              controller: passwordConfirmController,
              obscureText: true,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                }
                return null;
              },
              staggerIndex: 2,
            ),
            GFButton(
              onPressed: widget.state.status == ProfileStatus.saving
                  ? null
                  : () => _handleUpdate(context),
              child: widget.state.status == ProfileStatus.saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Update'),
            ).fadeScaleAnimate(),
          ],
        ),
      ),
    );
  }
}