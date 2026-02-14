import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SettingsLocalDataSource {
  Future<void> saveThemeMode(ThemeMode themeMode);
  Future<ThemeMode> getThemeMode();
  Future<void> saveLanguageCode(String languageCode);
  Future<String> getLanguageCode();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  SettingsLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    debugPrint('SettingsLocalDataSourceImpl: saveThemeMode: $themeMode');
    try {
      await _secureStorage.write(
        key: 'theme_mode',
        value: themeMode == ThemeMode.light || themeMode == ThemeMode.system ? 'light' : 'dark' );
    } catch (e, stackTrace) {
      debugPrint('SettingsLocalDataSourceImpl: error: $e');
      debugPrint('SettingsLocalDataSourceImpl: stackTrace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<ThemeMode> getThemeMode() async {
    try {
      final themeMode = await _secureStorage.read(key: 'theme_mode');
      if (themeMode != null) {
        return themeMode == 'light' ? ThemeMode.light : ThemeMode.dark;
      }
      // Если записи нет, возвращаем системную тему
      await saveThemeMode(ThemeMode.system);
      return ThemeMode.system;
    } catch (e) {
      debugPrint('SettingsLocalDataSourceImpl: getThemeMode error: $e');
      // В случае ошибки возвращаем системную тему
      return ThemeMode.system;
    }
  }

  @override
  Future<void> saveLanguageCode(String languageCode) async {
    debugPrint('🇷🇺🇺🇸 SettingsLocalDataSourceImpl: saveLanguageCode: $languageCode');
    await _secureStorage.write(key: 'language_code', value: languageCode);
  }

  @override
  Future<String> getLanguageCode() async {
    final language_code = await _secureStorage.read(key: 'language_code');
    if (language_code != null) {
      debugPrint('🇷🇺🇺🇸 SettingsLocalDataSourceImpl: language_code found: $language_code');
      return language_code;
    } else {
      saveLanguageCode('ru');
      debugPrint('🇷🇺🇺🇸 SettingsLocalDataSourceImpl: language_code not found, saving default language code: ru');
      return 'ru';
    }
  }
}
