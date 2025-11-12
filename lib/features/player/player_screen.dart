import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

import '../../core/utils/navigation_utils.dart';
import '../../main.dart';
import '../../shared/models/player_track.dart';
import '../../shared/models/meditation_track.dart';
import '../../shared/widgets/mini_player.dart';
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

  @override
  Widget build(BuildContext context) {
    final bottomPadding = (_activeTrackId != null ? 130.0 : 63.0);

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
            child: SizedBox(
              height: 63,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipPath(
                    clipper: PlayerBottomMenuClipper(),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        height: 63,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMeditationIcon(context),
                        _buildPlayerIcon(context),
                        _buildCentralButton(context),
                        _buildSleepIcon(),
                        _buildBookIcon(context),
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

  Widget _buildMeditationIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const MeditationScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/profileicon.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const SleepScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/sleeplogo.png',
            width: 28,
            height: 28,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.bedtime,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCentralButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const HomeScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/harmonyicon.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.image,
                  color: Colors.blue,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActivePlayerHalo() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepIcon() {
    return Transform.translate(
      offset: const Offset(8, -2),
      child: SizedBox(
        width: 52,
        height: 52,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildActivePlayerHalo(),
            Image.asset(
              'assets/icons/mediaicon.png',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 22,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const TasksScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/bookicon.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PlayerBottomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final scaleX = size.width / 375;
    final scaleY = size.height / 63;

    final path = Path()
      ..moveTo(21.1753 * scaleX, 1.2144 * scaleY)
      ..cubicTo(
        9.66565 * scaleX,
        0.582053 * scaleY,
        0,
        9.73658 * scaleY,
        0,
        21.2635 * scaleY,
      )
      ..lineTo(0, 71 * scaleY)
      ..cubicTo(
        0,
        75.4183 * scaleY,
        3.58172 * scaleX,
        79 * scaleY,
        8 * scaleX,
        79 * scaleY,
      )
      ..lineTo(367 * scaleX, 79 * scaleY)
      ..cubicTo(
        371.418 * scaleX,
        79 * scaleY,
        375 * scaleX,
        75.4183 * scaleY,
        375 * scaleX,
        71 * scaleY,
      )
      ..lineTo(375 * scaleX, 21.2635 * scaleY)
      ..cubicTo(
        375 * scaleX,
        9.73658 * scaleY,
        365.334 * scaleX,
        0.582054 * scaleY,
        353.825 * scaleX,
        1.2144 * scaleY,
      )
      ..cubicTo(
        341.455 * scaleX,
        1.89399 * scaleY,
        324.546 * scaleX,
        2.77789 * scaleY,
        305.498 * scaleX,
        3.64942 * scaleY,
      )
      ..cubicTo(
        297.261 * scaleX,
        4.02626 * scaleY,
        290 * scaleX,
        21.7548 * scaleY,
        290 * scaleX,
        30 * scaleY,
      )
      ..cubicTo(
        290 * scaleX,
        45.464 * scaleY,
        277.464 * scaleX,
        58 * scaleY,
        262 * scaleX,
        58 * scaleY,
      )
      ..cubicTo(
        246.536 * scaleX,
        58 * scaleY,
        234 * scaleX,
        45.464 * scaleY,
        234 * scaleX,
        30 * scaleY,
      )
      ..cubicTo(
        234 * scaleX,
        22.2739 * scaleY,
        226.451 * scaleX,
        6.50428 * scaleY,
        218.727 * scaleX,
        6.65803 * scaleY,
      )
      ..cubicTo(
        207.834 * scaleX,
        6.87484 * scaleY,
        197.302 * scaleX,
        6.99998 * scaleY,
        187.5 * scaleX,
        6.99998 * scaleY,
      )
      ..cubicTo(
        133.621 * scaleX,
        6.99998 * scaleY,
        57.656 * scaleX,
        3.21868 * scaleY,
        21.1753 * scaleX,
        1.2144 * scaleY,
      )
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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

