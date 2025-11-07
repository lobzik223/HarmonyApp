import 'package:flutter/material.dart';
import 'dart:ui';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../meditation/meditation_screen.dart';
import '../sleep/sleep_screen.dart';
import '../player/player_screen.dart';
import 'tasks_screen.dart';

/// Экран "Желания"
/// Фон: assets/images/fon1.jpg
class WishesScreen extends StatefulWidget {
  const WishesScreen({super.key});

  @override
  State<WishesScreen> createState() => _WishesScreenState();
}

class _WishesScreenState extends State<WishesScreen> {
  int _selectedSegment = 0; // 0 = Текущие, 1 = Исполненные

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

          // Заголовок с кнопкой "Назад" и текстом "ЖЕЛАНИЯ"
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Кнопка "Назад"
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Назад',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                // Центрированный заголовок "ЖЕЛАНИЯ"
                Expanded(
                  child: Center(
                    child: Text(
                      'ЖЕЛАНИЯ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                // Пустое место для балансировки
                const SizedBox(width: 80),
              ],
            ),
          ),

          // Виджет сегментированного контроля
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: _buildSegmentedControl(),
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

  Widget _buildSegmentedControl() {
    return Center(
      child: Container(
        width: 351,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Stack(
              children: [
                // Активный сегмент (белый фон)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: _selectedSegment == 0 ? 4 : 177.5,
                  top: 4,
                  child: Container(
                    width: 169.5,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                // Текст сегментов
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSegment = 0;
                          });
                        },
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            'Текущие',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _selectedSegment == 0
                                  ? const Color(0xFF202020)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSegment = 1;
                          });
                        },
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            'Исполненные',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _selectedSegment == 1
                                  ? const Color(0xFF202020)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
      offset: const Offset(12, -2), // Смещение вправо и вверх (немного влево)
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            noAnimationRoute(const TasksScreen()),
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Круг под иконкой (центрирован)
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(23),
              ),
            ),
            // Иконка книги (центрирована)
            Image.asset(
              'assets/icons/bookicon.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Ошибка загрузки изображения: $error');
                print('Путь: assets/icons/bookicon.png');
                return Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(14),
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

// Clipper для формы меню (копия из tasks_screen.dart)
class BottomMenuClipperTasks extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final scaleX = size.width / 375;
    final scaleY = size.height / 62;
    
    path.moveTo(338 * scaleX, 57.8165 * scaleY);
    path.cubicTo(
      354.016 * scaleX, 57.8165 * scaleY,
      367 * scaleX, 44.8328 * scaleY,
      367 * scaleX, 28.8165 * scaleY,
    );
    path.cubicTo(
      367 * scaleX, 18.3358 * scaleY,
      361.44 * scaleX, 9.15365 * scaleY,
      353.109 * scaleX, 4.05853 * scaleY,
    );
    path.cubicTo(
      351.816 * scaleX, 3.26764 * scaleY,
      352.311 * scaleX, 0.114056 * scaleY,
      353.825 * scaleX, 0.0308982 * scaleY,
    );
    path.cubicTo(
      365.334 * scaleX, -0.601449 * scaleY,
      375 * scaleX, 8.55308 * scaleY,
      375 * scaleX, 20.08 * scaleY,
    );
    path.lineTo(375 * scaleX, 69.8165 * scaleY);
    path.cubicTo(
      375 * scaleX, 74.2348 * scaleY,
      371.418 * scaleX, 77.8165 * scaleY,
      367 * scaleX, 77.8165 * scaleY,
    );
    path.lineTo(8 * scaleX, 77.8165 * scaleY);
    path.cubicTo(
      3.58172 * scaleX, 77.8165 * scaleY,
      0, 74.2348 * scaleY,
      0, 69.8165 * scaleY,
    );
    path.lineTo(0, 20.08 * scaleY);
    path.cubicTo(
      0, 8.55308 * scaleY,
      9.66565 * scaleX, -0.601449 * scaleY,
      21.1753 * scaleX, 0.0308974 * scaleY,
    );
    path.cubicTo(
      57.656 * scaleX, 2.03518 * scaleY,
      133.621 * scaleX, 5.81648 * scaleY,
      187.5 * scaleX, 5.81648 * scaleY,
    );
    path.cubicTo(
      219.096 * scaleX, 5.81648 * scaleY,
      258.286 * scaleX, 4.51614 * scaleY,
      292.656 * scaleX, 3.03637 * scaleY,
    );
    path.cubicTo(
      298.492 * scaleX, 2.7851 * scaleY,
      309 * scaleX, 22.9752 * scaleY,
      309 * scaleX, 28.8165 * scaleY,
    );
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

