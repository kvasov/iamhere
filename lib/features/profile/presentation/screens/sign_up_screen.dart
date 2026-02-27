import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/core/di/injection_container.dart';
import 'package:iamhere/features/profile/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:iamhere/features/profile/presentation/widgets/profile/update/avatar_widget.dart';
import 'package:iamhere/shared/styles/text_input_styles.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedPhotoPath;

  @override
  void dispose() {
    nameController.dispose();
    loginController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  void _handleSignUp(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SignUpBloc>().add(
            SignUpSubmitted(
              name: nameController.text.trim(),
              login: loginController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text,
              passwordConfirm: passwordConfirmController.text,
              photoPath: _selectedPhotoPath,
            ),
          );
    }
  }

  void _handlePhotoSelected(String? photoPath) {
    setState(() {
      _selectedPhotoPath = photoPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (_) => sl<SignUpBloc>(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Sign Up'),
          ),
          body: BlocListener<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                // После успешной регистрации устанавливаем авторизацию
                // context.read<ProfileBloc>().add(ProfileSetIsAuthEvent(isAuth: true));
                // Переходим на домашний экран
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Registration successful'),
                    backgroundColor: Colors.green,
                  ),
                );
                Future.delayed(const Duration(seconds: 2), () {
                  context.go('/home');
                });
              } else if (state is SignUpFailure) {
                // Показываем ошибку
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AvatarWidget(
                      photoPath: '',
                      onPhotoSelected: _handlePhotoSelected,
                      selectedPhotoPath: _selectedPhotoPath,
                    ),
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
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: textInputDecoration(
                        'Login',
                        Icons.person,
                      ),
                      controller: loginController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Login is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: textInputDecoration(
                        'Email',
                        Icons.email,
                      ),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: textInputDecoration(
                        'Password',
                        Icons.password,
                      ),
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: textInputDecoration(
                        'Password Confirm',
                        Icons.password,
                      ),
                      controller: passwordConfirmController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    BlocBuilder<SignUpBloc, SignUpState>(
                      builder: (context, state) {
                        final isLoading = state is SignUpLoading;
                        return GFButton(
                          text: 'Sign Up',
                          onPressed: isLoading ? null : () => _handleSignUp(context),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        context.go('/sign-in');
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}