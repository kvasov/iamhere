import 'package:flutter/material.dart';
import '../datasources/datasource_local.dart';
import 'package:iamhere/core/result.dart';

class SettingsRepository {
  final SettingsLocalDataSource settingsLocalDataSource;

  SettingsRepository({
    required this.settingsLocalDataSource,
  });

  RequestOperation<void> saveThemeMode(ThemeMode themeMode) async {
    try {
      await settingsLocalDataSource.saveThemeMode(themeMode);
      return Result.ok(null);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to save theme mode: $e'));
    }
  }
}
