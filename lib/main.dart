import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/app/i18n/strings.g.dart';
import 'package:iamhere/app/router/app_router.dart';
import 'package:iamhere/app/services/push_notification_service.dart';
import 'package:iamhere/core/di/injection_container.dart';
import 'package:iamhere/shared/bloc/locale/locale_bloc.dart';
import 'package:iamhere/shared/data/fcm/fcm_local_datasource.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:iamhere/features/user/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:iamhere/shared/bloc/theme/theme_bloc.dart';
import 'package:iamhere/app/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  PushNotificationService.setupBackgroundMessageHandler();

  await initDI();

  final prefs = sl<SharedPreferences>();
  final splashHasBeenShown = prefs.getBool('splash_has_been_shown') ?? false;

  // Создаем ThemeBloc и загружаем тему через событие
  final themeBloc = sl<ThemeBloc>();
  themeBloc.add(ThemeInitEvent());

  // Дожидаемся загрузки темы перед созданием приложения
  await themeBloc.stream.firstWhere(
    (state) => state is ThemeLoaded,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBloc>(
          create: (_) => sl<LocaleBloc>()..add(LocaleInitEvent()),
        ),
        BlocProvider<ProfileBloc>.value(
          value: sl<ProfileBloc>(),
        ),
        BlocProvider<ThemeBloc>.value(
          value: themeBloc,
        ),
        BlocProvider<SignInBloc>.value(
          value: sl<SignInBloc>()..add(SignInCheckTokenEvent()),
        ),
        BlocProvider<UserBloc>.value(
          value: sl<UserBloc>(),
        ),
      ],
      child: MainApp(splashHasBeenShown: splashHasBeenShown),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.splashHasBeenShown});
  final bool splashHasBeenShown;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;
  late final PushNotificationService _pushService;

  @override
  void initState() {
    super.initState();

    final profileBloc = context.read<ProfileBloc>();

    _router = AppRouter(
      profileBloc: profileBloc,
      splashHasBeenShown: widget.splashHasBeenShown,
    ).router;

    _pushService = PushNotificationService(_router, sl<FcmLocalDataSource>());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _pushService.init();
    });

    profileBloc.stream.listen((state) {
      if (state is ProfileLoaded) {
        _pushService.tryNavigate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              final themeMode = (themeState as ThemeLoaded).themeMode;

              return MaterialApp.router(
                locale: localeState.locale,
                theme: AppTheme.buildLightTheme(Colors.blue),
                darkTheme: AppTheme.buildDarkTheme(Colors.blue),
                themeMode: themeMode,
                routerConfig: _router,
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
