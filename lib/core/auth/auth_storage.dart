import 'package:shared_preferences/shared_preferences.dart';

const _keyAccessToken = 'harmony_access_token';
const _keyRefreshToken = 'harmony_refresh_token';
const _keyUserEmail = 'harmony_user_email';
const _keyUserName = 'harmony_user_name';

/// Хранение токенов и данных пользователя.
class AuthStorage {
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  static Future<void> saveAuth({
    required String accessToken,
    required String refreshToken,
    String? userEmail,
    String? userName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    if (userEmail != null) await prefs.setString(_keyUserEmail, userEmail);
    if (userName != null) await prefs.setString(_keyUserName, userName);
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
  }

  static Future<bool> hasAccount() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }
}
