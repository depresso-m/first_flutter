import 'package:flutter/material.dart';

import 'app_state.dart';

class AppStateWidget extends InheritedWidget {
  final AppState state;

  const AppStateWidget({super.key, required this.state, required super.child});

  static AppState of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AppStateWidget>();
    if (widget == null) {
      throw Exception('AppStateWidget not found in widget tree');
    }
    return widget.state;
  }

  static AppState? maybeOf(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AppStateWidget>();
    return widget?.state;
  }

  @override
  bool updateShouldNotify(AppStateWidget oldWidget) {
    return state != oldWidget.state;
  }
}
