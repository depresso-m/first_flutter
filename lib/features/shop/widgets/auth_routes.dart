import 'package:flutter/material.dart';

Route<T> authSlideRoute<T>({required Widget page, bool reverse = false}) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final tween = Tween<Offset>(
        begin: Offset(reverse ? -1 : 1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
