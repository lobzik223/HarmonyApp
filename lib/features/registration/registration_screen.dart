import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../login/login_screen.dart';
import '../plan/plan_selection_section.dart';

/// Экран "Регистрации"
/// Фон с градиентом на основе SVG
class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

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
              'assets/images/registerfon.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Ошибка загрузки фона: $error');
                return Container(
                  color: Colors.white,
                );
              },
            ),
          ),
          // Контент
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  // Верхняя иконка бренда
                  Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/icons/harmonyicon.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Ошибка загрузки изображения: $error');
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Заголовок "РЕГИСТРАЦИЯ"
                  Text(
                    'РЕГИСТРАЦИЯ',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0.4,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Поля ввода
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildTextField('Имя'),
                        const SizedBox(height: 16),
                        _buildTextField('Фамилия'),
                        const SizedBox(height: 16),
                        _buildTextField('Телефон'),
                        const SizedBox(height: 16),
                        _buildTextField('Почта'),
                        const SizedBox(height: 32),
                        // Кнопка "Зарегистрироваться"
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF202020),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                noAnimationRoute(const PlanSelectionSection()),
                              );
                            },
                            child: Text(
                              'Зарегистрироваться',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF202020),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Текст "Уже есть аккаунт?"
                        Text(
                          'Уже есть аккаунт?',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Ссылка "Войти >"
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              noAnimationRoute(const LoginScreen()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Войти',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
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
                        const SizedBox(height: 48),
                        // Раздел "Или войдите с помощью:"
                        Text(
                          'Или войдите с помощью:',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Иконки социальных сетей
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialIcon('Google', Icons.g_mobiledata, Colors.white, const Color(0xFF4285F4)),
                            const SizedBox(width: 16),
                            _buildSocialIcon('VK', Icons.circle, const Color(0xFF0077FF), Colors.white),
                            const SizedBox(width: 16),
                            _buildSocialIcon('Yandex', Icons.circle, const Color(0xFFFC3F1D), Colors.white),
                          ],
                        ),
                        const SizedBox(height: 40),
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

  Widget _buildTextField(String hint) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8), // Radius: 8px
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Blur: 8px
        child: Container(
          height: 50, // Немного увеличена высота
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.4), // rgba(255, 255, 255, 0.4)
            borderRadius: BorderRadius.circular(8), // Radius: 8px
            // Нет границы
          ),
          child: TextField(
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF202020), // Темный текст для ввода
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF757575), // Серый цвет для placeholder
              ),
              contentPadding: const EdgeInsets.only(
                top: 13, // Top: 13px
                bottom: 13, // Bottom: 13px
                left: 16, // Left: 16px
                right: 16, // Right: 16px
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String name, IconData icon, Color iconColor, Color bgColor) {
    return GestureDetector(
      onTap: () {
        // Обработка входа через социальную сеть
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}

