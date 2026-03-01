import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/player_track.dart';

const _key = 'harmony_recent_tracks';
const _maxCount = 15;

/// Последние 15 прослушанных треков, сохраняются локально на устройстве.
class RecentTracksStorage {
  static Future<List<PlayerTrack>> getRecentTracks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return [];
    try {
      final list = json.decode(jsonStr) as List<dynamic>?;
      if (list == null) return [];
      return list
          .map((e) {
            if (e is! Map<String, dynamic>) return null;
            final id = e['id'] as String?;
            final title = e['title'] as String?;
            final artist = e['artist'] as String?;
            if (id == null || title == null) return null;
            return PlayerTrack(
              id: id,
              title: title,
              artist: artist ?? 'Harmony',
            );
          })
          .whereType<PlayerTrack>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Добавить трек в начало списка (последний прослушанный — первый). Храним не более 15.
  static Future<void> addRecentTrack(PlayerTrack track) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getRecentTracks();
    final withoutThis = current.where((t) => t.id != track.id).toList();
    final updated = [track, ...withoutThis].take(_maxCount).toList();
    final list = updated
        .map((t) => {'id': t.id, 'title': t.title, 'artist': t.artist})
        .toList();
    await prefs.setString(_key, json.encode(list));
  }
}
