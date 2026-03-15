import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../shared/models/meditation_track.dart';

/// Глобальный сервис воспроизведения аудио.
/// Используется при выборе трека на главной, в медитациях, курсах и т.д.
class AudioService extends ChangeNotifier {
  AudioService._();
  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();

  String? _currentUrl;
  MeditationTrack? _currentTrack;
  List<MeditationTrack> _currentTrackContext = [];
  bool _isPlaying = false;
  bool _isLoading = false;
  double _progress = 0.0;
  Duration _position = Duration.zero;
  Duration? _duration;

  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;

  bool get isPlaying => _isPlaying;
  /// Трек загружается или буферизуется — показывать индикатор загрузки, скрывать prev/next.
  bool get isLoading => _isLoading;
  double get progress => _progress;
  Duration get position => _position;
  Duration? get duration => _duration;
  String? get currentUrl => _currentUrl;
  MeditationTrack? get currentTrack => _currentTrack;
  List<MeditationTrack> get currentTrackContext => List.unmodifiable(_currentTrackContext);

  /// Установить активный трек (для мини-плеера во всех окнах).
  void setActiveTrack(MeditationTrack track, List<MeditationTrack> context) {
    _currentTrack = track;
    _currentTrackContext = context;
    notifyListeners();
  }

  /// Очистить активный трек.
  void clearActiveTrack() {
    _currentTrack = null;
    _currentTrackContext = [];
    notifyListeners();
  }

  String get formattedPosition {
    final d = _position;
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String get formattedDuration {
    final d = _duration;
    if (d == null) return '0:00';
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _initListeners() {
    _durationSub?.cancel();
    _positionSub?.cancel();
    _stateSub?.cancel();

    _durationSub = _player.durationStream.listen((d) {
      _duration = d;
      _updateProgress();
      notifyListeners();
    });

    _positionSub = _player.positionStream.listen((p) {
      _position = p;
      _updateProgress();
      notifyListeners();
    });

    _stateSub = _player.playerStateStream.listen((s) {
      final wasPlaying = _isPlaying;
      final wasLoading = _isLoading;
      _isPlaying = s.playing;
      _isLoading = s.processingState == ProcessingState.loading ||
          s.processingState == ProcessingState.buffering;
      if (wasPlaying != _isPlaying || wasLoading != _isLoading) notifyListeners();
    });
  }

  void _updateProgress() {
    final d = _duration;
    if (d != null && d.inMilliseconds > 0) {
      _progress = _position.inMilliseconds / d.inMilliseconds;
    } else {
      _progress = 0.0;
    }
  }

  /// Воспроизвести по URL. Если url пустой — ничего не делает.
  Future<void> play(String url) async {
    if (url.isEmpty) return;
    _currentUrl = url;
    _isLoading = true;
    _initListeners();
    notifyListeners();
    try {
      await _player.setUrl(url);
      await _player.play();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('AudioService play error: $e');
      _isPlaying = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Поставить на паузу.
  Future<void> pause() async {
    await _player.pause();
    _isPlaying = false;
    notifyListeners();
  }

  /// Переключить play/pause.
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      if (_currentUrl != null && _currentUrl!.isNotEmpty) {
        await _player.play();
        _isPlaying = true;
        notifyListeners();
      }
    }
  }

  /// Перемотать к позиции (0.0–1.0).
  Future<void> seekTo(double progress) async {
    final d = _duration;
    if (d == null) return;
    final pos = Duration(milliseconds: (progress * d.inMilliseconds).round());
    await _player.seek(pos);
  }

  /// Остановить и сбросить.
  Future<void> stop() async {
    await _player.stop();
    _currentUrl = null;
    _currentTrack = null;
    _currentTrackContext = [];
    _isPlaying = false;
    _isLoading = false;
    _progress = 0.0;
    _position = Duration.zero;
    _duration = null;
    notifyListeners();
  }

  void dispose() {
    _durationSub?.cancel();
    _positionSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
  }
}
