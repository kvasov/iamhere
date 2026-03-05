// ---------------------------------------------------------------------------
// PushNotificationService — FCM + локальные уведомления
// ---------------------------------------------------------------------------
//
// Отвечает за:
// - приём push (foreground / background / terminated);
// - показ головки уведомления через flutter_local_notifications (в foreground
//   FCM сам не показывает, в background показываем из background handler);
// - переход на экран места по тапу (FCM, локальное уведомление, cold start).

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iamhere/shared/data/fcm/fcm_local_datasource.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Константы (общие для main isolate и background isolate)
// ---------------------------------------------------------------------------

/// Канал уведомлений на Android 8+. Имя и importance влияют на отображение в шторке.
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'high_importance_channel',
  'Уведомления',
  description: 'Канал для push-уведомлений',
  importance: Importance.high,
);

/// Настройки при первом вызове initialize() плагина. Одинаковые в main и в background,
/// чтобы уведомления выглядели единообразно.
const InitializationSettings _initSettings = InitializationSettings(
  android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  iOS: DarwinInitializationSettings(requestAlertPermission: false),
);

// ---------------------------------------------------------------------------
// Background handler (топ-уровень — требование Firebase)
// ---------------------------------------------------------------------------

/// Обработчик push-сообщений, когда приложение в фоне или закрыто.
///
/// Выполняется в **отдельном isolate**. Поэтому: (1) функция обязана быть
/// топ-уровневой; (2) нельзя использовать [PushNotificationService] или GetIt —
/// плагин и Firebase инициализируются здесь заново.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Flutter и Firebase в этом isolate не инициализированы — делаем это вручную.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Плагин создаём локально: в background isolate нет доступа к экземпляру из main.
  final plugin = FlutterLocalNotificationsPlugin();
  await plugin.initialize(settings: _initSettings);

  // На Android 8+ без канала уведомление может не показаться или без звука.
  if (Platform.isAndroid) {
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  final notification = message.notification;
  final title = notification?.title ?? 'Уведомление';
  final body = notification?.body ?? '';

  // id по hashCode сообщения — при повторной доставке то же уведомление обновится.
  // payload (place_id) вернётся при тапе и обработается в main isolate.
  await plugin.show(
    id: message.hashCode,
    title: title,
    body: body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: _channel.importance,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(),
    ),
    payload: message.data['place_id'],
  );

  debugPrint('🔔 Background message: ${message.messageId}');
}

// ---------------------------------------------------------------------------
// PushNotificationService
// ---------------------------------------------------------------------------

/// Сервис push-уведомлений: инициализация плагина в main, подписки на FCM,
/// показ локальных уведомлений в foreground и навигация по тапу.
class PushNotificationService {
  PushNotificationService(this.router, this._fcmLocalDataSource);

  /// Роутер для перехода на /place/:id при тапе по уведомлению.
  final GoRouter router;

  /// Сохранение FCM-токена (для отправки на бэкенд).
  final FcmLocalDataSource _fcmLocalDataSource;

  /// Отложенный маршрут (например после логина), если уведомление пришло до авторизации.
  String? _pendingRoute;

  /// Один экземпляр плагина на приложение (main isolate). В background — свой экземпляр в handler.
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Инициализация плагина выполняется один раз при первом init().
  static bool _localNotificationsInitialized = false;

  /// Регистрирует [firebaseMessagingBackgroundHandler]. Вызывать в main() до runApp().
  static void setupBackgroundMessageHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Полная инициализация: плагин, подписки на FCM, проверка cold start по уведомлению.
  Future<void> init() async {
    await _ensureLocalNotificationsInitialized(router);

    // Запрос разрешений и сохранение FCM-токена (на Android обязателен для получения push).
    if (Platform.isAndroid) {
      await _requestPermissionAndSaveToken();
    }

    // В foreground FCM не показывает головку — показываем сами через плагин.
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // Пользователь тапнул по системному FCM-уведомлению (приложение было в фоне).
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Приложение запустили по тапу на FCM (приложение было закрыто).
    final initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Приложение запустили по тапу на локальное уведомление (наш плагин).
    final launchDetails =
        await _localNotifications.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true &&
        launchDetails?.notificationResponse?.payload != null) {
      _goToPlace(router, launchDetails!.notificationResponse!.payload!);
    }
  }

  /// Инициализация плагина в main isolate. [router] нужен для колбека при тапе на уведомление.
  static Future<void> _ensureLocalNotificationsInitialized(
    GoRouter router,
  ) async {
    if (_localNotificationsInitialized) return;
    await _localNotifications.initialize(
      settings: _initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Тап по локальному уведомлению (приложение уже было запущено или в фоне).
        if (response.payload != null && response.payload!.isNotEmpty) {
          _goToPlace(router, response.payload!);
        }
      },
    );
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);
    }
    _localNotificationsInitialized = true;
  }

  /// Запрос разрешения на уведомления и сохранение FCM-токена в локальное хранилище.
  Future<void> _requestPermissionAndSaveToken() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    final token = await messaging.getToken();
    if (token != null) {
      await _fcmLocalDataSource.saveFcmToken(token);
      debugPrint('📱 FCM Token: $token');
    }
  }

  /// Переход на экран места. Статический метод — вызывается и из колбека плагина (нет this), и из init().
  static void _goToPlace(GoRouter router, String placeId) {
    router.go('/place/$placeId');
  }

  /// Показывает локальное уведомление при получении FCM в foreground.
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? 'Уведомление';
    final body = notification?.body ?? '';

    await _localNotifications.show(
      id: message.hashCode,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: _channel.importance,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data['place_id'],
    );

    debugPrint('🔔 Foreground message shown: ${message.messageId}');
  }

  /// Вызывать после успешной авторизации: выполняет отложенный переход, если он был сохранён.
  void tryNavigate() {
    if (_pendingRoute != null) {
      router.go(_pendingRoute!);
      _pendingRoute = null;
    }
  }

  /// Обработка открытия по FCM: переход на /place/:id если в data есть place_id.
  void _handleMessage(RemoteMessage message) {
    debugPrint('🔔 PushNotificationService _handleMessage: ${message.data}');
    final placeId = message.data['place_id'];
    if (placeId != null) {
      _goToPlace(router, placeId);
    }
  }
}
