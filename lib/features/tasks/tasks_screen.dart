import 'package:flutter/material.dart';
import 'dart:ui';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../../core/storage/tracker_dates_storage.dart';
import '../../shared/widgets/harmony_bottom_nav.dart';
import '../meditation/meditation_screen.dart';
import '../sleep/sleep_screen.dart';
import '../player/player_screen.dart';
import 'wishes_screen.dart';

/// Экран "Задания"
/// Фон: assets/images/fon1.jpg
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  /// Выбранные пользователем даты (множественный выбор, сохраняются локально).
  Set<DateTime> _selectedDates = {};

  String _getMonthName(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    switch (date.month) {
      case 1: return l10n.monthJanuary;
      case 2: return l10n.monthFebruary;
      case 3: return l10n.monthMarch;
      case 4: return l10n.monthApril;
      case 5: return l10n.monthMay;
      case 6: return l10n.monthJune;
      case 7: return l10n.monthJuly;
      case 8: return l10n.monthAugust;
      case 9: return l10n.monthSeptember;
      case 10: return l10n.monthOctober;
      case 11: return l10n.monthNovember;
      case 12: return l10n.monthDecember;
      default: return l10n.monthJanuary;
    }
  }

  String _getDayName(BuildContext context, int weekday) {
    final l10n = AppLocalizations.of(context)!;
    switch (weekday) {
      case 1: return l10n.dayMon;
      case 2: return l10n.dayTue;
      case 3: return l10n.dayWed;
      case 4: return l10n.dayThu;
      case 5: return l10n.dayFri;
      case 6: return l10n.daySat;
      case 7: return l10n.daySun;
      default: return l10n.dayMon;
    }
  }
  
  // Получаем даты для конкретного месяца с правильным началом недели
  List<DateTime?> _getMonthDates(DateTime month) {
    final dates = <DateTime?>[];
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    
    // Начинаем с понедельника недели, в которой находится первое число месяца
    int firstWeekday = firstDay.weekday; // 1 = понедельник, 7 = воскресенье
    DateTime startDate = firstDay.subtract(Duration(days: firstWeekday - 1));
    
    // Генерируем 6 недель (42 дня) для каждого месяца
    for (int i = 0; i < 42; i++) {
      final date = startDate.add(Duration(days: i));
      // Если дата вне текущего месяца, добавляем null
      if (date.month != month.month || date.year != month.year) {
        dates.add(null);
      } else {
        dates.add(date);
      }
    }
    
    return dates;
  }
  
  @override
  void initState() {
    super.initState();
    _loadSelectedDates();
  }

  Future<void> _loadSelectedDates() async {
    final dates = await TrackerDatesStorage.getSelectedDates();
    if (mounted) setState(() => _selectedDates = dates);
  }

  Future<void> _toggleDate(DateTime date) async {
    final normalized = DateTime(date.year, date.month, date.day);
    setState(() {
      if (_selectedDates.contains(normalized)) {
        _selectedDates.remove(normalized);
      } else {
        _selectedDates.add(normalized);
      }
    });
    await TrackerDatesStorage.setSelectedDates(_selectedDates);
  }

  void _handleBottomNavTap(HarmonyTab tab) {
    switch (tab) {
      case HarmonyTab.meditation:
        Navigator.of(context).push(
          noAnimationRoute(const MeditationScreen()),
        );
        break;
      case HarmonyTab.sleep:
        Navigator.of(context).push(
          noAnimationRoute(const SleepScreen()),
        );
        break;
      case HarmonyTab.home:
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const HomeScreen()),
        );
        break;
      case HarmonyTab.player:
        Navigator.of(context).push(
          noAnimationRoute(const PlayerScreen()),
        );
        break;
      case HarmonyTab.tasks:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Фоновое изображение на весь экран
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fon1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Заголовок "ТРЕКЕР ЗАНЯТИЙ" в верхней части слева
          Positioned(
            top: 62,
            left: 16,
            child: Text(
              AppLocalizations.of(context)!.activityTrackerTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 1.0, // 100%
                letterSpacing: 0.4, // 2% от 20px
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),

          // Элемент "Желания >" справа вверху
          Positioned(
            top: 60,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  noAnimationRoute(const WishesScreen()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.wishes,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          // Календарь (скроллируемый)
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            bottom: 100,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _buildMonthCalendar(),
            ),
          ),
          
          // Нижнее меню поверх изображения
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: HarmonyBottomNav(
              activeTab: HarmonyTab.tasks,
              onTabSelected: _handleBottomNavTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCalendar() {
    final year = DateTime.now().year;
    // Все 12 месяцев текущего года (январь — декабрь)
    final months = List.generate(12, (i) => DateTime(year, i + 1, 1));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: months.map((month) => _buildSingleMonth(month)).toList(),
      ),
    );
  }
  
  Widget _buildSingleMonth(DateTime month) {
    final calendarDates = _getMonthDates(month);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Название месяца и год
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 8),
          child: Text(
            '${_getMonthName(context, month)} ${month.year}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ),
        
        // Дни недели
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppLocalizations.of(context)!.dayMon,
            AppLocalizations.of(context)!.dayTue,
            AppLocalizations.of(context)!.dayWed,
            AppLocalizations.of(context)!.dayThu,
            AppLocalizations.of(context)!.dayFri,
            AppLocalizations.of(context)!.daySat,
            AppLocalizations.of(context)!.daySun,
          ].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        
        // Сетка дат
        ...List.generate(6, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (dayIndex) {
                final dateIndex = weekIndex * 7 + dayIndex;
                final date = calendarDates[dateIndex];
                
                if (date == null) {
                  return Expanded(child: Container());
                }
                
                final normalized = DateTime(date.year, date.month, date.day);
                final isSelected = _selectedDates.contains(normalized);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: GestureDetector(
                      onTap: () => _toggleDate(date),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                // Контент даты (только день)
                                Center(
                                  child: Text(
                                    date.day.toString().padLeft(2, '0'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                                
                                // Круг для выбора сверху
                                Positioned(
                                  top: 4,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Размытый зеленый круг (glow эффект) - только если выбран
                                          if (isSelected)
                                            Container(
                                              width: 14,
                                              height: 14,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF00FF1A),
                                                shape: BoxShape.circle,
                                              ),
                                              child: ClipOval(
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                  child: Container(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          // Круг с галочкой (зеленый если выбран, пустой с обводкой если нет)
                                          Container(
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: isSelected 
                                                  ? const Color(0xFF04FF5C)
                                                  : Colors.transparent,
                                              shape: BoxShape.circle,
                                              border: isSelected 
                                                  ? null 
                                                  : Border.all(
                                                      color: Colors.white.withOpacity(0.7),
                                                      width: 1.5,
                                                    ),
                                            ),
                                            child: isSelected
                                                ? const Icon(
                                                    Icons.check,
                                                    size: 7,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
        const SizedBox(height: 24),
      ],
    );
  }

}

