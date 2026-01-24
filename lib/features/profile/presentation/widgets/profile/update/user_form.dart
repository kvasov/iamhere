import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:iamhere/shared/styles/text_input_styles.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _imagePicker = ImagePicker();
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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedPhotoPath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при выборе фото: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Выбрать из галереи'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Сделать фото'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
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
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Stack(
                  children: [
                    ClipOval(
                      child: _selectedPhotoPath != null
                          ? Image.file(
                              File(_selectedPhotoPath!),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : widget.state.photoPath != null
                              ? Image.network(
                                  'http://0.0.0.0:8080/${widget.state.photoPath!}',
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 60,
                                    );
                                  },
                                )
                              : Center(
                                child: const Icon(
                                    Icons.person,
                                    size: 60,
                                  ),
                              ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: textInputDecoration(
                'Name',
                Icons.person,
              ),
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: textInputDecoration(
                'Password',
                Icons.password,
              ),
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
            ),
            TextFormField(
              decoration: textInputDecoration(
                'Password Confirm',
                Icons.password,
              ),
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
            ),
            GFButton(text: 'Update', onPressed: () => _handleUpdate(context)),
          ],
        ),
      ),
    );
  }
}