import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:iamhere/core/di/injection_container.dart';
import 'package:iamhere/features/place/data/models/place.dart';

abstract class PlacesListRemoteDataSource {
  Future<List<Place>> getPlaces(String? token);
  Future<Place> getPlace(String? token, String placeId);
}

class PlacesListRemoteDataSourceImpl implements PlacesListRemoteDataSource {
  @override
  Future<List<Place>> getPlaces(String? token) async {
    final Dio dio = sl<Dio>();
    final response = await dio.get(
      '/api/places',
      options: Options(headers: {'Authorization': 'Bearer $token'})
    );

    debugPrint('response: ${response.data}');

    // API возвращает напрямую массив объектов, а не объект с полем data
    final List<dynamic> responseData = response.data as List<dynamic>;

    // Преобразуем массив JSON объектов в список Todo
    return responseData
        .map((e) => Place.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Place> getPlace(String? token, String placeId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Dio dio = sl<Dio>();
    final response = await dio.get(
      '/api/places/$placeId',
      options: Options(headers: {'Authorization': 'Bearer $token'})
    );

    debugPrint('response: ${response.data}');

    return Place.fromJson(response.data as Map<String, dynamic>);
  }
}


