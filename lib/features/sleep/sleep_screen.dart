import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../../core/api/content_api.dart';
import '../../shared/models/meditation_track.dart';
import '../../shared/widgets/mini_player.dart';
import '../../shared/widgets/harmony_bottom_nav.dart';
import '../meditation/meditation_screen.dart';
import '../tasks/tasks_screen.dart';
import '../player/player_screen.dart';
import '../player/open_player_screen.dart';

/// Экран "Сон"
/// Фон с градиентами точно как в SVG
class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  List<MeditationTrack> _nightmareExclusionTracks = [];
  List<MeditationTrack> _otherDirectionTracks = [];
  List<MeditationTrack> _allTracks = [];
  String? _activeTrackId;
  bool _isPlaying = false;
  double _progress = 0.0;
  String _currentTime = '2:23:65';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTracks() async {
    try {
      final allTracks = await ContentApi.getSleepTracks();
      final nightmareExclusion = allTracks.where((track) => track.category == 'nightmare_exclusion').toList();
      final otherDirection = allTracks.where((track) => track.category == 'other_direction').toList();
      if (mounted) {
        setState(() {
          _nightmareExclusionTracks = nightmareExclusion;
          _otherDirectionTracks = otherDirection;
          _allTracks = allTracks;
          _activeTrackId = null;
          _isPlaying = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _nightmareExclusionTracks = [];
          _otherDirectionTracks = [];
          _allTracks = [];
        });
      }
    }
  }

  void _handleBottomNavTap(HarmonyTab tab) {
    switch (tab) {
      case HarmonyTab.meditation:
        Navigator.of(context).push(
          noAnimationRoute(const MeditationScreen()),
        );
        break;
      case HarmonyTab.sleep:
        return;
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
          // Основной фон с диагональным градиентом
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3E43E9), // глубокий фиолетово-синий (верхний левый угол)
                  Color(0xFF5565F2), // холодный синий (28%)
                  Color(0xFF9AD3FF), // мягкий небесный (55%)
                  Color(0xFF39D8D0), // бирюза (правый низ)
                ],
                stops: [0.0, 0.28, 0.55, 1.0],
              ),
            ),
          ),
          
          // Бирюзовый блик справа-ниже
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.84, 0.4),
                  radius: 0.55,
                  colors: [
                    const Color(0xFF6AF4E8).withOpacity(0.50),
                    const Color(0xFF6AF4E8).withOpacity(0.10),
                    const Color(0xFF6AF4E8).withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // Скроллируемый контент
          Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            interactive: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 62,
                  bottom: bottomPadding + 20, // Отступ снизу
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // Заголовок "СОН"
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.sleepTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: 0.4,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Раздел "ИСКЛЮЧЕНИЕ КОШМАРОВ"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.nightmareExclusion,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                            letterSpacing: 0.28,
                            color: Colors.white,
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
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Карточки треков для раздела "ИСКЛЮЧЕНИЕ КОШМАРОВ"
                  if (_nightmareExclusionTracks.isNotEmpty)
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: _nightmareExclusionTracks.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_activeTrackId == _nightmareExclusionTracks[index].id) {
                                  _isPlaying = !_isPlaying;
                                } else {
                                  _activeTrackId = _nightmareExclusionTracks[index].id;
                                  _isPlaying = true;
                                  _progress = 0.0;
                                }
                              });
                            },
                            child: _buildTrackCard(_nightmareExclusionTracks[index]),
                          );
                        },
                      ),
                    ),
                  
                  const SizedBox(height: 40),
                  
                  // Раздел "ДРУГОЕ НАПРАВЛЕНИЕ"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.otherDirection,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                            letterSpacing: 0.28,
                            color: Colors.white,
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
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Карточки треков для раздела "ДРУГОЕ НАПРАВЛЕНИЕ"
                  if (_otherDirectionTracks.isNotEmpty)
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: _otherDirectionTracks.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_activeTrackId == _otherDirectionTracks[index].id) {
                                  _isPlaying = !_isPlaying;
                                } else {
                                  _activeTrackId = _otherDirectionTracks[index].id;
                                  _isPlaying = true;
                                  _progress = 0.0;
                                }
                              });
                            },
                            child: _buildTrackCard(_otherDirectionTracks[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Мини-плеер
          if (_activeTrackId != null)
            MiniPlayer(
              bottomOffset: HarmonyBottomNav.miniPlayerBottomOffset(context),
              track: _allTracks.firstWhere(
                (t) => t.id == _activeTrackId,
                orElse: () => _allTracks.isNotEmpty ? _allTracks.first : MeditationTrack(
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
              ),
              isPlaying: _isPlaying,
              progress: _progress,
              currentTime: _currentTime,
              totalTime: '3:42',
              onTap: () {
                final idx = _allTracks.indexWhere((t) => t.id == _activeTrackId);
                final t = idx >= 0 ? _allTracks[idx] : _allTracks.first;
                Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (context) => OpenPlayerScreen(
                      track: t,
                      tracks: _allTracks,
                      initialIndex: idx >= 0 ? idx : 0,
                      isPlaying: _isPlaying,
                      progress: _progress,
                      currentTime: _currentTime,
                      totalTime: '3:42',
                      onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
                      onPrevious: () {
                        if (_activeTrackId != null && idx > 0) {
                          setState(() {
                            _activeTrackId = _allTracks[idx - 1].id;
                            _isPlaying = true;
                            _progress = 0.0;
                          });
                        }
                      },
                      onNext: () {
                        if (_activeTrackId != null && idx < _allTracks.length - 1) {
                          setState(() {
                            _activeTrackId = _allTracks[idx + 1].id;
                            _isPlaying = true;
                            _progress = 0.0;
                          });
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
                setState(() {
                  _isPlaying = !_isPlaying;
                });
              },
              onPrevious: () {
                if (_activeTrackId != null) {
                  final currentIndex = _allTracks.indexWhere((t) => t.id == _activeTrackId);
                  if (currentIndex > 0) {
                    setState(() {
                      _activeTrackId = _allTracks[currentIndex - 1].id;
                      _isPlaying = true;
                      _progress = 0.0;
                    });
                  }
                }
              },
              onNext: () {
                if (_activeTrackId != null) {
                  final currentIndex = _allTracks.indexWhere((t) => t.id == _activeTrackId);
                  if (currentIndex < _allTracks.length - 1) {
                    setState(() {
                      _activeTrackId = _allTracks[currentIndex + 1].id;
                      _isPlaying = true;
                      _progress = 0.0;
                    });
                  }
                }
              },
            ),
          
          // Нижнее меню поверх изображения
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: HarmonyBottomNav(
              activeTab: HarmonyTab.sleep,
              onTabSelected: _handleBottomNavTap,
              leadingEdgeCutoutTab: HarmonyTab.sleep,
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
                      ? Image.asset(
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
                // Иконка сна в левом верхнем углу
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
                          'assets/icons/soonicon.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.bedtime, size: 16, color: Color(0xFF202020)),
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
                              ? const Icon(
                                  Icons.pause,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.play_arrow,
                                  size: 20,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          
          // Название трека (белый цвет)
          Text(
            track.title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          
          // Длительность (белый цвет)
          Text(
            track.description,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.white,
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
          width: 34,
          height: 34,
          decoration: const BoxDecoration(
            color: Color(0xFF4DB2EA),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: Image.asset(
                'assets/icons/harmonyicon.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              ),
            ),
          ),
        ),
        const SizedBox(width: -2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF46AEE8), Color(0xFF46E4E3)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            AppLocalizations.of(context)!.premiumBadge,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }
}

