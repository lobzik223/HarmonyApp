import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

const _apiPrefix = '/api';
const _authPrefix = '$_apiPrefix/auth';

/// API авторизации: регистрация, вход, проверка токена.
class AuthApi {
  static String get _base => AppConstants.baseUrl.replaceFirst(RegExp(r'/$'), '');
  static String get _key => AppConstants.appKey;

  static Map<String, String> get _baseHeaders {
    final h = <String, String>{'Content-Type': 'application/json'};
    if (_key.isNotEmpty) h['X-Harmony-App-Key'] = _key;
    return h;
  }

  /// POST /api/auth/register
  static Future<AuthResponse> register({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    final res = await http
        .post(
          Uri.parse('$_base$_authPrefix/register'),
          headers: _baseHeaders,
          body: jsonEncode({
            'name': name.trim(),
            'surname': surname.trim(),
            'email': email.trim().toLowerCase(),
            'password': password,
          }),
        )
        .timeout(AppConstants.apiTimeout);
    return _parseAuthResponse(res);
  }

  /// POST /api/auth/login
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final res = await http
        .post(
          Uri.parse('$_base$_authPrefix/login'),
          headers: _baseHeaders,
          body: jsonEncode({
            'email': email.trim().toLowerCase(),
            'password': password,
          }),
        )
        .timeout(AppConstants.apiTimeout);
    return _parseAuthResponse(res);
  }

  /// GET /api/auth/me — проверка токена (Authorization: Bearer)
  static Future<Map<String, dynamic>?> me(String accessToken) async {
    final headers = {..._baseHeaders, 'Authorization': 'Bearer $accessToken'};
    final res = await http
        .get(Uri.parse('$_base$_authPrefix/me'), headers: headers)
        .timeout(AppConstants.apiTimeout);
    if (res.statusCode != 200) return null;
    return json.decode(res.body) as Map<String, dynamic>?;
  }

  static AuthResponse _parseAuthResponse(http.Response res) {
    dynamic body;
    try {
      body = json.decode(res.body);
    } catch (_) {
      return AuthResponse(success: false, error: 'Сервер вернул неверный ответ. Попробуйте позже.');
    }
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final map = body is Map ? body as Map<String, dynamic> : null;
      if (map == null) return AuthResponse(success: false, error: 'Сервер вернул неверный ответ. Попробуйте позже.');
      final user = map['user'] as Map<String, dynamic>?;
      return AuthResponse(
        success: true,
        accessToken: map['token'] as String? ?? '',
        refreshToken: map['refreshToken'] as String? ?? '',
        userEmail: user?['email'] as String? ?? '',
        userName: user?['name'] as String? ?? '',
      );
    }
    final map = body is Map ? body as Map<String, dynamic> : null;
    String? msg = map?['message'] as String? ?? map?['error']?.toString();
    if (msg == null && body is List && body.isNotEmpty) {
      final first = body[0];
      if (first is Map && first['message'] != null) msg = first['message'].toString();
    }
    final userMessage = _errorToRussian(res.statusCode, msg);
    return AuthResponse(success: false, error: userMessage);
  }

  /// Превращает код ответа и сообщение сервера в понятное описание на русском.
  static String _errorToRussian(int statusCode, String? serverMessage) {
    switch (statusCode) {
      case 400:
        return serverMessage?.isNotEmpty == true
            ? serverMessage!
            : 'Неверный запрос. Проверьте введённые данные.';
      case 401:
        return 'Сервер отклонил доступ. Проверьте адрес API и ключ приложения (HARMONY_APP_KEY) в настройках бэкенда.';
      case 403:
        return 'Доступ запрещён. Недостаточно прав.';
      case 404:
        return 'Сервис не найден. Проверьте подключение к интернету или попробуйте позже.';
      case 409:
        return 'Такой email уже зарегистрирован. Войдите или восстановите пароль.';
      case 422:
        return serverMessage?.isNotEmpty == true
            ? serverMessage!
            : 'Данные заполнены неверно. Проверьте поля и попробуйте снова.';
      case 429:
        return 'Слишком много попыток. Подождите немного и попробуйте снова.';
      case 500:
      case 502:
      case 503:
        return 'Временная ошибка на сервере. Попробуйте через несколько минут.';
    }
    if (serverMessage != null && serverMessage.isNotEmpty) {
      final m = serverMessage.toLowerCase();
      if (m.contains('unauthorized')) return 'Сервер отклонил доступ. Проверьте адрес API и ключ приложения (HARMONY_APP_KEY) в настройках бэкенда.';
      if (m.contains('forbidden')) return 'Доступ запрещён.';
      if (m.contains('not found')) return 'Сервис недоступен. Попробуйте позже.';
      if (m.contains('already exists') || m.contains('already registered')) return 'Такой email уже зарегистрирован. Войдите или восстановите пароль.';
      if (m.contains('invalid') || m.contains('invalid credentials')) return 'Неверная почта или пароль.';
      if (m.contains('network') || m.contains('connection') || m.contains('timeout')) return 'Нет соединения с интернетом. Проверьте сеть.';
      return serverMessage;
    }
    return 'Произошла ошибка (код $statusCode). Попробуйте ещё раз.';
  }
}

class AuthResponse {
  final bool success;
  final String? accessToken;
  final String? refreshToken;
  final String? userEmail;
  final String? userName;
  final String? error;

  AuthResponse({
    required this.success,
    this.accessToken,
    this.refreshToken,
    this.userEmail,
    this.userName,
    this.error,
  });
}
