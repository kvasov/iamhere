import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/core/di/injection_container.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:iamhere/features/profile/presentation/widgets/profile/text_field_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, this.showTokenExpiredMessage = false});

  /// Показывать «Вас давно не было…» при редиректе из-за истёкшего токена (reason=token_expired в роуте).
  final bool showTokenExpiredMessage;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.showTokenExpiredMessage) {
      context.read<ProfileBloc>().add(ProfileTokenDeleteEvent());
    }
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SignInBloc>().add(
            SignInSubmitted(
              login: loginController.text.trim(),
              password: passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (_) => sl<SignInBloc>(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Sign In'),
          ),
          body: BlocListener<SignInBloc, SignInState>(
            listener: (context, state) {
              if (state is SignInSuccess) {
                // После успешной авторизации ProfileBloc уже обновлен в SignInBloc
                // GoRouter автоматически сделает редирект на /home из-за изменения состояния ProfileBloc
                // Показываем сообщение об успехе только если виджет еще активен
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sign in successful'),
                      backgroundColor: Colors.green,
                      behavior: .floating,
                      elevation: 0,
                      margin: .only(bottom: 10, left: 16, right: 16),
                    ),
                  );
                }
              } else if (state is SignInFailure) {
                // Показываем ошибку только если виджет еще активен
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      behavior: .floating,
                      elevation: 0,
                      margin: .only(bottom: 10, left: 16, right: 16),
                    ),
                  );
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.showTokenExpiredMessage) ...[
                      const Text(
                        'Вас давно не было, нужно ввести данные для входа',
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFieldWidget(
                      hintText: 'Name',
                      prefixIcon: Icons.person,
                      controller: loginController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Login is required';
                        }
                        return null;
                      },
                      staggerIndex: 0,
                    ),
                    const SizedBox(height: 16),
                    TextFieldWidget(
                      hintText: 'Password',
                      prefixIcon: Icons.password,
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      staggerIndex: 1,
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<SignInBloc, SignInState>(
                      builder: (context, state) {
                        final isLoading = state is SignInLoading;
                        return GFButton(
                          text: 'Sign In',
                          onPressed: isLoading ? null : () => _handleSignIn(context),
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
                    TextButton(
                      onPressed: () {
                        context.go('/sign-up');
                      },
                      child: const Text('Sign Up'),
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