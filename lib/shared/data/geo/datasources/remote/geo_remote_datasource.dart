import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

// https://geocode-maps.yandex.ru/v1/?apikey=29b221b4-7d30-4d9d-b159-a3d649ead400&geocode=25.194867,55.274795&format=json

import 'package:iamhere/core/constants/api_keys.dart';

abstract class GeoRemoteDataSource {
  Future<Map<String, dynamic>> getAddressByCoordinates(String latitude, String longitude);
}

class GeoRemoteDataSourceImpl implements GeoRemoteDataSource {
  final Dio _dio;

  GeoRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> getAddressByCoordinates(String latitude, String longitude) async {
    // debugPrint('UserRemoteDataSourceImpl signIn - вызов dio');
    try {
      final Dio dio = _dio;
      final response = await dio.post(
        'https://geocode-maps.yandex.ru/v1/?apikey=$geoCoderApiKey&geocode=$latitude,$longitude&format=json',
      );
      debugPrint('🤍 GeoRemoteDataSourceImpl getAddressByCoordinates - получен response: $response');
      return response.data;
    } on DioException catch (e) {
      debugPrint('GeoRemoteDataSourceImpl getAddressByCoordinates - ошибка: $e');
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      debugPrint('GeoRemoteDataSourceImpl getAddressByCoordinates - ошибка: $e');
      throw Exception('Failed to get address by coordinates: $e');
    }
  }
}
