import 'package:flutter/material.dart';
import 'dart:ui';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/plan/plan_selection_section.dart';

void main() {
  runApp(const HarmonyApp());
}

class HarmonyApp extends StatelessWidget {
  const HarmonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const PlanSelectionSection(),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
                image: AssetImage('assets/images/window1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Верхняя иконка с кнопкой (слева)
          Positioned(
            top: 62,
            left: 16,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  'assets/icons/butonicon.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Ошибка загрузки изображения: $error');
                    print('Путь: assets/icons/butonicon.png');
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Верхняя иконка пользователя (справа)
          Positioned(
            top: 62,
            right: 16,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CustomPaint(
                  size: const Size(50, 50),
                  painter: UserTopIconPainter(),
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
              height: 62,
              child: Stack(
                children: [
                  // Фоновое размытие с точной формой SVG
                  ClipPath(
                    clipper: BottomMenuClipper(),
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
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Левая иконка - медитация
                          _buildMeditationIcon(),
                        // Вторая иконка - сон
                        _buildSleepIcon(),
                        // Центральная кнопка с градиентом
                        _buildCentralButton(),
                        // Четвертая иконка - плеер
                        _buildPlayerIcon(),
                        // Правая иконка - книга
                        _buildBookIcon(),
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

  Widget _buildMeditationIcon() {
    return Container(
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
    );
  }

  Widget _buildSleepIcon() {
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

  Widget _buildPlayerIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CustomPaint(
            size: const Size(28, 28),
            painter: PlayerIconPainter(),
          ),
        ),
      ),
    );
  }

  Widget _buildBookIcon() {
    return Container(
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
    );
  }

  Widget _buildCentralButton() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 30,
          height: 30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/icons/harmonyicon.png',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Ошибка загрузки изображения: $error');
                print('Путь: assets/icons/harmonyicon.png');
                // Если изображение не загружается, показываем иконку
                return Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.image,
                    color: Colors.blue,
                    size: 20,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class BottomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    
    // Точная форма по SVG координатам
    path.moveTo(21.1753 * width / 375, 0.0308974 * height / 62);
    path.cubicTo(
      9.66565 * width / 375, -0.601449 * height / 62,
      0, 8.55308 * height / 62,
      0, 20.08 * height / 62,
    );
    path.lineTo(0, 69.8165 * height / 62);
    path.cubicTo(
      0, 74.2348 * height / 62,
      3.58172 * height / 62, 77.8165 * height / 62,
      8 * height / 62, 77.8165 * height / 62,
    );
    path.lineTo(367 * width / 375, 77.8165 * height / 62);
    path.cubicTo(
      371.418 * height / 62, 77.8165 * height / 62,
      375 * width / 375, 74.2348 * height / 62,
      375 * width / 375, 69.8165 * height / 62,
    );
    path.lineTo(375 * width / 375, 20.08 * height / 62);
    path.cubicTo(
      375 * width / 375, 8.55308 * height / 62,
      365.334 * width / 375, -0.601448 * height / 62,
      353.825 * width / 375, 0.0308983 * height / 62,
    );
    path.cubicTo(
      325.867 * width / 375, 1.56691 * height / 62,
      274.72 * width / 375, 4.14658 * height / 62,
      228.096 * width / 375, 5.26815 * height / 62,
    );
    path.cubicTo(
      220.288 * width / 375, 5.45598 * height / 62,
      214.418 * width / 375, 19.1347 * height / 62,
      214.937 * width / 375, 26.9279 * height / 62,
    );
    path.cubicTo(
      214.979 * width / 375, 27.5521 * height / 62,
      215 * width / 375, 28.1818 * height / 62,
      215 * width / 375, 28.8165 * height / 62,
    );
    path.cubicTo(
      215 * width / 375, 44.2805 * height / 62,
      202.464 * width / 375, 56.8165 * height / 62,
      187 * width / 375, 56.8165 * height / 62,
    );
    path.cubicTo(
      171.536 * width / 375, 56.8165 * height / 62,
      159 * width / 375, 44.2805 * height / 62,
      159 * width / 375, 28.8165 * height / 62,
    );
    path.cubicTo(
      159 * width / 375, 28.1766 * height / 62,
      159.021 * width / 375, 27.5418 * height / 62,
      159.064 * width / 375, 26.9126 * height / 62,
    );
    path.cubicTo(
      159.587 * width / 375, 19.1192 * height / 62,
      153.725 * width / 375, 5.4352 * height / 62,
      145.917 * width / 375, 5.24419 * height / 62,
    );
    path.cubicTo(
      99.5592 * width / 375, 4.11023 * height / 62,
      48.9355 * width / 375, 1.55607 * height / 62,
      21.1753 * width / 375, 0.0308974 * height / 62,
    );
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



// Иконка пользователя для верхней части (50x50)
class UserTopIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // SVG координаты уже для 50x50, поэтому используем их напрямую
    final double scale = 1.0;
    
    // Фон - полупрозрачный черный круг
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    
    final backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.width / 2),
    );
    canvas.drawRRect(backgroundRect, backgroundPaint);
    
    // Белые контуры
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    // Голова - круг
    final headCenter = Offset(24.9999, 18);
    final headRadius = 4.66667;
    canvas.drawCircle(headCenter, headRadius, strokePaint);
    
    // Тело - путь
    final bodyPath = Path();
    bodyPath.moveTo(34.3334, 31.4167);
    bodyPath.cubicTo(
      34.3334, 34.3162,
      34.3334, 36.6667,
      25.0001, 36.6667,
    );
    bodyPath.cubicTo(
      15.6667, 36.6667,
      15.6667, 34.3162,
      15.6667, 31.4167,
    );
    bodyPath.cubicTo(
      15.6667, 28.5172,
      19.8454, 26.1667,
      25.0001, 26.1667,
    );
    bodyPath.cubicTo(
      30.1547, 26.1667,
      34.3334, 28.5172,
      34.3334, 31.4167,
    );
    bodyPath.close();
    
    canvas.drawPath(bodyPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Иконка плеера для нижнего меню
class PlayerIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Основной корпус плеера
    final playerPath = Path();
    playerPath.moveTo(size.width * 0.099, size.height * 0.292); // 2.781/28
    playerPath.cubicTo(
      size.width * 0.081, size.height * 0.444, // 2.26/28
      size.width * 0.071, size.height * 0.52, // 2.0/28
      size.width * 0.111, size.height * 0.334, // 3.106/28
    );
    playerPath.cubicTo(
      size.width * 0.15, size.height * 0.292, // 4.212/28
      size.width * 0.221, size.height * 0.292, // 6.18/28
      size.width * 0.361, size.height * 0.292, // 10.118/28
    );
    playerPath.lineTo(size.width * 0.639, size.height * 0.292); // 17.882/28
    playerPath.cubicTo(
      size.width * 0.779, size.height * 0.292, // 21.819/28
      size.width * 0.849, size.height * 0.292, // 23.788/28
      size.width * 0.889, size.height * 0.334, // 24.894/28
    );
    playerPath.cubicTo(
      size.width * 0.995, size.height * 0.52, // 25.0/28
      size.width * 0.929, size.height * 0.444, // 25.74/28
      size.width * 0.901, size.height * 0.292, // 25.22/28
    );
    playerPath.lineTo(size.width * 0.902, size.height * 0.7); // 24.726/28
    playerPath.cubicTo(
      size.width * 0.868, size.height * 0.803, // 24.318/28
      size.width * 0.868, size.height * 0.855, // 24.114/28
      size.width * 0.868, size.height * 0.857, // 23.067/28
    );
    playerPath.cubicTo(
      size.width * 0.786, size.height * 0.917, // 22.02/28
      size.width * 0.731, size.height * 0.917, // 20.476/28
      size.width * 0.621, size.height * 0.917, // 17.389/28
    );
    playerPath.lineTo(size.width * 0.379, size.height * 0.917); // 10.611/28
    playerPath.cubicTo(
      size.width * 0.269, size.height * 0.917, // 7.524/28
      size.width * 0.214, size.height * 0.917, // 5.98/28
      size.width * 0.176, size.height * 0.857, // 4.932/28
    );
    playerPath.cubicTo(
      size.width * 0.139, size.height * 0.855, // 3.886/28
      size.width * 0.132, size.height * 0.803, // 3.682/28
      size.width * 0.117, size.height * 0.7, // 3.274/28
    );
    playerPath.close();

    // Кнопка воспроизведения
    final playButtonPath = Path();
    playButtonPath.addOval(Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.708), // 19.833/28
      width: size.width * 0.125, // 3.5/28
      height: size.width * 0.125,
    ));

    // Кнопка громкости
    final volumePath = Path();
    volumePath.moveTo(size.width * 0.5, size.height * 0.438); // 12.25/28
    volumePath.lineTo(size.width * 0.5, size.height * 0.708); // 19.833/28
    volumePath.lineTo(size.width * 0.625, size.height * 0.562); // 17.5/28
    volumePath.lineTo(size.width * 0.625, size.height * 0.562); // 15.75/28

    // Верхняя часть
    final topPath = Path();
    topPath.moveTo(size.width * 0.815, size.height * 0.292); // 22.822/28
    topPath.cubicTo(
      size.width * 0.827, size.height * 0.237, // 23.089/28
      size.width * 0.783, size.height * 0.188, // 21.918/28
      size.width * 0.727, size.height * 0.188, // 20.372/28
    );
    topPath.lineTo(size.width * 0.272, size.height * 0.188); // 7.628/28
    topPath.cubicTo(
      size.width * 0.217, size.height * 0.188, // 6.082/28
      size.width * 0.175, size.height * 0.237, // 4.911/28
      size.width * 0.185, size.height * 0.292, // 5.178/28
    );

    // Нижняя часть
    final bottomPath = Path();
    bottomPath.moveTo(size.width * 0.729, size.height * 0.188); // 20.417/28
    bottomPath.cubicTo(
      size.width * 0.73, size.height * 0.177, // 20.45/28
      size.width * 0.73, size.height * 0.171, // 20.467/28
      size.width * 0.73, size.height * 0.167, // 20.467/28
    );
    bottomPath.cubicTo(
      size.width * 0.73, size.height * 0.124, // 20.469/28
      size.width * 0.657, size.height * 0.088, // 19.57/28
      size.width * 0.657, size.height * 0.084, // 18.382/28
    );
    bottomPath.cubicTo(
      size.width * 0.657, size.height * 0.083, // 18.258/28
      size.width * 0.657, size.height * 0.083, // 18.106/28
      size.width * 0.657, size.height * 0.083, // 17.802/28
    );
    bottomPath.lineTo(size.width * 0.364, size.height * 0.083); // 10.198/28
    bottomPath.cubicTo(
      size.width * 0.354, size.height * 0.083, // 9.894/28
      size.width * 0.348, size.height * 0.083, // 9.742/28
      size.width * 0.343, size.height * 0.084, // 9.618/28
    );
    bottomPath.cubicTo(
      size.width * 0.301, size.height * 0.088, // 8.43/28
      size.width * 0.269, size.height * 0.124, // 7.531/28
      size.width * 0.269, size.height * 0.167, // 7.533/28
    );
    bottomPath.cubicTo(
      size.width * 0.269, size.height * 0.171, // 7.533/28
      size.width * 0.27, size.height * 0.177, // 7.55/28
      size.width * 0.271, size.height * 0.188, // 7.583/28
    );

    canvas.drawPath(playerPath, paint);
    canvas.drawPath(playButtonPath, paint);
    canvas.drawPath(volumePath, paint);
    canvas.drawPath(topPath, paint);
    canvas.drawPath(bottomPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


