import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class UserLocalDataSource {
  Future<void> saveUserToken(String token);
  Future<String?> getUserToken();
  Future<void> removeUserToken();
  // Future<bool> hasToken();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  UserLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveUserToken(String token) async {
    try {
      await _secureStorage.write(key: 'user_token', value: token);
    } catch (e) {
      throw Exception('Failed to save user token: $e');
    }
  }

  @override
  Future<String?> getUserToken() async {
    try {
      final token = await _secureStorage.read(key: 'user_token');
      return token;
    } catch (e) {
      debugPrint('UserLocalDataSourceImpl: getUserToken error: $e');
      return null;
    }
  }

  @override
  Future<void> removeUserToken() async {
    try {
      await _secureStorage.delete(key: 'user_token');
      debugPrint('💚 UserLocalDataSourceImpl: removeUserToken success');
    } catch (e) {
      debugPrint('❌ UserLocalDataSourceImpl: removeUserToken error: $e');
      throw Exception('Failed to remove token: $e');
    }
  }

  // @override
  // Future<bool> hasToken() async {
  //   try {
  //     return await TokenStorage.hasToken();
  //   } catch (e) {
  //     throw Exception('Failed to check token: $e');
  //   }
  // }
}