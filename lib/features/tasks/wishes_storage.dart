import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'wish_model.dart';

const _key = 'harmony_wishes';

/// Локальное хранилище желаний пользователя.
class WishesStorage {
  static Future<List<Wish>> getWishes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return [];
    try {
      final list = json.decode(jsonStr) as List<dynamic>?;
      if (list == null) return [];
      return list
          .map<Wish?>((e) {
            if (e is! Map<String, dynamic>) return null;
            return Wish(
              id: e['id'] as String? ?? '',
              category: e['category'] as String? ?? '',
              title: e['title'] as String? ?? '',
              description: e['description'] as String? ?? '',
              isFulfilled: e['isFulfilled'] as bool? ?? false,
              isFavorite: e['isFavorite'] as bool? ?? false,
            );
          })
          .whereType<Wish>()
          .where((w) => w.id.isNotEmpty && w.title.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveWishes(List<Wish> wishes) async {
    final prefs = await SharedPreferences.getInstance();
    final list = wishes
        .map((w) => {
              'id': w.id,
              'category': w.category,
              'title': w.title,
              'description': w.description,
              'isFulfilled': w.isFulfilled,
              'isFavorite': w.isFavorite,
            })
        .toList();
    await prefs.setString(_key, json.encode(list));
  }
}
