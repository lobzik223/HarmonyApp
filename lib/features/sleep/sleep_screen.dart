import 'package:flutter/material.dart';
import 'dart:ui';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../meditation/meditation_screen.dart';
import '../tasks/tasks_screen.dart';

/// Экран "Сон"
/// Фон с градиентами точно как в SVG
class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Основной фон с диагональным градиентом
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3E43E9), // глубокий фиолетово-синий (верхний левый угол)
                  Color(0xFF5565F2), // холодный синий (28%)
                  Color(0xFF9AD3FF), // мягкий небесный (55%)
                  Color(0xFF39D8D0), // бирюза (правый низ)
                ],
                stops: [0.0, 0.28, 0.55, 1.0],
              ),
            ),
          ),
          
          // Бирюзовый блик справа-ниже
          // cx="92%" cy="70%" r="55%" в SVG
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.84, 0.4), // 92% x, 70% y (от центра)
                  radius: 0.55, // 55% от размера
                  colors: [
                    const Color(0xFF6AF4E8).withOpacity(0.50),
                    const Color(0xFF6AF4E8).withOpacity(0.10),
                    const Color(0xFF6AF4E8).withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // Заголовок "СОН" в верхней части
          Positioned(
            top: 62,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'СОН',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  height: 1.0, // 100%
                  letterSpacing: 0.4, // 2% от 20px
                  color: Colors.white, // rgba(255, 255, 255, 1)
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          
          // Нижнее меню поверх изображения
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 63,
              child: Stack(
                children: [
                  // Фоновое размытие с точной формой SVG
                  ClipPath(
                    clipper: BottomMenuClipperSleep(),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        width: double.infinity,
                        height: 63,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
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
                        // Вторая иконка - сон (выбрана) с кругом
                        _buildSleepIconWithCircle(context),
                        // Центральная кнопка (обычная иконка)
                        _buildCentralButtonAsIcon(context),
                        // Четвертая иконка - сон
                        _buildSleepIconSimple(),
                        // Правая иконка - книга
                        _buildBookIcon(context),
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

  Widget _buildSleepIconWithCircle(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-5, 0), // Смещение влево (меньше для смещения вправо)
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
          // Иконка сна (центрирована)
          Image.asset(
            'assets/icons/sleeplogo.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
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
        ],
      ),
    );
  }

  Widget _buildSleepIconSimple() {
    return Container(
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
    );
  }

  Widget _buildBookIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          noAnimationRoute(const TasksScreen()),
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

// Clipper для формы меню с вырезом под второй иконкой (сон)
// path d="M113 59C129.016 59 142 46.0163 142 30C142 29.7537 141.997 29.5082 141.991 29.2634C141.791 21.2528 148.805 6.51139 156.817 6.66878C167.516 6.87897 177.862 6.99998 187.5 6.99998C241.379 6.99998 317.344 3.21868 353.825 1.2144C365.334 0.582054 375 9.73658 375 21.2635V71C375 75.4183 371.418 79 367 79H8C3.58172 79 0 75.4183 0 71V21.2635C0 9.73658 9.66565 0.582053 21.1753 1.2144C33.8484 1.91067 51.2864 2.82139 70.9083 3.71354C78.9144 4.07756 84.8804 19.2678 84.129 27.2469C84.0436 28.1531 84 29.0714 84 30C84 46.0163 96.9837 59 113 59Z"
class BottomMenuClipperSleep extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final scaleX = size.width / 375;
    final scaleY = size.height / 63;
    
    // M113 59
    path.moveTo(113 * scaleX, 59 * scaleY);
    
    // C129.016 59 142 46.0163 142 30
    path.cubicTo(
      129.016 * scaleX, 59 * scaleY,
      142 * scaleX, 46.0163 * scaleY,
      142 * scaleX, 30 * scaleY,
    );
    
    // C142 29.7537 141.997 29.5082 141.991 29.2634
    path.cubicTo(
      142 * scaleX, 29.7537 * scaleY,
      141.997 * scaleX, 29.5082 * scaleY,
      141.991 * scaleX, 29.2634 * scaleY,
    );
    
    // C141.791 21.2528 148.805 6.51139 156.817 6.66878
    path.cubicTo(
      141.791 * scaleX, 21.2528 * scaleY,
      148.805 * scaleX, 6.51139 * scaleY,
      156.817 * scaleX, 6.66878 * scaleY,
    );
    
    // C167.516 6.87897 177.862 6.99998 187.5 6.99998
    path.cubicTo(
      167.516 * scaleX, 6.87897 * scaleY,
      177.862 * scaleX, 6.99998 * scaleY,
      187.5 * scaleX, 6.99998 * scaleY,
    );
    
    // C241.379 6.99998 317.344 3.21868 353.825 1.2144
    path.cubicTo(
      241.379 * scaleX, 6.99998 * scaleY,
      317.344 * scaleX, 3.21868 * scaleY,
      353.825 * scaleX, 1.2144 * scaleY,
    );
    
    // C365.334 0.582054 375 9.73658 375 21.2635
    path.cubicTo(
      365.334 * scaleX, 0.582054 * scaleY,
      375 * scaleX, 9.73658 * scaleY,
      375 * scaleX, 21.2635 * scaleY,
    );
    
    // V71 (вертикальная линия до y=71)
    path.lineTo(375 * scaleX, 71 * scaleY);
    
    // C375 75.4183 371.418 79 367 79
    path.cubicTo(
      375 * scaleX, 75.4183 * scaleY,
      371.418 * scaleX, 79 * scaleY,
      367 * scaleX, 79 * scaleY,
    );
    
    // H8 (горизонтальная линия до x=8)
    path.lineTo(8 * scaleX, 79 * scaleY);
    
    // C3.58172 79 0 75.4183 0 71
    path.cubicTo(
      3.58172 * scaleX, 79 * scaleY,
      0, 75.4183 * scaleY,
      0, 71 * scaleY,
    );
    
    // V21.2635 (вертикальная линия до y=21.2635)
    path.lineTo(0, 21.2635 * scaleY);
    
    // C0 9.73658 9.66565 0.582053 21.1753 1.2144
    path.cubicTo(
      0, 9.73658 * scaleY,
      9.66565 * scaleX, 0.582053 * scaleY,
      21.1753 * scaleX, 1.2144 * scaleY,
    );
    
    // C33.8484 1.91067 51.2864 2.82139 70.9083 3.71354
    path.cubicTo(
      33.8484 * scaleX, 1.91067 * scaleY,
      51.2864 * scaleX, 2.82139 * scaleY,
      70.9083 * scaleX, 3.71354 * scaleY,
    );
    
    // C78.9144 4.07756 84.8804 19.2678 84.129 27.2469
    path.cubicTo(
      78.9144 * scaleX, 4.07756 * scaleY,
      84.8804 * scaleX, 19.2678 * scaleY,
      84.129 * scaleX, 27.2469 * scaleY,
    );
    
    // C84.0436 28.1531 84 29.0714 84 30
    path.cubicTo(
      84.0436 * scaleX, 28.1531 * scaleY,
      84 * scaleX, 29.0714 * scaleY,
      84 * scaleX, 30 * scaleY,
    );
    
    // C84 46.0163 96.9837 59 113 59
    path.cubicTo(
      84 * scaleX, 46.0163 * scaleY,
      96.9837 * scaleX, 59 * scaleY,
      113 * scaleX, 59 * scaleY,
    );
    
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

