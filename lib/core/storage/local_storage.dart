import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _tokenKey = 'jwt_token';
  static const _loginEmailKey = 'login_email';
  static const _themeModeKey = 'theme_mode';
  static const _loginRequestTokenKey = 'login_request_token';

  static Future<LocalStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorage(prefs);
  }

  String? readToken() => _prefs.getString(_tokenKey);

  Future<void> writeToken(String token) => _prefs.setString(_tokenKey, token);

  Future<void> clearToken() => _prefs.remove(_tokenKey);

  String? readLoginEmail() => _prefs.getString(_loginEmailKey);

  Future<void> writeLoginEmail(String email) =>
      _prefs.setString(_loginEmailKey, email);

  Future<void> clearLoginEmail() => _prefs.remove(_loginEmailKey);

  String? readLoginRequestToken() => _prefs.getString(_loginRequestTokenKey);

  Future<void> writeLoginRequestToken(String token) =>
      _prefs.setString(_loginRequestTokenKey, token);

  Future<void> clearLoginRequestToken() => _prefs.remove(_loginRequestTokenKey);

  Future<void> writeThemeMode(String mode) =>
      _prefs.setString(_themeModeKey, mode);

  String? readThemeMode() => _prefs.getString(_themeModeKey);
}
