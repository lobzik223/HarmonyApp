import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/utils/navigation_utils.dart';
import '../../main.dart';
import '../meditation/meditation_screen.dart';
import '../sleep/sleep_screen.dart';
import '../tasks/tasks_screen.dart';

/// Экран плеера с фоновой иллюстрацией и фирменным нижним меню
class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/playerfon.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                );
              },
            ),
          ),

          // Нижнее меню навигации
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 63,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipPath(
                    clipper: PlayerBottomMenuClipper(),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        height: 63,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMeditationIcon(context),
                        _buildPlayerIcon(context),
                        _buildCentralButton(context),
                        _buildSleepIcon(),
                        _buildBookIcon(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const MeditationScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/profileicon.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const SleepScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/sleeplogo.png',
            width: 28,
            height: 28,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.bedtime,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCentralButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const HomeScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/harmonyicon.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.image,
                  color: Colors.blue,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActivePlayerHalo() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepIcon() {
    return Transform.translate(
      offset: const Offset(6, 0),
      child: SizedBox(
        width: 46,
        height: 46,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildActivePlayerHalo(),
            Image.asset(
              'assets/icons/mediaicon.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 20,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookIcon(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          noAnimationRoute(const TasksScreen()),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/bookicon.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 20,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PlayerBottomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final scaleX = size.width / 375;
    final scaleY = size.height / 63;

    final path = Path()
      ..moveTo(21.1753 * scaleX, 1.2144 * scaleY)
      ..cubicTo(
        9.66565 * scaleX,
        0.582053 * scaleY,
        0,
        9.73658 * scaleY,
        0,
        21.2635 * scaleY,
      )
      ..lineTo(0, 71 * scaleY)
      ..cubicTo(
        0,
        75.4183 * scaleY,
        3.58172 * scaleX,
        79 * scaleY,
        8 * scaleX,
        79 * scaleY,
      )
      ..lineTo(367 * scaleX, 79 * scaleY)
      ..cubicTo(
        371.418 * scaleX,
        79 * scaleY,
        375 * scaleX,
        75.4183 * scaleY,
        375 * scaleX,
        71 * scaleY,
      )
      ..lineTo(375 * scaleX, 21.2635 * scaleY)
      ..cubicTo(
        375 * scaleX,
        9.73658 * scaleY,
        365.334 * scaleX,
        0.582054 * scaleY,
        353.825 * scaleX,
        1.2144 * scaleY,
      )
      ..cubicTo(
        341.455 * scaleX,
        1.89399 * scaleY,
        324.546 * scaleX,
        2.77789 * scaleY,
        305.498 * scaleX,
        3.64942 * scaleY,
      )
      ..cubicTo(
        297.261 * scaleX,
        4.02626 * scaleY,
        290 * scaleX,
        21.7548 * scaleY,
        290 * scaleX,
        30 * scaleY,
      )
      ..cubicTo(
        290 * scaleX,
        45.464 * scaleY,
        277.464 * scaleX,
        58 * scaleY,
        262 * scaleX,
        58 * scaleY,
      )
      ..cubicTo(
        246.536 * scaleX,
        58 * scaleY,
        234 * scaleX,
        45.464 * scaleY,
        234 * scaleX,
        30 * scaleY,
      )
      ..cubicTo(
        234 * scaleX,
        22.2739 * scaleY,
        226.451 * scaleX,
        6.50428 * scaleY,
        218.727 * scaleX,
        6.65803 * scaleY,
      )
      ..cubicTo(
        207.834 * scaleX,
        6.87484 * scaleY,
        197.302 * scaleX,
        6.99998 * scaleY,
        187.5 * scaleX,
        6.99998 * scaleY,
      )
      ..cubicTo(
        133.621 * scaleX,
        6.99998 * scaleY,
        57.656 * scaleX,
        3.21868 * scaleY,
        21.1753 * scaleX,
        1.2144 * scaleY,
      )
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

