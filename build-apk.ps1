# Сборка APK с ключом приложения (APP_KEY из backend-harmony/.env)
# Укажите свой HARMONY_APP_KEY ниже или задайте переменную окружения $env:HARMONY_APP_KEY

$flutterBin = $env:FLUTTER_ROOT
if (-not $flutterBin) {
  foreach ($p in @("C:\flutter\bin", "$env:USERPROFILE\flutter\bin")) {
    if (Test-Path "$p\flutter.bat") { $flutterBin = $p; break }
  }
}

if (-not $flutterBin -or -not (Test-Path "$flutterBin\flutter.bat")) {
  Write-Host "Flutter not found. Set path or run: `$env:FLUTTER_ROOT = 'C:\flutter\bin'" -ForegroundColor Red
  exit 1
}

$env:PATH = "$flutterBin;$env:PATH"
Set-Location $PSScriptRoot

# Ключ: тот же что APP_KEY в backend-harmony/.env (подставьте свой или задайте $env:HARMONY_APP_KEY)
$appKey = $env:HARMONY_APP_KEY
if (-not $appKey) {
  $appKey = "E7/psBnCVeK0R1h2mL/F1sI5n6OvWAsLyWN1sTxCN3M="
}

Write-Host "Building APK with HARMONY_APP_KEY..." -ForegroundColor Green
& "$flutterBin\flutter.bat" build apk --release `
  --dart-define=HARMONY_API_URL=https://api.harmonymeditation.online `
  --dart-define=HARMONY_APP_KEY=$appKey
