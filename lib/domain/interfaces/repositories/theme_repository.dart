import '../../../core/models/app_theme_mode.dart';

abstract class ThemeRepository {
  Future<AppThemeMode> getThemeMode();

  Future<void> saveThemeMode(AppThemeMode themeMode);

  Future<void> clearThemeMode();
}
