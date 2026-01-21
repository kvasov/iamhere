import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:iamhere/app/db/database.dart';
import 'package:iamhere/core/di/injection_container.dart';

abstract class SettingsLocalDataSource {
  Future<void> saveThemeMode(ThemeMode themeMode);
  Future<ThemeMode> getThemeMode();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final AppDatabase _database;

  SettingsLocalDataSourceImpl({AppDatabase? database})
      : _database = database ?? sl<AppDatabase>();

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    debugPrint('SettingsLocalDataSourceImpl: saveThemeMode: $themeMode');
    try {
      // Проверяем, существует ли запись
      final existingSettings = await _database.select(_database.settings).getSingleOrNull();

      final themeModeValue = themeMode == ThemeMode.light ? true : false;

      if (existingSettings != null) {
        // Обновляем существующую запись
        await (_database.update(_database.settings)..where((tbl) => tbl.id.equals(existingSettings.id)))
            .write(SettingsCompanion(themeMode: Value(themeModeValue)));
        debugPrint('SettingsLocalDataSourceImpl: existing settings updated');
      } else {
        // Вставляем новую запись, если её нет
        await _database
          .into(_database.settings)
          .insert(
            SettingsCompanion.insert(
              themeMode: themeModeValue,
            ),
          );
        debugPrint('SettingsLocalDataSourceImpl: new settings inserted');
      }
    } catch (e, stackTrace) {
      debugPrint('SettingsLocalDataSourceImpl: error: $e');
      debugPrint('SettingsLocalDataSourceImpl: stackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    try {
      final setting = await _database.select(_database.settings).getSingleOrNull();
      if (setting != null) {
        return setting.themeMode == true ? ThemeMode.light : ThemeMode.dark;
      }
      // Если записи нет, возвращаем системную тему
      return ThemeMode.system;
    } catch (e) {
      debugPrint('SettingsLocalDataSourceImpl: getThemeMode error: $e');
      // В случае ошибки возвращаем системную тему
      return ThemeMode.system;
    }
  }
}
