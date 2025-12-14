import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/app_theme_mode.dart';
import '../../di/injection_container.dart';
import '../../domain/usecases/theme/get_theme_mode_usecase.dart';
import '../../domain/usecases/theme/save_theme_mode_usecase.dart';

final getThemeModeUseCaseProvider = Provider<GetThemeModeUseCase>(
  (ref) => getIt<GetThemeModeUseCase>(),
);

final saveThemeModeUseCaseProvider = Provider<SaveThemeModeUseCase>(
  (ref) => getIt<SaveThemeModeUseCase>(),
);

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SaveThemeModeUseCase _saveThemeModeUseCase;

  ThemeNotifier({
    required GetThemeModeUseCase getThemeModeUseCase,
    required SaveThemeModeUseCase saveThemeModeUseCase,
  })  : _getThemeModeUseCase = getThemeModeUseCase,
        _saveThemeModeUseCase = saveThemeModeUseCase,
        super(AppThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    state = await _getThemeModeUseCase.execute();
  }

  Future<void> setTheme(AppThemeMode themeMode) async {
    await _saveThemeModeUseCase.execute(themeMode);
    state = themeMode;
  }
}

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier(
    getThemeModeUseCase: ref.watch(getThemeModeUseCaseProvider),
    saveThemeModeUseCase: ref.watch(saveThemeModeUseCaseProvider),
  );
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final appThemeMode = ref.watch(themeNotifierProvider);

  switch (appThemeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
});
