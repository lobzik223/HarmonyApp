# Запуск Harmony App в Chrome (Web)

## 0. Если «flutter не распознаётся» (Flutter не в PATH)

**Вариант А — узнать путь к Flutter в Android Studio**  
File → Settings → Languages & Frameworks → Flutter → поле **Flutter SDK path**.  
Скопируйте путь (например `C:\flutter`). В командах ниже нужна папка **bin**: `C:\flutter\bin`.

**Вариант Б — один раз добавить в PATH для текущего окна PowerShell:**

```powershell
$env:PATH = "C:\flutter\bin;$env:PATH"
```

Замените `C:\flutter\bin` на ваш путь к папке `flutter\bin`. После этого в этом же окне выполните `flutter run -d chrome`.

**Вариант В — скрипт run-web.ps1**  
В папке HarmonyApp есть `run-web.ps1`. Откройте его, в начале укажите путь к `flutter\bin` в строке с `$flutterBin = "..."`, сохраните и выполните в PowerShell:

```powershell
cd c:\Users\pc\Desktop\Harmony-App\HarmonyApp
.\run-web.ps1
```

## 1. Убедитесь, что Flutter установлен

В терминале (после добавления в PATH или из Android Studio):

```bash
flutter --version
```

Типичный путь Flutter на Windows: `C:\flutter\bin`, `C:\src\flutter\bin` или `C:\Users\<имя>\flutter\bin`.

---

## 2. Включите поддержку Web (один раз)

```bash
flutter config --enable-web
```

---

## 3. Перейдите в папку проекта и запустите в Chrome

```bash
cd c:\Users\pc\Desktop\Harmony-App\HarmonyApp
flutter pub get
flutter run -d chrome
```

Если Chrome не определился автоматически:

```bash
flutter run -d web-server --web-port=8080
```

После этого откройте в браузере: **http://localhost:8080**

---

## 4. Если появляются ошибки

- **«No devices found»** — выполните `flutter config --enable-web` и снова `flutter run -d chrome`.
- **Chrome не в списке** — установите Chrome или используйте `flutter run -d web-server --web-port=8080` и откройте ссылку в любом браузере.
- **Ошибки зависимостей** — выполните `flutter clean`, затем `flutter pub get`, затем снова `flutter run -d chrome`.
- **Flutter не найден в PowerShell** — откройте **CMD** или терминал из Android Studio (File → Open → HarmonyApp → внизу Terminal) и выполните команды там.

---

## Быстрая команда (всё в одном)

В папке проекта:

```bash
flutter config --enable-web
flutter pub get
flutter run -d chrome
```
