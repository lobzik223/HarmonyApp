import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../../shared/models/meditation_track.dart';
import '../../shared/widgets/mini_player.dart';
import '../meditation/meditation_screen.dart';
import '../tasks/tasks_screen.dart';
import '../player/player_screen.dart';

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
      final String response = await rootBundle.loadString('assets/data/sleep_tracks.json');
      final data = json.decode(response) as Map<String, dynamic>;
      final List<dynamic> tracksJson = data['tracks'] as List<dynamic>;
      final allTracks = tracksJson
          .map((trackJson) => MeditationTrack.fromJson(trackJson as Map<String, dynamic>))
          .toList();
      
      final nightmareExclusion = allTracks.where((track) => track.category == 'nightmare_exclusion').toList();
      final otherDirection = allTracks.where((track) => track.category == 'other_direction').toList();
      
      print('=== ЗАГРУЗКА ТРЕКОВ СНА ===');
      print('Всего треков загружено: ${allTracks.length}');
      print('Треков для исключения кошмаров: ${nightmareExclusion.length}');
      print('Треков для другого направления: ${otherDirection.length}');
      
      if (mounted) {
        setState(() {
          _nightmareExclusionTracks = nightmareExclusion;
          _otherDirectionTracks = otherDirection;
          _allTracks = allTracks;
          
          // Не устанавливаем активный трек при загрузке - только при нажатии на карточку
          _activeTrackId = null;
          _isPlaying = false;
        });
      }
    } catch (e) {
      print('Ошибка загрузки треков сна: $e');
      if (mounted) {
        setState(() {
          _nightmareExclusionTracks = [];
          _otherDirectionTracks = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = (_activeTrackId != null ? 130.0 : 63.0); // Отступ снизу для меню + мини-плеер
    
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
                      'СОН',
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
                          'ИСКЛЮЧЕНИЕ КОШМАРОВ',
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
                              'Все',
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
                          'ДРУГОЕ НАПРАВЛЕНИЕ',
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
                              'Все',
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
            child: Container(
              height: 63,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: BottomMenuClipperSleep(),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        width: double.infinity,
                        height: 63,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMeditationIcon(context),
                        _buildSleepIconWithCircle(context),
                        _buildCentralButtonAsIcon(context),
                        _buildSleepIconSimple(context),
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
                
                // Иконка луны со звездами в левом верхнем углу
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bedtime,
                      size: 16,
                      color: Color(0xFF202020),
                    ),
                  ),
                ),
                
                // Центральный overlay - Play/Pause
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

  Widget _buildMeditationIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
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

  Widget _buildSleepIconWithCircle(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-8, -0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          Image.asset(
            'assets/icons/sleeplogo.png',
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
                  Icons.bedtime,
                  color: Colors.white,
                  size: 22,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSleepIconSimple(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          noAnimationRoute(const PlayerScreen()),
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
            'assets/icons/mediaicon.png',
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
                  Icons.music_note,
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

  Widget _buildBookIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
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

  Widget _buildCentralButtonAsIcon(BuildContext context) {
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

// Clipper для формы меню с вырезом под второй иконкой (сон)
class BottomMenuClipperSleep extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final scaleX = size.width / 375;
    final scaleY = size.height / 63;
    
    path.moveTo(113 * scaleX, 59 * scaleY);
    path.cubicTo(
      129.016 * scaleX, 59 * scaleY,
      142 * scaleX, 46.0163 * scaleY,
      142 * scaleX, 30 * scaleY,
    );
    path.cubicTo(
      142 * scaleX, 29.7537 * scaleY,
      141.997 * scaleX, 29.5082 * scaleY,
      141.991 * scaleX, 29.2634 * scaleY,
    );
    path.cubicTo(
      141.791 * scaleX, 21.2528 * scaleY,
      148.805 * scaleX, 6.51139 * scaleY,
      156.817 * scaleX, 6.66878 * scaleY,
    );
    path.cubicTo(
      167.516 * scaleX, 6.87897 * scaleY,
      177.862 * scaleX, 6.99998 * scaleY,
      187.5 * scaleX, 6.99998 * scaleY,
    );
    path.cubicTo(
      241.379 * scaleX, 6.99998 * scaleY,
      317.344 * scaleX, 3.21868 * scaleY,
      353.825 * scaleX, 1.2144 * scaleY,
    );
    path.cubicTo(
      365.334 * scaleX, 0.582054 * scaleY,
      375 * scaleX, 9.73658 * scaleY,
      375 * scaleX, 21.2635 * scaleY,
    );
    path.lineTo(375 * scaleX, 71 * scaleY);
    path.cubicTo(
      375 * scaleX, 75.4183 * scaleY,
      371.418 * scaleX, 79 * scaleY,
      367 * scaleX, 79 * scaleY,
    );
    path.lineTo(8 * scaleX, 79 * scaleY);
    path.cubicTo(
      3.58172 * scaleX, 79 * scaleY,
      0, 75.4183 * scaleY,
      0, 71 * scaleY,
    );
    path.lineTo(0, 21.2635 * scaleY);
    path.cubicTo(
      0, 9.73658 * scaleY,
      9.66565 * scaleX, 0.582053 * scaleY,
      21.1753 * scaleX, 1.2144 * scaleY,
    );
    path.cubicTo(
      33.8484 * scaleX, 1.91067 * scaleY,
      51.2864 * scaleX, 2.82139 * scaleY,
      70.9083 * scaleX, 3.71354 * scaleY,
    );
    path.cubicTo(
      78.9144 * scaleX, 4.07756 * scaleY,
      84.8804 * scaleX, 19.2678 * scaleY,
      84.129 * scaleX, 27.2469 * scaleY,
    );
    path.cubicTo(
      84.0436 * scaleX, 28.1531 * scaleY,
      84 * scaleX, 29.0714 * scaleY,
      84 * scaleX, 30 * scaleY,
    );
    path.cubicTo(
      84 * scaleX, 46.0163 * scaleY,
      96.9837 * scaleX, 59 * scaleY,
      113 * scaleX, 59 * scaleY,
    );
    
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
