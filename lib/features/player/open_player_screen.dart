import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/navigation_utils.dart';
import '../../main.dart';
import '../../shared/models/meditation_track.dart';
import '../../shared/widgets/harmony_bottom_nav.dart';
import '../meditation/meditation_screen.dart';
import '../sleep/sleep_screen.dart';
import '../tasks/tasks_screen.dart';

/// Полноэкранный плеер: фон — обложка трека, панель управления — стеклянная (glassmorphism),
/// при открытом плеере нижнее меню прозрачное, иконка плеера подсвечена синим.
class OpenPlayerScreen extends StatefulWidget {
  const OpenPlayerScreen({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.progress,
    required this.currentTime,
    required this.totalTime,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    this.tracks,
    this.initialIndex = 0,
  });

  final MeditationTrack track;
  final bool isPlaying;
  final double progress;
  final String currentTime;
  final String totalTime;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  /// Если задан — можно переключать треки внутри плеера; при закрытии вернётся [Navigator.pop] с id текущего трека.
  final List<MeditationTrack>? tracks;
  final int initialIndex;

  @override
  State<OpenPlayerScreen> createState() => _OpenPlayerScreenState();
}

class _OpenPlayerScreenState extends State<OpenPlayerScreen> {
  late bool _isPlaying;
  late double _progress;
  late int _currentIndex;

  List<MeditationTrack> get _tracks => widget.tracks ?? [widget.track];
  MeditationTrack get _track => _tracks[_currentIndex.clamp(0, _tracks.length - 1)];

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isPlaying;
    _progress = widget.progress;
    _currentIndex = widget.tracks != null
        ? widget.initialIndex.clamp(0, widget.tracks!.length - 1)
        : 0;
  }

  void _handlePlayPause() {
    setState(() => _isPlaying = !_isPlaying);
    widget.onPlayPause();
  }

  void _handlePrevious() {
    if (_tracks.length > 1 && _currentIndex > 0) {
      setState(() {
        _currentIndex = _currentIndex - 1;
        _progress = 0.0;
      });
    }
    if (widget.tracks == null) widget.onPrevious();
  }

  void _handleNext() {
    if (_tracks.length > 1 && _currentIndex < _tracks.length - 1) {
      setState(() {
        _currentIndex = _currentIndex + 1;
        _progress = 0.0;
      });
    }
    if (widget.tracks == null) widget.onNext();
  }

  void _handleBack() {
    if (widget.tracks != null) {
      Navigator.of(context).pop(_track.id);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _handleBottomNavTap(HarmonyTab tab) {
    if (widget.tracks != null) {
      Navigator.of(context).pop(_track.id);
    } else {
      Navigator.of(context).pop();
    }
    if (tab == HarmonyTab.meditation) {
      Navigator.of(context).push(noAnimationRoute(const MeditationScreen()));
    } else if (tab == HarmonyTab.sleep) {
      Navigator.of(context).push(noAnimationRoute(const SleepScreen()));
    } else if (tab == HarmonyTab.home) {
      Navigator.of(context).pushReplacement(noAnimationRoute(const HomeScreen()));
    } else if (tab == HarmonyTab.tasks) {
      Navigator.of(context).push(noAnimationRoute(const TasksScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Фон — обложка трека на весь экран, от края до края (как на макете)
          Positioned.fill(
            child: _buildBackground(),
          ),
          // Лёгкое затемнение сверху только для читаемости кнопки «Назад»
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Кнопка «Назад» — овальная светло-серая, тёмный текст (точь-в-точь как на макете)
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Material(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(24),
                  elevation: 0,
                  child: InkWell(
                    onTap: _handleBack,
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text(
                        AppLocalizations.of(context)!.back,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF424242),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Нижняя часть: панель плеера + нижнее меню
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, 28),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Слой стекла (блюр + полупрозрачность)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.42),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(28),
                                  topRight: Radius.circular(28),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Контент панели (увеличенная высота панели — отступы сверху и снизу)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 52,
                                  child: Text(
                                    widget.currentTime,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Expanded(child: _buildProgressBar()),
                                SizedBox(
                                  width: 52,
                                  child: Text(
                                    widget.totalTime,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.right,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 28),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _buildCoverThumbnail(56, 56),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _track.title.isEmpty ? AppLocalizations.of(context)!.trackTitlePlaceholder : _track.title,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _track.description.isEmpty ? AppLocalizations.of(context)!.artistPlaceholder : _track.description,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white.withOpacity(0.85),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildControlButton(
                                      icon: Icons.skip_previous,
                                      onTap: _handlePrevious,
                                    ),
                                    const SizedBox(width: 4),
                                    _buildControlButton(
                                      icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                                      onTap: _handlePlayPause,
                                      isCenter: true,
                                    ),
                                    const SizedBox(width: 4),
                                    _buildControlButton(
                                      icon: Icons.skip_next,
                                      onTap: _handleNext,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                HarmonyBottomNav(
                  activeTab: HarmonyTab.player,
                  onTabSelected: _handleBottomNavTap,
                  leadingEdgeCutoutTab: HarmonyTab.player,
                  glassStyle: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Прогресс-бар точь-в-точь как на второй фотке: проигранная часть — бирюзовая линия,
  /// непроигранная — светлая серая, круг того же цвета движется при прослушивании.
  Widget _buildProgressBar() {
    const double barHeight = 5;
    const double thumbRadius = 8;
    final double progress = _progress.clamp(0.0, 1.0);
    const Color teal = Color(0xFF46E4E3);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final thumbLeft = (width * progress).clamp(thumbRadius, width - thumbRadius);
        return Stack(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.none,
          children: [
            // Непроигранная часть — светлая серая (как на второй фотке)
            Container(
              height: barHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.45),
                borderRadius: BorderRadius.circular(barHeight / 2),
              ),
            ),
            // Проигранная часть — бирюзовая, как круг в баре
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: barHeight,
                decoration: BoxDecoration(
                  color: teal,
                  borderRadius: BorderRadius.circular(barHeight / 2),
                ),
              ),
            ),
            // Круг — того же цвета что и линия, движется при прослушивании
            Positioned(
              left: thumbLeft - thumbRadius,
              child: Container(
                width: thumbRadius * 2,
                height: thumbRadius * 2,
                decoration: BoxDecoration(
                  color: teal,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: teal.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackground() {
    final cover = _track.image;
    if (cover.isNotEmpty) {
      return Image.asset(
        cover,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _placeholderBackground(),
      );
    }
    return _placeholderBackground();
  }

  Widget _placeholderBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF44AAED),
            Color(0xFF2D6A8F),
            Color(0xFF1a3d52),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverThumbnail(double w, double h) {
    final cover = _track.image;
    if (cover.isNotEmpty) {
      return Image.asset(
        cover,
        width: w,
        height: h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _defaultCover(w, h),
      );
    }
    return _defaultCover(w, h);
  }

  Widget _defaultCover(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
        ),
      ),
      child: const Icon(Icons.headphones, color: Colors.white, size: 28),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isCenter = false,
  }) {
    final size = isCenter ? 32.0 : 26.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: size, color: Colors.white),
        ),
      ),
    );
  }
}
