/// Константы приложения Harmony App
class AppConstants {
  // Название приложения
  static const String appName = 'Harmony App';
  static const String appVersion = '1.0.0';
  
  // API конфигурация
  static const String baseUrl = 'https://api.harmonyapp.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Локальное хранение
  static const String userPreferencesKey = 'user_preferences';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Поддерживаемые языки
  static const List<String> supportedLanguages = ['en', 'ru'];
  static const String defaultLanguage = 'en';
  
  // Анимации
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
  
  // Размеры
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  
  // Ограничения
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  
  // Сетевые настройки
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
