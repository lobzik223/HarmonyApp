import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/audio/audio_service.dart';
import '../models/meditation_track.dart';

/// Мини-плеер, который отображается внизу экрана.
/// По нажатию на область плеера (не на кнопки) вызывается [onTap] — открытие полноэкранного плеера.
class MiniPlayer extends StatelessWidget {
  final MeditationTrack? track;
  final VoidCallback? onPrevious;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final VoidCallback? onTap;
  final double progress; // 0.0 - 1.0
  final bool isPlaying;
  final bool isLoading;
  final String currentTime;
  final String totalTime;
  /// Отступ снизу: ставим высоту нижней панели, чтобы белый фон плеера не перекрывал навбар.
  final double bottomOffset;
  /// Прозрачный стеклянный стиль (для главного окна плеера).
  final bool transparentStyle;
  /// Доп. смещение вниз (отрицательное = ниже).
  final double bottomOffsetAdjustment;

  const MiniPlayer({
    super.key,
    this.track,
    this.onPrevious,
    this.onPlayPause,
    this.onNext,
    this.onTap,
    this.progress = 0.0,
    this.isPlaying = false,
    this.isLoading = false,
    this.currentTime = '10:56',
    this.totalTime = '10:56',
    this.bottomOffset = 0.0,
    this.transparentStyle = false,
    this.bottomOffsetAdjustment = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    if (track == null) {
      return const SizedBox.shrink();
    }

    final double bottomPadding = bottomOffset + 20;
    return Positioned(
      bottom: bottomOffset - 28 + bottomOffsetAdjustment,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Основной контент плеера
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: (transparentStyle
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: bottomPadding),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.22),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          border: Border(
                            top: BorderSide(color: Colors.white.withOpacity(0.2), width: 1),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _playerContentChildren(),
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: bottomPadding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
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
                        children: _playerContentChildren(),
                      ),
                    )),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _playerContentChildren() => [
            // Прогресс-бар с кругом как в OpenPlayer (тап и перетаскивание для перемотки)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const double barHeight = 4;
                  const double thumbRadius = 7;
                  final double p = progress.clamp(0.0, 1.0);
                  const Color teal = Color(0xFF46E4E3);
                  final width = constraints.maxWidth;
                  final thumbLeft = (width * p).clamp(thumbRadius, width - thumbRadius);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (d) {
                      final x = d.localPosition.dx;
                      final newProgress = (x / width).clamp(0.0, 1.0);
                      AudioService.instance.seekTo(newProgress);
                    },
                    onPanStart: (d) {
                      final x = d.localPosition.dx;
                      final newProgress = (x / width).clamp(0.0, 1.0);
                      AudioService.instance.seekTo(newProgress);
                    },
                    onPanUpdate: (d) {
                      final x = d.localPosition.dx;
                      final newProgress = (x / width).clamp(0.0, 1.0);
                      AudioService.instance.seekTo(newProgress);
                    },
                    child: Stack(
                    alignment: Alignment.centerLeft,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: barHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: transparentStyle
                              ? Colors.white.withOpacity(0.55)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(barHeight / 2),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: p,
                        child: Container(
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: teal,
                            borderRadius: BorderRadius.circular(barHeight / 2),
                          ),
                        ),
                      ),
                      Positioned(
                        left: thumbLeft - thumbRadius,
                        child: Container(
                          width: thumbRadius * 2,
                          height: thumbRadius * 2,
                          decoration: BoxDecoration(
                            color: teal,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.95),
                              width: 1.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: teal.withOpacity(0.45),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  );
                },
              ),
            ),
            // Основной контент плеера
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Обложка трека или иконка наушников (слева)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: track!.image.isNotEmpty
                          ? (track!.image.startsWith('http')
                              ? Image.network(
                                  track!.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _buildHeadphonesPlaceholder(),
                                )
                              : Image.asset(
                                  track!.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _buildHeadphonesPlaceholder(),
                                ))
                          : _buildHeadphonesPlaceholder(),
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
                            color: transparentStyle ? Colors.white : const Color(0xFF202020),
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
                            color: transparentStyle ? Colors.white70 : const Color(0xFF757575),
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
                      if (!isLoading) ...[
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
                      ],
                      // Кнопка "Пауза/Воспроизведение" или индикатор загрузки
                      GestureDetector(
                        onTap: isLoading ? () {} : onPlayPause,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: isLoading
                              ? SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            transparentStyle ? Colors.white : const Color(0xFF46E4E3),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.play_arrow,
                                        size: 18,
                                        color: transparentStyle ? Colors.white : const Color(0xFF46E4E3),
                                      ),
                                    ],
                                  ),
                                )
                              : isPlaying
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
                      if (!isLoading) ...[
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
                    ],
                  ),
                ],
              ),
            ),
  ];

  Widget _buildHeadphonesPlaceholder() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB3E5FC),
            Colors.white,
          ],
        ),
      ),
      child: Stack(
        children: [
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

