import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

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
    if (kDebugMode) {
      debugPrint(
        '[AUTH][REGISTER][REQ] email=${email.trim().toLowerCase()} '
        'passLen=${password.length} appKeySet=${_key.isNotEmpty} url=$_base$_authPrefix/register',
      );
    }
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
    if (kDebugMode) {
      debugPrint('[AUTH][REGISTER][RES] status=${res.statusCode} body=${res.body}');
    }
    return _parseAuthResponse(res);
  }

  /// POST /api/auth/login
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    if (kDebugMode) {
      debugPrint(
        '[AUTH][LOGIN][REQ] email=${email.trim().toLowerCase()} '
        'passLen=${password.length} appKeySet=${_key.isNotEmpty} url=$_base$_authPrefix/login',
      );
    }
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
    if (kDebugMode) {
      debugPrint('[AUTH][LOGIN][RES] status=${res.statusCode} body=${res.body}');
    }
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
      return AuthResponse(success: false, error: 'Ошибка сервера');
    }
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final map = body is Map ? body as Map<String, dynamic> : null;
      if (map == null) return AuthResponse(success: false, error: 'Неверный ответ сервера');
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
    return AuthResponse(success: false, error: msg ?? 'Ошибка ${res.statusCode}');
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
