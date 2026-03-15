import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../../l10n/app_localizations.dart';
import '../../core/api/content_api.dart';
import '../../core/utils/navigation_utils.dart';
import '../../main.dart';
import '../../shared/models/meditation_track.dart';
import '../../shared/widgets/harmony_bottom_nav.dart';
import '../meditation/meditation_screen.dart';
import '../sleep/sleep_screen.dart';
import '../tasks/tasks_screen.dart';

/// Полноэкранный видеоплеер для видео-треков.
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.track,
    this.tracks,
    this.initialIndex = 0,
  });

  final MeditationTrack track;
  final List<MeditationTrack>? tracks;
  final int initialIndex;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  int _currentIndex = 0;
  bool _initialized = false;
  String? _error;
  Timer? _hideControlsTimer;
  bool _showControls = true;

  List<MeditationTrack> get _tracks => widget.tracks ?? [widget.track];
  MeditationTrack get _track => _tracks[_currentIndex.clamp(0, _tracks.length - 1)];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.tracks != null
        ? widget.initialIndex.clamp(0, widget.tracks!.length - 1)
        : 0;
    _initVideo();
  }

  void _initVideo() {
    final url = _track.video;
    if (url.isEmpty) {
      setState(() => _error = 'Нет URL видео');
      return;
    }
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _initialized = true;
          _error = null;
        });
        _controller.play();
        _startHideControlsTimer();
      }
    }).catchError((e) {
      if (mounted) setState(() => _error = e.toString());
    });
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
        _startHideControlsTimer();
      }
    });
  }

  void _handlePrevious() {
    if (_tracks.length > 1 && _currentIndex > 0) {
      _controller.pause();
      _controller.dispose();
      setState(() => _currentIndex = _currentIndex - 1);
      _initVideo();
      ContentApi.registerTrackListen(_track.id).catchError((_) {});
    }
  }

  void _handleNext() {
    if (_tracks.length > 1 && _currentIndex < _tracks.length - 1) {
      _controller.pause();
      _controller.dispose();
      setState(() => _currentIndex = _currentIndex + 1);
      _initVideo();
      ContentApi.registerTrackListen(_track.id).catchError((_) {});
    }
  }

  void _handleBack() {
    Navigator.of(context).pop(_track.id);
  }

  void _handleBottomNavTap(HarmonyTab tab) {
    Navigator.of(context).pop(_track.id);
    if (tab == HarmonyTab.meditation) {
      Navigator.of(context).push(noAnimationRoute(const MeditationScreen()));
    } else if (tab == HarmonyTab.sleep) {
      Navigator.of(context).push(noAnimationRoute(const SleepScreen()));
    } else if (tab == HarmonyTab.home) {
      Navigator.of(context).pushReplacement(noAnimationRoute(const HomeScreen()));
    } else if (tab == HarmonyTab.tasks) {
      Navigator.of(context).push(noAnimationRoute(const TasksScreen()));
    }
  }

  void _onTapVideo() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) _startHideControlsTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: _onTapVideo,
            child: Center(
              child: _buildVideo(),
            ),
          ),
          if (_showControls) ...[
            _buildTopGradient(),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8),
                  child: Material(
                    color: const Color(0xFFE8E8E8),
                    borderRadius: BorderRadius.circular(24),
                    elevation: 0,
                    child: InkWell(
                      onTap: _handleBack,
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Text(
                          AppLocalizations.of(context)!.back,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF424242),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildControls(),
                  HarmonyBottomNav(
                    activeTab: HarmonyTab.player,
                    onTabSelected: _handleBottomNavTap,
                    glassStyle: true,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVideo() {
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white54, size: 64),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }
    if (!_initialized) {
      return const CircularProgressIndicator(color: Colors.white54);
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }

  Widget _buildTopGradient() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.5),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    final duration = _controller.value.duration;
    final position = _controller.value.position;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;
    final totalStr = duration.inMilliseconds > 0
        ? '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}'
        : '0:00';
    final posStr = '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white38,
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: (v) {
                final pos = Duration(milliseconds: (v * duration.inMilliseconds).round());
                _controller.seekTo(pos);
              },
            ),
          ),
          Row(
            children: [
              Text(
                posStr,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const Spacer(),
              Text(
                totalStr,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_tracks.length > 1 && _currentIndex > 0)
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 40),
                  onPressed: _handlePrevious,
                ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 56,
                ),
                onPressed: _togglePlayPause,
              ),
              const SizedBox(width: 16),
              if (_tracks.length > 1 && _currentIndex < _tracks.length - 1)
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 40),
                  onPressed: _handleNext,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _track.title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
