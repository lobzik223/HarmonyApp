import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/navigation_utils.dart';
import '../registration/registration_screen.dart';
import 'dart:ui' as ui;

/// Экран загрузки
/// Фон с градиентом точно как в SVG
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  // Автоматический переход убран - теперь переход только при нажатии на кнопку "Далее"
  late AnimationController _rotationController;
  bool _assetsLoaded = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    // Предзагрузка всех ресурсов для мгновенного отображения
    _preloadAssets();
  }

  Future<void> _preloadAssets() async {
    // Предзагрузка изображения для мгновенного отображения
    await precacheImage(
      const AssetImage('assets/icons/harmonyicon.png'),
      context,
    );
    
    // SVG загружается автоматически при отображении, предзагрузка не требуется
    
    // Все ресурсы загружены - контент отображается сразу
    if (mounted) {
      setState(() {
        _assetsLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Белый фон под изображением
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
          ),
          // Фоновое изображение
          Positioned.fill(
            child: Image.asset(
              'assets/images/loading_screen.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Ошибка загрузки фона: $error');
                return Container(
                  color: Colors.white,
                );
              },
            ),
          ),
          
          // Центральный контент (сдвинут вверх) - отображается сразу без задержек
          Center(
            child: Transform.translate(
              offset: const Offset(0, -100), // Поднимаем весь блок выше
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Логотип Harmony (увеличен и поднят выше) - предзагружен
                  Image.asset(
                    'assets/icons/harmonyicon.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                    cacheWidth: 200,
                    cacheHeight: 200,
                    errorBuilder: (context, error, stackTrace) {
                      print('Ошибка загрузки изображения: $error');
                      print('Путь: assets/icons/harmonyicon.png');
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.apps,
                          color: Colors.white,
                          size: 100,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 60), // Увеличен отступ между иконкой и текстами
                  
                  // Текст "HARMONY" с шрифтом Unbounded - предзагружен
                  Text(
                    'HARMONY',
                    style: GoogleFonts.unbounded(
                      fontSize: 36,
                      fontWeight: FontWeight.w500, // Medium (500)
                      height: 1.0, // 100%
                      letterSpacing: 0,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Текст "ОСОЗНАЙ ЭТОТ МОМЕНТ" с шрифтом Inter - предзагружен
                  Text(
                    'ОСОЗНАЙ ЭТОТ МОМЕНТ',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w400, // Regular
                      height: 1.0, // 100%
                      letterSpacing: 0.34, // 2% от 17px
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Кнопка "Далее" сверху
          SafeArea(
            child: Positioned(
              top: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    noAnimationRoute(const RegistrationScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Далее',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          
          // Индикатор загрузки внизу (SVG с угловым градиентом 66x66)
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Center(
              child: RotationTransition(
                turns: _rotationController,
                child: SvgPicture.asset(
                  'assets/icons/loading_indicator.svg',
                  width: 66,
                  height: 66,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  placeholderBuilder: (context) => const SizedBox(
                    width: 66,
                    height: 66,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

