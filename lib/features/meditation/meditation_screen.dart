import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../../shared/models/meditation_track.dart';
import '../../shared/widgets/mini_player.dart';
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
            child: Container(
              height: 63,
              child: Stack(
                children: [
                  // Фоновое размытие с точной формой SVG
                  ClipPath(
                    clipper: BottomMenuClipperNew(),
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
                  // Иконки меню
                  Positioned(
                    top: 5,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Левая иконка - медитация (выбрана) с кругом
                          Transform.translate(
                            offset: const Offset(-10, 0), // Смещение влево
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                // Круг под иконкой
                                Positioned(
                                  top: 2, // 7 - 5 = 2 относительно top: 5 у Row
                                  child: Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(23),
                                    ),
                                  ),
                                ),
                                // Иконка медитации
                                _buildMeditationIcon(context, isSelected: true),
                              ],
                            ),
                          ),
                        // Вторая иконка - сон
                        _buildPlayerIcon(context),
                        // Центральная кнопка (обычная иконка)
                        _buildCentralButtonAsIcon(context),
                        // Четвертая иконка - сон
                        _buildSleepIcon(),
                        // Правая иконка - книга
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

  Widget _buildMeditationIcon(BuildContext context, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        // Уже на экране медитации, ничего не делаем
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Transform.translate(
            offset: const Offset(0, 4),
            child: Image.asset(
            'assets/icons/profileicon.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print('Ошибка загрузки изображения: $error');
              print('Путь: assets/icons/profileicon.png');
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
      ),
    );
  }

  Widget _buildSleepIcon() {
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
          child: Transform.translate(
            offset: const Offset(0, 6),
            child: Image.asset(
              'assets/icons/mediaicon.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Ошибка загрузки изображения: $error');
                print('Путь: assets/icons/mediaicon.png');
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
      ),
    );
  }

  Widget _buildPlayerIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
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
          child: Transform.translate(
            offset: const Offset(0, 6),
            child: Image.asset(
              'assets/icons/sleeplogo.png',
              width: 28,
              height: 28,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Ошибка загрузки изображения: $error');
                print('Путь: assets/icons/sleeplogo.png');
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
          child: Transform.translate(
            offset: const Offset(0, 6),
            child: Image.asset(
              'assets/icons/bookicon.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Ошибка загрузки изображения: $error');
                print('Путь: assets/icons/bookicon.png');
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
          child: Transform.translate(
            offset: const Offset(0, 6),
            child: Image.asset(
              'assets/icons/harmonyicon.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                print('Ошибка загрузки изображения: $error');
                print('Путь: assets/icons/harmonyicon.png');
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
      ),
    );
  }
}

// Новый clipper для формы меню из SVG
// viewBox="0 0 375 63", но путь может выходить за пределы
class BottomMenuClipperNew extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final scaleX = size.width / 375;
    final scaleY = size.height / 63;
    
    // M38 59
    path.moveTo(38 * scaleX, 59 * scaleY);
    
    // C54.0163 59 67 46.0163 67 30
    path.cubicTo(
      54.0163 * scaleX, 59 * scaleY,
      67 * scaleX, 46.0163 * scaleY,
      67 * scaleX, 30 * scaleY,
    );
    
    // C67 24.0696 77.4103 4.00862 83.3353 4.26243
    path.cubicTo(
      67 * scaleX, 24.0696 * scaleY,
      77.4103 * scaleX, 4.00862 * scaleY,
      83.3353 * scaleX, 4.26243 * scaleY,
    );
    
    // C117.465 5.72449 156.208 6.99998 187.5 6.99998
    path.cubicTo(
      117.465 * scaleX, 5.72449 * scaleY,
      156.208 * scaleX, 6.99998 * scaleY,
      187.5 * scaleX, 6.99998 * scaleY,
    );
    
    // C241.379 6.99998 317.344 3.21868 353.825 1.2144
    path.cubicTo(
      241.379 * scaleX, 6.99998 * scaleY,
      317.344 * scaleX, 3.21868 * scaleY,
      353.825 * scaleX, 1.2144 * scaleY,
    );
    
    // C365.334 0.582054 375 9.73658 375 21.2635
    path.cubicTo(
      365.334 * scaleX, 0.582054 * scaleY,
      375 * scaleX, 9.73658 * scaleY,
      375 * scaleX, 21.2635 * scaleY,
    );
    
    // V71 (вертикальная линия до y=71)
    path.lineTo(375 * scaleX, 71 * scaleY);
    
    // C375 75.4183 371.418 79 367 79
    path.cubicTo(
      375 * scaleX, 75.4183 * scaleY,
      371.418 * scaleX, 79 * scaleY,
      367 * scaleX, 79 * scaleY,
    );
    
    // H8 (горизонтальная линия до x=8)
    path.lineTo(8 * scaleX, 79 * scaleY);
    
    // C3.58172 79 0 75.4183 0 71
    path.cubicTo(
      3.58172 * scaleX, 79 * scaleY,
      0, 75.4183 * scaleY,
      0, 71 * scaleY,
    );
    
    // V21.2635 (вертикальная линия до y=21.2635)
    path.lineTo(0, 21.2635 * scaleY);
    
    // C0 9.73658 9.66565 0.582053 21.1753 1.2144
    path.cubicTo(
      0, 9.73658 * scaleY,
      9.66565 * scaleX, 0.582053 * scaleY,
      21.1753 * scaleX, 1.2144 * scaleY,
    );
    
    // C22.8539 1.30662 23.4448 4.85543 22.0419 5.78173
    path.cubicTo(
      22.8539 * scaleX, 1.30662 * scaleY,
      23.4448 * scaleX, 4.85543 * scaleY,
      22.0419 * scaleX, 5.78173 * scaleY,
    );
    
    // C14.1842 10.9698 9 19.8795 9 30
    path.cubicTo(
      14.1842 * scaleX, 10.9698 * scaleY,
      9 * scaleX, 19.8795 * scaleY,
      9 * scaleX, 30 * scaleY,
    );
    
    // C9 46.0163 21.9837 59 38 59
    path.cubicTo(
      9 * scaleX, 46.0163 * scaleY,
      21.9837 * scaleX, 59 * scaleY,
      38 * scaleX, 59 * scaleY,
    );
    
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

