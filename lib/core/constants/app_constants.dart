/// Константы приложения Harmony
class AppConstants {
  // Название приложения
  static const String appName = 'Harmony';
  static const String appVersion = '1.0.0';
  
  // API конфигурация (в продакшене задать через --dart-define или env)
  static const String baseUrl = String.fromEnvironment(
    'HARMONY_API_URL',
    defaultValue: 'https://api.harmonymeditation.online',
  );
  /// Ключ приложения для API. Переопределить: --dart-define=HARMONY_APP_KEY=...
  static const String appKey = String.fromEnvironment(
    'HARMONY_APP_KEY',
    defaultValue: 'E7/psBnCVeK0R1h2mL/F1sI5n6OvWAsLyWN1sTxCN3M=',
  );
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
  
  // Пароль: мин 8, макс 128 символов; минимум 1 буква и 1 цифра
  static const int passwordMinLength = 8;
  static const int passwordMaxLength = 128;
  
  // Ограничения
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  
  // Сетевые настройки
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
