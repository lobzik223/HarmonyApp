import 'package:shared_preferences/shared_preferences.dart';

const _key = 'harmony_tracker_selected_dates';

/// Выбранные пользователем даты в трекере занятий (локально).
class TrackerDatesStorage {
  static Future<Set<DateTime>> getSelectedDates() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key);
    if (list == null) return {};
    final set = <DateTime>{};
    for (final s in list) {
      final d = DateTime.tryParse(s);
      if (d != null) set.add(DateTime(d.year, d.month, d.day));
    }
    return set;
  }

  static Future<void> setSelectedDates(Set<DateTime> dates) async {
    final prefs = await SharedPreferences.getInstance();
    final list = dates.map((d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}').toList();
    await prefs.setStringList(_key, list);
  }
}
