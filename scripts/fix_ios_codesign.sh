#!/bin/bash
# Исправление ошибки: "resource fork, Finder information, or similar detritus not allowed"
# Запускать перед flutter build ios если сборка падает с PhaseScriptExecution

set -e
cd "$(dirname "$0")/.."

echo "Очистка расширенных атрибутов..."
if [ -d "build/ios" ]; then
  xattr -cr build/ios 2>/dev/null || true
  echo "  ✓ build/ios"
fi
if [ -n "$FLUTTER_ROOT" ] && [ -d "$FLUTTER_ROOT/bin/cache/artifacts/engine" ]; then
  xattr -cr "$FLUTTER_ROOT/bin/cache/artifacts/engine" 2>/dev/null || true
  echo "  ✓ Flutter engine cache"
fi
echo "Готово. Запустите: flutter clean && flutter pub get && flutter build ios"
