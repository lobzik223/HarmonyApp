import 'package:flutter/material.dart';
import 'dart:ui';
import '../../main.dart';
import '../../core/utils/navigation_utils.dart';
import '../../shared/widgets/harmony_bottom_nav.dart';
import '../meditation/meditation_screen.dart';
import '../sleep/sleep_screen.dart';
import '../player/player_screen.dart';
import 'tasks_screen.dart';

/// Модель желания
class Wish {
  final String id;
  final String category;
  final String title;
  final String description;
  final bool isFulfilled;
  final bool isFavorite;

  Wish({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.isFulfilled = false,
    this.isFavorite = false,
  });

  Wish copyWith({
    String? id,
    String? category,
    String? title,
    String? description,
    bool? isFulfilled,
    bool? isFavorite,
  }) {
    return Wish(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      isFulfilled: isFulfilled ?? this.isFulfilled,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

/// Экран "Желания"
/// Фон: assets/images/fon1.jpg
class WishesScreen extends StatefulWidget {
  const WishesScreen({super.key});

  @override
  State<WishesScreen> createState() => _WishesScreenState();
}

class _WishesScreenState extends State<WishesScreen> {
  int _selectedSegment = 0; // 0 = Текущие, 1 = Исполненные
  
  // Список желаний
  List<Wish> _wishes = [
    Wish(
      id: '1',
      category: 'Название категории',
      title: 'Заголовк желания, который может уйти на 2',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore.',
      isFulfilled: false,
      isFavorite: false,
    ),
    Wish(
      id: '2',
      category: 'Название категории',
      title: 'Заголовк желания',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore.',
      isFulfilled: false,
      isFavorite: true,
    ),
    Wish(
      id: '3',
      category: 'Название категории',
      title: 'Заголовк желания, который может уйти на 2',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore.',
      isFulfilled: false,
      isFavorite: false,
    ),
    Wish(
      id: '4',
      category: 'Название категории',
      title: 'Заголовк желания',
      description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore.',
      isFulfilled: true,
      isFavorite: false,
    ),
  ];
  
  // Получаем отфильтрованные желания
  List<Wish> get _filteredWishes {
    if (_selectedSegment == 0) {
      return _wishes.where((wish) => !wish.isFulfilled).toList();
    } else {
      return _wishes.where((wish) => wish.isFulfilled).toList();
    }
  }
  
  // Добавить новое желание
  void _addWish() {
    showDialog(
      context: context,
      builder: (context) => _AddWishDialog(
        onAdd: (wish) {
          setState(() {
            _wishes.add(wish);
          });
        },
      ),
    );
  }
  
  // Переключить избранное
  void _toggleFavorite(String id) {
    setState(() {
      final index = _wishes.indexWhere((wish) => wish.id == id);
      if (index != -1) {
        _wishes[index] = _wishes[index].copyWith(
          isFavorite: !_wishes[index].isFavorite,
        );
      }
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
        Navigator.of(context).push(
          noAnimationRoute(const PlayerScreen()),
        );
        break;
      case HarmonyTab.tasks:
        Navigator.of(context).pushReplacement(
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
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fon1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Заголовок с кнопкой "Назад" и текстом "ЖЕЛАНИЯ"
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Кнопка "Назад"
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Назад',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                // Центрированный заголовок "ЖЕЛАНИЯ"
                Expanded(
                  child: Center(
                    child: Text(
                      'ЖЕЛАНИЯ',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                // Пустое место для балансировки
                const SizedBox(width: 80),
              ],
            ),
          ),

          // Виджет сегментированного контроля
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: _buildSegmentedControl(),
          ),

          // Список карточек желаний
          Positioned(
            top: 160,
            left: 0,
            right: 0,
            bottom: 100,
            child: _buildWishesList(),
          ),

          // Кнопка добавления нового желания
          Positioned(
            bottom: 120,
            right: 20,
            child: GestureDetector(
              onTap: _addWish,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Нижнее меню поверх изображения
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: HarmonyBottomNav(
              activeTab: HarmonyTab.tasks,
              onTabSelected: _handleBottomNavTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Center(
      child: Container(
        width: 351,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Stack(
              children: [
                // Активный сегмент (белый фон)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: _selectedSegment == 0 ? 4 : 177.5,
                  top: 4,
                  child: Container(
                    width: 169.5,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                // Текст сегментов
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSegment = 0;
                          });
                        },
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            'Текущие',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _selectedSegment == 0
                                  ? const Color(0xFF202020)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSegment = 1;
                          });
                        },
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            'Исполненные',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _selectedSegment == 1
                                  ? const Color(0xFF202020)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildWishesList() {
    final filteredWishes = _filteredWishes;
    
    if (filteredWishes.isEmpty) {
      return Center(
        child: Text(
          _selectedSegment == 0 ? 'Нет текущих желаний' : 'Нет исполненных желаний',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      );
    }
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: filteredWishes.map((wish) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildWishCard(wish),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildWishCard(Wish wish) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхняя строка: категория и иконка сердца
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название категории
                  Text(
                    wish.category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      height: 1.0,
                    ),
                  ),
                  // Иконка сердца
                  GestureDetector(
                    onTap: () => _toggleFavorite(wish.id),
                    child: Icon(
                      wish.isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: wish.isFavorite ? Colors.red : Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Заголовок желания
              Text(
                wish.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Описание
              Text(
                wish.description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Диалог для добавления нового желания
class _AddWishDialog extends StatefulWidget {
  final Function(Wish) onAdd;

  const _AddWishDialog({required this.onAdd});

  @override
  State<_AddWishDialog> createState() => _AddWishDialogState();
}

class _AddWishDialogState extends State<_AddWishDialog> {
  final _categoryController = TextEditingController(text: 'Название категории');
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveWish() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите заголовок желания')),
      );
      return;
    }

    final wish = Wish(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: _categoryController.text.trim().isEmpty 
          ? 'Название категории' 
          : _categoryController.text.trim(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore.'
          : _descriptionController.text.trim(),
    );

    widget.onAdd(wish);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Новое желание',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _categoryController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Категория',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Заголовок',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Описание (необязательно)',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white54),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Отмена',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saveWish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                      ),
                      child: const Text('Добавить'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}