import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

/// Секция экрана "Выбор плана" (без изменения main.dart)
/// - Фон: assets/images/fon1.jpg (cover)
/// - Маленькая верхняя иконка бренда: assets/icons/harmonyicon.png
/// - Заголовок: "Чего ты хочешь достичь?" (верхний регистр, размер ~44, межстрочный 140%, letterSpacing ~2%)
/// - Кнопки как в макете (первая активная, остальные приглушены)
class PlanSelectionSection extends StatelessWidget {
  const PlanSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Фон
        Positioned.fill(
          child: Image.asset(
            'assets/images/fon1.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Ошибка загрузки фона: $error');
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Text(
                    'Фон не загружен',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
        // Контент
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Верхняя иконка бренда (увеличена)
              Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/icons/harmonyicon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Заголовок
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ЧЕГО ТЫ ХОЧЕШЬ',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.greatVibes(
                        fontSize: 28, // Еще меньше для первой строки
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        letterSpacing: 0.56, // 2% от 28px
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 8), // Небольшой отступ между строками
                    Text(
                      'ДОСТИЧЬ?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.greatVibes(
                        fontSize: 40, // Больше для второй строки
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        letterSpacing: 0.8, // 2% от 40px
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              // Кнопки
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _planButton(label: 'Гармония', enabled: true),
                    const SizedBox(height: 12),
                    _planButton(label: 'Финансы', enabled: false),
                    const SizedBox(height: 12),
                    _planButton(label: 'Здоровье', enabled: false),
                    const SizedBox(height: 12),
                    _planButton(label: 'Сон', enabled: false),
                    const SizedBox(height: 12),
                    _planButton(label: 'Любовь', enabled: false),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Продолжить',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none, // Убираем любые подчеркивания
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _planButton({required String label, required bool enabled}) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              decoration: TextDecoration.none, // Убираем любые подчеркивания
            ),
          ),
        ),
      ),
    );
  }
}


