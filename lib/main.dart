import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/navigation_utils.dart';
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
      id: json['id'] as String,
      image: json['image'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      type: json['type'] as String,
      date: json['date'] as String?,
      duration: json['duration'] as String?,
      views: json['views'] as String?,
      isLocked: json['isLocked'] as bool? ?? false,
    );
  }
}

void main() {
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
      themeMode: ThemeMode.system,
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
  
  // Загружаем карточки из JSON
  Future<void> _loadHomeCards() async {
    try {
      final String response = await rootBundle.loadString('assets/data/home_cards.json');
      final data = json.decode(response) as Map<String, dynamic>;
      
      // Загружаем главную карточку
      if (data['featured'] != null) {
        _featuredCard = HomeCard.fromJson(data['featured'] as Map<String, dynamic>);
      }
      
      // Загружаем рекомендованные
      if (data['recommended'] != null) {
        final recommendedList = data['recommended'] as List<dynamic>;
        _recommendedCards = recommendedList
            .map((item) => HomeCard.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      
      // Загружаем экстренные
      if (data['emergency'] != null) {
        final emergencyList = data['emergency'] as List<dynamic>;
        _emergencyCards = emergencyList
            .map((item) => HomeCard.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Ошибка загрузки карточек: $e');
      // Устанавливаем дефолтные данные если файл не загрузился
      _setDefaultCards();
      if (mounted) {
        setState(() {});
      }
    }
  }
  
  // Устанавливаем дефолтные карточки
  void _setDefaultCards() {
    _featuredCard = HomeCard(
      id: 'featured1',
      image: 'assets/images/window1.jpg',
      date: '5 декабря',
      title: 'Путь вдоха',
      subtitle: 'Китайская мудрость о долголетии',
      type: 'Занятие',
      duration: '8 мин',
      isLocked: false,
    );
    
    _recommendedCards = [
      HomeCard(
        id: 'rec1',
        image: 'assets/images/id2.jpg',
        title: 'Исполнение желаний',
        type: 'Курс',
        views: '12,3 тыс',
        isLocked: false,
      ),
      HomeCard(
        id: 'rec2',
        image: 'assets/images/id3.png',
        title: 'Колесо жизненного баланса',
        type: 'Курс',
        views: '26,3 тыс',
        isLocked: false,
      ),
    ];
    
    _emergencyCards = [
      HomeCard(
        id: 'emergency1',
        image: 'assets/images/fon1.jpg',
        title: 'Снятие стресса',
        type: 'Медитация',
        duration: '5 мин',
        isLocked: false,
      ),
      HomeCard(
        id: 'emergency2',
        image: 'assets/images/window1.jpg',
        title: 'Быстрое успокоение',
        type: 'Дыхание',
        duration: '3 мин',
        isLocked: false,
      ),
    ];
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
      body: Stack(
        children: [
          // Фоновое изображение на весь экран
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_backgrounds[_currentBackgroundIndex]),
                fit: BoxFit.cover,
              ),
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
                  
                  // Раздел "Рекомендовано для вас"
                  if (_recommendedCards.isNotEmpty) ...[
                    const Text(
                      'Рекомендовано для вас',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRecommendedCards(),
                    const SizedBox(height: 32),
                  ],
                  
                  // Раздел "Экстренные ситуации"
                  if (_emergencyCards.isNotEmpty) ...[
                    const Text(
                      'Экстренные ситуации',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
