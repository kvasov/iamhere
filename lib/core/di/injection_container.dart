import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:iamhere/features/place/presentation/bloc/places_bloc.dart';
import 'package:iamhere/features/place/data/datasources/places_datasource.dart';
import 'package:iamhere/features/place/data/repositories/places_repository_impl.dart';

import 'package:iamhere/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:iamhere/features/settings/data/datasources/datasource_local.dart';
import 'package:iamhere/shared/data/geo/datasources/remote/geo_remote_datasource.dart';
import 'package:iamhere/shared/data/fcm/fcm_local_datasource.dart';
import 'package:iamhere/shared/data/user/repositories/user_repository.dart';
import 'package:iamhere/shared/data/user/datasources/local/user_local_datasource.dart';
import 'package:iamhere/shared/data/user/datasources/remote/user_remote_datasource.dart';
import 'package:iamhere/features/profile/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:iamhere/shared/bloc/locale/locale_bloc.dart';
import 'package:iamhere/shared/bloc/theme/theme_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:iamhere/core/constants/host.dart';
import 'package:iamhere/features/user/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:iamhere/features/user/presentation/bloc/subscription_bloc/subscription_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final sl = GetIt.instance;

Future<void> initDI() async {
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = 'http://${host}/';
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    return dio;
  });

  sl.registerFactory(() => PlacesBloc(placesRepository: sl<PlacesRepository>()));
  sl.registerLazySingleton(() => ProfileBloc(userRepository: sl<UserRepository>()));
  sl.registerFactory(() => LocaleBloc());
  sl.registerFactory(() => ThemeBloc());
  sl.registerFactory(() => SignUpBloc(userRepository: sl<UserRepository>()));
  sl.registerFactory(() => SignInBloc(
    userRepository: sl<UserRepository>(),
    profileBloc: sl<ProfileBloc>(),
  ));
  sl.registerFactory(() => UserBloc(
    userRepository: sl<UserRepository>(),
  ));
  sl.registerFactory(() => SubscriptionBloc(
    userRepository: sl<UserRepository>(),
  ));

  sl.registerLazySingleton<PlacesRepository>(() => PlacesRepository(
    userLocalDataSource: sl<UserLocalDataSource>(),
    placesRemoteDataSource: sl<PlacesListRemoteDataSource>(),
  ));

  sl.registerLazySingleton<PlacesListRemoteDataSource>(() => PlacesListRemoteDataSourceImpl());

  sl.registerLazySingleton<GeoRemoteDataSource>(() => GeoRemoteDataSourceImpl(sl<Dio>()));


  sl.registerLazySingleton<UserRepository>(() => UserRepository(
    fcmLocalDataSource: sl<FcmLocalDataSource>(),
    userRemoteDataSource: sl<UserRemoteDataSource>(),
    userLocalDataSource: sl<UserLocalDataSource>(),
  ));

  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(sl<Dio>()));
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(sl<FlutterSecureStorage>()));

  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepository(
    settingsLocalDataSource: sl<SettingsLocalDataSource>(),
  ));

  sl.registerLazySingleton<SettingsLocalDataSource>(() => SettingsLocalDataSourceImpl(sl<FlutterSecureStorage>()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  final secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton(() => secureStorage);

  sl.registerLazySingleton<FcmLocalDataSource>(() => FcmLocalDataSourceImpl(
    sl<SharedPreferences>())
  );
}
