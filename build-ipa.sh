#!/bin/bash
# Сборка IPA для App Store (запускать на Mac)
# Использует те же ключи, что и DartDefines.xcconfig

APP_KEY="${HARMONY_APP_KEY:-E7/psBnCVeK0R1h2mL/F1sI5n6OvWAsLyWN1sTxCN3M=}"

cd "$(dirname "$0")"
flutter build ipa --release \
  --dart-define=HARMONY_API_URL=https://api.harmonymeditation.online \
  --dart-define=HARMONY_APP_KEY="$APP_KEY"
