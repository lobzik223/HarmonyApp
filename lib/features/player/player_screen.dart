import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../core/utils/navigation_utils.dart';
import '../../core/api/content_api.dart';
import '../../core/storage/recent_tracks_storage.dart';
import '../../main.dart';
import '../../shared/models/player_track.dart';
import '../../shared/models/meditation_track.dart';
import '../../shared/widgets/mini_player.dart';
import '../../shared/widgets/harmony_bottom_nav.dart';
import '../meditation/meditation_screen.dart';
import '../sleep/sleep_screen.dart';
import '../tasks/tasks_screen.dart';
import 'open_player_screen.dart';

/// Экран плеера с фоновой иллюстрацией и фирменным нижним меню
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<PlayerTrack> _tracks = [];
  List<PlayerTrack> _recentTracks = [];
  String? _activeTrackId;
  bool _isPlaying = false;
  double _progress = 0.0;
  String _currentTime = '2:23:65';

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    try {
      final med = await ContentApi.getMeditationTracks();
      final sleep = await ContentApi.getSleepTracks();
      final all = [...med, ...sleep];
      final tracks = all
          .map((t) => PlayerTrack(
                id: t.id,
                title: t.title,
                artist: t.description.isNotEmpty ? t.description : 'Harmony',
              ))
          .toList();
      final recent = await RecentTracksStorage.getRecentTracks();
      if (mounted) setState(() {
        _tracks = tracks;
        _recentTracks = recent;
      });
    } catch (e) {
      if (mounted) setState(() {
        _tracks = [];
        _recentTracks = [];
      });
    }
  }

  void _onTrackPlay(PlayerTrack track) {
    ContentApi.registerTrackListen(track.id).catchError((_) {});
    RecentTracksStorage.addRecentTrack(track).then((_) async {
      final recent = await RecentTracksStorage.getRecentTracks();
      if (mounted) setState(() => _recentTracks = recent);
    });
  }

  void _handleBottomNavTap(HarmonyTab tab) {
    switch (tab) {
      case HarmonyTab.meditation:
        Navigator.of(context).push(
          noAnimationRoute(const MeditationScreen()),
        );
        break;
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
        return;
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
          // Фон — поднят выше, от верхнего края
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/playerfon.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                );
              },
            ),
          ),

          // Заголовок «Прослушанные» сверху по центру (как «Главная»)
          Positioned(
            top: 62,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.listenedTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),

          // Скроллируемый контент: прослушанные (до 15) + все треки
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: bottomPadding,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Последние 15 прослушанных
                  if (_recentTracks.isNotEmpty) ...[
                    ..._recentTracks.map((track) {
                      final isActive = _activeTrackId == track.id;
                      final isPlaying = isActive && _isPlaying;
                      return _buildTrackCard(track, isActive, isPlaying);
                    }),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.allTracks,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  // Список всех треков
                  ..._tracks.asMap().entries.map((entry) {
                    final track = entry.value;
                    final isActive = _activeTrackId == track.id;
                    final isPlaying = isActive && _isPlaying;
                    return _buildTrackCard(track, isActive, isPlaying);
                  }).toList(),
                ],
              ),
            ),
          ),

          // Мини-плеер
          if (_activeTrackId != null)
            MiniPlayer(
              bottomOffset: HarmonyBottomNav.miniPlayerBottomOffset(context),
              track: _createMeditationTrackFromPlayerTrack(
                _tracks.firstWhere((t) => t.id == _activeTrackId),
              ),
              isPlaying: _isPlaying,
              progress: _progress,
              currentTime: _currentTime,
              totalTime: '3:42',
              onTap: () {
                final idx = _tracks.indexWhere((t) => t.id == _activeTrackId);
                final pt = idx >= 0 ? _tracks[idx] : _tracks.first;
                final mtList = _tracks.map(_createMeditationTrackFromPlayerTrack).toList();
                Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (context) => OpenPlayerScreen(
                      track: _createMeditationTrackFromPlayerTrack(pt),
                      tracks: mtList,
                      initialIndex: idx >= 0 ? idx : 0,
                      isPlaying: _isPlaying,
                      progress: _progress,
                      currentTime: _currentTime,
                      totalTime: '3:42',
                      onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
                      onPrevious: () {
                        if (idx > 0) setState(() {
                          _activeTrackId = _tracks[idx - 1].id;
                          _isPlaying = true;
                          _progress = 0.0;
                        });
                      },
                      onNext: () {
                        if (idx < _tracks.length - 1) setState(() {
                          _activeTrackId = _tracks[idx + 1].id;
                          _isPlaying = true;
                          _progress = 0.0;
                        });
                      },
                    ),
                  ),
                ).then((newActiveId) async {
                  if (newActiveId != null && mounted) {
                    setState(() => _activeTrackId = newActiveId);
                    final idx = _tracks.indexWhere((t) => t.id == newActiveId);
                    if (idx >= 0) {
                      await RecentTracksStorage.addRecentTrack(_tracks[idx]);
                      if (mounted) {
                        final recent = await RecentTracksStorage.getRecentTracks();
                        setState(() => _recentTracks = recent);
                      }
                    }
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
                  final currentIndex = _tracks.indexWhere((t) => t.id == _activeTrackId);
                  if (currentIndex > 0) {
                    setState(() {
                      _activeTrackId = _tracks[currentIndex - 1].id;
                      _isPlaying = true;
                      _progress = 0.0;
                    });
                  }
                }
              },
              onNext: () {
                if (_activeTrackId != null) {
                  final currentIndex = _tracks.indexWhere((t) => t.id == _activeTrackId);
                  if (currentIndex < _tracks.length - 1) {
                    setState(() {
                      _activeTrackId = _tracks[currentIndex + 1].id;
                      _isPlaying = true;
                      _progress = 0.0;
                    });
                  }
                }
              },
            ),

          // Нижнее меню навигации
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: HarmonyBottomNav(
              activeTab: HarmonyTab.player,
              onTabSelected: _handleBottomNavTap,
              leadingEdgeCutoutTab: HarmonyTab.player,
            ),
          ),
        ],
      ),
    );
  }

  // Создает MeditationTrack из PlayerTrack для MiniPlayer
  MeditationTrack _createMeditationTrackFromPlayerTrack(PlayerTrack track) {
    return MeditationTrack(
      id: track.id,
      title: track.title,
      description: track.artist,
      level: '',
      image: '',
      video: '',
      type: '',
      category: '',
      isPremium: false,
      isPlaying: _isPlaying,
    );
  }

  // Строит карточку трека
  Widget _buildTrackCard(PlayerTrack track, bool isActive, bool isPlaying) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_activeTrackId == track.id) {
            _isPlaying = !_isPlaying;
          } else {
            _activeTrackId = track.id;
            _isPlaying = true;
            _progress = 0.0;
          }
        });
        _onTrackPlay(track);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.08), // Еще более прозрачный серый фон
          borderRadius: BorderRadius.circular(12), // Чуть больше закругленность
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 2,
              offset: const Offset(0, 1.5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Иконка наушников слева (48x48 с rounded corners 12)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // rx="12" ry="12" из SVG
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF44AAED),
                    Color(0xFF46E4E3),
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
                        colors: [Colors.white, Colors.white],
                      ).createShader(bounds),
                      child: const Icon(
                        Icons.headphones,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            
            // Текст (название трека и исполнитель)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    track.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF202020), // fill="#202020" из SVG
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.artist,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF202020).withOpacity(0.4), // fill="#202020" fill-opacity="0.4" из SVG
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Иконка play/pause справа в синем круге с эффектом свечения
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF4FC3F7), // Синий круг
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4FC3F7).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: isPlaying
                    ? const Icon(
                        Icons.pause,
                        size: 16,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.play_arrow,
                        size: 16,
                        color: Colors.white,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  


  
}

/// Художник для рисования частиц/точек на фоне иконки наушников
class ParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
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

