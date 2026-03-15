import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../../core/api/content_api.dart';
import '../../core/audio/audio_service.dart';
import '../../shared/models/meditation_track.dart';
import '../../shared/widgets/mini_player.dart';
import '../../shared/widgets/harmony_bottom_nav.dart';
import '../sleep/sleep_screen.dart';
import '../tasks/tasks_screen.dart';
import '../player/player_screen.dart';
import '../player/open_player_screen.dart';

/// Экран "Медитации" — разделы и карточки с бэкенда.
class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  List<SectionWithTracks> _sections = [];
  List<MeditationTrack> _allTracks = [];
  String? _activeTrackId;
  bool _isPlaying = false;
  double _progress = 0.0;
  String _currentTime = '0:00';

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    try {
      final sections = await ContentApi.getSectionsWithTracks('MEDITATION');
      final allTracks = sections.expand((s) => s.tracks).toList();
      if (mounted) {
        setState(() {
          _sections = sections;
          _allTracks = allTracks;
          _activeTrackId = null;
          _isPlaying = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _sections = [];
          _allTracks = [];
        });
      }
    }
  }

  void _handleBottomNavTap(HarmonyTab tab) {
    switch (tab) {
      case HarmonyTab.meditation:
        return;
      case HarmonyTab.sleep:
        Navigator.of(context).push(
          noAnimationRoute(const SleepScreen()),
        );
        break;
      case HarmonyTab.home:
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const HomeScreen()),
        );
        break;
      case HarmonyTab.player:
        Navigator.of(context).push(
          noAnimationRoute(const PlayerScreen()),
        );
        break;
      case HarmonyTab.tasks:
        Navigator.of(context).push(
          noAnimationRoute(const TasksScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = (_activeTrackId != null ? 160.0 : 100.0);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFDDF3FF),
                  Color(0xFFCFEFFF),
                  Color(0xFFBCEFEF),
                  Color(0xFF7FE2DB),
                ],
                stops: [0.0, 0.35, 0.70, 1.0],
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.6, -0.8),
                  radius: 0.45,
                  colors: [
                    const Color(0xFFFFFFFF).withOpacity(0.65),
                    const Color(0xFFFFFFFF).withOpacity(0.12),
                    const Color(0xFFFFFFFF).withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.1, 0.7),
                  radius: 0.5,
                  colors: [
                    const Color(0xFFA9FFF7).withOpacity(0.35),
                    const Color(0xFFA9FFF7).withOpacity(0.08),
                    const Color(0xFFA9FFF7).withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                top: 62,
                bottom: bottomPadding + 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.meditationsTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: 0.4,
                        color: Color(0xFF202020),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  for (final section in _sections) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            section.name.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              letterSpacing: 0.28,
                              color: const Color(0xFF202020),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.all,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                  letterSpacing: 0.28,
                                  color: const Color(0xFF202020),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Color(0xFF202020),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    if (section.tracks.isNotEmpty)
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          itemCount: section.tracks.length,
                          itemBuilder: (context, index) {
                            final track = section.tracks[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_activeTrackId == track.id) {
                                    _isPlaying = !_isPlaying;
                                    AudioService.instance.togglePlayPause();
                                  } else {
                                    _activeTrackId = track.id;
                                    _isPlaying = true;
                                    _progress = 0.0;
                                    if (track.video.isNotEmpty) {
                                      AudioService.instance.play(track.video);
                                    }
                                  }
                                });
                              },
                              child: _buildTrackCard(track),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 40),
                  ],
                ],
              ),
            ),
          ),
          if (_activeTrackId != null)
            ListenableBuilder(
              listenable: AudioService.instance,
              builder: (context, _) {
                final svc = AudioService.instance;
                final active = _allTracks.firstWhere(
                  (t) => t.id == _activeTrackId,
                  orElse: () => _allTracks.isNotEmpty
                      ? _allTracks.first
                      : MeditationTrack(
                          id: '',
                          title: '',
                          description: '',
                          level: '',
                          image: '',
                          video: '',
                          type: '',
                          category: '',
                          isPremium: false,
                          isPlaying: false,
                        ),
                );
                return MiniPlayer(
                  bottomOffset: HarmonyBottomNav.miniPlayerBottomOffset(context),
                  track: active,
                  isPlaying: svc.isPlaying,
                  progress: svc.progress,
                  currentTime: svc.formattedPosition,
                  totalTime: active.durationSeconds != null
                      ? MeditationTrack.formatDuration(active.durationSeconds)
                      : svc.formattedDuration,
                  onTap: () {
                    final idx = _allTracks.indexWhere((t) => t.id == _activeTrackId);
                    final t = idx >= 0 ? _allTracks[idx] : _allTracks.first;
                    Navigator.of(context).push<String>(
                      MaterialPageRoute(
                        builder: (context) => OpenPlayerScreen(
                          track: t,
                          tracks: _allTracks,
                          initialIndex: idx >= 0 ? idx : 0,
                          isPlaying: svc.isPlaying,
                          progress: svc.progress,
                          currentTime: svc.formattedPosition,
                          totalTime: t.durationSeconds != null
                              ? MeditationTrack.formatDuration(t.durationSeconds)
                              : svc.formattedDuration,
                          onPlayPause: () {
                            AudioService.instance.togglePlayPause();
                            setState(() => _isPlaying = svc.isPlaying);
                          },
                          onPrevious: () {
                            if (idx > 0) {
                              final prev = _allTracks[idx - 1];
                              setState(() {
                                _activeTrackId = prev.id;
                                _isPlaying = true;
                                _progress = 0.0;
                              });
                              if (prev.video.isNotEmpty) AudioService.instance.play(prev.video);
                            }
                          },
                          onNext: () {
                            if (idx < _allTracks.length - 1) {
                              final next = _allTracks[idx + 1];
                              setState(() {
                                _activeTrackId = next.id;
                                _isPlaying = true;
                                _progress = 0.0;
                              });
                              if (next.video.isNotEmpty) AudioService.instance.play(next.video);
                            }
                          },
                        ),
                      ),
                    ).then((newActiveId) {
                      if (newActiveId != null && mounted) {
                        setState(() => _activeTrackId = newActiveId);
                      }
                    });
                  },
                  onPlayPause: () {
                    AudioService.instance.togglePlayPause();
                    setState(() => _isPlaying = AudioService.instance.isPlaying);
                  },
                  onPrevious: () {
                    final idx = _allTracks.indexWhere((t) => t.id == _activeTrackId);
                    if (idx > 0) {
                      final prev = _allTracks[idx - 1];
                      setState(() {
                        _activeTrackId = prev.id;
                        _isPlaying = true;
                        _progress = 0.0;
                      });
                      if (prev.video.isNotEmpty) AudioService.instance.play(prev.video);
                    }
                  },
                  onNext: () {
                    final idx = _allTracks.indexWhere((t) => t.id == _activeTrackId);
                    if (idx >= 0 && idx < _allTracks.length - 1) {
                      final next = _allTracks[idx + 1];
                      setState(() {
                        _activeTrackId = next.id;
                        _isPlaying = true;
                        _progress = 0.0;
                      });
                      if (next.video.isNotEmpty) AudioService.instance.play(next.video);
                    }
                  },
                );
              },
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: HarmonyBottomNav(
              activeTab: HarmonyTab.meditation,
              onTabSelected: _handleBottomNavTap,
              iconsBlack: _activeTrackId != null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackCard(MeditationTrack track) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 145,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[300],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: track.image.isNotEmpty
                      ? Image.network(
                          track.image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[300],
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
                if (track.isPremium)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                        child: Container(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          'assets/icons/meditationicon.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.self_improvement, size: 16, color: Color(0xFF202020)),
                        ),
                      ),
                    ),
                  ),
                ),
                if (track.isPremium)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 62,
                    child: Center(child: _buildPremiumTrackBadge()),
                  )
                else
                  Center(
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF000000).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: (_activeTrackId == track.id && _isPlaying)
                              ? const Icon(Icons.pause, size: 16, color: Colors.white)
                              : const Icon(Icons.play_arrow, size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            track.title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF202020),
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            track.description,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF202020),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTrackBadge() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: Color(0xFF4DB2EA),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: Image.asset(
                'assets/icons/harmonyicon.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.auto_awesome, color: Colors.white, size: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: -2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF46AEE8), Color(0xFF46E4E3)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            AppLocalizations.of(context)!.premiumBadge,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}
