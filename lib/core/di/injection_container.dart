import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:iamhere/features/place/presentation/bloc/places_bloc.dart';
import 'package:iamhere/features/place/data/datasources/places_list_datasource.dart';
import 'package:iamhere/features/place/data/repositories/places_repository_impl.dart';

import 'package:iamhere/features/profile/data/repositories/user_repository.dart';
import 'package:iamhere/features/profile/data/datasources/local/user_local_datasource.dart';
import 'package:iamhere/features/profile/data/datasources/remote/user_remote_datasource.dart';
import 'package:iamhere/features/profile/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:iamhere/shared/bloc/locale/locale_bloc.dart';
import 'package:iamhere/shared/bloc/theme/theme_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:iamhere/app/db/database.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = 'http://0.0.0.0:8080/';
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

  sl.registerLazySingleton<PlacesRepository>(() => PlacesRepository(
    userLocalDataSource: sl<UserLocalDataSource>(),
    placesRemoteDataSource: sl<PlacesListRemoteDataSource>(),
  ));

  sl.registerLazySingleton<PlacesListRemoteDataSource>(() => PlacesListRemoteDataSourceImpl());


  sl.registerLazySingleton<UserRepository>(() => UserRepository(
    userRemoteDataSource: sl<UserRemoteDataSource>(),
    userLocalDataSource: sl<UserLocalDataSource>(),
  ));

  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(sl<Dio>()));
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(sl<AppDatabase>()));

  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton(() => sharedPreferences);

  // Регистрируем базу данных как singleton - один экземпляр на все приложение
  sl.registerLazySingleton(() => AppDatabase());
}
