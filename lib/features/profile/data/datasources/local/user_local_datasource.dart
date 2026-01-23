import 'package:drift/drift.dart';
import 'package:iamhere/app/db/database.dart';
import 'package:flutter/foundation.dart';

abstract class UserLocalDataSource {
  Future<void> saveUserToken(String token);
  Future<String?> getUserToken();
  Future<void> removeUserToken();
  // Future<bool> hasToken();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final AppDatabase _database;

  UserLocalDataSourceImpl(this._database);

  @override
  Future<void> saveUserToken(String token) async {
    try {
      // Проверяем, существует ли запись
      final existingUser = await _database.select(_database.users).getSingleOrNull();

      if (existingUser != null) {
        // Обновляем существующую запись
        await (_database.update(_database.users)..where((tbl) => tbl.id.equals(existingUser.id)))
            .write(UsersCompanion(token: Value(token)));
      } else {
        // Вставляем новую запись, если её нет
        await _database
            .into(_database.users)
            .insert(UsersCompanion.insert(token: Value(token)));
      }
    } catch (e) {
      throw Exception('Failed to save user token: $e');
    }
  }

  @override
  Future<String?> getUserToken() async {
    try {
      final user = await _database.select(_database.users).getSingleOrNull();
      return user?.token;
    } catch (e) {
      debugPrint('UserLocalDataSourceImpl: getUserToken error: $e');
      return null;
    }
  }

  @override
  Future<void> removeUserToken() async {
    try {
      await _database.delete(_database.users).go();
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