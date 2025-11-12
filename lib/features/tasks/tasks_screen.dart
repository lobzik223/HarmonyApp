import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
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
        
        // Форматируем дату в формат DD.MM
        final day = currentDate.day.toString().padLeft(2, '0');
        final month = currentDate.month.toString().padLeft(2, '0');
        final dateStr = '$day.$month';
        
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

          // Заголовок "ГРАФИК ЗАДАНИЙ" в верхней части слева
          Positioned(
            top: 62,
            left: 16,
            child: Text(
              'ТРЕКЕР ЗАДАНИЙ',
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

          // Календарь с карточками дней
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: 62,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildCalendarGrid(),
            ),
          ),
          
          // Нижнее меню поверх изображения
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 62,
              child: Stack(
                children: [
                  // Фоновое размытие с точной формой SVG
                  ClipPath(
                    clipper: BottomMenuClipperTasks(),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        width: double.infinity,
                        height: 62,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  // Иконки меню
                  Positioned(
                    top: 5,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Левая иконка - медитация
                          _buildMeditationIcon(context),
                        // Вторая иконка - сон
                        _buildSleepIcon(context),
                        // Центральная кнопка (обычная иконка)
                        _buildCentralButtonAsIcon(context),
                        // Четвертая иконка - сон
                        _buildSleepIconSimple(context),
                        // Правая иконка - книга (выбрана) с кругом
                        _buildBookIconWithCircle(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildMeditationIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          noAnimationRoute(const MeditationScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/profileicon.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Ошибка загрузки изображения: $error');
              print('Путь: assets/icons/profileicon.png');
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSleepIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          noAnimationRoute(const SleepScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/sleeplogo.png',
            width: 28,
            height: 28,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Ошибка загрузки изображения: $error');
              print('Путь: assets/icons/sleeplogo.png');
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.bedtime,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSleepIconSimple(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          noAnimationRoute(const PlayerScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/mediaicon.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Ошибка загрузки изображения: $error');
              print('Путь: assets/icons/mediaicon.png');
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookIconWithCircle(BuildContext context) {
    return Transform.translate(
      offset: const Offset(16, -2), // Смещение вправо и вверх
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Круг под иконкой (центрирован)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          // Иконка книги (центрирована)
          Image.asset(
            'assets/icons/bookicon.png',
            width: 30,
            height: 30,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Ошибка загрузки изображения: $error');
              print('Путь: assets/icons/bookicon.png');
              return Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCentralButtonAsIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const HomeScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/harmonyicon.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Ошибка загрузки изображения: $error');
              print('Путь: assets/icons/harmonyicon.png');
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.image,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Clipper для формы меню с вырезом под правой иконкой (книга)
// path d="M338 57.8165C354.016 57.8165 367 44.8328 367 28.8165C367 18.3358 361.44 9.15365 353.109 4.05853C351.816 3.26764 352.311 0.114056 353.825 0.0308982C365.334 -0.601449 375 8.55308 375 20.08V69.8165C375 74.2348 371.418 77.8165 367 77.8165H8C3.58172 77.8165 0 74.2348 0 69.8165V20.08C0 8.55308 9.66565 -0.601449 21.1753 0.0308974C57.656 2.03518 133.621 5.81648 187.5 5.81648C219.096 5.81648 258.286 4.51614 292.656 3.03637C298.492 2.7851 309 22.9752 309 28.8165C309 44.8328 321.984 57.8165 338 57.8165Z"
class BottomMenuClipperTasks extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final scaleX = size.width / 375;
    final scaleY = size.height / 62;
    
    // M338 57.8165
    path.moveTo(338 * scaleX, 57.8165 * scaleY);
    
    // C354.016 57.8165 367 44.8328 367 28.8165
    path.cubicTo(
      354.016 * scaleX, 57.8165 * scaleY,
      367 * scaleX, 44.8328 * scaleY,
      367 * scaleX, 28.8165 * scaleY,
    );
    
    // C367 18.3358 361.44 9.15365 353.109 4.05853
    path.cubicTo(
      367 * scaleX, 18.3358 * scaleY,
      361.44 * scaleX, 9.15365 * scaleY,
      353.109 * scaleX, 4.05853 * scaleY,
    );
    
    // C351.816 3.26764 352.311 0.114056 353.825 0.0308982
    path.cubicTo(
      351.816 * scaleX, 3.26764 * scaleY,
      352.311 * scaleX, 0.114056 * scaleY,
      353.825 * scaleX, 0.0308982 * scaleY,
    );
    
    // C365.334 -0.601449 375 8.55308 375 20.08
    path.cubicTo(
      365.334 * scaleX, -0.601449 * scaleY,
      375 * scaleX, 8.55308 * scaleY,
      375 * scaleX, 20.08 * scaleY,
    );
    
    // V69.8165 (вертикальная линия до y=69.8165)
    path.lineTo(375 * scaleX, 69.8165 * scaleY);
    
    // C375 74.2348 371.418 77.8165 367 77.8165
    path.cubicTo(
      375 * scaleX, 74.2348 * scaleY,
      371.418 * scaleX, 77.8165 * scaleY,
      367 * scaleX, 77.8165 * scaleY,
    );
    
    // H8 (горизонтальная линия до x=8)
    path.lineTo(8 * scaleX, 77.8165 * scaleY);
    
    // C3.58172 77.8165 0 74.2348 0 69.8165
    path.cubicTo(
      3.58172 * scaleX, 77.8165 * scaleY,
      0, 74.2348 * scaleY,
      0, 69.8165 * scaleY,
    );
    
    // V20.08 (вертикальная линия до y=20.08)
    path.lineTo(0, 20.08 * scaleY);
    
    // C0 8.55308 9.66565 -0.601449 21.1753 0.0308974
    path.cubicTo(
      0, 8.55308 * scaleY,
      9.66565 * scaleX, -0.601449 * scaleY,
      21.1753 * scaleX, 0.0308974 * scaleY,
    );
    
    // C57.656 2.03518 133.621 5.81648 187.5 5.81648
    path.cubicTo(
      57.656 * scaleX, 2.03518 * scaleY,
      133.621 * scaleX, 5.81648 * scaleY,
      187.5 * scaleX, 5.81648 * scaleY,
    );
    
    // C219.096 5.81648 258.286 4.51614 292.656 3.03637
    path.cubicTo(
      219.096 * scaleX, 5.81648 * scaleY,
      258.286 * scaleX, 4.51614 * scaleY,
      292.656 * scaleX, 3.03637 * scaleY,
    );
    
    // C298.492 2.7851 309 22.9752 309 28.8165
    path.cubicTo(
      298.492 * scaleX, 2.7851 * scaleY,
      309 * scaleX, 22.9752 * scaleY,
      309 * scaleX, 28.8165 * scaleY,
    );
    
    // C309 44.8328 321.984 57.8165 338 57.8165
    path.cubicTo(
      309 * scaleX, 44.8328 * scaleY,
      321.984 * scaleX, 57.8165 * scaleY,
      338 * scaleX, 57.8165 * scaleY,
    );
    
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

