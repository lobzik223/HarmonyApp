import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/meditation_track.dart';

/// Мини-плеер, который отображается внизу экрана
class MiniPlayer extends StatelessWidget {
  final MeditationTrack? track;
  final VoidCallback? onPrevious;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final double progress; // 0.0 - 1.0
  final bool isPlaying;
  final String currentTime;
  final String totalTime;

  const MiniPlayer({
    super.key,
    this.track,
    this.onPrevious,
    this.onPlayPause,
    this.onNext,
    this.progress = 0.0,
    this.isPlaying = false,
    this.currentTime = '10:56',
    this.totalTime = '10:56',
  });

  @override
  Widget build(BuildContext context) {
    if (track == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0, // Начинаем с самого низа, чтобы белый фон продолжался под меню
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Основной контент плеера (над меню)
          Container(
            width: double.infinity, // Максимальная ширина без margin
            decoration: BoxDecoration(
              color: Colors.white, // Белый фон
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ), // Только верхние углы скруглены
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            // Прогресс-бар сверху с ручкой
            Container(
              height: 3,
              margin: const EdgeInsets.only(top: 0),
              child: Stack(
                children: [
                  // Фон прогресс-бара
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2), // Светло-серый на белом фоне
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  // Заполненная часть прогресс-бара
                  FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF4FC3F7), // Светло-синий
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  // Ручка прогресс-бара (кружок)
                  if (progress > 0.0)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Positioned(
                          left: constraints.maxWidth * progress.clamp(0.0, 1.0) - 5,
                          top: -4,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4FC3F7),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            // Основной контент плеера
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Увеличена высота и отступы
              child: Row(
                children: [
                  // Иконка альбома с наушниками (слева)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12), // Загнутые углы
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFB3E5FC), // Светло-синий
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Фоновые точки/частицы
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomPaint(
                              painter: ParticlesPainter(),
                            ),
                          ),
                        ),
                        // Иконка наушников
                        Center(
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                            ).createShader(bounds),
                            child: Icon(
                              Icons.headphones,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Название трека и время (центр)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          track!.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF202020), // Темно-серый
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentTime,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF757575), // Светло-серый
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Кнопки управления (справа)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Кнопка "Назад" (SVG иконка)
                      GestureDetector(
                        onTap: onPrevious,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: SvgPicture.asset(
                            'assets/icons/previous_button.svg',
                            width: 24,
                            height: 24,
                            placeholderBuilder: (context) => ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                              ).createShader(bounds),
                              child: const Icon(
                                Icons.skip_previous,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            colorFilter: null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      // Кнопка "Пауза/Воспроизведение"
                      GestureDetector(
                        onTap: onPlayPause,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: isPlaying
                              ? SvgPicture.asset(
                                  'assets/icons/pause_button.svg',
                                  width: 28,
                                  height: 28,
                                  placeholderBuilder: (context) => ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                                    ).createShader(bounds),
                                    child: const Icon(
                                      Icons.pause,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                  colorFilter: null,
                                )
                              : ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                                  ).createShader(bounds),
                                  child: Icon(
                                    Icons.play_arrow,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      // Кнопка "Вперед" (SVG иконка)
                      GestureDetector(
                        onTap: onNext,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: SvgPicture.asset(
                            'assets/icons/next_button.svg',
                            width: 24,
                            height: 24,
                            placeholderBuilder: (context) => ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                              ).createShader(bounds),
                              child: const Icon(
                                Icons.skip_next,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            colorFilter: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
          ),
          // Белый фон, продолжающийся под меню (высота меню 63)
          Container(
            height: 63,
            width: double.infinity,
            color: Colors.white, // Белый фон под меню
            margin: const EdgeInsets.symmetric(horizontal: 0), // Без отступов для полной ширины
          ),
        ],
      ),
    );
  }
}

/// Художник для рисования частиц/точек на фоне иконки альбома
class ParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Рисуем небольшие точки/частицы
    final particles = [
      Offset(size.width * 0.2, size.height * 0.25),
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.6),
      Offset(size.width * 0.3, size.height * 0.75),
    ];

    for (var particle in particles) {
      canvas.drawCircle(particle, 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

