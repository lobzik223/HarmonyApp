import 'package:flutter/material.dart';

// Функция для создания route без анимации
PageRoute<T> noAnimationRoute<T extends Object>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

