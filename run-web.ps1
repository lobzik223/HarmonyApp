# Run Harmony App in Chrome (Web). If flutter not in PATH, set your path below (folder that contains flutter.bat).

# Option: set your Flutter bin path here (Android Studio: Settings -> Flutter -> Flutter SDK path, then add \bin)
# $flutterBin = "C:\flutter\bin"

if (-not $flutterBin) { $flutterBin = $env:FLUTTER_ROOT }
if (-not $flutterBin) {
  $paths = @(
    "C:\flutter\bin",
    "$env:USERPROFILE\flutter\bin",
    "C:\src\flutter\bin",
    "$env:LOCALAPPDATA\Android\flutter\bin"
  )
  foreach ($p in $paths) {
    if (Test-Path "$p\flutter.bat") { $flutterBin = $p; break }
  }
}

if (-not $flutterBin -or -not (Test-Path "$flutterBin\flutter.bat")) {
  Write-Host "Flutter not found in default paths." -ForegroundColor Yellow
  Write-Host "Enter path to Flutter BIN folder (folder that contains flutter.bat)." -ForegroundColor Cyan
  Write-Host "Example: C:\flutter\bin  or get from Android Studio: Settings -> Flutter -> Flutter SDK path, then add \bin" -ForegroundColor Gray
  $flutterBin = Read-Host "Flutter bin path"
  $flutterBin = $flutterBin.Trim().Trim('"')
  if ($flutterBin -and -not $flutterBin.EndsWith("\bin")) { $flutterBin = Join-Path $flutterBin "bin" }
  if (-not $flutterBin -or -not (Test-Path "$flutterBin\flutter.bat")) {
    Write-Host "Path invalid or flutter.bat not found." -ForegroundColor Red
    if ($flutterBin) { Write-Host "  Checked: $flutterBin\flutter.bat (folder exists: $(Test-Path $flutterBin))" -ForegroundColor Gray }
    Write-Host "If Flutter is not installed: install from https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Cyan
    Write-Host "If installed: open Android Studio -> File -> Settings -> Languages & Frameworks -> Flutter, copy 'Flutter SDK path', add \bin" -ForegroundColor Cyan
    exit 1
  }
}

$env:PATH = "$flutterBin;$env:PATH"
Set-Location $PSScriptRoot

Write-Host "Using Flutter: $flutterBin" -ForegroundColor Green
& "$flutterBin\flutter.bat" config --enable-web 2>$null
& "$flutterBin\flutter.bat" pub get
& "$flutterBin\flutter.bat" run -d chrome
