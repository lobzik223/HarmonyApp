# Harmony App

Кроссплатформенное приложение для iOS и Android, созданное на Flutter.

## 🚀 Особенности

- **Кроссплатформенность**: Работает на iOS и Android
- **Современный дизайн**: Material Design 3 с поддержкой темной темы
- **Архитектура**: Чистая архитектура с разделением на слои
- **Управление состоянием**: Riverpod для реактивного программирования
- **Навигация**: Go Router для декларативной навигации
- **Локальное хранение**: Hive, SQLite, SharedPreferences
- **Сетевые запросы**: Dio для HTTP клиента
- **Анимации**: Lottie, Shimmer, Staggered Animations
- **Безопасность**: Биометрическая аутентификация, шифрование
- **Уведомления**: Локальные уведомления
- **Аналитика**: Firebase Analytics и Crashlytics

## 📱 Поддерживаемые платформы

- **iOS**: 12.0+
- **Android**: API 21+ (Android 5.0+)

## 🛠 Технологический стек

### Основные зависимости
- `flutter_riverpod` - Управление состоянием
- `go_router` - Навигация и роутинг
- `dio` - HTTP клиент
- `hive` - Локальная база данных
- `shared_preferences` - Простые настройки
- `sqflite` - SQLite база данных

### UI и анимации
- `lottie` - Анимации
- `shimmer` - Эффекты загрузки
- `flutter_staggered_animations` - Анимации появления
- `cached_network_image` - Кэширование изображений

### Платформо-специфичные функции
- `device_info_plus` - Информация об устройстве
- `package_info_plus` - Информация о приложении
- `connectivity_plus` - Проверка подключения
- `local_auth` - Биометрическая аутентификация
- `flutter_local_notifications` - Уведомления
- `image_picker` - Выбор изображений

### Firebase
- `firebase_core` - Основной Firebase SDK
- `firebase_analytics` - Аналитика
- `firebase_crashlytics` - Отчеты о сбоях

## 🏗 Архитектура проекта

```
lib/
├── app/                    # Конфигурация приложения
├── core/                   # Основные компоненты
│   ├── constants/         # Константы
│   ├── theme/            # Темы и стили
│   ├── utils/            # Утилиты
│   ├── services/         # Сервисы
│   └── widgets/          # Базовые виджеты
├── features/             # Функциональные модули
├── shared/               # Общие компоненты
│   ├── models/           # Модели данных
│   ├── repositories/     # Репозитории
│   ├── providers/        # Провайдеры состояния
│   └── widgets/          # Переиспользуемые виджеты
└── main.dart            # Точка входа
```

## 🚀 Быстрый старт

### Предварительные требования

1. **Flutter SDK** (3.9.2+)
2. **Dart SDK** (3.9.2+)
3. **Android Studio** или **VS Code** с Flutter расширениями
4. **Xcode** (для iOS разработки)
5. **CocoaPods** (для iOS зависимостей)

### Установка

1. Клонируйте репозиторий:
```bash
git clone <repository-url>
cd harmony_app
```

2. Установите зависимости:
```bash
flutter pub get
```

3. Для iOS установите CocoaPods зависимости:
```bash
cd ios && pod install && cd ..
```

### Запуск

#### Android
```bash
flutter run
```

#### iOS
```bash
flutter run -d ios
```

### Сборка

#### Android APK
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Сборка для продакшена (API + ключ приложения)

Если бекенд использует ключ приложения (`APP_KEY`), при сборке релиза передайте тот же ключ и при необходимости URL API (по умолчанию уже `https://api.harmonymeditation.online`). Связка всех проектов описана в **ENV-SETUP.md** в корне репозитория.

```bash
# Android
flutter build apk --release --dart-define=HARMONY_APP_KEY=значение_APP_KEY_из_бэкенда

# iOS
flutter build ios --release --dart-define=HARMONY_APP_KEY=значение_APP_KEY_из_бэкенда
```

Опционально другой URL API:
```bash
--dart-define=HARMONY_API_URL=https://api.harmonymeditation.online --dart-define=HARMONY_APP_KEY=...
```

## 📁 Структура ассетов

```
assets/
├── images/          # Изображения
├── icons/           # Иконки
├── animations/      # Lottie анимации
├── sounds/          # Звуковые файлы
├── data/            # JSON данные
└── fonts/           # Кастомные шрифты
```

## 🎨 Дизайн система

### Цветовая палитра
- **Primary**: #6366F1 (Индиго)
- **Secondary**: #10B981 (Изумрудный)
- **Accent**: #F59E0B (Янтарный)
- **Success**: #10B981
- **Warning**: #F59E0B
- **Error**: #EF4444
- **Info**: #3B82F6

### Типографика
- **Семейство шрифтов**: HarmonyApp
- **Веса**: Light (300), Regular (400), Bold (700)

### Компоненты
- Скругленные углы: 12px
- Отступы: 8px, 16px, 24px
- Тени: Material Design 3
- Анимации: 150ms, 300ms, 500ms

## 🔧 Конфигурация

### Android
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 35
- **Compile SDK**: 35
- **Java Version**: 17

### iOS
- **Min iOS**: 12.0
- **Swift**: 5.0+
- **Xcode**: 14.0+

## 📝 Разработка

### Линтинг
```bash
flutter analyze
```

### Тестирование
```bash
flutter test
```

### Генерация кода
```bash
flutter packages pub run build_runner build
```

## 🚀 Развертывание

### Android
1. Настройте подпись приложения
2. Создайте release APK:
```bash
flutter build apk --release
```

### iOS
1. Настройте Apple Developer аккаунт
2. Создайте release сборку:
```bash
flutter build ios --release
```

## 📄 Лицензия

Этот проект лицензирован под MIT License.

## 🤝 Вклад в проект

1. Форкните репозиторий
2. Создайте ветку для новой функции
3. Внесите изменения
4. Создайте Pull Request

## 📞 Поддержка

Если у вас есть вопросы или проблемы, создайте issue в репозитории.