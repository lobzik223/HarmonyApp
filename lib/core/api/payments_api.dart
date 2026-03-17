import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import '../auth/auth_storage.dart';

/// Product ID подписок — должны совпадать с Google Play Console и App Store Connect.
class IapProductIds {
  static const premiumMonth = 'harmony_premium_month';
  static const premiumYear = 'harmony_premium_year';
  static const proMonth = 'harmony_pro_month';
  static const pro3Months = 'harmony_pro_3months';
  static const pro6Months = 'harmony_pro_6months';
  static const proYear = 'harmony_pro_year';

  static const premiumIds = [premiumMonth, premiumYear];
  static const proIds = [proMonth, pro3Months, pro6Months, proYear];
  static const allIds = [...premiumIds, ...proIds];
}

const _apiPrefix = '/api';

/// Верификация покупок в приложении (Apple/Google) на бэкенде.
class PaymentsApi {
  static String get _base =>
      AppConstants.baseUrl.replaceFirst(RegExp(r'/$'), '');
  static String get _key => AppConstants.appKey;

  static Future<Map<String, String>> _headers() async {
    final h = <String, String>{'Content-Type': 'application/json'};
    if (_key.isNotEmpty) h['X-Harmony-App-Key'] = _key;
    final token = await AuthStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  /// POST /api/payments/apple/verify — верификация чека Apple и активация подписки.
  static Future<bool> verifyApple(String receiptData) async {
    final res = await http
        .post(
          Uri.parse('$_base$_apiPrefix/payments/apple/verify'),
          headers: await _headers(),
          body: jsonEncode({'receipt': receiptData}),
        )
        .timeout(AppConstants.apiTimeout);
    if (res.statusCode != 200 && res.statusCode != 201) return false;
    final map = json.decode(res.body) as Map<String, dynamic>?;
    return map?['success'] as bool? ?? false;
  }

  /// POST /api/payments/google/verify — верификация покупки Google и активация подписки.
  static Future<bool> verifyGoogle({
    required String purchaseToken,
    required String productId,
  }) async {
    final res = await http
        .post(
          Uri.parse('$_base$_apiPrefix/payments/google/verify'),
          headers: await _headers(),
          body: jsonEncode({
            'purchaseToken': purchaseToken,
            'productId': productId,
          }),
        )
        .timeout(AppConstants.apiTimeout);
    if (res.statusCode != 200 && res.statusCode != 201) return false;
    final map = json.decode(res.body) as Map<String, dynamic>?;
    return map?['success'] as bool? ?? false;
  }
}
