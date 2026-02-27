import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// import 'package:seabattle/shared/entities/game.dart';
// import 'package:seabattle/shared/entities/ship.dart';

abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> signIn(String login, String password);
  Future<Map<String, dynamic>> signUp(String name, String login, String email, String password, String photoPath);
  Future<bool> signOut(String token);
  Future<Map<String, dynamic>> getUserInfo(String token);
  Future<Map<String, dynamic>> updateUserInfo(String token, String userId, String name, String password, String passwordConfirm, {String? photoPath});
  Future<Map<String, dynamic>> getUserInfoById(String token, int userId);
  Future<Map<String, dynamic>> updateUserFcmToken(String token, String fcmToken);
  Future<Map<String, dynamic>> subscribeToUser(String token, int userId);
  Future<Map<String, dynamic>> unSubscribeFromUser(String token, int followedId);
  Future<Map<String, dynamic>> checkSubscription(String token, int followedId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> signIn(String login, String password) async {
    // debugPrint('UserRemoteDataSourceImpl signIn - вызов dio');
    try {
      final Dio dio = _dio;
      final response = await dio.post(
        '/api/auth/login',
        data: {
          'login': login,
          'password': password,
        },
      );
      debugPrint('🤍 UserRemoteDataSourceImpl signIn - получен response: $response');
      return response.data;
    } on DioException catch (e) {
      debugPrint('UserRemoteDataSourceImpl signIn - ошибка: $e');
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      debugPrint('UserRemoteDataSourceImpl signIn - ошибка: $e');
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> signUp(String name, String login, String email, String password, String photoPath) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'login': login,
        'email': email,
        'password': password,
      });

      // Добавляем фото, если оно передано
      if (photoPath.isNotEmpty) {
        final file = File(photoPath);
        if (await file.exists()) {
          formData.files.add(MapEntry(
            'photo',
            await MultipartFile.fromFile(
              photoPath,
              filename: photoPath.split('/').last,
            ),
          ));
        }
      }

      final Dio dio = _dio;
      final response = await dio.post(
        '/api/users',
        data: formData,
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<bool> signOut(String token) async {
    final Dio dio = _dio;
    final response = await dio.post(
      '/api/auth/logout',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['success'] == true;
  }

  @override
  Future<Map<String, dynamic>> getUserInfo(String token) async {
    try {
      final Dio dio = _dio;
      final response = await dio.get(
        '/api/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $token'})
      );
      debugPrint('💚 UserRemoteDataSourceImpl getUserInfo - получен response: $response');
      return response.data['user'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      throw Exception('Failed to get user info: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserInfo(
    String token,
    String userId,
    String name,
    String password,
    String passwordConfirm,
    {String? photoPath}
  ) async {
    try {
      final Dio dio = _dio;
      final formData = FormData.fromMap({
        'name': name,
        'password': password,
        'passwordConfirm': passwordConfirm,
      });

      // Добавляем фото, если оно передано
      if (photoPath != null && photoPath.isNotEmpty) {
        final file = File(photoPath);
        if (await file.exists()) {
          formData.files.add(MapEntry(
            'photo',
            await MultipartFile.fromFile(
              photoPath,
              filename: photoPath.split('/').last,
            ),
          ));
        }
      }

      final response = await dio.put(
        '/api/users/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: formData,
      );
      await Future.delayed(const Duration(milliseconds: 500));
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      throw Exception('Failed to update user info: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserInfoById(String token, int userId) async {
    try {
      final Dio dio = _dio;
      final response = await dio.get(
        '/api/users/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      throw Exception('Failed to get user info by id: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserFcmToken(String token, String fcmToken) async {
    try {
      final Dio dio = _dio;
      final response = await dio.put(
        '/api/users/fcm-token',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {'fcmToken': fcmToken},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      throw Exception('Failed to update user fcm token: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> subscribeToUser(String token, int userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final Dio dio = _dio;
      final response = await dio.post(
        '/api/followers',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {'followedId': userId},
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      throw Exception('Failed to subscribe to user: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> unSubscribeFromUser(String token, int followedId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final Dio dio = _dio;
      final response = await dio.delete(
        '/api/followers/$followedId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      throw Exception('Failed to unsubscribe from user: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> checkSubscription(String token, int followedId) async {
    try {
      final Dio dio = _dio;
      final response = await dio.get(
        '/api/followers/check/$followedId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      throw Exception('Failed to check subscription: $e');
    }
  }
}
