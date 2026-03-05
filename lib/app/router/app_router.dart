import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iamhere/features/home/presentation/screens/home_screen.dart';
import 'package:iamhere/features/place/presentation/screens/place_screen.dart';
import 'package:iamhere/features/place/presentation/screens/gallery_screen.dart';
import 'package:iamhere/features/profile/presentation/screens/sign_in_screen.dart';
import 'package:iamhere/features/profile/presentation/screens/sign_up_screen.dart';
import 'package:iamhere/features/user/presentation/screens/user_screen.dart';
import 'package:iamhere/features/splash/presentation/screens/splash_screen.dart';
import 'package:iamhere/features/profile/presentation/screens/profile_screen.dart';
import 'package:iamhere/features/extra/presentation/screens/extra_screen.dart';
import 'package:iamhere/features/settings/settings_screen.dart';
import 'package:iamhere/features/place/presentation/screens/add_place.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:iamhere/app/router/scaffold_with_bottom_nav.dart';

/// Общий page с анимацией перехода
/// Переходы применяются только к содержимому, а не к bottom navigation bar
class AppTransitionPage<T extends Object?> extends CustomTransitionPage<T> {
  final bool showBottomNavBar;
  final String? currentLocation;

  AppTransitionPage({
    required LocalKey key,
    required Widget child,
    this.showBottomNavBar = false,
    this.currentLocation,
  }) : super(
          key: key,
          // НЕ оборачиваем child здесь, чтобы избежать двойного оборачивания
          child: child,
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            // Если есть bottom navigation bar, применяем переходы только к body Scaffold
            if (showBottomNavBar && currentLocation != null) {
              // debugPrint('🔵 AppTransitionPage: showBottomNavBar=$showBottomNavBar, currentLocation=$currentLocation, child=${child.runtimeType}');

              // child должен быть Scaffold из экрана
              Widget? scaffoldBody;
              PreferredSizeWidget? scaffoldAppBar;
              Color? scaffoldBackgroundColor;
              bool? scaffoldResizeToAvoidBottomInset;

              // Извлекаем свойства из Scaffold
              if (child is Scaffold) {
                scaffoldBody = child.body;
                scaffoldAppBar = child.appBar;
                scaffoldBackgroundColor = child.backgroundColor;
                scaffoldResizeToAvoidBottomInset = child.resizeToAvoidBottomInset;
                // debugPrint('🔵 AppTransitionPage: Извлечены свойства из Scaffold');
              } else {
                // Если child не Scaffold, используем его как body
                scaffoldBody = child;
                // debugPrint('🔵 AppTransitionPage: child не Scaffold, используем как body');
              }

              // Применяем переходы только к body, а не к самому Scaffold
              final animatedBody = _buildAnimatedContent(scaffoldBody!, curved);

              // Создаем новый Scaffold с анимированным body и bottomNavigationBar
              // Важно: НЕ копируем bottomNavigationBar из оригинального Scaffold
              return ScaffoldWithBottomAppBar(
                currentLocation: currentLocation,
                child: Scaffold(
                  appBar: scaffoldAppBar,
                  body: animatedBody,
                  backgroundColor: scaffoldBackgroundColor,
                  resizeToAvoidBottomInset: scaffoldResizeToAvoidBottomInset,
                ),
              );
            }

            // Обычный переход для экранов без bottom navigation bar
            return _buildAnimatedContent(child, curved);
          },
        );
}

/// Создает анимированный виджет с эффектами scale и fade
Widget _buildAnimatedContent(Widget child, CurvedAnimation curved) {
  return ScaleTransition(
    scale: Tween<double>(
      begin: 0.97,
      end: 1.0,
    ).animate(curved),
    child: FadeTransition(
      opacity: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(curved),
      child: child,
    ),
  );
}


/// Хелпер для создания GoRoute с кастомным переходом
GoRoute buildRoute({
  required String path,
  required String name,
  required Widget child,
  bool showBottomNavBar = false,
}) {
  return GoRoute(
    path: path,
    name: name,
    pageBuilder: (context, state) {
      // debugPrint('🔵 buildRoute: path=$path, showBottomNavBar=$showBottomNavBar, matchedLocation=${state.matchedLocation}');
      return AppTransitionPage(
        key: state.pageKey,
        child: child,
        showBottomNavBar: showBottomNavBar,
        currentLocation: state.matchedLocation,
      );
    },
  );
}

/// Маршрут с динамическим контентом из state (например, extra).
GoRoute buildRouteWithState({
  required String path,
  required String name,
  required Widget Function(GoRouterState state) childBuilder,
  bool showBottomNavBar = false,
}) {
  return GoRoute(
    path: path,
    name: name,
    pageBuilder: (context, state) {
      return AppTransitionPage(
        key: state.pageKey,
        child: childBuilder(state),
        showBottomNavBar: showBottomNavBar,
        currentLocation: state.matchedLocation,
      );
    },
  );
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Конфигурация маршрутов приложения
class AppRouter {
  final ProfileBloc profileBloc;
  final bool splashHasBeenShown;
  AppRouter({required this.profileBloc, this.splashHasBeenShown = false});

  GoRouter get router => GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(profileBloc.stream),
    redirect: (context, state) {
      // debugPrint('🔵🔵🔵🔵🔵🔵 redirect: ${state.matchedLocation}, profileState: ${profileBloc.state}');
      final profileState = profileBloc.state;

      final isGoingToSplash = state.matchedLocation == '/splash';
      final isGoingToHome = state.matchedLocation == '/home';
      final isGoingToProfile = state.matchedLocation == '/profile';
      final isGoingToSignIn = state.matchedLocation == '/sign-in';
      final isGoingToSignUp = state.matchedLocation == '/sign-up';

      // Если токен истек — явно переходим на sign-in в следующем кадре,
      // т.к. возврат из redirect иногда не применяется (повторный вызов redirect возвращает null).
      if (profileState is ProfileTokenExpired) {
        // debugPrint('🔴 redirect: profileState is ProfileTokenExpired');
        return '/sign-in?reason=token_expired';
      }

      // Если состояние еще не загружено или идет загрузка
      if (profileState is! ProfileLoaded) {
        // debugPrint('🇷🇺 profileState is not loaded: ${profileState.runtimeType}');
        // Если идет загрузка профиля - разрешаем доступ ко всем страницам
        // чтобы не было редиректа во время загрузки данных
        if (profileState is ProfileLoading) {
          return null;
        }

        // Разрешаем переход на profile (будет загрузка данных)
        if (isGoingToProfile) {
          return null;
        }

        // Если splash уже был показан, то редиректим на sign-in
        if (isGoingToSplash && splashHasBeenShown) {
          return '/sign-in';
        }

        // Если пытаемся перейти на home - редиректим на sign-in
        // (так как после загрузки данных неавторизованный пользователь все равно будет редиректиться на sign-in)
        if (isGoingToHome) {
          return '/sign-in';
        }
        // Разрешаем переход на sign-in
        if (isGoingToSignIn || isGoingToSignUp) {
          return null;
        }
        // Редиректим на splash для всех остальных маршрутов
        return '/splash';
      }


      // Если пользователь не авторизован
      if (profileState.isAuth == false) {
        // Редиректим на sign-in при попытке перехода на profile или home
        if (isGoingToProfile || isGoingToHome) {
          return '/sign-in';
        }
        // Разрешаем доступ только к sign-in, sign-up и splash
        if (isGoingToSignIn || isGoingToSplash || isGoingToSignUp) {
          // debugPrint('🔵 redirect: isGoingToSignIn || isGoingToSplash || isGoingToSignUp');
          // Если splash уже был показан, то редиректим на home
          if (isGoingToSplash && splashHasBeenShown) {
            // debugPrint('☎️ redirect: splashHasBeenShown = true, redirecting to home');
            return '/home';
          }
          return null;
        }
        // Редиректим на sign-in для всех остальных маршрутов
        return '/sign-in';
      }

      // Если пользователь авторизован
      if (profileState.isAuth == true) {
        // Редиректим только со splash на home
        // Разрешаем доступ к остальным страницам
        if (isGoingToSplash || isGoingToSignIn) {
          return '/home';
        }
      }

      return null;
    },
    routes: [
      buildRoute(
        path: '/splash',
        name: 'splash',
        child: SplashScreen(),
      ),
      buildRoute(
        path: '/home',
        name: 'home',
        child: const HomeScreen(),
        showBottomNavBar: true,
      ),
      buildRoute(
        path: '/place/:placeId',
        name: 'place',
        child: const PlaceScreen(),
        showBottomNavBar: true,
      ),
      buildRouteWithState(
        path: '/gallery',
        name: 'gallery',
        childBuilder: (state) {
          final extra = state.extra as Map<String, dynamic>?;
          final urls = (extra?['urls'] as List<dynamic>).map((e) => e as String).toList();
          final initialIndex = extra?['initialIndex'] as int? ?? 0;
          return GalleryScreen(imageUrls: urls, initialIndex: initialIndex);
        },
      ),
      buildRoute(
        path: '/profile',
        name: 'profile',
        child: const ProfileScreen(),
        showBottomNavBar: true,
      ),
      buildRoute(
        path: '/settings',
        name: 'settings',
        child: const SettingsScreen(),
        showBottomNavBar: true,
      ),
      buildRouteWithState(
        path: '/sign-in',
        name: 'sign-in',
        childBuilder: (state) {
          final showTokenExpiredMessage =
              state.uri.queryParameters['reason'] == 'token_expired';
          // debugPrint('🔥🔥🔥🔥🔥🔥🔥 sign-in: showTokenExpiredMessage=$showTokenExpiredMessage');
          return SignInScreen(showTokenExpiredMessage: showTokenExpiredMessage);
        },
      ),
      buildRoute(
        path: '/sign-up',
        name: 'sign-up',
        child: SignUpScreen(),
      ),
      buildRoute(
        path: '/user/:userId',
        name: 'user',
        child: const UserScreen(),
        showBottomNavBar: true,
      ),
      buildRoute(
        path: '/extra',
        name: 'extra',
        child: ExtraScreen(),
      ),
      buildRoute(
        path: '/add-place',
        name: 'add-place',
        child: const AddPlaceScreen(),
        showBottomNavBar: true,
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((state) {
      // debugPrint('GoRouterRefreshStream: state changed to $state');
      notifyListeners();
    });
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

