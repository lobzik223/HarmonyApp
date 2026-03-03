import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import '../auth/auth_storage.dart';
import '../../shared/models/meditation_track.dart';

const _apiPrefix = '/api';

/// Загрузка секций и треков с бэкенда. Заголовок X-Harmony-App-Key обязателен, если задан APP_KEY.
class ContentApi {
  static String get _base => AppConstants.baseUrl.replaceFirst(RegExp(r'/$'), '');
  static String get _key => AppConstants.appKey;

  static Future<Map<String, String>> _headers({bool withAuth = false}) async {
    final h = <String, String>{'Content-Type': 'application/json'};
    if (_key.isNotEmpty) h['X-Harmony-App-Key'] = _key;
    if (withAuth) {
      final token = await AuthStorage.getAccessToken();
      if (token != null && token.isNotEmpty) h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  static String mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$_base${path.startsWith('/') ? path : '/$path'}';
  }

  /// GET /api/content/sections?type=MEDITATION
  static Future<List<Map<String, dynamic>>> getSections({String? type}) async {
    final q = type != null ? '?type=${Uri.encodeComponent(type)}' : '';
    final res = await http
        .get(Uri.parse('$_base$_apiPrefix/content/sections$q'), headers: await _headers())
        .timeout(AppConstants.apiTimeout);
    if (res.statusCode != 200) throw Exception('Sections: ${res.statusCode}');
    final list = json.decode(res.body) as List<dynamic>;
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  /// GET /api/content/tracks
  static Future<List<Map<String, dynamic>>> getTracks({String? sectionId, String? type}) async {
    final params = <String, String>{};
    if (sectionId != null) params['sectionId'] = sectionId;
    if (type != null) params['type'] = type;
    final q = params.isEmpty ? '' : '?${params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}';
    final res = await http
        .get(Uri.parse('$_base$_apiPrefix/content/tracks$q'), headers: await _headers())
        .timeout(AppConstants.apiTimeout);
    if (res.statusCode != 200) throw Exception('Tracks: ${res.statusCode}');
    final list = json.decode(res.body) as List<dynamic>;
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  /// Секции с треками (для медитаций: type=MEDITATION). Маппинг в [MeditationTrack] по section.slug как category.
  static Future<List<MeditationTrack>> getMeditationTracks() async {
    final sections = await getSections(type: 'MEDITATION');
    final allTracks = <MeditationTrack>[];
    for (final section in sections) {
      final sectionId = section['id'] as String?;
      final slug = (section['slug'] as String?) ?? 'other';
      final tracks = await getTracks(sectionId: sectionId);
      for (final t in tracks) {
        allTracks.add(MeditationTrack.fromApiJson(t, category: slug));
      }
    }
    return allTracks;
  }

  /// Секции с треками для сна (type=SLEEP). Маппинг по section.slug (nightmare_exclusion, other_direction и т.д.).
  static Future<List<MeditationTrack>> getSleepTracks() async {
    final sections = await getSections(type: 'SLEEP');
    final allTracks = <MeditationTrack>[];
    for (final section in sections) {
      final sectionId = section['id'] as String?;
      final slug = (section['slug'] as String?) ?? 'other';
      final tracks = await getTracks(sectionId: sectionId);
      for (final t in tracks) {
        allTracks.add(MeditationTrack.fromApiJson(t, category: slug));
      }
    }
    return allTracks;
  }

  /// GET /api/content/home — главный экран: featured, recommended, emergency (статьи).
  static Future<Map<String, dynamic>> getHome() async {
    final res = await http
        .get(Uri.parse('$_base$_apiPrefix/content/home'), headers: await _headers())
        .timeout(AppConstants.apiTimeout);
    if (res.statusCode != 200) throw Exception('Home: ${res.statusCode}');
    return json.decode(res.body) as Map<String, dynamic>;
  }

  /// POST /api/content/tracks/:id/listen — учитывает уникальное прослушивание пользователя.
  static Future<void> registerTrackListen(String trackId) async {
    final res = await http
        .post(
          Uri.parse('$_base$_apiPrefix/content/tracks/$trackId/listen'),
          headers: await _headers(withAuth: true),
        )
        .timeout(AppConstants.apiTimeout);
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Track listen: ${res.statusCode}');
    }
  }
}
