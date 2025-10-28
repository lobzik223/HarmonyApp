import 'package:flutter/material.dart';
import 'dart:ui';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

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
      home: const HomeScreen(),
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
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Левая иконка - профиль (SVG)
                          _buildProfileIcon(),
                        // Вторая иконка - глаз
                        _buildMenuIcon(Icons.visibility_outlined),
                        // Центральная кнопка с градиентом
                        _buildCentralButton(),
                        // Четвертая иконка - чат
                        _buildMenuIcon(Icons.chat_bubble_outline),
                        // Правая иконка - настройки
                        _buildMenuIcon(Icons.tune),
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

  Widget _buildMenuIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildProfileIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomPaint(
        size: const Size(28, 28),
        painter: ProfileIconPainter(),
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
              'assets/icons/image-Photoroom.png',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Ошибка загрузки изображения: $error');
                print('Путь: assets/icons/image-Photoroom.png');
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

class ProfileIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.7;

    final path = Path();

    // Голова (круг)
    final headRadius = size.width * 0.104;
    path.addOval(Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.25),
      width: headRadius * 2,
      height: headRadius * 2,
    ));

    // Плечи и тело
    path.moveTo(size.width * 0.125, size.height * 0.708);
    path.cubicTo(
      size.width * 0.232, size.height * 0.654,
      size.width * 0.25, size.height * 0.64,
      size.width * 0.25, size.height * 0.625,
    );
    path.cubicTo(
      size.width * 0.25, size.height * 0.503,
      size.width * 0.339, size.height * 0.399,
      size.width * 0.459, size.height * 0.379,
    );
    path.cubicTo(
      size.width * 0.515, size.height * 0.374,
      size.width * 0.571, size.height * 0.374,
      size.width * 0.625, size.height * 0.379,
    );
    path.cubicTo(
      size.width * 0.661, size.height * 0.399,
      size.width * 0.75, size.height * 0.503,
      size.width * 0.75, size.height * 0.625,
    );
    path.cubicTo(
      size.width * 0.75, size.height * 0.64,
      size.width * 0.768, size.height * 0.654,
      size.width * 0.875, size.height * 0.708,
    );

    // Левая рука
    path.moveTo(size.width * 0.396, size.height * 0.667);
    path.cubicTo(
      size.width * 0.352, size.height * 0.717,
      size.width * 0.324, size.height * 0.752,
      size.width * 0.307, size.height * 0.785,
    );
    path.cubicTo(
      size.width * 0.307, size.height * 0.821,
      size.width * 0.307, size.height * 0.857,
      size.width * 0.302, size.height * 0.893,
    );
    path.cubicTo(
      size.width * 0.302, size.height * 0.929,
      size.width * 0.302, size.height * 0.965,
      size.width * 0.280, size.height * 0.965,
    );
    path.cubicTo(
      size.width * 0.258, size.height * 0.965,
      size.width * 0.236, size.height * 0.929,
      size.width * 0.236, size.height * 0.893,
    );
    path.cubicTo(
      size.width * 0.236, size.height * 0.857,
      size.width * 0.236, size.height * 0.821,
      size.width * 0.236, size.height * 0.785,
    );
    path.cubicTo(
      size.width * 0.236, size.height * 0.752,
      size.width * 0.208, size.height * 0.717,
      size.width * 0.164, size.height * 0.667,
    );

    // Правая рука
    path.moveTo(size.width * 0.458, size.height * 0.667);
    path.cubicTo(
      size.width * 0.502, size.height * 0.717,
      size.width * 0.530, size.height * 0.752,
      size.width * 0.547, size.height * 0.785,
    );
    path.cubicTo(
      size.width * 0.547, size.height * 0.821,
      size.width * 0.547, size.height * 0.857,
      size.width * 0.552, size.height * 0.893,
    );
    path.cubicTo(
      size.width * 0.552, size.height * 0.929,
      size.width * 0.552, size.height * 0.965,
      size.width * 0.574, size.height * 0.965,
    );
    path.cubicTo(
      size.width * 0.596, size.height * 0.965,
      size.width * 0.618, size.height * 0.929,
      size.width * 0.618, size.height * 0.893,
    );
    path.cubicTo(
      size.width * 0.618, size.height * 0.857,
      size.width * 0.618, size.height * 0.821,
      size.width * 0.618, size.height * 0.785,
    );
    path.cubicTo(
      size.width * 0.618, size.height * 0.752,
      size.width * 0.646, size.height * 0.717,
      size.width * 0.690, size.height * 0.667,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
