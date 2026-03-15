import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../core/utils/navigation_utils.dart';
import '../../core/api/content_api.dart';
import '../../core/audio/audio_service.dart';
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
  late int _currentIndex;

  List<MeditationTrack> get _tracks => widget.tracks ?? [widget.track];
  MeditationTrack get _track => _tracks[_currentIndex.clamp(0, _tracks.length - 1)];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.tracks != null
        ? widget.initialIndex.clamp(0, widget.tracks!.length - 1)
        : 0;
    _registerOpenedTrack();
  }

  void _registerOpenedTrack() {
    if (_track.id.isEmpty) return;
    ContentApi.registerTrackListen(_track.id).catchError((_) {});
  }

  String _resolveTotalTime() {
    if (_track.durationSeconds != null && _track.durationSeconds! > 0) {
      return MeditationTrack.formatDuration(_track.durationSeconds);
    }
    return widget.totalTime;
  }

  void _handlePlayPause() {
    AudioService.instance.togglePlayPause();
    widget.onPlayPause();
  }

  void _handlePrevious() {
    if (_tracks.length > 1 && _currentIndex > 0) {
      setState(() => _currentIndex = _currentIndex - 1);
      final prev = _tracks[_currentIndex];
      AudioService.instance.setActiveTrack(prev, _tracks);
      if (prev.video.isNotEmpty) AudioService.instance.play(prev.video);
      _registerOpenedTrack();
    }
    if (widget.tracks == null) widget.onPrevious();
  }

  void _handleNext() {
    if (_tracks.length > 1 && _currentIndex < _tracks.length - 1) {
      setState(() => _currentIndex = _currentIndex + 1);
      final next = _tracks[_currentIndex];
      AudioService.instance.setActiveTrack(next, _tracks);
      if (next.video.isNotEmpty) AudioService.instance.play(next.video);
      _registerOpenedTrack();
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
          // Нижняя часть: стеклянная панель плеера + нижнее меню
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(0, 80),
                  child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: HarmonyBottomNav.totalHeight(context) - 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.24),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        border: Border(
                          top: BorderSide(color: Colors.white.withOpacity(0.22), width: 1),
                        ),
                      ),
                      child: ListenableBuilder(
                        listenable: AudioService.instance,
                        builder: (context, _) {
                          final svc = AudioService.instance;
                          final progress = svc.progress.clamp(0.0, 1.0);
                          final currentTime = svc.formattedPosition;
                          final totalTime = svc.formattedDuration != '0:00'
                              ? svc.formattedDuration
                              : _resolveTotalTime();
                          final isPlaying = svc.isPlaying;
                          final isLoading = svc.isLoading;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
                                child: _buildProgressBar(progress),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12, right: 12, top: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      currentTime,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.86),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      totalTime,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.86),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 8, 10, 14),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: _buildCoverThumbnail(52, 52),
                                    ),
                                    const SizedBox(width: 10),
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
                                              height: 1.1,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _track.description.isEmpty ? AppLocalizations.of(context)!.artistPlaceholder : _track.description,
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white.withOpacity(0.82),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (!isLoading) ...[
                                          _buildControlButton(
                                            icon: Icons.skip_previous_rounded,
                                            onTap: _handlePrevious,
                                          ),
                                        ],
                                        _buildControlButton(
                                          icon: isLoading
                                              ? Icons.play_arrow_rounded
                                              : (isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                                          onTap: isLoading ? () {} : _handlePlayPause,
                                          isCenter: true,
                                          isLoading: isLoading,
                                        ),
                                        if (!isLoading) ...[
                                          _buildControlButton(
                                            icon: Icons.skip_next_rounded,
                                            onTap: _handleNext,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
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

  /// Прогресс-бар: бирюзовая активная часть + серо-белая неактивная с круглым thumb.
  Widget _buildProgressBar(double progress) {
    const double barHeight = 4;
    const double thumbRadius = 7;
    final double p = progress.clamp(0.0, 1.0);
    const Color teal = Color(0xFF46E4E3);
    return LayoutBuilder(
      builder: (context, constraints) {
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
            // Непроигранная часть — светлая серая (как на второй фотке)
            Container(
              height: barHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(barHeight / 2),
              ),
            ),
            // Проигранная часть — бирюзовая, как круг в баре
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
            // Круг — того же цвета что и линия, движется при прослушивании
            Positioned(
              left: thumbLeft - thumbRadius,
              child: Container(
                width: thumbRadius * 2,
                height: thumbRadius * 2,
                decoration: BoxDecoration(
                  color: teal,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.95), width: 1.8),
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
    );
  }

  Widget _buildBackground() {
    final cover = _track.image;
    if (cover.isNotEmpty) {
      if (cover.startsWith('http')) {
        return Image.network(
          cover,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _placeholderBackground(),
        );
      }
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
      if (cover.startsWith('http')) {
        return Image.network(
          cover,
          width: w,
          height: h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _defaultCover(w, h),
        );
      }
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
    bool isLoading = false,
  }) {
    const teal = Color(0xFF46E4E3);
    final size = isCenter ? 36.0 : 24.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
          child: isLoading
              ? SizedBox(
                  width: size + 8,
                  height: size + 8,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: size,
                        height: size,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(teal),
                        ),
                      ),
                      Icon(icon, size: size * 0.6, color: teal),
                    ],
                  ),
                )
              : Icon(icon, size: size, color: Colors.white),
        ),
      ),
    );
  }
}
