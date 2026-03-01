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
import 'core/api/content_api.dart';
import 'features/loading/loading_screen.dart';
import 'features/registration/registration_screen.dart';
import 'features/plan/plan_selection_section.dart';
import 'features/meditation/meditation_screen.dart';
import 'features/sleep/sleep_screen.dart';
import 'features/tasks/tasks_screen.dart';
import 'features/player/player_screen.dart';
import 'features/profile/profile_screen.dart';
import 'shared/widgets/harmony_bottom_nav.dart';

/// Модель карточки для главного экрана
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
    );
  }

  /// Из статьи API (ContentArticle).
  factory HomeCard.fromApiArticle(Map<String, dynamic> json) {
    final base = AppConstants.baseUrl.replaceFirst(RegExp(r'/$'), '');
    String image = json['imageUrl'] as String? ?? '';
    if (image.isNotEmpty && !image.startsWith('http')) image = '$base$image';
    return HomeCard(
      id: json['id'] as String? ?? '',
      image: image,
      title: json['title'] as String? ?? '',
      subtitle: json['descriptionShort'] as String?,
      type: json['blockType'] as String? ?? 'FEATURED',
      isLocked: false,
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
      localizationsDelegates: [
        appLocalizationsDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
  List<HomeCard> _emergencyCards = [];

  @override
  void initState() {
    super.initState();
    _loadSavedBackground();
    _loadHomeCards();
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
      _emergencyCards = (home['emergency'] as List<dynamic>?)
          ?.map((e) => HomeCard.fromApiArticle(e as Map<String, dynamic>))
          .toList() ?? [];
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        setState(() {
          _featuredCard = null;
          _recommendedCards = [];
          _emergencyCards = [];
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

  @override
  Widget build(BuildContext context) {
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
            bottom: 100,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Главная карточка
                  if (_featuredCard != null) _buildFeaturedCard(_featuredCard!),
                  
                  const SizedBox(height: 32),
                  
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
                    _buildRecommendedCards(),
                    const SizedBox(height: 32),
                  ],
                  
                  if (_emergencyCards.isNotEmpty) ...[
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
                    _buildEmergencyCards(),
                    const SizedBox(height: 32),
                  ],
                ],
              ),
            ),
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
              child: Image.asset(
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
  
  // Рекомендованные карточки (две рядом)
  Widget _buildRecommendedCards() {
    final cards = _recommendedCards.take(2).toList();
    return Row(
      children: cards.asMap().entries.map((entry) {
        final index = entry.key;
        final card = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == 0 ? 8 : 0),
            child: _buildSmallCard(card),
          ),
        );
      }).toList(),
    );
  }
  
  // Экстренные карточки
  Widget _buildEmergencyCards() {
    return Column(
      children: _emergencyCards.map((card) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSmallCard(card),
        );
      }).toList(),
    );
  }
  
  // Маленькая карточка
  Widget _buildSmallCard(HomeCard card) {
    return GestureDetector(
      onTap: () {
        // Можно добавить навигацию на детальную страницу
        print('Нажата карточка: ${card.title}');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Изображение
            Positioned.fill(
              child: Image.asset(
                card.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.image, color: Colors.white54, size: 32),
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
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
            // Замок/просмотры в левом нижнем углу
            Positioned(
              bottom: 50,
              left: 12,
              child: Row(
                children: [
                  if (card.isLocked)
                    const Icon(
                      Icons.lock,
                      size: 12,
                      color: Colors.white,
                    ),
                  if (card.isLocked) const SizedBox(width: 4),
                  if (card.views != null)
                    Text(
                      card.views!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  if (card.duration != null)
                    Text(
                      card.duration!,
                      style: const TextStyle(
                        fontSize: 11,
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      card.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.type,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
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
