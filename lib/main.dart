import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/navigation_utils.dart';
import 'core/audio/audio_service.dart';
import 'core/api/content_api.dart';
import 'features/loading/loading_screen.dart';
import 'features/registration/registration_screen.dart';
import 'features/plan/plan_selection_section.dart';
import 'features/meditation/meditation_screen.dart';
import 'features/sleep/sleep_screen.dart';
import 'features/tasks/tasks_screen.dart';
import 'features/player/player_screen.dart';
import 'features/player/open_player_screen.dart';
import 'features/profile/profile_screen.dart';
import 'shared/models/meditation_track.dart';
import 'shared/widgets/harmony_bottom_nav.dart';
import 'shared/widgets/mini_player.dart';

/// Модель карточки для главного экрана (раздел «О силе мышления» и др.)
class HomeCard {
  final String id;
  final String image;
  final String title;
  final String? subtitle;
  final String type;
  final String? date;
  final String? duration;
  final String? views;
  final bool isLocked;
  final String? descriptionFull;
  /// URL аудио/видео для воспроизведения (курсы, треки).
  final String? audioUrl;

  HomeCard({
    required this.id,
    required this.image,
    required this.title,
    this.subtitle,
    required this.type,
    this.date,
    this.duration,
    this.views,
    this.isLocked = false,
    this.descriptionFull,
    this.audioUrl,
  });

  factory HomeCard.fromJson(Map<String, dynamic> json) {
    return HomeCard(
      id: json['id'] as String? ?? '',
      image: json['image'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      type: json['type'] as String? ?? '',
      date: json['date'] as String?,
      duration: json['duration'] as String?,
      views: json['views'] as String?,
      isLocked: json['isLocked'] as bool? ?? false,
      descriptionFull: json['descriptionFull'] as String?,
      audioUrl: json['audioUrl'] as String?,
    );
  }

  /// Из статьи API (ContentArticle).
  factory HomeCard.fromApiArticle(Map<String, dynamic> json) {
    final base = AppConstants.baseUrl.replaceFirst(RegExp(r'/$'), '');
    String image = json['imageUrl'] as String? ?? '';
    if (image.isNotEmpty && !image.startsWith('http')) image = '$base$image';
    final publishedAt = json['publishedAt'] as String?;
    String? dateStr;
    if (publishedAt != null && publishedAt.isNotEmpty) {
      try {
        final d = DateTime.parse(publishedAt);
        const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
        if (d.month >= 1 && d.month <= 12) {
          dateStr = '${d.day} ${months[d.month - 1]}';
        }
      } catch (_) {}
    }
    final durationMin = json['durationMinutes'] as int?;
    final duration = durationMin != null ? '$durationMin мин' : null;
    return HomeCard(
      id: json['id'] as String? ?? '',
      image: image,
      title: json['title'] as String? ?? '',
      subtitle: json['descriptionShort'] as String?,
      type: json['blockType'] as String? ?? 'FEATURED',
      isLocked: false,
      date: dateStr,
      duration: duration,
      descriptionFull: json['descriptionFull'] as String?,
    );
  }
}

class CourseCard {
  final String id;
  final String title;
  final String? subtitle;
  final String image;
  final String? descriptionFull;
  final List<HomeCard> tracks;

  CourseCard({
    required this.id,
    required this.title,
    required this.image,
    this.subtitle,
    this.descriptionFull,
    this.tracks = const [],
  });

  factory CourseCard.fromApi(Map<String, dynamic> json) {
    final base = AppConstants.baseUrl.replaceFirst(RegExp(r'/$'), '');
    String image = json['imageUrl'] as String? ?? '';
    if (image.isNotEmpty && !image.startsWith('http')) image = '$base$image';
    final courseTracks = (json['tracks'] as List<dynamic>? ?? [])
        .map((e) => e as Map<String, dynamic>)
        .map((e) {
          final t = e['track'] as Map<String, dynamic>? ?? {};
          final audioUrl = ContentApi.mediaUrl(t['audioUrl'] as String?);
          return HomeCard(
            id: t['id'] as String? ?? '',
            image: ContentApi.mediaUrl(t['coverUrl'] as String?),
            title: t['title'] as String? ?? '',
            subtitle: t['descriptionShort'] as String?,
            type: 'TRACK',
            duration: null,
            isLocked: t['isPremium'] as bool? ?? false,
            audioUrl: audioUrl.isNotEmpty ? audioUrl : null,
          );
        })
        .toList();
    return CourseCard(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['descriptionShort'] as String?,
      descriptionFull: json['descriptionFull'] as String?,
      image: image,
      tracks: courseTracks,
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Ловим ошибки Flutter, чтобы в консоли было видно причину чёрного экрана
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exception}');
    debugPrint('Stack: ${details.stack}');
  };
  runApp(const HarmonyApp());
}

class HarmonyApp extends StatelessWidget {
  const HarmonyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supported) {
        for (final s in supported) {
          if (locale != null && s.languageCode == locale.languageCode) return s;
        }
        return const Locale('en');
      },
      home: const LoadingScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Список фонов для переключения
  final List<String> _backgrounds = [
    'assets/images/window1.jpg',
    'assets/images/fon1.jpg',
    'assets/images/id2.jpg',
    'assets/images/id3.png',
  ];
  
  int _currentBackgroundIndex = 0; // Начинаем с window1.jpg
  bool _isLoading = true; // Флаг загрузки сохраненного фона
  
  // Данные карточек
  HomeCard? _featuredCard;
  List<HomeCard> _recommendedCards = [];
  List<MeditationTrack> _popularTracks = [];
  List<CourseCard> _courses = [];
  /// Секции главной (Гармония, Расслабление, Осознанность, Энергия) с треками.
  List<Map<String, dynamic>> _homeSections = [];
  String? _activeTrackId;
  List<MeditationTrack> _activeTrackContext = [];
  bool _isPlaying = false;
  double _progress = 0.0;
  String _currentTime = '0:00';

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadSavedBackground();
    _loadHomeCards();
    _refreshTimer = Timer.periodic(const Duration(minutes: 3), (_) {
      if (mounted) _loadHomeCards();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
  
  // Загружаем карточки с API (без демо)
  Future<void> _loadHomeCards() async {
    try {
      final data = await ContentApi.getHome();
      final home = data['home'] as Map<String, dynamic>?;
      if (home == null) {
        if (mounted) setState(() {});
        return;
      }
      if (home['featured'] != null) {
        _featuredCard = HomeCard.fromApiArticle(home['featured'] as Map<String, dynamic>);
      } else {
        _featuredCard = null;
      }
      _recommendedCards = (home['recommended'] as List<dynamic>?)
          ?.map((e) => HomeCard.fromApiArticle(e as Map<String, dynamic>))
          .toList() ?? [];
      _popularTracks = (home['popularTracks'] as List<dynamic>?)
          ?.map((e) {
            final track = e as Map<String, dynamic>;
            final section = track['section'] as Map<String, dynamic>?;
            final category = section?['slug'] as String? ?? 'popular';
            return MeditationTrack.fromApiJson(track, category: category);
          })
          .toList() ?? [];
      _courses = (home['courses'] as List<dynamic>?)
          ?.map((e) => CourseCard.fromApi(e as Map<String, dynamic>))
          .toList() ?? [];
      final rawHomeSections = data['homeSections'] as List<dynamic>? ?? [];
      _homeSections = rawHomeSections.map((s) {
        final section = s as Map<String, dynamic>;
        final slug = section['slug'] as String? ?? '';
        final tracksList = section['tracks'] as List<dynamic>? ?? [];
        final tracks = tracksList
            .map((t) => MeditationTrack.fromApiJson(t as Map<String, dynamic>, category: slug))
            .toList();
        return <String, dynamic>{
          'name': section['name'] as String? ?? '',
          'slug': slug,
          'tracks': tracks,
        };
      }).toList();
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        setState(() {
          _featuredCard = null;
          _recommendedCards = [];
          _popularTracks = [];
          _courses = [];
          _homeSections = [];
        });
      }
    }
  }
  
  // Загружаем сохраненный фон
  Future<void> _loadSavedBackground() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex = prefs.getInt('home_background_index');
      if (savedIndex != null && savedIndex >= 0 && savedIndex < _backgrounds.length) {
        setState(() {
          _currentBackgroundIndex = savedIndex;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Ошибка загрузки сохраненного фона: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Сохраняем выбранный фон
  Future<void> _saveBackground(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('home_background_index', index);
    } catch (e) {
      print('Ошибка сохранения фона: $e');
    }
  }

  void _switchBackground() {
    setState(() {
      _currentBackgroundIndex = (_currentBackgroundIndex + 1) % _backgrounds.length;
    });
    // Сохраняем выбранный фон
    _saveBackground(_currentBackgroundIndex);
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
        // Уже на главном экране
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

  void _setActiveTrack(MeditationTrack track, List<MeditationTrack> contextTracks) {
    if (AudioService.instance.currentTrack?.id == track.id) {
      AudioService.instance.togglePlayPause();
      setState(() => _isPlaying = AudioService.instance.isPlaying);
    } else {
      AudioService.instance.setActiveTrack(track, contextTracks);
      if (track.video.isNotEmpty) {
        AudioService.instance.play(track.video);
      }
      setState(() {
        _activeTrackId = track.id;
        _activeTrackContext = contextTracks;
        _isPlaying = true;
        _progress = 0.0;
      });
    }
    ContentApi.registerTrackListen(track.id).catchError((_) {});
  }

  String _formatCardSubtitle(MeditationTrack track) {
    final level = track.level.trim().isEmpty ? 'A' : track.level.trim();
    return 'i-медитация • Уровень $level';
  }

  void _openActiveTrackPlayer() {
    final active = AudioService.instance.currentTrack;
    final ctx = AudioService.instance.currentTrackContext;
    if (active == null || ctx.isEmpty) return;
    final idx = ctx.indexWhere((t) => t.id == active.id);
    if (idx < 0) return;
    Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => OpenPlayerScreen(
          track: active,
          tracks: ctx,
          initialIndex: idx,
          isPlaying: AudioService.instance.isPlaying,
          progress: AudioService.instance.progress,
          currentTime: AudioService.instance.formattedPosition,
          totalTime: active.durationSeconds != null
              ? MeditationTrack.formatDuration(active.durationSeconds)
              : AudioService.instance.formattedDuration,
          onPlayPause: () {
            AudioService.instance.togglePlayPause();
            setState(() => _isPlaying = AudioService.instance.isPlaying);
          },
          onPrevious: () {
            if (idx > 0) {
              final prev = ctx[idx - 1];
              AudioService.instance.setActiveTrack(prev, ctx);
              if (prev.video.isNotEmpty) AudioService.instance.play(prev.video);
              setState(() => _activeTrackId = prev.id);
            }
          },
          onNext: () {
            if (idx < ctx.length - 1) {
              final next = ctx[idx + 1];
              AudioService.instance.setActiveTrack(next, ctx);
              if (next.video.isNotEmpty) AudioService.instance.play(next.video);
              setState(() => _activeTrackId = next.id);
            }
          },
        ),
      ),
    ).then((newActiveId) {
      if (newActiveId != null && mounted) {
        setState(() => _activeTrackId = newActiveId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final contentBottom = _activeTrackId != null ? 160.0 : 100.0;
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: Stack(
        children: [
          // Фон (светлый запасной, если картинка не загрузится) + изображение на весь экран
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFE8E8E8),
          ),
          Positioned.fill(
            child: Image.asset(
              _backgrounds[_currentBackgroundIndex],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          // Верхняя иконка с кнопкой (слева) - переключает фон
          Positioned(
            top: 62,
            left: 16,
            child: GestureDetector(
              onTap: _switchBackground,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    'assets/icons/butonicon.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Ошибка загрузки изображения: $error');
                      print('Путь: assets/icons/butonicon.png');
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // Верхняя иконка пользователя (справа)
          Positioned(
            top: 62,
            right: 16,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).push(
                  noAnimationRoute(const ProfileScreen()),
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CustomPaint(
                    size: const Size(50, 50),
                    painter: UserTopIconPainter(),
                  ),
                ),
              ),
            ),
          ),
          
          // Заголовок по центру
          Positioned(
            top: 62,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.homeTitle,
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
          
          // Скроллируемый контент с карточками
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            bottom: contentBottom,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Первый раздел: О силе мышления (карточки с бэкенда)
                  if (_recommendedCards.isNotEmpty) ...[
                    Text(
                      AppLocalizations.of(context)!.powerOfThoughts,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.48,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMindPowerCards(),
                    const SizedBox(height: 32),
                  ],
                  if (_featuredCard != null) ...[
                    _buildFeaturedCard(_featuredCard!),
                    const SizedBox(height: 32),
                  ],
                  if (_popularTracks.isNotEmpty) ...[
                    Text(
                      AppLocalizations.of(context)!.popularFromHarmony,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.48,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPopularTracksCards(),
                    const SizedBox(height: 32),
                  ],
                  ..._homeSections.where((s) => (s['tracks'] as List<MeditationTrack>).isNotEmpty).map((section) => _buildHomeSectionBlock(section)),
                  if (_courses.isNotEmpty) ...[
                    Text(
                      'Курсы',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.48,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCourseCards(),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
          ),

          ListenableBuilder(
            listenable: AudioService.instance,
            builder: (context, _) {
              final svc = AudioService.instance;
              final active = svc.currentTrack;
              if (active == null) return const SizedBox.shrink();
              final ctx = svc.currentTrackContext.isNotEmpty ? svc.currentTrackContext : [active];
              return MiniPlayer(
                bottomOffset: HarmonyBottomNav.miniPlayerBottomOffset(context),
                transparentStyle: true,
                bottomOffsetAdjustment: -40,
                track: active,
                isPlaying: svc.isPlaying,
                isLoading: svc.isLoading,
                progress: svc.progress,
                currentTime: svc.formattedPosition,
                totalTime: active.durationSeconds != null
                    ? MeditationTrack.formatDuration(active.durationSeconds)
                    : svc.formattedDuration,
                onTap: _openActiveTrackPlayer,
                onPlayPause: () {
                  AudioService.instance.togglePlayPause();
                  setState(() => _isPlaying = AudioService.instance.isPlaying);
                },
                onPrevious: () {
                  final idx = ctx.indexWhere((t) => t.id == active.id);
                  if (idx > 0) {
                    final prev = ctx[idx - 1];
                    AudioService.instance.setActiveTrack(prev, ctx);
                    if (prev.video.isNotEmpty) AudioService.instance.play(prev.video);
                    setState(() => _activeTrackId = prev.id);
                  }
                },
                onNext: () {
                  final idx = ctx.indexWhere((t) => t.id == active.id);
                  if (idx >= 0 && idx < ctx.length - 1) {
                    final next = ctx[idx + 1];
                    AudioService.instance.setActiveTrack(next, ctx);
                    if (next.video.isNotEmpty) AudioService.instance.play(next.video);
                    setState(() => _activeTrackId = next.id);
                  }
                },
              );
            },
          ),
          
          // Нижнее меню поверх изображения
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: HarmonyBottomNav(
              activeTab: HarmonyTab.home,
              onTabSelected: _handleBottomNavTap,
              isHomeStyle: true,
              highlightHomeIdle: true,
              iconsBlack: false,
            ),
          ),
        ],
      ),
    );
  }
  
  // Главная большая карточка
  Widget _buildFeaturedCard(HomeCard card) {
    return GestureDetector(
      onTap: () {
        // Можно добавить навигацию на детальную страницу
        print('Нажата карточка: ${card.title}');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
          children: [
            // Изображение
            Positioned.fill(
              child: Image.network(
                card.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.image, color: Colors.white54, size: 48),
                    ),
                  );
                },
              ),
            ),
            // Градиент снизу
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            // Дата в правом верхнем углу
            if (card.date != null)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    card.date!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            // Длительность/замок в левом нижнем углу изображения
            Positioned(
              bottom: 100,
              left: 16,
              child: Row(
                children: [
                  if (card.isLocked)
                    const Icon(
                      Icons.lock,
                      size: 14,
                      color: Colors.white,
                    ),
                  if (card.isLocked) const SizedBox(width: 4),
                  if (card.duration != null)
                    Text(
                      card.duration!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
            // Текст внизу
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      card.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (card.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        card.subtitle!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      card.type,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
  
  // Карточки раздела «О силе мышления» — в ряд: фото целиком сверху, текст снизу под карточкой
  static const double _mindPowerImageHeight = 180.0;

  Widget _buildMindPowerCards() {
    return SizedBox(
      height: _mindPowerImageHeight + 58,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _recommendedCards.length,
        itemBuilder: (context, index) {
          final card = _recommendedCards[index];
          return Padding(
            padding: EdgeInsets.only(right: index < _recommendedCards.length - 1 ? 12 : 0),
            child: _buildMindPowerCard(card),
          );
        },
      ),
    );
  }

  Widget _buildMindPowerCard(HomeCard card) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          slideUpRoute(HomeCardDetailScreen(card: card)),
        );
      },
      child: SizedBox(
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото целиком, без наложения текста
            SizedBox(
              height: _mindPowerImageHeight,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      card.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A237E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.image, color: Colors.white54, size: 48),
                      ),
                    ),
                  ),
                  if (card.date != null)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          card.date!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Название и описание под карточкой — без фона, компактный текст
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.title,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.25,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (card.subtitle != null && card.subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      card.subtitle!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.25,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Популярные треки (до 10) — компактные карточки как в разделах медитаций.
  Widget _buildPopularTracksCards() {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _popularTracks.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final track = _popularTracks[index];
          return _buildAudioTrackCard(
            track,
            subtitle: _formatCardSubtitle(track),
            onTap: () => _setActiveTrack(track, _popularTracks),
          );
        },
      ),
    );
  }

  /// Блок секции главной (Гармония, Расслабление, Осознанность, Энергия): заголовок + горизонтальный список треков.
  Widget _buildHomeSectionBlock(Map<String, dynamic> section) {
    final name = section['name'] as String? ?? '';
    final tracks = section['tracks'] as List<MeditationTrack>? ?? [];
    if (tracks.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.0,
              letterSpacing: 0.48,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tracks.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final track = tracks[index];
                return _buildHomeSectionTrackCard(track, tracks);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeSectionTrackCard(MeditationTrack track, List<MeditationTrack> tracks) {
    return _buildAudioTrackCard(
      track,
      subtitle: _formatCardSubtitle(track),
      onTap: () => _setActiveTrack(track, tracks),
    );
  }

  Widget _buildCourseCards() {
    return Column(
      children: _courses.map((course) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                noAnimationRoute(CourseDetailScreen(
                  course: course,
                  onTrackTap: _setActiveTrack,
                )),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2768),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 190,
                      width: double.infinity,
                      child: Image.network(
                        course.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFF2C2F4D),
                          child: const Icon(Icons.image, color: Colors.white54, size: 40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (course.subtitle != null && course.subtitle!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              course.subtitle!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildAudioTrackCard(
    MeditationTrack track, {
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isActive = _activeTrackId == track.id;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 145,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      track.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.music_note, color: Colors.black38, size: 40),
                        ),
                      ),
                    ),
                  ),
                  if (track.isPremium)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
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
                            'assets/icons/zvezda.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(Icons.auto_awesome, size: 16, color: Color(0xFF202020)),
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
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              (isActive && _isPlaying) ? Icons.pause : Icons.play_arrow,
                              size: 22,
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
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF637381),
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
                errorBuilder: (_, __, ___) => const Icon(Icons.auto_awesome, color: Colors.white, size: 12),
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
            'PREMIUM',
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

/// Градиент фона как на экране «Сон»
const _sleepStyleGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF3E43E9),
    Color(0xFF5565F2),
    Color(0xFF9AD3FF),
    Color(0xFF39D8D0),
  ],
  stops: [0.0, 0.28, 0.55, 1.0],
);

/// Экран детали карточки (обложка, название, полное описание) — фон нижней части как у Сна, без белых пропусков
class HomeCardDetailScreen extends StatefulWidget {
  const HomeCardDetailScreen({super.key, required this.card});
  final HomeCard card;

  @override
  State<HomeCardDetailScreen> createState() => _HomeCardDetailScreenState();
}

class _HomeCardDetailScreenState extends State<HomeCardDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final contentChildren = <Widget>[
      Text(
        card.title,
        style: GoogleFonts.inter(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      if (card.subtitle != null && card.subtitle!.isNotEmpty) ...[
        const SizedBox(height: 8),
        Text(
          card.subtitle!,
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        ),
      ],
      const SizedBox(height: 28),
      if (card.descriptionFull != null && card.descriptionFull!.isNotEmpty)
        Text(
          card.descriptionFull!,
          style: GoogleFonts.inter(
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        )
      else if (card.subtitle != null && card.subtitle!.isNotEmpty)
        Text(
          card.subtitle!,
          style: GoogleFonts.inter(
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: _sleepStyleGradient),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.46,
                  width: double.infinity,
                  child: GestureDetector(
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Image.network(
                        card.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: const Color(0xFF2C2F4D),
                          child: const Icon(Icons.image, color: Colors.white54, size: 64),
                        ),
                      ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: _sleepStyleGradient,
                      ),
                      child: NotificationListener<OverscrollNotification>(
                      onNotification: (notification) {
                        if (notification.overscroll < -60) {
                          Navigator.of(context).pop();
                          return true;
                        }
                        return false;
                      },
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: contentChildren,
                        ),
                      ),
                    ),
                  ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.46 - 14,
              child: IgnorePointer(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.08),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 12),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: ClipRRect(
borderRadius: BorderRadius.circular(22),
                        child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(Icons.chevron_left, color: Colors.white, size: 26),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

MeditationTrack _homeCardToMeditationTrack(HomeCard card) {
  return MeditationTrack(
    id: card.id,
    title: card.title,
    description: card.subtitle ?? '',
    level: 'A',
    image: card.image,
    video: card.audioUrl ?? '',
    type: 'meditation',
    category: 'course',
    isPremium: card.isLocked,
    isPlaying: false,
    durationSeconds: null,
  );
}

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course, this.onTrackTap});
  final CourseCard course;
  final void Function(MeditationTrack track, List<MeditationTrack> contextTracks)? onTrackTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.42,
                width: double.infinity,
                child: Image.network(
                  course.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF2C2F4D),
                    child: const Icon(Icons.image, color: Colors.white54, size: 64),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2F4D),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    children: [
                      Text(
                        course.title,
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (course.subtitle != null && course.subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          course.subtitle!,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Text(
                        'Треки курса',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...course.tracks.asMap().entries.map((entry) {
                        final idx = entry.key + 1;
                        final track = entry.value;
                        final canPlay = track.audioUrl != null && track.audioUrl!.isNotEmpty;
                        final mt = _homeCardToMeditationTrack(track);
                        final mtList = course.tracks
                            .where((t) => t.audioUrl != null && t.audioUrl!.isNotEmpty)
                            .map(_homeCardToMeditationTrack)
                            .toList();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            onTap: canPlay && onTrackTap != null
                                ? () => onTrackTap!(mt, mtList)
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF5B5CE6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$idx',
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          track.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (track.subtitle != null && track.subtitle!.isNotEmpty)
                                          Text(
                                            track.subtitle!,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (track.isLocked)
                                    const Icon(Icons.lock_outline, color: Colors.white54)
                                  else if (canPlay)
                                    const Icon(Icons.play_circle_outline, color: Colors.white70, size: 28),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB300).withOpacity(0.95),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Иконка пользователя для верхней части (50x50)
class UserTopIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // SVG координаты уже для 50x50, поэтому используем их напрямую
    final double scale = 1.0;
    
    // Фон - полупрозрачный черный круг
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    
    final backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.width / 2),
    );
    canvas.drawRRect(backgroundRect, backgroundPaint);
    
    // Белые контуры
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    // Голова - круг
    final headCenter = Offset(24.9999, 18);
    final headRadius = 4.66667;
    canvas.drawCircle(headCenter, headRadius, strokePaint);
    
    // Тело - путь
    final bodyPath = Path();
    bodyPath.moveTo(34.3334, 31.4167);
    bodyPath.cubicTo(
      34.3334, 34.3162,
      34.3334, 36.6667,
      25.0001, 36.6667,
    );
    bodyPath.cubicTo(
      15.6667, 36.6667,
      15.6667, 34.3162,
      15.6667, 31.4167,
    );
    bodyPath.cubicTo(
      15.6667, 28.5172,
      19.8454, 26.1667,
      25.0001, 26.1667,
    );
    bodyPath.cubicTo(
      30.1547, 26.1667,
      34.3334, 28.5172,
      34.3334, 31.4167,
    );
    bodyPath.close();
    
    canvas.drawPath(bodyPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
