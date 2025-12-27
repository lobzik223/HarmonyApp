import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../../core/utils/navigation_utils.dart';
import '../../main.dart';
import '../../shared/models/player_track.dart';
import '../../shared/models/meditation_track.dart';
import '../../shared/widgets/mini_player.dart';
import '../../shared/widgets/harmony_bottom_nav.dart';
import '../meditation/meditation_screen.dart';
import '../sleep/sleep_screen.dart';
import '../tasks/tasks_screen.dart';

/// Экран плеера с фоновой иллюстрацией и фирменным нижним меню
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  List<PlayerTrack> _tracks = [];
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
      final String response = await rootBundle.loadString('assets/data/player_tracks.json');
      final data = json.decode(response) as Map<String, dynamic>;
      final List<dynamic> tracksJson = data['tracks'] as List<dynamic>;
      final tracks = tracksJson
          .map((trackJson) => PlayerTrack(
                id: trackJson['id'] as String,
                title: trackJson['title'] as String,
                artist: trackJson['artist'] as String,
              ))
          .toList();

      if (mounted) {
        setState(() {
          _tracks = tracks;
        });
      }
    } catch (e) {
      print('Ошибка загрузки треков плеера: $e');
      if (mounted) {
        setState(() {
          _tracks = [];
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
          Positioned.fill(
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

          // Скроллируемый контент с карточками треков
          Positioned(
            top: 62,
            left: 0,
            right: 0,
            bottom: bottomPadding,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 300),
                  
                  // Список карточек треков
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
              track: _createMeditationTrackFromPlayerTrack(
                _tracks.firstWhere((t) => t.id == _activeTrackId),
              ),
              isPlaying: _isPlaying,
              progress: _progress,
              currentTime: _currentTime,
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

