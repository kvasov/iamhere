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

  RequestOperation<ThemeMode> getThemeMode() async {
    try {
      final themeMode = await settingsLocalDataSource.getThemeMode();
      return Result.ok(themeMode);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to get theme mode: $e'));
    }
  }

  RequestOperation<void> saveLanguageCode(String languageCode) async {
    try {
      await settingsLocalDataSource.saveLanguageCode(languageCode);
      return Result.ok(null);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to save language code: $e'));
    }
  }

  RequestOperation<String> getLanguageCode() async {
    try {
      final languageCode = await settingsLocalDataSource.getLanguageCode();
      return Result.ok(languageCode);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to get language code: $e'));
    }
  }
}
