import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../../shared/models/meditation_track.dart';
import '../../shared/widgets/mini_player.dart';
import '../../shared/widgets/harmony_bottom_nav.dart';
import '../sleep/sleep_screen.dart';
import '../tasks/tasks_screen.dart';
import '../player/player_screen.dart';

/// Экран "Медитации"
/// Фон с градиентами точно как в SVG
class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  List<MeditationTrack> _relaxationTracks = [];
  List<MeditationTrack> _inspirationTracks = [];
  List<MeditationTrack> _loveTracks = [];
  List<MeditationTrack> _allTracks = []; // Все треки для поиска
  String? _activeTrackId; // ID активного трека
  bool _isPlaying = false; // Состояние воспроизведения
  double _progress = 0.0; // Прогресс воспроизведения (0.0 - 1.0)
  String _currentTime = '10:56'; // Текущее время (заглушка)

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    try {
      final String response = await rootBundle.loadString('assets/data/meditation_tracks.json');
      final data = json.decode(response) as Map<String, dynamic>;
      final List<dynamic> tracksJson = data['tracks'] as List<dynamic>;
      final allTracks = tracksJson
          .map((trackJson) => MeditationTrack.fromJson(trackJson as Map<String, dynamic>))
          .toList();
      
      final relaxation = allTracks.where((track) => track.category == 'relaxation').toList();
      final inspiration = allTracks.where((track) => track.category == 'inspiration').toList();
      final love = allTracks.where((track) => track.category == 'love').toList();
      
      print('=== ЗАГРУЗКА ТРЕКОВ ===');
      print('Всего треков загружено: ${allTracks.length}');
      print('Треков для отдыха: ${relaxation.length}');
      print('Треков для вдохновения: ${inspiration.length}');
      print('Треков для поиска любви: ${love.length}');
      for (var track in allTracks) {
        print('Трек ID: ${track.id}, категория: ${track.category}, название: ${track.title}');
      }
      
      if (mounted) {
        setState(() {
          _relaxationTracks = relaxation;
          _inspirationTracks = inspiration;
          _loveTracks = love;
          _allTracks = allTracks; // Сохраняем все треки
          
          // Не устанавливаем активный трек при загрузке - только при нажатии на карточку
          _activeTrackId = null;
          _isPlaying = false;
        });
        print('Состояние обновлено. Relaxation: ${_relaxationTracks.length}, Inspiration: ${_inspirationTracks.length}, Love: ${_loveTracks.length}');
      }
    } catch (e) {
      print('Ошибка загрузки треков: $e');
      print('Stack trace: ${StackTrace.current}');
      if (mounted) {
        setState(() {
          _relaxationTracks = [];
          _inspirationTracks = [];
          _loveTracks = [];
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
          // Основной фон с диагональным градиентом
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFDDF3FF), // очень светлый голубой влево-сверху
                  Color(0xFFCFEFFF), // мягкий голубой (35%)
                  Color(0xFFBCEFEF), // нежная бирюза (70%)
                  Color(0xFF7FE2DB), // более насыщенная бирюза вправо-внизу
                ],
                stops: [0.0, 0.35, 0.70, 1.0],
              ),
            ),
          ),
          
          // Едва заметное "сияние" сверху-справа
          // cx="80%" cy="10%" r="45%" в SVG
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.6, -0.8), // 80% x, 10% y (от центра)
                  radius: 0.45, // 45% от размера
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
          
          // Мягкая подсветка снизу-центра
          // cx="55%" cy="85%" r="50%" в SVG
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.1, 0.7), // 55% x, 85% y (от центра)
                  radius: 0.5, // 50% от размера
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

          // Скроллируемый контент
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                top: 62,
                bottom: bottomPadding + 20, // Отступ снизу
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок "МЕДИТАЦИИ"
                  Center(
                    child: Text(
                      'МЕДИТАЦИИ',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        height: 1.0, // 100%
                        letterSpacing: 0.4, // 2% от 20px
                        color: Color(0xFF202020), // rgba(32, 32, 32, 1)
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Раздел "ДЛЯ ОТДЫХА"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ДЛЯ ОТДЫХА',
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
                              'Все',
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
                  
                  // Карточки треков для раздела "ДЛЯ ОТДЫХА"
                  if (_relaxationTracks.isNotEmpty)
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: _relaxationTracks.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_activeTrackId == _relaxationTracks[index].id) {
                                  _isPlaying = !_isPlaying;
                                } else {
                                  _activeTrackId = _relaxationTracks[index].id;
                                  _isPlaying = true;
                                  _progress = 0.0;
                                }
                              });
                            },
                            child: _buildTrackCard(_relaxationTracks[index], isInspiration: false),
                          );
                        },
                      ),
                    ),
                  
                  const SizedBox(height: 40),
                  
                  // Раздел "ДЛЯ ВДОХНОВЕНИЯ"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ДЛЯ ВДОХНОВЕНИЯ',
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
                              'Все',
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
                  
                  // Карточки треков для раздела "ДЛЯ ВДОХНОВЕНИЯ"
                  if (_inspirationTracks.isNotEmpty)
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: _inspirationTracks.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_activeTrackId == _inspirationTracks[index].id) {
                                  _isPlaying = !_isPlaying;
                                } else {
                                  _activeTrackId = _inspirationTracks[index].id;
                                  _isPlaying = true;
                                  _progress = 0.0;
                                }
                              });
                            },
                            child: _buildTrackCard(_inspirationTracks[index], isInspiration: true),
                          );
                        },
                      ),
                    ),
                  
                  const SizedBox(height: 40),
                  
                  // Раздел "ДЛЯ ПОИСКА ЛЮБВИ"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ДЛЯ ПОИСКА ЛЮБВИ',
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
                              'Все',
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
                  
                  // Карточки треков для раздела "ДЛЯ ПОИСКА ЛЮБВИ"
                  if (_loveTracks.isNotEmpty)
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: _loveTracks.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_activeTrackId == _loveTracks[index].id) {
                                  _isPlaying = !_isPlaying;
                                } else {
                                  _activeTrackId = _loveTracks[index].id;
                                  _isPlaying = true;
                                  _progress = 0.0;
                                }
                              });
                            },
                            child: _buildTrackCard(_loveTracks[index], isInspiration: false),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Мини-плеер (отображается над нижним меню, если есть активный трек)
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
            child: HarmonyBottomNav(
              activeTab: HarmonyTab.meditation,
              onTabSelected: _handleBottomNavTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackCard(MeditationTrack track, {bool isInspiration = false}) {
    return Container(
      width: 150, // Чуть меньше ширина карточки
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Карточка с изображением/видео
          Container(
            height: 145, // Увеличенная высота карточки
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[300],
            ),
            child: Stack(
              children: [
                // Фоновое изображение или видео
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
                
                // Иконка в левом верхнем углу (медитация для отдыха, звезда для вдохновения)
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
                    child: Icon(
                      isInspiration ? Icons.star : Icons.self_improvement,
                      size: 16,
                      color: const Color(0xFF202020),
                    ),
                  ),
                ),
                
                // Premium бейдж в нижнем левом углу (для premium треков)
                if (track.isPremium)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4FC3F7), // Light blue
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'PREMIUM',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Центральный overlay - Play для неактивных, Pause для активных треков
                Center(
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000).withOpacity(0.15), // rgba(0, 0, 0, 0.15)
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
          
          // Название трека (компактное, как на втором скриншоте)
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
          
          // Описание с уровнем
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

}
