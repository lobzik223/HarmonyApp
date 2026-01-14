import 'package:flutter/material.dart';
import 'dart:ui';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../../shared/widgets/harmony_bottom_nav.dart';
import '../meditation/meditation_screen.dart';
import '../sleep/sleep_screen.dart';
import '../player/player_screen.dart';
import 'wishes_screen.dart';

/// Модель карточки дня для календаря
class DayCard {
  final String dayAbbreviation; // ПН, ВТ, СР...
  final String date; // 01.08
  final bool isCompleted; // Выполнено ли задание

  DayCard({
    required this.dayAbbreviation,
    required this.date,
    this.isCompleted = false,
  });
}

/// Экран "Задания"
/// Фон: assets/images/fon1.jpg
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  DateTime _selectedDate = DateTime.now(); // Выбранная дата в календаре
  
  // Даты с событиями (для зеленых точек) - для всех месяцев
  Set<DateTime> _getDatesWithEvents() {
    final now = DateTime.now();
    return {
      // Предыдущий месяц
      DateTime(now.year, now.month - 1, 2),
      DateTime(now.year, now.month - 1, 5),
      DateTime(now.year, now.month - 1, 8),
      DateTime(now.year, now.month - 1, 12),
      DateTime(now.year, now.month - 1, 15),
      DateTime(now.year, now.month - 1, 20),
      DateTime(now.year, now.month - 1, 25),
      // Текущий месяц
      DateTime(now.year, now.month, 2),
      DateTime(now.year, now.month, 3),
      DateTime(now.year, now.month, 4),
      DateTime(now.year, now.month, 5),
      DateTime(now.year, now.month, 6),
      DateTime(now.year, now.month, 7),
      DateTime(now.year, now.month, 9),
      DateTime(now.year, now.month, 11),
      DateTime(now.year, now.month, 13),
      DateTime(now.year, now.month, 14),
      DateTime(now.year, now.month, 18),
      DateTime(now.year, now.month, 22),
      DateTime(now.year, now.month, 28),
      // Следующий месяц
      DateTime(now.year, now.month + 1, 1),
      DateTime(now.year, now.month + 1, 5),
      DateTime(now.year, now.month + 1, 10),
      DateTime(now.year, now.month + 1, 15),
      DateTime(now.year, now.month + 1, 20),
      DateTime(now.year, now.month + 1, 25),
    };
  }
  
  // Получаем название месяца на русском
  String _getMonthName(DateTime date) {
    const months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[date.month - 1];
  }
  
  // Получаем сокращение дня недели для календаря
  String _getDayName(int weekday) {
    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return days[weekday - 1];
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
  
  // Генерируем карточки дней для календаря с реальными датами
  List<DayCard> _generateDayCards() {
    final cards = <DayCard>[];
    
    // Получаем текущую дату
    final now = DateTime.now();
    
    // Начинаем с первого дня текущего месяца
    final startDate = DateTime(now.year, now.month, 1);
    
    // Находим первый понедельник месяца (или первый день, если месяц начинается с понедельника)
    // В Dart: 1 = понедельник, 7 = воскресенье
    int firstDayOfWeek = startDate.weekday; // 1-7, где 1 = понедельник
    DateTime currentDate = startDate.subtract(Duration(days: firstDayOfWeek - 1));
    
    // Генерируем 10 недель (70 дней) - два блока по 5 недель
    for (int week = 0; week < 10; week++) {
      for (int dayOfWeek = 0; dayOfWeek < 7; dayOfWeek++) {
        // Получаем день недели (1 = понедельник, 7 = воскресенье)
        final weekday = currentDate.weekday;
        
        // Получаем сокращение дня недели на русском
        final dayAbbreviation = _getDayAbbreviation(weekday);
        
        // Форматируем дату - только день
        final day = currentDate.day.toString().padLeft(2, '0');
        final dateStr = day;
        
        // По умолчанию все карточки не выполнены
        cards.add(DayCard(
          dayAbbreviation: dayAbbreviation,
          date: dateStr,
          isCompleted: false,
        ));
        
        // Переходим к следующему дню
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
    
    return cards;
  }
  
  // Получаем сокращение дня недели на русском
  String _getDayAbbreviation(int weekday) {
    // weekday: 1 = понедельник, 2 = вторник, ..., 7 = воскресенье
    switch (weekday) {
      case 1:
        return 'ПН';
      case 2:
        return 'ВТ';
      case 3:
        return 'СР';
      case 4:
        return 'ЧТ';
      case 5:
        return 'ПТ';
      case 6:
        return 'СБ';
      case 7:
        return 'ВС';
      default:
        return 'ПН';
    }
  }

  final List<DayCard> _dayCards = [];

  @override
  void initState() {
    super.initState();
    _dayCards.addAll(_generateDayCards());
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
              'ТРЕКЕР ЗАНЯТИЙ',
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
                children: const [
                  Text(
                    'Желания',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          // Календарь сверху (скроллируемый)
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
    final now = DateTime.now();
    // Генерируем список месяцев: предыдущий, текущий, следующий
    final months = [
      DateTime(now.year, now.month - 1, 1), // Предыдущий месяц
      DateTime(now.year, now.month, 1),     // Текущий месяц
      DateTime(now.year, now.month + 1, 1), // Следующий месяц
    ];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: months.map((month) {
          return _buildSingleMonth(month);
        }).toList(),
      ),
    );
  }
  
  Widget _buildSingleMonth(DateTime month) {
    final calendarDates = _getMonthDates(month);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Название месяца
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 8),
          child: Text(
            _getMonthName(month),
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
          children: ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'].map((day) {
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
                
                final isSelected = date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;
                final hasEvent = _getDatesWithEvents().any((eventDate) =>
                    eventDate.year == date.year &&
                    eventDate.month == date.month &&
                    eventDate.day == date.day);
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
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
                                
                                // Зеленая точка для дат с событиями (справа вверху)
                                if (hasEvent && !isSelected)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF04FF5C),
                                        shape: BoxShape.circle,
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
        const SizedBox(height: 24), // Отступ между месяцами
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final rows = <Widget>[];
    
    // Разбиваем карточки на ряды по 7 штук
    for (int i = 0; i < _dayCards.length; i += 7) {
      final rowCards = _dayCards.sublist(
        i,
        i + 7 > _dayCards.length ? _dayCards.length : i + 7,
      );
      
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowCards.asMap().entries.map((entry) {
            final cardIndex = i + entry.key;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: _buildDayCard(_dayCards[cardIndex], cardIndex),
              ),
            );
          }).toList(),
        ),
      );
      
      // Добавляем разделительную линию только между двумя блоками (после 5-й недели)
      // После 5-й недели (i = 28 означает, что мы только что добавили 5-й ряд)
      if (i == 28 && i + 7 < _dayCards.length) {
        rows.add(_buildSeparatorLine());
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }

  Widget _buildDayCard(DayCard card, int cardIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _dayCards[cardIndex] = DayCard(
            dayAbbreviation: card.dayAbbreviation,
            date: card.date,
            isCompleted: !card.isCompleted,
          );
        });
      },
      child: Container(
        height: 40,
        margin: const EdgeInsets.only(bottom: 8),
        child: Stack(
          children: [
            // Фон карточки с blur эффектом
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 14),
                      // День недели (ПН, ВТ, СР...)
                      Text(
                        card.dayAbbreviation,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Дата (01.08)
                      Text(
                        card.date,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Значок в центре сверху (всегда видимый, зеленый только если активен)
            Positioned(
              top: 2,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 14,
                  height: 14,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Размытый зеленый круг (glow эффект) - только если активен
                      if (card.isCompleted)
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00FF1A),
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
                      // Круг с галочкой (зеленый если активен, пустой с обводкой если нет)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: card.isCompleted 
                              ? const Color(0xFF04FF5C)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: card.isCompleted 
                              ? null 
                              : Border.all(
                                  color: Colors.white.withOpacity(0.7),
                                  width: 1.5,
                                ),
                        ),
                        child: card.isCompleted
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
    );
  }

  Widget _buildSeparatorLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            width: double.infinity,
            height: 1,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }

}

