import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
// import 'package:seabattle/shared/entities/game.dart';
// import 'package:seabattle/shared/entities/ship.dart';

abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> signIn(String login, String password);
  Future<Map<String, dynamic>> signUp(String name, String login, String email, String password);
  Future<Map<String, dynamic>> getUserInfo(String token);
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
      // debugPrint('UserRemoteDataSourceImpl signIn - ошибка: $e');
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      // debugPrint('UserRemoteDataSourceImpl signIn - ошибка: $e');
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> signUp(String name, String login, String email, String password) async {
    try {
      final Dio dio = _dio;
      final response = await dio.post(
        '/api/users',
        data: {
          'name': name,
          'login': login,
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Network error');
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
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

  // @override
  // Future<Map<String, dynamic>> updateGame(int id, GameAction action, String userUniqueId) async {
  //   // debugPrint('QRRemoteDataSourceImpl updateGame - вызов dio');

  //   try {
  //     final Dio dio = _dio;
  //     Response<dynamic> response;
  //     switch (action) {
  //       case GameAction.accept:
  //         response = await dio.post(
  //           '/api/game/accept/$id',
  //           data: {
  //             'userUniqueId': userUniqueId,
  //           },
  //         );
  //         break;
  //       case GameAction.ready:
  //         response = await dio.post(
  //           '/api/game/ready/$id',
  //           data: {
  //             'userUniqueId': userUniqueId,
  //           },
  //         );
  //         break;
  //       case GameAction.cancel:
  //         response = await dio.post(
  //           '/api/game/cancel/$id',
  //           data: {
  //             'userUniqueId': userUniqueId,
  //           },
  //         );
  //         break;
  //       case GameAction.complete:
  //         response = await dio.post(
  //           '/api/game/complete/$id',
  //         );
  //         break;
  //     }

  //     // debugPrint('QRRemoteDataSourceImpl updateGame - получен response: $response');
  //     return response.data;
  //   } on DioException catch (e) {
  //     // debugPrint('QRRemoteDataSourceImpl createGame - ошибка: $e');
  //     throw Exception(e.response?.data['error'] ?? 'Network error');
  //   } catch (e) {
  //     // debugPrint('QRRemoteDataSourceImpl createGame - ошибка: $e');
  //     throw Exception('Failed to create game: $e');
  //   }
  // }

  // @override
  // Future<void> sendShipsToOpponent(int id, String userUniqueId, List<Ship> ships) async {
  //   try {
  //     final Dio dio = _dio;
  //     final data = jsonEncode({
  //       'userUniqueId': userUniqueId,
  //       'ships': ships.map((ship) => ship.toJson()).toList(),
  //     });
  //     await dio.post(
  //       '/api/game/send-ships-to-opponent/$id',
  //       data: data,
  //     );
  //   } on DioException catch (e) {
  //     throw Exception(e.response?.data['error'] ?? 'Network error');
  //   } catch (e) {
  //     throw Exception('Failed to send ships to opponent: $e');
  //   }
  // }
}
