#!/bin/bash
# Настройка ANDROID_HOME для сборки Flutter Android APK.
# Запусти: source scripts/setup_android_env.sh (или . scripts/setup_android_env.sh)

# Стандартный путь после установки Android Studio на Mac
if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"
  echo "ANDROID_HOME=$ANDROID_HOME"
  echo "Готово. Можно собирать: flutter build apk --release"
  exit 0
fi

echo "Android SDK не найден в $HOME/Library/Android/sdk"
echo ""
echo "1. Установи Android Studio: https://developer.android.com/studio"
echo "2. В Android Studio: More Actions → SDK Manager → установи Android SDK (путь будет показан)"
echo "3. Либо установи только command-line tools: https://developer.android.com/studio#command-tools"
echo "4. Затем выполни: export ANDROID_HOME=/путь/к/sdk"
exit 1
