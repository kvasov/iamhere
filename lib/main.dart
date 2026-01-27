import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/app/i18n/strings.g.dart';
import 'package:iamhere/app/router/app_router.dart';
import 'package:iamhere/core/di/injection_container.dart' show init, sl;
import 'package:iamhere/shared/bloc/locale/locale_bloc.dart';
import 'package:iamhere/shared/bloc/locale/locale_event.dart';
import 'package:iamhere/shared/bloc/locale/locale_state.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:iamhere/shared/bloc/theme/theme_bloc.dart';
import 'package:iamhere/app/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  // Для разработки: раскомментируйте следующую строку, чтобы удалить БД при запуске
  // await AppDatabase.deleteDatabase();

  await init();

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
          create: (_) => sl<LocaleBloc>()..add(LocaleInitEvent('ru')),
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
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    /// ✅ Теперь ProfileBloc УЖЕ существует выше в дереве
    final profileBloc = context.read<ProfileBloc>();

    _router = AppRouter(
      profileBloc: profileBloc,
    ).router;

    if (Platform.isAndroid) {
      _initFCM();
    }
  }

  Future<void> _initFCM() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    final token = await messaging.getToken();
    print('📱 FCM Token: $token');

    FirebaseMessaging.onMessage.listen((message) {
      print('🔔 Foreground message: ${message.notification?.title}');
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
