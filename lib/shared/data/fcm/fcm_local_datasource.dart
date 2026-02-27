import 'package:shared_preferences/shared_preferences.dart';

abstract class FcmLocalDataSource {
  Future<void> saveFcmToken(String token);
  Future<String?> getFcmToken();
}

class FcmLocalDataSourceImpl implements FcmLocalDataSource {
  final SharedPreferences _prefs;
  static const _key = 'fcm_token';

  FcmLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveFcmToken(String token) async {
    await _prefs.setString(_key, token);
  }

  @override
  Future<String?> getFcmToken() async {
    return _prefs.getString(_key);
  }
}