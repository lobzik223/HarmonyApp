import 'package:shared_preferences/shared_preferences.dart';

const _keyAccessToken = 'harmony_access_token';
const _keyRefreshToken = 'harmony_refresh_token';
const _keyUserEmail = 'harmony_user_email';
const _keyUserName = 'harmony_user_name';
const _keyUserSurname = 'harmony_user_surname';
const _keyProfilePhotoPath = 'harmony_profile_photo_path';

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
    String? userSurname,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    if (userEmail != null) await prefs.setString(_keyUserEmail, userEmail);
    if (userName != null) await prefs.setString(_keyUserName, userName);
    if (userSurname != null) await prefs.setString(_keyUserSurname, userSurname);
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserSurname);
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

  static Future<String?> getUserSurname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserSurname);
  }

  /// Путь к локальному фото профиля (только на устройстве, на сервер не загружается).
  static Future<String?> getProfilePhotoPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfilePhotoPath);
  }

  static Future<void> setProfilePhotoPath(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      await prefs.remove(_keyProfilePhotoPath);
    } else {
      await prefs.setString(_keyProfilePhotoPath, path);
    }
  }

  /// Обновить только имя/фамилию в локальном хранилище (после PATCH /me).
  static Future<void> saveUserProfile({String? name, String? surname}) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString(_keyUserName, name);
    if (surname != null) await prefs.setString(_keyUserSurname, surname);
  }
}
