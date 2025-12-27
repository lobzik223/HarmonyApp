import 'dart:ui';

import 'package:flutter/material.dart';

/// Вкладки нижнего меню Harmony
enum HarmonyTab { meditation, sleep, home, player, tasks }

/// Унифицированное нижнее меню с фиксированными позициями иконок.
class HarmonyBottomNav extends StatelessWidget {
  const HarmonyBottomNav({
    super.key,
    required this.activeTab,
    this.onTabSelected,
    this.isHomeStyle = false,
    this.highlightHomeIdle = false,
    this.leadingEdgeCutoutTab,
  });

  final HarmonyTab activeTab;
  final ValueChanged<HarmonyTab>? onTabSelected;
  final bool isHomeStyle;
  final bool highlightHomeIdle;
  final HarmonyTab? leadingEdgeCutoutTab;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).padding.bottom;
    const double backgroundOffset = 8.0;

    return SizedBox(
      height: 80 + bottomInset + backgroundOffset,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, backgroundOffset),
              child: ClipPath(
                clipper: _HarmonyBottomClipper(
                  activeTab: activeTab,
                  mode: isHomeStyle
                      ? _ClipperMode.homeStatic
                      : (leadingEdgeCutoutTab != null &&
                              activeTab == leadingEdgeCutoutTab
                          ? _ClipperMode.leadingEdge
                          : (activeTab == HarmonyTab.meditation
                              ? _ClipperMode.leadingEdge
                              : (activeTab == HarmonyTab.tasks
                                  ? _ClipperMode.leadingEdge
                                  : _ClipperMode.dynamicNotch))),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    padding: EdgeInsets.only(bottom: bottomInset),
                    decoration: (isHomeStyle || activeTab == HarmonyTab.tasks)
                        ? BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                          )
                        : const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF44AAED),
                                Color(0xFF46E4E3),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                top: 6,
                bottom: bottomInset > 0 ? bottomInset / 2 : 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: HarmonyTab.values
                    .map(
                      (tab) {
                        // Сдвигаем иконки чуть правее (левее от исходной позиции)
                        final bool isPlayer = tab == HarmonyTab.player;
                        final bool isSleep = tab == HarmonyTab.sleep;
                        final bool isMeditation = tab == HarmonyTab.meditation;
                        final bool isTasks = tab == HarmonyTab.tasks;
                        final Widget navItem = _HarmonyNavItem(
                          tab: tab,
                          isSelected: tab == activeTab,
                          onTap: onTabSelected,
                          highlightHomeIdle: highlightHomeIdle,
                        );
                        if (isMeditation) {
                          return Transform.translate(
                            offset: const Offset(-5, 0), // Сдвиг влево на 5 пикселей
                            child: navItem,
                          );
                        }
                        if (isPlayer) {
                          return Transform.translate(
                            offset: const Offset(3, 0), // Сдвиг вправо на 3 пикселя
                            child: navItem,
                          );
                        }
                        if (isSleep) {
                          return Transform.translate(
                            offset: const Offset(-2, 0), // Сдвиг влево на 2 пикселя
                            child: navItem,
                          );
                        }
                        if (isTasks) {
                          return Transform.translate(
                            offset: const Offset(6, 0), // Сдвиг вправо на 6 пикселей
                            child: navItem,
                          );
                        }
                        return navItem;
                      },
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HarmonyNavItem extends StatelessWidget {
  const _HarmonyNavItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
    required this.highlightHomeIdle,
  });

  final HarmonyTab tab;
  final bool isSelected;
  final ValueChanged<HarmonyTab>? onTap;
  final bool highlightHomeIdle;

  static const _iconPaths = {
    HarmonyTab.meditation: 'assets/icons/profileicon.png',
    HarmonyTab.sleep: 'assets/icons/sleeplogo.png',
    HarmonyTab.home: 'assets/icons/harmonyicon.png',
    HarmonyTab.player: 'assets/icons/mediaicon.png',
    HarmonyTab.tasks: 'assets/icons/bookicon.png',
  };

  @override
  Widget build(BuildContext context) {
    final bool isHome = tab == HarmonyTab.home;
    final double badgeSize = isHome ? 56 : 48;
    final double iconSize = isHome ? 30 : 28;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!isSelected) {
          onTap?.call(tab);
        }
      },
      child: SizedBox(
        width: 64,
        height: 64,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: badgeSize,
              height: badgeSize,
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF44AAED), Color(0xFF46E4E3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(badgeSize / 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          offset: const Offset(0, 6),
                          blurRadius: 12,
                        ),
                      ],
                    )
                  : BoxDecoration(
                      color: isHome && highlightHomeIdle
                          ? Colors.white.withOpacity(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(badgeSize / 2),
                    ),
            ),
            Image.asset(
              _iconPaths[tab]!,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.circle,
                  size: iconSize,
                  color: Colors.white.withOpacity(0.8),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum _ClipperMode { homeStatic, dynamicNotch, leadingEdge }

class _HarmonyBottomClipper extends CustomClipper<Path> {
  const _HarmonyBottomClipper({
    required this.activeTab,
    required this.mode,
  });

  final HarmonyTab activeTab;
  final _ClipperMode mode;

  @override
  Path getClip(Size size) {
    if (mode == _ClipperMode.homeStatic) {
      return _buildHomePath(size);
    }
    if (mode == _ClipperMode.leadingEdge) {
      return _buildLeadingEdgePath(size);
    }
    return _buildDynamicPath(size);
  }

  Path _buildHomePath(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(21.1753 * width / 375, 0.0308974 * height / 80);
    path.cubicTo(
      9.66565 * width / 375,
      -0.601449 * height / 80,
      0,
      8.55308 * height / 80,
      0,
      20.08 * height / 80,
    );
    path.lineTo(0, 69.8165 * height / 80);
    path.cubicTo(
      0,
      74.2348 * height / 80,
      3.58172 * height / 80,
      77.8165 * height / 80,
      8 * height / 80,
      77.8165 * height / 80,
    );
    path.lineTo(367 * width / 375, 77.8165 * height / 80);
    path.cubicTo(
      371.418 * height / 80,
      77.8165 * height / 80,
      375 * width / 375,
      74.2348 * height / 80,
      375 * width / 375,
      69.8165 * height / 80,
    );
    path.lineTo(375 * width / 375, 20.08 * height / 80);
    path.cubicTo(
      375 * width / 375,
      8.55308 * height / 80,
      365.334 * width / 375,
      -0.601448 * height / 80,
      353.825 * width / 375,
      0.0308983 * height / 80,
    );
    path.cubicTo(
      325.867 * width / 375,
      1.56691 * height / 80,
      274.72 * width / 375,
      4.14658 * height / 80,
      228.096 * width / 375,
      5.26815 * height / 80,
    );
    path.cubicTo(
      220.288 * width / 375,
      5.45598 * height / 80,
      214.418 * width / 375,
      19.1347 * height / 80,
      214.937 * width / 375,
      26.9279 * height / 80,
    );
    path.cubicTo(
      214.979 * width / 375,
      27.5521 * height / 80,
      215 * width / 375,
      28.1818 * height / 80,
      215 * width / 375,
      28.8165 * height / 80,
    );
    path.cubicTo(
      215 * width / 375,
      44.2805 * height / 80,
      202.464 * width / 375,
      56.8165 * height / 80,
      187 * width / 375,
      56.8165 * height / 80,
    );
    path.cubicTo(
      171.536 * width / 375,
      56.8165 * height / 80,
      159 * width / 375,
      44.2805 * height / 80,
      159 * width / 375,
      28.8165 * height / 80,
    );
    path.cubicTo(
      159 * width / 375,
      28.1766 * height / 80,
      159.021 * width / 375,
      27.5418 * height / 80,
      159.064 * width / 375,
      26.9126 * height / 80,
    );
    path.cubicTo(
      159.587 * width / 375,
      19.1192 * height / 80,
      153.725 * width / 375,
      5.4352 * height / 80,
      145.917 * width / 375,
      5.24419 * height / 80,
    );
    path.cubicTo(
      99.5592 * width / 375,
      4.11023 * height / 80,
      48.9355 * width / 375,
      1.55607 * height / 80,
      21.1753 * width / 375,
      0.0308974 * height / 80,
    );
    path.close();
    return path;
  }

  Path _buildDynamicPath(Size size) {
    final tabs = HarmonyTab.values.length;
    final tabWidth = size.width / tabs;
    final notchRadius = 27.0;
    final notchDepth = 26.0;
    final activeIndex = HarmonyTab.values.indexOf(activeTab).clamp(0, tabs - 1);
    final isEdge = activeIndex == 0 || activeIndex == tabs - 1;
    final safeEdge = isEdge ? 8.0 : 18.0;
    double notchCenter = (activeIndex + 0.5) * tabWidth;
    double notchStart = notchCenter - notchRadius;
    double notchEnd = notchCenter + notchRadius;

    if (notchStart < safeEdge) {
      final shift = safeEdge - notchStart;
      notchStart = safeEdge;
      notchEnd += shift;
      notchCenter += shift / 2;
    }
    if (notchEnd > size.width - safeEdge) {
      final shift = notchEnd - (size.width - safeEdge);
      notchEnd = size.width - safeEdge;
      notchStart -= shift;
      notchCenter -= shift / 2;
    }

    final path = Path();
    path.moveTo(0, 22);
    path.quadraticBezierTo(0, 0, safeEdge, 0);
    path.lineTo(notchStart, 0);
    path.cubicTo(
      notchStart + notchRadius * 0.2,
      0,
      notchCenter - notchRadius * 0.9,
      notchDepth * 0.15,
      notchCenter - notchRadius * 0.55,
      notchDepth * 0.55,
    );
    path.quadraticBezierTo(
      notchCenter - notchRadius * 0.2,
      notchDepth,
      notchCenter,
      notchDepth,
    );
    path.quadraticBezierTo(
      notchCenter + notchRadius * 0.2,
      notchDepth,
      notchCenter + notchRadius * 0.55,
      notchDepth * 0.55,
    );
    path.cubicTo(
      notchCenter + notchRadius * 0.9,
      notchDepth * 0.15,
      notchEnd - notchRadius * 0.2,
      0,
      notchEnd,
      0,
    );
    path.lineTo(size.width - safeEdge, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 22);
    path.lineTo(size.width, size.height - 6);
    path.quadraticBezierTo(size.width, size.height, size.width - 10, size.height);
    path.lineTo(10, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 6);
    path.close();
    return path;
  }

  Path _buildLeadingEdgePath(Size size) {
    final activeIndex = HarmonyTab.values.indexOf(activeTab);
    
    // Точный путь из SVG - масштабируем под текущий размер
    const double refWidth = 375.0;
    const double refHeight = 62.0; // Высота viewBox из SVG
    final double sx = size.width / refWidth;
    final double sy = size.height / refHeight;

    // Вырез для медитации (индекс 0) - точный путь из предоставленного SVG
    if (activeIndex == 0) {
      const double meditationOffset = -3.0; // Сдвиг выреза влево (соответствует сдвигу иконки)
      final double syNew = size.height / 71.0; // viewBox высота 62
      
      // Точный путь из SVG: M38 57.8165C54.0163 57.8165 67 44.8328 67 28.8165...
      final path = Path()
        // M38 57.8165 - начало выреза
        ..moveTo((38 + meditationOffset) * sx, 57.8165 * syNew)
        // C54.0163 57.8165 67 44.8328 67 28.8165
        ..cubicTo(
          (54.0163 + meditationOffset) * sx, 57.8165 * syNew,
          (67 + meditationOffset) * sx, 44.8328 * syNew,
          (67 + meditationOffset) * sx, 28.8165 * syNew,
        )
        // C67 22.8861 77.4103 2.82512 83.3353 3.07893
        ..cubicTo(
          (67 + meditationOffset) * sx, 22.8861 * syNew,
          (77.4103 + meditationOffset) * sx, 2.82512 * syNew,
          (83.3353 + meditationOffset) * sx, 3.07893 * syNew,
        )
        // C117.465 4.54099 156.208 5.81648 187.5 5.81648
        ..cubicTo(
          117.465 * sx, 4.54099 * syNew,
          156.208 * sx, 5.81648 * syNew,
          187.5 * sx, 5.81648 * syNew,
        )
        // C241.379 5.81648 317.344 2.03518 353.825 0.0308982
        ..cubicTo(
          241.379 * sx, 5.81648 * syNew,
          317.344 * sx, 2.03518 * syNew,
          353.825 * sx, 0.0308982 * syNew,
        )
        // C365.334 -0.601449 375 8.55308 375 20.08
        ..cubicTo(
          365.334 * sx, -0.601449 * syNew,
          375 * sx, 8.55308 * syNew,
          375 * sx, 20.08 * syNew,
        )
        // V69.8165
        ..lineTo(375 * sx, 69.8165 * syNew)
        // C375 74.2348 371.418 77.8165 367 77.8165
        ..cubicTo(
          375 * sx, 74.2348 * syNew,
          371.418 * sx, 77.8165 * syNew,
          367 * sx, 77.8165 * syNew,
        )
        // H8
        ..lineTo(8 * sx, 77.8165 * syNew)
        // C3.58172 77.8165 0 74.2348 0 69.8165
        ..cubicTo(
          3.58172 * sx, 77.8165 * syNew,
          0, 74.2348 * syNew,
          0, 69.8165 * syNew,
        )
        // V20.08
        ..lineTo(0, 20.08 * syNew)
        // C0 8.55308 9.66565 -0.601449 21.1753 0.0308974
        ..cubicTo(
          0, 8.55308 * syNew,
          9.66565 * sx, -0.601449 * syNew,
          21.1753 * sx, 0.0308974 * syNew,
        )
        // C22.8539 0.123121 23.4448 3.67193 22.0419 4.59823
        ..cubicTo(
          (22.8539 + meditationOffset) * sx, 0.123121 * syNew,
          (23.4448 + meditationOffset) * sx, 3.67193 * syNew,
          (22.0419 + meditationOffset) * sx, 4.59823 * syNew,
        )
        // C14.1842 9.78633 9 18.696 9 28.8165
        ..cubicTo(
          (14.1842 + meditationOffset) * sx, 9.78633 * syNew,
          (9 + meditationOffset) * sx, 18.696 * syNew,
          (9 + meditationOffset) * sx, 28.8165 * syNew,
        )
        // C9 44.8328 21.9837 57.8165 38 57.8165
        ..cubicTo(
          (9 + meditationOffset) * sx, 44.8328 * syNew,
          (21.9837 + meditationOffset) * sx, 57.8165 * syNew,
          (38 + meditationOffset) * sx, 57.8165 * syNew,
        )
        ..close();

      return path;
    } else if (activeIndex == 1) {
      // Вырез для сна (вторая вкладка) - уменьшенная глубина, сдвинуто влево
      // Иконка сна сдвинута на 2px влево, вырез тоже сдвигаем
      const double sleepOffset = -2.0; // Сдвиг иконки влево
      final path = Path()
        // Вырез для сна - начинается с нижней точки круга (поднято выше), сдвинуто влево
        ..moveTo((113 + sleepOffset) * sx, 48 * sy) // Сдвинуто влево
        // Нижняя дуга выреза (справа)
        ..cubicTo(
          (129.016 + sleepOffset) * sx, 48 * sy, // Сдвинуто влево
          (142 + sleepOffset) * sx, 40 * sy, // Сдвинуто влево
          (142 + sleepOffset) * sx, 28.8165 * sy,
        )
        // Левая сторона выреза - идет вверх - сдвинуто влево
        ..cubicTo(
          (142 + sleepOffset) * sx, 28.5702 * sy, // Сдвинуто влево
          (141.997 + sleepOffset) * sx, 28.3247 * sy, // Сдвинуто влево
          (141.991 + sleepOffset) * sx, 28.0799 * sy, // Сдвинуто влево
        )
        ..cubicTo(
          (141.791 + sleepOffset) * sx, 20.0693 * sy, // Сдвинуто влево
          (148.805 + sleepOffset) * sx, 5.32789 * sy, // Сдвинуто влево
          (156.817 + sleepOffset) * sx, 5.48528 * sy, // Сдвинуто влево
        )
        // Продолжение верхней части пути
        ..cubicTo(
          167.516 * sx, 5.69547 * sy,
          177.862 * sx, 5.81648 * sy,
          187.5 * sx, 5.81648 * sy,
        )
        // Продолжение до правого края
        ..cubicTo(
          241.379 * sx, 5.81648 * sy,
          317.344 * sx, 2.03518 * sy,
          353.825 * sx, 0.0308982 * sy,
        )
        // Верхний правый угол
        ..cubicTo(
          365.334 * sx, -0.601449 * sy,
          375 * sx, 8.55308 * sy,
          375 * sx, 20.08 * sy,
        )
        // Правый край вниз
        ..lineTo(375 * sx, 69.8165 * sy)
        // Нижний правый угол
        ..cubicTo(
          375 * sx, 74.2348 * sy,
          371.418 * sx, 77.8165 * sy,
          367 * sx, 77.8165 * sy,
        )
        // Нижний край до левого нижнего угла
        ..lineTo(8 * sx, 77.8165 * sy)
        // Нижний левый угол
        ..cubicTo(
          3.58172 * sx, 77.8165 * sy,
          0, 74.2348 * sy,
          0, 69.8165 * sy,
        )
        // Левый край вверх
        ..lineTo(0, 20.08 * sy)
        // Верхний левый угол
        ..cubicTo(
          0, 8.55308 * sy,
          9.66565 * sx, -0.601449 * sy,
          21.1753 * sx, 0.0308974 * sy,
        )
        // Левая часть пути к вырезу
        ..cubicTo(
          33.8484 * sx, 0.727167 * sy,
          51.2864 * sx, 1.63789 * sy,
          70.9083 * sx, 2.53004 * sy,
        )
        ..cubicTo(
          78.9144 * sx, 2.89406 * sy,
          (84.8804 + sleepOffset) * sx, 18.0843 * sy, // Сдвинуто влево
          (84.129 + sleepOffset) * sx, 26.0634 * sy, // Сдвинуто влево
        )
        ..cubicTo(
          (84.0436 + sleepOffset) * sx, 26.9696 * sy, // Сдвинуто влево
          (84 + sleepOffset) * sx, 27.8879 * sy, // Сдвинуто влево
          (84 + sleepOffset) * sx, 28.8165 * sy, // Сдвинуто влево
        )
        // Замыкаем вырез - нижняя дуга выреза (слева) (поднято выше)
        ..cubicTo(
          (84 + sleepOffset) * sx, 40 * sy, // Сдвинуто влево
          (96.9837 + sleepOffset) * sx, 48 * sy, // Сдвинуто влево
          (113 + sleepOffset) * sx, 48 * sy, // Сдвинуто влево
        )
        ..close();

      return path;
    } else if (activeIndex == 3) {
      // Вырез для плеера (четвертая вкладка) - точный путь из SVG
      // В SVG viewBox высота = 63, но меню масштабируется под 62 (или 80 в коде)
      // Используем точный путь из SVG с правильным масштабированием
      const double refHeightPlayer = 63.0; // Высота viewBox из SVG для player
      final double syPlayer = size.height / refHeightPlayer;
      // Вырез для плеера - уменьшенная глубина (поднято выше), сдвинуто правее
      // Иконка плеера сдвинута на 3px вправо, вырез тоже сдвигаем
      const double playerOffset = 3.0; // Сдвиг иконки вправо
      
      final path = Path()
        ..moveTo((262 + playerOffset) * sx, 50 * syPlayer) // Сдвинуто правее
        // Нижняя дуга выреза (справа) - поднято выше, сдвинуто правее
        ..cubicTo(
          (277.464 + playerOffset) * sx, 50 * syPlayer, // Сдвинуто правее
          (290 + playerOffset) * sx, 40 * syPlayer, // Сдвинуто правее
          (290 + playerOffset) * sx, 30 * syPlayer, // Сдвинуто правее
        )
        // Левая сторона выреза - идет вверх - сдвинуто правее
        ..cubicTo(
          (290 + playerOffset) * sx, 21.7548 * syPlayer, // Сдвинуто правее
          (297.261 + playerOffset) * sx, 4.02626 * syPlayer, // Сдвинуто правее
          (305.498 + playerOffset) * sx, 3.64942 * syPlayer, // Сдвинуто правее
        )
        // Продолжение верхней части пути
        ..cubicTo(
          324.546 * sx, 2.77789 * syPlayer, // C324.546 2.77789
          341.455 * sx, 1.89399 * syPlayer, // 341.455 1.89399
          353.825 * sx, 1.2144 * syPlayer, // 353.825 1.2144
        )
        // Верхний правый угол
        ..cubicTo(
          365.334 * sx, 0.582054 * syPlayer, // C365.334 0.582054
          375 * sx, 9.73658 * syPlayer, // 375 9.73658
          375 * sx, 21.2635 * syPlayer, // 375 21.2635
        )
        // Правый край вниз
        ..lineTo(375 * sx, 71 * syPlayer) // V71
        // Нижний правый угол
        ..cubicTo(
          375 * sx, 75.4183 * syPlayer, // C375 75.4183
          371.418 * sx, 79 * syPlayer, // 371.418 79
          367 * sx, 79 * syPlayer, // 367 79
        )
        // Нижний край до левого нижнего угла
        ..lineTo(8 * sx, 79 * syPlayer) // H8
        // Нижний левый угол
        ..cubicTo(
          3.58172 * sx, 79 * syPlayer, // C3.58172 79
          0, 75.4183 * syPlayer, // 0 75.4183
          0, 71 * syPlayer, // 0 71
        )
        // Левый край вверх
        ..lineTo(0, 21.2635 * syPlayer) // V21.2635
        // Верхний левый угол
        ..cubicTo(
          0, 9.73658 * syPlayer, // C0 9.73658
          9.66565 * sx, 0.582053 * syPlayer, // 9.66565 0.582053
          21.1753 * sx, 1.2144 * syPlayer, // 21.1753 1.2144
        )
        // Левая часть пути к вырезу
        ..cubicTo(
          57.656 * sx, 3.21868 * syPlayer, // C57.656 3.21868
          133.621 * sx, 6.99998 * syPlayer, // 133.621 6.99998
          187.5 * sx, 6.99998 * syPlayer, // 187.5 6.99998
        )
        ..cubicTo(
          197.302 * sx, 6.99998 * syPlayer, // C197.302 6.99998
          207.834 * sx, 6.87484 * syPlayer, // 207.834 6.87484
          (218.727 + playerOffset) * sx, 6.65803 * syPlayer, // Сдвинуто правее
        )
        ..cubicTo(
          (226.451 + playerOffset) * sx, 6.50428 * syPlayer, // Сдвинуто правее
          (234 + playerOffset) * sx, 22.2739 * syPlayer, // Сдвинуто правее
          (234 + playerOffset) * sx, 30 * syPlayer, // Сдвинуто правее
        )
        // Замыкаем вырез - нижняя дуга выреза (слева) - поднято выше, сдвинуто правее
        ..cubicTo(
          (234 + playerOffset) * sx, 40 * syPlayer, // Сдвинуто правее
          (246.536 + playerOffset) * sx, 50 * syPlayer, // Сдвинуто правее
          (262 + playerOffset) * sx, 50 * syPlayer, // Сдвинуто правее (начало выреза - замкнуто)
        )
        ..close();

      return path;
    } else if (activeIndex == 4) {
      // Вырез для tasks (книга) - точный путь из предоставленного SVG
      const double tasksOffset = 2.0; // Сдвиг выреза вправо (соответствует сдвигу иконки)
      final double syNew = size.height / 73.0; // viewBox высота 63
      
      final path = Path()
        // Начинаем с нижней точки выреза (левая сторона) - точный путь из SVG
        // M338 59 - начало выреза
        ..moveTo((338 + tasksOffset) * sx, 59.0 * syNew)
        // Нижняя дуга выреза (справа)
        // C354.016 59 367 46.0163 367 30
        ..cubicTo(
          (354.016 + tasksOffset) * sx, 59.0 * syNew,
          (367 + tasksOffset) * sx, 46.0163 * syNew,
          (367 + tasksOffset) * sx, 30.0 * syNew,
        )
        // Левая сторона выреза - идет вверх
        // C367 19.5193 361.44 10.3372 353.109 5.24203
        ..cubicTo(
          (367 + tasksOffset) * sx, 19.5193 * syNew,
          (361.44 + tasksOffset) * sx, 10.3372 * syNew,
          (353.109 + tasksOffset) * sx, 5.24203 * syNew,
        )
        // C351.816 4.45114 352.311 1.29756 353.825 1.2144
        ..cubicTo(
          (351.816 + tasksOffset) * sx, 4.45114 * syNew,
          (352.311 + tasksOffset) * sx, 1.29756 * syNew,
          (353.825 + tasksOffset) * sx, 1.2144 * syNew,
        )
        // Верхний правый угол
        // C365.334 0.582054 375 9.73658 375 21.2635
        ..cubicTo(
          365.334 * sx, 0.582054 * syNew,
          375 * sx, 9.73658 * syNew,
          375 * sx, 21.2635 * syNew,
        )
        // Правый край вниз
        // V71
        ..lineTo(375 * sx, 71.0 * syNew)
        // Нижний правый угол
        // C375 75.4183 371.418 79 367 79
        ..cubicTo(
          375 * sx, 75.4183 * syNew,
          371.418 * sx, 79.0 * syNew,
          367 * sx, 79.0 * syNew,
        )
        // Нижний край до левого нижнего угла
        // H8
        ..lineTo(8 * sx, 79.0 * syNew)
        // Нижний левый угол
        // C3.58172 79 0 75.4183 0 71
        ..cubicTo(
          3.58172 * sx, 79.0 * syNew,
          0, 75.4183 * syNew,
          0, 71.0 * syNew,
        )
        // Левый край вверх
        // V21.2635
        ..lineTo(0, 21.2635 * syNew)
        // Верхний левый угол
        // C0 9.73658 9.66565 0.582053 21.1753 1.2144
        ..cubicTo(
          0, 9.73658 * syNew,
          9.66565 * sx, 0.582053 * syNew,
          21.1753 * sx, 1.2144 * syNew,
        )
        // Левая часть пути к вырезу
        // C57.656 3.21868 133.621 6.99998 187.5 6.99998
        ..cubicTo(
          57.656 * sx, 3.21868 * syNew,
          133.621 * sx, 6.99998 * syNew,
          187.5 * sx, 6.99998 * syNew,
        )
        // C219.096 6.99998 258.286 5.69965 292.656 4.21987
        ..cubicTo(
          219.096 * sx, 6.99998 * syNew,
          258.286 * sx, 5.69965 * syNew,
          292.656 * sx, 4.21987 * syNew,
        )
        // C298.492 3.96861 309 24.1587 309 30
        ..cubicTo(
          (298.492 + tasksOffset) * sx, 3.96861 * syNew,
          (309 + tasksOffset) * sx, 24.1587 * syNew,
          (309 + tasksOffset) * sx, 30.0 * syNew,
        )
        // Замыкаем вырез - нижняя дуга выреза (слева)
        // C309 46.0163 321.984 59 338 59
        ..cubicTo(
          (309 + tasksOffset) * sx, 46.0163 * syNew,
          (321.984 + tasksOffset) * sx, 59.0 * syNew,
          (338 + tasksOffset) * sx, 59.0 * syNew,
        )
        ..close();

      return path;
    }

    // Для других вкладок используем стандартный путь
    return _buildDynamicPath(size);
  }

  @override
  bool shouldReclip(covariant _HarmonyBottomClipper oldClipper) =>
      oldClipper.activeTab != activeTab || oldClipper.mode != mode;
}


